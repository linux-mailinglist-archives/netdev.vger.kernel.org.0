Return-Path: <netdev+bounces-11932-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D4DA735573
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:06:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 547711C20833
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:06:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49537C123;
	Mon, 19 Jun 2023 11:06:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFB48C06
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:06:03 +0000 (UTC)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BFEF0;
	Mon, 19 Jun 2023 04:06:01 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b3ecb17721so6450195ad.0;
        Mon, 19 Jun 2023 04:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687172761; x=1689764761;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=61G8jKWmTPkE98T2o1ErPi8QnNgtzybIhkbIC792pRE=;
        b=TGwVHQZbLFN/ucLqPPINCORQKiHo1lWOFRnvIu9MGf+BIl6Ecw/621SDst8TqH2KFv
         WpaM4oOr4ZEJSJgvRPP4EsEiKgdXeGUZlF22wbBg+Qdgg/dcS0NTeyu5sMOueFt8FWZL
         M3EmjyJSO1e3pAWRTYVs7ZgZ3o4HF+x9sXy1uDBVD6+aUyuQwUhRJ1eNxbD6HkpVmXYS
         UG9dTgOU51qMn5Fi6NmGD8KjrMHcdcocWGiy69kioctkG7mPpykyBWZSOKYMLicvi3yl
         kvpDa2BpH+khGkuTia7E1fHDnVP0mHFPDskNorajZYApEzKCujLD1+HJJNBADe2zuhfs
         PGqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687172761; x=1689764761;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=61G8jKWmTPkE98T2o1ErPi8QnNgtzybIhkbIC792pRE=;
        b=j/GX6NtgbeHOxa+IerdLbmnx+U+H5WNPSsADuVT/k2Z0cJUj4G+It3akx+d8NULMuO
         t7HBUww9DmYZcDC4pxjOqWUAROC5X0o3LlIUGCyM+Zn9ajkc9KBcdK6BrnwqPJI7iJ54
         g/5S/1EJE33kBCrlxdw6jOzplDEOQOHGnKs24YJOCz2brMX+L3rLwHCRZdPyGPHZOEbU
         pH0MorCloRJnAKCoSeYZhtTdPEOlMxzDgN7lYjBDGaQkEBzXG+nGa/3M/j3BsgA02wfx
         EtusPhH9FF/0/jMZJf7KQLrKA4ZRJsptP2Xmvps0u9zsBrUFfrCxBJrFIj39EYQyctQ3
         +NqA==
X-Gm-Message-State: AC+VfDx0sqt1cbdUifr4f+b470ZTzGhW1q0GmDz6MBjJRuOp1L03yI9w
	0GrTxFcU2KV3/vt7mI1xw44=
X-Google-Smtp-Source: ACHHUZ4NQAr+tNVSrO5miNJuMGWzjLNBOJQVq5ePzAt1e8iwSQQDxqqQiWyPYGXvXe0+/oiFNDRNjQ==
X-Received: by 2002:a17:902:f688:b0:1ad:e3a8:3c4 with SMTP id l8-20020a170902f68800b001ade3a803c4mr11199748plg.4.1687172760556;
        Mon, 19 Jun 2023 04:06:00 -0700 (PDT)
Received: from localhost (ec2-54-68-170-188.us-west-2.compute.amazonaws.com. [54.68.170.188])
        by smtp.gmail.com with ESMTPSA id u3-20020a17090341c300b001aaecc15d66sm20227271ple.289.2023.06.19.04.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 04:06:00 -0700 (PDT)
Date: Mon, 19 Jun 2023 20:05:59 +0900 (JST)
Message-Id: <20230619.200559.1405325531450768221.ubuntu@gmail.com>
To: greg@kroah.com
Cc: fujita.tomonori@gmail.com, alice@ryhl.io, andrew@lunn.ch,
 kuba@kernel.org, netdev@vger.kernel.org, rust-for-linux@vger.kernel.org,
 aliceryhl@google.com, miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
