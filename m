Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B0FBA2A1
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 14:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbfIVMgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 08:36:10 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42452 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728905AbfIVMgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 08:36:10 -0400
Received: by mail-lj1-f196.google.com with SMTP id y23so11064866lje.9
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 05:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jmzpJzY0d/P7Ym5PAFaOvFwpdEAEFppuJ7iWLWk8KCw=;
        b=cbHFmcv6/bXBK6r6XFiG1AF3dzZgtyDuw5MqfUokf24orrGJLt3cbf0kXn08plGQpP
         UzEGd8crEYxS+DxwH8b1izlFMX1zqJL9S6ZUwlVreU7RfbfVoXhtABPKilaz7N1+yIoH
         OP6WqAdO+mLKgGJ6KfBD85QuVWyz0Xd8LMQ7cU3WYtQpYDjqCSRsegouAgHYe2me+eiE
         psd6RPAEVUHrOQxBsdw0K8rX1YUPOyBYAgk1wxCCWX6XujraK2IzSZfQGJ+zM32gaRzZ
         0Ua3f41JSYMt3TtSEsJ7knR+icCy0BPAD4iOP2AuaPgV6ggoE65fxXwDLpYYHy22mG4T
         8UxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jmzpJzY0d/P7Ym5PAFaOvFwpdEAEFppuJ7iWLWk8KCw=;
        b=uOHC9efVcAsJrNd0VqPz3vRI4Rh4CkWor5/NtV1xl6YhlkNe4u6ATSfoy34yus1yGk
         XGBz437eODfENAPl27VuJ+GdA50LChWShOM/PSyRPwiAFD3tmLo656I9nfgTGaD+R36E
         2/owYQp4/0t7N0TZS1BfmAfZr2y9zD2+lAcifWKWHqzpyzc5V8O4qfeUbnUI9a1NcJsG
         3xzU7ccUvifzSmUkvy+Y6xeuA+mjZMQDjnUN+tS07oK5r/zuxRpcRaW/3i7mLwTIPMsO
         ol8GL5NS70n/CU6oITuCN0huiarSgp01TP09WoMcb/wSFgvHN1Jq0Gx6k/jCg5kkR12a
         NStg==
X-Gm-Message-State: APjAAAVZH7idDkbwra98a4qR6sGdEkZKXLDIqa63A6cloNshBNJtRqh8
        ilnAOqRQers0Vrxt5e0FpV2Y/iqNxBYYmXtCOHQ=
X-Google-Smtp-Source: APXvYqx+PrOXvI0AFKSPOVpOZgiuLnquuCynXNFWQ1dN41FwwH4bwGQBTjJhrvVm+qPMtwITLivCBRNvoytX9OEeAwE=
X-Received: by 2002:a2e:9185:: with SMTP id f5mr6554278ljg.235.1569155766987;
 Sun, 22 Sep 2019 05:36:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190916134802.8252-1-ap420073@gmail.com> <20190916134802.8252-11-ap420073@gmail.com>
 <20190920164816.55a77053@cakuba.netronome.com>
In-Reply-To: <20190920164816.55a77053@cakuba.netronome.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 22 Sep 2019 21:35:55 +0900
Message-ID: <CAMArcTV04jucf9jV8GtWvq55=Ly0-AwObPSn+4C+o2QH=j94Lw@mail.gmail.com>
Subject: Re: [PATCH net v3 10/11] vxlan: add adjacent link to limit depth level
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, j.vosburgh@gmail.com,
        vfalico@gmail.com, Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Sep 2019 at 08:48, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>

Hi Jakub,
Thank you so much for your detailed review!

