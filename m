Return-Path: <netdev+bounces-11279-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D1C27325FA
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:47:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BF251C20F0A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 03:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8855C7F3;
	Fri, 16 Jun 2023 03:47:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788D8648
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 03:47:47 +0000 (UTC)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EFC269D;
	Thu, 15 Jun 2023 20:47:46 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b3c5631476so559105ad.1;
        Thu, 15 Jun 2023 20:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686887265; x=1689479265;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8GyQ85VgE5HFZ0QoRvTjedg0ikS7YWehL0KdgFuB0I4=;
        b=DyQuM9eq/fT3r6JXe65o6F4iYy4txn1JUBibM4Ls+oGYEfhmA8ZDuUQ9dVL4eQtX3f
         +OvnpYaIif7rhYStQoCQroDsvpgzlgT0z9CRnAC834S/4SX02w+QugWZDIu5aSQIRHYf
         qPwJ8zEi0SXsIGJ+01v2GD2YOSQVWHFYtlVudTTle2F/sgUPEmdOMWJhQvvaXAP8R1Eq
         sPbcbSBd01nKhRakY9RGem4EnhB6Zyy0P1RmpF/wlPCgx++hsTW7dRBZnEjwNhb2X+bl
         pfTFFncJA4N2LTkKRe5PUrAedpu7ZQ8UfVDta1sNLuZH6F+MjbyEpD1gFWo7st/QnQ8q
         5CQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686887265; x=1689479265;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8GyQ85VgE5HFZ0QoRvTjedg0ikS7YWehL0KdgFuB0I4=;
        b=WDJtaO038pD25TClCGU8Xjn/j8XtLM9YFnpb9fU45Tf1gSlPicdpJ1iUlScOPKqHZS
         w8THU41mqhjSqg17PHWNRWQ1IQ07K4x1IRkwfswylzZ2cLu4KDTeqk7RaOAYhU6DLTFw
         LYh4lXw+b+UnORRKeSsZkuokRj9RZAIQljiw3ldfkpuU2JVW8P9LLKq4jcuhOlmVc22q
         iceUlx7jqTSH0ELh+jQj6c1UPE5Vp+YDMVoKVU2UZFs6txdjvaNrtabDFy4d7GCys3Oc
         Ja1QW8TYyTfjl1YL9r9drxIaOSmlOX12bZAc1JENuWdPDbcY3PER1tjU2T0AInLpNfQ5
         kQ3A==
X-Gm-Message-State: AC+VfDzbCba5oAlv9Kcb8wt6bqFhIsFs4CH/zUYQz+uUlb+2x9GBqSQw
	cbEtl9iDr08WEeSJ3KywRwY=
X-Google-Smtp-Source: ACHHUZ7B1nIw/BMdoGiOyxY/b5GiViNkkWLh1bTN/tjPjRux8dVj4z2dP6dXP9uIlV/qH1Dvo1h+aA==
X-Received: by 2002:a17:903:2451:b0:1b0:34c6:3bf2 with SMTP id l17-20020a170903245100b001b034c63bf2mr989715pls.5.1686887265439;
        Thu, 15 Jun 2023 20:47:45 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id io21-20020a17090312d500b001a5fccab02dsm14736225plb.177.2023.06.15.20.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 20:47:44 -0700 (PDT)
Date: Thu, 15 Jun 2023 20:47:43 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>, netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org, aliceryhl@google.com,
	miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
Message-ID: <ZIvbX+edJo3Rh9W6@hoboy.vegasvil.org>
References: <20230613045326.3938283-1-fujita.tomonori@gmail.com>
 <20230614230128.199724bd@kernel.org>
 <8e9e2908-c0da-49ec-86ef-b20fb3bd71c3@lunn.ch>
 <20230615190252.4e010230@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615190252.4e010230@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 07:02:52PM -0700, Jakub Kicinski wrote:

> IMO we have too much useless playground stuff in C already, don't get me
> started. Let's get a real device prove that this thing can actually work
> :( We can waste years implementing imaginary device drivers that nobody
> ends up using.

Yes, the long standing policy seems to be not to merge "dummy"
drivers.  The original PTP patch set had one, but at the time the
reviews said firmly "No" to that.

Thanks,
Richard



