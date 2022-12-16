Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B5064EFB7
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbiLPQtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiLPQtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:49:08 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2082.outbound.protection.outlook.com [40.107.7.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2732E687;
        Fri, 16 Dec 2022 08:49:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0XZgJ6fAx8F3RvD10QncW+jH9aRE6UpSAf9z09Tk7P+v8q7Z+FbujVwj2c8SDi/ao39xVMu7DWRxcYLQBsCwCFh+5cskNxXD6vhjQWr1e9IrzrInQ/rDrMIlXSmH63MKuXdqpD2YyFI9kYf29wiE34v3mFAAp2/KS6wOilgaH0Xsh2uGWBhaYEkIHiYS58BzSiF+SYf2F/hjMd/AOgSYMNVaqbMAOyI+vTtGFQbxGMPG+4EIQdWNfLeeKm0kZRNrnAELTj1qrNG5/EWCvEHk3gQGmkUOW1GBj7Frz10CxBtxkN9AGNjXEVL3ch4KznJox7Vt4bf0vIxWqciX5nABw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z8tcwfqxgeHFKjb7K07Cbtw70yEW6LmRa05eLq/in08=;
 b=exbshPg1QHDZ7nwgBX9kzh7fct3ttmerUbfLR4WJbOP8VnzWG9dks5M57rqpRaBUV0fDZdAuAwGpV76t8nVrGrPhpd+dIS3sCaZcBmOqfZq1cmoaLXC6QBrmcg+uoK5P2GN+WrEDOITVKe9gznf5TFurtg4tAGGWy95DLOFIun1kogDvMYc2JPxw6VB+QAuw4yVWSAKwYWOZWUqcvGJ8eKd3TCj4xsq1Xq6R1SBn734jSBEnmOPn2EBv/0F1g2JjRj5Z063WnNDWbucl1zpWfMXWCOzMTScuNk4lRscPsd83oZPWLkTD2eNa8QamglEgfniO8kjD6jN7uWsOe+zRHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8tcwfqxgeHFKjb7K07Cbtw70yEW6LmRa05eLq/in08=;
 b=JEjx30ZZD0jSzVO3lQqSPzdVRoZiHto4G0Ibd6dV1bHsi7SUA7905ohLDfnqOGzUC3llAXkgHBwzGqGLbA3ywH7J38C7/YiZxWnbJekEofVlkUNY4ldfsdWR3hbaeaWe1+Elu+Hd9mWLpqVddsx1/ckpQ6ZFv5Lw5JevEEL8XLkuuXikmdeID8wd0Jl08K3YB1oxooG0L/jmTzJMEItOQ5CP1Qn5CvjGMT9gqqVPR07LOUPx7n+0K5Kf1p82ReV7tiVNbrAusNLB4GxXvmkcitK0J2A7evGXO/YMOVSpO7WpDpDnB3DasRARrueIx+5mZh3Qv8Uz7sgkLBGj7f9/YA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AM9PR03MB8010.eurprd03.prod.outlook.com (2603:10a6:20b:43d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Fri, 16 Dec
 2022 16:49:06 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5880.019; Fri, 16 Dec 2022
 16:49:05 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v4 3/4] net: mdio: Update speed register bits
Date:   Fri, 16 Dec 2022 11:48:50 -0500
Message-Id: <20221216164851.2932043-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221216164851.2932043-1-sean.anderson@seco.com>
References: <20221216164851.2932043-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0150.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::35) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AM9PR03MB8010:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e9b1937-1d4e-4d0f-2f68-08dadf8571b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X9TGCbs8vnoidoyYnGPmtoMzqTjNN+CAQ0x/tMrz6U9C7YFUWcMXOEGuQEaKhGyHaRO1h9Kc8JkyWa0Hk2tHcFF86ENxVHm9FFTjfAqXhVoF563TUbZZoFoMLcK6onaQ6nIIhGFA1GKztjtDQT93GFSh05TSbT/4aqYYkSC0/UkdciLc7S5dEHTlmpnguh+TaPMYjrIxzPM7EpmC1HcUO5pJUU7vLw1itQrCrk3LRULr4Se45DxCuTAI3YA+ZJJQxSfF2CktvSf5mCDwIOYN7iNEvjVTdTNKvEvrkZPoQW0AK/rNK2oKqRSND4JmWeYyNFREwd+6VCIVGeU99TZNwRnkvhaC6328dPA03pRyrNiNuxJei0qgWn4+r8BkW4UmU3uKcdUNQQWrcs+iOrSsmCwJK16pHeDv5HIpfNxjibA3WjmfhTCZnW8mvwT4d4PJG895JvgyXXzI/nI/uft+aPk2fPjQfI7/jR6XYJlK6wtwt7JpMYBNOt4Aj9ODH8r/288APbU03gSQ8+m2WULTgOwxh+A2Z7xyuceyFt0Zd3yG9OZy1ww/AyTV8XMacOWGDe7eFYKUF+1rZRyiQ/5GBWsazfn7spoT5QtEfY3TIBgITRM8nfUXfcZwlPU3wlQlBieDb8/B+apZhQjNj+iBxIK3L0fo5n5g4F0buy4CoT9LpXjhUf0xEs326s/apqtYz+qRo8St2C8do6G2Ud/BJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(346002)(376002)(39850400004)(451199015)(2616005)(1076003)(86362001)(83380400001)(36756003)(38350700002)(15650500001)(44832011)(38100700002)(316002)(41300700001)(2906002)(8936002)(66476007)(66556008)(66946007)(4326008)(5660300002)(8676002)(7416002)(186003)(52116002)(478600001)(107886003)(26005)(6486002)(6512007)(54906003)(6506007)(6666004)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PsfiQiDspBP02uuCDMVR0tbo/MqPvYVij5gUCFoo5m8g9/2t81HSS7HHuP9Q?=
 =?us-ascii?Q?TRE5HAz41DGmn5J2/uBnDuwOWwXv8GW7kLPfQ14/LlU6rtWG7/FoReWhjoS8?=
 =?us-ascii?Q?kyKeJMhRH8aNcVY64AuqMduBsfeocSvFhWLGvxx8VFinIJX06GTVE9RrGmJS?=
 =?us-ascii?Q?MxSRjaBxGCQWIo8JGz7xLS9UtqLAZaHbZKkwU971wtWLZ2qIDs9kpdk9XxUP?=
 =?us-ascii?Q?APYPiKX41ynZ2/pk0tEVweyBV7iAjPrQ8IAlE+7bqF+qV8mKzUxFCDkxmKAl?=
 =?us-ascii?Q?wky6Q8w3ddt9U9hROMsur5CrKOVNLVVDXQLjqzxINA2KEQI4yTsCAHA56r4s?=
 =?us-ascii?Q?6W6tbLRf6BHr5hJa9UwuhvCgNUP+JuyCksaAAJ8wqD1fQTzvbDjqM9zjMk4f?=
 =?us-ascii?Q?C9ixqg4mEbQ66X9wQ9yYJ6JalQwyVt/q7f6urH0XkuECwHdlAqSTqbDg+olF?=
 =?us-ascii?Q?wLdP/XhbCkWJgU2f3Rh6OhJ1RHY5MKGcAKVilnpkWYPSwrhevR9xiTUv3YSM?=
 =?us-ascii?Q?ML0QAzi7xCafDGbfmBz8r83atli63jGN03YPkW3Eh7a1OfW1MWZfDRX1v1gu?=
 =?us-ascii?Q?7D6s6BASzYTOY9Ei4d/Vq2aKDdWZbwzkAMTtheF23lDPftBjH4rL1h/oosXy?=
 =?us-ascii?Q?jLFOnRgTR6wFzZcOQd9NNDb+D+gcVGUlNjAJzmuWzA9K97gy8oOJ+Bj3Ogoc?=
 =?us-ascii?Q?ZoKAZtLQOMrXkgOUhX/qNe/CGblgKWSjxCaNPFVdl9IxGZrWqTMqrH3Zm+ds?=
 =?us-ascii?Q?o6Ylb99hsljnQVzjqZUGKKgUdSbEYqM/bSx1IDHM6F4m9fjnYKeLgnnXkS6E?=
 =?us-ascii?Q?OugUiSwhsXJ49MJdttM4G4ugVcGVj9KDMCrN6Uq/l5rjkV+42FT/FNgmIv+p?=
 =?us-ascii?Q?+1fAQRH4SDw1KAko6Euu8XnBOzI8bL1hRAPAaqtUCOWQRVRymJiQbmbUGyHp?=
 =?us-ascii?Q?xiw/P86wZ7f42lZvGWRh1SYHdKKROS/oqFeXMoZBh6MGqgyPxDf6iMV8APLy?=
 =?us-ascii?Q?vTyViNSPBm+eGhYH5LXRU5Q+tEz9B9zOWs3okvm9v3f8Ba0HedWZGLyD6Qu/?=
 =?us-ascii?Q?gJrYH/FQbXzzij0sZsxO360tDmeCeu5S/+vT5Ed8av4zA6h82EsReSKo32i1?=
 =?us-ascii?Q?B9x2Tr+osIwa8fxR5ZWC/shmYZiwEV6b7hVUFZdstWorc1IM3ipFHGEIL8HJ?=
 =?us-ascii?Q?uOV91f9jTYAVRO8TsYUijixetTTkjcynQ8b0TKWHa7KgNQbFBU15U8hZOdB/?=
 =?us-ascii?Q?/WFI2157ZpzMkMvzSwaivX2IVqCg6bh/mgWLhBgmill5QTmeos+zeefsHgTO?=
 =?us-ascii?Q?Sm5CRC1KnhTZOjeOQeCFafvWCAMNrA9ula6FO+ywfV7wRhz8Athto1XdzHx9?=
 =?us-ascii?Q?79exgYggw+/dqHfBtm48Dv2jMjNrFceGQ4YzIe2O2qEh7P4GK0pIp71QwS2+?=
 =?us-ascii?Q?u6caPX+cyaCGIz167CBf7KcefKI+n3DVTr0JYKD6Yj6lhegIOqEbRW+49vo+?=
 =?us-ascii?Q?tBfGppRs1P14phFHKC8eOmg8V+KH8mdEtl9e6k5LimkPs21hXeeuA/65O1Ud?=
 =?us-ascii?Q?HpeQ/bc1JADodpDrDsjFD8ql06PDb9G+LzN3suaQ0WK38bmAznmhtm0OvtIu?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e9b1937-1d4e-4d0f-2f68-08dadf8571b3
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 16:49:05.8636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p3ao5dYlb4j1jMTKX+1wlOdAajyZL5jvh5udq/zP2JxYIn+eWGTRMqaJdw9GqN2bcaW10MwFGX5AH0TEMtlVhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB8010
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This updates the speed register bits to the 2018 revision of 802.3.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v3)

