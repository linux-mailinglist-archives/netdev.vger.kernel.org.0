Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C5949AE4F
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 09:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359677AbiAYIqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 03:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355202AbiAYIko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:40:44 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95F2C06808B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 23:15:35 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id w190so12611503pfw.7
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 23:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d6e9piRdTKa3UHadnhDTGSz08tmmVdIBkR4Xko1CjUo=;
        b=CZuYvt8epJ+SE8W4u964tONm4HL8E2VjzrAeu5AUpafXjx8aTMZP+dXQexCyAeoqfn
         80Skfb4RdR0e79dqPmiG+s5pTEsFGk9Up7CbIKK1J3q39T0nv78rZVEq0vEAO8lxOgSD
         ugMtvEZ9UYYEJ7y08skauOXgvlKYce/1yRZuhxBYD/9tCY/GWz3APqxPzLRqbVZsq3J2
         uyDSF5zZx3NbX7UysXu3KWUQ5HIM8uM8V3Qx6/WbZTMGycww0YP9qy7PtEdjsByfXuA3
         qsZ3CTLPYIPqbCkhZ/ynYNvaUuiBtEtkDuTyiWjVZYPLh9KE900s9qsRCimzSju8iRbp
         GPHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d6e9piRdTKa3UHadnhDTGSz08tmmVdIBkR4Xko1CjUo=;
        b=4ssZ3fX2g0m/vDqp1LeyRRLTId7B20KMwH6WHzGYOnBOy7HZquJhFfiXkm7uWtIcae
         cBc+Fl6x9XQkS5pXmRO3LGvssHR6nXcC/3uKJznoZiVgPX72RGdO45u483kQGRjneCRd
         CI8LAjytZnj21XRktjBqLYFswXV7aoh6j3y+Q/H6OxWJG8QmG61meGHIv7BlwDiewvkh
         dBTfGTVqga3XUtrEWe5P1hMFGv3Sj3t0FuiobAQKxKL4Q86Um6+468/airs/NJj0+68X
         Zh3MDuQzOaT0peehKmBW3N8cfYMDNb6gVpXtbQyEbomAyZUf8JK+I29VAs1XSIqtk6vT
         +UhQ==
X-Gm-Message-State: AOAM5307r8WvxVzaPOMe1gjkb0JJPEDjcJevVmc+GECQZh7Hg3XbpPre
        vcnotMiB5t6h5IsnzCGhXu5IqZeS0Oz0UF/dDNY=
X-Google-Smtp-Source: ABdhPJwdKcyN4ADPVRLG94sQLfm01Lv3p66p1g/f33guAAtBMgVmGjxvDkF+K9vv3ijI5Sxu/z1CTRmfi9GqVCpKCcI=
X-Received: by 2002:a63:461c:: with SMTP id t28mr14238191pga.547.1643094935053;
 Mon, 24 Jan 2022 23:15:35 -0800 (PST)
MIME-Version: 1.0
References: <20220124084649.0918ba5c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124165535.tksp4aayeaww7mbf@skbuf> <228b64d7-d3d4-c557-dba9-00f7c094f496@gmail.com>
 <20220124172158.tkbfstpwg2zp5kaq@skbuf> <20220124093556.50fe39a3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124102051.7c40e015@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124190845.md3m2wzu7jx4xtpr@skbuf> <20220124113812.5b75eaab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124205607.kugsccikzgmbdgmf@skbuf> <20220124134242.595fd728@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124223053.gpeonw6f34icwsht@skbuf>
In-Reply-To: <20220124223053.gpeonw6f34icwsht@skbuf>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 25 Jan 2022 04:15:23 -0300
Message-ID: <CAJq09z5JF71kFKxF860RCXPvofhitaPe7ES4UTMeEVO8LH=PoA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wow... that's a lot to digest.

> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  .../files/drivers/net/ethernet/ralink/mtk_eth_soc.c  | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/target/linux/ramips/files/drivers/net/ethernet/ralink/mtk_eth_soc.c b/target/linux/ramips/files/drivers/net/ethernet/ralink/mtk_eth_soc.c
> index e07e5ed5a8f8..6ed9bc5942fd 100644
> --- a/target/linux/ramips/files/drivers/net/ethernet/ralink/mtk_eth_soc.c
> +++ b/target/linux/ramips/files/drivers/net/ethernet/ralink/mtk_eth_soc.c
> @@ -31,6 +31,7 @@
>  #include <linux/io.h>
>  #include <linux/bug.h>
>  #include <linux/netfilter.h>
> +#include <net/dsa.h>
>  #include <net/netfilter/nf_flow_table.h>
>  #include <linux/of_gpio.h>
>  #include <linux/gpio.h>
> @@ -1497,6 +1498,16 @@ static int fe_change_mtu(struct net_device *dev, int new_mtu)
>         return fe_open(dev);
>  }
>
> +static netdev_features_t fe_features_check(struct sk_buff *skb,
> +                                          struct net_device *dev,
> +                                          netdev_features_t features)
> +{
> +       if (netdev_uses_dsa(dev))
> +               features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
> +
> +       return features;
> +}
> +
>  static const struct net_device_ops fe_netdev_ops = {
>         .ndo_init               = fe_init,
>         .ndo_uninit             = fe_uninit,
> @@ -1514,6 +1525,7 @@ static const struct net_device_ops fe_netdev_ops = {
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>         .ndo_poll_controller    = fe_poll_controller,
>  #endif
> +       .ndo_features_check     = fe_features_check,
>  };
>
>  static void fe_reset_pending(struct fe_priv *priv)

Thanks, Vladimir. I'll try that patch soon. However, it will never be
accepted even in OpenWrt as is because it does offload its own
proprietary tag.
I might need to add another if like:

> +       if (netdev_uses_dsa(dev))
> +               if (skb->???->proto_in_use != DSA_TAG_PROTO_MTK)
> +                      features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);

I think it would need to save the used tag in some form of an oob
signal (as Florian suggested). In that case, even the
netdev_uses_dsa() test can be removed as a skb with an oob tag signal
is surely from a dsa device.

Anyway, even with existing offload code not doing exactly what they
should, they normally work given a normal device usage. The strange
part is that DSA assumes those features, copied from master to slave,
will still be the same even after a tag was injected into the packet.

Sorry for my arrogance being a newbie but I think the place to fix the
problem is still in slave feature list. It is better than having the
kernel repeat the test for every single packet. And nobody will be
willing to add extra overhead to a working code just because DSA needs
it. It is easier to add a new function that does not touch existing
code paths.

I believe that those drivers with NETIF_F_HW_CSUM are fine for every
type of DSA, right? So, just those with NETIF_F_IP_CSUM |
NETIF_F_IPV6_CSUM set needs to be adjusted. A fully implemented
ndo_features_check() will work but improving it for every driver will
add extra code/overhead for all packets, used with DSA or not. And
that extra code needed for DSA will either always keep or remove the
same features for a given slave.

I imagine that for NETIF_F_CSUM_MASK and NETIF_F_GSO_MASK, it would
not be too hard to build a set of candidate packets to test if that
feature is still valid after the tag was added. With that assumption,
a new ndo_features_check_offline(), similar to ndo_features_check()
but not be called by netif_skb_features, will test each candidate
during slave setup. If the check disagrees after the tag was added,
that feature should be disabled for that slave. Something like:

slave->features = master->features;
if (slave->features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))
    if (dev->netdev_ops->ndo_features_check_offline)
        foreach (test_candidate)
            tagged_test_candidate = add_tag (test_candidate, slave->tag);

            slave->features &=
~(master->netdev_ops->ndo_features_check_offline(test_candidate,
master, slave->features) ^

master->netdev_ops->ndo_features_check_offline(tagged_test_candidate,
master, slave->features)
    else
        slave->features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK)

The only drivers that would have performance regression while used as
DSA master ports are those:
1) that does not have NETIF_F_HW_CSUM set
2) but could still offload after a particular DSA tag was added (when
tag vendor and HW matches)
3) and still didn't implement the new ndo_features_check_offline().

ndo_features_check_offline() would not be too much different from what
Vladmir suggested for the out-of-tree mtk_eth_soc driver.

ndo_features_check_offline(sbk, dev, features) {
    switch (sbk->oob->tag) {
    case SUPPORTED_TAG_1:
    case SUPPORTED_TAG_2:
    case SUPPORTED_TAG_3:
    case NO_TAG:
        break;
    default:
        features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
    }

    if (dev->netdev_ops->ndo_features_check)
         features &= dev->netdev_ops->ndo_features_check(skb, dev, features);

    /* some more test if needed*/

    return features;
}

If used exclusively by DSA, ndo_features_check_offline could also be
called ndo_dsa_features_check (or any better name than
ndo_features_check_offline). That is not far away from what Vladmir
suggested (and later retracted) in the first place.

Regards,

Luiz
