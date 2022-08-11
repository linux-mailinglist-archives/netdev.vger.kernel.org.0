Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E54058FAF0
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 12:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbiHKKvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 06:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233884AbiHKKvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 06:51:42 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E6C80F73
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 03:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660215101; x=1691751101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cd8hXPZRGkvy4Z7QjEyN2n6ofbRPcPq2avevoVc1c9E=;
  b=HDR0SMEdkbasy8MqIuAHkSU+FsYwjhZzzbEalT/gXDboULKIM7GQuawz
   VxmOuJQBOWm9Vcmz0jTBCJIksi/K+8OsezAPByKPPcq3tU1L1cy5wOxrj
   m63KVDCm6gIuYrXotZctjmaJbmkSXrQyfONYputSXbi04B4jSDIsGCrH+
   tRuW8PEgQGvPoMPdtkSsmTkj6Dy5t2U710ZIpyPeZOKxr1SRo/7yxhTWS
   86XDWSama7e+2qi/UjQRl4Pq4KwLg2b4I6xu//AKqNTEdHlPpftpF4Flc
   3yt6hbtjoCm1RL/VKRMjbbGo9p/ncYyKDHYcvcQ39we1GGDzUF3AryMop
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="271702071"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="271702071"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 03:51:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="581624347"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 11 Aug 2022 03:51:38 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27BApaVb000420;
        Thu, 11 Aug 2022 11:51:37 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "shenjian (K)" <shenjian15@huawei.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        ecree.xilinx@gmail.com, hkallweit1@gmail.com, saeed@kernel.org,
        leon@kernel.org, netdev@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [RFCv7 PATCH net-next 01/36] net: introduce operation helpers for netdev features
Date:   Thu, 11 Aug 2022 12:49:36 +0200
Message-Id: <20220811104936.3675-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <444c4f87-ed36-721a-f619-97c7725e2c87@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com> <20220810030624.34711-2-shenjian15@huawei.com> <20220810094358.1303843-1-alexandr.lobakin@intel.com> <444c4f87-ed36-721a-f619-97c7725e2c87@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "shenjian (K)" <shenjian15@huawei.com>
Date: Wed, 10 Aug 2022 19:32:28 +0800

