Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C378D5ABA7D
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiIBV7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiIBV6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:58:24 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150079.outbound.protection.outlook.com [40.107.15.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D98F72EA;
        Fri,  2 Sep 2022 14:58:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKxuxuu5r08o7rAKfgQsyGFz/acL2kwPV1iJ8Kwf6TICiLaxBDwmjzvVfAOKcKkfuNhH5rBSOoO9UuakTntCmFMDbXGbSoczIJYRatbQnq0BMfhXwuI3a3QAB8HUaFyjcHd2PhoeF0t94nEQxms/OkPBz4BY0EkO6UmK9yXmoDeBVMsQLM/vjwkJdCNAu9CAkvFSw94P2gjH+LpLYIWolOHgn6PWs9ruH5S3nUszCKCm6sKQ1pqhTDTHzlruPx7TjTSB2fvlhFKGdqe9KtvRHV1NyhuZ+3wxjfqFkgtv3vjJDg25ZrCeaiaOlMnGQPFf0XGW88iaYh3J3t39RiYgfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GPLsINVCZek7AgubG4D2wNh7zNp0V2wFxp/SOz3Jd7I=;
 b=L5Ue8+BJHhlS0zfLQ1g5ZfH3UE1T6z4u4iM0iqA5ltol6qwAqCZFBpERdZYgUEYkt4VNBu+MR238e3BLyeuWu5oEWH/ITCHug8iRiICnk8slRUQcJ1FXg/8RJGHo6w2h2Le8dMKS3OGhKw0tytA1XFQXhQqm24aNpJXfNWLTU7Nd9wvkjNwGfx3dyBKW7HsBcWfXLLFsLhRZkNOESYWvBcl9E6xLp7H3PQzOLVwOeh0V8ws7ol+hvUJ3EOcs3OBbjRmzJXekpNkLOYm5yjsji2Y0RfnkNmWe+KIK982KSoTemy4T1wUUjrfTTAFhXgFxtPXjY4bDS0Z3Csp6fTJoaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPLsINVCZek7AgubG4D2wNh7zNp0V2wFxp/SOz3Jd7I=;
 b=NDbW/Dh77+33GNxDv7p1EaJ+l+ddpgUBdPPbMsvRituh9AVz6zKFgTqqRBKOOXQOL7XpUYCmql8nH6TJv8fJ07+1w1HUyS/0dmtYhtVRnVPZ3lhKTczPWeIuL0Tk7FU6OQ/0qvqzBsl+08pefd/6WY1gZJJneIkNureYwBcMKXmWjEqjMgRHZ1vrNP9N97EVVXE57LIcgeFmqtIuKYPc1cNBfI1u7lbswefAXKcU6RiqpMsrHVa4BmOLBv1+Bc+f50vO0K6haaZHdNUX2g/uJbbpmuIDVIX/2qipW5s4VNFzX9M2h8dKzwXDGOPARi1Sll7hY9Sl6GitYd1hVLNFbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4085.eurprd03.prod.outlook.com (2603:10a6:20b:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 21:58:04 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:58:04 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 08/14] net: fman: Specify type of mac_dev for exception_cb
Date:   Fri,  2 Sep 2022 17:57:30 -0400
Message-Id: <20220902215737.981341-9-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220902215737.981341-1-sean.anderson@seco.com>
References: <20220902215737.981341-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0315.namprd03.prod.outlook.com
 (2603:10b6:610:118::15) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7ae83f7-8632-4327-38bb-08da8d2e365f
X-MS-TrafficTypeDiagnostic: AM6PR03MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +BewBlAbuws50cy1qpc/BsCAeQv0A7Tuqxc3yUyZW/m67RG8GvFlgstX69urO1Btv+sJO5sWdYW0vDt0CRmlJ+EqYRs3mxCqlODYRf/eOtdPS8O/uxNOE7h48RpMweUadsiEq3ranJAmMw4mjtX54pT+Q2dPoQuQsi1pcGHuLKsbh4YcaOokTD9bg56X2vpvM7eMfQ6DOBTAEhUNZl6I3s4p9TsyU5xKJ5/g0F8lvHI01xhgVPpBTcrwNfSzs4t3wpPMYF0sD6DHamOqhVM8Pe4GCU62tZigx63+ub/RU4wEBWwj+oqlMjEVzd7UYEwD4X0Q6rNtPGsWzu/BQTvfd+pctEWIIEG2pFk6gyBy1kv0KO9Yv9eNxA2kh1MpJgCnBJd6+znaoeLR8o+/EeFgaZXA1+gvp8BfEbcfktN9VawwCkAiXHhVj8hbXKD1hNxGXlrrCXMmRozZGI86nsSQ7P/GOm9fmOsdCQGdmtXDciAuRbM119DtdX0yzFH5zf+1a5EJAF1CJHz1Zpq/Ljt0/xHp9eUc+j/gzmc6tDAmt5R7amIvhthNoSlGOwTls8tljN7h3vGSCl2Eui4UboOZQJKoi8AP3oJL+TiSk9hlrD0LfKa/sARCPDepKBLjIbR1U5e251UApijzq9hmLG+Zcf7PXln5yW8utf6Du1gc8BtXiWPXWg7pDFRucs4R2aXhzOs0ihM9+sfXVzzg4DpwVpUt0takW7YLCoWtbReK7V/AZXhFVK9/2KvJK43KLMtOYzmvo6Uf8gz2jGdD9hVzig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(376002)(396003)(366004)(6506007)(6512007)(26005)(2616005)(186003)(1076003)(7416002)(44832011)(52116002)(8936002)(5660300002)(86362001)(6486002)(41300700001)(6666004)(107886003)(478600001)(83380400001)(36756003)(2906002)(4326008)(8676002)(110136005)(316002)(38350700002)(38100700002)(66476007)(54906003)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/8i+X10rqpI/QTTx31dH+ZdoG9/qk2010Td7E2Hmn19NhroMBYCmQG0ol7QP?=
 =?us-ascii?Q?Aq4gPVl5sbo6yeJFeRO0gtB3G0U4ISCipEqaM9SVT48TuE8j11GUqYDjsinP?=
 =?us-ascii?Q?BhW7U4f5B5X0z8UgN7E0MmsATFOHKwKMURZ+2Z50FULXLB8qp6Kbz435WtZN?=
 =?us-ascii?Q?MjcKbNbvpBrFYL9DkOLtfx986Y9/UUuxPjVUMidCiBzYAPlBWI21V/YSZpsU?=
 =?us-ascii?Q?EH4VDQe16jPVpyckn1tGo/5LVSql8wz/g6e3QOsvC0P1/myxxeGS++wyGD7f?=
 =?us-ascii?Q?j4jtaxXgW05ogSSDTOa7nM4XSyv29gCuHVO4XSwvdyASdXEJrLw0i/vMXi5b?=
 =?us-ascii?Q?NK58kyg0kDfPSyOuch979C3KWv6f1RgpR2GSt5lA3ooXNO4zxGKheSdvSUMn?=
 =?us-ascii?Q?0LUimV59QqpgJF9IoIh2RbfdtSElbCdmAALixG5VxhoycySDe1va0b7dG8E4?=
 =?us-ascii?Q?pqu0HgcvknZPhJywISWSWxjb4KeA1EW9DGisTn1TGQoW6MINt/exOXVY3fsh?=
 =?us-ascii?Q?t6zq6hUCdyJJqpNRtn+Kt01ZI26xGiEE8kt4nsFx6R3vD6PQxJfDZGBs/gwT?=
 =?us-ascii?Q?dTa4Rdu9lUpHHvNVXJgikPyb/ORDsfyor+ps9sLG/0qtrONLoR6Q+En6mrM6?=
 =?us-ascii?Q?sOgywHyP8OMbtazpXqUZ1atISpQPLeAEmxs6BTwcZEspaRPGYSuc3aesaRMR?=
 =?us-ascii?Q?OROgHxL0xMSLB20CMFbyp/vxreWM+GD6DuFWAWkQPvPZiFtc3Ol8+dH20q/D?=
 =?us-ascii?Q?0g9XxdRSqQyEuXpMjmLde+aXGpkW7V338z61lj42/53btD9WYccxPUzVfArP?=
 =?us-ascii?Q?ob3o7xYHlZXINEyx9h1KQ6FQqD22w8iM015+xwWv8y8IVQKSTOTjM2ECLMQ6?=
 =?us-ascii?Q?YTbQhUl4TS0NxA8nGvmsXQcIMYEYQaeqlkmIq4XzBjvulTR0TvV3i9aWVx+A?=
 =?us-ascii?Q?RjcoXtnhbrx7TDpWRtNxM2RtD/S+3U8JBvhxfIGWRXkmfUSuJhIwwGbxeQ+f?=
 =?us-ascii?Q?+/fRQegfRqZia8NgbO57J4d6ulmQ3RVFnfbsC2vZJctFfB8fjhzjYXfiCUwP?=
 =?us-ascii?Q?rgEMOYjtoMa1u4kFcSs305j8uYxTtTPYpGmPwGQ/F/LyK/Jdo0XW4r7AZgoJ?=
 =?us-ascii?Q?O0Dn88pLlpUQ0XPit8ufTRpSs8qnBK7HPeyReFOnGF9wOOs8+KK8YkscW4Gu?=
 =?us-ascii?Q?zOnlJhZ5ETUGTf61XJcuzw2fhJQwpuNM5sm6TQRCuo7ptrifgjGUpUGECziA?=
 =?us-ascii?Q?GIKdeU4Erzzpmc7OyyBL/aKtR2r+VPkQNJD6cqdEcCaB8KirTS+G0dO+5Hqn?=
 =?us-ascii?Q?+kYulVgChC4//PVqjL4p+VNgUkakO4v+J0t1izdh8ELqVu0hNh0FYs5DRyC6?=
 =?us-ascii?Q?WR1W+cmrxjH44MOn0kEQL51/cbExgmSxX2vayUG24I/Vt9QMAwL6xRtAEXqp?=
 =?us-ascii?Q?zQk7kjb5fyUxNE4wl4kNOQhfCCAg6aeO1PNq+dhJ64/PAJ3QJibrfSIpvQe7?=
 =?us-ascii?Q?f5kyBYIE2esOaVzUkQNCTqWBFSMBc4/1iyxzVM0k3HuR0qxGUV5E5xW12Ry2?=
 =?us-ascii?Q?FzFU5PbC1qMUoWZ2HIy/RNduo3itHQJGuBiOX2jHaAqQuEEvF6OokXE7A2CS?=
 =?us-ascii?Q?ig=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7ae83f7-8632-4327-38bb-08da8d2e365f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:58:04.8599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bn99MfgQvwdBU9gkaJLjnpCUcK22DN70Dyc+TbHJCgQDnc7bTE/fm6I+4m3NC2IpnDiRlReG0ZscHcNM+PJzXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using a void pointer for mac_dev, specify its type
explicitly.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

Changes in v5:
- Reduce line length of tgec_config

Changes in v2:
- New

 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 2 +-
 drivers/net/ethernet/freescale/fman/fman_mac.h   | 5 +++--
 drivers/net/ethernet/freescale/fman/fman_memac.c | 2 +-
 drivers/net/ethernet/freescale/fman/fman_tgec.c  | 5 +++--
 drivers/net/ethernet/freescale/fman/mac.c        | 5 ++---
 5 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 09ad1117005a..7acd57424034 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -301,7 +301,7 @@ struct fman_mac {
 	/* Ethernet physical interface */
 	phy_interface_t phy_if;
 	u16 max_speed;
-	void *dev_id; /* device cookie used by the exception cbs */
+	struct mac_device *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *exception_cb;
 	fman_mac_exception_cb *event_cb;
 	/* Number of individual addresses in registers for this station */
diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index 730aae7fed13..65887a3160d7 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -41,6 +41,7 @@
 #include <linux/if_ether.h>
 
 struct fman_mac;
+struct mac_device;
 
 /* Ethernet Address */
 typedef u8 enet_addr_t[ETH_ALEN];
@@ -158,8 +159,8 @@ struct eth_hash_entry {
 	struct list_head node;
 };
 
-typedef void (fman_mac_exception_cb)(void *dev_id,
-				    enum fman_mac_exceptions exceptions);
+typedef void (fman_mac_exception_cb)(struct mac_device *dev_id,
+				     enum fman_mac_exceptions exceptions);
 
 /* FMan MAC config input */
 struct fman_mac_params {
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index af2e67a250de..0e0d9415b93e 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -311,7 +311,7 @@ struct fman_mac {
 	/* Ethernet physical interface */
 	phy_interface_t phy_if;
 	u16 max_speed;
-	void *dev_id; /* device cookie used by the exception cbs */
+	struct mac_device *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *exception_cb;
 	fman_mac_exception_cb *event_cb;
 	/* Pointer to driver's global address hash table  */
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 2642a4c27292..0a66ae58c026 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -180,7 +180,7 @@ struct fman_mac {
 	/* MAC address of device; */
 	u64 addr;
 	u16 max_speed;
-	void *dev_id; /* device cookie used by the exception cbs */
+	struct mac_device *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *exception_cb;
 	fman_mac_exception_cb *event_cb;
 	/* pointer to driver's global address hash table  */
@@ -728,7 +728,8 @@ static int tgec_free(struct fman_mac *tgec)
 	return 0;
 }
 
-static struct fman_mac *tgec_config(struct mac_device *mac_dev, struct fman_mac_params *params)
+static struct fman_mac *tgec_config(struct mac_device *mac_dev,
+				    struct fman_mac_params *params)
 {
 	struct fman_mac *tgec;
 	struct tgec_cfg *cfg;
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 0f9e3e9e60c6..66a3742a862b 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -41,10 +41,9 @@ struct mac_address {
 	struct list_head list;
 };
 
-static void mac_exception(void *handle, enum fman_mac_exceptions ex)
+static void mac_exception(struct mac_device *mac_dev,
+			  enum fman_mac_exceptions ex)
 {
-	struct mac_device *mac_dev = handle;
-
 	if (ex == FM_MAC_EX_10G_RX_FIFO_OVFL) {
 		/* don't flag RX FIFO after the first */
 		mac_dev->set_exception(mac_dev->fman_mac,
-- 
2.35.1.1320.gc452695387.dirty

