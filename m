Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC8D3EBBF0
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 20:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhHMSUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 14:20:14 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36550 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhHMSUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 14:20:13 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DIGSuV030641;
        Fri, 13 Aug 2021 18:19:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=x7qMBqBarTFypK87086DVeY575ags2l5OdW8ifPAM9I=;
 b=VG8izLZ6qXabm6f3HEPU8HhNggYTW1YeHx5K9uE1a7hkPpqpsvs7h57+j+78VRNDT/N6
 eP2oKvNzMwv4UEwc6QnIH9pZCTYYOHLEHEqpikLc4yUV3pddz2k0msqyDKVpN9Z/9Rcx
 3wQLijtMIpiHfkHMYVr/BT5jp90XdAp8zzqDPvvJvoBUpjvgifG6cemruh2O1eWdD/Z5
 Fy0unFc3JtGIH+k9daajI9ss+RV1DnaDFTicS1hvUv1DMuUZ5GUxUoBAn5RzGgpP//Cm
 DfOLOPXF/gxz8/WVEILaSVkaV495crqKfX4xMqYg4snDbUtw4vpuLS4Cw3C0UpyGCBIT +A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=x7qMBqBarTFypK87086DVeY575ags2l5OdW8ifPAM9I=;
 b=zhdsT2rfrQa8ivTkrBU+vQAsnEFoE/Kayy1aLG8zCc5ARfB87KTPf/3J6RpRuV1LGzIJ
 6Ku3r4AI7GxkaQRzuykP/SN/eRsRAQT/5s7DyqTv8WefWaNsjICdgGBhcZNagvgPgwgF
 LlN6gcJYPerVVW+Xf8AarUV5ScEfq9jZj3umlAEq5v0Kp4f+Vd5CEoth1ivYFacucf7n
 tSDKPvA5s9Esj3yeVvV7Mbv1FBt0+8sm7hihtUTilxsWwwUyqQGYeJ5/l3GW/qvXeo1+
 rlQ77RR5F5c2nFnaQbUhVYjVo964+mHmnCeBJJBSZYRi/z101725YAp+YoFi1+1XbDAu eQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3adsja8ptu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 18:19:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17DIGJcf111604;
        Fri, 13 Aug 2021 18:19:42 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by userp3030.oracle.com with ESMTP id 3abjwb4cqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 18:19:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ml4NuGfIj1bpoBIqBdzvAxcrCDxxTFPor3NmMyrqb7bNCqirtCCCnV89RgmCwIwJcq4oR21zpRMPiAGZHKtEEoy9tE0MjJZLJemk5HGwCrdU3y2Hu7k5gUBJwht8PUmmgb2yTdJpxoSE4pIetQ0Vymj5Vn1HL4AyGTJmEnAvJMnSYbh2tXpFzGi09/5dzeZpsZnkk3toLE4b8uCq5v+Y+Xm9W0Q9wVkKmAC9SXDGeFskBWsEFjprSeGZL/WF9K55rP5SNopky9t9qA0gAWzlX5AwtU+MhG4PYZtK99w/bj6VDPOTm+wyCqfTJX2+h8O9sxvJ17y0KKnLEAHhUVC9Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7qMBqBarTFypK87086DVeY575ags2l5OdW8ifPAM9I=;
 b=PJqq0dLDdQaygK4TKTu7lq7Wpul03HSBCGrmQFLQsTo1DiooWmci5jZfj5+8raGAgQ/uzchKIBpp10rKW2uKFh8neeZ66XEh6fQqznkoKA3LpiDBTToO4bzCNqyfNWrYBuNVeCga4+XoxO/PSU6O/4zh1Bot6UITvSQFQlRqv0APineu9CJnXlF36wy6jBgyj4hWzfzArF7QLiTXYEThPjKD9WoZOIPkZK+liFzbttpiIQkIV2CRXJZvrOF2MK0bKmJKciDc9oveWdNa/qSdAhvq2A7gvwdKltZyAawbsVlYlL0uA7nIgrIZNioD54LHivZbED4+XXv/gELAZMz6gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7qMBqBarTFypK87086DVeY575ags2l5OdW8ifPAM9I=;
 b=tRHkzuNdZeV8hLdhSQXwIcu5INoQERJez+wCtgw7+eVuSIFHwBmcS46gzTW//6z9uSMppFlVcqSQjcEoan30+OPGTr+MT3LWWIFxcReqGhn7SL01VGr95k5XTYd2HbgeLhMac2fHrNHZA/7WgE69G2VbqbeJU3R+klxAnPSEkYU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB4687.namprd10.prod.outlook.com (2603:10b6:a03:2d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Fri, 13 Aug
 2021 18:19:40 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%4]) with mapi id 15.20.4415.020; Fri, 13 Aug 2021
 18:19:40 +0000
