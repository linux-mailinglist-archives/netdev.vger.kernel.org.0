Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8FD6A8BA9
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 23:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjCBWV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 17:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCBWV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 17:21:57 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56364C6CF
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 14:21:47 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id d7so929674qtr.12
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 14:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677795707;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m9QHIe9WJEW1cyKpTmtCEmUjIUycq4v3MWXN0pOHlgs=;
        b=liJv8sQwFhnsYgJmu2MdDvv8p5Qk/jer48BWr8iPqfR60wSyeEga/MRMhHhu95XZAx
         /xg1zRsgRyrD30BO+2B8Oy25MS7OU4MZCxOWfQMTGjuhM+EeGC0nVTXSuOUC3xW/hfh8
         QsRKtkzr1XlmoN20TOT6LOLkRhzJDCQroJXFSBkTt1NgnnLZcdHDDEeBW03t8aGWWLq+
         bCXCYns/lX15hyXOLSWASEwKKluVOzrTbDApo+RJK7DgkuNBCVyFCsrJdCTXHjleiLoU
         ebS28VWqK/SBXxmHMrQ0tMXZTAlzSSo0iOnAsYE9h8jk3Bla6t87o4wJR5ZiKryDGNEh
         pbEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677795707;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m9QHIe9WJEW1cyKpTmtCEmUjIUycq4v3MWXN0pOHlgs=;
        b=0YFrY0msqYXbZo0OYtsmOtnGblroidA1E6BgfQtaYWI53vFV/Pi2P5Xh/EgiVAT8Yu
         8H2Wdw9sUy5RCwe6BunWIXRr/y/4ZRLBVir71JvLud2fLfLzzDqSfn8kpW//+k5xBNk9
         wsPqRtJ72VWlSOtAahJGgyRzypSV6HI9FfcTGp0XRtKepScBe3YZHOZFglLQ1r+B7NSm
         Iua4yYNVJC5de39ULcmsiRnxVh7yA4HaZu2HUBaouRqz9U8NmENbWX6NUm9y4FnT3w8L
         Xc7LxoDpMnqIWYGLdQb7JasejFaXylQ24vsuC9ywy/B/fSUwDSO0B4bLKyar0NXmcnhd
         T5oQ==
X-Gm-Message-State: AO0yUKXUAviPrEDms10zv5mGa9vbcGVS6v4/uZ5BlWvayCzMIyrH5HzB
        NTQd+MqjivIa1pWoVpTDn2k3mLMn/vk=
X-Google-Smtp-Source: AK7set9I3Ii6Hx18/15G8JlstQwNAQw0iTNq8g8ULVhfr1+vRE7YwHlr9CKLus5iQEImxIaQBM/Cag==
X-Received: by 2002:a05:6a20:7da6:b0:cd:fc47:dd74 with SMTP id v38-20020a056a207da600b000cdfc47dd74mr10155922pzj.4.1677792487557;
        Thu, 02 Mar 2023 13:28:07 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id l30-20020a635b5e000000b004ff6b744248sm126074pgm.48.2023.03.02.13.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 13:28:07 -0800 (PST)
Date:   Thu, 2 Mar 2023 13:28:04 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <ZAEU5BQQQHhvcW5P@hoboy.vegasvil.org>
References: <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
 <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
 <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
 <20230228142648.408f26c4@kernel.org>
 <Y/6Cxf6EAAg22GOL@shell.armlinux.org.uk>
 <20230228145911.2df60a9f@kernel.org>
 <20230301170408.0cc0519d@kmaincent-XPS-13-7390>
 <ZAAn1deCtR0BoVAm@hoboy.vegasvil.org>
 <ZACNRjCojuK6tcnl@shell.armlinux.org.uk>
 <20230302084932.4e242f71@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302084932.4e242f71@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 08:49:32AM -0800, Jakub Kicinski wrote:

> Don't wanna waste too much of your time with the questions since
> I haven't done much research but - wouldn't MAC timestamp be a better
> choice more often (as long as it's a real, to-spec PTP stamp)? 
> Are we picking PHY for historical reasons?

I think the default rating for MACs can be higher, but in the case of
at least one PHY, the TI PHYTER (dp83640), the PHY is the far better
choice.  This PHY surpasses any MAC on the market, and so it should
have a high rating.

For example, I've seen boards with the TI am335x, initially selected
because of the built in CPTS PTP feature, which the designers were
forced augment with the PHYTERs simply because of inadequate SoC
implementation.

In other words, if you find a board with the PHYTER, then it is there
for a reason.

Thanks,
Richard
