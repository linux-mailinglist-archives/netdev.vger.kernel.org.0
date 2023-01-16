Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C3566D159
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 23:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbjAPWHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 17:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbjAPWHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 17:07:00 -0500
X-Greylist: delayed 1486 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 Jan 2023 14:06:59 PST
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3132686E;
        Mon, 16 Jan 2023 14:06:59 -0800 (PST)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GGRBlg011355;
        Mon, 16 Jan 2023 16:41:49 -0500
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2177.outbound.protection.outlook.com [104.47.75.177])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3n3rd221s6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 16:41:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwiIqrNWy0n1UQt/AWSZTOjPq7z49s2jqoqyxFNrWNbxLnmU4NMO+Y7yv7Naa71fLg5YEMxEMe6AJLLJbJAUxoXQqlN9yroIynVycsbGBQ/18CxpsGaBLaNcQJc3osXUa7GBmeTHz6qHszwe8bMVeOov7qaReTiIRMS3HlcHqEdToR9RbMXI8IU4J83mLXGRJifBcqrUOnRRkXL1qQLYuE6pcWXxdf6K+Ec2yktZntjsDZZNi9wEwrFMkRThFFcKthuuAX8IRpK05+4PX8NMLn6w8rMFhKvWMjBD0WOkAaBDjNfzRU9TZ5wauLhPRUoopO/VW2s9FSI2kO5XSel5gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WKsZxVaKN2AgK2KyMar4NnspuujtU7mNWGVlwfwwRM4=;
 b=Be6yBgkjwKWEJHzAM5MLVECcsAKyKSM1PHWkwVBtr8f2Tp+DKhVEvjOSNLPBmQJKr5ri8WaNLijDFjs/LN1Tgi9QXeVsW50IzL7yrk3aq5hW9b/ZE6BSPxuWaH9mRFAuWzloNDa0hEbyWHqzFnSBCUUR5oR6lwbYYCdIwUp8adQIs6kqoYDsy63YgpebG0l95PqTi6ZdEM0iUZlRCfipwAySO6Pe1f5mfFF5BJXRnrUJIHQEDBuHl/AGMw2MjXdAUgq3cZWsc5+LaOBx0UjRg4GbA+ygLeEbcwSSLkqk38QcVULB6g0qEepVVF8XjKNxImlXlH4J65Dc8UrHsF03Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKsZxVaKN2AgK2KyMar4NnspuujtU7mNWGVlwfwwRM4=;
 b=K3Rh08djyPme9qagZlENCDrZjSO85kpexXLBiMhiWUoWulqirnPQZcvy4h8s5eATq2CiGJ8SVJXSgkytfleEUa5SIKYpGSIQKtKMzBuZBZ8adpJP02wBD/JiLUVBS4emjB/MZ6ozNAY0aHPdyTkOsWQCNUl9xcA53sH6nUj4zek=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YT2PR01MB5728.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:4d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 21:41:47 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::cc30:d469:e7a2:f7c1]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::cc30:d469:e7a2:f7c1%4]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 21:41:47 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Robert Hancock <robert.hancock@calian.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: macb: fix PTP TX timestamp failure due to packet padding