From:   Rao Shoaib <Rao.Shoaib@oracle.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, rao.shoaib@oracle.com,
        viro@zeniv.linux.org.uk, edumazet@google.com
Subject: [PATCH] af_unix: check socket state when queuing OOB
Date:   Fri, 13 Aug 2021 11:19:34 -0700
Message-Id: <20210813181934.647992-1-Rao.Shoaib@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0376.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::21) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from shoaib-laptop.us.oracle.com (2606:b400:8301:1010::16aa) by SJ0PR03CA0376.namprd03.prod.outlook.com (2603:10b6:a03:3a1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Fri, 13 Aug 2021 18:19:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e400b16-9867-43d1-ca4f-08d95e86ea50
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4687:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB468793F93C73B28AF8A3A625EFFA9@SJ0PR10MB4687.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HeRnX/cbb58LipmQ2N9ZcOs2c4EQYs17n1iGBt7kM4fIlcMYus4FgR/I4hUlAQR3hwhlU6txdN8XFrddcDy8+kK+KrMYAgYQ6yGcuqT3AEc/wFUdqCKOCDcACMfs9ppcmWJHR9AxxrL4xrjFocWnmvn5fkFzYyv3Ah/V5o8/SfNZWKK37CRD0uKk/XATWmOrDf2hEqzk65zhbLGORXuNi6RzUW3QwWDjtfuuDZe5nc1qIs1w3qjkI+uML0jtqV4mUvSPzQpNTeuHVg4Pz3d1mhF4zsVEoUkeRyo5qbeLHlgSR6/jvybSszR7oTFT58gsEuZW9nPnK+pwGJcsa9a1ZWf7kDYCpd5yl3OfZFmnc3TJTSv1WxVgjlKmBL9SmOjaF94xjXu7sBbALniekv+gAagbc+fQMORXvQSIbz2bV67s9s73BNmHE+aMYvqu3m+OfkVXT7gIEbNLUNDmm4aFxzI+vSEZ2DO0bStkiCorL+j711TGv9yvstf4y+9plEfTIC/REXdIJ1ycqH3OCh1DBtCATInTIqrNXRppoTmSiYarC+B7qXUMd/HzK2OR2x0a1sP+s6tC+Mhh1ylfr7zkVY/+ijjT0SO4xIyLfIYsynAZUYONxs5AX2NI7yBgKebQqSCvRlRjO4BuuUtk9IjTxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(396003)(376002)(366004)(86362001)(478600001)(6486002)(316002)(8676002)(186003)(1076003)(52116002)(36756003)(5660300002)(66556008)(66476007)(6666004)(38100700002)(83380400001)(2616005)(2906002)(7696005)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mBLfehlaVTwneyW86qDKuP+rpDEP3UVPiq9X/6bsU+StLziJCVhzU6D4oAvv?=
 =?us-ascii?Q?a3XJ3OQuHLpJCylCcEtXIIP9YrgXxiglF06/zwUP8m9Cl8ZMKYMCy0OfIbn1?=
 =?us-ascii?Q?q2rqvhyM74zUqPWfve9MTEuq0xdhmW4ets6buPzb14IFTjlVaTBhnVlaT7RB?=
 =?us-ascii?Q?D6QRyEHuVE1+jUUZff4NDYKXhPjSCtNg6wbEWo+LVj1jXTPjJOEi27ze3x16?=
 =?us-ascii?Q?CzoUywez06lu61R842JgUaLCXjO8VRhb+Vc5nrTes5jxnUtQt2BmtahQqRaH?=
 =?us-ascii?Q?AnGNUDfW5H2wlbgYThc30qcePhngVr2TaxcIdlFydw7qWl+9p9AxbbaVpZcM?=
 =?us-ascii?Q?/9geLgw/V/WUrFlhsC1yNG5Z9xiRvPzbfRvImRRfYmrn4uh3lDtSvuhFL/SV?=
 =?us-ascii?Q?3nIAtqo62ShEgpVzt41Q1aE8EIrL+0en1Rd/amCHyyebgOSldzyu0qiZ5d52?=
 =?us-ascii?Q?DiHXgFLNaixX/72LW0/pAUTZefHdbgWktyWhgkcA2K+nlxamtK9cmc8uXL20?=
 =?us-ascii?Q?kWZsop56XphoqhYWG9Jk+rBDNyPMNtNMYnsCqUUm4Gi6n8i3xFUWpoc7QHnY?=
 =?us-ascii?Q?DwiR9p0diKuUt+G8d7f/yJDlxWTOW9f9duwm5CEE8uTUCK5I5166r2cAH39r?=
 =?us-ascii?Q?l6oAKryYQ9Ojth4zerH7T5BXW/qpYnHoyqTHu8WmYisE4zuZHT31FiqfGhQS?=
 =?us-ascii?Q?Qlc1iXjp3Pe68Z0f9CswJAVRUm7+jEAQ4kHywD0hD4DPh9irZq0WyPHHneiK?=
 =?us-ascii?Q?tdaHmeVYBN3Au4FJ1mApc8XcsucMh6QdWFQ18uTcxxL4Zd6Z4R84udvOMmLZ?=
 =?us-ascii?Q?zMJAJyOerAQ4r4DwDA+LQ64PpszWYoaBQcV+ZKj/qVv67gxQObYX4qfRlQ2k?=
 =?us-ascii?Q?iSadYGY6Kc+XYMz8M6vw0fBBaRFykceSZlu+OiMYei/dVcjQtv1cxHWmx9XI?=
 =?us-ascii?Q?a/1962paj50pWJGlaa8VSt81kROYVqMkxMrHvQj8JUf77nZcGxm9zC7Lk3Ij?=
 =?us-ascii?Q?H+0fXZLkGGxNNAvi09fglLajh2apwKCl3m/+xexSdpP6Sdc/8s2AYOaXBqM/?=
 =?us-ascii?Q?V80jH/R1nd3UdCUYSrif7lkjs9ZgZG/ZfY9ZXwFwSZiSFrHyf+38h4am3rvG?=
 =?us-ascii?Q?5XD9diqIf12Y3XTqRBdlaTzdpZweJw/tZUxyw4Y5CRuUKNP8kLQJStI8pah8?=
 =?us-ascii?Q?vLRDq7QFfG1RfBZ0twmDObnhZxl0Ca373RIhWAXIQd55odgSKDvOQdU1K5CX?=
 =?us-ascii?Q?mxP1Xhb55fe6tvrYg7O8hiHK3Z/Vic+PjEAjHl+Jx4gTEG6Inwts/J1Bu1r7?=
 =?us-ascii?Q?xfYpg454gasi0wnJnTNJa698vGb5FynncMuUHA7u7Gx7RQx07rCAvIe/zse3?=
 =?us-ascii?Q?NPsPaeA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e400b16-9867-43d1-ca4f-08d95e86ea50
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 18:19:40.1299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wvst1NKbKWMRDKlfrQkYi5ZltSAm+TTifDm6PGA9gTOnfhYqs8Fxhw5g3Wu2w5a7/SOyQlPSDINECPFBDKFfBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4687
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10075 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130108
X-Proofpoint-GUID: qxcjuN00PeVFXOKFecfPGxbLjjKccEGt
X-Proofpoint-ORIG-GUID: qxcjuN00PeVFXOKFecfPGxbLjjKccEGt
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

edumazet@google.com pointed out that queue_oob
does not check socket state after acquiring
the lock. He also pointed to an incorrect usage
of kfree_skb and an unnecessary setting of skb
length. This patch addresses those issue.

Signed-off-by: Rao Shoaib <Rao.Shoaib@oracle.com>
---
 net/unix/af_unix.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index a626e52c629a..0f59fed993d8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1891,7 +1891,6 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 		return err;
 
 	skb_put(skb, 1);
-	skb->len = 1;
 	err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, 1);
 
 	if (err) {
@@ -1900,11 +1899,19 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 	}
 
 	unix_state_lock(other);
+
+	if (sock_flag(other, SOCK_DEAD) ||
+	    (other->sk_shutdown & RCV_SHUTDOWN)) {
+		unix_state_unlock(other);
+		kfree_skb(skb);
+		return -EPIPE;
+	}
+
 	maybe_add_creds(skb, sock, other);
 	skb_get(skb);
 
 	if (ousk->oob_skb)
-		kfree_skb(ousk->oob_skb);
+		consume_skb(ousk->oob_skb);
 
 	ousk->oob_skb = skb;
 
-- 
2.27.0

