Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2854581AE
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 05:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237902AbhKUEUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 23:20:16 -0500
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:57418 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231205AbhKUEUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 23:20:15 -0500
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AL3t36v022803;
        Sat, 20 Nov 2021 20:16:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=proofpoint20171006; bh=L8+/aMJMZ96HwFCics/BdrN9OIrEredTiJ/ASW1pyGA=;
 b=Pj/MPz0Jp3izql6NTVzKsYg1fe55Knxq7zBGmzBiY0mwLOwKBC/cciMd5QJMWSHkl5+w
 JRqmm/1YeFUcsoOY8ovAmewXhgyIJfgMK5tfcNcaJ28lW5PDy0oU7jFcv2fHsydNQVog
 lvJdPpI0UFFPU/Srm7mEkkJ3N71sSJq5jR+cXwLOVW6CiPAwMdovF7v+cbnXdSniRE6c
 BWuIV28VWMDwqXmrrVnRsv7XAf94YGiiCPHK7VGfcaRioKtwkUshE2AKc+WAjiZ2qxgh
 YZFRTY29ARsvOA0XNlV4ur/c8gHKBNXndV++Tq9Dnq6S3QxE6kSwwF2LjpWsutfq1c3g jA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3cf1f38vjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 20 Nov 2021 20:16:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzmRCfmMXDVvSP0lvY6RZUPFsQWY6u02/vqba4OzLeZfDFEJ0QBCm98yRljdSv4M7GLUlhu6o1oT/7Kjb0bORB9cdSbodW3e+KMqYHrDfM6Nm633KwmkI/hdraBHm/+VvSLApPRvaZmpcrKaR+iKL8/Ba7eXWfJ/tY5ymWf9lyt7/LJawXJKGaQOy9zMnfM3eQiPruaw78k7pKkym63egAc2oOW7cjUy1NYVelIiLDV11abY87QqIb6TIXxMSeUpzseN3PuwpzQeIPb31GQQam0CsS2Dk1Ak71EqzTq6Vh+sHFdVjnfaKRLBGSMjhwQ+En1Xwht6MI6YDvzLCSM6DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L8+/aMJMZ96HwFCics/BdrN9OIrEredTiJ/ASW1pyGA=;
 b=D3/rVtBBPDXVW+pUvGveMQXVHuzMxB5BVnwzUPJ2I7eRND2FSdt2SDO1iyIyqq2zn04og0bPelz6WNVNWFZO29nSzUYZHN9qJh4/tsQm7VQJ/pmTRfIpjJFH52KZ/JXI+SEPn7vi1zY3D1Qk6NdO1hoaK9CjWZXDBufrDfMVdW07kM9d5+gfXuE+ZmPphfaAO2RN4DATkaDLOZJHJWl8gbUV6tTOgkuRtIQ36UFklYPI3R0q+PUCBUW2frShFlbE9Ugon5yZubQoplCE2vuDw1xuKL6ozmi6uyHHeC7js/06vSw9BpIIuTsWlGIlaN+M3DpjyDmLvjp421V6hr98Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by CH2PR02MB7094.namprd02.prod.outlook.com (2603:10b6:610:89::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Sun, 21 Nov
 2021 04:16:21 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::c549:4f6b:774b:d63b]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::c549:4f6b:774b:d63b%4]) with mapi id 15.20.4713.024; Sun, 21 Nov 2021
 04:16:21 +0000
From:   Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To:     dhowells@redhat.com, marc.dionne@auristor.com, davem@davemloft.net,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Subject: [PATCH net 1/2] rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()
Date:   Sun, 21 Nov 2021 04:16:07 +0000
Message-Id: <20211121041608.133740-1-eiichi.tsukata@nutanix.com>
X-Mailer: git-send-email 2.9.3
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0130.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::15) To CH0PR02MB8041.namprd02.prod.outlook.com
 (2603:10b6:610:106::10)
