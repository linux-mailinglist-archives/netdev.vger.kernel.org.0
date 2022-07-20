Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F306E57B95F
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 17:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241203AbiGTPOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 11:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240965AbiGTPOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 11:14:46 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE4D5A14F
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658330085; x=1689866085;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9y5lcOAkvRMJcwg+kXKlZpnpi58+70bW7jJB9LZQtd8=;
  b=Tl4UDnKi8VZ6/17sPcrgCaUAgrOhm3Uy0ijsBfTDLGX12bDmKCs8nKQN
   UWuDkX68wb/Bho39YWIGcJ88eSGajP0rFoXhG+BLsKRMFVQdkuXmLTL6h
   WSOQlmLHL0eUDNzTCbTBvKC4aAKQZyuK1BgngbuV2DHfymYQsy+WXaVkq
   mUbcFPkK93hKbQN43fV+96o43hwCpzp7SPP1ZrHYl13Frvnq/mWQDy90e
   lbkJxhDTSeQaLHpm0igZJAgxaoVjQh/RgZTEgVcFupr5CvLOggcxMwWU9
   84IkC6m5XqMHY23EdP5zn/MkTuVEvibwlAhZ7/hsk4JH5wjvuzz+EU/vl
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="284362205"
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="284362205"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 08:14:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="740321110"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 20 Jul 2022 08:14:42 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26KFEeeL027982;
        Wed, 20 Jul 2022 16:14:40 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "shenjian (K)" <shenjian15@huawei.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        ecree.xilinx@gmail.com, hkallweit1@gmail.com, saeed@kernel.org,
        leon@kernel.org, netdev@vger.kernel.org, linuxarm@openeuler.org,
        lipeng321@huawei.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: Re: [RFCv6 PATCH net-next 02/19] net: replace general features macroes with global netdev_features variables
Date:   Wed, 20 Jul 2022 17:13:47 +0200
Message-Id: <20220720151347.3875809-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <0cec0cac-dae7-cce7-ccf2-92e5d7086642@huawei.com>
References: <20220419022206.36381-1-shenjian15@huawei.com> <20220419022206.36381-3-shenjian15@huawei.com> <20220419144944.1665016-1-alexandr.lobakin@intel.com> <0cec0cac-dae7-cce7-ccf2-92e5d7086642@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: shenjian (K) <shenjian15@huawei.com>
Date: Wed, 20 Apr 2022 17:54:13 +0800

