Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263C9234448
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 12:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732707AbgGaKuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 06:50:14 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:53202
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729141AbgGaKuN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 06:50:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7pOc0ZwqcEFuGuFm2wcwzco1WY3fO13omEiI4H8M8uNTAkk5cb2vVcadDf0WTRU+rBEBM8BhD6VQ/n4citgMCmGhd2ImmOGl2P9qcIlMlvv0OuxFTDue/FLeERi7FEzy6l3KrAhzZGfhHe9FfbSc/ahht82TNrGqYDog1CPlgerpY4mDCsFxm+Or37nEQ/+qmHRI5QhSbPnV146kgQ7M245cDWvUFKndXxjl7LKgJ44Dq7iyTtUNbqtpJFcODAEIyFTU+jn2RnfyDUUuQ7TLMeQb3MoXPDD/Z5Ry2lEcWaoJLCCDkITsvPUOcXuElw9jesIPVnEjERZ33XH9aLSVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wY2x4dbOIgXpyQCbX5HxJwe7Ojf6pjze7jgQ6SGYbek=;
 b=brRBpRO5ZJXW6R1Aq6ONsGNh5JH6ipG6uy/ixM2ToxUGwHh1ITntZqoskupoSn1oS5r8Hc+qYcdjHXiNW/ahfCmeiHSIRUR3LmbmPgeR3BF0v9zn0f7Esp/4RaCvNkqTqQKMkXeFOcIcQO4tnNFVMim+OBXG4Qm/iugxzZGm7ZoDXBcLwYHM3cFHagoFhclj0Rs86PJRxQXSpZbbG8Bb3feEJ1nCptQ/f/SWzVa/ADgOZGfZPHboH3OShM3IwZj6hcUtwb78dEL17VfNYVRfbK+WG+5+B80ygfUnkFwd9OVJdZKS8kv+E60wgutz4F9hFZtbY8gwKOWKFu6JwGo/Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wY2x4dbOIgXpyQCbX5HxJwe7Ojf6pjze7jgQ6SGYbek=;
 b=dYp1R9AeCL/JUhfkXbc9Ly/gKWZfaFhzRlC2p+ukfv8PLWFSXJfGeuQ3jc22Zk70ssq4rDech1ABgFWmQDk6bM8RaPzWBzHC+9RcM4WOVNzy3J4rLkJRb0/yCfcG0YPwr68hm9ZvvQMh4BZfsCMMYitw0dmW7mfeajF1OJV52cw=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com (2603:10a6:20b:94::20)
 by AM6PR04MB5943.eurprd04.prod.outlook.com (2603:10a6:20b:99::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Fri, 31 Jul
 2020 10:49:56 +0000
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99]) by AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99%5]) with mapi id 15.20.3239.019; Fri, 31 Jul 2020
 10:49:56 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Markus.Elfring@web.de
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net v2 4/5] fsl/fman: check dereferencing null pointer
Date:   Fri, 31 Jul 2020 13:49:21 +0300
Message-Id: <1596192562-7629-5-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596192562-7629-1-git-send-email-florinel.iordache@nxp.com>
References: <1596192562-7629-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0103.eurprd04.prod.outlook.com
 (2603:10a6:208:be::44) To AM6PR04MB5447.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR04CA0103.eurprd04.prod.outlook.com (2603:10a6:208:be::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 10:49:55 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 292ddbb8-2eea-4696-9b62-08d8353f7690
X-MS-TrafficTypeDiagnostic: AM6PR04MB5943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB5943783A3A58EEEFAB865A52FB4E0@AM6PR04MB5943.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HXJLIIQ09NwlWUodSaTRUldDaXa22ly1EvaslgliC4Y0uO8vIh9bNZJEsL+YQ0PIrkBHk4WDs6cAY+nkC76uuh9zNfoChSpkMJymQkX+zGF2g/d3g7gST8OIYYuqFA1JXU4yfz2LZ3lzqZhllpGK4vHG5Yil2yXZMg01RMwbL6QqYlnP9hnJ3PYJ0YuQjvepDh868gJ1Q3Eqj+6giShg0XyVHvoNsO8lHSHrgdOouz++5pDpnDCc+OM4HNXDm0gDA9wCsfGf8Lv9ZdQ6rI5Nl5rKnr83XPaI4y4bOFB92W0aItdG1tNQjMsb+xyhs9S0kLUqOSyTZlrzHoTnLiJLTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5447.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(3450700001)(6666004)(478600001)(83380400001)(36756003)(52116002)(2906002)(4326008)(6486002)(316002)(66946007)(66556008)(6512007)(5660300002)(8676002)(86362001)(8936002)(956004)(2616005)(186003)(16526019)(26005)(44832011)(6506007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BEnAYPx1ymbL2rb53OMCXgoS+003Nm7zKWbtJhmG4+vC5JaqzCWicCa/L78N/M+0NrbLuhzlA4JXotwPqFKivctqYoGVELNALMlEiGPcyUfNujudKMfQMSfFnGuipUz2AknsaZmDJ/g//GoTwA/c261h4IJ6eISvTRNuwHpxnfGYr3mkgKcdEjoV1yuR78rdkJU/22mHSsuoEfFW12Ln52C3h3D8+im115GCd5aMWinX8eV44gHwdbkfpWn/AniwPpvyQnzU59n+XHJqIhfND4nn/Sr12tscq08yjQYLlq56nnPhrGrBy1dNfxpEb0TB3AP5gwHgchMTnNboUhXwZTxmlx9PxYAzd2NkhcccpvrI6qqxiiu7ZKcjqP4Y4RVhj5sos7X8w4V0j4256RAIYyQrutTznIIqai/A+iUbdIW1Y7+NRss6w+7eVS+w/6/vVQBG+Yrb0x9EM5VvmsUz9+1SduLExpbSByFuCklC5ikui8eHOS/yqPUb4lunOdyn5M5ViSZbC8c8BvKow6Ns8Rnym41EAf6a4J+60ZJFXJKk7FCWvucSmPunxxRUDBoguPxwEkpHk1bXgZzryrlfA9K0zQ1cQL9HUlvedIgX+e9gUhJ42JNEeNNZ/Ct8fWc1yHVUoPmOmhff/wAe9qfLvQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 292ddbb8-2eea-4696-9b62-08d8353f7690
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5447.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 10:49:56.2854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IM6/0IM6b0V21HMh70PfH+MekOrfpNZsmjuNmNl/IDcV4nqhGHaVLjMbomObVBFw92jcb8fZttVNI9nA/WKjM72OLM9Wl69poNSMOiBzTXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5943
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a safe check to avoid dereferencing null pointer

Fixes: 57ba4c9b56d8 ("fsl/fman: Add FMan MAC support")

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 4 ++--
 drivers/net/ethernet/freescale/fman/fman_memac.c | 2 +-
 drivers/net/ethernet/freescale/fman/fman_tgec.c  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

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
index bb02b37..645764a 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -981,7 +981,7 @@ int memac_del_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
 
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

