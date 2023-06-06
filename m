Return-Path: <netdev+bounces-8362-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 654D0723CE1
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC0691C20E69
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7253C29118;
	Tue,  6 Jun 2023 09:16:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63007290EA
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:16:49 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BD0109
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686043003; x=1717579003;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=E8hHWNKPu9TmGy/xsGewtPNb7TG8PpaP/iQJRghtTWc=;
  b=b9i8id0Vz7syqExIDiWnEbqNvFk498lGyO6fPf5Rvw+joKZ4M+Dy4dBj
   +zySde2PGGEYMMSMZVLqrxJkMBQWrF5wn5zZSz/cOFA3CeTW9xQUyZ+Qy
   X0w8jT+tysB66Tg/TY/f4NC8XQr0/WcOGXJllMPKezBIgrlGE6/AxdaJT
   CbUtx5WmX4kw68G/wcGV7lRh4pqp65VR7AfuI18a/iLxD3puy7YwJPaJa
   gh2oI0gd/xmnWk5LJ7IpbCUSqx7scdzfy2qzj5zJh6Vl7DD6P8CdYHaod
   hMjHJkxJvaM3dZKBnjMfi0zPHI+VUjFv6rO15HggwdL09JRI6bI/cUJeF
   A==;
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="217003397"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2023 02:16:43 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 6 Jun 2023 02:16:42 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 6 Jun 2023 02:16:41 -0700
Date: Tue, 6 Jun 2023 09:16:40 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Dave Ertman <david.m.ertman@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 02/10] ice: Add driver support for firmware
 changes for LAG
Message-ID: <20230606091640.i4eqc4hc7kskk7e2@DEN-LT-70577>
References: <20230605182258.557933-1-david.m.ertman@intel.com>
 <20230605182258.557933-3-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230605182258.557933-3-david.m.ertman@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

 > Add the defines, fields, and detection code for FW support of LAG for
> SRIOV.  Also exposes some previously static functions to allow access
> in the lag code.
> 
> Clean up code that is unused or not needed for LAG support.  Also add
> a ordered workqueue for processing LAG events.

nit: s/a/an/

> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h          |  5 ++
>  .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  3 ++
>  drivers/net/ethernet/intel/ice/ice_common.c   |  9 +++-
>  drivers/net/ethernet/intel/ice/ice_lag.c      | 53 ++++++++++---------
>  drivers/net/ethernet/intel/ice/ice_lib.c      |  2 +-
>  drivers/net/ethernet/intel/ice/ice_lib.h      |  1 +
>  drivers/net/ethernet/intel/ice/ice_main.c     | 12 +++++
>  drivers/net/ethernet/intel/ice/ice_type.h     |  2 +
>  8 files changed, 59 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> index b4bca1d964a9..7a2f93c0c3f2 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -200,6 +200,8 @@ enum ice_feature {
>         ICE_F_PTP_EXTTS,
>         ICE_F_SMA_CTRL,
>         ICE_F_GNSS,
> +       ICE_F_ROCE_LAG,
> +       ICE_F_SRIOV_LAG,
>         ICE_F_MAX
>  };
> 
> @@ -560,6 +562,7 @@ struct ice_pf {
>         struct mutex sw_mutex;          /* lock for protecting VSI alloc flow */
>         struct mutex tc_mutex;          /* lock to protect TC changes */
>         struct mutex adev_mutex;        /* lock to protect aux device access */
> +       struct mutex lag_mutex;         /* protect ice_lag struct in PF */
>         u32 msg_enable;
>         struct ice_ptp ptp;
>         struct gnss_serial *gnss_serial;
> @@ -629,6 +632,8 @@ struct ice_pf {
>         struct ice_agg_node vf_agg_node[ICE_MAX_VF_AGG_NODES];
>  };
> 
> +extern struct workqueue_struct *ice_lag_wq;
> +
>  struct ice_netdev_priv {
>         struct ice_vsi *vsi;
>         struct ice_repr *repr;
> diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
> index 8a624cef0eb0..05ae65f1dd27 100644
> --- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
> +++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
> @@ -121,6 +121,9 @@ struct ice_aqc_list_caps_elem {
>  #define ICE_AQC_CAPS_POST_UPDATE_RESET_RESTRICT                0x0077
>  #define ICE_AQC_CAPS_NVM_MGMT                          0x0080
>  #define ICE_AQC_CAPS_TX_SCHED_TOPO_COMP_MODE           0x0085
> +#define ICE_AQC_CAPS_FW_LAG_SUPPORT                    0x0092
> +#define ICE_AQC_BIT_ROCEV2_LAG                         0x01
> +#define ICE_AQC_BIT_SRIOV_LAG                          0x02
> 
>         u8 major_ver;
>         u8 minor_ver;
> diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
> index 23a9f169bc71..fd21b5e38600 100644
> --- a/drivers/net/ethernet/intel/ice/ice_common.c
> +++ b/drivers/net/ethernet/intel/ice/ice_common.c
> @@ -2248,7 +2248,14 @@ ice_parse_common_caps(struct ice_hw *hw, struct ice_hw_common_caps *caps,
>         case ICE_AQC_CAPS_TX_SCHED_TOPO_COMP_MODE:
>                 caps->tx_sched_topo_comp_mode_en = (number == 1);
>                 break;
> -
> +       case ICE_AQC_CAPS_FW_LAG_SUPPORT:
> +               caps->roce_lag = !!(number & ICE_AQC_BIT_ROCEV2_LAG);
> +               ice_debug(hw, ICE_DBG_INIT, "%s: roce_lag = %d\n",
> +                         prefix, caps->roce_lag);
> +               caps->sriov_lag = !!(number & ICE_AQC_BIT_SRIOV_LAG);
> +               ice_debug(hw, ICE_DBG_INIT, "%s: sriov_lag = %d\n",
> +                         prefix, caps->sriov_lag);
> +               break;

roce_lag and sriov_lag are both u8 - should this be %u for unsigned int?

>         default:
>                 /* Not one of the recognized common capabilities */
>                 found = false;
> diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
> index 5a7753bda324..73bfc5cd8b37 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lag.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lag.c
> @@ -4,8 +4,12 @@
>  /* Link Aggregation code */
> 
>  #include "ice.h"
> +#include "ice_lib.h"
>  #include "ice_lag.h"
> 
> +#define ICE_LAG_RES_SHARED     BIT(14)
> +#define ICE_LAG_RES_VALID      BIT(15)
> +
>  /**
>   * ice_lag_set_primary - set PF LAG state as Primary
>   * @lag: LAG info struct
> @@ -225,6 +229,26 @@ static void ice_lag_unregister(struct ice_lag *lag, struct net_device *netdev)
>         lag->role = ICE_LAG_NONE;
>  }
> 
> +/**
> + * ice_lag_check_nvm_support - Check for NVM support for LAG
> + * @pf: PF struct
> + */
> +static void ice_lag_check_nvm_support(struct ice_pf *pf)
> +{
> +       struct ice_hw_dev_caps *caps;
> +
> +       caps = &pf->hw.dev_caps;
> +       if (caps->common_cap.roce_lag)
> +               ice_set_feature_support(pf, ICE_F_ROCE_LAG);
> +       else
> +               ice_clear_feature_support(pf, ICE_F_ROCE_LAG);
> +
> +       if (caps->common_cap.sriov_lag)
> +               ice_set_feature_support(pf, ICE_F_SRIOV_LAG);
> +       else
> +               ice_clear_feature_support(pf, ICE_F_SRIOV_LAG);
> +}
> +
>  /**
>   * ice_lag_changeupper_event - handle LAG changeupper event
>   * @lag: LAG info struct
> @@ -264,26 +288,6 @@ static void ice_lag_changeupper_event(struct ice_lag *lag, void *ptr)
>         ice_display_lag_info(lag);
>  }
> 
> -/**
> - * ice_lag_changelower_event - handle LAG changelower event
> - * @lag: LAG info struct
> - * @ptr: opaque data pointer
> - *
> - * ptr to be cast to netdev_notifier_changelowerstate_info
> - */
> -static void ice_lag_changelower_event(struct ice_lag *lag, void *ptr)
> -{
> -       struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
> -
> -       if (netdev != lag->netdev)
> -               return;
> -
> -       netdev_dbg(netdev, "bonding info\n");
> -
> -       if (!netif_is_lag_port(netdev))
> -               netdev_dbg(netdev, "CHANGELOWER rcvd, but netdev not in LAG. Bail\n");
> -}
> -
>  /**
>   * ice_lag_event_handler - handle LAG events from netdev
>   * @notif_blk: notifier block registered by this netdev
> @@ -310,9 +314,6 @@ ice_lag_event_handler(struct notifier_block *notif_blk, unsigned long event,
>         case NETDEV_CHANGEUPPER:
>                 ice_lag_changeupper_event(lag, ptr);
>                 break;
> -       case NETDEV_CHANGELOWERSTATE:
> -               ice_lag_changelower_event(lag, ptr);
> -               break;
>         case NETDEV_BONDING_INFO:
>                 ice_lag_info_event(lag, ptr);
>                 break;
> @@ -379,6 +380,8 @@ int ice_init_lag(struct ice_pf *pf)
>         struct ice_vsi *vsi;
>         int err;
> 
> +       ice_lag_check_nvm_support(pf);
> +
>         pf->lag = kzalloc(sizeof(*lag), GFP_KERNEL);
>         if (!pf->lag)
>                 return -ENOMEM;
> @@ -435,9 +438,7 @@ void ice_deinit_lag(struct ice_pf *pf)
>         if (lag->pf)
>                 ice_unregister_lag_handler(lag);
> 
> -       dev_put(lag->upper_netdev);
> -
> -       dev_put(lag->peer_netdev);
> +       flush_workqueue(ice_lag_wq);
> 
>         kfree(lag);
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
> index 5ddb95d1073a..7b98655ceeeb 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> @@ -4011,7 +4011,7 @@ bool ice_is_feature_supported(struct ice_pf *pf, enum ice_feature f)
>   * @pf: pointer to the struct ice_pf instance
>   * @f: feature enum to set
>   */
> -static void ice_set_feature_support(struct ice_pf *pf, enum ice_feature f)
> +void ice_set_feature_support(struct ice_pf *pf, enum ice_feature f)
>  {
>         if (f < 0 || f >= ICE_F_MAX)
>                 return;
> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
> index e985766e6bb5..d35fb628d7c6 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.h
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.h
> @@ -162,6 +162,7 @@ int ice_vsi_del_vlan_zero(struct ice_vsi *vsi);
>  bool ice_vsi_has_non_zero_vlans(struct ice_vsi *vsi);
>  u16 ice_vsi_num_non_zero_vlans(struct ice_vsi *vsi);
>  bool ice_is_feature_supported(struct ice_pf *pf, enum ice_feature f);
> +void ice_set_feature_support(struct ice_pf *pf, enum ice_feature f);
>  void ice_clear_feature_support(struct ice_pf *pf, enum ice_feature f);
>  void ice_init_feature_support(struct ice_pf *pf);
>  bool ice_vsi_is_rx_queue_active(struct ice_vsi *vsi);
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index b0d1e6116eb9..7030b2e54d2b 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -64,6 +64,7 @@ struct device *ice_hw_to_dev(struct ice_hw *hw)
>  }
> 
>  static struct workqueue_struct *ice_wq;
> +struct workqueue_struct *ice_lag_wq;
>  static const struct net_device_ops ice_netdev_safe_mode_ops;
>  static const struct net_device_ops ice_netdev_ops;
> 
> @@ -3780,6 +3781,7 @@ u16 ice_get_avail_rxq_count(struct ice_pf *pf)
>  static void ice_deinit_pf(struct ice_pf *pf)
>  {
>         ice_service_task_stop(pf);
> +       mutex_destroy(&pf->lag_mutex);
>         mutex_destroy(&pf->adev_mutex);
>         mutex_destroy(&pf->sw_mutex);
>         mutex_destroy(&pf->tc_mutex);
> @@ -3860,6 +3862,7 @@ static int ice_init_pf(struct ice_pf *pf)
>         mutex_init(&pf->sw_mutex);
>         mutex_init(&pf->tc_mutex);
>         mutex_init(&pf->adev_mutex);
> +       mutex_init(&pf->lag_mutex);
> 
>         INIT_HLIST_HEAD(&pf->aq_wait_list);
>         spin_lock_init(&pf->aq_wait_lock);
> @@ -5640,10 +5643,18 @@ static int __init ice_module_init(void)
>                 return -ENOMEM;
>         }
> 
> +       ice_lag_wq = alloc_ordered_workqueue("ice_lag_wq", 0);
> +       if (!ice_lag_wq) {
> +               pr_err("Failed to create LAG workqueue\n");
> +               destroy_workqueue(ice_wq);
> +               return -ENOMEM;
> +       }
> +
>         status = pci_register_driver(&ice_driver);
>         if (status) {
>                 pr_err("failed to register PCI driver, err %d\n", status);
>                 destroy_workqueue(ice_wq);
> +               destroy_workqueue(ice_lag_wq);
>         }
> 
>         return status;
> @@ -5660,6 +5671,7 @@ static void __exit ice_module_exit(void)
>  {
>         pci_unregister_driver(&ice_driver);
>         destroy_workqueue(ice_wq);
> +       destroy_workqueue(ice_lag_wq);
>         pr_info("module unloaded\n");
>  }
>  module_exit(ice_module_exit);
> diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
> index 5602695243a8..460ec75f162b 100644
> --- a/drivers/net/ethernet/intel/ice/ice_type.h
> +++ b/drivers/net/ethernet/intel/ice/ice_type.h
> @@ -277,6 +277,8 @@ struct ice_hw_common_caps {
>         u8 dcb;
>         u8 ieee_1588;
>         u8 rdma;
> +       u8 roce_lag;
> +       u8 sriov_lag;
> 
>         bool nvm_update_pending_nvm;
>         bool nvm_update_pending_orom;
> --
> 2.40.1
> 
> 