MIME-Version: 1.0
Received: from eiichi-tsukata.ubvm.nutanix.com (192.146.154.244) by SJ0PR13CA0130.namprd13.prod.outlook.com (2603:10b6:a03:2c6::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.13 via Frontend Transport; Sun, 21 Nov 2021 04:16:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ede21af5-f99b-49d1-1135-08d9aca5ac7d
X-MS-TrafficTypeDiagnostic: CH2PR02MB7094:
X-Microsoft-Antispam-PRVS: <CH2PR02MB7094E53F04B93E773752CB10809E9@CH2PR02MB7094.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KWlixl+sqNtKMPBNLi3PPAdl6jJWzUY6eKGf6jH4mHY6NAXuz9s7J2z1ADTTHlVVuSwJJG+uQpt7Wv/skkz2acp1yJxh7zkeZEK9iP7qjZnAFAeCrTI300KZ31re1dkda2uErYvjjnHPS4/aIBOQtfkoWMllYV3r8OI59a8lJxNMbVuOufVwj2I3RJFu0mYsDEcKfOOScNVeRb4GDxawkqsBsy/wkQ5gNhw6mL1MVVXNa7AbaUB5+R5mRWQh6fFOCZjxz/MAzm6gWaJhtc1cSlGigIAuYW9iuY0otgm2cpvuljJD3viJB897I8D81JMdVBLgfQ5V9hePkdxNIRX6WvnrYwcQwjaXAjhSLTze5vULMnbTN8ZkAmSq/keTtA/t06u2gb2lE8fKfddr7Yb3dOwVZGQYPA8OkHfWDUvNXkOx7oBCyh0vd4StHg31e5v+F4rC+xEGBBukQ2GuADpLy+EtQv+46bGlpPs0RAVmRQy1p1SNrad0cG5RnM54PpRD+PCsauLaMUo3e84hgtBElnzQ6NL4YawHBwQEW7aqjd85rm3z8So9sIl6oul7cWG+bfPOVmbyCmrcbKoKdBYNqpAkS6Ye7vHm5xY9cRkstwQ2JH3A99jAiRzUn5Y9xzLpmf3CyXARCY+3oX2DDl7ylxjGJ/k5BL55Oo64ycmglcrI/j6T8KyHSQmoTdpp/mUM08cFTseyv1CrQ4llwGYB9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(107886003)(186003)(38100700002)(508600001)(66556008)(4326008)(5660300002)(66946007)(8936002)(26005)(38350700002)(66476007)(316002)(86362001)(2616005)(4744005)(8676002)(956004)(52116002)(6486002)(2906002)(1076003)(44832011)(6666004)(7696005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PXvI053rtR4UPY+0l6+fXy1yTs0O96bqN9T8eU6hwgImZ8l+QUz0P8BF3+jq?=
 =?us-ascii?Q?bR3jyxB+zrRYuCZiIGszVBzsJ3LV2AeOp2YKf1ytW3h2V/W+FcsByjACD1dE?=
 =?us-ascii?Q?GYlAYm78M26CC/mWDjdBG9LNobhTVu6BgD10nfO3FeMfLsOHn9jmtogiEaHR?=
 =?us-ascii?Q?EHiGxvI+4na2Ymyo/jrbmbSyjH56wxCy3/+/qVvXKHnpqscGQD2LSFMp06Yj?=
 =?us-ascii?Q?PdjjMHA8q+XMipntlKHtdrfIRbsoiguaGvKbeDpsm/SJRKr2m8XkpPwR53Ab?=
 =?us-ascii?Q?AKCmXjfBB5P7PvLCxCKySmVH8xlNHC5c/szGAmDMx0FabAKSCVAJUoWskzuM?=
 =?us-ascii?Q?kOlC6jn0/x+BdLaysC543ufCbxVX4QoDBJsqOt6Pa0uamxLn1jCWjYRfpbdv?=
 =?us-ascii?Q?akVIg7K9JNC0yiPJKnm9URuirplFhcgXk6YaE5+sTrq4RoL2/u7ZI8Vns7Hn?=
 =?us-ascii?Q?1Ddu5MvtAmfLE2zrkEB1OSmZEgMNKV85AwmNZotCj1SexOgB6tpN090Jp/eb?=
 =?us-ascii?Q?GlV71YSwYQCIWgZ+Kb7F1Dwm1aDEPZKKESJHJkPH214brd/J6COYZpR0x/OV?=
 =?us-ascii?Q?n9NZtFWZ5zSXL7K2dgEkT2B0/r6lbddWHXf+L7LPejafbIxPv9C9rnL2mnKK?=
 =?us-ascii?Q?uGXqCUY0kyTgcyjuwXeO9ukQyYtbquugYlLrUNiaEC3sGs5WXr+Agw4SMyHV?=
 =?us-ascii?Q?kmzr3aSoo/P6xyobK8P7dvKU6TszmMos59wuavvbevi36+d6vpP95Foc9iWG?=
 =?us-ascii?Q?XaFSlejrGeUOJoMo0N4gjcXRhy3R+e2IWpd7UG8/gLnUGDUQRshawS5ocbl/?=
 =?us-ascii?Q?VOYL5C40fqJvgcr3PfDGkjTSzX3P9v3hwz+oMsUDoOLKYs/+dGjxZ6ggMxrh?=
 =?us-ascii?Q?gcarJO52v6bt67dtOgx+e350sG7OKhfFhd9VITJV9dQH92va5w98Iqw8+v2f?=
 =?us-ascii?Q?xCW6pef7vha39+Gcrrt0PcOKyzv5/VI6ZiLzj5zSRTCgvGW92EDJL6Lr+6cN?=
 =?us-ascii?Q?ggCLBkERRmRojPd4eNlxSRDdF6rZ0co+0Ws/oR7bjg56J4hzmU6CIjDeRs/R?=
 =?us-ascii?Q?Kz1yW26sc1NZbS7x6bqs6U/cwgu7BHrQUjENg7hUMon8v5BdrBOyTeogQHr0?=
 =?us-ascii?Q?ZpDcWQVzLd0MgdoXKPubvXTrQr//1byonUoM32CTh7CpvoRkLIchGsa4jas6?=
 =?us-ascii?Q?YKY5FwMeISu+MlGo1hAnsRfTn8+bo9SYvsdZktB7EZFKQQ1DlGB3ZwlK5fHh?=
 =?us-ascii?Q?gt1aIg2mAXTGYbEvTmdA6BfbgqQjQ4IiW9jEMn6bRgyTQkhqkjrvrbxG6mp9?=
 =?us-ascii?Q?IJ04SVh7GfGjROOBSsWzJdVLybhU1SWg93JBBtGTXIsGombPj1L4KRTCPQq4?=
 =?us-ascii?Q?LYswnlLGaDm5y58IskOB2YesYGXhHEBlm66+BQEa9vN1s9XixjpsJSso2T9o?=
 =?us-ascii?Q?fQtw0Esk5epC5BPwPY5b8y2nhfSY2IEx7JKm2PLQ9iFZ5KrEg/lCjIgkXPL+?=
 =?us-ascii?Q?cajhfRVoKlS3VXOcf3sHm40XlCknv22kSE7g/CFoMGRer4yiNfnyYtpxpuYC?=
 =?us-ascii?Q?Y2iZbCsD7919qBiBzGPNu7RqlYouFYC1S72NIpv8AclKcKfiNDWRKslB60go?=
 =?us-ascii?Q?I9dP+toqp2vcxwtxyEn4PTNHQFtG89oFfIj4mHJMGD/whxItOE+25z2xmymj?=
 =?us-ascii?Q?f6zu0k6J+nhtWY33xe7MBgL6acQ=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ede21af5-f99b-49d1-1135-08d9aca5ac7d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2021 04:16:21.5235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BIZDLJdbPritCqif/dmMZeP4Yf8pp3Kw+vF4uXWme2ggSOk4OXEVI73UDrPNLqGN2yFqUkt6ijTPF3JlEow5LeGIUCdgT7hQH/w96yXhXgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB7094
X-Proofpoint-ORIG-GUID: JuTU_yk60cCzqsmPeLwgh9t55Kfhmkf1
X-Proofpoint-GUID: JuTU_yk60cCzqsmPeLwgh9t55Kfhmkf1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-21_02,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Need to call rxrpc_put_peer() for bundle candidate before kfree() as it
holds a ref to rxrpc_peer.

Fixes: 245500d853e9 ("rxrpc: Rewrite the client connection manager")
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
---
 net/rxrpc/conn_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index dbea0bfee48e..46dcb33888ff 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -328,6 +328,7 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *c
 	return candidate;
 
 found_bundle_free:
+	rxrpc_put_peer(candidate->params.peer);
 	kfree(candidate);
 found_bundle:
 	rxrpc_get_bundle(bundle);
-- 
2.33.1

