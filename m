Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFBF3F9A0E
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 15:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245263AbhH0NZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 09:25:43 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50968 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245285AbhH0NZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 09:25:39 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17RA9fsc025577;
        Fri, 27 Aug 2021 13:24:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=VUoCVmcTtVBuG/NtFy8NfN54CEFBPcn+o9dRM8mY81o=;
 b=cxd6pN5bj6RkMYRSKIX2rwDscs7kbl7bZUlSE8H4PS1seZiStCX5YD//NZWvKrxrkASK
 if7LDMKdT5iRxvtaP/BeRfp+n+N3tzgcmqf6Vy7RJFdetoxo5PD8QzlgFI5lWDvXGyUQ
 LK1Yh3oHBUm5YX5kURI9zmeWVsJwDtK+zVWb1X8bcqwK1kiS4V68v5gMUa09EMjxKT5X
 oPkz/PCUSC90YKTCcpMDWpt0OpAXnwX2sqUnwb1ECbahlqXbcIbaFa5YmQqJiSs8or4I
 GWag5/rMaG5bL3XeFm2Ctma84fP+yTNZHH3F5QRtMBwhvfqwI5Iji68d/vFfs4YjIzrW kA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=VUoCVmcTtVBuG/NtFy8NfN54CEFBPcn+o9dRM8mY81o=;
 b=HDqGA57CeZj4a+wwpEbb4rPkZTZNJ1NcDIufclyUDefhGMRdz0us7DFm4HlQ0LG4D6AC
 266JKPu+UV3CM8mb1pU+Xuw4zhFATdPR5++jSngR0IHXOU0KZGazduKvTlW7GXVOx4iT
 OB+cXWy7fenDXximADNbgY4zkUslu49fraT7S83FsHVRuEPw34ZLXYjGrq1DWn+t3H5g
 UF+b5t25DJn54k8oL0GAlUv+lGWdgyRsE3R3mLwNoy37HLUXVr/1G6bNjJNNa/VNIaTt
 tIyjjQuwKkcsUe5HXIqt4jVlFvoaayMmW6SM96n41zRN0UBUNqTI//EG3VDBnaZRMKVB zQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ap3eauqxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 13:24:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17RD9oBb076997;
        Fri, 27 Aug 2021 13:24:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by userp3030.oracle.com with ESMTP id 3ajpm4pucv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 13:24:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNJwri2hWlqqgcKSbPN3Paazj7uc0S/lVD+nRWXFgqNX3b1q49eBY+SnAVwyrmOx/Zdkm+E5jQZiz3Kt0Z0dy4wDJnBZ0Kw110N6s+GlE3bmj/5biG3Dxzqqb+Wxs9Iw9kSI7xj4NVBjVJxKGIAk1OsTQtvr/yZevAWMtWjHWNRCoK4qKzozuiKbmrm+D6MJG9uDPw1rKX/l0s6pwFQfEDkZSXvO7Id0pwqHjjWOhfhjy7wcwHj4YUyJMFAb/cCHJL9ROYzyLH2zeUqycDCrhSq/eQfcIV883oyWaBr8LeZG4KOoR7UNZqN9XDjpS4V5Dyqw20GT/PgA/Pu+MpX93A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUoCVmcTtVBuG/NtFy8NfN54CEFBPcn+o9dRM8mY81o=;
 b=haqQxODMV33MD4wtlbonjRURuvr+M9Kvdri5LCyQgZj24cnreN86wyp+1gSIrZ78sJnuLT/zK5FSChD23id0hvwWJ5l4Bze0O9C4BbT4VZaCdBZ97lyX6I0HVSZi/faOnx4SCOsM82fS7l1GcF6M2O/KvpzEVIkne4Qxm4GOUKSGduIonyADKVEs631MwuauaaDzOzMgBpDaBgBr6QHwaYI346FEn7fBoZ1DRF4hvEBJ2wM4oDEmo1j3KE5H7trVC2H/U4DE6+UcgRzu8GzD95hraT5Fi+gE9Lu+5iOt5pq4Ce7o17C7n/1+82pTX0qopbSiluAlu0ouM1yv68eTwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUoCVmcTtVBuG/NtFy8NfN54CEFBPcn+o9dRM8mY81o=;
 b=y4safj4NZa0t+aSt6fkYiE55x3giHX1SmZXIk+tiO8RqmWr4OJe9rIGSyLk6I9on+Nuo0QfeskXN2g2HuhQWZSdbTU4XAARQHrfsDBwg0axiqcxgbAK6SXIstMBrPSlrDDWPDuVzl5Znx8B5DWSUmmFQmRClpKhsRqSI+RGkuS0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5476.namprd10.prod.outlook.com
 (2603:10b6:5:35b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.21; Fri, 27 Aug
 2021 13:24:41 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4457.019; Fri, 27 Aug 2021
 13:24:41 +0000
Date:   Fri, 27 Aug 2021 16:24:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Manivannan Sadhasivam <mani@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Xiaolong Huang <butterflyhuangxx@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net: qrtr: make checks in qrtr_endpoint_post()
 stricter
Message-ID: <20210827132428.GA8934@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0103.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::18) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (62.8.83.99) by ZR0P278CA0103.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Fri, 27 Aug 2021 13:24:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5b84ae1-ebd6-4df3-45d8-08d9695e06b6
X-MS-TrafficTypeDiagnostic: CO6PR10MB5476:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB54768D478F2DE3C82C30F97E8EC89@CO6PR10MB5476.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wfk5sddx9xlMKaqJh1GhiUZS4seex/k73hTI0pKcLKn0ZODNhIFnThvK7elFUoUoMS+JE6HlGZgA00ZYeB6SQuCF/AqNiaV+Pfg5i7jc3G/Qa/YSlk34HEyMTBFgajRKx4uNPKPpJqKNjXW/xlKtvB2n33pPc4q+UoqQj8RPYZgklNkkys+iTCwndtmpMVvGXE50OYn9p41sBaRKgHvkF/uOSjQa0LuYSJCSn+k75pX+eek2EbF+AkKY73cQ4HZ7Y3R3A1wXx6trbvo1XTTg8YadrBa7d5uPosHITauf+36rPHwnGLUYbfcyd9jD5w+Nr8zY/v4+LkBbZ40W/CnNq2lTB9of2jQUeSpF5a5grdgRpnB6xLbMcKvFk7QC1SoeuXk3pHlN1MvfLgYm4tkGxjxG5sZc33J8pkRIQikR30+XWsVa6UrrIF1OaRIN2D8hV7AFH2Oct7S5DW74Uq5lmSgRoKOYXBzFXSnKjlxdfYvRNpcUanv5kW1uDnnmGKJXcfj9jRHFpnnhTtKdr3HDZtoSm4WJFCBm6jacjlc4jQYcnZTt0e3zt+5mTqlxGdnrrUCRX61zTPa8LcvFVNx4rKm+YQkAkyxISC04nMNAJgk7jwmDm2YEQ89znMcg35HXhm1eeUUK+YW3q2gfVb19/toxjPTRd/Lnan/oNvAjHVj9rGqKycbxRs4IZdTmS5wjFG9BHI8vA2KP9ifSzex5nA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(39860400002)(396003)(956004)(66476007)(66556008)(9576002)(478600001)(44832011)(66946007)(6666004)(8676002)(86362001)(110136005)(2906002)(54906003)(316002)(8936002)(55016002)(9686003)(33716001)(186003)(6496006)(52116002)(1076003)(83380400001)(5660300002)(4326008)(33656002)(38100700002)(26005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bAjkRtI6W+Tp90DkwR3t39CP7VhTIQHGnGa55Jjr13Nii9MsN0yaTYjnxrqb?=
 =?us-ascii?Q?LaQm+wVPN4iw5377k+riEdcG7GPSV9tgixQxCTDKOCMNLgCZkgSxxLjN6yKc?=
 =?us-ascii?Q?TNwSKkWXMcxenDsj7ZlWt9VTXdrnspHfvGk28KMdLX+d3C/T/YSvzGRrmZyT?=
 =?us-ascii?Q?d5kcUjJhQG7QiMfwG2b6udHOwClz4rxKWA2OQNb1CQu2JUpZolT9wffCBbv6?=
 =?us-ascii?Q?PaesV7CZlcydxxX1ekStIEErDHkREn6OiLqPLBF1/+w1ycZapbQZthdyNyRG?=
 =?us-ascii?Q?w/lWSJVSCuytNH2Q2LuhZ3Iy4WTIi0qQVJeNq5mnnouwOhDepyJd71WwzI9Q?=
 =?us-ascii?Q?HVr8MuDNoQJ1H2bS1qysmQ9vKyVglxhAqgnUFqa4CB/jqaLn14ZADj2+Nv4w?=
 =?us-ascii?Q?fLKH80g867SEcTwNsI39+rCGZ4t0L5iQCAeVggiK/iz+CMlLIgRJcO08iBtx?=
 =?us-ascii?Q?r51URzr5KMeM6ROvV0o5K6Mes03+Vp/LgC02gh9cJX2QG5cLJp7Kogr5BrRQ?=
 =?us-ascii?Q?C1gzYjK7E3Zm1CFmNLvZ07wgKnkw2ujsZiPlhkod6ISwEf25QTeaEoq7sGoG?=
 =?us-ascii?Q?dFInxJpppTRVoAVYgbeP3ozDFii6OOJgJhc+Z2I6yYXaJQXPsYNphwzME7H6?=
 =?us-ascii?Q?t3GHt1tDN+cbY3qR9U4KW/R1T7q8WnXFF7C7FZUpfv80KgTCRPdBz/EkYy4U?=
 =?us-ascii?Q?B9G7kxYswHQiNUa91HCl2I4ErW3/l1hwuXBQh40ENZhWcIGnjkTAl5F2gJTg?=
 =?us-ascii?Q?JI4f3IDOtPJ/arFZ1rMmQDqfEXQ2Bp9C3Jn1p/sHvNgIgWdIH5Vtlz7CJmnG?=
 =?us-ascii?Q?fs9/U6OPO1mEe40ArJvA/6Dr+k19pUBVv/4hdIM/MLYWUxpxbZCMMPhyAY0M?=
 =?us-ascii?Q?BVDzicYfvIA2FKqeHDqt6Auy+Pjwhvj2DofbxxcLM6IVeeoAcD4pb+xc4Wtl?=
 =?us-ascii?Q?cVxyYnuB/COihnDoy89NCIS1GvWgUafA2+Wu8biDheR8Uw3B9WVv+pF8zORr?=
 =?us-ascii?Q?e9i+hBsqWcnP4t39RcWMiWwY9si1rMeZZMvZGQRnND/zELLd8W9TMwB2dx3q?=
 =?us-ascii?Q?MA6xeQYb8U9lpJRBPwJAd/+vf8QXTssqz+Z/wOyfCjMSkOQsWQyGGuvsXnct?=
 =?us-ascii?Q?iWpnNYjEFfDPF0S5oqMb5tnf5eyfxJrmuTbO0NgWb2goJECCZ3quSO0ZQWaH?=
 =?us-ascii?Q?oZOJ5YODHDVeRUq2GoAg+VhIQ+926QjqNwJ9apyf6lz9aH6iUggv65/QftYl?=
 =?us-ascii?Q?0DJuXE3gqK5aktbxoq3TzuDB5XvRGRwSXO1OtOn7t8cPvkgaYdHKmCoHk9Sl?=
 =?us-ascii?Q?0KIkNYHwMg8p47651RHdrhIY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b84ae1-ebd6-4df3-45d8-08d9695e06b6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 13:24:41.3325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RWMFIIXTu7qawX8tpuWsgoZFdzRMWZHIwM6XkKS2O9ZyTPGEg8GfKyAEENpGzfEKxd9qdgo/YpsrLUSv/IjPzipjk3ZBlxrilYocL/x/v5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5476
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10088 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270086
X-Proofpoint-ORIG-GUID: ClF2jluAY0VJreYuAY3LsjZLejTiVRcq
X-Proofpoint-GUID: ClF2jluAY0VJreYuAY3LsjZLejTiVRcq
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These checks are still not strict enough.  The main problem is that if
"cb->type == QRTR_TYPE_NEW_SERVER" is true then "len - hdrlen" is
guaranteed to be 4 but we need to be at least 16 bytes.  In fact, we
can reject everything smaller than sizeof(*pkt) which is 20 bytes.

Also I don't like the ALIGN(size, 4).  It's better to just insist that
data is needs to be aligned at the start.

Fixes: 0baa99ee353c ("net: qrtr: Allow non-immediate node routing")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This was from review.  Not tested.

 net/qrtr/qrtr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index b8508e35d20e..dbb647f5481b 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 		goto err;
 	}
 
-	if (!size || len != ALIGN(size, 4) + hdrlen)
+	if (!size || size % 3 || len != size + hdrlen)
 		goto err;
 
 	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
@@ -506,8 +506,12 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 
 	if (cb->type == QRTR_TYPE_NEW_SERVER) {
 		/* Remote node endpoint can bridge other distant nodes */
-		const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
+		const struct qrtr_ctrl_pkt *pkt;
 
+		if (size < sizeof(*pkt))
+			goto err;
+
+		pkt = data + hdrlen;
 		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
 	}
 
-- 
2.20.1

