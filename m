Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA42045C802
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 15:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354321AbhKXOye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 09:54:34 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:63950 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353708AbhKXOy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 09:54:27 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AOEKVcn031449;
        Wed, 24 Nov 2021 14:50:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=5Vrsdz4b5yMJv4rTN0+EZShnOEqM6/MPKnESRlJDFY4=;
 b=QX5Hcf69HoxYOIBnFwKB08IG4bJB9l/eTaqL22sZ91nj2BpFmrTIBw17y1vexNKE3mgk
 0H6waIl8nGRGZ8P6/+bNABlMjyeFkDczRNVmdUleH99V2hcEZJVzdIgyIIzsLWPdwJP3
 RTLdn6/8+NWSQG1d48wwBgYWx9Ir7Ewis19ScwDAWzTMn2sfOn18EwDxbOJhgIt3LbhL
 +vHN1pcQschttRslj5X7QD2g9aqmR6AqnEghfNzNkTcrpdrk9I/Q0mpeR+WB2b31szmt
 Oq14b8IphE/70XzDYIUHv6RNkK32mHGQ1NHRc6ORzbHSRz7g8OkjLxN4LJarh/AmIYkg 3Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3chmfn149c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 14:50:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AOEoo6I192001;
        Wed, 24 Nov 2021 14:50:56 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2170.outbound.protection.outlook.com [104.47.73.170])
        by userp3030.oracle.com with ESMTP id 3cep51qx9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 14:50:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVqCuVAxooPM3NLmv3Pwz7+fWt5DwrBSwa+UkPPP5uiqh6auHZNnpT/Qh5VNmgHLp6i7D3zF7bpQJ9v69CeabwiWDSPcmhvaUvgarC9oSjNIxKmHH8+y4KDxg0x4hmE0ZyCdn/UgAMipok8AVxcSWHqw5zibu89SMntl9irL4kKxdi8zY9NSVdqctIDjsXSobltyIyL/urqrK/FF66GqAaFaM+GWRXXvvaDKirpecIpzGbE+gonzgEZhL5o5eL4iIzen1i9uEFZ16Xj87e7rHrcAiwvcRstONARLqk+Je5RRQsveG+U3iQFxSRfwdlzI8O9ro6NKe8+sw5/+67LubA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Vrsdz4b5yMJv4rTN0+EZShnOEqM6/MPKnESRlJDFY4=;
 b=MBpZk+0xBkPekGoj2FP1so1O327BoUoQRtvNrvs1kdfsh229agfJWrS1yUt9ZYkNn9q4iGf9PfZGWgbR86dhc2WVuBD5iQhFDWESCt+/U6VmE3zFamOL3VARWrG5fwSETcaWjb9nDj+rtJ4yLRu8Gy1Zn/9j+6cb+aOyxJHkFAhZgFI2VI8wa24cTaZ0J31lzpGpLNDnecEjs0DAzod+ojtgEKNf47DPFjRqD5cPj3aW7MEyfbbrQ/9dStzd4cgrozgyTbkueryKcgeH5tWqJ24hKEqbf93gs1TsPR7NkEs1Ot75Xm0f42hO5BG4nZHDxSf543KDahj1zQykEzYICA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Vrsdz4b5yMJv4rTN0+EZShnOEqM6/MPKnESRlJDFY4=;
 b=MRGhUkg3nwwtl+mAxiwBEy+jOfS5JBxN92D0T37kw8tVG1d166ySUWiwtT58/FfBDPxqdiyJ0iELSkwODbnc8DmQ7aLs+FdgZ2BuKv2Ret4pbOR17uKxwG6b3RxSSGL9R4BDP+gGEbGdpENau4le/iv9wdln2V/SU6qEYkBL7/w=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4484.namprd10.prod.outlook.com
 (2603:10b6:303:90::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Wed, 24 Nov
 2021 14:50:54 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.022; Wed, 24 Nov 2021
 14:50:54 +0000
Date:   Wed, 24 Nov 2021 17:50:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Wolfgang Grandegger <wg@grandegger.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Markus Plessing <plessing@ems-wuensche.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v3 net] can: sja1000: fix use after free in
 ems_pcmcia_add_card()
