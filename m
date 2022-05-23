Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4373353169E
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239003AbiEWQlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238966AbiEWQlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:41:16 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FC918367
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:41:13 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id y13so29296887eje.2
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iUGGPEpEBvIWHgX5WmkSro+WwIlgJC8zd/HjCtR8Q4c=;
        b=H3XfY74DTshOhN9sVQxtYdLk3vb8+vVSWvfYXd8FmbjGu9PKT5P9hkqc6GDpTJRtpR
         AuayBey8pE3g+5B7/74w0rcBqxGaBNlDcXcJBD7UAoKASVPM1/xojk5Etdm4dJ38uEFH
         YH4Td6rXuPGroFATKKmQeZ9qdGzAiPNVCchLQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iUGGPEpEBvIWHgX5WmkSro+WwIlgJC8zd/HjCtR8Q4c=;
        b=sxlbH/Cph0fkSPAJiLEvNgeaLDesI6qjdmib58R2PIXtzuQM9zHSgq2aA5I3mMp5Gr
         tUswsvC0IowSTAgWWgULG6l+ik9kA1JsolCWwmRPcBrWNnaV8ls7LurKN4RKS+Rk9qYa
         aqtiJDBF/MTNn+dH/V/w46a7ucwFL2k+pOf75upeVl2QtnKgYwIGB+ycmMzyBJsBDEOo
         vXQJOQk3KsTA/sXtiMSQxiUBmFv9LuRW9bA1mdk2mJXLNVe35p6OhKyv2VdXsM6Ysf2V
         IhINpL++aYWE06g9EWaJm1cizJdfFcdzjDJZUBzRWRk6tYeGFwYXrsd4WvzqG1Lv0PEa
         w7Tg==
X-Gm-Message-State: AOAM533Kx3usY3rttfb9Doab3rRlC72g2ZXrvoPAJj0hr3QwCJoLXWc0
        0brIPy9owkU6SH25aBjTS7rNzQ==
X-Google-Smtp-Source: ABdhPJzUjwcf7OH53MGed2OB9aRdAWP195mx3cAjRfMxFGJesJ5BWL2DFnSYtmnPrZrVXDQiO+tRdA==
X-Received: by 2002:a17:907:3da1:b0:6fe:ae46:997d with SMTP id he33-20020a1709073da100b006feae46997dmr13878511ejc.633.1653324071808;
        Mon, 23 May 2022 09:41:11 -0700 (PDT)
Received: from tom-ThinkPad-T14s-Gen-2i (net-188-217-53-154.cust.vodafonedsl.it. [188.217.53.154])
        by smtp.gmail.com with ESMTPSA id d23-20020a50fe97000000b0042ac2b71078sm8380787edt.55.2022.05.23.09.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 09:41:11 -0700 (PDT)
Date:   Mon, 23 May 2022 18:41:08 +0200
From:   Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     michael@amarulasolutions.com, alberto.bianchi@amarulasolutions.com,
        linux-amarula@amarulasolutions.com, linuxfancy@googlegroups.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: phy: DP83822: enable rgmii mode if
 phy_interface_is_rgmii
Message-ID: <20220523164108.GA3635492@tom-ThinkPad-T14s-Gen-2i>
References: <20220520235846.1919954-1-tommaso.merciai@amarulasolutions.com>
 <YokxxlyFTJZ8c+5y@lunn.ch>
 <20220523065754.GJ1589864@tom-ThinkPad-T14s-Gen-2i>
 <Yot7OD8MAQPttmyV@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yot7OD8MAQPttmyV@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 02:16:56PM +0200, Andrew Lunn wrote:
> On Mon, May 23, 2022 at 08:57:54AM +0200, Tommaso Merciai wrote:
> > On Sat, May 21, 2022 at 08:39:02PM +0200, Andrew Lunn wrote:
> > > On Sat, May 21, 2022 at 01:58:46AM +0200, Tommaso Merciai wrote:
> > > > RGMII mode can be enable from dp83822 straps, and also writing bit 9
> > > > of register 0x17 - RMII and Status Register (RCSR).
> > > > When phy_interface_is_rgmii rgmii mode must be enabled, same for
> > > > contrary, this prevents malconfigurations of hw straps
> > > > 
> > > > References:
> > > >  - https://www.ti.com/lit/gpn/dp83822i p66
> > > > 
> > > > Signed-off-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
> > > > Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> > > > Suggested-by: Alberto Bianchi <alberto.bianchi@amarulasolutions.com>
> > > > Tested-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
> > > 
> > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > > 
> > > If you want to, you could go further. If bit 9 is clear, bit 5 defines
> > > the mode, either RMII or MII. There are interface modes defined for
> > > these, so you could get bit 5 as well.
> > 
> > Hi Andrew,
> > Thanks for the review and for your time.
> > I'll try to go further, like you suggest :)
> 
> Hi Tomaso
> 
> This patch has been accepted, so you will need to submit an
> incremental patch. I also expect net-next to close soon for the merge
> window, so you might want to wait two weeks before submitting.
> 
> 	Andrew


Hi Andrew,
Thanks for the info. I'll wait for the close of the merge window
then.

Regards,
Tommaso

-- 
Tommaso Merciai
Embedded Linux Engineer
tommaso.merciai@amarulasolutions.com
__________________________________

Amarula Solutions SRL
Via Le Canevare 30, 31100 Treviso, Veneto, IT
T. +39 042 243 5310
info@amarulasolutions.com
www.amarulasolutions.com
