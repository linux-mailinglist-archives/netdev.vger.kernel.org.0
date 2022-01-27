Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0C949E323
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 14:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241579AbiA0NQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 08:16:47 -0500
Received: from mga05.intel.com ([192.55.52.43]:61072 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236055AbiA0NQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 08:16:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643289407; x=1674825407;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KafQ7cuMd0XW06yWg4Hjs+yKBCBPY0GJeWm1s/bsDEE=;
  b=gEq3kd5hQmTaAOO8CJAKIWtqyUehCiX5mRS+6IDXyDeEnHNaqqD4OUIu
   OtogqfC/xImw6WPDsLW9e5aC/AwVMEnWBNsoAoZMUiY5yUULE9otHxvRC
   dzUeF/e9ngbiMY74ZevwIO54/jaOM5CmmV5vyAdDx3W23aSTNXhkGWIuE
   T4jwilcpuWBUfkmMbJpHReCUr1mw+OueFIA6EoAutVa7Fwui/QYY1wyvJ
   dj70lOJWieNZKQpErKAEIRnNiOU2N+5ZOTGZNzl0woMVO1+gPBXan78kL
   heSV3NsuyLRKi14XbbHi0AtsP8h8JYm3PqJ0pCLo3eJioP5MD+9yEjLEO
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="333198231"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="333198231"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 05:16:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="628677118"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 27 Jan 2022 05:16:45 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20RDGipc023596;
        Thu, 27 Jan 2022 13:16:44 GMT
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com
Subject: [PATCH iproute2-next 0/2] GTP support for ip link and tc flower
Date:   Thu, 27 Jan 2022 14:13:53 +0100
Message-Id: <20220127131355.126824-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series introduces GTP support to iproute2. Since this patch
series it is possible to create net devices of GTP type. Then, those
devices can be used in tc in order to offload GTP packets. New field
in tc flower (gtp_opts) can be used to match on QFI and PDU type.

Kernel changes:
https://lore.kernel.org/netdev/20220127125525.125805-1-marcin.szycik@linux.intel.com/T/#u

Wojciech Drewek (2):
  ip: GTP support in ip link
  f_flower: Implement gtp options support

 include/uapi/linux/pkt_cls.h |  16 +++++
 ip/Makefile                  |   2 +-
 ip/iplink.c                  |   2 +-
 ip/iplink_gtp.c              | 116 +++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in        |  25 +++++++-
 man/man8/tc-flower.8         |  10 +++
 tc/f_flower.c                | 120 +++++++++++++++++++++++++++++++++++
 7 files changed, 288 insertions(+), 3 deletions(-)
 create mode 100644 ip/iplink_gtp.c

-- 
2.31.1

