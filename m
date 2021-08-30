Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86D83FB297
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 10:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbhH3Iio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 04:38:44 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18914 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233318AbhH3Iif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 04:38:35 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17U6whMP020589;
        Mon, 30 Aug 2021 08:37:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=AYMUViLKibZwfDXkhtzbOoW9exaxIuLM2HbCYVj5Cgk=;
 b=T3iYPkz/QAshS99TO4k/+bbkQZQXqaKW3Ndz+AAR/Bt7I2wTcvwAPM/cVbZ22Cruqyf8
 F1DBcgoTdeT+AZeP1HzadqKC4ZWXWScbZLCoSXeG0XCz0uRUAn+F+hn/OZbAWtt0izl0
 VvECPiJm5g11PHJjZnw+vjK8gMyl7fUIUjMJEAgJqBc5+9EbeIeXcBMvBpB8peRBVDKN
 3hk5ye7In4oji1fT32JtyONjyyWC2UvHGsAGDQekzRYa/lAx/tG9GVR39ppyXWQFC2YI
 Q8xbrXSCs6Aix/gOmRTmWdtdJRzYC3Sz6nNTzmn5KOhly92P529aoeTROR/owexh5zRa ng== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2020-01-29; bh=AYMUViLKibZwfDXkhtzbOoW9exaxIuLM2HbCYVj5Cgk=;
 b=FCuqUWpWnv2qTQjNdKpqwBLXWgjhfJKeBVZ5JKdbNok3Fz6w9+XL3CgXPHBhVzpqx4n0
 E65FBNKEzHx8So/5O2TJrgiJ5d9uRc1gPUlaogqM5vuyZ6m7d2930XqA5Xd7MAqyPGvc
 0B0o+I2WB6ZflxVo9GyKmdsV/RBAEmZUsTg1+WiWo6FZYNrtpwoPKYtahQbcY93QP1xl
 Z5INGLoiyh+gAV6z0TpE9CBgy4+CaA3bHW7n1PdJ2KfSe78vGUXGRWNYpLaFZDPCk4rq
 WFdYDkQOxT6oYaFQmt4nCoit2KLNDG3irpJpRzldNH3PLi/MrFDCxUZe3LF4MIbQtmRH Lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3arbxwgy17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Aug 2021 08:37:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17U8Tghs153730;
        Mon, 30 Aug 2021 08:37:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3030.oracle.com with ESMTP id 3aqb6bjvb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Aug 2021 08:37:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/NZl6P/Avv/aPFqpOArzEb1K7r2HK+JBjGSIrwDkQOD2zV5ObuNQNSq9uA/zVImpaRBCzMNtVBblut29eqyrPxQJZ9R+eytPF0X6N4sWhWS52jUUTsPfcw0Jd1DVdygZM01ViwH/Dt8sKgwbyqo06xXTC/7lM4xFC77tI/igqkhCgSPVeZH+OIPzEPgQB+qGuBy7v0XqQ0qYKWZ9qufCanZXVjPf3kYt+IctJfbEuIi7UyV/DiGBrxBMw5Zp/mKJVqNt51M4VXi+m6vSDTcAAQY2MOY/CanSsj+Ceo9JmPIKYLkjYGiYtQUS3doEEQKuH0OQi3rOsTLR0hVcK/JEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYMUViLKibZwfDXkhtzbOoW9exaxIuLM2HbCYVj5Cgk=;
 b=dzCRh74O+V6qzBD2YOhUi+ChQxojDivGHHmaNsoUkCcdMYZgczJELq+IDM6LJo4hSQd2f/FHd5waNjT6DhTDPUw8TYWq8BxrTOGzW8Etvklw+9QT4tyHEy2PM5oeb68jXvf84ziaWzOGobKSrnBlGtKjsxUEmRsObhsagLLkTIakV4qYNJFWeY4NuqA3oAeYCwRkyWcvON6ZgE5n8g8Q7Tm0fVMKLYcus31yNhsJvpaFB1IVwRxreLI6P++VorJ/9mopZ7B615ucWqfovDFDPz2tF/wjjWW2xEyon6ShTRx0Dna/9Cw831UMDlygYYN3wMar5uLfrBGFopEXH9iEBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYMUViLKibZwfDXkhtzbOoW9exaxIuLM2HbCYVj5Cgk=;
 b=tqIMNJyhH16Fck4R5gcAvC5gu4sd7dRFKxDmYRYjqimLrzkYHhssDmC9jdBsd3nAA1Y2RjcCkJGB6qaNkRr8ojPGcTNGA49xm/rAVlGijTL4neJpCwEz+2VkQe/lUKlKw+nQ5hMcKGcUjkJrXMJRgBk/id0itJVNEpLZxVC5UAk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1776.namprd10.prod.outlook.com
 (2603:10b6:301:4::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Mon, 30 Aug
 2021 08:37:35 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 08:37:34 +0000
Date:   Mon, 30 Aug 2021 11:37:17 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Manivannan Sadhasivam <mani@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Xiaolong Huang <butterflyhuangxx@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 net] net: qrtr: make checks in qrtr_endpoint_post()
 stricter
