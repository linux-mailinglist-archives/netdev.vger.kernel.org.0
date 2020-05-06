Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B261F1C656F
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 03:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgEFBU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 21:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729457AbgEFBU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 21:20:57 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921D4C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 18:20:55 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id a2so50778ejx.5
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 18:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZW2zVi7mfltwMEfzDszXfsTnO2qWA/hvU/i0zf0j304=;
        b=oOPUOHPv+NEAcwxt4YTHrIlw8XASKcCNGLCpfA2IN+NlWN4EhHAWoDVT0BYmkYGFm8
         dla8Ij7dYR91H9bAN73gbFtW2QnXyx9QVbsrzTyGS/45UlwdHYqLkUCylwmwluweHwRk
         VKw5gG6mgbwtZkYaY2aPLQ5b9Rl5SIX58AI9Zy04QeW5+Mou6gPJkbkDzCP2SLTypm1f
         MBvU/ZCvlgzGqtouLcui+qX1rFpc5Ni7gnUAxYQRvAh+ZAUxa5B3kAU/L5wf61x/oFOP
         N0DQsa6cbE/cnbJyqw2U8sCIQhCSJqaHUqUxZ5uEOWPITX+j7dJEqknsUNny44EqdNbH
         IAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZW2zVi7mfltwMEfzDszXfsTnO2qWA/hvU/i0zf0j304=;
        b=ntD2oAYRGFTzuyNSYD1Vq7SJ54QYX0PiS01pqE7L04vH64Ys/3RZSVtBVMzUfSzKpb
         uSesIPCjz6c13kmyYbLW7ixdX32S/IDL8icmplTwFz38PXJsx8xFMQC1huglT2XEooX+
         +294ZB7BK8Y8WWFK78/0tU62xXXMnFfGKvIPqzl/mLhWU/NGybhC1ZB5r2izUQczUA9V
         VjufQkAy0DUeBPyYesa6Rso6UQjYwY5Az+ge4j3pXOb6ZXaM5KQQacxtex4DTIngBVo5
         madwEeUlDh5euZGXvPFVefcy7u5jXCrZjVPEPDDOfVO1KB1OnAi3zW+VYnjLcXj3SKfP
         BDKQ==
X-Gm-Message-State: AGi0PuY9ceRB3N76V+TXSHoeJt1PZlzDKfoqwDwmRxOw99BjKvYwLg/P
        1AoDK1doM3PkxZ9rtUdppvSOkJALhc3N5kr7amM=
X-Google-Smtp-Source: APiQypLA/uOx7TixEg2QSsxUGTeRh8zwjjGbrvwh9FvVPXNgZ+F0fhkD3NvuCvrhdZZjlFm1MqgvJGCCzj9HGVucfPE=
X-Received: by 2002:a17:906:355b:: with SMTP id s27mr5330805eja.184.1588728054126;
 Tue, 05 May 2020 18:20:54 -0700 (PDT)
MIME-Version: 1.0
References: <1588051455-42828-1-git-send-email-xiangxia.m.yue@gmail.com> <0de430f3-a3a8-24d0-caf7-b6ee657c83bd@mellanox.com>
In-Reply-To: <0de430f3-a3a8-24d0-caf7-b6ee657c83bd@mellanox.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 6 May 2020 09:20:17 +0800
Message-ID: <CAMDZJNUy5T-vz2j_+egPQQEuHo=tJDbswmZk7Nf1ycy6p2bf_Q@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net/mlx5e: Implicitly decap the tunnel
 packet when necessary
