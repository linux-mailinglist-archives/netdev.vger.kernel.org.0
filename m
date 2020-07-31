Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7268A233F63
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 08:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731533AbgGaGrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 02:47:07 -0400
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:50639
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731351AbgGaGrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 02:47:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghSeVja7lAZOyfreNQ9w66rN04+II69joYR7gZUO1hulV+sG6lCrFX9PA1EBnhLDMRvIB4ZpxdUx6zRdG16uqIGPzLxuibv1zzRikgKm61sEgg5OEv884xvtLfnP7wV6LvTtwK3M2x9Ed5dOHgHdG5/pOSsSc+UpsyJHp9swJ5utf2qv6MhEAQGiacZqrkPWGhCD6ZboriuBcnO0zD15GLLh5D3A5UtQoCOWEgwa1MGjVlnlVHfl+PGF5mCuYjSWqbDIJLKJcfNPNLfqqD6pDH29qeSLssTPIFrU5/r7wnt/LoKAtUi9wheL9S41XaFK7eSCfmgvcGbbvFkXH/KoHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIFqgGufNAWYsh6zczVA9+IdU/14r5N8QN5MVY0BwNE=;
 b=Xrr5EMx1+p+AkGaAMQTZGtD6qNqz05cw3vuNrPQsK0W+puo9BqhQFYJxf2DOyGWIBOgSWIJg32yHl5whAnM2NeMqK8SD4/qFCFi664G3zr3nQvnXaANS0ZL1zUoNsEXoH+IubmqBVS7D6O/Q4jLFMwHoQ3zWbnjhzwf6NX/dnLy2jQz2r7vTCi2Ngqn4GLJz4t4G1q0jYuENbGHYs43zEv7+EfraN+9smhbj2Zu6+NZGw4w1n/i4GcUMtOj511t/jqQngYU6KohrJ+dxWc9lQeLwBysGCVZUiGUIRSUPmBK/ef3WvdbYdy/rlKIQGFTf63jHH9SZgxOU/as4KhShng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIFqgGufNAWYsh6zczVA9+IdU/14r5N8QN5MVY0BwNE=;
 b=sSHRE1UvkmhO+zQ9Z7He9QKa6WzQYSqM3Ic+S2smyEzW3i7IGFW1yC/WsO5avVbVdXkMuqC3MU54S56pvHFETbC08rnzlMkyWKUYthPsE275oC9cYnJTgomq22V4Qy9QjNyGqwPi1MApQECkGTnAkCNu6F80NZ6sXn+kP1xlBo4=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com (2603:10a6:20b:94::20)
 by AM6PR0402MB3527.eurprd04.prod.outlook.com (2603:10a6:209:6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Fri, 31 Jul
 2020 06:46:50 +0000
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99]) by AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99%5]) with mapi id 15.20.3239.019; Fri, 31 Jul 2020
 06:46:50 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net 4/5] fsl/fman: check dereferencing null pointer
