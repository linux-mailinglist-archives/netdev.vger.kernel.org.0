Return-Path: <netdev+bounces-10656-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F77E72F96D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:40:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B3BA281239
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E705569D;
	Wed, 14 Jun 2023 09:40:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712386101
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:40:36 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605C12D75
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 02:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686735601; x=1718271601;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dLy4O6Uul/cbqW0rTEAUKNks1q6NbuP6jzScLCB4tas=;
  b=Jsx1ETyopDlLPWbtcskJKDHCI6Hbd0kN17eNdDhmTY/2U2krpyTs6TPO
   u6wl2aw3+bIk5DAQozUfASy/fi1W5mQi7wgLfoaWtmD+Bez6O4OjzR1hL
   gx5bx+hsSMxPK1nKacZhdObrs6spe/aF+Stqm+3FmLHjKusMB8Y729tQg
   g1UhsOotyHH/jbiFzKvJUgCqE+oHXOoFOPxp/8HMPjOVG0Ukt+M7kA4gJ
   UsqzVHMaFgt6bsvJMTIvdLtObUNjiYO8IipkQpQiK51lcppu+eBz2bE3/
   0FajlcjBRHj9JWqaf/U8j4nIgiSSTzV9kgW30qKZjGAvXVnsiME8WSIOB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="422170681"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="422170681"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 02:40:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="741772509"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="741772509"
Received: from mszycik-mobl1.ger.corp.intel.com (HELO [10.249.137.22]) ([10.249.137.22])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 02:39:57 -0700
Message-ID: <7ff20252-4672-fdcf-6c64-f7bbbd469cc7@linux.intel.com>
Date: Wed, 14 Jun 2023 11:39:49 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH iwl-next v2 0/6] ice: Add PFCP filter support
Content-Language: en-US
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org, wojciech.drewek@intel.com,
 michal.swiatkowski@linux.intel.com, aleksander.lobakin@intel.com,
 davem@davemloft.net, kuba@kernel.org, jiri@resnulli.us, pabeni@redhat.com,
 jesse.brandeburg@intel.com, simon.horman@corigine.com, idosch@nvidia.com
References: <20230607112606.15899-1-marcin.szycik@linux.intel.com>
From: Marcin Szycik <marcin.szycik@linux.intel.com>
In-Reply-To: <20230607112606.15899-1-marcin.szycik@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 07.06.2023 13:26, Marcin Szycik wrote:
> Add support for creating PFCP filters in switchdev mode. Add pfcp module
> that allows to create a PFCP-type netdev. The netdev then can be passed to
> tc when creating a filter to indicate that PFCP filter should be created.
> 
> To add a PFCP filter, a special netdev must be created and passed to tc
> command:
> 
> ip link add pfcp0 type pfcp
> tc filter add dev eth0 ingress prio 1 flower pfcp_opts \
> 1:123/ff:fffffffffffffff0 skip_hw action mirred egress redirect dev pfcp0
> 
> Changes in iproute2 are required to be able to add the pfcp netdev and use
> pfcp_opts in tc (patchset will be submitted later).

iproute2 patch posted to netdev [1]. A little clarification: no changes are
required to create pfcp type netdev - it can be created if pfcp module is
loaded. Changes in iproute2 are only needed to use the newly introduced
pfcp_opts.

[1] https://lore.kernel.org/netdev/20230614091758.11180-1-marcin.szycik@linux.intel.com

