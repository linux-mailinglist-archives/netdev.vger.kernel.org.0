Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96551641F66
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 21:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiLDUJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 15:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiLDUJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 15:09:42 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E2CFAE0;
        Sun,  4 Dec 2022 12:09:41 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id d14so8239641edj.11;
        Sun, 04 Dec 2022 12:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ip6SZHWMV81bUwLtmFCqaYGVJyCpz3wK7ABNoO5l8hU=;
        b=DB0o1Y1AP5IPXjGZUM4ebWXQ8m+/uRIu8MYIv1boN9JXsOpAaWfLdCI0Lde8whzFgC
         a2MDput7ujZP4TB7ikv1aNFZobVROY8Kscm/LVqLpH5zdyhzbk4t0hDkXYwuU7bPE3+2
         7gFIvOWb3dl7pb8BKLLr9SeidAqbqwW5E4x0KFeMiG+nHxA1m3p4uRaOnl6Vkp/7MLVT
         mGdn4Ph8WzFDbTnjZhbap8eGj699Q2ZHa0VAK5788S+/Ydi0ExhzvT4hGK8yV+HOlSSd
         O/9/XmOKUMgjtKIXmAjjlRofu4pgMNeSyUymEp6iLuucRlCaJiucjV277OSTbCGYnRq8
         nbnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ip6SZHWMV81bUwLtmFCqaYGVJyCpz3wK7ABNoO5l8hU=;
        b=ybtxrijngRAc8j7PRPsZuUWXKiBleHMf/tldjfqVgB8iMrASpDFtCx5sqHugPL1xhD
         a7vtUSpwAqtkK5aYF6te8cyd1HDEylzAoqdWlwcCgVNOolzYruuv97bvvHAO2qftI+2x
         yjV5Vtw7G0bIl1ll56AGCZBzxisERMzDO4RLPTo+OlLx+JcBr7X/mE+U8M7mvK2DFI+h
         FfgkrbJe1t6Z2zFbp3NGQZkhqnZidaLlcFOiG7KmNoJ7PI1oYJjWm5ZvnrmB0ihBNR+L
         idrRN4dY8Q/MewQQHbhLhK6ma4GLI7jm6ZZWQd4IPB9esTqJIBaUpJ55pshxqIhWu8aY
         TCnQ==
X-Gm-Message-State: ANoB5pmytAFkvZAg0m7/b9kQxlnvjCVbgJAmOpa1Jt+WTuD/fEfzWy9Q
        Ibb6/aQmnej7/+p520SXlNI=
X-Google-Smtp-Source: AA0mqf4+FyBafvMMq9Ng73XoU3tsiZYRsgZdJxwZAax3hjDxxacwwFYuMedPFJdhLUTMY+pH6fvMRg==
X-Received: by 2002:a05:6402:494:b0:46a:c9bc:ccd4 with SMTP id k20-20020a056402049400b0046ac9bcccd4mr38262070edv.200.1670184580345;
        Sun, 04 Dec 2022 12:09:40 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id x11-20020aa7d6cb000000b0045b4b67156fsm4353018edr.45.2022.12.04.12.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 12:09:39 -0800 (PST)
Date:   Sun, 4 Dec 2022 21:09:48 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 2/4] phylib: Add support for 10BASE-T1S link
 modes and PLCA config
Message-ID: <Y4z+jD0RStmryFhL@gvm01>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <b2fffe32ffb0f6a6b4547e2e115bfad6c1139f70.1670119328.git.piergiorgio.beruto@gmail.com>
 <Y4zi8ySOlmKP0kgg@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4zi8ySOlmKP0kgg@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 07:12:03PM +0100, Andrew Lunn wrote:
> On Sun, Dec 04, 2022 at 03:30:52AM +0100, Piergiorgio Beruto wrote:
> > This patch adds the required connection between netlink ethtool and
> > phylib to resolve PLCA get/set config and get status messages.
> > Additionally, it adds the link modes for the IEEE 802.3cg Clause 147
> > 10BASE-T1S Ethernet PHY.
> 
> Please break this patch up.
> 
> >  const char *phy_speed_to_str(int speed)
> >  {
> > -	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 99,
> > +	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 102,
> >  		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
> >  		"If a speed or mode has been added please update phy_speed_to_str "
> >  		"and the PHY settings array.\n");
> 
> > --- a/include/uapi/linux/ethtool.h
> > +++ b/include/uapi/linux/ethtool.h
> > @@ -1741,6 +1741,9 @@ enum ethtool_link_mode_bit_indices {
> >  	ETHTOOL_LINK_MODE_800000baseDR8_2_Full_BIT	 = 96,
> >  	ETHTOOL_LINK_MODE_800000baseSR8_Full_BIT	 = 97,
> >  	ETHTOOL_LINK_MODE_800000baseVR8_Full_BIT	 = 98,
> > +	ETHTOOL_LINK_MODE_10baseT1S_Full_BIT		 = 99,
> > +	ETHTOOL_LINK_MODE_10baseT1S_Half_BIT		 = 100,
> > +	ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT	 = 101,
> >  
> >  	/* must be last entry */
> >  	__ETHTOOL_LINK_MODE_MASK_NBITS
> > diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> > index 21cfe8557205..c586db0c5e68 100644
> > --- a/net/ethtool/common.c
> > +++ b/net/ethtool/common.c
> > @@ -208,6 +208,9 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
> >  	__DEFINE_LINK_MODE_NAME(800000, DR8_2, Full),
> >  	__DEFINE_LINK_MODE_NAME(800000, SR8, Full),
> >  	__DEFINE_LINK_MODE_NAME(800000, VR8, Full),
> > +	__DEFINE_LINK_MODE_NAME(10, T1S, Full),
> > +	__DEFINE_LINK_MODE_NAME(10, T1S, Half),
> > +	__DEFINE_LINK_MODE_NAME(10, T1S_P2MP, Half),
> >  };
> >  static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
> >  
> > @@ -366,6 +371,9 @@ const struct link_mode_info link_mode_params[] = {
> >  	__DEFINE_LINK_MODE_PARAMS(800000, DR8_2, Full),
> >  	__DEFINE_LINK_MODE_PARAMS(800000, SR8, Full),
> >  	__DEFINE_LINK_MODE_PARAMS(800000, VR8, Full),
> > +	__DEFINE_LINK_MODE_PARAMS(10, T1S, Full),
> > +	__DEFINE_LINK_MODE_PARAMS(10, T1S, Half),
> > +	__DEFINE_LINK_MODE_PARAMS(10, T1S_P2MP, Half),
> >  };
> >  static_assert(ARRAY_SIZE(link_mode_params) == __ETHTOOL_LINK_MODE_MASK_NBITS);
> 
> This is one logical change, so makes one patch, for example.
> 
> You are aiming for lots of simple, easy to review, well described,
> obviously correct patches.
Alright, will do.

Thanks,
Piergiorgio