> 在 2022/8/10 17:43, Alexander Lobakin 写道:
> > From: Jian Shen <shenjian15@huawei.com>
> > Date: Wed, 10 Aug 2022 11:05:49 +0800
> >
> >> Introduce a set of bitmap operation helpers for netdev features,
> >> then we can use them to replace the logical operation with them.
> >>
> >> The implementation of these helpers are based on the old prototype
> >> of netdev_features_t is still u64. These helpers will be rewritten
> >> on the last patch, when the prototype changes.
> >>
> >> To avoid interdependencies between netdev_features_helper.h and
> >> netdevice.h, put the helpers for testing feature in the netdevice.h,
> >> and move advandced helpers like netdev_get_wanted_features() and
> >> netdev_intersect_features() to netdev_features_helper.h.
> >>
> >> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> >> ---
> >>   include/linux/netdev_features.h        |  11 +
> >>   include/linux/netdev_features_helper.h | 707 +++++++++++++++++++++++++
> > 'netdev_feature_helpers.h' fits more I guess, doesn't it? It
> > contains several helpers, not only one.
> ok， will rename it.
> 
> > And BTW, do you think it's worth to create a new file rather than
> > put everything just in netdev_features.h?
> Jakub suggested me to move them to a new file, then it can be includued
> at users appropriately. 
> [https://www.spinics.net/lists/netdev/msg809370.html]
> 
> And it's unable to put everything in netdev_features.h, because these 
> helpers
> need to see the definition of struct net_device which is defined in 
> netdevice.h.
> It leading interdependence for netdeice.h include netdev_features.h.

Ah, correct then, sure! I missed that fact.

> 
> 
> >>   include/linux/netdevice.h              |  45 +-
> >>   net/8021q/vlan_dev.c                   |   1 +
> >>   net/core/dev.c                         |   1 +
> >>   5 files changed, 747 insertions(+), 18 deletions(-)
> >>   create mode 100644 include/linux/netdev_features_helper.h
> >>
> >> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> >> index 7c2d77d75a88..9d434b4e6e6e 100644
> >> --- a/include/linux/netdev_features.h
> >> +++ b/include/linux/netdev_features.h
> >> @@ -11,6 +11,17 @@
> >>   
> >>   typedef u64 netdev_features_t;
> >>   
> >> +struct netdev_feature_set {
> >> +	unsigned int cnt;
> >> +	unsigned short feature_bits[];
> >> +};
> >> +
> >> +#define DECLARE_NETDEV_FEATURE_SET(name, features...)			\
> >> +	const struct netdev_feature_set name = {			\
> >> +		.cnt = sizeof((unsigned short[]){ features }) / sizeof(unsigned short),	\
> >> +		.feature_bits = { features },				\
> >> +	}
> >> +
> >>   enum {
> >>   	NETIF_F_SG_BIT,			/* Scatter/gather IO. */
> >>   	NETIF_F_IP_CSUM_BIT,		/* Can checksum TCP/UDP over IPv4. */
> >> diff --git a/include/linux/netdev_features_helper.h b/include/linux/netdev_features_helper.h
> >> new file mode 100644
> >> index 000000000000..5423927d139b
> >> --- /dev/null
> >> +++ b/include/linux/netdev_features_helper.h
> >> @@ -0,0 +1,707 @@
> >> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> >> +/*
> >> + * Network device features helpers.
> >> + */
> >> +#ifndef _LINUX_NETDEV_FEATURES_HELPER_H
> >> +#define _LINUX_NETDEV_FEATURES_HELPER_H
> >> +
> >> +#include <linux/netdevice.h>
> >> +
> >> +static inline void netdev_features_zero(netdev_features_t *dst)
> >> +{
> >> +	*dst = 0;
> >> +}
> >> +
> >> +/* active_feature prefer to netdev->features */
> >> +#define netdev_active_features_zero(ndev) \
> >> +		netdev_features_zero(&ndev->features)
> > netdev_features_t sometimes is being placed and used on the stack.
> > I think it's better to pass just `netdev_features_t *` to those
> > helpers, this way you wouldn't also need to create a new helper
> > for each net_device::*_features.
> My purpose of defining  helpers for each net_device::*_features is to
> avoiding driver to change  net_device::*_features directly.

But why? My point is that you have to create a whole bunch of
copy'n'paste functions differing only by the &net_device field
name.

> 
> >> +
> >> +#define netdev_hw_features_zero(ndev) \
> >> +		netdev_features_zero(&ndev->hw_features)

Oh BTW: wrap `ndev` in the netdev_features_zero() call into braces,
`netdev_feature_zero(&(ndev)->hw_features)`, otherwise it may cause
unwanted sneaky logical changes or build failures.

> >> +
> >> +#define netdev_wanted_features_zero(ndev) \
> > [...]
> >
> >> +#define netdev_gso_partial_features_and(ndev, __features) \
> >> +		netdev_features_and(ndev->gso_partial_features, __features)
> >> +
> >> +/* helpers for netdev features '&=' operation */
> >> +static inline void
> >> +netdev_features_mask(netdev_features_t *dst,
> >> +			   const netdev_features_t features)
> >> +{
> >> +	*dst = netdev_features_and(*dst, features);
> > A small proposal: if you look at bitmap_and() for example, it
> > returns 1 if the resulting bitmap is non-empty and 0 if it is. What
> > about doing the same here? It would probably help to do reduce
> > boilerplating in the drivers where we only want to know if there's
> > anything left after masking.
> > Same for xor, toggle etc.
> Thanks for point this.  Return whether empty, then I can remove 
> netdev_features_intersects
> helpers. But there are also many places to use 'f1 & f2' as return value 
> or input param, then
> I need to define more temporay features to store the result, and then 
> return the temporay
> features or pass into it.

No, netdev_features_intersects() is okay, leave it as it is. Just
look on bitmap_*() prototypes and return its values when applicable.

> 
> >> +}
> >> +
> >> +static inline void
> >> +netdev_active_features_mask(struct net_device *ndev,
> >> +			    const netdev_features_t features)
> >> +{
> >> +	ndev->features = netdev_active_features_and(ndev, features);
> >> +}
> > [...]
> >
> >> +/* helpers for netdev features 'set bit array' operation */
> >> +static inline void
> >> +netdev_features_set_array(const struct netdev_feature_set *set,
> >> +			  netdev_features_t *dst)
> >> +{
> >> +	int i;
> >> +
> >> +	for (i = 0; i < set->cnt; i++)
> > Nit: kernel is C11 now, you can do just `for (u32 i = 0; i ...`.
> > (and yeah, it's better to use unsigned types when you don't plan
> > to store negative values there).
> ok, will fix it.
> 
> >> +		netdev_feature_add(set->feature_bits[i], dst);
> >> +}
> > [...]
> >
> >> -- 
> >> 2.33.0
> > Thanks,
> > Olek
> >
> > .

Thanks,
Olek