Changes in v3:
- New

 include/uapi/linux/mdio.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 14b779a8577b..490466f9a5c5 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -147,6 +147,7 @@
 #define MDIO_SPEED_10G			0x0001	/* 10G capable */
 
 /* PMA/PMD Speed register. */
+#define MDIO_PMA_SPEED_10G		MDIO_SPEED_10G
 #define MDIO_PMA_SPEED_2B		0x0002	/* 2BASE-TL capable */
 #define MDIO_PMA_SPEED_10P		0x0004	/* 10PASS-TS capable */
 #define MDIO_PMA_SPEED_1000		0x0010	/* 1000M capable */
@@ -154,9 +155,15 @@
 #define MDIO_PMA_SPEED_10		0x0040	/* 10M capable */
 
 /* PCS et al. Speed register. */
+#define MDIO_PCS_SPEED_10G		MDIO_SPEED_10G
 #define MDIO_PCS_SPEED_10P2B		0x0002	/* 10PASS-TS/2BASE-TL capable */
+#define MDIO_PCS_SPEED_40G		0x0004  /* 450G capable */
+#define MDIO_PCS_SPEED_100G		0x0008  /* 100G capable */
+#define MDIO_PCS_SPEED_25G		0x0010  /* 25G capable */
 #define MDIO_PCS_SPEED_2_5G		0x0040	/* 2.5G capable */
 #define MDIO_PCS_SPEED_5G		0x0080	/* 5G capable */
+#define MDIO_PCS_SPEED_200G		0x0100  /* 200G capable */
+#define MDIO_PCS_SPEED_400G		0x0200  /* 400G capable */
 
 /* Device present registers. */
 #define MDIO_DEVS_PRESENT(devad)	(1 << (devad))
-- 
2.35.1.1320.gc452695387.dirty

