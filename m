Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6DF850B59B
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446919AbiDVK4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446922AbiDVK4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:56:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4661F56206
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650624831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xnZQyjU9xLrcnPEW5DCyWO9xAj19XuZuuuLLzK36tiE=;
        b=GyulpDVy8r98UTV7JtGRzjRGPeCBvI27/yYV3tqO//ZJwJFn+XhH4b/OSb3t/TAavg8bCH
        QZqCLNS/rLNo/K4T+ImZB/Urx+ZqEfushHiyy/g96VDhDvMbxAmf60oE6sdr60Avq5j7lv
        FJT6DxViKfGaC6FNKgvQyoK0VFNdCio=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-rf8M-UHDOTyESAZLevxzLA-1; Fri, 22 Apr 2022 06:53:50 -0400
X-MC-Unique: rf8M-UHDOTyESAZLevxzLA-1
Received: by mail-wr1-f69.google.com with SMTP id j30-20020adfb31e000000b0020a9043abd7so1774834wrd.12
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:53:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xnZQyjU9xLrcnPEW5DCyWO9xAj19XuZuuuLLzK36tiE=;
        b=JYV6gL2yl6XZ3JO97JthljPdDYEb4D7oljgBPmXnxeOHWsY3YjmnnkzOIFZ/rSutKc
         EEIFw1f5K273syuVs2E4WJtVOt+FDJjsHmzmX4khQwYy5ZbuhHjasNhyB7wbXGgGxbFM
         Qf8prdqLqFVDvZdQ23RypkU7FakRkhBo6nO+4jLt3Z2kRj0dsEJ+Y5nixyzALYqAVFyc
         /j3730SarJElTSEoHb53R6D7OaWmfXKliQZDL+YfExs6Pntp/vevT2GliEgoWMeGWMJz
         RSoZO14lHjfKLBmdtJLEsIo5GF+aNYok0MVhPAWkBiebCR+hJ3yuSnYEIzXLAT1d5Igg
         IVPg==
X-Gm-Message-State: AOAM530+agFVTOLLRFtKyBHD2mN6ho6CwvixRLQCaNO0Ox4VSK5fpz+3
        rh+o3gnvOfwbJiaPNV2WKlGhXSdclG7WuHI3SFK85yKFSteh1ySjgNglwLtVElXvxSWT1lqy5HL
        EyUDb1aRSa0END0nB
X-Received: by 2002:adf:cd87:0:b0:207:b0ad:6d8 with SMTP id q7-20020adfcd87000000b00207b0ad06d8mr3262433wrj.111.1650624828866;
        Fri, 22 Apr 2022 03:53:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhZcxDAj12VbxxvIv7PfzuGYSITpF+VJ1aomZhKgHA709UnEMd1+DWF424CTMMMxjLYrAjUw==
X-Received: by 2002:adf:cd87:0:b0:207:b0ad:6d8 with SMTP id q7-20020adfcd87000000b00207b0ad06d8mr3262419wrj.111.1650624828639;
        Fri, 22 Apr 2022 03:53:48 -0700 (PDT)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id v13-20020adfe28d000000b0020375f27a5asm1534993wri.4.2022.04.22.03.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 03:53:47 -0700 (PDT)
Date:   Fri, 22 Apr 2022 12:53:45 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dccp@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] ipv4: Don't reset ->flowi4_scope in
 ip_rt_fix_tos().
Message-ID: <20220422105345.GA15621@debian.home>
References: <cover.1650470610.git.gnault@redhat.com>
 <c3fdfe3353158c9b9da14602619fb82db5e77f27.1650470610.git.gnault@redhat.com>
 <0d4e27ee-385c-fd5d-bd31-51e9e2382667@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d4e27ee-385c-fd5d-bd31-51e9e2382667@kernel.org>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 08:30:52PM -0600, David Ahern wrote:
> On 4/20/22 5:21 PM, Guillaume Nault wrote:
> > All callers already initialise ->flowi4_scope with RT_SCOPE_UNIVERSE,
> > either by manual field assignment, memset(0) of the whole structure or
> > implicit structure initialisation of on-stack variables
> > (RT_SCOPE_UNIVERSE actually equals 0).
> > 
> > Therefore, we don't need to always initialise ->flowi4_scope in
> > ip_rt_fix_tos(). We only need to reduce the scope to RT_SCOPE_LINK when
> > the special RTO_ONLINK flag is present in the tos.
> > 
> > This will allow some code simplification, like removing
> > ip_rt_fix_tos(). Also, the long term idea is to remove RTO_ONLINK
> > entirely by properly initialising ->flowi4_scope, instead of
> > overloading ->flowi4_tos with a special flag. Eventually, this will
> > allow to convert ->flowi4_tos to dscp_t.
> > 
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> > ---
> > It's important for the correctness of this patch that all callers
> > initialise ->flowi4_scope to 0 (in one way or another). Auditing all of
> > them is long, although each case is pretty trivial.
> > 
> > If it helps, I can send a patch series that converts implicit
> > initialisation of ->flowi4_scope with an explicit assignment to
> > RT_SCOPE_UNIVERSE. This would also have the advantage of making it
> > clear to future readers that ->flowi4_scope _has_ to be initialised. I
> > haven't sent such patch series to not overwhelm reviewers with trivial
> > and not technically-required changes (there are 40+ places to modify,
> > scattered over 30+ different files). But if anyone prefers explicit
> > initialisation everywhere, then just let me know and I'll send such
> > patches.
> 
> There are a handful of places that open code the initialization of the
> flow struct. I *think* I found all of them in 40867d74c374.

