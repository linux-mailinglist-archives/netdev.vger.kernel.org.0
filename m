Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC21699CD1
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 20:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjBPTFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 14:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjBPTFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 14:05:01 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2095.outbound.protection.outlook.com [40.107.6.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633FA505E8;
        Thu, 16 Feb 2023 11:04:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5h8H9RW/4i69Bm4lwzkEEFGx9fg6lbnCM6dxE1f2nGFF/SIMPSvm6FU7WDTX64pqcFVrlyVawiDpbk0dLUmnppIZXCslg+vRyz5YQQp653Ryi7m+aJHluRlXQdZz4llAvgc2tD67wxZ20wRiszALKtEL1fuUKhGgmI2itVUHnkkVvHaqJ+c0mX7WpINwmLIDolNu/sKTCsnNUp8ngkibcGMXPjQl9VJ05DJpfJbnCKqoVZPMsNJZlXES08ByATJyvbwmIsecSE54bLbmJk9cOEjMuebg/LGC99+6Z1Z1A4RkJ3igXb56jZ/k+zhPPTQxBmfk3NhM2xC88Hj14U2sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ESb6T328AFftBY2Ij5fphSg8J3NB8NixFPh+OOkPKQM=;
 b=SH34qF6zkHLw+bMBhyJR2vwJHY6Ax7qErgFd34hFLuUYJ5tXpX6mnlak8kOVOhzkCBgCgKN+V4Dcl68oKmFpBhLh4moJ/PhSwZX4aD976TyZFUb+9UJduWHiPTPwb3YEpn5s49K9/Aqw9TyiYj4QfrOqPGtUW6wZDsr3L6Pp1Y/LVekp0iJv/xwNu34mupftzH+9vbxzHO2M5pJy16ZoCWgLTvbsutpzHtl9xTnd+63FC91sr35A7UN2/hPk5N4g8U+0gT/mImcvv+t460sYKydK5oAb/4eAvlxmj6P2wcEzCU0PLo7pcgQEoaGjT4Y8MeB9E26sGbedKS2UFpSElQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESb6T328AFftBY2Ij5fphSg8J3NB8NixFPh+OOkPKQM=;
 b=rha0qiNxhc7MVTxBjAflwztdbmjb3xyx6OlP0YVLgMX9uqIVHoDA4yVqvJWppVUpzggajU39T5oDK1sRa1zk17IW4jCzIm5cwX/wZasZkSf4YMqDl/crrWF/keU3LgSql+4jwYRgHYm4mut6/Meprg8hvgVhK9BbJ3Gmu2LpNaQ=
Received: from AS9PR06CA0543.eurprd06.prod.outlook.com (2603:10a6:20b:485::6)
 by PA4PR03MB6784.eurprd03.prod.outlook.com (2603:10a6:102:f0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 19:04:54 +0000
Received: from VI1EUR06FT020.eop-eur06.prod.protection.outlook.com
 (2603:10a6:20b:485:cafe::72) by AS9PR06CA0543.outlook.office365.com
 (2603:10a6:20b:485::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Thu, 16 Feb 2023 19:04:54 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT020.mail.protection.outlook.com (10.13.6.201) with Microsoft SMTP
 Server id 15.20.6086.24 via Frontend Transport; Thu, 16 Feb 2023 19:04:53
 +0000
Received: from esd-s20.esd.local (jenkins.esd.local [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 7F9A67C1635;
        Thu, 16 Feb 2023 20:04:53 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 6F8872E447E; Thu, 16 Feb 2023 20:04:53 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v3 0/3] can: esd_usb: Some more preparation for supporting esd CAN-USB/3
Date:   Thu, 16 Feb 2023 20:04:47 +0100
Message-Id: <20230216190450.3901254-1-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT020:EE_|PA4PR03MB6784:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 6f106394-d629-4240-8650-08db1050aff6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zdA5rrQiQvdt11cQXWeHUvjL0qs2Z1K6sxjQ2yixbph4aeyne33gcp+4S7Cbjz4dpAFNeCuH9yBVy7x+MiwzDiNHr1T5eorfOFEt8wl2YSnRXq5PPEIBXaK+Ygt2JBTgaizZC9BP3NMkPYb5CwObF2YSV0jZk+yo2r0+WDQN4J9fNiCtzF+qKHd+qh3dSW2aOB12+drMZIzDxNd5b1xANzvkWV+sm5gycWa9SFNWIi+QDqncRXli1HWYue7EnR28mCYZTkvyLjDL7rFwDkZD229v3pdz3hJgrQ30p56B3S4Fr7pUKLlZw66oMpWEXy3WWta4Qk8JmNOr6DcY9VvS2zUuV8W8g7/04o7D67l4BmkVMbjs1GigB2EdezvW3UUZvUzEvSWFlQ6i9a0P0GV7FZkrwKlEHd9xFpSFNVUSO2sGWJ5U/u7iBT1BQLHd9JcrprO4MMR+aBdstTz23X4afJ1wLNLszugXQ7nDB4alWT3wI9i4yl8oJTlW6PTXoXCOndlNXqCvc7+T0Is1iSoVcksd+ojszBu0pdvzHoamWvKVi7An+OMgob1OWEpsUa3cr47bPUI6GR9pziFnnJCTAIOPrSv4Sipizf8x2DcifL1ooiNH5z+6oedbYyOjnGuAD/gDRAczGAw1s8kpN0MPky8WsbzdkVhyX99YSj2Q/gze2kYA4XUzyMsPcMUTJPMAdXbN02/bYmByBpEt/IkNbw==
X-Forefront-Antispam-Report: CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39840400004)(376002)(136003)(451199018)(46966006)(36840700001)(8936002)(41300700001)(83380400001)(47076005)(6266002)(336012)(186003)(40480700001)(82310400005)(86362001)(478600001)(26005)(6666004)(81166007)(1076003)(2616005)(966005)(36756003)(4326008)(54906003)(70206006)(8676002)(42186006)(70586007)(110136005)(316002)(356005)(36860700001)(44832011)(2906002)(5660300002);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 19:04:53.7404
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f106394-d629-4240-8650-08db1050aff6
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT020.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB6784
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another small batch of patches to be seen as preparation for adding
support of the newly available esd CAN-USB/3 to esd_usb.c.

Due to some unresolved questions adding support for
CAN_CTRLMODE_BERR_REPORTING has been postponed to one of the future
patches.

*Resend of the whole series as v3 for easier handling.*
---
* Changelog *

v2 -> v3:
 * More specific subjects
 * Try to use imperative instead of past tense

v1 -> v2:
 * [Patch v2 1/3]: No changes.
 * [Patch v2 2/3]: Make use of can_change_state() and relocate testing
   alloc_can_err_skb() for NULL to the end of esd_usb_rx_event(), to
   have things like can_bus_off(), can_change_state() working even in
   out of memory conditions.
 * [Patch v2 3/3]: No changes. I will 'declare esd_usb_msg as an union
   instead of a struct' in a separate follow-up patch.

v1:
Link: https://lore.kernel.org/all/20221219212013.1294820-1-frank.jungclaus@esd.eu/
Link: https://lore.kernel.org/all/20221219212717.1298282-1-frank.jungclaus@esd.eu/


Frank Jungclaus (3):
  can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case
    of a bus error
  can: esd_usb: Make use of can_change_state() and relocate checking skb
    for NULL
  can: esd_usb: Improve readability on decoding ESD_EV_CAN_ERROR_EXT
    messages

 drivers/net/can/usb/esd_usb.c | 70 ++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 30 deletions(-)


base-commit: fa1d915a624f72b153a9ff9700232056758a2b6c
-- 
2.25.1