Message-ID: <20210830083717.GU7722@kadam>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFcO6XMo2rFJqb1zZyPgEDtChLHNq26WfhAd5WC+9NMnRNM8uw@mail.gmail.com>
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0029.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::17)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (62.8.83.99) by JNXP275CA0029.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend Transport; Mon, 30 Aug 2021 08:37:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4850b538-66a7-4667-b5b3-08d96b916a20
X-MS-TrafficTypeDiagnostic: MWHPR10MB1776:
X-Microsoft-Antispam-PRVS: <MWHPR10MB177612A6A051806F2EE22E788ECB9@MWHPR10MB1776.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WJSuIy33iCp6dcXHyFAESYApvfEUoiv3frrvjDtqkLoaUOb+/As53j1jByyxbwuNEnxYAWbI8y3FFZJuPPrroLQDHOcORIQSY9yHStaJc2HY3dL2RVd4252w2EhQ4xYgm5wx77HMmLJHa+n5krNaP9MxUUphEpze4nGYldi6x9bCh5lSNB3Ui3URBheEufBknSfM9V+D0OV3et5vtr3W/yrTOlEfgr3ZeYqXmsXzyQtIOvdJziSrtfTjTl6X64//ZZGe1N67JGngieCmQSNtUOxudUpyqpJVi67YVRM0SxheoyDh3zrVlA8PbofKlaxx3y3NuaTT17FNTFx2dZG9LVLuPq3UgIdqjzaU5v0asOH8d2IYpoM0QbU7rcZws04bqFKLXv5RKb1tlUmrvgaprQoR8x+WURh0B7aYhglsdeWx3VEihSX2Gzy30SWuxDtGBA9GH/57UKZbtLNHs7kxOw4JEMqJKiRBT724PnMEbG5WD5QXN1x9+Gjm/a3G2Jt1tKm3Qp+U9ustwWYY9Csv9eYNlwFS6/lATZpaNIzN45O5X1A9h4NOq770XiAES6PUWnpknwlIbufOSKNVmYo5lC1lQrpyS4M5S3UbtcDyPsPX7Zl1SPuhMXWZjeGKS3yJyEEC+2BMZeSEi/xBBtxwuyyVv2hhb7TAM0fHeKdfRuflFroI3oYIMNMQHrw+iFRnT6tBwyDWXviNErXiN1z04Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33716001)(9686003)(8676002)(508600001)(83380400001)(44832011)(26005)(55016002)(6666004)(316002)(2906002)(186003)(110136005)(5660300002)(38100700002)(52116002)(4326008)(54906003)(1076003)(86362001)(66556008)(9576002)(66946007)(38350700002)(8936002)(33656002)(6496006)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1NmvGdTwDnvXB2z9jrS13jrQzNfMzGJneV4ko7/30VHG9htJT4Tk6Dl20eS8?=
 =?us-ascii?Q?xU1YifsbPiEMdcIKzD+uqjQkYd8qG7m4CKRFpAhXTr112c4lWxqcBMXE5Xdh?=
 =?us-ascii?Q?f9+HK8OxElL+m9goIUejJLZhBw0dyCcVMGRYORk+HdvmWu7x5DEXjwdj4VlP?=
 =?us-ascii?Q?LCsDPrOfRPdJlmCChYQ018uKbJPAych2ioQEe6Q23qvLxdrQRMEyxT82deNv?=
 =?us-ascii?Q?OgRQKYTWElw/MBlV+I+UXc4GLIoAU3wUPKubBbKlYPQZigJKf1fjSClgj1Xa?=
 =?us-ascii?Q?9nxgolhO8ZZRB5BCOMQYC5RLOdK3ycUJdolA36UThxb0W1GN9mN5gId77ero?=
 =?us-ascii?Q?iLgH2GZeTcmBpskymhYU051ua9Mdxmi3JerrDpq3TvOE1Zv+i2reVXjM5NUf?=
 =?us-ascii?Q?QpxzfJ9PmcZgiFhrIhblD26pigYI5ktZCHJEZGnc8HnYeShCZuqjtWccWmc+?=
 =?us-ascii?Q?WodpAfnAVJl2BCM6MSt8gbrTTzrvos9kGVWmcedE493wTWxn0KtynUn7ICG7?=
 =?us-ascii?Q?A/y/d2+nXzTqgVr17hebtEV1xmg1qCgb9eUTY2PDCFnQsFZnVFU5uDgd1ZWs?=
 =?us-ascii?Q?FC/y/AEOhNqcJRdHUmKrF4JyEA1nWABl0qWr7uc0qvPtx5bN4oVSruyPSicT?=
 =?us-ascii?Q?W5sSIX9XR3S7SOt2WoseABzJlZK0HS2KUzofahFx3cOTD2YQNus+edtIEQWw?=
 =?us-ascii?Q?rbJXsJvCHPLbQMw7y+kwNsQnpZnYEE7/nzzdBDhf/YlYPowl/RzzuvvusjbD?=
 =?us-ascii?Q?+0aPLDsD4RWx8qrEXgT/xta2oMq6ceFC2G+AgbNi7dvOmxqHIJebDU4JYAch?=
 =?us-ascii?Q?yzzygSJ0jNwkaCR6tJ4PzjpnkSlbS420glOgDaTdcwKEAk2Qkp7+VyYN516K?=
 =?us-ascii?Q?6ZzC3Jdo/baYhVATLJLNThRZwnDW0QVoX88+jdhuQn2eA3054wz8VtiUauGG?=
 =?us-ascii?Q?37S95uR53Psnrfx5vhB/Reouz19xU9tn79lvOO8x9hpgkKqFDJtyzjptOl/B?=
 =?us-ascii?Q?qGpTmffiLHCuu0dodwk61nFXYktRlb7Td/OaT9SWhOTCy/1MeJGOG10jDDHH?=
 =?us-ascii?Q?1KUEf6poWFE9WUVbsCWqalswmgeGnq7utf+SOsIQC9dpbBauSGsrMfSmZIcx?=
 =?us-ascii?Q?CpGSCS88yPwQ0vri2Yt48Eohop4GWv4iRYdeObJbYsn+9FGlhRg6WEi3D5FJ?=
 =?us-ascii?Q?mm7u/A0lZIooiVAUnFYSFU+BGqQi1pepobTdchrr4OARMRkFu6+yEPAZfI8f?=
 =?us-ascii?Q?X5IbVwArMKMCRXjbD84+wGYuBimzUZGMD2AEAIjmQTZuvok2xjVb/rgyXjX3?=
 =?us-ascii?Q?HMwlc+hSJnB+HGafqR+lvFiE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4850b538-66a7-4667-b5b3-08d96b916a20
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 08:37:34.9205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PpAzdip2NfjWscHechQK61/7VaXzqDOxFF9NkEabf53caGYGjxrtRd8/Kg9InxOEs14v6KDFg4vS46k3733omgbHcEixy/XrM8jCxuy+0wg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1776
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10091 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108300063
X-Proofpoint-ORIG-GUID: iewNlhx1JRvsSTe2zqYGeczJlhGTf_f4
X-Proofpoint-GUID: iewNlhx1JRvsSTe2zqYGeczJlhGTf_f4
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
v2: Fix a % vs & bug.  Thanks, butt3rflyh4ck!

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
+	if (!size || size & 3 || len != size + hdrlen)
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
