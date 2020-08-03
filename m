Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3C623A00C
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 09:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgHCHI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 03:08:27 -0400
Received: from mail-eopbgr150052.outbound.protection.outlook.com ([40.107.15.52]:25506
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726202AbgHCHIZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 03:08:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kg7y+Zc5x/JH/xmUItkwkEy1sDI3rQxEAlWovCLxur8BH+38JROII/77NoLjU9IyTP9z7Vz5plaFe5fxjEoHNZdij1sfsXNTCKGpsoOf1k5LqR1ylbEJZAJ8AXQv0IkG6W3zWT6ABhZgcoTf0CvbQDDf3WN2WBwS788NVdZf2JatR/RX11nQaZC7mjfLN9Txh+yuz173ZoS8/ML0Uk0ICoCNnty3toxGZ1iTewUh086GH/+PwuCq8tZD2YqnzIJd7qg/I7xoqNvryWThSHOsxNFfoji27gVvpNMlVNDazswE86tdePNV7qMUF3OwLtMGXiHv4bBdf5KhoD9OW426xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcZRj5mQvYa9BBQ1rLDtrN7ZRqFF3pXX5+pAz7I0/sg=;
 b=WIWnVAlYctfcGZ5C4tRDCybg7Tj0WHWlHz1Qo45gEpjPN1sx/TirF5VcT/uuzqw7QzqZNm1xxIlm36LzyLR0VvJIA4H7xQUF/qKI/0wMgonxoCV5zwSjPyj2tTUYdvhBB40qyGZRXwtgT6ePew+TvzGimyyPMJ1jfEi84q9H0nhFZWoblGafnAM+JeMHoV4gh1C9/N+edZiLIaW6L7h0QHDPba+AMKPGWoq3d/UblJPgSqk9lSzx+XYm1uSFOQl63sL4PanZ+jDpX1C/VCoaoju409/YRnFrqLD4XxUiTfvSgtMAbgh+QlixjyPAXiD/EbRKim58HPGZfVmFSD8oxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcZRj5mQvYa9BBQ1rLDtrN7ZRqFF3pXX5+pAz7I0/sg=;
 b=arcqXX1ILRaIC93ZqJm5wGzEBm863tX8Av0gfEZlZFNdnI1/EhWWUcKw5H9hszBWsqmfrT8aDIp/w0TQrER7cMguE0Jn77rZmXQ4x0yT8xUEwXuLfbjJSQxhluZbk2mq3KH00ksWsO5BspnA/KLtV7etpiba6PiIePgtfNWR/0s=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB4356.eurprd04.prod.outlook.com (2603:10a6:208:5c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Mon, 3 Aug
 2020 07:08:04 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 07:08:04 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net v3 4/5] fsl/fman: check dereferencing null pointer
Date:   Mon,  3 Aug 2020 10:07:33 +0300
Message-Id: <1596438454-4895-5-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596438454-4895-1-git-send-email-florinel.iordache@nxp.com>
References: <1596438454-4895-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0007.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::20) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR07CA0007.eurprd07.prod.outlook.com (2603:10a6:208:ac::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3261.13 via Frontend Transport; Mon, 3 Aug 2020 07:08:04 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8318a6bb-25b2-49ca-e25f-08d8377bf76a
X-MS-TrafficTypeDiagnostic: AM0PR04MB4356:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB43566D70B67BB22200F243A2FB4D0@AM0PR04MB4356.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xnv/7eGCfg2wNwfJyk385ynkU4SvcCcXV10Xv8luYklOj4byNLneYm3gOTMRdqb2NDyair5Pi5NieECOM1PIHLsHOoW0hvC5K7PEuBI94BUt2FKRQ2FdikAlThPSiXsPgohbJaUPVXaF+t2PPF8UtHMNCYsPureNML/WKdfegiA/8LRkE3JjF/HjrYqlhZXvANQHAsleZsVNgsKxi96yp66jyekxxxOk0IHVasTOuXg6iw5J7vrTF0ZqS0Xvp5TL3EskxGLiqdT+wCqL8s7wGLA1PAPftgzZZvzJ+RiNiMkyJK9SpZa02swQ/qyd6NXcwenB+6J2fdc1p9Qs2OyXLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(956004)(6506007)(52116002)(83380400001)(6512007)(2616005)(316002)(36756003)(66946007)(2906002)(86362001)(6666004)(478600001)(66476007)(66556008)(3450700001)(6486002)(26005)(4326008)(8936002)(5660300002)(186003)(44832011)(8676002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yWXJh2mrO0vEAsvD7bquDGX/K1U/C2230uuP/v+WODm1UI3WBddihRstLUXgRypeuuJRDe9wDYsMsWFCqOECO/8SEZXJCH0OokW86fJmbSVp4N92tDa8L9lR0VIyCI2EE0ccZ4RhHywSTmuZbA44z3rn/H0rBMI0JWJzSHQxixfaaPLclGcuJJOxi1bFMo5Z4To/um/OzHNWSyGnFgOMfRDFBEZZNN5+nVYBVFK0sGaUOS9ReAWNCK31FXzgrqNtXt+dtOl9LZKl7ceb0blaNrNHDtZaW1Vhy6aXDfeS4YheCG1iPcPN95rqSEhXRBHCc7GOAFq+WyKcLTbDzIv+/NIQa8E1Ls0/E8yijhS2ry9+489QWZJLZlBnwROt2GR5hzAJTjZMbtTLF0jPjfgzy1QOi6glU7iXAgzmN6XuWFHMDoNSWOkY4jpivJktOAYTHrnZDUDwEuUJC2KI02mhfSxK8Mf4I1XGaqojBdIDnFoZiSGgIAHwPwULmRYVw8pj5HxmSVo5nQ7+D6JddrK+CGUpLUnLEVsa6DUvX92xnWa3ACgSmDrnLJxxsaajIk9iB9zgA+fhlPT55DwMhS0G137p7GBgTMOKTrlSFzvW4Ep46k+ieUdNFUq2szCZ1bGCB/NJEEbYCU0FNO6JTwolbA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8318a6bb-25b2-49ca-e25f-08d8377bf76a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5443.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 07:08:04.6216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VRcEpHGkGAfdO6nxqygHmb9z2gdoMREWBrEK7t0Q+2Jl6F2XsTROo4+vb0nyl3LDsM3hLwbE30bYzjvzwlQN4jsNQK1XOQQoRhGQfqSt94c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4356
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

