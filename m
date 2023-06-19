Return-Path: <netdev+bounces-11859-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3234A734E90
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:50:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6980B2810E0
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E062BA43;
	Mon, 19 Jun 2023 08:50:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D8CBE45
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:50:22 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71981B4;
	Mon, 19 Jun 2023 01:50:05 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-6668b13c7daso1002959b3a.1;
        Mon, 19 Jun 2023 01:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687164605; x=1689756605;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dX39+CU4/5ysVNF0CJKPL8tEIKfEU4/6ptS92TtYaX4=;
        b=mnDveZCTFK9TMCYyl5PfZUF+C560poHcX5m+5IU2+TxXKYyymKG0gXvQmyKACX7bER
         vNqrRKT7P2zcQ3GlU6Yf6+j9ipccdmWuG8wgqIle74sXVTLOY0laZBUhQCcYDiI0Sb/6
         AYw1eb+Wk9upCJ8h4QJrJW7e40pJWd71AEL03DhGGJnd3xuCXlraPT3pvIzfRyPZaa4q
         sMRrAuHv4pATcWIJvqYORuF//IwS/mhmf36AC4hT5UihdrTZqda+Vd7ZqkXnLzN5tIRa
         IZukMUqay8PZDM5TdTdXlxdr6ZG4c0gK/6IsMHjQ3ClMk7ukuMW3kieQXSviRNk2M1U8
         XBzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687164605; x=1689756605;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dX39+CU4/5ysVNF0CJKPL8tEIKfEU4/6ptS92TtYaX4=;
        b=lKmQoFHB0N6V8MVhANKCMvgve0/IfOD6skjc5WQWm5UG2itstXmVEJkGHdlwh1FDcG
         lnmuj2Ns8vchInB/weh7a41A7E/I9YnjWUTBhCeldpjEjRUw/tofSg1SFmCyb+bapxpU
         3iP1FAhKPfKLNKX5P9p/8NRm8RV9pZaHDIHScQxDzP8V0nmx4QvNFJX2BPzI3zuvOezH
         VQI23Plzul0WMVBaIQU9J8VjZnkGY4Ss9t984VOJWxK8aU7/XXq4y5dXEhm9IeE4mUZC
         Egr2O7fEXzlXz5eX2Rsn2uwsbMzGSZOW/tzERnr12BKTEltmMqsO9SUvfu52lNJOUCkH
         jL9Q==
X-Gm-Message-State: AC+VfDx9Ox80v4LahDw4boIigd6XUbqg2ZdPAu8e7snRZvUI8Ip6f2Jg
	+0nBeLw8gqLVmqiIM3s8Gtg=
X-Google-Smtp-Source: ACHHUZ5y/SFB8Chp3NOXvZe01fLhPfztc5niTNZEV+vka1rlmFTXw8P0fP35NbM+i07k3BpIgErQRw==
X-Received: by 2002:a05:6a00:1d95:b0:666:efc7:2463 with SMTP id z21-20020a056a001d9500b00666efc72463mr7533007pfw.2.1687164605056;
        Mon, 19 Jun 2023 01:50:05 -0700 (PDT)
Received: from localhost (ec2-54-68-170-188.us-west-2.compute.amazonaws.com. [54.68.170.188])
        by smtp.gmail.com with ESMTPSA id q18-20020a62e112000000b0064ccfb73cb8sm2000796pfh.46.2023.06.19.01.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 01:50:03 -0700 (PDT)
Date: Mon, 19 Jun 2023 17:50:03 +0900 (JST)
Message-Id: <20230619.175003.876496330266041709.ubuntu@gmail.com>
To: alice@ryhl.io
Cc: andrew@lunn.ch, kuba@kernel.org, fujita.tomonori@gmail.com,
 netdev@vger.kernel.org, rust-for-linux@vger.kernel.org,
 aliceryhl@google.com, miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
From: FUJITA Tomonori <fujita.tomonori@gmail.com>
In-Reply-To: <c1b23f21-d161-6241-26fb-7a2cbc4c059c@ryhl.io>
References: <053cb4c3-aab1-23b3-56e3-4f1741e69404@ryhl.io>
	<7dbf3c85-02ca-4c9b-b40d-adcdb85305dd@lunn.ch>
	<c1b23f21-d161-6241-26fb-7a2cbc4c059c@ryhl.io>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

On Sat, 17 Jun 2023 12:08:26 +0200
Alice Ryhl <alice@ryhl.io> wrote:

> On 6/16/23 22:04, Andrew Lunn wrote:
>>> Yes, you can certainly put a WARN_ON in the destructor.
>>>
>>> Another possibility is to use a scope to clean up. I don't know
>>> anything
>>> about these skb objects are used, but you could have the user define a
>>> "process this socket" function that you pass a pointer to the skb,
>>> then make
>>> the return value be something that explains what should be done with
>>> the
>>> packet. Since you must return a value of the right type, this forces
>>> you to
>>> choose.
>>>
>>> Of course, this requires that the processing of packets can be
>>> expressed as
>>> a function call, where it only inspects the packet for the duration of
>>> that
>>> function call. (Lifetimes can ensure that the skb pointer does not
>>> escape
>>> the function.)
>>>
>>> Would something like that work?
>> I don't think so, at least not in the contest of an Rust Ethernet
>> driver.
>> There are two main flows.
>> A packet is received. An skb is allocated and the received packet is
>> placed into the skb. The Ethernet driver then hands the packet over to
>> the network stack. The network stack is free to do whatever it wants
>> with the packet. Things can go wrong within the driver, so at times it
>> needs to free the skb rather than pass it to the network stack, which
>> would be a drop.
>> The second flow is that the network stack has a packet it wants sent
>> out an Ethernet port, in the form of an skb. The skb gets passed to
>> the Ethernet driver. The driver will do whatever it needs to do to
>> pass the contents of the skb to the hardware. Once the hardware has
>> it, the driver frees the skb. Again, things can go wrong and it needs
>> to free the skb without sending it, which is a drop.
>> So the lifetime is not a simple function call.
>> The drop reason indicates why the packet was dropped. It should give
>> some indication of what problem occurred which caused the drop. So
>> ideally we don't want an anonymous drop. The C code does not enforce
>> that, but it would be nice if the rust wrapper to dispose of an skb
>> did enforce it.
> 
> It sounds like a destructor with WARN_ON is the best approach right
> now.

Better to simply BUG()? We want to make sure that a device driver
explicity calls a function that consumes a skb object (on tx path,
e.g., napi_consume_skb()). If a device driver doesn't call such, it's
a bug that should be found easily and fixed during the development. It
would be even better if the compiler could find such though.

If Rust bindings for netdev could help device developpers in such way,
it's worth an experiments? because looks like netdev subsystem accepts
more drivers for new hardware than other subsystems.

thanks,

