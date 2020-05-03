Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968B61C302E
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 00:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgECWra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 18:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726825AbgECWr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 18:47:29 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60636C061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 15:47:29 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id re23so12347829ejb.4
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 15:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HvQWJeUYNHAk/8+V+gHW+AG1+DPIhQaHKnYbp+pQFCI=;
        b=RLmyb7oHyoA586i0bwYRGEgoSXQ8PXkv3UIyd7fkfoV+JqTjB/98Q3kVEcisgQg8T8
         zskRG9ihHP3+X0NIw5wxmzkgb3z+KW/wTzmL/0epWHBQbrCQH4AuHMFzD6o7lV1MiGgd
         I6n6CHHDbFw2FpaCgTFrCkDbs75cX11+XPSj/mMVhh8EGEfBRq31JkVWeDo8zTJLAPle
         BXBqwQe76f2Ke9iDEubiyvknbecxySZT5+JlfzrOHTdzpBg+o3Fg3VfICnxMleaVYE93
         0HARHQWA2qbUeAjN31vzdgbYNY1tXGageTFtFHmzCe9GPxxSudx7KU8MNzc1I99TsLLZ
         HXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HvQWJeUYNHAk/8+V+gHW+AG1+DPIhQaHKnYbp+pQFCI=;
        b=HpmX1EkoaGd+R464PufQTID5PuKxT6ctwDVuC/8Lk65UW0iYKr+qAy/son6QmhcbMT
         27513VlkxnMkRPHZefpfFvwihTQ+ikx12SXSxwV1HXGmrqKnMNCi6eSyi5+X61wXcWi9
         p1j46oNy1D6EoHK0Kc/9REZDZxe1IBWj4T2VuBmJqWHp8FwT0NzfMI4WlfZLoLRq4y11
         rWXhHswSrNW/unKTny0hZcYmHIJFYpSpcxeM9x1Zy++vTC+bt8Z3mTWCBKgZ2Pw7EJNG
         YQjNfSG/UNmLVfWaQzEHfGcy6HSOEydDXPgXpSp8Mup6D8NsF7/7eHdsoGDz91+TQzGQ
         ZIww==
X-Gm-Message-State: AGi0PuaDHaBjTe+eknCPU/OvAC9HFR82M4L8z6LqJf8jI5PXgo/52rdR
        sJAbPQeZqLOpaXEPVU0exz/19Pwkzh8tjjdsB6XGhoJy
X-Google-Smtp-Source: APiQypK6Nvn1/JusrxgRSXmAVynomBhfSBke4J8pPLjEspiPcsTtPHghDKxFErySa7YOD3BE7cNvkXt520lhG3jniro=
X-Received: by 2002:a17:906:355b:: with SMTP id s27mr12717021eja.184.1588546048056;
 Sun, 03 May 2020 15:47:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200503211035.19363-1-olteanv@gmail.com> <20200503211035.19363-2-olteanv@gmail.com>
 <71b974ca-66b4-b697-28fc-106cad586fba@gmail.com>
In-Reply-To: <71b974ca-66b4-b697-28fc-106cad586fba@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 4 May 2020 01:47:17 +0300
Message-ID: <CA+h21hono93B+GQ7xi07_K7TMf2teP=62tu4cBigs--X5gQMLA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/6] net: dsa: export dsa_slave_dev_check and dsa_slave_to_port
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>,
        Christian Herber <christian.herber@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        vlad@buslov.dev, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Mon, 4 May 2020 at 01:45, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/3/2020 2:10 PM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > To be able to perform mirroring and redirection through tc-flower
> > offloads (the implementation of which is given raw access to the
> > flow_cls_offload structure), switch drivers need to be able to call
> > these functions on act->dev.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> > Changes from RFC:
> > None.
> >
> >  include/net/dsa.h  | 2 ++
> >  net/dsa/dsa_priv.h | 8 --------
> >  net/dsa/slave.c    | 9 +++++++++
> >  3 files changed, 11 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/net/dsa.h b/include/net/dsa.h
> > index fb3f9222f2a1..62beaa4c234e 100644
> > --- a/include/net/dsa.h
> > +++ b/include/net/dsa.h
> > @@ -739,6 +739,8 @@ int dsa_port_get_phy_strings(struct dsa_port *dp, uint8_t *data);
> >  int dsa_port_get_ethtool_phy_stats(struct dsa_port *dp, uint64_t *data);
> >  int dsa_port_get_phy_sset_count(struct dsa_port *dp);
> >  void dsa_port_phylink_mac_change(struct dsa_switch *ds, int port, bool up);
> > +bool dsa_slave_dev_check(const struct net_device *dev);
> > +struct dsa_port *dsa_slave_to_port(const struct net_device *dev);
> >
> >  struct dsa_tag_driver {
> >       const struct dsa_device_ops *ops;
> > diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> > index 6d9a1ef65fa0..32bf570fd71c 100644
> > --- a/net/dsa/dsa_priv.h
> > +++ b/net/dsa/dsa_priv.h
> > @@ -173,19 +173,11 @@ extern const struct dsa_device_ops notag_netdev_ops;
> >  void dsa_slave_mii_bus_init(struct dsa_switch *ds);
> >  int dsa_slave_create(struct dsa_port *dp);
> >  void dsa_slave_destroy(struct net_device *slave_dev);
> > -bool dsa_slave_dev_check(const struct net_device *dev);
> >  int dsa_slave_suspend(struct net_device *slave_dev);
> >  int dsa_slave_resume(struct net_device *slave_dev);
> >  int dsa_slave_register_notifier(void);
> >  void dsa_slave_unregister_notifier(void);
> >
> > -static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
> > -{
> > -     struct dsa_slave_priv *p = netdev_priv(dev);
> > -
> > -     return p->dp;
> > -}
> > -
> >  static inline struct net_device *
> >  dsa_slave_to_master(const struct net_device *dev)
> >  {
> > diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> > index ba8bf90dc0cc..4eeb5b47ef99 100644
> > --- a/net/dsa/slave.c
> > +++ b/net/dsa/slave.c
> > @@ -62,6 +62,14 @@ static int dsa_slave_get_iflink(const struct net_device *dev)
> >       return dsa_slave_to_master(dev)->ifindex;
> >  }
> >
> > +struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
> > +{
> > +     struct dsa_slave_priv *p = netdev_priv(dev);
> > +
> > +     return p->dp;
> > +}
> > +EXPORT_SYMBOL_GPL(dsa_slave_to_port);
>
> You could probably make this a static inline in net/dsa.h, too. With or
> without doing that:

With dereferencing dsa_slave_priv, I don't think so.

>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> --
> Florian

Thanks,
-Vladimir