> 
> ICE COMMS package is required as it contains PFCP profiles.
> 
> Part of this patchset modifies IP_TUNNEL_*_OPTs, which were previously
> stored in a __be16. All possible values have already been used, making it
> impossible to add new ones.
> 
> Alexander Lobakin (2):
>   ip_tunnel: use a separate struct to store tunnel params in the kernel
>   ip_tunnel: convert __be16 tunnel flags to bitmaps
> 
> Marcin Szycik (2):
>   ice: refactor ICE_TC_FLWR_FIELD_ENC_OPTS
>   ice: Add support for PFCP hardware offload in switchdev
> 
> Michal Swiatkowski (1):
>   pfcp: always set pfcp metadata
> 
> Wojciech Drewek (1):
>   pfcp: add PFCP module
> 
>  drivers/net/Kconfig                           |  13 +
>  drivers/net/Makefile                          |   1 +
>  drivers/net/bareudp.c                         |  19 +-
>  drivers/net/ethernet/intel/ice/ice_ddp.c      |   9 +
>  .../net/ethernet/intel/ice/ice_flex_type.h    |   4 +-
>  .../ethernet/intel/ice/ice_protocol_type.h    |  12 +
>  drivers/net/ethernet/intel/ice/ice_switch.c   |  85 +++++
>  drivers/net/ethernet/intel/ice/ice_switch.h   |   2 +
>  drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  68 +++-
>  drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   7 +-
>  .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |   2 +-
>  .../mellanox/mlx5/core/en/tc_tun_encap.c      |   6 +-
>  .../mellanox/mlx5/core/en/tc_tun_geneve.c     |  12 +-
>  .../mellanox/mlx5/core/en/tc_tun_gre.c        |   9 +-
>  .../mellanox/mlx5/core/en/tc_tun_vxlan.c      |   9 +-
>  .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  15 +-
>  .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |  62 ++--
>  .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |   2 +-
>  .../ethernet/mellanox/mlxsw/spectrum_span.c   |  10 +-
>  .../ethernet/netronome/nfp/flower/action.c    |  12 +-
>  drivers/net/geneve.c                          |  46 ++-
>  drivers/net/pfcp.c                            | 303 ++++++++++++++++++
>  drivers/net/vxlan/vxlan_core.c                |  14 +-
>  include/linux/netdevice.h                     |   7 +-
>  include/net/dst_metadata.h                    |  10 +-
>  include/net/flow_dissector.h                  |   2 +-
>  include/net/gre.h                             |  59 ++--
>  include/net/ip6_tunnel.h                      |   4 +-
>  include/net/ip_tunnels.h                      | 106 +++++-
>  include/net/pfcp.h                            |  83 +++++
>  include/net/udp_tunnel.h                      |   4 +-
>  include/uapi/linux/if_tunnel.h                |  36 +++
>  include/uapi/linux/pkt_cls.h                  |  14 +
>  net/bridge/br_vlan_tunnel.c                   |   5 +-
>  net/core/filter.c                             |  20 +-
>  net/core/flow_dissector.c                     |  12 +-
>  net/ipv4/fou_bpf.c                            |   2 +-
>  net/ipv4/gre_demux.c                          |   2 +-
>  net/ipv4/ip_gre.c                             | 148 +++++----
>  net/ipv4/ip_tunnel.c                          |  92 ++++--
>  net/ipv4/ip_tunnel_core.c                     |  83 +++--
>  net/ipv4/ip_vti.c                             |  43 ++-
>  net/ipv4/ipip.c                               |  33 +-
>  net/ipv4/ipmr.c                               |   2 +-
>  net/ipv4/udp_tunnel_core.c                    |   5 +-
>  net/ipv6/addrconf.c                           |   3 +-
>  net/ipv6/ip6_gre.c                            |  87 ++---
>  net/ipv6/ip6_tunnel.c                         |  14 +-
>  net/ipv6/sit.c                                |  47 ++-
>  net/netfilter/ipvs/ip_vs_core.c               |   6 +-
>  net/netfilter/ipvs/ip_vs_xmit.c               |  20 +-
>  net/netfilter/nft_tunnel.c                    |  45 +--
>  net/openvswitch/flow_netlink.c                |  55 ++--
>  net/psample/psample.c                         |  26 +-
>  net/sched/act_tunnel_key.c                    |  39 +--
>  net/sched/cls_flower.c                        | 134 +++++++-
>  56 files changed, 1501 insertions(+), 469 deletions(-)
>  create mode 100644 drivers/net/pfcp.c
>  create mode 100644 include/net/pfcp.h
> 

