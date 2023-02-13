Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62393694F5C
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjBMS2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjBMS20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:28:26 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680AB72B7
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:27:55 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id q13so14822918qtx.2
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8VNUS94Lc/dpPRyxggWsh6adTRtP7ryB0gZvNEsPsfI=;
        b=GUo8w5xVw2ZBtNArKkQD7bMXS14pwhQd1+ili/2AcnBgI8jc3copMEQ894+83rIhH1
         BrUBpG4hdOl4zW01mAnkf28JLbeWuXADVto6p3Uj5KLFkuhhUc3jmyI3Gw8M7hI99WLc
         arJkdBMf2IULpES8T79qZL0R1+pJX7Y58gJL5KCI8qWgK93DWc1xd091H5jJdti6MQ16
         lhmeNeZahV8hzpV5Rvg9HQkcdd0JbefMO3PbPGHFk7RoWg2cd9YfblfnWMg1b75s9P8X
         iqtmVn1ezLgW49FOKCAaN5y6FhiKToRcIaKbS3XuhegI6fEnFihFu/UrIZB495ooK7JI
         rpvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8VNUS94Lc/dpPRyxggWsh6adTRtP7ryB0gZvNEsPsfI=;
        b=Hv3YO6yrsWuPQ+Jg+vvW1jq5EXg3AcMiPpLKzFOEKfppsZCsr+e/X9pVk0kph82aGH
         Gtwi+f5iHHL9ixr5DEWBtrhSpnRFxW0lM1L1hsFLSy/y4JKkpv1IPeNzNDba37lURfgm
         XbXvggttAkbLOYhmkY9uDbEoSeCj4+imuN5J2ZUnM1kJBbpgDEaF0IEvDo1j6xmLgl/m
         VlnGD1WwZU8Jd3VVdw8MbgOgPqJ+tDU9DZB++ivyF4Kny+Kt1lWZMPikuKcIzpBD6/7e
         FO2lJjeMWbds1vpKpkuGqavXt4vKrbSSjs+xwhrEajNvtDskcL2iqlhlDi7CUZ1kb3ls
         Jr3Q==
X-Gm-Message-State: AO0yUKU9g1BAO4Q0hDbt0SOZIKDnslCbznjydujAXpIf5rJuxWbFdxWp
        onFdl9ZqPdxOsApWdxT3t9w+8SQy/5NCGo9c
X-Google-Smtp-Source: AK7set/6GTR0lzidhvhi5ybuW15FqPvW2+G7RowduG4hd8gcO4rA31fEzivQ6kAHjJ+J5v29gTu9eA==
X-Received: by 2002:a05:622a:1d5:b0:3bb:7885:475f with SMTP id t21-20020a05622a01d500b003bb7885475fmr38592950qtw.3.1676312854641;
        Mon, 13 Feb 2023 10:27:34 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id q3-20020a378e03000000b0073b428119d9sm2525916qkd.106.2023.02.13.10.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 10:27:33 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id CEC5D4C228A; Mon, 13 Feb 2023 10:27:32 -0800 (PST)
Date:   Mon, 13 Feb 2023 10:27:32 -0800
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next v9 0/7] net/sched: cls_api: Support hardware
 miss to tc action
Message-ID: <Y+qBFLenHPxrTeT+@t14s.localdomain>
References: <20230206174403.32733-1-paulb@nvidia.com>
 <20230210015607.xjq2gorwpg4q3zxv@t14s.localdomain>
 <237cde33-022a-5d1c-d949-19773542f86b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <237cde33-022a-5d1c-d949-19773542f86b@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 06:25:14PM +0200, Paul Blakey wrote:
