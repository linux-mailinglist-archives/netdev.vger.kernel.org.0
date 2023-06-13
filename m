Return-Path: <netdev+bounces-10446-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85F8072E8BA
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:44:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91F3C1C2084E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7D62106C;
	Tue, 13 Jun 2023 16:44:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AE318002
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 16:44:14 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F1011D
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 09:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686674652; x=1718210652;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JZd/MBL3pQm9j7szbpKNvGCZd9Hg/TAYU2X7FC0qGVw=;
  b=B7s+7YzGL8ZgCdnMbmqalnnEcWk0hYhMUndJhgYbPFp6FsEWPN6nuqo/
   AFHtKvkY3V3fG47YOquz5XnvV2IgIjcx6WpWfRXl+r4VknfKfZiMpnKkz
   K1WKpDL7tWVPyP6ajVcyzwiONgq4svNJUanbrBuyiJdnS8EL5/nH/TnYE
   4g6cMynHkABFim6kFHVPYU4i9FyDbyFIJX3hOvM5RX5kTcBkI0pCAxEI0
   LkXbwj7PtUrmmsbbDABZuXLSiuU/NE874BdcMBiD1jNz95smiCUaqTOTs
   AAX94SQFqzilPu97cuf3SZCXay4rOWqH9eaY3Oyhuv08hNrclPkNN2NUo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="348049676"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="348049676"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 09:44:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="744752190"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="744752190"
Received: from lkp-server01.sh.intel.com (HELO 211f47bdb1cb) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 13 Jun 2023 09:44:08 -0700
Received: from kbuild by 211f47bdb1cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q977o-0001YC-0X;
	Tue, 13 Jun 2023 16:44:08 +0000
Date: Wed, 14 Jun 2023 00:43:10 +0800
From: kernel test robot <lkp@intel.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	intel-wired-lan@lists.osuosl.org
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
	fred@cloudflare.com,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH iwl-next] ice: allow hot-swapping XDP programs
Message-ID: <202306140054.1fcSzVzu-lkp@intel.com>
References: <20230613151005.337462-1-maciej.fijalkowski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613151005.337462-1-maciej.fijalkowski@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Maciej,

kernel test robot noticed the following build warnings:

[auto build test WARNING on tnguy-next-queue/dev-queue]

