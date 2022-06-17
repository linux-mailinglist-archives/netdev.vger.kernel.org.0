Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAC654FEFC
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377215AbiFQUfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356507AbiFQUeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:34:31 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2065.outbound.protection.outlook.com [40.107.22.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7334B5DA26;
        Fri, 17 Jun 2022 13:34:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RhlVCKRpE/jXRdFdYQllcjOiu7hP/Bsa+MWkaCMY5EsBsXbvGNex+qHR49r8PaPHxmq7R14nzE3seqUIcRxGXM8vWsL8TL3X2Zjbdu+gvSgpH9cUPnX+FZq7Enz/FPeWZqRnCiIWN6M0fU9G9+4xWG0i6veXgMvzoHKRZqNWPksjHv+QJZ6aO4bKGrhPzGRHGw+C/de/oJGzRN07ll+jBgNm6avwio6+zCiVzijR7bFgQggCGz1LUwttReosRDzCWfLmqALp3cvjDzK8X8UONzkit5dixOenD45enGFoKjZcELqGrOSJiywaMgLmeVgxnFfa5zR2/DWUxtpwGDswLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vRiLvnW8cA1S7WsJ/ivzaAIyrGttAsTtVTGeOUB3Woc=;
 b=XFGn+AJaDEE9jKJkjCarE4MHVUs/kXJeCQ2YH1TRvBol/3b6t/1aETTPokaL/E7A4FVQp6pGClY8UcTTk26WDEuYhHkZ25dD+SzJm139t3MaiP8Nx3qMckQS0TY0KT6Owx6EN3U0s6xYS1OW/6J/xr9Pt/UZ+y53q6VMdx3Zh6FLtrGaDXiuZguMMAv+1EBxmOZnNVNQkRGHt1C05tR60Fqo2kH6y+OTcToRSlEzYSV2uhhq4RCoJaNDu9aJ3tihMAVMLakt3XhQqtxbXj+PZDXD2Hg7WvmeKQ/RY7AIfVxmrhPKTebLHWIoSNc+20g80pdXAR5XaNYZXbiF3nMvBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRiLvnW8cA1S7WsJ/ivzaAIyrGttAsTtVTGeOUB3Woc=;
 b=Jpzbxzas5IlZo0wXdGaoIZZobQ56d2/iWVtqUHGgudy8NnlLd076zDjUr+qRmmxRyzDFtUPurku/8yqZuDKvQOWB6T51R8OObz2czoUmehCzVZDcm1zy19lDrQ9ZO92vcRncBqXu1UOzp9dW92b14kHvQOiZZ6tReJVFTBukyH4m85Ud+kDhyLpoUtCbOIz3eC83yvzRrwvV28jCX9jRy5UujwsDMsQSHGgbqHIvWNXeXDou35sgBAUb133LeC+uDweLp0BTq2r/ETDbcXP8otPkozu4aA1db5H/9pkAQtsWaOLSm5fqr7DvrT0jFz/cTQRpQXxiNfo11xUKkSqR7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBAPR03MB6438.eurprd03.prod.outlook.com (2603:10a6:10:19f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:33:58 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:33:58 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 12/28] net: fman: Export/rename some common functions
Date:   Fri, 17 Jun 2022 16:32:56 -0400
Message-Id: <20220617203312.3799646-13-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10798c05-9ab0-467a-a3ed-08da50a0b4d6
X-MS-TrafficTypeDiagnostic: DBAPR03MB6438:EE_
X-Microsoft-Antispam-PRVS: <DBAPR03MB6438EE6A6AAA41E58516252D96AF9@DBAPR03MB6438.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NSgm7muY6dqAWiOuoN6kwzZkt8s/Z+yOwM5Py+IYiVz/+LH9b6zx6e+pXo5EhIAphPsebRPR/TaxxoB5wZkxDVudFYAECuCvEErmdtRuj6IG5Vo52VteYqk4AT0K1ldxmzP5n7hDhk4F/Rk3sfWrwqCS/A0Lh+ENYKGbYLMh7RWRc/GJHrWf0500+hHwtwXRtNcguB58KSh1NYo0XeLQsZrod57gzNrMiAhxiTO+k7TJoPGuh6sm1DHUTXmGdUrmvg0r2S0g9aXn5Otzk5KnBZ/8dRhZFjW7mtKI1s11rFx9KNSMOkxrl9LSiFH4rZMLqlhuaHTTcbxr6xcnO6fKPq+2I+xUd8VEe0M5dH3Ri/gU4gliPBwa9iyjUHmcAEzFWH8gYtbTxeCUYMeLLSfrgTGrqvQzaQED1bl6YPqJpL/h2Zya9dMv8OBHvwXJ1zHcJFMqvxcPQsdlxiBbPcb6KwyvAcV1Gr0fyWSvQtlJ/X3TXERgiDj15pZGIecdseD1r0peWj5Q86lebViMCOspcj1BXmj7qihw/SMGdcwB8+KYL+8YmPyMmZTrbvYMa4ykdJSvk5PqErAoTa6ytNfovRwqV0fbZHgNsC+6lpadpRBVG6Cjl+KGQ0j6YrYfDMNNMAk+6GxOyBvcygAbqTQAaMkdAqv8WqKSF05wsugYyxh9k8AbL8D9J+sq7x2Dxr0o4QvzwtdFxQW6jFvaYjFCvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(54906003)(498600001)(8936002)(110136005)(6486002)(52116002)(2906002)(6506007)(4326008)(26005)(83380400001)(66476007)(66556008)(8676002)(316002)(1076003)(36756003)(66946007)(38100700002)(107886003)(38350700002)(44832011)(86362001)(2616005)(5660300002)(6512007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sK2fPhYVM7lwSCua4bmq5KWhv8wZVMNdP+5FU0QAX3xre7q/jDtqYYF/xn/X?=
 =?us-ascii?Q?r8AUgNLHJcOQZ9O5CdMmvLnQAhO2TL0KdUPWwxCI8A52DiaRR/DYqBamxzZp?=
 =?us-ascii?Q?oLI1OC1KrYjQhWIw+lLUUR37eO50imeDHqEAmceZNIdkIDtB27fQBxSE4elr?=
 =?us-ascii?Q?V590HGIjLjeE+/q4Obu4U1juO+jVHVvdP+EHp7T3TtG/TkWq/gZ3DLpxxb4z?=
 =?us-ascii?Q?cXQB+mzjWYS0nk0LES/H3GhL8C51VHZ5qIntwJHmz8VjG1v6Q7Y7Rw+YiLyf?=
 =?us-ascii?Q?5DKIszAQX1bC3n1YW5Ia/ioCRMWwJQcIzkNiKwPJoNW19ucs/1w9jsoS847k?=
 =?us-ascii?Q?/6X0Fhh4kF37P2ZkwHsT/bOLsnmxvf/z1oyETYQqG730AxuML5la2R2wsCcS?=
 =?us-ascii?Q?C47MUkDQahSSlddgsHed6Ek+QW4JXypaURr5UImCcoz83mr90sqvluzpk00Z?=
 =?us-ascii?Q?a8WLrf6JJzHjbFT3L4Ki5BkDMZC+ieX371M1cgDnoOQEcFMNB3PJJ1MPcCtJ?=
 =?us-ascii?Q?Ii8aZK8yy3mFiCUIfTN6WhFmGZ5TKe0jklMDrpqOM8a7KiW6/vgOVIMmHCpW?=
 =?us-ascii?Q?r+Q+o/1O+1JWJ69iB91dc/H2yQ/V8k4KmrRJk1jP5IWikVEavi37qfCM1Gkm?=
 =?us-ascii?Q?h+AJKhcM3cBuppQMWJhPqg9rnXYOUwwl/oEEx9v8Zl2S61bNhXgrwDXE6qTk?=
 =?us-ascii?Q?GofI4AGUQXZhRkcJm3kB7NdfB31ZnHmQ5+YQzvVlidb+ExiteAkhoQ31ipuZ?=
 =?us-ascii?Q?sUi44ZryVhrQTA8RLcMdNMgJoQS8Wd7cuR4rC1nXkT7b+0rFKNWxocXmBoo6?=
 =?us-ascii?Q?2ev+TCaZKJsm9qoII5KOHIUPbTWukknrMglKTe7S2V2gjzgzV0cKIPiUOfl9?=
 =?us-ascii?Q?xmzvp+U+sviVIcrftf+DFF8hH+vCAugqQSUii7YIb8v9Jw4HgEmI/22Qdzev?=
 =?us-ascii?Q?7CvZJJQP3N2u4SVH/JDRIa8dJkY2Db3aT4fMSgo4IoAzHcQrJSEWX8CpGgBg?=
 =?us-ascii?Q?mOdQI4J6mOwNncisV4iezgKBfp4M+o3+e9bwiHQ/a/YJGnP5Wy76GwKVpwxx?=
 =?us-ascii?Q?p2BhMfJ4Zhhi0luwq11uGpCt2LRjHoATvMYbYKxMEPIy6KZQLKC25/ImiRJf?=
 =?us-ascii?Q?QpwiKehTNgdIUUSsDftUnLiG2rayj0OoLGG+DS3gJZfNRudMRWA6+eolkfbA?=
 =?us-ascii?Q?8lkL56jr9fSFhtQ8zuPdWPDOeGeSWt6Q5NUauNFkZJgGBaoDN4LObdZywyqJ?=
 =?us-ascii?Q?QXUNpgDzTGvvjA6mOFhK9sgGUkfDfKB89qM0U2nPte1EeBjkbkDf456vt2OJ?=
 =?us-ascii?Q?MVb4X3D9eL0rUhtt1tPUz4CchuzNRyIo7FX81oM6ncYib/11rzEB/1vWmVky?=
 =?us-ascii?Q?RXL4iYk/EH6SThrbbd5pkWImmSoy5wgwpg7ut3XW5CYqGaW1tAhcPnwMcpH0?=
 =?us-ascii?Q?nJ11iatMTcu58+lgKhnJZhrxNHngWPxmucWVuFxnfts0+aGjh38HKn/G3mbG?=
 =?us-ascii?Q?/OLKRHdRxO6gMOfZY/PcQhJ06B+wcrBDaSi/gPZRXjK4snp3LEZ4x+aTS6rl?=
 =?us-ascii?Q?3zpaFrfX/5Qkd3U8fhAjXoN4jZhEYzypCHo8hxyhDy1HIamF96PiGZpcHMUq?=
 =?us-ascii?Q?Zio/lCwk2T3kZ6BuoV6CB6PUPwNZmbQYMRAnN6It1lzXzmQ+s2+pALxxqqhj?=
 =?us-ascii?Q?EzJapCzSUfwtP2msI7R83npAchtUNl+KTYA7fvjzaRACozofCRV8snwQwC5x?=
 =?us-ascii?Q?Xhv3wxj1fXi2zfN7z+RQ4908XvS84c8=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10798c05-9ab0-467a-a3ed-08da50a0b4d6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:33:58.6551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bhw+4yAu0fRRdQXN8E9bAE18z/gRjC4RHX5FhGsD0/V6mVT9ll7EVwlkmcPyTGDTzYvLtOBtcPqr5UyE2ljzKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6438
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for moving each of the initialization functions to their
own file, export some common functions so they can be re-used. This adds
an fman prefix to set_multi to make it a bit less genericly-named.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/ethernet/freescale/fman/mac.c | 12 ++++++------
 drivers/net/ethernet/freescale/fman/mac.h |  3 +++
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 248108b15cb0..ac26861ea2e0 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -62,8 +62,8 @@ static void mac_exception(void *handle, enum fman_mac_exceptions ex)
 		__func__, ex);
 }
 
