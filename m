Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC47946B337
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 07:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbhLGGyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 01:54:39 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:27038 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229483AbhLGGyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 01:54:39 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B74ZwxH004022;
        Tue, 7 Dec 2021 06:50:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=/dJWBgkPpLfZRgdsBlgCd7XHW4n+1krA6E0bo//wuZ8=;
 b=0/5vc1V7cwxN3LxlSxZDrDJ2FG+RpfiPWp/s+DvGWPPHgXg0sjkxgc3yOlC/oUIZmbmV
 C4bRYyGW3hZ4VPlm5MxPZo+Ag8Z7Qv5urpOB2yP3nd9riUtXcAOG8/AwOa8u6mTs5Rax
 5wFmYjOBmQYJ7axYXOdyJVeDol6dMnoKWWqpGCfdjE6yeGhXDnXrOEnCrl1vhdAmVa9e
 uYyNHJoCeVp4lEwD3aMUfeis5aaD1ymfkNJDzYk6IRoY2rsD3Crm7CV2GGgy/AWanzWx
 Ki5N6OSM7XxDy+AQu91Y98Sj+7pybZmZOYNJpXIcfoI5Oa8ZLaKfYpFjI78VKPX+x8cT Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cscwccke7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 06:50:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B76k3vM016633;
        Tue, 7 Dec 2021 06:50:46 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2041.outbound.protection.outlook.com [104.47.74.41])
        by aserp3020.oracle.com with ESMTP id 3cr054g4bv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 06:50:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dur9/yhSzhBntgMGGEu9V6WsmPbj4lQ5iQVskxoyZbBA4usYwMVPC3sBezMGEx+FpPzy8FVqsTZ56yxU0hB6X5tS4J3KQ3MnU6bkqrzedl2gvjF7ayOgw4mqMBLjNOT25ViU+MigJJ2xhdqmVGu8LGrPRofiKNXPvGYHDfvuIixOXsMaMeUyATmYhaDbvVkqMEDa8/SfD1P9dlwRifNQaFiIy+VyboJzS0+jkwoOUULiF38bwek1CsvCZrdPGtKcXv4Q+W5S8rMNI4dpSH48Q6BTl+lsrkKNIb5GglIPDIuQiUZYADW21QDBevp9k2c2bKosvbIx7XTA4LdQ10OZ9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/dJWBgkPpLfZRgdsBlgCd7XHW4n+1krA6E0bo//wuZ8=;
 b=ZI4emXbYHJaPyJ00cfgk2oj8CKd9sT0v07lDAcio5O/TJQnnZStLDocOHjUhfztv3OurYhqjoIk0RNKOQQSo0dYBY0xdnlLK0ZVgGvIOpPoGn99hHyCWBJdzEfKnSduOHzq0owS7nOdyBSPpDAZ/uhofLDlOfQ91+YGgffBkhE3TkiqThiBSEALWzgJ+YpHY4n8RhFcrgZDT4yMKXeE0k4vTkEHX7OG3xA3bEXXYkkN9r81rP/dPyEQ8mGea6tR4HwRsmrvj4G1W8Li8arG3IAUpdDRXMJycP+SMQaYpKu4zdRhDnpq1CnuDoPAKEOBWS8DboBam22FxiufqrR7fBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/dJWBgkPpLfZRgdsBlgCd7XHW4n+1krA6E0bo//wuZ8=;
 b=RH53ycAU/sjfirZ6e9lx+YifK0pgbr5islcBWm1A0xcPpkanhZvVi9l/wPLexKUlPpVgA3LKgFPcIft75u5k2Xv1XmrKlYAd6tgyo04ys/aeXfPasu2fgcViVoBntyA1UsXDvWujgxCIy+bqEFeSRlh/brgDE/q6GNU5IswweSo=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW5PR10MB5665.namprd10.prod.outlook.com
 (2603:10b6:303:19a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14; Tue, 7 Dec
 2021 06:50:44 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 06:50:44 +0000
Date:   Tue, 7 Dec 2021 09:50:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     GR-Linux-NIC-Dev@marvell.com, Ron Mercer <ron.mercer@qlogic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net/qla3xxx: fix an error code in
 ql_adapter_up()
Message-ID: <20211207065022.GC1956@kadam>
References: <20211203100300.GF2480@kili>
 <20211203101024.GI18178@kadam>
 <20211206165403.05a420a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206165403.05a420a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0021.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::33)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JN2P275CA0021.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Tue, 7 Dec 2021 06:50:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1fd6e96-ae02-4bac-d396-08d9b94de419
