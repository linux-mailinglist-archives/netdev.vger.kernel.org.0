Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219BA4AECE1
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236444AbiBIIkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:40:33 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiBIIkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:40:32 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2138.outbound.protection.outlook.com [40.107.215.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9DDC02B67E;
        Wed,  9 Feb 2022 00:40:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0jYuPESpXwAcgSar8XrJgLU5yp/4x77oJ4PJdzSw9qoagN4qHVozbB6n5ik9GocYnziaXXSRqNtojCqdHe/6Jbha/FikAjkVjXUcBo/9bkDEhu9URS9X+uWKvLzg/PAkFF5Q1Hmo0/dko8U0KCCdzuePHauXMlfGyAqYE/u7l0H8/7icQ/p2Jq02iuF83QoYG5wf8EbkgwzpIf6a8CNptpfuauKa8G2yOxNHd6azmooyr7mka4AEbm9XUjLbSx4y044pKyKSv3QkdAwCjjD9+O5OlSXp6DcP7IApN5KFnnvM43CWHK7fEoT5dhedYBp0B9xvp7oHYuEwqf8HdgKpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e6Ls3XnE4MQCsmuyZ6MCvE9U03iXd6fzzJt9twc2v9w=;
 b=mR1fXzyyVXrwvCGh/mwRgKDVI/TWiEFsDShalQIGrCgeZIIBe+r26+g05A+q/u5BAouv68QjO2ihoGcbmI64dZGqJdR25tDqXRYtaUkdSeOH5gqazPobmm5/YUYuNl4FcSLaQw8y8hCiVRLY+ZubHwtT3BUJxEKOttGgsfkLTJbU+TnbxGeo2qNg1rjc7LmZKCS4kOBa6Q0JquNv1Hu/cg5EV0K6fWv+DmahMtP1x8MY5ZJP54nG/jtbKkv0QGu0Q0BdMdXSK6aikvSRw1XBq/upmisxFGbIX0FXUW2dy6rayinTP3IeZF17A8fhehilMdFuNW4RCUejBwganafR7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6Ls3XnE4MQCsmuyZ6MCvE9U03iXd6fzzJt9twc2v9w=;
 b=mFFykur0BcpskiO7NUGWGtubPZS+QDikbLhseloLAchOAfHG8OjXpz13YebqRVqrwExfyP2K+UFIN+tZ2Zc0h6AkbqMWZekHH9lojReAaM60y+satOk2QmrP7hev9d2/hmCvaXGtzb7WGNykJxf+Z7Fs5J7dLDDBJ9lRhyechJU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by KL1PR0601MB4387.apcprd06.prod.outlook.com (2603:1096:820:7a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Wed, 9 Feb
 2022 08:39:40 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::80b4:e787:47a9:41bb]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 08:39:40 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: wireless: ath: use div64_u64() instead of do_div()
Date:   Wed,  9 Feb 2022 00:39:32 -0800
Message-Id: <1644395972-4303-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2PR03CA0044.apcprd03.prod.outlook.com
 (2603:1096:202:17::14) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90053797-a5d7-4b10-0313-08d9eba7b66f
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4387:EE_
X-Microsoft-Antispam-PRVS: <KL1PR0601MB4387A9CEC0A7D4E3C184EF49BD2E9@KL1PR0601MB4387.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: axxJKEp5l0Bs3vjyuVPyjlyVvDViMdryP+eclpQ7mT+ZA2OYcXPonl7gPaF/I8Hmj61AnCyJpoAgB6wZhy5YuG3LbcWM98SQzVu8Kh6O145kLa7eRKyKtXdZBMAzgzeZBPnOYWXwJrRX1XKkFhBcrCmcpIrFI+8f082RBsIocT5bWG98X+rbzeCcRGYjZtu9eZYo6stikrXbCEkYCChVK5nTrzXssHbBO3DckRR1DkMhDyRckSsmPY/66T47sXUbMUamUKnn5bnGqvJpnk2T+8ha3N3tis9awVAHrCofxJ5Zvuj02MFRxahEwBdkc6vNt+Zbo+KZn5Xtrsjd9lkntFwZT9STVb92tV0NksfFc4xQkgTehvl+XI5055u+UdOF1ARPsNUAEBieKXY2Fth7fZbw/R/uC4pHR58pnFEBxYf0OsOP51sHzTax4kAXWerJ5wvBAgh5y534yE10xYbArBjd5mCRG5YRuCnQjpcbNLPyLJY79Wx+SNG9DXsimJdQJuOYcbzj8fid294JNbxzJFZRhnfiS3GQP3AZ3xEDqnIH0R6oKoLU+hctayR9e5+e7inFckqgrp5w2l/g3QYYECDQbPZLiWZcv42SKFByz5xRaJojdZG6dSS11cRAsAbfbttarfCaySu7vDXkS4XRM5fbzkjN2c7z2nvZv9W+cJylFDPyzp2SauYzomh74dzDskNE5+H+ejHtp3s/KFvpVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(4326008)(110136005)(6486002)(66946007)(66476007)(66556008)(8676002)(86362001)(38100700002)(38350700002)(8936002)(2616005)(2906002)(107886003)(36756003)(6506007)(52116002)(5660300002)(6512007)(83380400001)(26005)(4744005)(508600001)(186003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WhkZIVsw4eKPRLV7Jspsyo8o8mWt0HH9oJuY7+x+BcDdSpl4ey+hwwYPtV0U?=
 =?us-ascii?Q?4xvfSGhJf72jPzZ9YKBZtVScGSWApUS3a3bmgfZMZgjbp0ALyekzQ6hCnPQD?=
 =?us-ascii?Q?n1QIL5GLZDltJYM1x5IRrgF2vHBrRq/nOLg/ADWLqykEVUKPVnCT3emE/ogO?=
 =?us-ascii?Q?vG2yGEaDLdZO2yEnqkGwMQT79yrVYaznZvkYlk22up0rBZAo6yJrwNKyIqlx?=
 =?us-ascii?Q?X1cGcXsztEDWVaxlqA5+hd/hYVh8XZ4vs98LMyEadwxXDumhFEhZ2aPr82Q+?=
 =?us-ascii?Q?9yfzkrCGfjSLs2MdEkqV/D1wlMop+/G4bXC2Blp3KmINbxI3WB1/afeoDSFF?=
 =?us-ascii?Q?POI02dM+03eOWG0SFxPkdC+0z0PhhpTOJpb+C2LWQsNGapFmM/ozcSkz9xXW?=
 =?us-ascii?Q?pBGcw4LMg+b4nnhmG9oHWXn/tfDWhzoHtfXB8uIcpfx4oAmlEiNVGq0931Pw?=
 =?us-ascii?Q?XJmG9bt/umu+YoJkdZDzOFIT2iF6Di5pA93X6vE4yWIDvJ6EWRlzNGq3zO7B?=
 =?us-ascii?Q?rpIlKWQImbEa5b1V9jowcct0xWjOukxPsJe85MplBmseNORYZLWX4CPOZDIM?=
 =?us-ascii?Q?ckeI2srE6mgZGTfB8mtud2xa4Dto0Gmf5LdREiNh2cR1wJBRkLXCi+S0hjib?=
 =?us-ascii?Q?T4lDaUIQtF2nVCr9FZntk1BXJH+EYPYqeqa8VQgvJ/g5H6d3CsNtJzxI05If?=
 =?us-ascii?Q?I5SHRwl19vELWhoPHGbb0e/Lq5s5SfMUCTQmu4QGMh7VWRHR253sRfTfAiBo?=
 =?us-ascii?Q?6OJKgvFBVo33iTlUNG/lCAx5au9f1VhUph9z/pxY1nJMoundjdkdTrXlROau?=
 =?us-ascii?Q?W49koXxq0xw90xKCGLsrr7M8Z7P8yaQfK9pyq03FbgIUYNLEJjNWZiMOIACV?=
 =?us-ascii?Q?VEU2ySRZMGHSgp199wS2p6AKcy/snv+gLWI1hSdgv3uW1ny8Lcsf+YSJT0/h?=
 =?us-ascii?Q?qUqLUMRVEJLrxX/BGG+/LcBavgB9cSOcri/Yt7nbJrhaHRy8F1UA88MKe76b?=
 =?us-ascii?Q?EUDEYTF3bjm1kt7kNDPqRZsIYcIHNZSPInVRey4DpysDtZnaXn6e7XoSXSf9?=
 =?us-ascii?Q?Gy/6mg3H+f0aCGc/z7JEZRaH6dlJHz7cRf0Prd4r5kiXbvaMdNB66HreUwWN?=
 =?us-ascii?Q?diclstTUGq9srGocYRd8kB9FefKcT5nyLo2e0GvkT6lUDlvXfMkyoQln7gls?=
 =?us-ascii?Q?SehlBc06cVjEbCpXCsP31ykKHaYiXdtyBApoZqqR67ObcrPQuiszBtHk9kOg?=
 =?us-ascii?Q?WgrlQ5DWzrfiQt96BEPsISTuNkfB05lB0f0LgKuTEu3krNtoM0nfEB8rCXWq?=
 =?us-ascii?Q?zt02HEC/ym+GOkwceJf5sh49htRXLQ1bJzT7OgIADGu2AKcjbMpEM6kuFBlh?=
 =?us-ascii?Q?3SZNvtmPaxOMuTJVVaTclfsVd2oSakmXBXarPlPYlSx6Zjp5a+XoomD8ywjQ?=
 =?us-ascii?Q?26dhFEmefn0aZyAB0sSixOzubUpfUEW2R5wt3lk/LtqoPSSxHggfgf70PGCm?=
 =?us-ascii?Q?fcxIaVx+udy2AE7MXzNx/39zkjPw/ER5/qxhRmm5KCNrKgaMnU9T16jndB/Z?=
 =?us-ascii?Q?4wkjj4uulA3MKiVggLoOCmL4bz6bIreKv3x39JGxEeVGcUgGo2OD+WEcbBA2?=
 =?us-ascii?Q?XC2Y3qh6GFxiSW/v0zhdyXo=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90053797-a5d7-4b10-0313-08d9eba7b66f
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 08:39:40.4148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eQW9Hd4TmN0NyXvAVvF0iuaU+xl7fL86pEea9tEOjk07Sx4tptE+HC2kVTiPsMYvsTtGppXmlqf3A68QipNtFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4387
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

do_div() does a 64-by-32 division.
When the divisor is u64, do_div() truncates it to 32 bits, this means it
can test non-zero and be truncated to zero for division.

fix do_div.cocci warning:
do_div() does a 64-by-32 division, please consider using div64_u64 instead.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 4c944e5..2cee9dd
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1766,7 +1766,7 @@ __acquires(&p->tid_rx_lock) __releases(&p->tid_rx_lock)
 			seq_puts(s, "\n");
 			if (!num_packets)
 				continue;
-			do_div(tx_latency_avg, num_packets);
+			div64_u64(tx_latency_avg, num_packets);
 			seq_printf(s, "Tx/Latency min/avg/max (us): %d/%lld/%d",
 				   p->stats.tx_latency_min_us,
 				   tx_latency_avg,
-- 
2.7.4

