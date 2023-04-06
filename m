Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12406D8F4E
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 08:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbjDFGVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 02:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbjDFGVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 02:21:50 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A943B4
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 23:21:49 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso39662190pjb.3
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 23:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680762108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9cCjQVs7IbnxcnODeDAba8EKdQX1O5+9z89NepZpu04=;
        b=aanFo98m43aMKrpEIl+fb1KMr6Gd7vLCKz2SzO04pXMVDgJzBzw+N9C/ax2cLHZaMH
         +pyWnmE0rPAKcg/WdIQJnUm1rUJjnT2DTInVtH49jA4FITH0FOzt2Z/bZaePwuwUrG7H
         4jP7cCKBcPnbFns75GVjvAaEhfqUoJobEsNNMTcbxVyfEieBDH2wAnQIvrTkuKEB4StR
         3etYptgrHH1xOWbvp+sP9AfWJRjeaqC3VdSkrNDjwOgVTVCBcQZPdaniphuDv0CY+H7K
         Yc6bG0+/sJULAA+CfAZmf6on/SnTIfItnrQXWPQ2A4OOMvcKTXxZyTq9XsMzZQB2PjUp
         Kmjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680762108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9cCjQVs7IbnxcnODeDAba8EKdQX1O5+9z89NepZpu04=;
        b=yCHfKTO9YYYFBBX5XgnQBb8ajzO1SvXyutGwU3J5fEB8NB46m2yDBiTiHzswWnuIp5
         ftr9DioVLn1sPjGfA8zkTXcKz3gb1jn+4gGRZYGRqDa2EStYwXs4NXzIiK3sQnPbaQp9
         UTqsG/rdhwXkU4+Ta+JzCZ4CjT0IQSsBncOZPDmF6zbjGBlr7C4CIEcArQN/AmXfMPYF
         6pE60y1hPCiWbQraA4Do+snRlIolWO3KvMxtQxNFq1RfdkCCD8hqoNFXjaUTkFltrqUA
         IHiTMnM3TblAwh1HgRIf6dDCCkk0atk5dBSKFPRW+vRpUQj/RTvhj4MiWoyAwAxtMpjZ
         JDbw==
X-Gm-Message-State: AAQBX9c17UhYzmXNU3K0fbehJ+02tUlA4awcaxgHzJOsdJfoGYt0B723
        oWAqmGcXVj4T7+Rf4kqS3VIwaXgvz27Hb0fy7505M4nrN43kgPBY
X-Google-Smtp-Source: AKy350bjof/9e70ccns7Z/8RLyFqs0eFRRtC3ou4me2V7gNHsdIo0k+rCPqSCI4UDGaJXeO5/L8mgv5t8Nvt7WZ6bxE=
X-Received: by 2002:a17:902:b18e:b0:1a2:13af:7c77 with SMTP id
 s14-20020a170902b18e00b001a213af7c77mr3587639plr.13.1680762108499; Wed, 05
 Apr 2023 23:21:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230405063323.36270-1-glipus@gmail.com> <20230405094210.32c013a7@kernel.org>
 <20230405170322.epknfkxdupctg6um@skbuf> <20230405101323.067a5542@kernel.org>
 <20230405172840.onxjhr34l7jruofs@skbuf> <20230405104253.23a3f5de@kernel.org>
 <20230405180121.cefhbjlejuisywhk@skbuf> <20230405170010.1c989a8f@kernel.org>
