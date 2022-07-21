Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49E557CE61
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiGUO6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbiGUO6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:58:37 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0598689F
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 07:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658415516; x=1689951516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tdwBRVC6Xmgk7iGYRKJIl5Uum1pUfZGlMcYYqR8HW8Y=;
  b=e/sXYgw18t82hyrtJPmzjL4z93W1i+3cC7PIDy7aLa1sG7OaasUJ0/je
   B/ZMoKGkMWKo1dKtfnJlPIp+xsYpLnrrJ2UHCkeDO/xPUdBrqsSZJVu6B
   myqAKD11HQ1CFLxs610B+rZFe31aH8PPiQLH8DVoD0lmpa9OPTqNGQGJv
   W/kxuO8BpdG4XZx1dcXlc7TDDmQbTKtoT6/xvBdVdE9eOkV+0lVsV6tDW
   yHfcS2WZ2M3S4Okg+ifaD3+jiCj1dJLDB6L9WKtl+8vi/giRX+brt8VFz
   qPYYCqxASafEK7BzckbVXCBYEJkM+It+9ty5oyYw5XwEADUXmpJyWgHSC
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="273917241"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="273917241"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 07:58:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="598489624"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 21 Jul 2022 07:58:32 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26LEwV31023204;
        Thu, 21 Jul 2022 15:58:31 +0100
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
Date:   Thu, 21 Jul 2022 16:57:16 +0200
Message-Id: <20220721145716.745433-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <eb0625cd-26a4-439a-1aca-fcc773393b8b@huawei.com>
References: <0cec0cac-dae7-cce7-ccf2-92e5d7086642@huawei.com> <20220720150957.3875487-1-alexandr.lobakin@intel.com> <eb0625cd-26a4-439a-1aca-fcc773393b8b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: shenjian (K) <shenjian15@huawei.com>
Date: Thu, 21 Jul 2022 09:15:59 +0800

> 在 2022/7/20 23:09, Alexander Lobakin 写道:
> > From: shenjian (K) <shenjian15@huawei.com>
> > Date: Wed, 20 Apr 2022 17:54:13 +0800
> >
> >> 在 2022/4/19 22:49, Alexander Lobakin 写道:
> >> > From: Jian Shen <shenjian15@huawei.com>
> >> > Date: Tue, 19 Apr 2022 10:21:49 +0800
> >> >
> >> >> There are many netdev_features bits group used in kernel. The 
> >> definition
> >> >> will be illegal when using feature bit more than 64. Replace these 
> >> macroes
> >> >> with global netdev_features variables, initialize them when netdev 
> >> module
> >> >> init.
> >> >>
> >> >> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> >> >> ---
> >> >>   drivers/net/wireguard/device.c  |  10 +-
> >> >>   include/linux/netdev_features.h | 102 +++++++++-----
> >> >>   net/core/Makefile               |   2 +-
> >> >>   net/core/dev.c                  |  87 ++++++++++++
> >> >>   net/core/netdev_features.c      | 241 
> >> ++++++++++++++++++++++++++++++++
> >> >>   5 files changed, 400 insertions(+), 42 deletions(-)
> >> >>   create mode 100644 net/core/netdev_features.c
> >> >>
> >> > --- 8< ---
> >> >
> >> >> diff --git a/net/core/dev.c b/net/core/dev.c
> >> >> index 4d6b57752eee..85bb418e8ef1 100644
> >> >> --- a/net/core/dev.c
> >> >> +++ b/net/core/dev.c
> >> >> @@ -146,6 +146,7 @@
> >> >>   #include <linux/sctp.h>
> >> >>   #include <net/udp_tunnel.h>
> >> >>   #include <linux/net_namespace.h>
> >> >> +#include <linux/netdev_features_helper.h>
> >> >>   #include <linux/indirect_call_wrapper.h>
> >> >>   #include <net/devlink.h>
> >> >>   #include <linux/pm_runtime.h>
> >> >> @@ -11255,6 +11256,90 @@ static struct pernet_operations 
> >> __net_initdata default_device_ops = {
> >> >>       .exit_batch = default_device_exit_batch,
> >> >>   };
> >> >>   >> +static void netdev_features_init(void)
> >> > It is an initialization function, so it must be marked as __init.
> >> right, I will add it, thanks!
> >>
> >> >> +{
> >> >> +    netdev_features_t features;
> >> >> +
> >> >> + netdev_features_set_array(&netif_f_never_change_feature_set,
> >> >> +                  &netdev_never_change_features);
> >> >> +
> >> >> + netdev_features_set_array(&netif_f_gso_feature_set_mask,
> >> > I'm not sure it does make sense to have an empty newline between
> >> > each call. I'd leave newlines only between the "regular" blocks
> >> > and the "multi-call" blocks, I mean, stuff like VLAN, GSO and
> >> > @netdev_ethtool_features.
> >> At first, I added empty newline per call for the it used three lines.
> >> Now the new call just use two lines, I will remove some unnecessary
> >> blank lines.
> >>
> >> Thanks!
> >
> > I see no news regarding the conversion since the end of April, maybe
> > I could pick it and finish if nobody objects? I'll preserve the
> > original authorship for sure.
> >
> Hi， Alexander
> 
> Sorry for late to finish the whole patchset with treewide changes, but 
> I'm still working on it.
> And most of the convertsions have been completed. I will send to new 
> patchset in two weeks.

Oh okay, I was only worried that it could be abandoned for some
reason. Great to hear it's almost done, 120+ drivers is not
something quick or exciting :)
I'll start reviewing the series, at least its "core" part, as soon
as it hits netdev ML. Thanks!

> 
> Jian
> 
> >>
> >> >> +                  &netdev_gso_features_mask);

[...]

> > Thanks,
> > Olek
> >
> > .
> >
> 

Olek