Date:   Mon, 16 Jan 2023 15:41:33 -0600
Message-Id: <20230116214133.1834364-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.39.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0049.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::6) To YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:b9::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB8838:EE_|YT2PR01MB5728:EE_
X-MS-Office365-Filtering-Correlation-Id: ef5282ec-ee6f-4548-5eaf-08daf80a77c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Ihxp171lRmbvpbQtZ6Ss83CASECsoev0uVTLCdWiL6CTxZuW3pyBNgr1viQ+YCDmmPBXxm2dvryJUFDAe8mBUxJhtXzjemoo/9Z3hN5A5yJH1NvKmFdusjuJDv5udYTS5BzJiPqaX47tUx39lS+d3daEOjajfW8DaAX+GTbJnjPmDeeV/H0ARqvjwwuFqhhA1/kwWGqEatahOKA+0oyPgwSe9Mime4Y7//0nA69fPkKPdgyqgkPj0PcisA/ElDVSN+37c71vIoeeOg+2UoTeyx0p1hfJi/f4LBbxAoQuH/1nxZfynAF5Y8cKGKFxsTRSnQOCu4xlvBpngLTxZl+C3IkyZp7Bm2KNqgyIfrSetp8+lXlig2tkI93mj0G7zNGscwOKPhk8rP5c1MAELR2UgnBl23BfuVGJCQEGWnp7e6A3nbygLuQSj9Hd648dNFmMdiofzaKuPF7+ggHqZfcY3IjBVxewJUv7akctI9i8W8BbpFHFqF9VCDwKXvmuoAB+rFed1Ti0GPGDA624IsbbnVA/0Aw6XFs3iDRSiHN1fQkaShmJrkrmxnRwJEGQt9KVr8XtZjs5ibiGlsLRI+LWkyCSU1YRDqWHczMCDvW370qFA6zLaNpEIdDA9Y13cr6r11vxqI+qWZJ/7OIoyiclpBkv1RsxliWQhMnT+12S6dKMiBz6ko+ld+9B5qhLDIge7Uss4/vzBjeK2Wfm5ZJKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(451199015)(83380400001)(38350700002)(86362001)(38100700002)(8936002)(5660300002)(2906002)(66556008)(44832011)(8676002)(66946007)(66476007)(4326008)(41300700001)(6512007)(6506007)(26005)(186003)(1076003)(2616005)(316002)(110136005)(6486002)(478600001)(52116002)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nn4zrZ/PAQoAejhKfnHVkC2dihoJuE84yqmIESlwfiZU15v24WIs1bUxnN2q?=
 =?us-ascii?Q?2WoOxumCErlg5fsevvJTvAMz5p9oiHP4SzJhKCMz+amkGPCrKWym5x/apkIp?=
 =?us-ascii?Q?2VbKCmBZD062OXoK5ikB8YAe+ZEasTLLD7/wz4sOezgy3A5JDhXqD1bhAXUW?=
 =?us-ascii?Q?eH6UOwsgRCjWxOQxFfay/wsmROwyu5vfo3HO3OWHeA1jb8NMcUGUFyTq9Tiu?=
 =?us-ascii?Q?Sv17s650Ai0kjklzpdHFCRgNa2j5Ogb/7qd3U3ZMLNmLOVFyKFTXoNAu0KIK?=
 =?us-ascii?Q?tTH6ggz0ayzn6MG40DeiUR3o6D1/fp3f56rEfw0AqumCpWbClvMTLF1dGdzV?=
 =?us-ascii?Q?3O25SIwvAkOHj7KTooW3IKLW8qPj/dqQ1db2N94QGd8GSIdAkQaeazu371vR?=
 =?us-ascii?Q?1oBx20hvZU8L6YCD9qOL3u01+JeXNjPVq+qK4C/AaG95WzXXDumtd5ny+H1S?=
 =?us-ascii?Q?haaVSQ3A+ZuNLqpl1BMRTmmdFnN22PaLDc7ar9dc4EWOwFOhx9N2+u3jt4I/?=
 =?us-ascii?Q?9+6fkg5Tkxy4ofQ4MBTtQ9bg3BIo0qRMlyl132rxcYMLdNdku7fX/mAYQdEh?=
 =?us-ascii?Q?sT5IcS6ChqPaakIm+1z/hIFrNZnDCC50nzTO3lF0rZWc6fXR0t/FVGigySLi?=
 =?us-ascii?Q?wXPB/ocHjQfoTbszgafySa8MhRhNX5DfF1rI8uLbQw4V+/bCYR3sYb9PW864?=
 =?us-ascii?Q?n3fFXbAUQCls+pCX710Mu636bWA293x+cRm6GhpGbvTciMW1iO7HHDYOfbrX?=
 =?us-ascii?Q?zsOL9/NXGHLoMWUUkbPK5hwItBGigqBxpqohTgNRFjIA3uvx9ghSbEtx6JR/?=
 =?us-ascii?Q?Geo9sGLD0IzUjIA0OKXbRJ6yZMdHkOh83FZRWaK/vXY2zi0GlscMsO5wxsos?=
 =?us-ascii?Q?5ba+9Lo/e4I25R9hZOA/LQYntdnA4Zm/3E9ldTJavpZOIYRo9IenwALaC06V?=
 =?us-ascii?Q?EV2RVZfJOlYMIwbn3I7dJjJ71t1OtVADSteT+PYjtBFydt2HqthFdPkoaKdp?=
 =?us-ascii?Q?fjtAAv8ftsFzgSV03SOsDG9FW+t1xxKLzb9aHPbHsMDcZ5EZMKcRFsKmZlNb?=
 =?us-ascii?Q?dxFmTfn+7Vot8DsjpiRwgMwaA11qTTD3LIgNS1x7I59S+T0e7cidxJcLHx6q?=
 =?us-ascii?Q?RqstFfpTFodZ1fJDhK9t0wV1+wZadEH5KVIW5xYi5xQzbb0WD4VBRcxFm/Ii?=
 =?us-ascii?Q?SLmcUFQatNSiVse7cQzFTCfQDeOswqxpgp3KMZVSRShAI5PMA6ltR8OlP833?=
 =?us-ascii?Q?PVXSjXpLLlt9bjStDc14T3JyVsN/vSE+N4bo+SlE31iBU+m54xZZQyaNRipn?=
 =?us-ascii?Q?Qmwa9DeCoO9UjLBX9VXYV6QxkSqneydV2Uy/FUSAUA3QvXUESON+niNAPFz6?=
 =?us-ascii?Q?nnU2aqvBRLRc/SmHG/GTdnza+dV4m9lUJNP+9PT9S158tFu32lfB7OWRaE0c?=
 =?us-ascii?Q?jPZ8ASA+o8zVi/s4kCw3XE1nconKIRcX/hJ7BZHctKSuFG2WfgPXAnJo3xPB?=
 =?us-ascii?Q?z//jJanLDuIaqud3ye479LjcWUD6Zsguwz3YN6tSsIQA5c/xfGARNzcONUEE?=
 =?us-ascii?Q?BcHErWi1idGa8ZmSUmBY1OxAzwxTpFH5eJYEm7Bq/MxUGtdj4xR3HcNnPtT6?=
 =?us-ascii?Q?YQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?l26oJgGqERppHmylUd0N11kixT39BmIpewdP7AziuyYQPhiQDiuX2pdfwr/H?=
 =?us-ascii?Q?5JeRPwyApkVabopvqE+x3TdFDmAIxUNmnSCmprjfOxz9qk0AxPlay0nDkWAG?=
 =?us-ascii?Q?+fh9I2Dc7e4+/tKCv+oQQKuhiNqEk2eyoU0lZDM8ggwmi98xxpCDWSLQyGiF?=
 =?us-ascii?Q?8siOhBsbEs0s+h2lkeOR0AmFHMprMe2An2VCSEuwRophx0EFcY0UiCotlGMP?=
 =?us-ascii?Q?s72PpVJfg0uCkyRBshPyzNKQeMyIcx8mTL+rRPeNC268j/U5UxtMOIY+VpGa?=
 =?us-ascii?Q?tzQCFff4a7SIwAvsIdCvxQjcB3IdyS6XrXJjF+uqRhG6jhjzWpAGlpGkNxGW?=
 =?us-ascii?Q?MjDvlimsUKgtBd+ilLjdpdX/s6BWQYP7RTV5BlSO4UebhA7chKPldWqnHzVh?=
 =?us-ascii?Q?4HguQFS76ORTE1XhUH0fWZKhiD0OXOTp330Cj6unY0ueogSj8eY+XP28xPoL?=
 =?us-ascii?Q?hNiA0wLVpM247ighcSvfWurHZ4j9S2BNCksDPPJQktvM0apZ6pojJDNlW0Hz?=
 =?us-ascii?Q?buDY5NZ6PpJ3rtEoSl7iMeCcKZWr8vP9mMpOuBCXwG3hpHnnZeoSZ7AjJ09y?=
 =?us-ascii?Q?E/Heqx56OQgaXEziziO+kF67g3iKvMMH0zOWTwiSZ2oNdIIx1KZmGu9mHhWJ?=
 =?us-ascii?Q?sapZDfzh2RvA714OwWX9D1CyuObPIccPIgCmLSU/ve9tgzVQsr9eP9hv3Ikv?=
 =?us-ascii?Q?KCPKLfFv7E9vmXDzvHq/fpfjtTgEXyVaf031hfDQEXSMQ7C1DvJLSLQvS7bE?=
 =?us-ascii?Q?4hh/yONMMIg+gNJXjbk+3d1rkxKiDK7beHpYuurcgaB8gTBCi9UbsldHgI33?=
 =?us-ascii?Q?ms8hiXCDtojqjW049PG+RxW86XQUFfMJl2nXUZBufqunt72c5gTbbArHoam1?=
 =?us-ascii?Q?CtN68mHWv0nsXUuIu4W7T6cl6nNonWN9GZceNNZ/C9x1OkF3VuolL4eeBbz3?=
 =?us-ascii?Q?KI6YqVvZTvUXXseRJB07qQ=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef5282ec-ee6f-4548-5eaf-08daf80a77c8
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 21:41:47.0421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Po1btUg0ODrb9xAIlaoFq61oLmkPTBw4N6hYNU7Me1h2a+a9qrsjsKvXzCHXVLjGNFLr2kVKYJ3GPIXSl9QiEapTR9Z8Fp0f3SXCaHZbn5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5728
X-Proofpoint-ORIG-GUID: K-5q7u_Wl5T_LlGnwR3f-zBOnCY_CB_s
X-Proofpoint-GUID: K-5q7u_Wl5T_LlGnwR3f-zBOnCY_CB_s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_16,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=858
 adultscore=0 impostorscore=0 mlxscore=0 spamscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160158
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP TX timestamp handling was observed to be broken with this driver
when using the raw Layer 2 PTP encapsulation. ptp4l was not receiving
the expected TX timestamp after transmitting a packet, causing it to
enter a failure state.

