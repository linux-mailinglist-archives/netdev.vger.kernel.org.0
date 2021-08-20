Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0FA3F33BA
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 20:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbhHTS2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 14:28:43 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34714 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbhHTS2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 14:28:35 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 17KIRHqM068427;
        Fri, 20 Aug 2021 13:27:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1629484037;
        bh=PA8KESUM4iIbQdy8FOvIfYXjnsAfczIewWjmDQ8Hgok=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=G0BmwBm/75FsPjyKBOfZehQosiB/OHK4ZE9aLqSOnGyBCNWdFYDNtB5bweyL+xiyd
         5W5QJuqtLC/2ghlbVedt05IQaEYnH5rnNzs+tDyrXSqNunMBWUybdMZdgh6ZGzjZqn
         ASRsI9IEHnv2yesUVu3sj2b9ayK7nWhEO1tEQnBg=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 17KIRHLS107305
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Aug 2021 13:27:17 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 20
 Aug 2021 13:27:17 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 20 Aug 2021 13:27:17 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 17KIR6mI088414;
        Fri, 20 Aug 2021 13:27:06 -0500
Subject: Re: [PATCH V3 net-next 2/4] ethtool: extend coalesce setting uAPI
 with CQE mode
To:     Yufeng Mo <moyufeng@huawei.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <shenjian15@huawei.com>,
        <lipeng321@huawei.com>, <yisen.zhuang@huawei.com>,
        <linyunsheng@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>, <salil.mehta@huawei.com>,
        <linuxarm@huawei.com>, <linuxarm@openeuler.org>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <thomas.lendacky@amd.com>,
        <irusskikh@marvell.com>, <michael.chan@broadcom.com>,
        <edwin.peer@broadcom.com>, <rohitm@chelsio.com>,
        <jacob.e.keller@intel.com>, <ioana.ciornei@nxp.com>,
        <vladimir.oltean@nxp.com>, <sgoutham@marvell.com>,
        <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <merez@codeaurora.org>,
        <kvalo@codeaurora.org>, <linux-wireless@vger.kernel.org>
References: <1629444920-25437-1-git-send-email-moyufeng@huawei.com>
 <1629444920-25437-3-git-send-email-moyufeng@huawei.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <32fd0b32-e748-42d9-6468-b5b1393511e9@ti.com>
