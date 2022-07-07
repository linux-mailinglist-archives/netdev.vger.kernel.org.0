Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D0956AE2B
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 00:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbiGGWPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 18:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236804AbiGGWPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 18:15:44 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D118C60518;
        Thu,  7 Jul 2022 15:15:40 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id l23so2968795ejr.5;
        Thu, 07 Jul 2022 15:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YbcTL+3qr14Rocr3oTmfsi882ixi5LpWV64cJlgqYcc=;
        b=nKKeKcLCsakCzn9XRzT0NpgzcCz7kp0YCUY2hhSmAHC8Orp4ossQP5D7uASZQKiTdj
         vRcW1AbOgc+uszyAoBDP1G/0vyQeEx3V6fhGWZA+L07P9A+s3ZvS3usUJztiStNHPj7D
         Ca0xp1rjC6vt2MFnDTc60V3IErNWN+A8pTAtuJDDFEJbHE9KbBfVLi9V27ILxxRVZ7yN
         e5/OexcdceNHe03xn8VzlKOoS9U00FrzMaKzdvq+UDqAWfaqIzI67EQEzIhCV548vHSq
         1haK57UQ98sc2kJCKltqY0nIARDffhfSE6ztysmaN7le5FIbZZlt3Toqec6xmdneV/Rv
         u7Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YbcTL+3qr14Rocr3oTmfsi882ixi5LpWV64cJlgqYcc=;
        b=Ep9Ku/NToxCSdozwhsW3iggEiXpzgoXT9e77/NSONvHbDD7meb07Wi6ybmSeQ0HkQd
         ljPD6kTVoOn0WfS53nPn9Y6iYQMyFmb1MhnOFxeIb3upQ/7TBYWvW+FCQ1DDzoHl780i
         63i9sAcUUQ1GDiI/2JrqMNvEHEiMiik5ZP9c8lw12o5jJFo9bqeOggKV1iLUKKXFdk9A
         6FJPZykRsrULhMTYoGPOj2uclLsQbCRgWcQq8Uqvdktt98NN0V0O5x62+fbNtoBdcrSC
         NzynqE13vfXifHqymAcxYWogTp8cqRN30Pl+Dos3ARPoSs5oNMCCwe+7s37BxPO/CZG7
         up1g==
X-Gm-Message-State: AJIora/TK+Ntq8PJcGcZAZCQtfGoPGs3Wu+cqql68XWIDEqtQQB9CRPF
        be0OXxT/aiw5MbU5HLZOliubGRiWxeYohQ==
X-Google-Smtp-Source: AGRyM1usB5byg/+DNuvkyt37RQjgSlmKDNaBM32qwOSA+SYK1RJhWKYdlKoEvwq6ViMpAswiRIln+A==
X-Received: by 2002:a17:907:9812:b0:726:3e5b:d299 with SMTP id ji18-20020a170907981200b007263e5bd299mr347748ejc.26.1657232139428;
        Thu, 07 Jul 2022 15:15:39 -0700 (PDT)
Received: from skbuf ([188.25.231.143])
        by smtp.gmail.com with ESMTPSA id fi18-20020a056402551200b0043a43fcde13sm10554706edb.13.2022.07.07.15.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 15:15:38 -0700 (PDT)
Date:   Fri, 8 Jul 2022 01:15:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH stable 4.9 v2] net: dsa: bcm_sf2: force pause link
 settings
Message-ID: <20220707221537.atc4b2k7fifhvaej@skbuf>
References: <20220706192455.56001-1-f.fainelli@gmail.com>
 <20220706203102.6pd5fac7tkyi4idz@skbuf>
 <b503199e-61d2-4d60-99dc-0f71616f7ec9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b503199e-61d2-4d60-99dc-0f71616f7ec9@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 09:53:04AM -0700, Florian Fainelli wrote:
> > IEEE 802.3 says "The PAUSE function shall be enabled according to Table
> > 28B–3 only if the highest common denominator is a full duplex technology."
> 
> Indeed, sorry about that, so I suppose the incremental patch would do, since
> we do not support changing pause frame auto-negotiation settings in 4.9:
> 
> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> index 562b5eb23d90..f3d61f2bb0f7 100644
> --- a/drivers/net/dsa/bcm_sf2.c
> +++ b/drivers/net/dsa/bcm_sf2.c
> @@ -669,15 +669,18 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch
> *ds, int port,
>                 break;
>         }
> 
> -       if (phydev->pause)
> -               rmt_adv = LPA_PAUSE_CAP;
> -       if (phydev->asym_pause)
> -               rmt_adv |= LPA_PAUSE_ASYM;
> -       if (phydev->advertising & ADVERTISED_Pause)
> -               lcl_adv = ADVERTISE_PAUSE_CAP;
> -       if (phydev->advertising & ADVERTISED_Asym_Pause)
> -               lcl_adv |= ADVERTISE_PAUSE_ASYM;
> -       flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
> +       if (phydev->duplex == DUPLEX_FULL &&
> +           phydev->autoneg == AUTONEG_ENABLE) {
> +               if (phydev->pause)
> +                       rmt_adv = LPA_PAUSE_CAP;
> +               if (phydev->asym_pause)
> +                       rmt_adv |= LPA_PAUSE_ASYM;
> +               if (phydev->advertising & ADVERTISED_Pause)
> +                       lcl_adv = ADVERTISE_PAUSE_CAP;
> +               if (phydev->advertising & ADVERTISED_Asym_Pause)
> +                       lcl_adv |= ADVERTISE_PAUSE_ASYM;
> +               flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
> +       }
> 
>         if (phydev->link)
>                 reg |= LINK_STS;

Yes, this looks OK, thank you.