The problem appears to be due to the way that the driver pads packets
which are smaller than the Ethernet minimum of 60 bytes. If headroom
space was available in the SKB, this caused the driver to move the data
back to utilize it. However, this appears to cause other data references
in the SKB to become inconsistent. In particular, this caused the
ptp_one_step_sync function to later (in the TX completion path) falsely
detect the packet as a one-step SYNC packet, even when it was not, which
caused the TX timestamp to not be processed when it should be.

Using the headroom for this purpose seems like an unnecessary complexity
as this is not a hot path in the driver, and in most cases it appears
that there is sufficient tailroom to not require using the headroom
anyway. Remove this usage of headroom to prevent this inconsistency from
occurring and causing other problems.

Fixes: 653e92a9175e ("net: macb: add support for padding and fcs computation")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 95667b979fab..72e42820713d 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2187,7 +2187,6 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 	bool cloned = skb_cloned(*skb) || skb_header_cloned(*skb) ||
 		      skb_is_nonlinear(*skb);
 	int padlen = ETH_ZLEN - (*skb)->len;
-	int headroom = skb_headroom(*skb);
 	int tailroom = skb_tailroom(*skb);
 	struct sk_buff *nskb;
 	u32 fcs;
@@ -2201,9 +2200,6 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 		/* FCS could be appeded to tailroom. */
 		if (tailroom >= ETH_FCS_LEN)
 			goto add_fcs;
-		/* FCS could be appeded by moving data to headroom. */
-		else if (!cloned && headroom + tailroom >= ETH_FCS_LEN)
-			padlen = 0;
 		/* No room for FCS, need to reallocate skb. */
 		else
 			padlen = ETH_FCS_LEN;
@@ -2212,10 +2208,7 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 		padlen += ETH_FCS_LEN;
 	}
 
-	if (!cloned && headroom + tailroom >= padlen) {
-		(*skb)->data = memmove((*skb)->head, (*skb)->data, (*skb)->len);
-		skb_set_tail_pointer(*skb, (*skb)->len);
-	} else {
+	if (cloned || tailroom < padlen) {
 		nskb = skb_copy_expand(*skb, 0, padlen, GFP_ATOMIC);
 		if (!nskb)
 			return -ENOMEM;
-- 
2.39.0

