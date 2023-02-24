Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC836A15A8
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 04:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjBXDz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 22:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBXDz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 22:55:57 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649A229E34;
        Thu, 23 Feb 2023 19:55:56 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id b16so6699179iln.3;
        Thu, 23 Feb 2023 19:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VbTIKtcCZdin9kdNkGWxLRdhhzQ58YxCqZNgWHIeK+M=;
        b=j9WNzsxPEAJgAqXDoMy075+EgPAgJp89uQP9MxMWsPO3//E+mz6kf9+dYCoqMXlTQZ
         YqKJolI4RECVlNEPNTZiUfiBt57c5zp9XVGxaZTet6fMiQbkmvBHE4gz7zQQUa1XdsIZ
         UsfYNANSOC4tNmW9TwDTLwLKypTwNoIwuNGFW/LpZctBOMZLI8jl/HbKVenXYYV7/xCO
         T7xYL2jV2UIYYC9uy5AmBMJZEdKChIVVc6ym5TwFnI2fhyzgtTbNHakevBYvdKD5Ez2B
         +l5ntghH/yUuGsxjmnpML3zigGrSRQMUUFUbEZOOCu0wVI1FWYTG3c+v9EosDBUv68D6
         BPaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VbTIKtcCZdin9kdNkGWxLRdhhzQ58YxCqZNgWHIeK+M=;
        b=nPABUQyyo24MVbL1dTsLA+TwBPkzF6wFvF+PILnLhociH8hX6r2MjpBkxrpAdKdpsR
         FYZ2ruiDXLJq4XfCPN0MnxRD+zm/HWNP7evPGrYIUzR/D/6cW0nb9GcW3rYmBstZuVIF
         jAV6JnF12t8a2Ercha66Dhk6CZnaPkYL1bOnEPhgIpU8oZKVUTaCQtAdXXNzd1Z6Mfn/
         duJJOMIvj9PJyj5kwdbhPwhj0odtfnZ6c/T8acdrgLesxcat8upH1nsl8f4ASdn3KvvH
         v83Euw1ag+WkM4GyoD/pw1yYCY3Z/lN4xvaXU+2ex5rvlXfuVr8hFPcaNXWiK2A6368V
         7z+A==
X-Gm-Message-State: AO0yUKW6INZ9URI7oezSbfWeXPkd2S/jqbP+Ogvdgu+LHHRN1r84ZOpv
        WHvQhBBFx/1h/Qxw60/tMrA=
X-Google-Smtp-Source: AK7set/N5OHlH+ID7f/i44cM7KsoiPH+D6zoLglAmPxwwIIfQbf5S+gfQa3/BMuryaakq5+soNTdMw==
X-Received: by 2002:a05:6e02:1b81:b0:317:f50:383b with SMTP id h1-20020a056e021b8100b003170f50383bmr874477ili.27.1677210955711;
        Thu, 23 Feb 2023 19:55:55 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k13-20020a02cb4d000000b003a60e5a2638sm4001581jap.94.2023.02.23.19.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 19:55:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 23 Feb 2023 19:55:53 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v8 6/9] net: phy: c22: migrate to
 genphy_c45_write_eee_adv()
Message-ID: <20230224035553.GA1089605@roeck-us.net>
References: <20230211074113.2782508-1-o.rempel@pengutronix.de>
 <20230211074113.2782508-7-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230211074113.2782508-7-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 11, 2023 at 08:41:10AM +0100, Oleksij Rempel wrote:
> Migrate from genphy_config_eee_advert() to genphy_c45_write_eee_adv().
> 
> It should work as before except write operation to the EEE adv registers
> will be done only if some EEE abilities was detected.
> 
> If some driver will have a regression, related driver should provide own
> .get_features callback. See micrel.c:ksz9477_get_features() as example.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

This patch causes network interface failures with all my xtensa qemu
emulations. Reverting it fixes the problem. Bisect log is attached
for reference.

Guenter

---
# bad: [e4bc15889506723d7b93c053ad4a75cd58248d74] Merge tag 'leds-next-6.3' of git://git.kernel.org/pub/scm/linux/kernel/git/lee/leds
# good: [c9c3395d5e3dcc6daee66c6908354d47bf98cb0c] Linux 6.2
git bisect start 'HEAD' 'c9c3395d5e3d'
# bad: [5b7c4cabbb65f5c469464da6c5f614cbd7f730f2] Merge tag 'net-next-6.3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
git bisect bad 5b7c4cabbb65f5c469464da6c5f614cbd7f730f2
# good: [877934769e5b91798d304d4641647900ee614ce8] Merge tag 'x86_cpu_for_v6.3_rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 877934769e5b91798d304d4641647900ee614ce8
# good: [c5ebba75c7625e5cb62cb5423883cc3764779420] net: ipa: use bitmasks for GSI IRQ values
git bisect good c5ebba75c7625e5cb62cb5423883cc3764779420
# bad: [871489dd01b67483248edc8873c389a66e469f30] Merge tag 'ieee802154-for-net-next-2023-02-20' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan-next
git bisect bad 871489dd01b67483248edc8873c389a66e469f30
# good: [986e43b19ae9176093da35e0a844e65c8bf9ede7] wifi: mac80211: fix receiving A-MSDU frames on mesh interfaces
git bisect good 986e43b19ae9176093da35e0a844e65c8bf9ede7
# bad: [ca0df43d211039dded5a8f8553356414c9a74731] Merge tag 'wireless-next-2023-03-16' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
git bisect bad ca0df43d211039dded5a8f8553356414c9a74731
# bad: [388a9c907a51489bf566165c72e4e8aa4d62ab49] Merge branch 'devlink-cleanups-and-move-devlink-health-functionality-to-separate-file'
git bisect bad 388a9c907a51489bf566165c72e4e8aa4d62ab49
# bad: [1a940b00013a468c0c9dd79dbb485c3ad273939e] net: stmmac: dwc-qos: Make struct dwc_eth_dwmac_data::remove return void
git bisect bad 1a940b00013a468c0c9dd79dbb485c3ad273939e
# good: [8024edf3590c83f467374857d7c3082d4b3bf079] Merge branch 'net-ipa-GSI-regs'
git bisect good 8024edf3590c83f467374857d7c3082d4b3bf079
# bad: [9b01c885be364526d8c05794f8358b3e563b7ff8] net: phy: c22: migrate to genphy_c45_write_eee_adv()
git bisect bad 9b01c885be364526d8c05794f8358b3e563b7ff8
# good: [79cdf17e5131ccdee0792f6f25d3db0e34861998] Merge branch 'ionic-on-chip-desc'
git bisect good 79cdf17e5131ccdee0792f6f25d3db0e34861998
# good: [48fb19940f2ba6b50dfea70f671be9340fb63d60] net: phy: micrel: add ksz9477_get_features()
git bisect good 48fb19940f2ba6b50dfea70f671be9340fb63d60
# good: [022c3f87f88e2d68e90be7687d981c9cb893a3b1] net: phy: add genphy_c45_ethtool_get/set_eee() support
git bisect good 022c3f87f88e2d68e90be7687d981c9cb893a3b1
# first bad commit: [9b01c885be364526d8c05794f8358b3e563b7ff8] net: phy: c22: migrate to genphy_c45_write_eee_adv()