X-MS-TrafficTypeDiagnostic: MW5PR10MB5665:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB56650A5613511319E21B7E168E6E9@MW5PR10MB5665.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A58KgQXQQDwLY+BuyAMsOEtpvVageIauJocnZ8Qc6j/OzqBd3bDUg4lBhTVinmvPruU5UqqRKxWLKJyqxZ4OnoH/OoFPIbm3VAGKQMRqLZesAxfTZ6qECbCXgC5E0ABQDWl7urmSvns1aOJ1J8SI56EPhuLzJkAP8voXdA1ayLGtZfa6kag+IHp49/P65g3CAU9bKb8GWiT8OKlBA7DrKYi3KFCTketSWYVhgM04r2yQ/O2oay5lNqV8apl+zRLGg0re5UKBgxs/+43J6VIYi/Y3W6f3R9Yv7HAPEn3Q7fmj5vbHE3ibN03CU10xDJ6a2QGi5ssdz7cBuWIqq4FulDkACqd/1CjwBxqiZl/fUd8IijdhxHGWfZfFog5yxgbrqFun5xGwxEtWALOuGKlgzMTGiWynEQeh3rPttwvRQl5L16rAZEaWJQM3pw+Cs1js/RbkMfjKZyN93ECjxka7kdfAZJz/U678astNc0YmAoqytneqDU5CuiiF4M65pH9VPeX+hO+JmzJutbPp7SThcPyTWAQ3DwFdE1tXsgDAwYsTNLcBDtzCufn/+dLOe2soBSKso0mn604G4BXsVySNiYJ32fSFkTRRWSHZ9/fQsBCBRVdkIfD5D0YtS3OIO3Ny75Q6+Frtk9Sh2j6d0eBCB1wLlFm9Yt4QN3KQTFvPJx4JjGlMrtcFFbSgI1TABm9fGd7Rz8fc4ILQ9j94QDuIRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(54906003)(8676002)(316002)(6496006)(52116002)(86362001)(1076003)(9686003)(4744005)(38100700002)(186003)(2906002)(55016003)(33716001)(4326008)(9576002)(8936002)(6916009)(26005)(66476007)(66946007)(83380400001)(44832011)(38350700002)(6666004)(66556008)(5660300002)(33656002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RgnW7h0qmQ2DmjfeFHbz4fnlE1p4BpD/WTOxDlraYXpRCo0TlTVw0N0E4jvR?=
 =?us-ascii?Q?UaVPM1TiZGJbAJ0kQtcXUZ5BczwiyyYWXvUw2WAzMnZE1n+puUriklBhnHqs?=
 =?us-ascii?Q?L+iViriBzOEQCk+yAI8kPR8vUcQ8by8NBTBnBVLojmK0dcp0uQ5y3oYRHpPw?=
 =?us-ascii?Q?7gcFF+gr94Dka7gTXOT44CIvXtszz1ZQg31hGovOAh9rD7fJHIphZL2c+/0F?=
 =?us-ascii?Q?VBAhZVaMwM/kc7+Feti9wPc+mHKM4aLv05bLrW4I2NH4ZrtAQT62Eoqv73Di?=
 =?us-ascii?Q?kK8Y7dsENwBzV1QwXTHD69Xsu2IigzdEV7QaY64i32v1T5bi9JfkVfV10az2?=
 =?us-ascii?Q?frFYS0ChpxAMfMWsbHAib0YcRYCOxAtUv65w5i49haIGX9zLPmamwH7Pn7ja?=
 =?us-ascii?Q?kcZTnO+Vy12Z/KnCyJbf2/kG+vtLmEhDrU1CpAgCi5WrfEK6SmlQrRCCsvrr?=
 =?us-ascii?Q?dn/3BiUHJxhlLueWe1egbX0jSaEoqkJ5NA4YBUEjYl+wA87fdLj3wntzjEPP?=
 =?us-ascii?Q?aBPcR2OeRjHdthN0Ugop/DKIT1vkxWx3NpxJOZMrEvTdskkB61YT+nvAcuFZ?=
 =?us-ascii?Q?u3MCG25tcI7ZQJ63e0dOeJ99s+t8K5v0QcBP0PYiXtyA2eQu4j19Qy4w9UJ0?=
 =?us-ascii?Q?PXVnPNGO9VDR9sXiG8q4qVqq/AX96HBAef7Gn/lRVMp6VoojyCGpNFEr+VVg?=
 =?us-ascii?Q?XZG7qgYcic0tncQD+sQ+MVHcZdrEYoT7DN5XgHHtQ9725yWHb4maoowAnRgr?=
 =?us-ascii?Q?Pmw11YyN2OYF0nVEUtPQBJQwxfWeLl8cOOCGFcTM2JPU9c2vu/nGo36zCEW+?=
 =?us-ascii?Q?RuFzcpUUOEpPuAfexv5hMHgSJZviI0VGo6dxq2SfQuzXoi13jpTvLZz7/FNW?=
 =?us-ascii?Q?H4TkWgOuSm+8+1bVsWieTd+iSoPcIdaI8pTiPcWdg1iZh5oiozviUMjpLWvc?=
 =?us-ascii?Q?SgAG5orVgq6dj/SJ6jLWVyk0429t93fVuF6F1K4T+MnEGM/FXlVg+2C2UxNG?=
 =?us-ascii?Q?0gdhpMK7RpZThFNfhwJm/tssmgHICJnPPoMHajOKFjU0mXHZVMWhNT5mgZZj?=
 =?us-ascii?Q?qpqAGYL0v9ZeKrPET8d34cedT9JJx/Zzh8T8jPeSDtA/77N/l57pZD70tpdz?=
 =?us-ascii?Q?xJCjpGxqO1Sr1RwLXfaeTV8gCR+Moh/vDBd/08Nvlsj8I+ppjvMvALFcnmHm?=
 =?us-ascii?Q?yfwcjvEoQ3f5zpNiR+R4ap2eqlZ2dgV00nZQf1KHNtHlEpbpxTBdKdRhbOYs?=
 =?us-ascii?Q?9Hylwl7JaXeAdaeGntGkN1ltF3Ujq7BlWClrrngnWuG0pEqrBXuS154iHZXV?=
 =?us-ascii?Q?jrTfy6j6xo4VQYPOlezPrFf2xXyf8OSDk4NgV+INe4kNlBlyl+kVvvzJbZla?=
 =?us-ascii?Q?jHraE3vwy4Yx0BckrsZdu5MgmxNtXv4Kaxxc0sEWelTvhGAkODoELnVHpbqE?=
 =?us-ascii?Q?tVXl2hI3IrEsg24ztDgyIYgTw2q7MHs2pFz84h5FM2VDDcUD8udqeI788sYk?=
 =?us-ascii?Q?WPHFAu3mpLDhr11fw/rmRPiWI3QObcH/3bGu/TeyLTgYIVbm9AfM2k2Ypi5B?=
 =?us-ascii?Q?db/LpItYQ+kZnxXEz3YqM7CDCSgdHegoqsj1jlDuRveg7ZQXdTJKhdIs6Tvq?=
 =?us-ascii?Q?XYE5SkO690pjyxIu1wgbWOw0J0u6mBtCecgQkXc4Qu63miJVv3BrougA/yjp?=
 =?us-ascii?Q?FXa1m6+ymgj2lD42Fzq/8zK3LIE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1fd6e96-ae02-4bac-d396-08d9b94de419
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 06:50:44.2112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O3yKBe3OwhDIqIpgPHeq2AbRaCEdWm8MWxcuM3u4/L3DO56SqCEVO+sn26D7jzxe9iHj94BoBV8YviSskUoPeqH86JSQCydWUCP3HdkyiLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5665
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=763 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070038
X-Proofpoint-ORIG-GUID: 7iJgeu6WfdLPWRxOhjFzAVdM5B_5H0JF
X-Proofpoint-GUID: 7iJgeu6WfdLPWRxOhjFzAVdM5B_5H0JF
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 04:54:03PM -0800, Jakub Kicinski wrote:
> On Fri, 3 Dec 2021 13:10:25 +0300 Dan Carpenter wrote:
> > I had intended to put [PATCH net] in the subject.  Although it's not a
> > high priority bug so net-next is fine too.
> 
> Looks like it's marked 'Changes Requested' in pw. The Fixes tag is also
> incorrect (the subject does not match, there's a [PATCH] in it, which
> seems to have been replaced by [PATCH net-next]). 
> 
> Would you mind reposting?

Doh!

I will repost.

regards,
dan carpenter