To:     Roi Dayan <roid@mellanox.com>
Cc:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 11:26 PM Roi Dayan <roid@mellanox.com> wrote:
>
>
>
> On 2020-04-28 8:24 AM, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > The commit 0a7fcb78cc21 ("net/mlx5e: Support inner header rewrite with
> > goto action"), will decapitate the tunnel packets if there is a goto
> > action in chain 0. But in some case, we don't want do that, for example:
>
> Hi Zhang,
>
> Thanks for your commit. i'll run more tests so i might have some comments later.
> Can you use decapsulate instead of decapitate please.
>
> >
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0    \
> >       flower enc_dst_ip 2.2.2.100 enc_dst_port 4789                   \
> >       action goto chain 2
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2    \
> >       flower dst_mac 00:11:22:33:44:55 enc_src_ip 2.2.2.200           \
> >       enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 100           \
> >       action tunnel_key unset action mirred egress redirect dev enp130s0f0_0
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2    \
> >       flower dst_mac 00:11:22:33:44:66 enc_src_ip 2.2.2.200           \
> >       enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 200           \
> >       action tunnel_key unset action mirred egress redirect dev enp130s0f0_1
> >
> > In this patch, if there is a pedit action in chain, do the decapitation action.
>
> decapsulation
>
> > if there are pedit and goto actions, do the decapitation and id mapping action.
> >
> > 8 test units:
> > [1]:
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0    \
> >       flower enc_dst_ip 2.2.2.100 enc_dst_port 4789                   \
> >       action goto chain 2
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2    \
> >       flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
> >       enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
> >       action tunnel_key unset \
> >       action mirred egress redirect dev enp130s0f0_0
> > [2]:
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0    \
> >       flower enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 100    \
> >       action goto chain 2
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2    \
> >       flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
> >       enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
> >       action pedit ex munge eth src set 00:11:22:33:44:f0             \
> >       action mirred egress redirect dev enp130s0f0_0
> > [3]:
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0    \
> >       flower enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 100    \
> >       action goto chain 2
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2    \
> >       flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
> >       enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
> >       action tunnel_key unset \
> >       action pedit ex munge eth src set 00:11:22:33:44:f0             \
> >       action mirred egress redirect dev enp130s0f0_0
> > [4]:
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0    \
> >       flower enc_dst_ip 2.2.2.100 enc_dst_port 4789                   \
> >       enc_key_id 100 dst_mac 00:11:22:33:44:55                        \
> >       action pedit ex munge eth src set 00:11:22:33:44:ff pipe        \
> >       action mirred egress redirect dev enp130s0f0_0
>
> what about the case of only chain 0 without pedit?
> I think now we skip matching tun? see comment below in parse_tunnel_attr().
>
> > [5]:
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0    \
> >       flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
> >       enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
> >       action pedit ex munge eth src set 00:11:22:33:44:ff             \
> >       action goto chain 2
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2    \
> >       flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
> >       enc_dst_port 4789 enc_key_id 100 src_mac 00:11:22:33:44:ff      \
> >       action tunnel_key unset \
> >       action mirred egress redirect dev enp130s0f0_0
> > [6]:
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0    \
> >       flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
> >       enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
> >       action pedit ex munge eth src set 00:11:22:33:44:ff             \
> >       action goto chain 2
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2    \
> >       flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
> >       enc_dst_port 4789 enc_key_id 100 src_mac 00:11:22:33:44:ff      \
> >       action tunnel_key unset \
> >       action pedit ex munge eth src set 00:11:22:33:44:f0             \
> >       action mirred egress redirect dev enp130s0f0_0
> > [7]:
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0    \
> >       flower  enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100               \
> >       enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
> >       action pedit ex munge eth src set 00:11:22:33:44:ff             \
> >       action goto chain 2
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2    \
> >       flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
> >       enc_dst_port 4789 enc_key_id 100 src_mac 00:11:22:33:44:ff      \
> >       action pedit ex munge eth src set 00:11:22:33:44:f0             \
> >       action goto chain 3
> > $ tc filter add dev vxlan0 protocol ip parent ffff: prio 1 chain 3    \
> >       flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
> >       enc_dst_port 4789 enc_key_id 100 src_mac 00:11:22:33:44:f0      \
> >       action tunnel_key unset \
> >       action pedit ex munge eth src set 00:11:22:33:44:f1             \
> >       action mirred egress redirect dev enp130s0f0_0
> > [8]:
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0    \
> >       flower enc_dst_ip 2.2.2.100 enc_dst_port 4789                   \
> >       action goto chain 2
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2    \
> >       flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
> >       enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
> >       action pedit ex munge eth src set 00:11:22:33:44:f0             \
> >       action goto chain 3
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 3    \
> >       flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
> >       enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
> >       action pedit ex munge eth src set 00:11:22:33:44:f1             \
> >       action goto chain 4
> > $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 4    \
> >       flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
> >       enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
> >       action pedit ex munge eth src set 00:11:22:33:44:f2             \
> >       action mirred egress redirect dev enp130s0f0_0
> >
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> >  .../net/ethernet/mellanox/mlx5/core/en/mapping.c   | 24 ++++++
> >  .../net/ethernet/mellanox/mlx5/core/en/mapping.h   |  1 +
> >  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 97 +++++++++++++++-------
> >  3 files changed, 92 insertions(+), 30 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c
> > index ea321e528749..90306dde6b60 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c
> > @@ -74,6 +74,30 @@ int mapping_add(struct mapping_ctx *ctx, void *data, u32 *id)
> >       return err;
> >  }
> >
> > +int mapping_find_by_data(struct mapping_ctx *ctx, void *data, u32 *id)
> > +{
> > +     struct mapping_item *mi;
> > +     u32 hash_key;
> > +
> > +     mutex_lock(&ctx->lock);
> > +
> > +     hash_key = jhash(data, ctx->data_size, 0);
> > +     hash_for_each_possible(ctx->ht, mi, node, hash_key) {
> > +             if (!memcmp(data, mi->data, ctx->data_size))
> > +                     goto found;
> > +     }
> > +
> > +     mutex_unlock(&ctx->lock);
> > +     return -ENOENT;
> > +
> > +found:
> > +     if (id)
> > +             *id = mi->id;
> > +
> > +     mutex_unlock(&ctx->lock);
> > +     return 0;
> > +}
> > +
> >  static void mapping_remove_and_free(struct mapping_ctx *ctx,
> >                                   struct mapping_item *mi)
> >  {
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h
> > index 285525cc5470..af501c9796b7 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h
> > @@ -9,6 +9,7 @@
> >  int mapping_add(struct mapping_ctx *ctx, void *data, u32 *id);
> >  int mapping_remove(struct mapping_ctx *ctx, u32 id);
> >  int mapping_find(struct mapping_ctx *ctx, u32 id, void *data);
> > +int mapping_find_by_data(struct mapping_ctx *ctx, void *data, u32 *id);
> >
> >  /* mapping uses an xarray to map data to ids in add(), and for find().
> >   * For locking, it uses a internal xarray spin lock for add()/remove(),
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > index a574c588269a..64f5c3f3dbb3 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > @@ -1786,7 +1786,8 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
> >       }
> >  }
> >
> > -static int flow_has_tc_fwd_action(struct flow_cls_offload *f)
> > +static int flow_has_tc_action(struct flow_cls_offload *f,
> > +                           enum flow_action_id action)
> >  {
> >       struct flow_rule *rule = flow_cls_offload_flow_rule(f);
> >       struct flow_action *flow_action = &rule->action;
> > @@ -1794,12 +1795,8 @@ static int flow_has_tc_fwd_action(struct flow_cls_offload *f)
> >       int i;
> >
> >       flow_action_for_each(i, act, flow_action) {
> > -             switch (act->id) {
> > -             case FLOW_ACTION_GOTO:
> > +             if (act->id == action)
> >                       return true;
> > -             default:
> > -                     continue;
> > -             }
> >       }
> >
> >       return false;
> > @@ -1853,10 +1850,37 @@ static int flow_has_tc_fwd_action(struct flow_cls_offload *f)
> >              sizeof(*__dst));\
> >  })
> >
> > +static void mlx5e_make_tunnel_match_key(struct flow_cls_offload *f,
> > +                                     struct net_device *filter_dev,
> > +                                     struct tunnel_match_key *tunnel_key)
> > +{
> > +     struct flow_rule *rule = flow_cls_offload_flow_rule(f);
> > +
> > +     memset(tunnel_key, 0, sizeof(*tunnel_key));
> > +     COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL,
> > +                    &tunnel_key->enc_control);
> > +     if (tunnel_key->enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS)
> > +             COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
> > +                            &tunnel_key->enc_ipv4);
> > +     else
> > +             COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS,
> > +                            &tunnel_key->enc_ipv6);
> > +
> > +     COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IP, &tunnel_key->enc_ip);
> > +     COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_PORTS,
> > +                    &tunnel_key->enc_tp);
> > +     COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_KEYID,
> > +                    &tunnel_key->enc_key_id);
> > +
> > +     tunnel_key->filter_ifindex = filter_dev->ifindex;
> > +}
> > +
> >  static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
> >                                   struct mlx5e_tc_flow *flow,
> >                                   struct flow_cls_offload *f,
> > -                                 struct net_device *filter_dev)
> > +                                 struct net_device *filter_dev,
> > +                                 bool sets_mapping,
> > +                                 bool needs_mapping)
> >  {
> >       struct flow_rule *rule = flow_cls_offload_flow_rule(f);
> >       struct netlink_ext_ack *extack = f->common.extack;
> > @@ -1876,22 +1900,7 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
> >       uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
> >       uplink_priv = &uplink_rpriv->uplink_priv;
> >
> > -     memset(&tunnel_key, 0, sizeof(tunnel_key));
> > -     COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL,
> > -                    &tunnel_key.enc_control);
> > -     if (tunnel_key.enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS)
> > -             COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
> > -                            &tunnel_key.enc_ipv4);
> > -     else
> > -             COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS,
> > -                            &tunnel_key.enc_ipv6);
> > -     COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IP, &tunnel_key.enc_ip);
> > -     COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_PORTS,
> > -                    &tunnel_key.enc_tp);
> > -     COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_KEYID,
> > -                    &tunnel_key.enc_key_id);
> > -     tunnel_key.filter_ifindex = filter_dev->ifindex;
> > -
> > +     mlx5e_make_tunnel_match_key(f, filter_dev, &tunnel_key);
> >       err = mapping_add(uplink_priv->tunnel_mapping, &tunnel_key, &tun_id);
> >       if (err)
> >               return err;
> > @@ -1915,10 +1924,10 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
> >       mask = enc_opts_id ? TUNNEL_ID_MASK :
> >                            (TUNNEL_ID_MASK & ~ENC_OPTS_BITS_MASK);
> >
> > -     if (attr->chain) {
> > +     if (needs_mapping) {
> >               mlx5e_tc_match_to_reg_match(&attr->parse_attr->spec,
> >                                           TUNNEL_TO_REG, value, mask);
> > -     } else {
> > +     } else if (sets_mapping) {
> >               mod_hdr_acts = &attr->parse_attr->mod_hdr_acts;
> >               err = mlx5e_tc_match_to_reg_set(priv->mdev,
> >                                               mod_hdr_acts,
> > @@ -1941,6 +1950,25 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
> >       return err;
> >  }
> >
> > +static int mlx5e_lookup_flow_tunnel_id(struct mlx5e_priv *priv,
> > +                                    struct mlx5e_tc_flow *flow,
> > +                                    struct flow_cls_offload *f,
> > +                                    struct net_device *filter_dev,
> > +                                    u32 *tun_id)
> > +{
> > +     struct mlx5_rep_uplink_priv *uplink_priv;
> > +     struct mlx5e_rep_priv *uplink_rpriv;
> > +     struct tunnel_match_key tunnel_key;
> > +     struct mlx5_eswitch *esw;
> > +
> > +     esw = priv->mdev->priv.eswitch;
> > +     uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
> > +     uplink_priv = &uplink_rpriv->uplink_priv;
> > +
> > +     mlx5e_make_tunnel_match_key(f, filter_dev, &tunnel_key);
> > +     return mapping_find_by_data(uplink_priv->tunnel_mapping, &tunnel_key, tun_id);
> > +}
> > +
> >  static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow)
> >  {
> >       u32 enc_opts_id = flow->tunnel_id & ENC_OPTS_BITS_MASK;
> > @@ -1976,14 +2004,22 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
> >       struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
> >       struct netlink_ext_ack *extack = f->common.extack;
> >       bool needs_mapping, sets_mapping;
> > +     bool pedit_action;
> >       int err;
> >
> >       if (!mlx5e_is_eswitch_flow(flow))
> >               return -EOPNOTSUPP;
> >
> > -     needs_mapping = !!flow->esw_attr->chain;
> > -     sets_mapping = !flow->esw_attr->chain && flow_has_tc_fwd_action(f);
> > -     *match_inner = !needs_mapping;
> > +     pedit_action = flow_has_tc_action(f, FLOW_ACTION_MANGLE) ||
> > +                    flow_has_tc_action(f, FLOW_ACTION_ADD);
> > +
> > +     *match_inner = pedit_action;
> > +     sets_mapping = pedit_action &&
> > +                    flow_has_tc_action(f, FLOW_ACTION_GOTO);
> > +
> > +     needs_mapping = !!flow->esw_attr->chain &&
> > +                     !mlx5e_lookup_flow_tunnel_id(priv, flow, f,
> > +                                                  filter_dev, NULL);
> >
> >       if ((needs_mapping || sets_mapping) &&
> >           !mlx5_eswitch_reg_c1_loopback_enabled(esw)) {
> > @@ -1994,7 +2030,7 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
> >               return -EOPNOTSUPP;
> >       }
> >
> > -     if (!flow->esw_attr->chain) {
> > +     if (*match_inner && !needs_mapping) {
>
> why you only get inside for match_inner?
> what about the case of matching tunnel on chain 0 without pedit action?
Oh, sorry, I forget that case, I change the codes:
+       tunnel_decap = flow_has_tc_action(f, FLOW_ACTION_TUNNEL_DECAP);
+
+       *match_inner = pedit_action || tunnel_decap;

and all cases were tested, and I will sent v2. Thanks

> we need to call mlx5e_tc_tun_parse()
>
> >               err = mlx5e_tc_tun_parse(filter_dev, priv, spec, f,
> >                                        match_level);
> >               if (err) {
> > @@ -2011,7 +2047,8 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
> >       if (!needs_mapping && !sets_mapping)
> >               return 0;
> >
> > -     return mlx5e_get_flow_tunnel_id(priv, flow, f, filter_dev);
> > +     return mlx5e_get_flow_tunnel_id(priv, flow, f, filter_dev,
> > +                                     sets_mapping, needs_mapping);
> >  }
> >
> >  static void *get_match_inner_headers_criteria(struct mlx5_flow_spec *spec)
> >



-- 
Best regards, Tonghao
