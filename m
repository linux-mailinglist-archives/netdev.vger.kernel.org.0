Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1939A25A0FE
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgIAVwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgIAVwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 17:52:00 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF4AC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 14:51:59 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id g6so1495021pfi.1
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 14:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=zpezJIycHxVWgG5Kg1IymaCbaNSzY7ri3TwDD8cWjI8=;
        b=mJSerkoIaB4tRPaDzReNNvh+GQqd/XK6Jx4BXOg0rsebO3t4XqoPcneTgI5IkV7PgF
         E9db9x1Ew5koXEIz+1jjtUH9toBK51HohM1IVtyRHu+JyKdcSyvddxzbOTuyokrSHVX5
         VURAMrjpagojLDvcR/a85elagfb0qpC6AAb8urxYu36Y8CnjO3ISEnWiLagQ1JVOZ6/a
         9HZGu3Q90Zn3EPrlRCFidUo+dXdM+KAXGcEVnWBehyv3OP0ROsN/9n7Tt0QgLQPfuOrS
         JngeXQtkEbDq9n9eet9WPtNATgNf6YEhCuv+8Yl516P5eO74BMyvOqJLKSq02nDGWAQo
         ojHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=zpezJIycHxVWgG5Kg1IymaCbaNSzY7ri3TwDD8cWjI8=;
        b=PJ6uVm3GwMbHDj0lMn2ajBkReA6CO1cEhkHpCsMwCmvGTT0+ImdSkueNzq20wHSeyz
         UuBYd5f2bEX8EyHTF0Kc/wGFQT1BU0zjZF6zcB3pPd1ybztX+CZJt4EkiltlLnu1tvRv
         dBxA39Erc3vmuiztfm8YoHvY+YSZprjQYRNrtz/ZCTwKmpTLRLYZe+90w1RLhZtLy8Wd
         A7uzMyB7sZrKIkGU83xVSofYZtxfMPA4y2GaRJ14vbEkLAUlk+OcG0KhQJGkDw8W9xNB
         jGovusKVn24BrNW1lGT9uokXt7Y7Nlg3FSFmBVQ7Wno6lYD0bngiAcOs3oyJQx54r+uP
         yXHA==
X-Gm-Message-State: AOAM531LdMzcRG6VUq81TuMrIUOP/XTzeADMoPAbea0jhZFiFZd5GSwY
        hPubH9JXN85nSRWASp5xW3PJqfSxZ/e1tM52Bwq6UKdO1HUH1SprPssT7IwPVAjjiIHJSthXcpU
        pnTr5q1M+KUGO8UoacgW0Tatn8HIqUaxlRIzfkOXh4gwAF9obPWfkffSNtZ/PCZKQ6/8WGIhE
X-Google-Smtp-Source: ABdhPJxYPgAp6cYoViUEtUBq9A9j0qkpBn2Y/pTlM8dIr95qCRACaahsoarvWAb7/Nhw82TznjaSxYLk6Mdxt7H2
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:aa7:824c:0:b029:137:165:ddce with SMTP
 id e12-20020aa7824c0000b02901370165ddcemr4012985pfn.0.1598997117178; Tue, 01
 Sep 2020 14:51:57 -0700 (PDT)
Date:   Tue,  1 Sep 2020 14:51:40 -0700
Message-Id: <20200901215149.2685117-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH net-next v2 0/9] Add GVE Features
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from v1:
Note: Patches 9 to 18 in v1 are dropped and will be uploaded in another
patchset.
Patch 1: Use EOPPNOTSUPP instead of EINVAL for get_tunable and set_tunable
				 unhandled cases.
Patch 3: Do NOT register netdev earlier.
				 Retitle from "gve: Register netdev earlier" to
				 "gve: Use dev_info/err instead of netif_info/err."
Patch 5: Break up into guest->NIC stats, NIC->guest stats.
Patch 7 (patch 6 in v1): Use reverse christmas tree in declaring tail in
				 gve_adminq_issue_cmd.
Patch 8 (patch 7 in v1): Add link_status Up to make logging more uniform.
Patch 9 (patch 8 in v1): Correct declaration of link_speed_region to
				 __be64* to fix sparse warning.

Catherine Sullivan (2):
  gve: Use dev_info/err instead of netif_info/err.
  gve: Add support for dma_mask register

David Awogbemila (2):
  gve: NIC stats for report-stats and for ethtool
  gve: Enable Link Speed Reporting in the driver.

Kuo Zhao (3):
  gve: Get and set Rx copybreak via ethtool
  gve: Add stats for gve.
  gve: Add Gvnic stats AQ command and ethtool show/set-priv-flags.

Patricio Noyola (1):
  gve: Use link status register to report link status

Sagi Shahar (1):
  gve: Batch AQ commands for creating and destroying queues.

 drivers/net/ethernet/google/gve/gve.h         | 111 +++++-
 drivers/net/ethernet/google/gve/gve_adminq.c  | 316 +++++++++++++--
 drivers/net/ethernet/google/gve/gve_adminq.h  |  62 ++-
 drivers/net/ethernet/google/gve/gve_ethtool.c | 366 ++++++++++++++++--
 drivers/net/ethernet/google/gve/gve_main.c    | 336 ++++++++++++----
 .../net/ethernet/google/gve/gve_register.h    |   4 +-
 drivers/net/ethernet/google/gve/gve_rx.c      |  37 +-
 7 files changed, 1053 insertions(+), 179 deletions(-)

-- 
2.28.0.402.g5ffc5be6b7-goog