> 在 2022/4/19 22:49, Alexander Lobakin 写道:
> > From: Jian Shen <shenjian15@huawei.com>
> > Date: Tue, 19 Apr 2022 10:21:49 +0800
> >
> >> There are many netdev_features bits group used in kernel. The definition
> >> will be illegal when using feature bit more than 64. Replace these macroes
> >> with global netdev_features variables, initialize them when netdev module
> >> init.
> >>
> >> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> >> ---
> >>   drivers/net/wireguard/device.c  |  10 +-
> >>   include/linux/netdev_features.h | 102 +++++++++-----
> >>   net/core/Makefile               |   2 +-
> >>   net/core/dev.c                  |  87 ++++++++++++
> >>   net/core/netdev_features.c      | 241 ++++++++++++++++++++++++++++++++
> >>   5 files changed, 400 insertions(+), 42 deletions(-)
> >>   create mode 100644 net/core/netdev_features.c
> >>
> > --- 8< ---
> >
> >> diff --git a/net/core/dev.c b/net/core/dev.c
> >> index 4d6b57752eee..85bb418e8ef1 100644
> >> --- a/net/core/dev.c
> >> +++ b/net/core/dev.c
> >> @@ -146,6 +146,7 @@
> >>   #include <linux/sctp.h>
> >>   #include <net/udp_tunnel.h>
> >>   #include <linux/net_namespace.h>
> >> +#include <linux/netdev_features_helper.h>
> >>   #include <linux/indirect_call_wrapper.h>
> >>   #include <net/devlink.h>
> >>   #include <linux/pm_runtime.h>
> >> @@ -11255,6 +11256,90 @@ static struct pernet_operations __net_initdata default_device_ops = {
> >>   	.exit_batch = default_device_exit_batch,
> >>   };
> >>   
> >> +static void netdev_features_init(void)
> > It is an initialization function, so it must be marked as __init.
> right, I will add it, thanks!
> 
> >> +{
> >> +	netdev_features_t features;
> >> +
> >> +	netdev_features_set_array(&netif_f_never_change_feature_set,
> >> +				  &netdev_never_change_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_gso_feature_set_mask,
> > I'm not sure it does make sense to have an empty newline between
> > each call. I'd leave newlines only between the "regular" blocks
> > and the "multi-call" blocks, I mean, stuff like VLAN, GSO and
> > @netdev_ethtool_features.
> At first, I added empty newline per call for the it used three lines.
> Now the new call just use two lines, I will remove some unnecessary
> blank lines.
> 
> Thanks!

(sorry for the triple mail, at first References got screwed, then
 encoding =\)

I see no news regarding the conversion since the end of April, maybe
I could pick it and finish if nobody objects? I'll preserve the
original authorship for sure.

> 
> >> +				  &netdev_gso_features_mask);
> >> +
> >> +	netdev_features_set_array(&netif_f_ip_csum_feature_set,
> >> +				  &netdev_ip_csum_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_csum_feature_set_mask,
> >> +				  &netdev_csum_features_mask);
> >> +
> >> +	netdev_features_set_array(&netif_f_general_tso_feature_set,
> >> +				  &netdev_general_tso_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_all_tso_feature_set,
> >> +				  &netdev_all_tso_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_tso_ecn_feature_set,
> >> +				  &netdev_tso_ecn_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_all_fcoe_feature_set,
> >> +				  &netdev_all_fcoe_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_gso_soft_feature_set,
> >> +				  &netdev_gso_software_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_one_for_all_feature_set,
> >> +				  &netdev_one_for_all_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_all_for_all_feature_set,
> >> +				  &netdev_all_for_all_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_upper_disables_feature_set,
> >> +				  &netdev_upper_disable_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_soft_feature_set,
> >> +				  &netdev_soft_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_soft_off_feature_set,
> >> +				  &netdev_soft_off_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_rx_vlan_feature_set,
> >> +				  &netdev_rx_vlan_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_tx_vlan_feature_set,
> >> +				  &netdev_tx_vlan_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_vlan_filter_feature_set,
> >> +				  &netdev_vlan_filter_features);
> >> +
> >> +	netdev_all_vlan_features = netdev_rx_vlan_features;
> >> +	netdev_features_set(&netdev_all_vlan_features, netdev_tx_vlan_features);
> >> +	netdev_features_set(&netdev_all_vlan_features,
> >> +			    netdev_vlan_filter_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_ctag_vlan_feature_set,
> >> +				  &netdev_ctag_vlan_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_stag_vlan_feature_set,
> >> +				  &netdev_stag_vlan_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_gso_encap_feature_set,
> >> +				  &netdev_gso_encap_all_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_xfrm_feature_set,
> >> +				  &netdev_xfrm_features);
> >> +
> >> +	netdev_features_set_array(&netif_f_tls_feature_set,
> >> +				  &netdev_tls_features);
> >> +
> >> +	netdev_csum_gso_features_mask =
> >> +		netdev_features_or(netdev_gso_software_features,
> >> +				   netdev_csum_features_mask);
> >> +
> >> +	netdev_features_fill(&features);
> >> +	netdev_ethtool_features =
> >> +		netdev_features_andnot(features, netdev_never_change_features);
> >> +}
> >> +
> >>   /*
> >>    *	Initialize the DEV module. At boot time this walks the device list and
> >>    *	unhooks any devices that fail to initialise (normally hardware not
> > --- 8< ---
> >
> >> -- 
> >> 2.33.0
> > Thanks,
> > Al
> >
> > .
> >

Thanks,
Olek
