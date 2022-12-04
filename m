Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C6A641E8C
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 19:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiLDSE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 13:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiLDSEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 13:04:25 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7C7DECF;
        Sun,  4 Dec 2022 10:04:24 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id n20so22930486ejh.0;
        Sun, 04 Dec 2022 10:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bu3XWy6tub93+8T28fZ7KSUsVBshY587isxVpnn55EE=;
        b=UtKQZXi7Ap5M4KANnUEzQMSXEXuyj+u8ba+yNcErwnODuM8Mr20LjlrNNnquWwQ6z0
         ZRehkxNUu1iuI+wStiLwIgHTQuM7hCNADYqTPBR0avWh8bzboydHYHzLR+UFjUXyuqYp
         GkVaAymjVTefP0NRgRblHBA1S7fEduITNLesYmUne0/etUtnp3S6Guj/GFdFWitCGE7g
         0UzIl0Y1tuHYhczDq2Ow7L5nPr07CrrkTkUiNBtshF1PNTR5PqwScRsckjoPmZOIkfBE
         09PD0t/ccPNDLF+/wvcFgPmzIQDw8nNArb/QjFLRYdYeP9YmVighEvWxplbtQwB6QISp
         CaEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bu3XWy6tub93+8T28fZ7KSUsVBshY587isxVpnn55EE=;
        b=bklDs3RODF6nuaNFNS5qFHtw0wROmbi05Be4I5z0bKbH2QsOZ5yFYo8NIniE/zIqfM
         RhAdWA8J3Eo/lM0T+kyKI+/yAcbbhpe7ci58a0uyWVTTMT9+UEq2oUZ1QMYhc0hVmv7w
         2oLFWGBxiPLLISss2nSyhDZWXKMZAGyX0JF08tdUaFLetG23E/mQ2uorwZslsgzEncnq
         Fv4qTw8lFUogugH3xSiAuxyAYMfKFH47qw3etzb9gHGJUrS381iKZe+K/9T0WOCRZy8h
         SuxvTzeBAFxp/z1jjWz9YQHQJbPY99JgOsCPbgs2y7C9x0+dhmBvP/9WBHQ36VeHh2J8
         JHdA==
X-Gm-Message-State: ANoB5pnuWjJ/3eIxFzkDiaQHsNSuILxEJ3BuhOvyoMmWo0LV92AMh7nF
        fuNOFY+pbna3QXzMZP/pNeY=
X-Google-Smtp-Source: AA0mqf7L2Yg49E7u1rwzidOIgrO9fy1zgNHiWQhYCZ8hCS5nrHUwv2yYhccJdXh6QcB0yewOnPzlIQ==
X-Received: by 2002:a17:906:a1d6:b0:7c0:b284:13f6 with SMTP id bx22-20020a170906a1d600b007c0b28413f6mr13563772ejb.149.1670177063521;
        Sun, 04 Dec 2022 10:04:23 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id w22-20020a1709060a1600b007c07dfb0816sm5340303ejf.215.2022.12.04.10.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 10:04:23 -0800 (PST)
Date:   Sun, 4 Dec 2022 19:04:31 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 2/4] phylib: Add support for 10BASE-T1S link
 modes and PLCA config
Message-ID: <Y4zhL3AWfIx5pBoy@gvm01>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <b2fffe32ffb0f6a6b4547e2e115bfad6c1139f70.1670119328.git.piergiorgio.beruto@gmail.com>
 <Y4zOok/KQPATE8+/@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4zOok/KQPATE8+/@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 04:45:22PM +0000, Russell King (Oracle) wrote:
> Hi,
> 
> On Sun, Dec 04, 2022 at 03:30:52AM +0100, Piergiorgio Beruto wrote:
> > diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> > index 5d08c627a516..5d8085fffffc 100644
> > --- a/drivers/net/phy/phy-core.c
> > +++ b/drivers/net/phy/phy-core.c
> > @@ -13,7 +13,7 @@
> >   */
> >  const char *phy_speed_to_str(int speed)
> >  {
> > -	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 99,
> > +	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 102,
> >  		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
> >  		"If a speed or mode has been added please update phy_speed_to_str "
> >  		"and the PHY settings array.\n");
> 
> I think you need to update settings[] in this file as well.
Oh, sure. I've just added the following:

	PHY_SETTING(     10, FULL,     10baseT1S_Full		),
	PHY_SETTING(     10, HALF,     10baseT1S_Half		),
	PHY_SETTING(     10, HALF,     10baseT1S_P2MP_Half	),

I will amend the patch after I reviewed all the feedback.

Thanks,
Piergiorgio
