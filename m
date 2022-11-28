Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBB263AD03
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 16:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiK1PwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 10:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiK1PwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 10:52:22 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DDF267
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 07:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669650741; x=1701186741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gu5Avi1TB7lw+9G9lcQn0ykLB+hI5CesKkgRnubSr2o=;
  b=BHU0zPS5ADxQWrMLBJO9GwOHBcyMQdeljLM+lo7JvNaScmdMCVBLh15G
   pBCR1lCTL3t8IVnvacKkT1mbBQLFVwCfcgAocE6r3e/+MqBMZkmZ8jAzi
   6O3TpByBVVxrc3kXLgSXrJBJrwyv6o0v5OuAZqLOTiaaDjB7P0Krj8q4L
   EPA/ezf2l7WHynHDqkGrEeqJ3h1uJBNpFYsnFC4P1AE9xcH8ziIBhhPZS
   huqHToq+ToJaqNJ+musDprREPfcx9O1xMWdj0y0mcbAGPQjrcIRmwddRu
   JVQkKyFDS13kQLPNU3vr58yKef8QNpCp+OyhMqlPqr5F+cRX+MXJlvHRu
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379125295"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="379125295"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 07:52:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="785676762"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="785676762"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 28 Nov 2022 07:52:03 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ASFq1B3000483;
        Mon, 28 Nov 2022 15:52:01 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "shenjian (K)" <shenjian15@huawei.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, kuba@kernel.org, ecree.xilinx@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, saeed@kernel.org,
        leon@kernel.org, netdev@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [RFCv8 PATCH net-next 00/55] net: extend the type of netdev_features_t to bitmap
Date:   Mon, 28 Nov 2022 16:51:27 +0100
Message-Id: <20221128155127.2101925-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <724a884e-d5ca-8192-b3be-bf68711be515@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com> <20221125154421.82829-1-alexandr.lobakin@intel.com> <724a884e-d5ca-8192-b3be-bf68711be515@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "shenjian (K)" <shenjian15@huawei.com>
Date: Mon, 28 Nov 2022 23:22:28 +0800

> 2022/11/25 23:44, Alexander Lobakin:
> > From: Jian Shen <shenjian15@huawei.com>
> > Date: Sun, 18 Sep 2022 09:42:41 +0000
> >
> >> For the prototype of netdev_features_t is u64, and the number
> >> of netdevice feature bits is 64 now. So there is no space to
> >> introduce new feature bit.
> >>
> >> This patchset try to solve it by change the prototype of
> >> netdev_features_t from u64 to structure below:
> >> 	typedef struct {
> >> 		DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
> >> 	} netdev_features_t;
> >>
> >> With this change, it's necessary to introduce a set of bitmap
> >> operation helpers for netdev features. [patch 1]
> > Hey,
> >
> > what's the current status, how's going?
> >
> > [...]
> Hi, Alexander
> 
> Sorry to reply late, I'm still working on this, dealing with split the 
> patchset.

Hey, no worries. Just curious as I believe lots of new features are
waiting for new bits to be available :D

> 
> Btw, could you kindly review this V8 set? I have adjusted the protocol 
> of many interfaces and helpers,

I'll try to find some time to review it this week, will see.

> to avoiding return or pass data large than 64bits. Hope to get more 

Yes, I'd prefer to not pass more than 64 bits in one function
argument, which means functions operating with netdev_features_t
must start take pointers. Otherwise, with passing netdev_features_t
directly as a struct, the very first newly added feature will do
8 -> 16 bytes on the stack per argument, boom.

> opinions.
> 
> Thanks!
> 
> Jian
> >> -- 
> >> 2.33.0
> > Thanks,
> > Olek

Thanks,
Olek