In-Reply-To: <20230405170010.1c989a8f@kernel.org>
From:   Max Georgiev <glipus@gmail.com>
Date:   Thu, 6 Apr 2023 00:21:37 -0600
Message-ID: <CAP5jrPGzrzMYmBBT+B6U5Oh6v_Tcie1rj0KqsWOEZOBR7JBoXA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan code path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        kory.maincent@bootlin.com, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 5, 2023 at 6:00=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Wed, 5 Apr 2023 21:01:21 +0300 Vladimir Oltean wrote:
> > - bonding is also DSA master when it has a DSA master as lower, so the
> >   DSA master restriction has already run once - on the bonding device
> >   itself
>
> Huh, didn't know that.
>
> > > The latter could be used for the first descend as well I'd presume.
> > > And it can be exported for the use of more complex drivers like
> > > bonding which want to walk the lowers themselves.
> > >
> > > > - it requires cfg.flags & HWTSTAMP_FLAG_BONDED_PHC_INDEX to be set =
in
> > > >   SET requests
> > > >
> > > > - it sets cfg.flags | HWTSTAMP_FLAG_BONDED_PHC_INDEX in GET respons=
es
> > >
> > > IIRC that was to indicate to user space that the real PHC may change
> > > for this netdev so it needs to pay attention to netlink notifications=
.
> > > Shouldn't apply to *vlans?
> >
> > No, this shouldn't apply to *vlans, but I didn't suggest that it should=
.
>
> Good, so if we just target *vlans we don't have to worry.
>
> > I don't think my proposal was clear enough, so here's some code
> > (untested, written in email client).
> >
> > static int macvlan_hwtstamp_get(struct net_device *dev,
> >                               struct kernel_hwtstamp_config *cfg,
> >                               struct netlink_ext_ack *extack)
> > {
> >       struct net_device *real_dev =3D macvlan_dev_real_dev(dev);
> >
> >       return generic_hwtstamp_get_lower(real_dev, cfg, extack);
> > }
> >
> > static int macvlan_hwtstamp_set(struct net_device *dev,
> >                               struct kernel_hwtstamp_config *cfg,
> >                               struct netlink_ext_ack *extack)
> > {
> >       struct net_device *real_dev =3D macvlan_dev_real_dev(dev);
> >
> >       return generic_hwtstamp_set_lower(real_dev, cfg, extack);
> > }
> >
> > static int vlan_hwtstamp_get(struct net_device *dev,
> >                            struct kernel_hwtstamp_config *cfg,
> >                            struct netlink_ext_ack *extack)
> > {
> >       struct net_device *real_dev =3D vlan_dev_priv(dev)->real_dev;
> >
> >       return generic_hwtstamp_get_lower(real_dev, cfg, extack);
> > }
> >
> > static int vlan_hwtstamp_set(struct net_device *dev,
> >                            struct kernel_hwtstamp_config *cfg,
> >                            struct netlink_ext_ack *extack)
> > {
> >       struct net_device *real_dev =3D vlan_dev_priv(dev)->real_dev;
> >
> >       return generic_hwtstamp_set_lower(real_dev, cfg, extack);
> > }
>
> I got that, but why wouldn't this not be better, as it avoids
> the 3 driver stubs? (also written in the MUA)
>
> int net_lower_hwtstamp_set(struct net_device *dev,
>                            struct kernel_hwtstamp_config *cfg,
>                            struct netlink_ext_ack *extack)
> {
>         struct list_head *iter =3D dev->adj_list.lower.next;
>         struct net_device *lower;
>
>         lower =3D netdev_lower_get_next(dev, &iter);
>         return generic_hwtstamp_set_lower(lower, cfg, extack);
> }
>
> > static int bond_hwtstamp_get(struct net_device *bond_dev,
> >                            struct kernel_hwtstamp_config *cfg,
> >                            struct netlink_ext_ack *extack)
> > {
> >       struct bonding *bond =3D netdev_priv(bond_dev);
> >       struct net_device *real_dev =3D bond_option_active_slave_get_rcu(=
bond);
> >       int err;
> >
> >       if (!real_dev)
> >               return -EOPNOTSUPP;
> >
> >       err =3D generic_hwtstamp_get_lower(real_dev, cfg, extack);
> >       if (err)
> >               return err;
> >
> >       /* Set the BOND_PHC_INDEX flag to notify user space */
> >       cfg->flags |=3D HWTSTAMP_FLAG_BONDED_PHC_INDEX;
> >
> >       return 0;
> > }
> >
> > static int bond_hwtstamp_set(struct net_device *bond_dev,
> >                            struct kernel_hwtstamp_config *cfg,
> >                            struct netlink_ext_ack *extack)
> > {
> >       struct bonding *bond =3D netdev_priv(bond_dev);
> >       struct net_device *real_dev =3D bond_option_active_slave_get_rcu(=
bond);
> >       int err;
> >
> >       if (!real_dev)
> >               return -EOPNOTSUPP;
> >
> >       if (!(cfg->flags & HWTSTAMP_FLAG_BONDED_PHC_INDEX))
> >               return -EOPNOTSUPP;
> >
> >       return generic_hwtstamp_set_lower(real_dev, cfg, extack);
> > }
> >
> > Doesn't seem in any way necessary to complicate things with the netdev
> > adjacence lists?
>
> What is the complication? We can add a "get first" helper maybe to hide
> the oddities of the linking.
>
> > > Yes, user space must be involved anyway, because the entire clock wil=
l
> > > change. IMHO implementing the pass thru for timestamping requests on
> > > bonding is checkbox engineering, kernel can't make it work
> > > transparently. But nobody else spoke up when it was proposed so...
> >
> > ok, but that's a bit beside the point here.
>
> You cut off the quote it was responding to so IDK if it is.

I tried my best to follow the discussion, and convert it to compilable code=
.
Here is what I have in mind for generic_hwtstamp_get_lower():

int generic_hwtstamp_get_lower(struct net_dev *dev,
                           struct kernel_hwtstamp_config *kernel_cfg,
                           struct netlink_ext_ack *extack)
{
        const struct net_device_ops *ops =3D dev->netdev_ops;
        struct hwtstamp_config cfg;
        int err;

        if (!netif_device_present(dev))
                return -ENODEV;

        if (ops->ndo_hwtstamp_get)
                return ops->ndo_hwtstamp_get(dev, cfg, extack);

        if (!cfg->ifr)
                return -EOPNOTSUPP;

        err =3D dev_eth_ioctl(dev, cfg->ifr, SIOCGHWTSTAMP);
        if (err)
            return err;

        if (copy_from_user(&cfg, cfg->ifr->ifr_data, sizeof(cfg)))
                return -EFAULT;

        hwtstamp_config_to_kernel(kernel_cfg, &cfg);

        return 0;
}

It looks like there is a possibility that the returned hwtstamp_config stru=
cture
will be copied twice to ifr and copied once from ifr on the return path
in case if the underlying driver does not implement ndo_hwtstamp_get():
- the underlying driver calls copy_to_user() inside its ndo_eth_ioctl()
  implementation to return the data to generic_hwtstamp_get_lower();
- then generic_hwtstamp_get_lower() calls copy_from_user() to copy it
  back out of the ifr to kernel_hwtstamp_config structure;
- then dev_get_hwtstamp() calls copy_to_user() again to update
  the same ifr with the same data the ifr already contains.

Should we consider this acceptable?
