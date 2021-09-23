Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBDE415B0A
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 11:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240184AbhIWJhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 05:37:15 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25310 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240069AbhIWJhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 05:37:13 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18N9OVpu022369;
        Thu, 23 Sep 2021 09:35:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=cvewADEhlq2vtsAK+HZ8WQG9a06WhHLCvFLUJyo48Xg=;
 b=vKOzKOYk9d4WFWUXnVwp+JrfmG/XYyOwYvPsvgpxdiGfSCL70Xr+/77lrelHmrQFM3v2
 xgbhuteiPkKnA+JDdQ+ZE8G1EYoOpnUD/JtgEW8T6ZsoA8CCh9sw7hJd109xdXiHnSBm
 4I8HZk0wc+HsHL0gK6ksjz+Ejkzoso/WTwzxu58PtKTjGrkCYqfqKC6BRQMf0NEHcUr3
 nAsiiR8oqwY2apTA5Odm/YfBWy+aZPUuMGBGYCnpSzp/ksNNX+Y9mmDrXXMG+oqZpCsP
 VWnFkj0bVZxg86CTLkybL05RwmytDDM0NE8AdAm1viS2ckilaDSuBsylhirH1FgWEY// Zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b8n2v0pgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Sep 2021 09:35:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18N9Z2ni184394;
        Thu, 23 Sep 2021 09:35:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by aserp3030.oracle.com with ESMTP id 3b7q5dehqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Sep 2021 09:35:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQO8PnB6Ldvi7cAVypNVfw2mnkK1YZKnEWvweS1cJXV6oWJvkrQ3KjfyKMtcjmbU22TDV/g/99/Ei2PuEvQGVehmbbiej1iDbkiB+4O1wI8ljqztsz+QQgDxXYzLnBRQGfScTYrG+E6gEFc2OEhEVq34zbG4509c4e8nGh6EJPHsTEjS3TgXlKbxaPizSdLXawjgJlOxRb+ldRwK73pPpZmrltkhGByaHNCzSi2IkTmSz2ryWb8tfOI091ODwWb17L5GFTgHheks0+lciVa5YFel6zgC5POCOSaNa8V1OMrq1tVlfhO6YAbNFwB3xJM9d0aJVtTB82U42raCovqk6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cvewADEhlq2vtsAK+HZ8WQG9a06WhHLCvFLUJyo48Xg=;
 b=LHnzjTiyArMxzAIgmhDWyEWZZ8d0Cw/DSajcg/yrUlQNWEqyRMa9RDqOnB6R8vubspfTSLs/nK1FWOWwzqt+RpaeZo5Omh1vSAsBafQ8+M+ebVxEI3dpvBs3Kn+U2FTyDfG3MGKzpcyggOrdncW5v0FG1B4KpXtcUTMteRL78Su6fFR0LPxAWQytmC4qinenCjq/EZOOm55lN/beNcOMlr+LDsLpLDkVdTx4LdLBd1dn2PelC+opjW+xJqJ8GG71LOhFXQdK1rohSiNMekdykqf+Wj+UR7g2P9WIjK4GUxk3jph5si6oDkaWwhWGgUIg7YBscZBfs30BiCtV+s5hPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvewADEhlq2vtsAK+HZ8WQG9a06WhHLCvFLUJyo48Xg=;
 b=pbWBAYnLCK4zWKh/yp5qHLpYxqGcboNRRxO6qicX0CSItEKeVwxNNTmP4UDgr1UnanuLuB+DMgcpnS9jLdaTv/dEK6YVODJ1Lj9VlsLq4eLsvvg3cfDm8dzHKd78O5s5jEYMjJgGtb96q7c9WJdP8dtksSPW4jX6jPvtjDvMvNs=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4610.namprd10.prod.outlook.com
 (2603:10b6:303:93::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 23 Sep
 2021 09:35:03 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4523.018; Thu, 23 Sep 2021
 09:35:03 +0000
Date:   Thu, 23 Sep 2021 12:34:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     syzbot <syzbot+581aff2ae6b860625116@syzkaller.appspotmail.com>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Subject: Re: [syzbot] general protection fault in sctp_rcv
Message-ID: <20210923093442.GC2048@kadam>
References: <0000000000009a53cd05cc788a95@google.com>
 <CADvbK_c-V6orWGm2ae1pxoUU-5J-1J-a057hYemA6oTESGhFMg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_c-V6orWGm2ae1pxoUU-5J-1J-a057hYemA6oTESGhFMg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0042.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::30)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JN2P275CA0042.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Thu, 23 Sep 2021 09:34:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba981fe2-1526-4af7-757c-08d97e756b89
