Return-Path: <netdev+bounces-6438-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC22F716471
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6750A2811DF
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86AA118012;
	Tue, 30 May 2023 14:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9C617FE4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:40:21 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB66AF9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:40:18 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f623adec61so47716405e9.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685457617; x=1688049617;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qL9GyciTC/kDMAYy+oAPInWZVHejB3sQdm/6/+QY5xY=;
        b=VfZ/j24OU445Uk6UmPb2tu3xKCMAXmqFBBx/zqeFcPrto9XH+VEl1VeJUVdoZ16iLu
         mXWuTvjeVKmse/BUFataQVhxBxPkAh5i0Q9V5bunbwRgnTo0O+/1fYS9Vt5feU3SfwE0
         LzLVVf0Z2ytg7TSPhqsZo+DLxd1RIbt/IZAtHEXm+qhgFSDNPc9ez3jsOD8WvquQJvqI
         oiVy8dIrAsfdKRl6lt7F+jEtXLPMbZEbVcrNWtU5ekAoEPfps4Noce1ElnC3kdhC/NZM
         Lpoufi2AwJfzl8hKQJncGCv0D5CVfA8xJRcGYG/bRC0A3wUhtnxbIOObz4ZqECc3r46s
         muKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685457617; x=1688049617;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qL9GyciTC/kDMAYy+oAPInWZVHejB3sQdm/6/+QY5xY=;
        b=WuAdGwL3oQF0xq7oszUt6Rkw3XO1XTZmM7Z+V/KwlIxu7vu4CEFnj6E4r6dy74iWO7
         tEW84H2AAOrN0Z7CI2REvl5L0E/+XLcFGmDVGoAYayXBK5Bj4gbRaTfvwKNRM6Iy/RVr
         aZLbaxzVc6yqnLWLG6SYwiYMV6crBrx1PEJDzGO2H35Bs9d9IsKysvy2J8MAlOcohhuh
         V/PhojeNnzCWRVoJGMijO5Wvcx23ZCkZZ0KdYts54dVOySRQMliVVRI6tvqCeilGINKR
         PaO+lFA0uMdt8ATAiqBFUpbASRIY/oEEnTDyD41ruDVcLJrjJrCzRmI0jnduLd3iDXVT
         4kFA==
X-Gm-Message-State: AC+VfDwpg6bkJiFiNixzmAGOX78FMcUWiMuko7eN9KNOmuGKIBK1cSYo
	KWhtJ6w4fCvmWoDohx+xF5ztjQ==
X-Google-Smtp-Source: ACHHUZ5qf+rZSdsbJ+5YXF2H2nZ0Bg0WhxwG6fHwBrEgYJR1mgnZ99rVJhd9NU5Mb9+Q7eZgm0+CTg==
X-Received: by 2002:a7b:c3d4:0:b0:3f4:21ff:b91f with SMTP id t20-20020a7bc3d4000000b003f421ffb91fmr1803557wmj.28.1685457617136;
        Tue, 30 May 2023 07:40:17 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id c21-20020a7bc855000000b003f1958eeadcsm21067878wml.17.2023.05.30.07.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 07:40:14 -0700 (PDT)
Date: Tue, 30 May 2023 17:40:11 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Jakub Kicinski <kuba@kernel.org>, Russell King <linux@armlinux.org.uk>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: phy: fix a signedness bug in genphy_loopback()
Message-ID: <fb553ce5-c533-44a2-a134-fbb552f247bb@kili.mountain>
References: <d7bb312e-2428-45f6-b9b3-59ba544e8b94@kili.mountain>
 <20230529215802.70710036@kernel.org>
 <90b1107b-7ea0-4d8f-ad88-ec14fd149582@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90b1107b-7ea0-4d8f-ad88-ec14fd149582@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 02:39:53PM +0200, Andrew Lunn wrote:
> On Mon, May 29, 2023 at 09:58:02PM -0700, Jakub Kicinski wrote:
> > On Fri, 26 May 2023 14:45:54 +0300 Dan Carpenter wrote:
> > > The "val" variable is used to store error codes from phy_read() so
> > > it needs to be signed for the error handling to work as expected.
> > > 
> > > Fixes: 014068dcb5b1 ("net: phy: genphy_loopback: add link speed configuration")
> > > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> > 
> > Is it going to be obvious to PHY-savvy folks that the val passed to
> > phy_read_poll_timeout() must be an int? Is it a very common pattern?
> > My outsider intuition is that since regs are 16b, u16 is reasonable,
> > and more people may make the same mistake.
> 
> It is common to get this wrong in general with PHY drivers. Dan
> regularly posts fixes like this soon after a PHY driver patch it
> merged. I really wish we could somehow get the compiler to warn when
> the result from phy_read() is stored into a unsigned type. It would
> save Dan a lot of work.

I don't see these as much as I used.  It's maybe once per month.  I'm
not sure why, maybe kbuild emails everyone before I see it?  GCC will
warn about this with -Wtype-limits.  Clang will also trigger a warning.

The Smatch check for this had a bug where it only warned about if
(x < 0) { if x was u32 or larger.  I fixed that bug which is why I was
looking at this code.  I will push the fix for that in a couple days.

regards,
dan carpenter