By open code, do you mean "doesn't use flowi4_init_output() nor
ip_tunnel_init_flow()"? If so, I think there are many more.

To be sure we're on the same page, here's a small part of the diff for
my "explicit flowi4_scope initialisation" patch series:

 drivers/infiniband/core/addr.c                          | 1 +
 drivers/infiniband/sw/rxe/rxe_net.c                     | 1 +
 drivers/net/amt.c                                       | 3 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c            | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c     | 3 +++
 drivers/net/ethernet/netronome/nfp/flower/action.c      | 1 +
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c | 7 +++++--
 drivers/net/geneve.c                                    | 9 +++++++--
 drivers/net/gtp.c                                       | 1 +
 drivers/net/ipvlan/ipvlan_core.c                        | 1 +
 drivers/net/vrf.c                                       | 1 +
 drivers/net/vxlan/vxlan_core.c                          | 1 +
 drivers/net/wireguard/socket.c                          | 1 +
 include/net/ip_tunnels.h                                | 1 +
 include/net/route.h                                     | 2 ++
 net/core/filter.c                                       | 1 +
 net/core/lwt_bpf.c                                      | 1 +
 net/dccp/ipv4.c                                         | 1 +
 net/ipv4/icmp.c                                         | 3 +++
 net/ipv4/netfilter.c                                    | 1 +
 net/ipv4/netfilter/nf_reject_ipv4.c                     | 1 +
 net/ipv4/route.c                                        | 1 +
 net/ipv4/xfrm4_policy.c                                 | 1 +
 net/netfilter/ipvs/ip_vs_xmit.c                         | 1 +
 net/netfilter/nf_conntrack_h323_main.c                  | 3 +++
 net/netfilter/nf_conntrack_sip.c                        | 1 +
 net/netfilter/nft_flow_offload.c                        | 1 +
 net/netfilter/nft_rt.c                                  | 1 +
 net/netfilter/xt_TCPMSS.c                               | 2 ++
 net/sctp/protocol.c                                     | 1 +
 net/smc/smc_ib.c                                        | 1 +
 net/tipc/udp_media.c                                    | 1 +
 net/xfrm/xfrm_policy.c                                  | 1 +
 33 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index f253295795f0..5b6e0003eead 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -399,6 +399,7 @@ static int addr4_resolve(struct sockaddr *src_sock,
        memset(&fl4, 0, sizeof(fl4));
        fl4.daddr = dst_ip;
        fl4.saddr = src_ip;
+       fl4.flowi4_scope = RT_SCOPE_UNIVERSE;
        fl4.flowi4_oif = addr->bound_dev_if;
        rt = ip_route_output_key(addr->net, &fl4);
        ret = PTR_ERR_OR_ZERO(rt);
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index c53f4529f098..cf6dc89a8785 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -31,6 +31,7 @@ static struct dst_entry *rxe_find_route4(struct net_device *ndev,
        fl.flowi4_oif = ndev->ifindex;
        memcpy(&fl.saddr, saddr, sizeof(*saddr));
        memcpy(&fl.daddr, daddr, sizeof(*daddr));
+       fl.flowi4_scope = RT_SCOPE_UNIVERSE;
        fl.flowi4_proto = IPPROTO_UDP;
 
        rt = ip_route_output_key(&init_net, &fl);
diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 10455c9b9da0..3e957ff64715 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -990,6 +990,7 @@ static bool amt_send_membership_update(struct amt_dev *amt,
        fl4.daddr              = amt->remote_ip;
        fl4.saddr              = amt->local_ip;
        fl4.flowi4_tos         = AMT_TOS;
+       fl4.flowi4_scope       = RT_SCOPE_UNIVERSE;
        fl4.flowi4_proto       = IPPROTO_UDP;
        rt = ip_route_output_key(amt->net, &fl4);
        if (IS_ERR(rt)) {
@@ -1048,6 +1049,7 @@ static void amt_send_multicast_data(struct amt_dev *amt,
        fl4.flowi4_oif         = amt->stream_dev->ifindex;
        fl4.daddr              = tunnel->ip4;
        fl4.saddr              = amt->local_ip;
+       fl4.flowi4_scope       = RT_SCOPE_UNIVERSE;
        fl4.flowi4_proto       = IPPROTO_UDP;
        rt = ip_route_output_key(amt->net, &fl4);
        if (IS_ERR(rt)) {
@@ -1103,6 +1105,7 @@ static bool amt_send_membership_query(struct amt_dev *amt,
        fl4.daddr              = tunnel->ip4;
        fl4.saddr              = amt->local_ip;
        fl4.flowi4_tos         = AMT_TOS;
+       fl4.flowi4_scope       = RT_SCOPE_UNIVERSE;
        fl4.flowi4_proto       = IPPROTO_UDP;
        rt = ip_route_output_key(amt->net, &fl4);
        if (IS_ERR(rt)) {
...

> > ---
> >  net/ipv4/route.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index e839d424b861..d8f82c0ac132 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -503,8 +503,8 @@ static void ip_rt_fix_tos(struct flowi4 *fl4)
> >  	__u8 tos = RT_FL_TOS(fl4);
> >  
> >  	fl4->flowi4_tos = tos & IPTOS_RT_MASK;
> > -	fl4->flowi4_scope = tos & RTO_ONLINK ?
> > -			    RT_SCOPE_LINK : RT_SCOPE_UNIVERSE;
> > +	if (tos & RTO_ONLINK)
> > +		fl4->flowi4_scope = RT_SCOPE_LINK;
> >  }
> >  
> >  static void __build_flow_key(const struct net *net, struct flowi4 *fl4,
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>
> 

