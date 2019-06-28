Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9415A2AB
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfF1Rmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:42:36 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38559 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfF1Rmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:42:36 -0400
Received: by mail-lj1-f196.google.com with SMTP id r9so6794105ljg.5
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 10:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0TblVs0OCGnK0PdDL0E4v2C6QkBq74kuKaiwg1yEJr4=;
        b=h+CWyiCXWK49xupKTFvq1Zw/VMslxTC74r/7TANkE2gykXH/MqX2SHCzhW1aS3OSRq
         oRpajLJiUyRRESOjXOy4M7U8LsQxrek2km6IydcgewpqQkUeFa+NaLL7R4KjKPi+EJv5
         vqS6fql9TLXiR57gw/RR2h8A9zAXZJG061bzuEKfJj+Uy+b93Dmf9hUvt+ANjSKVfyQK
         hewFxVOTmp2nO9ehdECjTQxswTCBIj1nknxtP4U5Ohz5NBPo2X7Mk82ZKqW08TKqYSKS
         NfgSjhCJpy5gtz1tkSA1bmljN6JuvPWkOPMvAKu/xv2ov7tKY5FgaEN5vXqgrIfCBMbj
         dw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0TblVs0OCGnK0PdDL0E4v2C6QkBq74kuKaiwg1yEJr4=;
        b=Jp1fgnDmWjSOMYMXAAwyQlgrSvPW543492hlnRqOMIglCcA7jw7y/X2cUr8CEEGmSc
         5Ug0k5wKF18TrI/SiJHdKkv4Cc77jyOLwxTiO2q4/iu00BKjT9uv+gdsmS1fyZGwakHL
         i0sCbvIKz/87hxZW2j8LEiUNfSuRTqMIZO6KcW862smyM4sX+91apXTbsXxBVZPRbx3D
         LsmxcrJOkDSKGQRZsqJX6wo+dn/4Q3o3swzp3pXF+2+vcq/IYcnteJWIIju+KyDXklgK
         uns85m71YANl9ukWednD/m78tcK7u16qEI05oLyH1sjYOchdA2/P9AVHfHE2IL6zD7zd
         kO2Q==
X-Gm-Message-State: APjAAAVTFa/dfKtCrTh3GP3HqLUuIasMXCSw5xJnamV+T4PfYhvPmICf
        6JHbKSrwnalSpvwzHNELKpNzhoMensLKiWfsHGpQJg==
X-Google-Smtp-Source: APXvYqyphJPSJBdLJ+epjI69c+FLaMeKjCx6uexJiaczWqX8W0NIivkMYXAVghTGjfqySRWIjcKE6PD0QYa+SGqHBGE=
X-Received: by 2002:a2e:9754:: with SMTP id f20mr6839586ljj.151.1561743753707;
 Fri, 28 Jun 2019 10:42:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190626185251.205687-1-csully@google.com> <20190626185251.205687-5-csully@google.com>
 <20190626194805.GG27733@lunn.ch>
In-Reply-To: <20190626194805.GG27733@lunn.ch>
From:   Catherine Sullivan <csully@google.com>
Date:   Fri, 28 Jun 2019 10:42:22 -0700
Message-ID: <CAH_-1qwA4y3_OKSP0gegiE5HB8KE-+2u9XYsYe2MFKU1vDXTFg@mail.gmail.com>
Subject: Re: [net-next 4/4] gve: Add ethtool support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 12:48 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +static int gve_get_sset_count(struct net_device *netdev, int sset)
> > +{
> > +     struct gve_priv *priv = netdev_priv(netdev);
> > +
> > +     if (!netif_carrier_ok(netdev))
> > +             return 0;
>
> That is pretty unusual. What goes wrong if there is no carrier and
> statistics are returned?

This was meant to protect against priv->rx/tx not being a valid pointer.
In v2 it will just check the pointer instead of the carrier status.

>
> > +static void
> > +gve_get_ethtool_stats(struct net_device *netdev,
> > +                   struct ethtool_stats *stats, u64 *data)
> > +{
> > +     struct gve_priv *priv = netdev_priv(netdev);
> > +     u64 rx_pkts, rx_bytes, tx_pkts, tx_bytes;
> > +     int ring;
> > +     int i;
> > +
> > +     ASSERT_RTNL();
> > +
> > +     if (!netif_carrier_ok(netdev))
> > +             return;
> > +
> > +     for (rx_pkts = 0, rx_bytes = 0, ring = 0;
> > +          ring < priv->rx_cfg.num_queues; ring++) {
> > +             rx_pkts += priv->rx[ring].rpackets;
> > +             rx_bytes += priv->rx[ring].rbytes;
> > +     }
> > +     for (tx_pkts = 0, tx_bytes = 0, ring = 0;
> > +          ring < priv->tx_cfg.num_queues; ring++) {
> > +             tx_pkts += priv->tx[ring].pkt_done;
> > +             tx_bytes += priv->tx[ring].bytes_done;
> > +     }
> > +     memset(data, 0, GVE_MAIN_STATS_LEN * sizeof(*data));
>
> Maybe you should do this memset when the carrier is off?

Will be fixed in v2.

>
>       Andrew


Catherine
