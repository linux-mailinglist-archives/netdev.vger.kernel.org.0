Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6235EBD34
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiI0I1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiI0I1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:27:03 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F6DA4B9C
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 01:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664267222; x=1695803222;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oRbzxcD/EYelfJirzanDTW2ZtajAcEZtBzGOaqFQF74=;
  b=bIeTZBif8N3Fnqs0V0d8JY5UsAD2Kb1BtTc8rvYJGWcsYFAsUYIPMlYA
   PsuQ2LNbLWxTwd6AvTjI7G6FeH8TgaoBttTLz07Vmamo9dLc4Z2+thc0L
   7MaFU8CWA+VnEN06UjzUlUKJPU9CStZx7+WwmI1KrTfI0V7I6ejO+ESNT
   3lwnC2jRaXH4IgVPvK9T/ilVMI0CVNB67tpQ3gOZkshIdCkspcSk1gi+Q
   b769aoD5AUMPPqcXp1eSz0URYTCk0m1ld2Qo8QwLMAUxMFOFWtQb43DFG
   /Jh6WnJxLJWXJ54C6nKndO5XdzyM3fYPYqf3Imubd0lP+vu66NdzAdHoz
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="327612356"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="327612356"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 01:27:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="652199934"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="652199934"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 27 Sep 2022 01:27:01 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 28R8QxxJ023862;
        Tue, 27 Sep 2022 09:27:00 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, gnault@redhat.com
Subject: [PATCH iproute2-next 0/3] L2TPv3 support in tc-flower
Date:   Tue, 27 Sep 2022 10:23:15 +0200
Message-Id: <20220927082318.289252-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset implements support for matching
on L2TPv3 session id using tc-flower.
First two patches are uapi updates.

Kernel changes (merged):
https://lore.kernel.org/netdev/166365901622.22752.10799448124008445080.git-patchwork-notify@kernel.org/

Wojciech Drewek (3):
  uapi: move IPPROTO_L2TP to in.h
  uapi: Add TCA_FLOWER_KEY_L2TPV3_SID
  f_flower: Introduce L2TPv3 support

 include/uapi/linux/in.h      |  2 ++
 include/uapi/linux/l2tp.h    |  2 --
 include/uapi/linux/pkt_cls.h |  2 ++
 man/man8/tc-flower.8         | 11 +++++++--
 tc/f_flower.c                | 45 +++++++++++++++++++++++++++++++++++-
 5 files changed, 57 insertions(+), 5 deletions(-)

-- 
2.31.1

