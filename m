Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7194F2ED6E2
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 19:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729239AbhAGSo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 13:44:59 -0500
Received: from mga03.intel.com ([134.134.136.65]:5856 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728105AbhAGSo6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 13:44:58 -0500
IronPort-SDR: t0fVx6pUDCmLvn2EZ22MfgICAAhj7Ie7NXeTkhvx8/rrD0jvGj6AFI31YAeSMdmnxzSYFU/JUS
 CmHGwFEk1Vdw==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="177576296"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="177576296"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 10:44:17 -0800
IronPort-SDR: 13rQa7JdKtmakYBYbVxtGICGwx2YsvuOPokAUfKlzqHvE2605MyM1j0dUprS9rfc8k1nMbb2Mi
 YibgxAsoG0Cg==
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="422675392"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.22.194]) ([10.209.22.194])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 10:44:15 -0800
Subject: Re: [PATCH net-next 0/4] udp_tunnel_nic: post conversion cleanup
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, thomas.lendacky@amd.com,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        michael.chan@broadcom.com, rajur@chelsio.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, GR-Linux-NIC-Dev@marvell.com,
        ecree.xilinx@gmail.com, simon.horman@netronome.com,
        alexander.duyck@gmail.com
References: <20210106210637.1839662-1-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <ea428429-eb5f-166c-1773-acc7aa824731@intel.com>
Date:   Thu, 7 Jan 2021 10:44:11 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210106210637.1839662-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/6/2021 1:06 PM, Jakub Kicinski wrote:
> It has been two releases since we added the common infra for UDP
> tunnel port offload, and we have not heard of any major issues.
> Remove the old direct driver NDOs completely, and perform minor
> simplifications in the tunnel drivers.
> 

Nice to see this step! Everything seems straight forward to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Jakub Kicinski (4):
>   udp_tunnel: hard-wire NDOs to udp_tunnel_nic_*_port() helpers
>   udp_tunnel: remove REGISTER/UNREGISTER handling from tunnel drivers
>   net: remove ndo_udp_tunnel_* callbacks
>   udp_tunnel: reshuffle NETIF_F_RX_UDP_TUNNEL_PORT checks
> 
>  drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  2 --
>  .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  2 --
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 --
>  .../net/ethernet/cavium/liquidio/lio_main.c   |  2 --
>  .../ethernet/cavium/liquidio/lio_vf_main.c    |  2 --
>  .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 --
>  drivers/net/ethernet/cisco/enic/enic_main.c   |  4 ----
>  drivers/net/ethernet/emulex/benet/be_main.c   |  2 --
>  .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  2 --
>  drivers/net/ethernet/intel/i40e/i40e_main.c   |  2 --
>  drivers/net/ethernet/intel/ice/ice_main.c     |  2 --
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  2 --
>  .../net/ethernet/mellanox/mlx4/en_netdev.c    |  4 ----
>  .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 --
>  .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  2 --
>  .../ethernet/netronome/nfp/nfp_net_common.c   |  2 --
>  drivers/net/ethernet/qlogic/qede/qede_main.c  |  6 -----
>  .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  2 --
>  drivers/net/ethernet/sfc/efx.c                |  2 --
>  drivers/net/geneve.c                          | 14 ++++-------
>  drivers/net/netdevsim/netdev.c                |  2 --
>  drivers/net/vxlan.c                           | 15 ++++--------
>  include/linux/netdevice.h                     | 17 -------------
>  include/net/udp_tunnel.h                      |  8 +++++++
>  net/core/dev.c                                |  2 +-
>  net/ipv4/udp_tunnel_core.c                    | 24 ++++---------------
>  26 files changed, 22 insertions(+), 106 deletions(-)
> 