> On Mon, 16 Sep 2019 22:48:01 +0900, Taehee Yoo wrote:
> > Current vxlan code doesn't limit the number of nested devices.
> > Nested devices would be handled recursively and this routine needs
> > huge stack memory. So, unlimited nested devices could make
> > stack overflow.
> >
> > In order to fix this issue, this patch adds adjacent links.
> > The adjacent link APIs internally check the depth level.
>
> > Fixes: acaf4e70997f ("net: vxlan: when lower dev unregisters remove vxlan dev as well")
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>
> Minor nit picks here, I hope you don't mind.
>
> > diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> > index 3d9bcc957f7d..0d5c8d22d8a4 100644
> > --- a/drivers/net/vxlan.c
> > +++ b/drivers/net/vxlan.c
> > @@ -3567,6 +3567,8 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
> >       struct vxlan_net *vn = net_generic(net, vxlan_net_id);
> >       struct vxlan_dev *vxlan = netdev_priv(dev);
> >       struct vxlan_fdb *f = NULL;
> > +     struct net_device *remote_dev = NULL;
> > +     struct vxlan_rdst *dst = &vxlan->default_dst;
>
> Especially in places where reverse christmas tree variable ordering is
> adhered to, could you please preserve it? That'd mean:
>
>         struct vxlan_net *vn = net_generic(net, vxlan_net_id);
>         struct vxlan_dev *vxlan = netdev_priv(dev);
>         struct net_device *remote_dev = NULL;
>         struct vxlan_fdb *f = NULL;
>         bool unregister = false;
>         struct vxlan_rdst *dst;
>         int err;
>
>         dst = &vxlan->default_dst;
>
> here.
>
> >       bool unregister = false;
> >       int err;
> >
> > @@ -3577,14 +3579,14 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
> >       dev->ethtool_ops = &vxlan_ethtool_ops;
> >
> >       /* create an fdb entry for a valid default destination */
> > -     if (!vxlan_addr_any(&vxlan->default_dst.remote_ip)) {
> > +     if (!vxlan_addr_any(&dst->remote_ip)) {
> >               err = vxlan_fdb_create(vxlan, all_zeros_mac,
> > -                                    &vxlan->default_dst.remote_ip,
> > +                                    &dst->remote_ip,
> >                                      NUD_REACHABLE | NUD_PERMANENT,
> >                                      vxlan->cfg.dst_port,
> > -                                    vxlan->default_dst.remote_vni,
> > -                                    vxlan->default_dst.remote_vni,
> > -                                    vxlan->default_dst.remote_ifindex,
> > +                                    dst->remote_vni,
> > +                                    dst->remote_vni,
> > +                                    dst->remote_ifindex,
> >                                      NTF_SELF, &f);
> >               if (err)
> >                       return err;
> > @@ -3595,26 +3597,43 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
> >               goto errout;
> >       unregister = true;
> >
> > +     if (dst->remote_ifindex) {
> > +             remote_dev = __dev_get_by_index(net, dst->remote_ifindex);
> > +             if (!remote_dev)
> > +                     goto errout;
> > +
> > +             err = netdev_upper_dev_link(remote_dev, dev, extack);
> > +             if (err)
> > +                     goto errout;
> > +     }
> > +
> >       err = rtnl_configure_link(dev, NULL);
> >       if (err)
> > -             goto errout;
> > +             goto unlink;
> >
> >       if (f) {
> > -             vxlan_fdb_insert(vxlan, all_zeros_mac,
> > -                              vxlan->default_dst.remote_vni, f);
> > +             vxlan_fdb_insert(vxlan, all_zeros_mac, dst->remote_vni, f);
> >
> >               /* notify default fdb entry */
> >               err = vxlan_fdb_notify(vxlan, f, first_remote_rtnl(f),
> >                                      RTM_NEWNEIGH, true, extack);
> >               if (err) {
> >                       vxlan_fdb_destroy(vxlan, f, false, false);
> > +                     if (remote_dev)
> > +                             netdev_upper_dev_unlink(remote_dev, dev);
> >                       goto unregister;
> >               }
> >       }
> >
> >       list_add(&vxlan->next, &vn->vxlan_list);
> > +     if (remote_dev) {
> > +             dst->remote_dev = remote_dev;
> > +             dev_hold(remote_dev);
> > +     }
> >       return 0;
> > -
> > +unlink:
> > +     if (remote_dev)
> > +             netdev_upper_dev_unlink(remote_dev, dev);
> >  errout:
> >       /* unregister_netdevice() destroys the default FDB entry with deletion
> >        * notification. But the addition notification was not sent yet, so
> > @@ -3936,6 +3955,8 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
> >       struct net_device *lowerdev;
> >       struct vxlan_config conf;
> >       int err;
> > +     bool linked = false;
> > +     bool disabled = false;
>
> Same here.
>
> >       err = vxlan_nl2conf(tb, data, dev, &conf, true, extack);
> >       if (err)
> > @@ -3946,6 +3967,16 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
> >       if (err)
> >               return err;
> >
> > +     if (lowerdev) {
> > +             if (dst->remote_dev && lowerdev != dst->remote_dev) {
> > +                     netdev_adjacent_dev_disable(dst->remote_dev, dev);
> > +                     disabled = true;
> > +             }
> > +             err = netdev_upper_dev_link(lowerdev, dev, extack);
> > +             if (err)
> > +                     goto err;
>
> would you mind naming the label errout? there is an err variable, and
> other places in this file use errout
>
> > +             linked = true;
> > +     }
> >       /* handle default dst entry */
> >       if (!vxlan_addr_equal(&conf.remote_ip, &dst->remote_ip)) {
> >               u32 hash_index = fdb_head_index(vxlan, all_zeros_mac, conf.vni);
> > @@ -3962,7 +3993,7 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
> >                                              NTF_SELF, true, extack);
> >                       if (err) {
> >                               spin_unlock_bh(&vxlan->hash_lock[hash_index]);
> > -                             return err;
> > +                             goto err;
> >                       }
> >               }
> >               if (!vxlan_addr_any(&dst->remote_ip))
> > @@ -3979,8 +4010,24 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
> >       if (conf.age_interval != vxlan->cfg.age_interval)
> >               mod_timer(&vxlan->age_timer, jiffies);
> >
> > +     if (disabled) {
> > +             netdev_adjacent_dev_enable(dst->remote_dev, dev);
> > +             netdev_upper_dev_unlink(dst->remote_dev, dev);
> > +             dev_put(dst->remote_dev);
> > +     }
> > +     if (linked) {
> > +             dst->remote_dev = lowerdev;
> > +             dev_hold(dst->remote_dev);
> > +     }
> > +
> >       vxlan_config_apply(dev, &conf, lowerdev, vxlan->net, true);
> >       return 0;
> > +err:
> > +     if (linked)
> > +             netdev_upper_dev_unlink(lowerdev, dev);
> > +     if (disabled)
> > +             netdev_adjacent_dev_enable(dst->remote_dev, dev);
> > +     return err;
> >  }
> >
> >  static void vxlan_dellink(struct net_device *dev, struct list_head *head)
> > @@ -3991,6 +4038,10 @@ static void vxlan_dellink(struct net_device *dev, struct list_head *head)
> >
> >       list_del(&vxlan->next);
> >       unregister_netdevice_queue(dev, head);
> > +     if (vxlan->default_dst.remote_dev) {
> > +             netdev_upper_dev_unlink(vxlan->default_dst.remote_dev, dev);
> > +             dev_put(vxlan->default_dst.remote_dev);
> > +     }
> >  }
> >
> >  static size_t vxlan_get_size(const struct net_device *dev)
> > diff --git a/include/net/vxlan.h b/include/net/vxlan.h
> > index dc1583a1fb8a..08e237d7aa73 100644
> > --- a/include/net/vxlan.h
> > +++ b/include/net/vxlan.h
> > @@ -197,6 +197,7 @@ struct vxlan_rdst {
> >       u8                       offloaded:1;
> >       __be32                   remote_vni;
> >       u32                      remote_ifindex;
> > +     struct net_device        *remote_dev;
> >       struct list_head         list;
> >       struct rcu_head          rcu;
> >       struct dst_cache         dst_cache;
>

Thank you for letting me know about "reverse christmas tree variable ordering".
I will send a v4 patch that will include things that you mentioned.

Thank you!
