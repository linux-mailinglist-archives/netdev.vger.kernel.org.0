Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B171D5A2686
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242003AbiHZLF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344205AbiHZLEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:04:37 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442452F66C
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661511861; x=1693047861;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WQPUokZJ/zyxD04DZp4EtBIHeKLqWB2LpoPcO5ArG28=;
  b=TNHE0VneUkeDWxie8pNTsK52blwPHsb2YsBlKflFEiOK6l7RNudXUDAn
   Ee0aB5NCstnGfYhFrUQLLT4p0dMCTSXnQ7qFcFR01nNHcvpZt1JPy/cIZ
   zAIw3nI80iKa9uk7F+6uRbpAhVQ4LZRwJ1n4nlLi6ahN+RIzW7HzoNoRW
   vItFnWxdxFRZwvjTdxeRjh+H03/B9Cg8TwGN6pCoWt0YDmuNT2c/HwCuN
   +n15KEa2sm2Zq2sb1oCqytfZPeZ6RR7lCkRcOYzl8J7tQ+Q1K8gMQ6SWi
   a/Rnyf8cB2rZLgCtDx3YdSZ2mGE/twKsS00REMRssfOEcVFtoAr/HD1kk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="295755173"
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="295755173"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 04:04:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="752840781"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 26 Aug 2022 04:04:16 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27QB4CLr024087;
        Fri, 26 Aug 2022 12:04:14 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcin.szycik@linux.intel.com, michal.swiatkowski@linux.intel.com,
        kurt@linutronix.de, boris.sukholitko@broadcom.com,
        vladbu@nvidia.com, komachi.yoshiki@gmail.com, paulb@nvidia.com,
        baowen.zheng@corigine.com, louis.peens@corigine.com,
        simon.horman@corigine.com, pablo@netfilter.org,
        maksym.glubokiy@plvision.eu, intel-wired-lan@lists.osuosl.org,
        jchapman@katalix.com, gnault@redhat.com
Subject: [RFC PATCH net-next 1/5] uapi: move IPPROTO_L2TP to in.h
Date:   Fri, 26 Aug 2022 13:00:55 +0200
Message-Id: <20220826110059.119927-2-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220826110059.119927-1-wojciech.drewek@intel.com>
References: <20220826110059.119927-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPPROTO_L2TP is currently defined in l2tp.h, but most of
ip protocols is defined in in.h file. Move it there in order
to keep code clean.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 include/uapi/linux/in.h   | 2 ++
 include/uapi/linux/l2tp.h | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index 14168225cecd..5a9454c886b3 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -68,6 +68,8 @@ enum {
 #define IPPROTO_PIM		IPPROTO_PIM
   IPPROTO_COMP = 108,		/* Compression Header Protocol		*/
 #define IPPROTO_COMP		IPPROTO_COMP
+  IPPROTO_L2TP = 115,		/* Layer 2 Tunnelling Protocol		*/
+#define IPPROTO_L2TP		IPPROTO_L2TP
   IPPROTO_SCTP = 132,		/* Stream Control Transport Protocol	*/
 #define IPPROTO_SCTP		IPPROTO_SCTP
   IPPROTO_UDPLITE = 136,	/* UDP-Lite (RFC 3828)			*/
diff --git a/include/uapi/linux/l2tp.h b/include/uapi/linux/l2tp.h
index bab8c9708611..7d81c3e1ec29 100644
--- a/include/uapi/linux/l2tp.h
+++ b/include/uapi/linux/l2tp.h
@@ -13,8 +13,6 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 
-#define IPPROTO_L2TP		115
-
 /**
  * struct sockaddr_l2tpip - the sockaddr structure for L2TP-over-IP sockets
  * @l2tp_family:  address family number AF_L2TPIP.
-- 
2.31.1