> 
> 
> On 10/02/2023 03:56, Marcelo Ricardo Leitner wrote:
> > Hi,
> > 
> > On Mon, Feb 06, 2023 at 07:43:56PM +0200, Paul Blakey wrote:
> > > Hi,
> > > 
> > > This series adds support for hardware miss to instruct tc to continue execution
> > > in a specific tc action instance on a filter's action list. The mlx5 driver patch
> > > (besides the refactors) shows its usage instead of using just chain restore.
> > > 
> > > Currently a filter's action list must be executed all together or
> > > not at all as driver are only able to tell tc to continue executing from a
> > > specific tc chain, and not a specific filter/action.
> > > 
> > > This is troublesome with regards to action CT, where new connections should
> > > be sent to software (via tc chain restore), and established connections can
> > > be handled in hardware.
> > > 
> > > Checking for new connections is done when executing the ct action in hardware
> > > (by checking the packet's tuple against known established tuples).
> > > But if there is a packet modification (pedit) action before action CT and the
> > > checked tuple is a new connection, hardware will need to revert the previous
> > > packet modifications before sending it back to software so it can
> > > re-match the same tc filter in software and re-execute its CT action.
> > > 
> > > The following is an example configuration of stateless nat
> > > on mlx5 driver that isn't supported before this patchet:
> > > 
> > >   #Setup corrosponding mlx5 VFs in namespaces
> > >   $ ip netns add ns0
> > >   $ ip netns add ns1
> > >   $ ip link set dev enp8s0f0v0 netns ns0
> > >   $ ip netns exec ns0 ifconfig enp8s0f0v0 1.1.1.1/24 up
> > >   $ ip link set dev enp8s0f0v1 netns ns1
> > >   $ ip netns exec ns1 ifconfig enp8s0f0v1 1.1.1.2/24 up
> > > 
> > >   #Setup tc arp and ct rules on mxl5 VF representors
> > >   $ tc qdisc add dev enp8s0f0_0 ingress
> > >   $ tc qdisc add dev enp8s0f0_1 ingress
> > >   $ ifconfig enp8s0f0_0 up
> > >   $ ifconfig enp8s0f0_1 up
> > > 
> > >   #Original side
> > >   $ tc filter add dev enp8s0f0_0 ingress chain 0 proto ip flower \
> > >      ct_state -trk ip_proto tcp dst_port 8888 \
> > >        action pedit ex munge tcp dport set 5001 pipe \
> > >        action csum ip tcp pipe \
> > >        action ct pipe \
> > >        action goto chain 1
> > >   $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
> > >      ct_state +trk+est \
> > >        action mirred egress redirect dev enp8s0f0_1
> > >   $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
> > >      ct_state +trk+new \
> > >        action ct commit pipe \
> > >        action mirred egress redirect dev enp8s0f0_1
> > >   $ tc filter add dev enp8s0f0_0 ingress chain 0 proto arp flower \
> > >        action mirred egress redirect dev enp8s0f0_1
> > > 
> > >   #Reply side
> > >   $ tc filter add dev enp8s0f0_1 ingress chain 0 proto arp flower \
> > >        action mirred egress redirect dev enp8s0f0_0
> > >   $ tc filter add dev enp8s0f0_1 ingress chain 0 proto ip flower \
> > >      ct_state -trk ip_proto tcp \
> > >        action ct pipe \
> > >        action pedit ex munge tcp sport set 8888 pipe \
> > >        action csum ip tcp pipe \
> > >        action mirred egress redirect dev enp8s0f0_0
> > > 
> > >   #Run traffic
> > >   $ ip netns exec ns1 iperf -s -p 5001&
> > >   $ sleep 2 #wait for iperf to fully open
> > >   $ ip netns exec ns0 iperf -c 1.1.1.2 -p 8888
> > > 
> > >   #dump tc filter stats on enp8s0f0_0 chain 0 rule and see hardware packets:
> > >   $ tc -s filter show dev enp8s0f0_0 ingress chain 0 proto ip | grep "hardware.*pkt"
> > >          Sent hardware 9310116832 bytes 6149672 pkt
> > >          Sent hardware 9310116832 bytes 6149672 pkt
> > >          Sent hardware 9310116832 bytes 6149672 pkt
> > 
> > I see Jamal had asked about stats on the other version, but then no
> > dependency was set. I think we _must_ have a dependency of this
> > patchet on the per-action stats one. Otherwise the stats above will
> > get messy.  Without the per-action stats, the last one is replicated
> > to the other actions. But then, will hw count the packet that it did
> > only the first action? I don't see how it would, and then for the all
> > but first one the packet will be accounted twice.
> > 
> > With this said, it would be nice to provide a sample of how the sw and
> > hw stats would look like _after_ this patchset as well.
> > 
> > Btw I'll add my Reviewed-by tag to the per-action stats one in a few.
> 
> 
> This patchset actually doesn't need to rely on the per actions stats because
> the driver is still reordering the action list so CT will be first and the
> example in cover letter will be rejected because it can't be reordered. Then
> we are still doing all (CT and the rest) or nothing.

Ah right. I thought the driver patches here were undoing the
reordering already.

> 
> But we wanted to confirm the API before committing the rest of the driver
> patches since its has a lot of refactors so we split it to two series - API,
> then only MLX5 DRIVER. This is just the API with a bare minimal driver
> change to just use the API. From tc user perspective nothing changed here.
> 
> So do we first continue with this (after i fix your suggestions), and then
> we'll submit the rest, or should I rebase on the per action stats, add even

Well, the two patchsets will certainly create conflicts when adding
the cookie. Not sure if the maintainers can accomodate it.

> more mlx5 patches here which are mostly not relevant, since I think we are
> ok with the API changes.
> 
> 
> > 
> > > 
> > > A new connection executing the first filter in hardware will first rewrite
> > > the dst port to the new port, and then the ct action is executed,
> > > because this is a new connection, hardware will need to be send this back
> > > to software, on chain 0, to execute the first filter again in software.
> > > The dst port needs to be reverted otherwise it won't re-match the old
> > > dst port in the first filter. Because of that, currently mlx5 driver will
> > > reject offloading the above action ct rule.
> > > 
> > > This series adds supports partial offload of a filter's action list,
> > 
> > We should avoid this terminology as is, as it can create confusion. It
> > is not that it is offloading action 1 and not action 2. Instead, it is
> > adding support to a more fine grained miss to sw. Perhaps "support for
> > partially executing in hw".
> > 
> > > and letting tc software continue processing in the specific action instance
> > > where hardware left off (in the above case after the "action pedit ex munge tcp
> > > dport... of the first rule") allowing support for scenarios such as the above.
> > > 
> > > Changelog:
> > > 	v1->v2:
> > > 	Fixed compilation without CONFIG_NET_CLS
> > > 	Cover letter re-write
> > > 
> > > 	v2->v3:
> > > 	Unlock spin_lock on error in cls flower filter handle refactor
> > > 	Cover letter
> > > 
> > > 	v3->v4:
> > > 	Silence warning by clang
> > > 
> > > 	v4->v5:
> > > 	Cover letter example
> > > 	Removed ifdef as much as possible by using inline stubs
> > > 
> > > 	v5->v6:
> > > 	Removed new inlines in cls_api.c (bot complained in patchwork)
> > > 	Added reviewed-by/ack - Thanks!
> > > 
> > > 	v6->v7:
> > > 	Removed WARN_ON from pkt path (leon)
> > > 	Removed unnecessary return in void func
> > > 
> > > 	v7->v8:
> > > 	Removed #if IS_ENABLED on skb ext adding Kconfig changes
> > > 	Complex variable init in seperate lines
> > > 	if,else if, else if ---> switch case
> > > 
> > > 	v8->v9:
> > > 	Removed even more IS_ENABLED because of Kconfig
> > > 
> > > Paul Blakey (7):
> > >    net/sched: cls_api: Support hardware miss to tc action
> > >    net/sched: flower: Move filter handle initialization earlier
> > >    net/sched: flower: Support hardware miss to tc action
> > >    net/mlx5: Kconfig: Make tc offload depend on tc skb extension
> > >    net/mlx5: Refactor tc miss handling to a single function
> > >    net/mlx5e: Rename CHAIN_TO_REG to MAPPED_OBJ_TO_REG
> > >    net/mlx5e: TC, Set CT miss to the specific ct action instance
> > > 
> > >   .../net/ethernet/mellanox/mlx5/core/Kconfig   |   4 +-
> > >   .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 225 ++------------
> > >   .../mellanox/mlx5/core/en/tc/sample.c         |   2 +-
> > >   .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  39 +--
> > >   .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |   2 +
> > >   .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +-
> > >   .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 280 ++++++++++++++++--
> > >   .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  23 +-
> > >   .../net/ethernet/mellanox/mlx5/core/eswitch.h |   2 +
> > >   .../mellanox/mlx5/core/lib/fs_chains.c        |  14 +-
> > >   include/linux/skbuff.h                        |   6 +-
> > >   include/net/flow_offload.h                    |   1 +
> > >   include/net/pkt_cls.h                         |  34 ++-
> > >   include/net/sch_generic.h                     |   2 +
> > >   net/openvswitch/flow.c                        |   3 +-
> > >   net/sched/act_api.c                           |   2 +-
> > >   net/sched/cls_api.c                           | 213 ++++++++++++-
> > >   net/sched/cls_flower.c                        |  73 +++--
> > >   18 files changed, 602 insertions(+), 327 deletions(-)
> > > 
> > > -- 
> > > 2.30.1
> > > 
