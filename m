Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D345975B6
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240795AbiHQS1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238247AbiHQS1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:27:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F51F9A99E;
        Wed, 17 Aug 2022 11:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30D966134B;
        Wed, 17 Aug 2022 18:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A85C433D6;
        Wed, 17 Aug 2022 18:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660760866;
        bh=7RQC7Z5PDF/KkimXUInJgKToDP1OPwB23lF//Uzk2B8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fwb9RA1C7Uh1vpJloxASY9ISkShN05ee9h3qgfit+SEAXYnbGamXfHyG9o8wjEfeL
         rKjRDPTf9B+ksAbVyVP42yLRfzZMod4TR1IhYkxDO74Xyw3aCcpITONOaY5D3tz/Em
         IGRZAuYQlk4Ey7f4ZX4RNt3v8PioPYsIBULUakd38dY2uqks+mRhh+ChUeYIhK/ohj
         SY3UtHU5TtPlqBJn3El5z0v1O14gP5Mc8GA9PY5fYarmyf9+CM73Tx8ImfpXjqsmF/
         7rUewMIJYBuDb6634mPVRTUYAaqYNCrn2iHWv+YGb0EeQs+OCG5UG+6mnX6WUOm+EH
         674uQIV8FiY8A==
Date:   Wed, 17 Aug 2022 11:27:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 9/9] u64_stat: Remove the obsolete fetch_irq() variants
Message-ID: <20220817112745.4efd8217@kernel.org>
In-Reply-To: <20220817162703.728679-10-bigeasy@linutronix.de>
References: <20220817162703.728679-1-bigeasy@linutronix.de>
        <20220817162703.728679-10-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 18:27:03 +0200 Sebastian Andrzej Siewior wrote:
>  drivers/net/ethernet/alacritech/slic.h        | 12 +++----
>  drivers/net/ethernet/amazon/ena/ena_ethtool.c |  4 +--
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  | 12 +++----
>  .../net/ethernet/aquantia/atlantic/aq_ring.c  |  8 ++---
>  drivers/net/ethernet/asix/ax88796c_main.c     |  4 +--
>  drivers/net/ethernet/broadcom/b44.c           |  8 ++---
>  drivers/net/ethernet/broadcom/bcmsysport.c    | 12 +++----
>  .../net/ethernet/emulex/benet/be_ethtool.c    | 12 +++----
>  drivers/net/ethernet/emulex/benet/be_main.c   | 16 +++++-----
>  .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  4 +--
>  .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  8 ++---
>  .../net/ethernet/intel/i40e/i40e_ethtool.c    |  8 ++---
>  drivers/net/ethernet/intel/i40e/i40e_main.c   | 20 ++++++------
>  .../net/ethernet/intel/iavf/iavf_ethtool.c    |  8 ++---
>  drivers/net/ethernet/intel/ice/ice_main.c     |  4 +--
>  drivers/net/ethernet/intel/igb/igb_ethtool.c  | 12 +++----
>  drivers/net/ethernet/intel/igb/igb_main.c     |  8 ++---
>  drivers/net/ethernet/intel/igc/igc_ethtool.c  | 12 +++----
>  drivers/net/ethernet/intel/igc/igc_main.c     |  8 ++---
>  .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  8 ++---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  8 ++---
>  drivers/net/ethernet/intel/ixgbevf/ethtool.c  | 12 +++----
>  .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  8 ++---
>  drivers/net/ethernet/marvell/mvneta.c         |  8 ++---
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  8 ++---
>  drivers/net/ethernet/marvell/sky2.c           |  8 ++---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  8 ++---
>  .../net/ethernet/mellanox/mlxsw/spectrum.c    |  4 +--
>  drivers/net/ethernet/microsoft/mana/mana_en.c |  8 ++---
>  .../ethernet/microsoft/mana/mana_ethtool.c    |  8 ++---
>  .../net/ethernet/netronome/nfp/nfp_net_repr.c |  4 +--
>  drivers/net/ethernet/nvidia/forcedeth.c       |  8 ++---
>  .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  4 +--
>  drivers/net/ethernet/realtek/8139too.c        |  8 ++---
>  drivers/net/ethernet/socionext/sni_ave.c      |  8 ++---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  4 +--
>  drivers/net/ethernet/ti/netcp_core.c          |  8 ++---
>  drivers/net/ethernet/via/via-rhine.c          |  8 ++---
>  drivers/net/hyperv/netvsc_drv.c               | 32 +++++++++----------
>  drivers/net/ifb.c                             | 12 +++----
>  drivers/net/ipvlan/ipvlan_main.c              |  4 +--
>  drivers/net/loopback.c                        |  4 +--
>  drivers/net/macsec.c                          | 12 +++----
>  drivers/net/macvlan.c                         |  4 +--
>  drivers/net/mhi_net.c                         |  8 ++---
>  drivers/net/team/team.c                       |  4 +--
>  drivers/net/team/team_mode_loadbalance.c      |  4 +--
>  drivers/net/veth.c                            | 12 +++----
>  drivers/net/virtio_net.c                      | 16 +++++-----
>  drivers/net/vrf.c                             |  4 +--
>  drivers/net/vxlan/vxlan_vnifilter.c           |  4 +--
>  drivers/net/wwan/mhi_wwan_mbim.c              |  8 ++---
>  drivers/net/xen-netfront.c                    |  8 ++---
>  drivers/spi/spi.c                             |  4 +--
>  include/linux/u64_stats_sync.h                | 12 -------
>  kernel/bpf/syscall.c                          |  4 +--
>  net/8021q/vlan_dev.c                          |  4 +--
>  net/bridge/br_multicast.c                     |  4 +--
>  net/bridge/br_vlan.c                          |  4 +--
>  net/core/dev.c                                |  4 +--
>  net/core/devlink.c                            |  4 +--
>  net/core/drop_monitor.c                       |  8 ++---
>  net/core/gen_stats.c                          | 16 +++++-----
>  net/dsa/slave.c                               |  4 +--
>  net/ipv4/af_inet.c                            |  4 +--
>  net/ipv6/seg6_local.c                         |  4 +--
>  net/netfilter/ipvs/ip_vs_ctl.c                |  4 +--
>  net/netfilter/nf_tables_api.c                 |  4 +--
>  net/openvswitch/datapath.c                    |  4 +--
>  net/openvswitch/flow_table.c                  |  9 +++---

What's the thinking on merging? 8 and 9 will get reposted separately 
for net-next once the discussions are over?