From: FUJITA Tomonori <fujita.tomonori@gmail.com>
In-Reply-To: <2023061940-rotting-frequency-765f@gregkh>
References: <c1b23f21-d161-6241-26fb-7a2cbc4c059c@ryhl.io>
	<20230619.175003.876496330266041709.ubuntu@gmail.com>
	<2023061940-rotting-frequency-765f@gregkh>
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

On Mon, 19 Jun 2023 11:46:38 +0200
Greg KH <greg@kroah.com> wrote:

> On Mon, Jun 19, 2023 at 05:50:03PM +0900, FUJITA Tomonori wrote:
>> Hi,
>> 
>> On Sat, 17 Jun 2023 12:08:26 +0200
>> Alice Ryhl <alice@ryhl.io> wrote:
>> 
>> > On 6/16/23 22:04, Andrew Lunn wrote:
>> >>> Yes, you can certainly put a WARN_ON in the destructor.
>> >>>
>> >>> Another possibility is to use a scope to clean up. I don't know
>> >>> anything
>> >>> about these skb objects are used, but you could have the user define a
>> >>> "process this socket" function that you pass a pointer to the skb,
>> >>> then make
>> >>> the return value be something that explains what should be done with
>> >>> the
>> >>> packet. Since you must return a value of the right type, this forces
>> >>> you to
>> >>> choose.
>> >>>
>> >>> Of course, this requires that the processing of packets can be
>> >>> expressed as
>> >>> a function call, where it only inspects the packet for the duration of
>> >>> that
>> >>> function call. (Lifetimes can ensure that the skb pointer does not
>> >>> escape
>> >>> the function.)
>> >>>
>> >>> Would something like that work?
>> >> I don't think so, at least not in the contest of an Rust Ethernet
>> >> driver.
>> >> There are two main flows.
>> >> A packet is received. An skb is allocated and the received packet is
>> >> placed into the skb. The Ethernet driver then hands the packet over to
>> >> the network stack. The network stack is free to do whatever it wants
>> >> with the packet. Things can go wrong within the driver, so at times it
>> >> needs to free the skb rather than pass it to the network stack, which
>> >> would be a drop.
>> >> The second flow is that the network stack has a packet it wants sent
>> >> out an Ethernet port, in the form of an skb. The skb gets passed to
>> >> the Ethernet driver. The driver will do whatever it needs to do to
>> >> pass the contents of the skb to the hardware. Once the hardware has
>> >> it, the driver frees the skb. Again, things can go wrong and it needs
>> >> to free the skb without sending it, which is a drop.
>> >> So the lifetime is not a simple function call.
>> >> The drop reason indicates why the packet was dropped. It should give
>> >> some indication of what problem occurred which caused the drop. So
>> >> ideally we don't want an anonymous drop. The C code does not enforce
>> >> that, but it would be nice if the rust wrapper to dispose of an skb
>> >> did enforce it.
>> > 
>> > It sounds like a destructor with WARN_ON is the best approach right
>> > now.
>> 
>> Better to simply BUG()? We want to make sure that a device driver
>> explicity calls a function that consumes a skb object (on tx path,
>> e.g., napi_consume_skb()). If a device driver doesn't call such, it's
>> a bug that should be found easily and fixed during the development. It
>> would be even better if the compiler could find such though.
> 
> No, BUG() means "I have given up all hope here because the hardware is
> broken and beyond repair so the machine will now crash and take all of
> your data with it because I don't know how to properly recover".  That
> should NEVER happen in a device driver, as that's very presumptious of
> it, and means the driver itself is broken.
> 
> Report the error back up the chain and handle it properly, that's the
> correct thing to do.

I see. Then netdev_warn() should be used instead.

Is it possible to handle the case where a device driver wrongly
doesn't consume a skb object?


>> If Rust bindings for netdev could help device developpers in such way,
>> it's worth an experiments? because looks like netdev subsystem accepts
>> more drivers for new hardware than other subsystems.
> 
> Have you looked at the IIO subsystem?  :)

No, I've not. Are there possible drivers that Rust could be useful
for?

thanks,