-static int set_fman_mac_params(struct mac_device *mac_dev,
-			       struct fman_mac_params *params)
+int set_fman_mac_params(struct mac_device *mac_dev,
+			struct fman_mac_params *params)
 {
 	struct mac_priv_s *priv = mac_dev->priv;
 
@@ -86,7 +86,7 @@ static int set_fman_mac_params(struct mac_device *mac_dev,
 	return 0;
 }
 
-static int set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
+int fman_set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
 {
 	struct mac_priv_s	*priv;
 	struct mac_address	*old_addr, *tmp;
@@ -281,7 +281,7 @@ static int tgec_initialization(struct mac_device *mac_dev,
 	mac_dev->set_exception		= tgec_set_exception;
 	mac_dev->set_allmulti		= tgec_set_allmulti;
 	mac_dev->set_tstamp		= tgec_set_tstamp;
-	mac_dev->set_multi		= set_multi;
+	mac_dev->set_multi		= fman_set_multi;
 	mac_dev->adjust_link            = adjust_link_void;
 	mac_dev->enable			= tgec_enable;
 	mac_dev->disable		= tgec_disable;
@@ -343,7 +343,7 @@ static int dtsec_initialization(struct mac_device *mac_dev,
 	mac_dev->set_exception		= dtsec_set_exception;
 	mac_dev->set_allmulti		= dtsec_set_allmulti;
 	mac_dev->set_tstamp		= dtsec_set_tstamp;
-	mac_dev->set_multi		= set_multi;
+	mac_dev->set_multi		= fman_set_multi;
 	mac_dev->adjust_link            = adjust_link_dtsec;
 	mac_dev->enable			= dtsec_enable;
 	mac_dev->disable		= dtsec_disable;
@@ -410,7 +410,7 @@ static int memac_initialization(struct mac_device *mac_dev,
 	mac_dev->set_exception		= memac_set_exception;
 	mac_dev->set_allmulti		= memac_set_allmulti;
 	mac_dev->set_tstamp		= memac_set_tstamp;
-	mac_dev->set_multi		= set_multi;
+	mac_dev->set_multi		= fman_set_multi;
 	mac_dev->adjust_link            = adjust_link_memac;
 	mac_dev->enable			= memac_enable;
 	mac_dev->disable		= memac_disable;
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index 05dbb8b5a704..da410a7d00c9 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -71,5 +71,8 @@ int fman_set_mac_active_pause(struct mac_device *mac_dev, bool rx, bool tx);
 
 void fman_get_pause_cfg(struct mac_device *mac_dev, bool *rx_pause,
 			bool *tx_pause);
+int set_fman_mac_params(struct mac_device *mac_dev,
+			struct fman_mac_params *params);
+int fman_set_multi(struct net_device *net_dev, struct mac_device *mac_dev);
 
 #endif	/* __MAC_H */
-- 
2.35.1.1320.gc452695387.dirty

