Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2C4674DC5
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 08:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjATHIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 02:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjATHIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 02:08:01 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3194B4AA;
        Thu, 19 Jan 2023 23:08:00 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30K77aoi017587;
        Fri, 20 Jan 2023 01:07:36 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1674198456;
        bh=MPgFQOAXKvf0ryAO+dvw20dotsQVh16aDcWdPqC4bSI=;
        h=From:To:CC:Subject:Date;
        b=wJULVzrbk4menwDaW7FNrC8YNjFcRGyIx/9wM7fuDD41b5GHgNBDHtqJNitPAqeW7
         n0YEqrzMfEs7cbJMQj0xasJZ8wJl4soeTtYVVrdVpzqygHTzlnlxW4g4g7Z75QiPPj
         j5eYn5B9h/KeVACQ0wOHG47i7GdVK/Sgw+nWyWVg=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30K77aFH014847
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Jan 2023 01:07:36 -0600
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 20
 Jan 2023 01:07:36 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 20 Jan 2023 01:07:36 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30K77VSp074203;
        Fri, 20 Jan 2023 01:07:32 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>,
        <leon@kernel.org>
CC:     <leonro@nvidia.com>, <anthony.l.nguyen@intel.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <vigneshr@ti.com>,
        <srk@ti.com>, <s-vadapalli@ti.com>
Subject: [PATCH net-next v5 0/2] Fix CPTS release action in am65-cpts driver
Date:   Fri, 20 Jan 2023 12:37:29 +0530
Message-ID: <20230120070731.383729-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete unreachable code in am65_cpsw_init_cpts() function, which was
Reported-by: Leon Romanovsky <leon@kernel.org>
at:
https://lore.kernel.org/r/Y8aHwSnVK9+sAb24@unreal

Remove the devm action associated with am65_cpts_release() and invoke the
function directly on the cleanup and exit paths.

Changes from v4:
1. Rebase series on net-next commit: cff9b79e9ad5
2. Collect Reviewed-by tags from Leon Romanovsky, Tony Nguyen and
   Roger Quadros for all patches in the series.

Changes from v3:
1. Rebase patch 2/2 on net-next commit: cff9b79e9ad5
2. Collect Reviewed-by tags from Leon Romanovsky, Tony Nguyen and
   Roger Quadros for patch 2/2.

Changes from v2:
1. Drop Reviewed-by tag from Roger Quadros.
2. Add cleanup patch for deleting unreachable error handling code in
   am65_cpsw_init_cpts().
3. Drop am65_cpsw_cpts_cleanup() function and directly invoke
   am65_cpts_release().

Changes from v1:
1. Fix the build issue when "CONFIG_TI_K3_AM65_CPTS" is not set. This
   error was reported by kernel test robot <lkp@intel.com> at:
   https://lore.kernel.org/r/202301142105.lt733Lt3-lkp@intel.com/
2. Collect Reviewed-by tag from Roger Quadros.

v4:
https://lore.kernel.org/r/20230120044201.357950-1-s-vadapalli@ti.com/
v3:
https://lore.kernel.org/r/20230118095439.114222-1-s-vadapalli@ti.com/
v2:
https://lore.kernel.org/r/20230116044517.310461-1-s-vadapalli@ti.com/
v1:
https://lore.kernel.org/r/20230113104816.132815-1-s-vadapalli@ti.com/

Siddharth Vadapalli (2):
  net: ethernet: ti: am65-cpsw: Delete unreachable error handling code
  net: ethernet: ti: am65-cpsw/cpts: Fix CPTS release action

 drivers/net/ethernet/ti/am65-cpsw-nuss.c |  7 ++-----
 drivers/net/ethernet/ti/am65-cpts.c      | 15 +++++----------
 drivers/net/ethernet/ti/am65-cpts.h      |  5 +++++
 3 files changed, 12 insertions(+), 15 deletions(-)

-- 
2.25.1

