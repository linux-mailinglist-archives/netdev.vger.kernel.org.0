Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA83644AA6
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 18:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiLFRyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 12:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLFRyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 12:54:44 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBD127B38
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 09:54:43 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 136so14063504pga.1
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 09:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W6Twx4R+xRYsWuwj3gRJK0snYsutiSzgs0B2CA7DRDg=;
        b=NNdEEglbRBeBA6sG0XJix8CkBuQ8kf9OwEl1jYr+UOunckcxhpwnCkelJYBGTuLWBM
         OJM9NRh74M4VKO5PyblhlMvEDTuIVCKXeuk4OQh5+mAdzUoCdEaig4TVb8x1kfN1zKZK
         GxxTV0Hz1Hvwgi0nw+mTpZ8TtW76ZZWgqh4547sD7/HORKYdgV7Qn8ApBGFpKMFPSx7e
         S0gmpYcEFg6kn6QHdEci7zE7rVC6eejime2Ss+ErTQLN5d55oQEC88qDxSe/0i1Yk1I+
         I3mjfWiZduKfViFJT9TiUi5XSRzvV8b9xmwQMSj0Em3d4nWQrvE1bOAavON5z8iel8OZ
         ykPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W6Twx4R+xRYsWuwj3gRJK0snYsutiSzgs0B2CA7DRDg=;
        b=SaNjZKq3SnE+zMibC56uhc+BY7xKe/8icARgj9CqoC0pVnd8OE4ff3sweZj1Zetkxc
         qrKJvPnsvsofZnCnu6G/g9D/9HEVSx07DO4SdC9ARTnn0fkBIiNnYlJyErGnPc0Adc++
         cs6d6p9SMG+QbF+let0LMOdutOdK8TjbMTpb0O9KOfZj7bz7vpPq1KY1TATTCIjVcxKE
         JgGHlEg0Nv4F7ycHeLQIWiklGWbN/sB0JPYiXta3PyvZhMlv0k/nna2g9AtsZ3T4NvMk
         DA5EvogF+g/gTcXwOESjKFVA68rYYCC6LAxkcQ1bNuDB+5XivtvHHK/2SemWvGO4OvcU
         9Ouw==
X-Gm-Message-State: ANoB5pmvUBwtITLWMNxo1ol1xM9bnrghyc1TqJEFfRcBOZuX+3XdYwch
        D769k5e5MSOBonaH7MJxGc0jHSHvHn/9QuaDdWUJOA==
X-Google-Smtp-Source: AA0mqf6zQr2x4cPsGoypOz3qjtafeUYKz1g7gTZJ1QJSZB4XRdQTmfn8W29jdL5D4oQGxqJOj/+3iMij1ue6TQ9aEO8=
X-Received: by 2002:a62:36c7:0:b0:563:8011:e9e4 with SMTP id
 d190-20020a6236c7000000b005638011e9e4mr92438519pfa.76.1670349283347; Tue, 06
 Dec 2022 09:54:43 -0800 (PST)
MIME-Version: 1.0
References: <20221205194845.2131161-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221205194845.2131161-1-vladimir.oltean@nxp.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Tue, 6 Dec 2022 09:54:31 -0800
Message-ID: <CAJ+vNU0ETp7f+kGx3eDtsfhf_wVoAtrKqeZidFLKSEujDmFG6Q@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: accept phy-mode = "internal" for
 internal PHY ports
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 5, 2022 at 11:49 AM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> The ethernet-controller dt-schema, mostly pushed forward by Linux, has
> the "internal" PHY mode for denoting MAC connections to an internal PHY.
>
> U-Boot may provide device tree blobs where this phy-mode is specified,
> so make the Linux driver accept them.
>
> It appears that the current behavior with phy-mode = "internal" was
> introduced when mv88e6xxx started reporting supported_interfaces to
> phylink. Prior to that, I don't think it would have any issues accepting
> this phy-mode.
>
> Fixes: d4ebf12bcec4 ("net: dsa: mv88e6xxx: populate supported_interfaces and mac_capabilities")
> Link: https://lore.kernel.org/linux-arm-kernel/20221205172709.kglithpbhdbsakvd@skbuf/T/
> Reported-by: Tim Harvey <tharvey@gateworks.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index ccfa4751d3b7..ba4fff8690aa 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -833,10 +833,13 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
>
>         chip->info->ops->phylink_get_caps(chip, port, config);
>
> -       /* Internal ports need GMII for PHYLIB */
> -       if (mv88e6xxx_phy_is_internal(ds, port))
> +       if (mv88e6xxx_phy_is_internal(ds, port)) {
> +               __set_bit(PHY_INTERFACE_MODE_INTERNAL,
> +                         config->supported_interfaces);
> +               /* Internal ports with no phy-mode need GMII for PHYLIB */
>                 __set_bit(PHY_INTERFACE_MODE_GMII,
>                           config->supported_interfaces);
> +       }
>  }
>
>  static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
> --
> 2.34.1
>

Thanks,

This allows me to update the dt of the imx6q-gw5904 to make the
internal mdio phy's less ambiguous.

Tested-By: Tim Harvey <tharvey@gateworks.com> # imx6q-gw904.dts

Best Regards,

Tim