Date:   Fri, 20 Aug 2021 21:27:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1629444920-25437-3-git-send-email-moyufeng@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20/08/2021 10:35, Yufeng Mo wrote:
> In order to support more coalesce parameters through netlink,
> add two new parameter kernel_coal and extack for .set_coalesce
> and .get_coalesce, then some extra info can return to user with
> the netlink API.
> 
> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> ---
>   drivers/infiniband/ulp/ipoib/ipoib_ethtool.c           |  8 ++++++--
>   drivers/net/ethernet/amazon/ena/ena_ethtool.c          |  8 ++++++--
>   drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c           |  8 ++++++--
>   drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c    |  8 ++++++--
>   drivers/net/ethernet/broadcom/bcmsysport.c             |  8 ++++++--
>   drivers/net/ethernet/broadcom/bnx2.c                   | 12 ++++++++----
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |  8 ++++++--
>   drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c      |  8 ++++++--
>   drivers/net/ethernet/broadcom/genet/bcmgenet.c         |  8 ++++++--
>   drivers/net/ethernet/broadcom/tg3.c                    | 10 ++++++++--
>   drivers/net/ethernet/brocade/bna/bnad_ethtool.c        | 12 ++++++++----
>   drivers/net/ethernet/cavium/liquidio/lio_ethtool.c     |  8 ++++++--
>   drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c    |  4 +++-
>   drivers/net/ethernet/chelsio/cxgb/cxgb2.c              |  8 ++++++--
>   drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c        |  8 ++++++--
>   drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c     |  8 ++++++--
>   drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |  8 ++++++--
>   drivers/net/ethernet/cisco/enic/enic_ethtool.c         |  8 ++++++--
>   drivers/net/ethernet/cortina/gemini.c                  |  8 ++++++--
>   drivers/net/ethernet/emulex/benet/be_ethtool.c         |  8 ++++++--
>   drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c     |  8 ++++++--
>   drivers/net/ethernet/freescale/enetc/enetc_ethtool.c   |  8 ++++++--
>   drivers/net/ethernet/freescale/fec_main.c              | 14 +++++++++-----
>   drivers/net/ethernet/freescale/gianfar_ethtool.c       |  8 ++++++--
>   drivers/net/ethernet/hisilicon/hip04_eth.c             |  8 ++++++--
>   drivers/net/ethernet/hisilicon/hns/hns_ethtool.c       | 12 ++++++++++--
>   drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c     |  8 ++++++--
>   drivers/net/ethernet/huawei/hinic/hinic_ethtool.c      |  8 ++++++--
>   drivers/net/ethernet/intel/e1000/e1000_ethtool.c       |  8 ++++++--
>   drivers/net/ethernet/intel/e1000e/ethtool.c            |  8 ++++++--
>   drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c       |  8 ++++++--
>   drivers/net/ethernet/intel/i40e/i40e_ethtool.c         | 12 ++++++++++--
>   drivers/net/ethernet/intel/iavf/iavf_ethtool.c         | 12 ++++++++++--
>   drivers/net/ethernet/intel/ice/ice_ethtool.c           | 12 ++++++++----
>   drivers/net/ethernet/intel/igb/igb_ethtool.c           |  8 ++++++--
>   drivers/net/ethernet/intel/igbvf/ethtool.c             |  8 ++++++--
>   drivers/net/ethernet/intel/igc/igc_ethtool.c           |  8 ++++++--
>   drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c       |  8 ++++++--
>   drivers/net/ethernet/intel/ixgbevf/ethtool.c           |  8 ++++++--
>   drivers/net/ethernet/jme.c                             | 12 ++++++++----
>   drivers/net/ethernet/marvell/mv643xx_eth.c             | 12 ++++++++----
>   drivers/net/ethernet/marvell/mvneta.c                  | 14 ++++++++++----
>   drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c        | 14 ++++++++++----
>   .../net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  8 ++++++--
>   drivers/net/ethernet/marvell/skge.c                    |  8 ++++++--
>   drivers/net/ethernet/marvell/sky2.c                    |  8 ++++++--
>   drivers/net/ethernet/mellanox/mlx4/en_ethtool.c        |  8 ++++++--
>   drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  8 ++++++--
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c       |  8 ++++++--
>   .../net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |  8 ++++++--
>   drivers/net/ethernet/myricom/myri10ge/myri10ge.c       | 12 ++++++++----
>   drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c   |  8 ++++++--
>   drivers/net/ethernet/ni/nixge.c                        | 14 ++++++++++----
>   drivers/net/ethernet/pensando/ionic/ionic_ethtool.c    |  8 ++++++--
>   .../net/ethernet/qlogic/netxen/netxen_nic_ethtool.c    |  8 ++++++--
>   drivers/net/ethernet/qlogic/qede/qede.h                |  4 +++-
>   drivers/net/ethernet/qlogic/qede/qede_ethtool.c        |  8 ++++++--
>   drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |  8 ++++++--
>   drivers/net/ethernet/realtek/r8169_main.c              | 10 ++++++++--
>   drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c     |  8 ++++++--
>   drivers/net/ethernet/sfc/ethtool.c                     |  8 ++++++--
>   drivers/net/ethernet/sfc/falcon/ethtool.c              |  8 ++++++--
>   drivers/net/ethernet/socionext/netsec.c                | 10 +++++++---
>   drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  8 ++++++--
>   drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c     | 14 ++++++++++----
>   drivers/net/ethernet/tehuti/tehuti.c                   | 12 ++++++++----
>   drivers/net/ethernet/ti/cpsw.c                         |  2 +-
>   drivers/net/ethernet/ti/cpsw_ethtool.c                 |  8 ++++++--
>   drivers/net/ethernet/ti/cpsw_new.c                     |  2 +-
>   drivers/net/ethernet/ti/cpsw_priv.h                    |  8 ++++++--
>   drivers/net/ethernet/ti/davinci_emac.c                 | 14 +++++++++++---
>   drivers/net/ethernet/via/via-velocity.c                |  8 ++++++--
>   drivers/net/ethernet/xilinx/ll_temac_main.c            | 14 ++++++++++----
>   drivers/net/ethernet/xilinx/xilinx_axienet_main.c      | 18 ++++++++++++++----
>   drivers/net/netdevsim/ethtool.c                        |  8 ++++++--
>   drivers/net/tun.c                                      |  8 ++++++--
>   drivers/net/usb/r8152.c                                |  8 ++++++--
>   drivers/net/virtio_net.c                               |  8 ++++++--
>   drivers/net/vmxnet3/vmxnet3_ethtool.c                  | 12 ++++++++----
>   drivers/net/wireless/ath/wil6210/ethtool.c             | 14 ++++++++++----
>   drivers/s390/net/qeth_ethtool.c                        |  4 +++-
>   drivers/staging/qlge/qlge_ethtool.c                    | 10 ++++++++--
>   include/linux/ethtool.h                                | 11 +++++++++--
>   net/ethtool/coalesce.c                                 | 10 +++++++---
>   net/ethtool/ioctl.c                                    | 15 ++++++++++++---
>   85 files changed, 576 insertions(+), 202 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> index 823f683..a09ca21 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> @@ -72,7 +72,9 @@ static void ipoib_get_drvinfo(struct net_device *netdev,
>   }
>   
>   static int ipoib_get_coalesce(struct net_device *dev,
> -			      struct ethtool_coalesce *coal)
> +			      struct ethtool_coalesce *coal,
> +			      struct kernel_ethtool_coalesce *kernel_coal,
> +			      struct netlink_ext_ack *extack)
>   {
>   	struct ipoib_dev_priv *priv = ipoib_priv(dev);
>   
> @@ -83,7 +85,9 @@ static int ipoib_get_coalesce(struct net_device *dev,
>   }
>   
>   static int ipoib_set_coalesce(struct net_device *dev,
> -			      struct ethtool_coalesce *coal)
> +			      struct ethtool_coalesce *coal,
> +			      struct kernel_ethtool_coalesce *kernel_coal,
> +			      struct netlink_ext_ack *extack)
>   {
>   	struct ipoib_dev_priv *priv = ipoib_priv(dev);
>   	int ret;

[...]

This is very big change which is not only mix two separate changes, but also looks
half-done. From one side you're adding HW feature supported by limited number of HW,
from another - changing most of net drivers to support it by generating mix of legacy
and new kernel_ethtool_coalesce parameters.

There is also an issue - you do not account get/set_per_queue_coalesce() in any way.

Would it be possible to consider following, please?

- move extack change out of this series

- option (a)
   add new callbacks in ethtool_ops as set_coalesce_cqe/get_coalesce_cqe for CQE support.
   Only required drivers will need to be changed.

- option (b)
   add struct ethtool_coalesce as first field of kernel_ethtool_coalesce

struct kernel_ethtool_coalesce {
	/* legacy */
	struct ethtool_coalesce coal;

	/* new */
	u8 use_cqe_mode_tx;
	u8 use_cqe_mode_rx;
};

--  then b.1
   drivers can be updated as
    static int set_coalesce(struct net_device *dev,
    			    struct kernel_ethtool_coalesce *kernel_coal)
    {
	struct ethtool_coalesce *coal = &kernel_coal->coal;
    
    (which will clearly indicate migration to the new interface )

-- then b.2
     add new callbacks in ethtool_ops as set_coalesce_ext/get_coalesce_ext (extended)
     which will accept struct kernel_ethtool_coalesce as parameter an allow drivers to migrate when needed
     (or as separate patch which will do only migration).

Personally, I like "b.2".

-- 
Best regards,
grygorii
