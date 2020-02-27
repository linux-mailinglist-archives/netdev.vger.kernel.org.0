Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76AA0171191
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgB0HgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:36:15 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34374 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgB0HgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:36:15 -0500
Received: by mail-lj1-f196.google.com with SMTP id x7so2215470ljc.1
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qZLAbOLHePXemWTFYvKdWHA10bGozpnZp4LM38PR+z0=;
        b=b+AJsk5jr31tyAKiCqdIzFUvdN2oZZ2gOdL39Foj4wuMVEX1liO5YyDRQMVtQ+AbJV
         2DY7e4KejQqmUr3GZmYvjv3MsZQGN2nxVOMdSyK+6+l8XRl6b6xjxQaw2dRyBEveLwtb
         JhRUpVSaafnxPlEfYsxzPCH6r5/meVEmw56N1ugVm/gvgmcKpJWmK5eCbK1n4epVSsyQ
         /Id0rYFX5zYt/uiLndttF13JvIWXRIE1kdjM3RthTSjUknBylG5KKbR0aJsi0pBOykHs
         YhGSMJBv3v8MS5s9ZKiyEhABZPtsUEAe7CoJsplCmL9+pEr76gLTqnG6yyKVz+WNaNDr
         u5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qZLAbOLHePXemWTFYvKdWHA10bGozpnZp4LM38PR+z0=;
        b=TFu1myc4g9jgjAlRYfCOKU32qHrSFKeEkmMwz0AvoqzdXterEHwcl9CnKGKwxT8uoD
         WtT6L6iYt/OKnt7NZp58jwGwI4klVu9PhAV/q4jcrwadiX6JHmPpKuJNVhBN+c72vtq6
         REEZrwiXiNRS5num67yvDLN5bmtXv5Q9Z/oYLjCCXGOXT4HgUd1HcLIui86aQ9QTBGA9
         WNb2Nxblz3hsO39Kl2e6A2thMsjEOoFj1pk3/giX0PiXR1wQg7Suc6IHZwpdUgrwqJGV
         eq78xPnBSEJWPk4prl3mnxwuPb+sXnEc6ImUQwEQIRcPNQY3czr/lVPzwn6xFSOIgaeD
         qLnw==
X-Gm-Message-State: ANhLgQ2ejCc1beLtIBfsAifzhFBpMFLbdVluGTEdpnGjxjh9G9FKrsrV
        4QfMa4r2fL9yINLefjo3wcBrFJ+eAueihQ55jBPIkfCECBI=
X-Google-Smtp-Source: ADFU+vuGaek6yZUix0+4WS+0mZcT69Uw9ImAtpnISLK4ZtMqAyKUq4EzXLMJI7GZgT1bN3spfgsMLPYnFIfE/PVHOhc=
X-Received: by 2002:a2e:809a:: with SMTP id i26mr2035571ljg.108.1582788972784;
 Wed, 26 Feb 2020 23:36:12 -0800 (PST)
MIME-Version: 1.0
References: <20200226174740.5636-1-ap420073@gmail.com> <84eb4ca7add20145fc427c3183d67ef6@codeaurora.org>
In-Reply-To: <84eb4ca7add20145fc427c3183d67ef6@codeaurora.org>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Thu, 27 Feb 2020 16:36:01 +0900
Message-ID: <CAMArcTW_dgUVjMD5+yUPQrJxjQOaGyHJ0DT1Kx6m=fGeMrA2=g@mail.gmail.com>
Subject: Re: [PATCH net 06/10] net: rmnet: print error message when command fails
To:     subashab@codeaurora.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stranche@codeaurora.org,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Feb 2020 at 05:37, <subashab@codeaurora.org> wrote:
>

Hi,
Thank you for the review :)