Message-ID: <20211124145041.GB13656@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0180.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::7) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0180.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:45::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Wed, 24 Nov 2021 14:50:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8572bd89-1e9f-43dc-83c6-08d9af59d0b6
X-MS-TrafficTypeDiagnostic: CO1PR10MB4484:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4484E6481757723365CB53168E619@CO1PR10MB4484.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CXhSl/7kb8+UiaJh7Ljxuyxl0CPHisEGxxNJBA6wcyBMJhtzDpX7UOYn/6scIL5R+iP9xUZWnRxbEJHRZ7R9NFqroTyoZM3m+xanmKLUtC/P1VwFsbTxXbMGafiUF6/O+/EXBez1q188a3tt2HqKA1nwqDMDCnaiNtbSaoZSXtrEqCKNuDVga7E9miUjyGYKRo1wxBHrCPxjOLM51UrcZ7P/ESlrdRdVxGjHjovMt7b8hChs2XTLG/txXShPP4gXLj5+U4wSZOysb82OIvT9RGh0R1XD0eTO9mkrENSnMJVOX4Xt6FFqm9voHfXmoHeg5mcvlND0kVMP0G49CBaQYrCuYgEFDg6TLNMUVUPaMGW/S/McnJA7sNSpb0gAZ14zXCUX4+HrHIwaCIK7FmMbvpV1ZAn2C4KykghE5qvACE7mpatw8hRxv36cHwEj6bev8ej1MPrbokFbNah1Jk79qLTV7bv7+tLftKXXtZNhSV1K9H8Brebsvdfp1H98eve4mM0stZEaSospriCqiaV9HquBt9JqN6d6/oMM1dMP3LckWGjWWdbYZPlzV/5AQE1xSS8nCpOBQM6HQLkZ21t9L9MQCBYkSorg85MQfTHntX7ArY+i9HGTn4UNw+fJZGGkDyvJQ/nm3uTJz+U9kpb1sVfJ7knxdj72wb0mB1ATTQGRW2FGkAepbohqlwulV8ibbPDXdqhN/fE+TDc8GrlbJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(44832011)(7416002)(26005)(1076003)(86362001)(33716001)(9686003)(6666004)(4326008)(55016003)(66946007)(52116002)(33656002)(66476007)(83380400001)(38350700002)(8676002)(316002)(38100700002)(956004)(9576002)(8936002)(508600001)(6916009)(54906003)(6496006)(5660300002)(186003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/Duix030fmTqZUFTLZv27YG9u3kU689DHWQBJZ4ClV2OdX40K0TwxlGSp8HR?=
 =?us-ascii?Q?tRUq+fsXBEHcwvAk2LqjLxOj2hklQco/hyc/3QprDd6kT4+Dppwmb2vk4k20?=
 =?us-ascii?Q?JHI3V5mg8RMMnECp46Mk0/BPor78rizz9sbFOpJ0CTj3U5LuanUsReSGyPE1?=
 =?us-ascii?Q?5OcLjHQ4qCm0kaZd8gBQBUCgJprm9rMuSZhsDxD18IZY7P8qRykV3J4EDoTD?=
 =?us-ascii?Q?+CxhffT5/12+akvGWdNjhy3ietbHKmbXjXwoeyUrrx8M3043xfjzukQGin/B?=
 =?us-ascii?Q?oj04j+p+S93pfSuOThwo0XUivA+1LU9YK05CIbpTr7Uq6x7DNgEBetCFRhmS?=
 =?us-ascii?Q?VtTRU9FkSYITzeUGl8Sz6tGEp0KaoOO52Y8mRIMvI+x2YCFxi/KNFlZ63wsG?=
 =?us-ascii?Q?1gkNxThTU+47ezMJzfHmlNIiM/8JUdXeirnoh+2N2REGgx+5qc3NTmC3sXob?=
 =?us-ascii?Q?o04JwUlQ2lOGX3/lucfRe46RtyqM6/X/Zstl/3E8myCMG2E8qVUjif/6VIfB?=
 =?us-ascii?Q?pEsjkkGX1zmgS3YW4EYfHvo3vJGkY3jqBzI7i/Fyv2JoAlmjbwIFm00/dF9x?=
 =?us-ascii?Q?n2FbwucWwjonqvBU9Sdkc04/hNnRpiJJV0Kh6HRqgDXZol5vdLe9os9C57n8?=
 =?us-ascii?Q?8DiDiLFjXDmfR+BYGM+7vVz4RFmwuR7Qs2y5z3tbdtPI2TqJEFJUAybMyN/R?=
 =?us-ascii?Q?hvwpLqacTVy7P9Lotutr+MJWLTpW3d9+Zeq4CiuVksYzlwhvYKHIktIXX9ST?=
 =?us-ascii?Q?plCjdeMDjJYxm39gOmsecKdlOF6MrlMZD6FD4GPC/EbQU+1X4MjgVP+KEn3/?=
 =?us-ascii?Q?Cw4/9kBsPPYQyZl/ektcT2CtBI9msVE/vcwXmOPqqWWBMZ5JjDuNrTfbqKlB?=
 =?us-ascii?Q?RSgvYBzXqpA4DGrJvigcqr7kSgeyFKVyPwnA3AK+7s9cz5Kh+M70Iw0jhvCr?=
 =?us-ascii?Q?0sC+u37JNpghpNuFMh8BHYrEj7YaQduvffxc59napxzJiIxuTlrUozbolwoD?=
 =?us-ascii?Q?X/eR2DJYEgyIrfBiHSUWy3/rRFtD3eItk6Kj/fGO5VeKb8YgV1Jw9V2CAEt/?=
 =?us-ascii?Q?59PJTmkXnVRJA4pHT4mWtJgQIYNlmxmozwHDOmIVjtF+fEUgxui1n3z5/f1o?=
 =?us-ascii?Q?kNvi7t6i1I9NuKgRrMIrMs6ZFfPAG5M2+r6vyMJx6tf48yanunnOHdnhj550?=
 =?us-ascii?Q?zXDG7vjVqtT+dZVgy4hK6gK04rRVFXyroI8wGUAZqEOKggEzTqD5noXP/KQU?=
 =?us-ascii?Q?naSAvTrWu5MzWqkAW/r5xN6z/AgYU6CICcIskC7CIx+bFtzKNhO6LS1yGao9?=
 =?us-ascii?Q?CZ6TrMcy9S24+f0mwpcdydcsnnkaGZFDchZN1oNEdtm5PPGHmrF6YBukleGM?=
 =?us-ascii?Q?HSoctiqemp3gUTnLl3FeSpX6ryXldgRpo+ISUWRUmQnMJrCZMZIS57crsG9X?=
 =?us-ascii?Q?LO4dfJSK2YZ2iV6GhlMqzypam3trXBcPDMLD4x8SCvdOvfSctrGDYs57ioXZ?=
 =?us-ascii?Q?OZnNsSJzOq8YJ9yH+9drLOO62BR9qKzLypxtPZdYdTXzcB6e8Nwoh3ObSMO4?=
 =?us-ascii?Q?nt31sRHIzDX8hiW7NLiYH/YQsivvYNYBz3VQbMB5PR0It6MDx4mx1+nxAblw?=
 =?us-ascii?Q?7gaU7D2J1+tk66T1OTHlhumxvEX72JOAPKhGyLPi/vKVArKkhm0U/uxmZPH1?=
 =?us-ascii?Q?SHlZ+oScEN0pOn9gZDp9OgLkRrY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8572bd89-1e9f-43dc-83c6-08d9af59d0b6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 14:50:54.1146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yp4eAK94UPoS7cg5GJ1gmj0q7uUCi0cl5BCfZfcIeY+z2iqBwv8UnK2taT7uTQ0rx24ANle1jF90t3Z8MOcFM86ZWQWPho8JrTnt5n/HtUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4484
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10178 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240083
X-Proofpoint-ORIG-GUID: Yy7G9NKKZRxKRO6nX8-pOKhb349VyQlB
X-Proofpoint-GUID: Yy7G9NKKZRxKRO6nX8-pOKhb349VyQlB
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the last channel is not available then "dev" is freed.  Fortunately,
we can just use "pdev->irq" instead.

Also we should check if at least one channel was set up.

Fixes: fd734c6f25ae ("can/sja1000: add driver for EMS PCMCIA card")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v3: add a check for if there is a channel.
v2: fix a bug in v1.  Only one channel is required but my patch returned
    if any channel was unavailable.

 drivers/net/can/sja1000/ems_pcmcia.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/sja1000/ems_pcmcia.c b/drivers/net/can/sja1000/ems_pcmcia.c
index e21b169c14c0..4642b6d4aaf7 100644
--- a/drivers/net/can/sja1000/ems_pcmcia.c
+++ b/drivers/net/can/sja1000/ems_pcmcia.c
@@ -234,7 +234,12 @@ static int ems_pcmcia_add_card(struct pcmcia_device *pdev, unsigned long base)
 			free_sja1000dev(dev);
 	}
 
-	err = request_irq(dev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,
+	if (!card->channels) {
+		err = -ENODEV;
+		goto failure_cleanup;
+	}
+
+	err = request_irq(pdev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,
 			  DRV_NAME, card);
 	if (!err)
 		return 0;
-- 
2.20.1