Date:   Fri, 31 Jul 2020 09:46:08 +0300
Message-Id: <1596177969-27645-5-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596177969-27645-1-git-send-email-florinel.iordache@nxp.com>
References: <1596177969-27645-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0112.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::17) To AM6PR04MB5447.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR06CA0112.eurprd06.prod.outlook.com (2603:10a6:208:ab::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 06:46:49 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f8c7f9fb-17d5-45fc-9fa1-08d8351d8068
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3527:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB352717E54AB24FEBC467D7CAFB4E0@AM6PR0402MB3527.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1wa7arRJPNjYGK7Wt+OmmOTQdYTeOcW7KB+wrvh5fKAwidJP3c3r3gwso9SmFSMR8Z4XoBPetXWcoskWUP3UdknSwZge06HLdhCzPoFndWQ/ONCAPTtEQLeSYXE93vq6XmiBcb4RrHy7x79rdwWGgEBpV5pED7juuFHy0qoaEy8FjZqYjouTAMSI2iOf9TsJUpYL9sdx/mzd1Xc4aBmSnJN7UP6rpzI7NpAo2AVwaor39GIT7jsRHcsOj6c05EXCEcfKC9YxLc/w+i92ljuQ328dvsmnpv5QgOSURsxGYMHMxS7klAxxVOdJB5kr1j3o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5447.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(316002)(83380400001)(36756003)(44832011)(66946007)(5660300002)(2906002)(66476007)(6506007)(66556008)(8676002)(6486002)(26005)(6666004)(2616005)(956004)(8936002)(4326008)(3450700001)(16526019)(6512007)(86362001)(478600001)(186003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /3gkowsFY8CuSPaR3jtqOSlJB7HqsuQ9eknCHbEaC5arZzZGCJi2uIOGYCh18AIOZCvKB6NocuosLDqbUfaHG8thYRGfEZKNW9EtPT5tCLqV0fqiH6XXEzc7T6TnnoytZn27DuFNHl6Oo6ECKrMeMMOS2hA1IA6EAHN8skEapEn8jXogllpZt065l1xI9CnE1Ypo/84UD4V31os6WX4N18WiGAL+k+lMMmiSMIto4JZ6b6mBAF5pp/0uAUKNTXkos0KbgU6d+1KR7Z50nNRJbHw9EFQaEIv5tWvmQpKXxKyKHDxmcQHTCL9kcrBL4lYFZ6H372DuVhuEFbCZXVdVWnMa1eZR0NID3bRKJINOOWebiaZgcqIznlmLlRABMEHlpMgwp8JeamGt5q67VvEmzGyUH6tA0b/mTKJKKOt6Ekv1jJK61lmkKKdj9dxczMygU93hT1Ke/SWl1CGaDnu4FwKOBe7OurOAIlIv1UQTTWY=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c7f9fb-17d5-45fc-9fa1-08d8351d8068
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5447.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 06:46:49.9627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7L/k0+kWHQp6amhugnfIWPqRDNetx3XjysnqAEfEITe97gTZMTeFnEGt56/tU78uwD/lVm79Vs0hYaGFAI43g5NojdA6acGv4p6bb22WZQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3527
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a safe check to avoid dereferencing null pointer

Fixes: 57ba4c9b ("fsl/fman: Add FMan MAC support")

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 4 ++--
 drivers/net/ethernet/freescale/fman/fman_memac.c | 3 ++-
 drivers/net/ethernet/freescale/fman/fman_tgec.c  | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 004c266..bce3c93 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1200,7 +1200,7 @@ int dtsec_del_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
 		list_for_each(pos,
 			      &dtsec->multicast_addr_hash->lsts[bucket]) {
 			hash_entry = ETH_HASH_ENTRY_OBJ(pos);
-			if (hash_entry->addr == addr) {
+			if (hash_entry && hash_entry->addr == addr) {
 				list_del_init(&hash_entry->node);
 				kfree(hash_entry);
 				break;
@@ -1213,7 +1213,7 @@ int dtsec_del_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
 		list_for_each(pos,
 			      &dtsec->unicast_addr_hash->lsts[bucket]) {
 			hash_entry = ETH_HASH_ENTRY_OBJ(pos);
-			if (hash_entry->addr == addr) {
+			if (hash_entry && hash_entry->addr == addr) {
 				list_del_init(&hash_entry->node);
 				kfree(hash_entry);
 				break;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index bb02b37..52ee982 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -852,6 +852,7 @@ int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
 
 	tmp = ioread32be(&regs->command_config);
 	tmp &= ~CMD_CFG_PFC_MODE;
+	priority = 0;
 
 	iowrite32be(tmp, &regs->command_config);
 
@@ -981,7 +982,7 @@ int memac_del_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
 
 	list_for_each(pos, &memac->multicast_addr_hash->lsts[hash]) {
 		hash_entry = ETH_HASH_ENTRY_OBJ(pos);
-		if (hash_entry->addr == addr) {
+		if (hash_entry && hash_entry->addr == addr) {
 			list_del_init(&hash_entry->node);
 			kfree(hash_entry);
 			break;
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 8c7eb87..41946b1 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -626,7 +626,7 @@ int tgec_del_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr)
 
 	list_for_each(pos, &tgec->multicast_addr_hash->lsts[hash]) {
 		hash_entry = ETH_HASH_ENTRY_OBJ(pos);
-		if (hash_entry->addr == addr) {
+		if (hash_entry && hash_entry->addr == addr) {
 			list_del_init(&hash_entry->node);
 			kfree(hash_entry);
 			break;
-- 
1.9.1