X-MS-TrafficTypeDiagnostic: CO1PR10MB4610:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB46101FB66625982A0687D45F8EA39@CO1PR10MB4610.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r2wDIsDgR/lIs1JGHV/NVPl2uybEEkl1/hJOTaZqOlQIZib97mwmxF4sO0ZROCZ41MKovF67hx/E8dupWskcFNwFhB/XYfJVnK4hKIWK1QAz+awvehjCDdDM93bPyCDbfM+hvYijhGiRJR9qw82tnWIHxZuRSU0ajsRTOMb4DrOMvtkw50r1g9ClpBAziYQhC9c1twCaogaaG+//1ieS06Weqty6UlbqtLkhpnoM6invF948ZOQY5W0eAAJAIU+SQy8XoKe4gbPwb9NN41fYjpbiHjrU8ZH5nT7DnV9UBulGuuRhtnxIkRbcXu0IscSogR4XectigCEpTe30U1zpcJ9eO7CeBdku6PFIe+fv5xaAe0cOO2zuL6YjVGKMcTCHGllRqwKV9zhdoc66ngB0GWdfaQtfBeRJBatlb9ynV7MFnDIfGm2x2dp3ZPyP/rJJYWnlOOne4Z0aGnruHuEoKRsSmpnEUHoYNg2ccnBorHLBVqbgq0rhr9t2TnjKDF9r/xypXsXv/5FbCbhGEgET+BDQHNMxWpcxR36stUR8FtFj4QnLGrksEyRyTKI+frqAzyhNyMIPC2boU2hvk2HOBV6/FUi/7wIIyeR1oTbQ9WAl3UrzNC9X7mpzCOL2HL0U16hi2/1J//soYilGwTz6/n6LatAyp3Mwb8/NRfcRH2vUxw7k8eujVsqgq4VbGQJzYia72IwHVFYi7gt8bK5qXCncLjuTiETIvmGwe3YHBtCCPv43W/Rq2vgEZQ13ZkiB8OTXtbZrcuJ3en9zPSFmb7jx4HzM1o9Qsl3z6+c9L/GaL0eSWp/S5HudlDULSmSf8Rt6L0aUz5Zg9uyNAa1Rp5CuIRXuXLe0cNKS+Zqrm0Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6496006)(52116002)(186003)(26005)(53546011)(8676002)(83380400001)(38350700002)(38100700002)(54906003)(2906002)(1076003)(6666004)(66946007)(6916009)(316002)(66556008)(33656002)(86362001)(508600001)(966005)(33716001)(7416002)(4326008)(44832011)(5660300002)(66476007)(55016002)(8936002)(9576002)(956004)(9686003)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sSe+lYOGp4guEb2WWUqM1GWVXpQZ5+XkNqpWUJ15lyN7+Jj7q8JA55yGaYTt?=
 =?us-ascii?Q?7PoNfEZissNOIAWxqATr84GoImDvFekXQUxN0fevEen+c3NQGYCrWouaPiud?=
 =?us-ascii?Q?0h+CVt/5Jb169jMm3Dzv3xL/ZNP/qwu+ABL94RHP3dlY5u/jI7nplrDPelcP?=
 =?us-ascii?Q?HcCdwNJw0PsKnouN7KF4moATF1bs0iO93AabCfWd3IGml5OxA5TW3m5WmCSN?=
 =?us-ascii?Q?if1wLt9Naj62HRkXqBSD5q+zYs2GAgWeWQ13mG8I9EQIhXvTDN4kUkPLiRXK?=
 =?us-ascii?Q?1IWrnn32OQL4uzif0ORD4DcdnBgB2DauWlJG3hheYF7XaUeW7W+TAhPCrgy6?=
 =?us-ascii?Q?3Zg/RQQB3hUf+nta/o8cq7sdVY0DNErCnPDWFJsoLcy7n95pccP3rIC/ZTp5?=
 =?us-ascii?Q?rwEDYpS3eQbNLHBft0+Gq9kjPtI4hEjKtgsMkGfGhMy7OjvQKcG37/IjAzjQ?=
 =?us-ascii?Q?Dd1R8inB3RKzOMIG1TOZaA3i6JokT7eEzHZXWmnM2AoRcIYYfpr7lhn7pB99?=
 =?us-ascii?Q?zJ4FxZU64c75UZYtZJAy2jZ16gc7DhnxFcbuu40x2834+ugQiZjOyhm8C7fT?=
 =?us-ascii?Q?KNBBQnOqytZXX9EUZsLba8KFg3Mzv4pCxP/4nC8I+E1mokb9CnTSwp1lQLXc?=
 =?us-ascii?Q?yMpaQr5pGaGUsAaf+S6P/MX5J5YyfZ7w+eOscvSE/UhJNb8GKUkGZAcn7Ibt?=
 =?us-ascii?Q?fpbOR651zpSuNCqNx4Seof1RXhLyitOXiHc7KRR2ZeDmgkmUQEIKqXeVyAcY?=
 =?us-ascii?Q?K6BX0RiDQWgAI9xQK+oK661KzqPyRRS3y879n2igc1rUq5uHpyeFrV9f3p4l?=
 =?us-ascii?Q?ycCjMp/bA2HRFjFzGCosm1sIExeA2LOGptPzy4RhBFB3KTWfK4SJea2CX42t?=
 =?us-ascii?Q?apNNNtfP4fi1FzzD5ZPDxtJqeBLvagwMj/poIhIBgv9Ut/BRI+vIIdQI0Ved?=
 =?us-ascii?Q?+6Am6uzM3AyRBHML4bz6MmynU/rNz6WDGUAoCMSsshiMUR7eFbWCV9tAaOwB?=
 =?us-ascii?Q?W7sUd5D1zu6Rp/Tu+g0o8emi3820fLuKjDRj1ijUr+XnjzoYIZ/aQr9KtYDc?=
 =?us-ascii?Q?BQfmfxXfyjPDa/mgbFlZHz8SOZyM/jnN6IuAERXdXVLtidRtHCmpkSYDcnhx?=
 =?us-ascii?Q?5MFtnm2u0P45pSF+ddCcXGITBvwjxAgdT2P4UZ9GOL3arg0DHx4bTRm1bMc3?=
 =?us-ascii?Q?SELYfenHE2ydTGd5rKe8rGQvWcdpB02R2/mdO1H1vr2Y4tw8uER6xa12vHON?=
 =?us-ascii?Q?QkpvgLzwU0ZV3ggxnTcJUm6YB2SHGOaQK+Hex5L2TjsODVPuYpC+ajc4Vyg1?=
 =?us-ascii?Q?mKd/v/XwnWQj4OO3Mcw9e22d?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba981fe2-1526-4af7-757c-08d97e756b89
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 09:35:03.2808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6koZFlO8o0Zm1WPiN3njvwedDcVq5PGfCBtrN/5wTsnSfNTqlOFGadACOio60cNv6pvlHD/eFlXz4UleIm/g3UsE287sS3Jp2o4GbNtE5uI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4610
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10115 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109230059
X-Proofpoint-GUID: kQbGHsd2UIwRRKhSAAJHsDEEyCanBb3g
X-Proofpoint-ORIG-GUID: kQbGHsd2UIwRRKhSAAJHsDEEyCanBb3g
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 05:18:29PM +0800, Xin Long wrote:
> On Tue, Sep 21, 2021 at 12:09 PM syzbot
> <syzbot+581aff2ae6b860625116@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    98dc68f8b0c2 selftests: nci: replace unsigned int with int
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11fd443d300000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=c31c0936547df9ea
> > dashboard link: https://syzkaller.appspot.com/bug?extid=581aff2ae6b860625116
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+581aff2ae6b860625116@syzkaller.appspotmail.com
> >
> > general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> > CPU: 0 PID: 11205 Comm: kworker/0:12 Not tainted 5.14.0-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Workqueue: ipv6_addrconf addrconf_dad_work
> > RIP: 0010:sctp_rcv_ootb net/sctp/input.c:705 [inline]
> by anyway, checking if skb_header_pointer() return NULL is always needed:
> @@ -702,7 +702,7 @@ static int sctp_rcv_ootb(struct sk_buff *skb)
>                 ch = skb_header_pointer(skb, offset, sizeof(*ch), &_ch);
> 
>                 /* Break out if chunk length is less then minimal. */
> -               if (ntohs(ch->length) < sizeof(_ch))
> +               if (!ch || ntohs(ch->length) < sizeof(_ch))
>                         break;
> 

The skb_header_pointer() function is annotated as __must_check but that
only means you have to use the return value.  These things would be
better as a Coccinelle or Smatch check.

I will create a Smatch warning for this.

regards,
dan carpenter