url:    https://github.com/intel-lab-lkp/linux/commits/Maciej-Fijalkowski/ice-allow-hot-swapping-XDP-programs/20230613-231046
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue.git dev-queue
patch link:    https://lore.kernel.org/r/20230613151005.337462-1-maciej.fijalkowski%40intel.com
patch subject: [PATCH iwl-next] ice: allow hot-swapping XDP programs
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20230614/202306140054.1fcSzVzu-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 12.3.0
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git remote add tnguy-next-queue https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue.git
        git fetch tnguy-next-queue dev-queue
        git checkout tnguy-next-queue/dev-queue
        b4 shazam https://lore.kernel.org/r/20230613151005.337462-1-maciej.fijalkowski@intel.com
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=alpha olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=alpha SHELL=/bin/bash drivers/net/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306140054.1fcSzVzu-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/intel/ice/ice_main.c: In function 'ice_xdp_setup_prog':
   drivers/net/ethernet/intel/ice/ice_main.c:2978:12: error: invalid storage class for function 'ice_xdp_safe_mode'
    2978 | static int ice_xdp_safe_mode(struct net_device __always_unused *dev,
         |            ^~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:2978:1: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
    2978 | static int ice_xdp_safe_mode(struct net_device __always_unused *dev,
         | ^~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:2992:12: error: invalid storage class for function 'ice_xdp'
    2992 | static int ice_xdp(struct net_device *dev, struct netdev_bpf *xdp)
         |            ^~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3017:13: error: invalid storage class for function 'ice_ena_misc_vector'
    3017 | static void ice_ena_misc_vector(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3055:20: error: invalid storage class for function 'ice_misc_intr'
    3055 | static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
         |                    ^~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3188:20: error: invalid storage class for function 'ice_misc_intr_thread_fn'
    3188 | static irqreturn_t ice_misc_intr_thread_fn(int __always_unused irq, void *data)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3222:13: error: invalid storage class for function 'ice_dis_ctrlq_interrupts'
    3222 | static void ice_dis_ctrlq_interrupts(struct ice_hw *hw)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3246:13: error: invalid storage class for function 'ice_free_irq_msix_misc'
    3246 | static void ice_free_irq_msix_misc(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3268:13: error: invalid storage class for function 'ice_ena_ctrlq_interrupts'
    3268 | static void ice_ena_ctrlq_interrupts(struct ice_hw *hw, u16 reg_idx)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3302:12: error: invalid storage class for function 'ice_req_irq_msix_misc'
    3302 | static int ice_req_irq_msix_misc(struct ice_pf *pf)
         |            ^~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3357:13: error: invalid storage class for function 'ice_napi_add'
    3357 | static void ice_napi_add(struct ice_vsi *vsi)
         |             ^~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3373:13: error: invalid storage class for function 'ice_set_ops'
    3373 | static void ice_set_ops(struct ice_vsi *vsi)
         |             ^~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3400:13: error: invalid storage class for function 'ice_set_netdev_features'
    3400 | static void ice_set_netdev_features(struct net_device *netdev)
         |             ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3509:1: error: invalid storage class for function 'ice_pf_vsi_setup'
    3509 | ice_pf_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi)
         | ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3521:1: error: invalid storage class for function 'ice_chnl_vsi_setup'
    3521 | ice_chnl_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
         | ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3543:1: error: invalid storage class for function 'ice_ctrl_vsi_setup'
    3543 | ice_ctrl_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi)
         | ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3583:1: error: invalid storage class for function 'ice_vlan_rx_add_vid'
    3583 | ice_vlan_rx_add_vid(struct net_device *netdev, __be16 proto, u16 vid)
         | ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3646:1: error: invalid storage class for function 'ice_vlan_rx_kill_vid'
    3646 | ice_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
         | ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3710:13: error: invalid storage class for function 'ice_rep_indr_tc_block_unbind'
    3710 | static void ice_rep_indr_tc_block_unbind(void *cb_priv)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3722:13: error: invalid storage class for function 'ice_tc_indir_block_unregister'
    3722 | static void ice_tc_indir_block_unregister(struct ice_vsi *vsi)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3736:12: error: invalid storage class for function 'ice_tc_indir_block_register'
    3736 | static int ice_tc_indir_block_register(struct ice_vsi *vsi)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3756:1: error: invalid storage class for function 'ice_get_avail_q_count'
    3756 | ice_get_avail_q_count(unsigned long *pf_qmap, struct mutex *lock, u16 size)
         | ^~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3793:13: error: invalid storage class for function 'ice_deinit_pf'
    3793 | static void ice_deinit_pf(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3820:13: error: invalid storage class for function 'ice_set_pf_caps'
    3820 | static void ice_set_pf_caps(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3869:12: error: invalid storage class for function 'ice_init_pf'
    3869 | static int ice_init_pf(struct ice_pf *pf)
         |            ^~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3982:13: error: invalid storage class for function 'ice_set_safe_mode_vlan_cfg'
    3982 | static void ice_set_safe_mode_vlan_cfg(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4033:13: error: invalid storage class for function 'ice_log_pkg_init'
    4033 | static void ice_log_pkg_init(struct ice_hw *hw, enum ice_ddp_state state)
         |             ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4118:1: error: invalid storage class for function 'ice_load_pkg'
    4118 | ice_load_pkg(const struct firmware *firmware, struct ice_pf *pf)
         | ^~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4157:13: error: invalid storage class for function 'ice_verify_cacheline_size'
    4157 | static void ice_verify_cacheline_size(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4170:12: error: invalid storage class for function 'ice_send_version'
    4170 | static int ice_send_version(struct ice_pf *pf)
         |            ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4189:12: error: invalid storage class for function 'ice_init_fdir'
    4189 | static int ice_init_fdir(struct ice_pf *pf)
         |            ^~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4230:13: error: invalid storage class for function 'ice_deinit_fdir'
    4230 | static void ice_deinit_fdir(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4251:14: error: invalid storage class for function 'ice_get_opt_fw_name'
    4251 | static char *ice_get_opt_fw_name(struct ice_pf *pf)
         |              ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4281:13: error: invalid storage class for function 'ice_request_fw'
    4281 | static void ice_request_fw(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4322:13: error: invalid storage class for function 'ice_print_wake_reason'
    4322 | static void ice_print_wake_reason(struct ice_pf *pf)
--
         |                            ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9155:28: note: (near initialization for 'ice_netdev_safe_mode_ops.ndo_get_stats64')
   drivers/net/ethernet/intel/ice/ice_main.c:9156:27: error: initializer element is not constant
    9156 |         .ndo_tx_timeout = ice_tx_timeout,
         |                           ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9156:27: note: (near initialization for 'ice_netdev_safe_mode_ops.ndo_tx_timeout')
   drivers/net/ethernet/intel/ice/ice_main.c:9157:20: error: initializer element is not constant
    9157 |         .ndo_bpf = ice_xdp_safe_mode,
         |                    ^~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9157:20: note: (near initialization for 'ice_netdev_safe_mode_ops.ndo_bpf')
   drivers/net/ethernet/intel/ice/ice_main.c:9161:21: error: initializer element is not constant
    9161 |         .ndo_open = ice_open,
         |                     ^~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9161:21: note: (near initialization for 'ice_netdev_ops.ndo_open')
   drivers/net/ethernet/intel/ice/ice_main.c:9162:21: error: initializer element is not constant
    9162 |         .ndo_stop = ice_stop,
         |                     ^~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9162:21: note: (near initialization for 'ice_netdev_ops.ndo_stop')
   drivers/net/ethernet/intel/ice/ice_main.c:9165:31: error: initializer element is not constant
    9165 |         .ndo_features_check = ice_features_check,
         |                               ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9165:31: note: (near initialization for 'ice_netdev_ops.ndo_features_check')
   drivers/net/ethernet/intel/ice/ice_main.c:9166:29: error: initializer element is not constant
    9166 |         .ndo_fix_features = ice_fix_features,
         |                             ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9166:29: note: (near initialization for 'ice_netdev_ops.ndo_fix_features')
   drivers/net/ethernet/intel/ice/ice_main.c:9167:28: error: initializer element is not constant
    9167 |         .ndo_set_rx_mode = ice_set_rx_mode,
         |                            ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9167:28: note: (near initialization for 'ice_netdev_ops.ndo_set_rx_mode')
   drivers/net/ethernet/intel/ice/ice_main.c:9168:32: error: initializer element is not constant
    9168 |         .ndo_set_mac_address = ice_set_mac_address,
         |                                ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9168:32: note: (near initialization for 'ice_netdev_ops.ndo_set_mac_address')
   drivers/net/ethernet/intel/ice/ice_main.c:9170:27: error: initializer element is not constant
    9170 |         .ndo_change_mtu = ice_change_mtu,
         |                           ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9170:27: note: (near initialization for 'ice_netdev_ops.ndo_change_mtu')
   drivers/net/ethernet/intel/ice/ice_main.c:9171:28: error: initializer element is not constant
    9171 |         .ndo_get_stats64 = ice_get_stats64,
         |                            ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9171:28: note: (near initialization for 'ice_netdev_ops.ndo_get_stats64')
   drivers/net/ethernet/intel/ice/ice_main.c:9172:31: error: initializer element is not constant
    9172 |         .ndo_set_tx_maxrate = ice_set_tx_maxrate,
         |                               ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9172:31: note: (near initialization for 'ice_netdev_ops.ndo_set_tx_maxrate')
   drivers/net/ethernet/intel/ice/ice_main.c:9173:26: error: initializer element is not constant
    9173 |         .ndo_eth_ioctl = ice_eth_ioctl,
         |                          ^~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9173:26: note: (near initialization for 'ice_netdev_ops.ndo_eth_ioctl')
   drivers/net/ethernet/intel/ice/ice_main.c:9182:32: error: initializer element is not constant
    9182 |         .ndo_vlan_rx_add_vid = ice_vlan_rx_add_vid,
         |                                ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9182:32: note: (near initialization for 'ice_netdev_ops.ndo_vlan_rx_add_vid')
   drivers/net/ethernet/intel/ice/ice_main.c:9183:33: error: initializer element is not constant
    9183 |         .ndo_vlan_rx_kill_vid = ice_vlan_rx_kill_vid,
         |                                 ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9183:33: note: (near initialization for 'ice_netdev_ops.ndo_vlan_rx_kill_vid')
   drivers/net/ethernet/intel/ice/ice_main.c:9184:25: error: initializer element is not constant
    9184 |         .ndo_setup_tc = ice_setup_tc,
         |                         ^~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9184:25: note: (near initialization for 'ice_netdev_ops.ndo_setup_tc')
   drivers/net/ethernet/intel/ice/ice_main.c:9185:29: error: initializer element is not constant
    9185 |         .ndo_set_features = ice_set_features,
         |                             ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9185:29: note: (near initialization for 'ice_netdev_ops.ndo_set_features')
   drivers/net/ethernet/intel/ice/ice_main.c:9186:31: error: initializer element is not constant
    9186 |         .ndo_bridge_getlink = ice_bridge_getlink,
         |                               ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9186:31: note: (near initialization for 'ice_netdev_ops.ndo_bridge_getlink')
   drivers/net/ethernet/intel/ice/ice_main.c:9187:31: error: initializer element is not constant
    9187 |         .ndo_bridge_setlink = ice_bridge_setlink,
         |                               ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9187:31: note: (near initialization for 'ice_netdev_ops.ndo_bridge_setlink')
   drivers/net/ethernet/intel/ice/ice_main.c:9188:24: error: initializer element is not constant
    9188 |         .ndo_fdb_add = ice_fdb_add,
         |                        ^~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9188:24: note: (near initialization for 'ice_netdev_ops.ndo_fdb_add')
   drivers/net/ethernet/intel/ice/ice_main.c:9189:24: error: initializer element is not constant
    9189 |         .ndo_fdb_del = ice_fdb_del,
         |                        ^~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9189:24: note: (near initialization for 'ice_netdev_ops.ndo_fdb_del')
   drivers/net/ethernet/intel/ice/ice_main.c:9193:27: error: initializer element is not constant
    9193 |         .ndo_tx_timeout = ice_tx_timeout,
         |                           ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9193:27: note: (near initialization for 'ice_netdev_ops.ndo_tx_timeout')
   drivers/net/ethernet/intel/ice/ice_main.c:9194:20: error: initializer element is not constant
    9194 |         .ndo_bpf = ice_xdp,
         |                    ^~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9194:20: note: (near initialization for 'ice_netdev_ops.ndo_bpf')
   drivers/net/ethernet/intel/ice/ice_main.c:9197:1: error: expected declaration or statement at end of input
    9197 | };
         | ^
   drivers/net/ethernet/intel/ice/ice_main.c:9160:36: warning: unused variable 'ice_netdev_ops' [-Wunused-variable]
    9160 | static const struct net_device_ops ice_netdev_ops = {
         |                                    ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:9148:36: warning: unused variable 'ice_netdev_safe_mode_ops' [-Wunused-variable]
    9148 | static const struct net_device_ops ice_netdev_safe_mode_ops = {
         |                                    ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c: At top level:
>> drivers/net/ethernet/intel/ice/ice_main.c:70:13: warning: 'ice_rebuild' used but never defined
      70 | static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type);
         |             ^~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:72:13: warning: 'ice_vsi_release_all' used but never defined
      72 | static void ice_vsi_release_all(struct ice_pf *pf);
         |             ^~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:74:12: warning: 'ice_rebuild_channels' used but never defined
      74 | static int ice_rebuild_channels(struct ice_pf *pf);
         |            ^~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:75:13: warning: 'ice_remove_q_channels' used but never defined
      75 | static void ice_remove_q_channels(struct ice_vsi *vsi, bool rem_adv_fltr);
         |             ^~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:78:1: warning: 'ice_indr_setup_tc_cb' used but never defined
      78 | ice_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch,
         | ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:8995:5: warning: 'ice_open_internal' defined but not used [-Wunused-function]
    8995 | int ice_open_internal(struct net_device *netdev)
         |     ^~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:8946:1: warning: 'ice_indr_setup_tc_cb' defined but not used [-Wunused-function]
    8946 | ice_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch,
         | ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:8479:12: warning: 'ice_rebuild_channels' defined but not used [-Wunused-function]
    8479 | static int ice_rebuild_channels(struct ice_pf *pf)
         |            ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:7601:5: warning: 'ice_get_rss_key' defined but not used [-Wunused-function]
    7601 | int ice_get_rss_key(struct ice_vsi *vsi, u8 *seed)
         |     ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:7572:5: warning: 'ice_get_rss_lut' defined but not used [-Wunused-function]
    7572 | int ice_get_rss_lut(struct ice_vsi *vsi, u8 *lut, u16 lut_size)
         |     ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:7548:5: warning: 'ice_set_rss_key' defined but not used [-Wunused-function]
    7548 | int ice_set_rss_key(struct ice_vsi *vsi, u8 *seed)
         |     ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:7519:5: warning: 'ice_set_rss_lut' defined but not used [-Wunused-function]
    7519 | int ice_set_rss_lut(struct ice_vsi *vsi, u8 *lut, u16 lut_size)
         |     ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:7187:13: warning: 'ice_rebuild' defined but not used [-Wunused-function]
    7187 | static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
         |             ^~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:7076:13: warning: 'ice_vsi_release_all' defined but not used [-Wunused-function]
    7076 | static void ice_vsi_release_all(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6960:5: warning: 'ice_vsi_open_ctrl' defined but not used [-Wunused-function]
    6960 | int ice_vsi_open_ctrl(struct ice_vsi *vsi)
         |     ^~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6867:5: warning: 'ice_down_up' defined but not used [-Wunused-function]
    6867 | int ice_down_up(struct ice_vsi *vsi)
         |     ^~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6589:6: warning: 'ice_update_pf_stats' defined but not used [-Wunused-function]
    6589 | void ice_update_pf_stats(struct ice_pf *pf)
         |      ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6547:6: warning: 'ice_update_vsi_stats' defined but not used [-Wunused-function]
    6547 | void ice_update_vsi_stats(struct ice_vsi *vsi)
         |      ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4929:6: warning: 'ice_unload' defined but not used [-Wunused-function]
    4929 | void ice_unload(struct ice_pf *pf)
         |      ^~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4882:5: warning: 'ice_load' defined but not used [-Wunused-function]
    4882 | int ice_load(struct ice_pf *pf)
         |     ^~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3939:5: warning: 'ice_vsi_recfg_qs' defined but not used [-Wunused-function]
    3939 | int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx, bool locked)
         |     ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3915:6: warning: 'ice_is_wol_supported' defined but not used [-Wunused-function]
    3915 | bool ice_is_wol_supported(struct ice_hw *hw)
         |      ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3563:1: warning: 'ice_lb_vsi_setup' defined but not used [-Wunused-function]
    3563 | ice_lb_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi)
         | ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3492:6: warning: 'ice_fill_rss_lut' defined but not used [-Wunused-function]
    3492 | void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size)
         |      ^~~~~~~~~~~~~~~~


vim +2978 drivers/net/ethernet/intel/ice/ice_main.c

efc2214b6047b6 Maciej Fijalkowski 2019-11-04  2972  
ebc5399ea1dfcd Maciej Fijalkowski 2021-05-20  2973  /**
ebc5399ea1dfcd Maciej Fijalkowski 2021-05-20  2974   * ice_xdp_safe_mode - XDP handler for safe mode
ebc5399ea1dfcd Maciej Fijalkowski 2021-05-20  2975   * @dev: netdevice
ebc5399ea1dfcd Maciej Fijalkowski 2021-05-20  2976   * @xdp: XDP command
ebc5399ea1dfcd Maciej Fijalkowski 2021-05-20  2977   */
ebc5399ea1dfcd Maciej Fijalkowski 2021-05-20 @2978  static int ice_xdp_safe_mode(struct net_device __always_unused *dev,
ebc5399ea1dfcd Maciej Fijalkowski 2021-05-20  2979  			     struct netdev_bpf *xdp)
ebc5399ea1dfcd Maciej Fijalkowski 2021-05-20  2980  {
ebc5399ea1dfcd Maciej Fijalkowski 2021-05-20  2981  	NL_SET_ERR_MSG_MOD(xdp->extack,
ebc5399ea1dfcd Maciej Fijalkowski 2021-05-20  2982  			   "Please provide working DDP firmware package in order to use XDP\n"
ebc5399ea1dfcd Maciej Fijalkowski 2021-05-20  2983  			   "Refer to Documentation/networking/device_drivers/ethernet/intel/ice.rst");
ebc5399ea1dfcd Maciej Fijalkowski 2021-05-20  2984  	return -EOPNOTSUPP;
ebc5399ea1dfcd Maciej Fijalkowski 2021-05-20  2985  }
ebc5399ea1dfcd Maciej Fijalkowski 2021-05-20  2986  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