> On 2020-02-26 10:47, Taehee Yoo wrote:
> > When rmnet netlink command fails, it doesn't print any error message.
> > So, users couldn't know the exact reason.
> > In order to tell the exact reason to the user, the extack error message
> > is used in this patch.
> >
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >  .../ethernet/qualcomm/rmnet/rmnet_config.c    | 26 ++++++++++++-------
> >  .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   | 10 +++----
> >  .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |  3 ++-
> >  3 files changed, 24 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> > b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> > index c8b1bfe127ac..93745cd45c29 100644
> > --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> > +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> > @@ -141,11 +141,10 @@ static int rmnet_newlink(struct net *src_net,
> > struct net_device *dev,
> >       }
> >
> >       real_dev = __dev_get_by_index(src_net, nla_get_u32(tb[IFLA_LINK]));
> > -     if (!real_dev || !dev)
> > +     if (!real_dev || !dev) {
> > +             NL_SET_ERR_MSG_MOD(extack, "link does not exist");
> >               return -ENODEV;
> > -
> > -     if (!data[IFLA_RMNET_MUX_ID])
> > -             return -EINVAL;
> > +     }
> >
> >       ep = kzalloc(sizeof(*ep), GFP_ATOMIC);
> >       if (!ep)
> > @@ -158,7 +157,7 @@ static int rmnet_newlink(struct net *src_net,
> > struct net_device *dev,
> >               goto err0;
> >
> >       port = rmnet_get_port_rtnl(real_dev);
> > -     err = rmnet_vnd_newlink(mux_id, dev, port, real_dev, ep);
> > +     err = rmnet_vnd_newlink(mux_id, dev, port, real_dev, ep, extack);
> >       if (err)
> >               goto err1;
> >
> > @@ -275,12 +274,16 @@ static int rmnet_rtnl_validate(struct nlattr
> > *tb[], struct nlattr *data[],
> >  {
> >       u16 mux_id;
> >
> > -     if (!data || !data[IFLA_RMNET_MUX_ID])
> > +     if (!data || !data[IFLA_RMNET_MUX_ID]) {
> > +             NL_SET_ERR_MSG_MOD(extack, "MUX ID not specifies");
> >               return -EINVAL;
> > +     }
> >
> >       mux_id = nla_get_u16(data[IFLA_RMNET_MUX_ID]);
> > -     if (mux_id > (RMNET_MAX_LOGICAL_EP - 1))
> > +     if (mux_id > (RMNET_MAX_LOGICAL_EP - 1)) {
> > +             NL_SET_ERR_MSG_MOD(extack, "invalid MUX ID");
> >               return -ERANGE;
> > +     }
> >
> >       return 0;
> >  }
> > @@ -414,11 +417,16 @@ int rmnet_add_bridge(struct net_device
> > *rmnet_dev,
> >       /* If there is more than one rmnet dev attached, its probably being
> >        * used for muxing. Skip the briding in that case
> >        */
> > -     if (port->nr_rmnet_devs > 1)
> > +     if (port->nr_rmnet_devs > 1) {
> > +             NL_SET_ERR_MSG_MOD(extack, "more than one rmnet dev attached");
> >               return -EINVAL;
> > +     }
> >
> > -     if (rmnet_is_real_dev_registered(slave_dev))
> > +     if (rmnet_is_real_dev_registered(slave_dev)) {
> > +             NL_SET_ERR_MSG_MOD(extack,
> > +                                "dev is already attached another rmnet dev");
> >               return -EBUSY;
> > +     }
> >
> >       err = rmnet_register_real_device(slave_dev);
> >       if (err)
> > diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> > b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> > index a26e76e9d382..90c19033ebe0 100644
> > --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> > +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> > @@ -224,16 +224,16 @@ void rmnet_vnd_setup(struct net_device
> > *rmnet_dev)
> >  int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
> >                     struct rmnet_port *port,
> >                     struct net_device *real_dev,
> > -                   struct rmnet_endpoint *ep)
> > +                   struct rmnet_endpoint *ep,
> > +                   struct netlink_ext_ack *extack)
> >  {
> >       struct rmnet_priv *priv = netdev_priv(rmnet_dev);
> >       int rc;
> >
> > -     if (ep->egress_dev)
> > -             return -EINVAL;
> > -
> > -     if (rmnet_get_endpoint(port, id))
> > +     if (rmnet_get_endpoint(port, id)) {
> > +             NL_SET_ERR_MSG_MOD(extack, "MUX ID already exists");
> >               return -EBUSY;
> > +     }
> >
> >       rmnet_dev->hw_features = NETIF_F_RXCSUM;
> >       rmnet_dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
> > diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
> > b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
> > index 54cbaf3c3bc4..d8fa76e8e9c4 100644
> > --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
> > +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
> > @@ -11,7 +11,8 @@ int rmnet_vnd_do_flow_control(struct net_device
> > *dev, int enable);
> >  int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
> >                     struct rmnet_port *port,
> >                     struct net_device *real_dev,
> > -                   struct rmnet_endpoint *ep);
> > +                   struct rmnet_endpoint *ep,
> > +                   struct netlink_ext_ack *extack);
> >  int rmnet_vnd_dellink(u8 id, struct rmnet_port *port,
> >                     struct rmnet_endpoint *ep);
> >  void rmnet_vnd_rx_fixup(struct sk_buff *skb, struct net_device *dev);
>
> This patch and [PATCH net 02/10] "net: rmnet: add missing module alias"
> seem
> to be adding new functionality. Perhaps it can be sent to net-next
> instead
> of net.

Okay, I will drop these two patches from this patchset.
And I will send these two patches to net-next separately.

Thanks a lot!
Taehee Yoo
