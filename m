Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BDB49B07B
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574885AbiAYJhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:37:00 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:62005 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574000AbiAYJbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:31:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643103071; x=1674639071;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uecLW4Oa2p9q3WykZcsVxmxvdL1GbmZ8rq+yUs5wlZQ=;
  b=F3Z9QrPN96b3vxrsK/9dR4GlofrcFM6I+AevPG9DvWVQ2VjCNhNzxl1m
   I7wmigUkzrj+6LU3g0+mChUJkMb49fsxsp+QB0kqtVyD2eMP3Mi7TUKWv
   PbMnSrZFd1oey89naQcUXq1UlWJq5NgMzta6YFjyo341wLMfgRDgG1dKU
   SIr6gflv3H4MxB32n+JquSIYkBmh00LWZMoNvoXXqk74EEvVj9KLTMFrK
   OGlNhZ4Vy9ZUScb43BBcMws1HT32UviTk4zG6bKYE4B21UwNE4q80SOnZ
   5uH1c5Cjm57DLPc1p+JUcYQ841f3GCl7GkS+vuRPm/td1YKBART1llMJB
   A==;
IronPort-SDR: vjLdE/sfqOM8LeoEPGXtGkjFeDhXjzx/705QuJUu/GUxRDt3DVQJkhU6HjqTNaYv9ZbgzeZULr
 HlwEyrqAKnx4mSP3GraMhMRK6D6Nq1StMawIYirZqeFuTTQmLtQycQHxtgo+TwHZPc1Cbq92wy
 fHVSEW61IWmLEbz8Va0oPCWdZ+UoPEZSFPLMTDtf+Qw73d4kyp5RVYZ4u0eoel4fnVzAajU2kQ
 HQ1JCN5qjv09Uuw7gRBAuGTrc7BBY8YRe2HeUd0dE2DWfNNEYTcJx5ZFDAHOvKXunAWRCqHbJ1
 XBfHAQR+ALKe8OEZjkuqRJ20
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="143790576"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jan 2022 02:31:03 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 25 Jan 2022 02:31:03 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 25 Jan 2022 02:31:01 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 0/2] net: lan966x: Fixes for sleep in atomic context
Date:   Tue, 25 Jan 2022 10:30:22 +0100
Message-ID: <20220125093024.121072-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series contains 2 fixes for lan966x that is sleeping in atomic
context. The first patch fixes the injection of the frames while the second
one fixes the updating of the MAC table.

Horatiu Vultur (2):
  net: lan966x: Fix sleep in atomic context when injecting frames
  net: lan966x: Fix sleep in atomic context when updating MAC table

 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c  | 11 ++++++-----
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c |  6 +++---
 2 files changed, 9 insertions(+), 8 deletions(-)

-- 
2.33.0

