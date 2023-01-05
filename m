Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E523565E94C
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 11:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbjAEKtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 05:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbjAEKtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 05:49:33 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA2854718;
        Thu,  5 Jan 2023 02:49:32 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id c17so52244003edj.13;
        Thu, 05 Jan 2023 02:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0filXF68FHJ6ZWCVzi7qhWK2rOtyQx7FNriFJV/pCmM=;
        b=L7CVuu1Uek/knGn2cPZ7ZWzk4OcXFXAL3vJPv9mC8MNf/UCjFkS4MhXJLYysguWF8i
         NA24GyVkXSWgHd1DPR8JyHMae1Q2zPZA5sEKdQT19JoSYQYpImvAwmPwvo8wLNdaiLo4
         mJNFH5GGtWY0V0r++CcT3fJhWSl0YlRTZWS9fXREygDa1RM6yIq2H1OwGZ7KoScB+EDz
         BpsXZxni+3IV78YiQPwupW+TL0ZYMbhANpX0n1QHOWvYJA8LLts0pERM44bGR1k5Aj0Y
         RkArTdFNNSnJM2z7EKjuj62A28xnHJU68h/5jSQI2jKspRiwdRFgdey/mdgMKg6tCvcH
         wH7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0filXF68FHJ6ZWCVzi7qhWK2rOtyQx7FNriFJV/pCmM=;
        b=BZmZUQ1HiXoouxycUnPdPTMbbZuQ/XLnCDRbrk+CRvxuu/zzGXvtBVVWvGLJ2Cr2Lx
         WOsXawRAMsCJQ53MDzGOtVg/JukxfKBF+9vo6XJlYqxz5Utxd3BFVVMFV0zJ5aUzXBgv
         DN9zftsdNs/5kHU210E4SuN2RrzchN/4A0Tm/JhHN16gY2uTrV2XmZjPHPQ5Ez/7F/pz
         iXTqSJmBc8AoQ1L8iQ5jvaixU/AOquJfJDjQzIErYmCp3I7Wr9Y/bXIDSfvxp0oyDX7Z
         tZEsILqWnuwCMb8RiKGbwwTh1B5xaY1atkxY0xybQsH8cz1cZYN7zkyRsAzcnkpj4o55
         bUdg==
X-Gm-Message-State: AFqh2kp7tlo54joQCP+2cFikNQ6Pa/calKxgqzBrmYPLnc8ReLre3CCC
        lhUk6gEAJB4bgVwQxZnHbfY=
X-Google-Smtp-Source: AMrXdXs2Z3EUhO27Z52EYVwbT1R05Xs/dwWHSukv4yK77+ao6OWJFUODaPSh9xZyDdQh/Mcy8xhvmA==
X-Received: by 2002:a05:6402:3706:b0:472:9af1:163f with SMTP id ek6-20020a056402370600b004729af1163fmr45200378edb.37.1672915770861;
        Thu, 05 Jan 2023 02:49:30 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id p14-20020a05640210ce00b0047025bf942bsm15744880edu.16.2023.01.05.02.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 02:49:30 -0800 (PST)
Date:   Thu, 5 Jan 2023 11:49:36 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 5/5] drivers/net/phy: add driver for the onsemi
 NCN26000 10BASE-T1S PHY
Message-ID: <Y7arQLi9ELyvXViZ@gvm01>
References: <cover.1672840325.git.piergiorgio.beruto@gmail.com>
 <d6ffe9c0296bc10c51068d3efaadd48e05561208.1672840326.git.piergiorgio.beruto@gmail.com>
 <Y7aS7GrjFDauGm9u@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7aS7GrjFDauGm9u@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 11:05:48AM +0200, Leon Romanovsky wrote:
> On Wed, Jan 04, 2023 at 03:07:05PM +0100, Piergiorgio Beruto wrote:
> > This patch adds support for the onsemi NCN26000 10BASE-T1S industrial
> > Ethernet PHY. The driver supports Point-to-Multipoint operation without
> > auto-negotiation and with link control handling. The PHY also features
> > PLCA for improving performance in P2MP mode.
> > 
> > Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> > ---
> >  MAINTAINERS                |   7 ++
> >  drivers/net/phy/Kconfig    |   7 ++
> >  drivers/net/phy/Makefile   |   1 +
> >  drivers/net/phy/ncn26000.c | 171 +++++++++++++++++++++++++++++++++++++
> >  4 files changed, 186 insertions(+)
> >  create mode 100644 drivers/net/phy/ncn26000.c
> 
> <...>
> 
> > +static int ncn26000_config_aneg(struct phy_device *phydev)
> > +{
> > +	// Note: the NCN26000 supports only P2MP link mode. Therefore, AN is not
> > +	// supported. However, this function is invoked by phylib to enable the
> > +	// PHY, regardless of the AN support.
> 
> Please use C-style comments for multi lines blocks.
Fixed.
> 
> > +	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
> > +	phydev->mdix = ETH_TP_MDI;
> > +
> > +	// bring up the link
> 
> Thanks
