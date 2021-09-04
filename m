Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109FD4008FF
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 03:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350857AbhIDBep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 21:34:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39386 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350649AbhIDBeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 21:34:44 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1840oGo0016825;
        Sat, 4 Sep 2021 01:33:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=XCXnn4ANUXRpCzgH3TDmKtYu+O5d4AMd90aebSz5Cck=;
 b=PKqAq9DqCP9oBlx3UgObUsXVtNqon8yqDuqYJs1TCj0HGP2KjKDchkIdlAHQXCPhSx9f
 C+zdAGyDeWlvS1HhqjoMOmxO+UaJ2g5u9gxMc6wmg6mUAZA66dOnJXHJoIRjcb+2xsiV
 QyhPYm/MDj5Y2VffZBAxRt78U65kkPAPFJhLXQS5dvAxyRqNduPvo8wWICFk6losiidd
 1lFxo5lCUULmUuBiBLjEnULvF+V//myZqikpg97GS1y/Tszfrjttx7nF5vaExYEyEv+X
 1ebD3O/sTQIfIax8EipAWCsrzWZWc6DnMUd86P5Bm/UtrgBbiB3r731uxYyHfXqX5ZGy ow== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=XCXnn4ANUXRpCzgH3TDmKtYu+O5d4AMd90aebSz5Cck=;
 b=nFEoqknpyPCKbs5hlO3SbZDOMjPUBayfxzmoRgksa9pvNcbnbONQ/kjCqHqpAAZFl8A3
 BSshDae7bTfHO0LBs/MftS/gzlD6h5Ojra1b8TUFxvuAqs7ypJMnfas5HaY7rC3UjRNQ
 3T+JqQchoJV5p81vtuELr0g4r6gt9vRRe4Yr9HaTbB2NpoV7tdsLQdu1aTZXvS4zzcw/
 bRJ1LPFm4JpDjDbMiclrWL7Um7PFLMikWDAgfdiV2M3ADhZrT1S5PPop746VTOYmtCmA
 qVJ0LlE/6YcrqO40jAWGLfWAd+DNVDT3fflZr5q8K2fxBQtC/vFRjXLgTroMiJeVDjOW mQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aug2ptd7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Sep 2021 01:33:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1841KYEE194419;
        Sat, 4 Sep 2021 01:33:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3030.oracle.com with ESMTP id 3auwwsjwe5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Sep 2021 01:33:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1tRYrx00s5znl9hL4INZtY6ncM9HO85YVy13cWgl+qev6Oq7VeQQdRumByTDCfDD5QVkToTZPWEUHnzMYxfc5LiFN4dcRXa0ByrzgZzyQzBdtUe7IcsCxRZk0tLW53i1mlGio/lOFTedT3h0b/tjrpXTs6iJRdlfLPiYKsovU47CKMPRX8auXzETsAmP200aJsqFOD6mRYozhWlI2Ig8CL648T5cZIk9oEQvhlUGqpB0S1QCbOo4lHPFIIst1jzVzDabtISarl2veIem983KWSn69Fdd28+Asls41UjoJjkNW26j2R/C7+cxwoqW075UCfbvajQeJ5YkhaIfs3R9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=XCXnn4ANUXRpCzgH3TDmKtYu+O5d4AMd90aebSz5Cck=;
 b=W/VfkFbXSOJFS3ZqDh9UdYP1l8xsEkjuZNd9h3kMk/+IKoHRYFv8B9xhwbKfclBnz5xZHj50IDL1G2T8+4C/XIup01qZWCz9XIhXwsPco9auqFEkR0Z4/UDWRwwgHWiEF5gWenq+4aDmU3RhhSV67KDqdfZMsDVoQOMjY7olIwMVpULXoMoMFfQk9rt27Yey4yoA9vm2W+yoHCq+uBc0VXSc7m9ukpPYA42uMSfJBhp/Kz4Au64ATdRaqD7btXJv+KWWdtSHKz5r60POkN4pog6jT3JjE2ZDlDRHG85vHLCPr6iPHihB6fSPI/047ZYNLGE1ueTyzKPLXtHDGEybzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCXnn4ANUXRpCzgH3TDmKtYu+O5d4AMd90aebSz5Cck=;
 b=VCk+U8Ko68NUqM2W7z7pPn37aFNoRsJJQkDjSdHwigC6tsntO5ZhtO3Jf+4wAHDx4aLEvsMSg7//NN2HpOFZusZVhhUsEGytQ4DoHhWJpT7HmbhSOSLuDozhzB1rIBq5QLd+P5CdY62l2qqr45JA+dl96eKa3HBzqLFjv5kHddA=
Authentication-Results: syzkaller.appspotmail.com; dkim=none (message not
 signed) header.d=none;syzkaller.appspotmail.com; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27)
 by BY5PR10MB4321.namprd10.prod.outlook.com (2603:10b6:a03:202::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Sat, 4 Sep
 2021 01:33:24 +0000
Received: from BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::a01b:c218:566a:d810]) by BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::a01b:c218:566a:d810%7]) with mapi id 15.20.4478.022; Sat, 4 Sep 2021
 01:33:24 +0000
Date:   Fri, 3 Sep 2021 21:33:20 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     syzbot <syzbot+b187b77c8474f9648fae@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, josh@joshtriplett.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org
Subject: Re: [syzbot] KASAN: use-after-free Read in __crypto_xor
Message-ID: <20210904013320.7nrsz4ybh75vkjij@oracle.com>
References: <000000000000b503bc05cb0ba623@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000b503bc05cb0ba623@google.com>
X-ClientProxiedBy: MN2PR19CA0010.namprd19.prod.outlook.com
 (2603:10b6:208:178::23) To BYAPR10MB2966.namprd10.prod.outlook.com
 (2603:10b6:a03:8c::27)
MIME-Version: 1.0
Received: from oracle.com (98.229.125.203) by MN2PR19CA0010.namprd19.prod.outlook.com (2603:10b6:208:178::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Sat, 4 Sep 2021 01:33:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d2ebf35-536a-49b5-811d-08d96f43fcbe
X-MS-TrafficTypeDiagnostic: BY5PR10MB4321:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4321A17B67A33BEE3ECAD6FCD9D09@BY5PR10MB4321.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bM8bSgzOdJBpruSGg9CqstQKAHjcLbKQbwGa67/rWApQyDFVYVzMcgtqxhEUv3kgkcHlw+HOaeuqA57wnlDYhnKPgfWEOuCKAvu8ziN6vOYcON9tc8idQi98VpNIbIQFzd0k3KLAKm7upTOhBtMc6jV8jAV7B30hEcFnsg58CbxYpqfYJU6EqEQwxCSqe+N3xY+Z6RSNWHesyX8QpTI3Tg4QRYW9JKk4Dn5mLjSh5GS3vd32WVmBPGdQF3C1Hfrw5VvJ/qbnkQgjSpIkuPuxweucnyTi9gB0G9MlOaGGSrjHk029SITq2MxbJsJKM6LXuNg6pyw1aHLxbHyB5XqoiwKQd+xjeR4RDUfCt38cdyGnw8aob+0nOwBREoW2HT5+UzIKLSq/JsK+wn2Hb6cQENdzSdgw60e2xhKRyoAHn6xsZp360c3I/Ugi/mfbCe1G03ZvSsx2T5VQwZWHC6I96DCVk1SgAt88e4iZhp/qkCk1QmHAehB9OhmdSCxNxASG7e9/14uO/bVJ5eiZJP87U6FRUdpl+Izp/Y43xGW9MzR9T6WVFCMWqKrtzeh0bwyMVsCTlPgcLDVDxz2gzs8kCEur6ENfYdbU4G04jW5jwOtNps7JIBVNC444d/qvM86UYHM9UWK/lbWmsOaDz97tGGDMbIp0+Ozv7Z6F74vA0uPab2zgl82o3DKWt8LhcUejX7jLV0u8/07shBwCCqzu2C5+2fylbum/u2e+1EJZ6NS7OPKDaPaky4duowTlZsPwecZRFYlhzTpuyzeuOCYA5II/ixyz6VkM+wqcq0YsezLA73wBTr/UPlNMKSAQxh19iVRVMnslj/hzxATaRcjSiy0FmHbNn5480gtRNEpzIvg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2966.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(966005)(38350700002)(508600001)(66476007)(36756003)(66556008)(8886007)(8936002)(66946007)(86362001)(7416002)(8676002)(83380400001)(316002)(52116002)(956004)(4326008)(2906002)(1076003)(55016002)(5660300002)(186003)(2616005)(7696005)(26005)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tY+dsqjEf8YF2VQw/yY4S1I+/3tOb9nGESiqQC1RZk02yqLBS6WM7EBzuJeN?=
 =?us-ascii?Q?pK5kJBxgV59rScI/IzoowgOkxKRgrrxtMFb7FGAQGvtJk36NhmIvOUNmBJS4?=
 =?us-ascii?Q?KjDVVvaW/XkcF8khWeW3fePtVwhpHFJXPVlxUUJQ2PFbbBstQROAdgX3MtnM?=
 =?us-ascii?Q?4xqmth/GRAeyYNQfQXfNKEnwnKET3s++j08eusTb9zR9Zw9AhsSChLnLeHiP?=
 =?us-ascii?Q?OXcrbAbtvNaPmUkTVHO1NnfeLqyt/4eELAM44bMOl9RqiaHzI0vb4IiWyWZk?=
 =?us-ascii?Q?F/Y0RCqgUINuUCb5iilT/z+X3fBx4uzvtSXM2M1UdM4Ylznt2Cw0kA3Zs7PD?=
 =?us-ascii?Q?xgjprCG0pL2Zr79oXCcjCGn23c3mLxwELlmyLtG+rS+fMu570LcGs+zS2gq4?=
 =?us-ascii?Q?jkGMWoi5RWJxpQeH+dkqBjIZmQFOTKh7ilQqP7ex2IbKW3lS+eN9hZ7I44qC?=
 =?us-ascii?Q?SpzvjhrwHpWhfMRO2apBZwzPsF7CAhHsQoeEonyG0jluYymShDBV/jelwV4d?=
 =?us-ascii?Q?NXuJzAqXG0iw+z5JG5jJymv0PTq4dL3DgfqnZAebl1D76XEPruQ4+wuvttW1?=
 =?us-ascii?Q?qaFgYFE4MWpU0mm8bFFX0dU0fLMzfKtzliX6JRzw8awd6pOtilsLo9krhrNi?=
 =?us-ascii?Q?ZL0xr244TwcAlRwlox8fi13SYINT05sZNgdm8JHxSXZkSb+17JMZlrI69u+k?=
 =?us-ascii?Q?+7TFf6urZxClmMGyUeS8WLZZZMddKSF+8o+AZlB+EoeJv2PGAd/Hvmtjl0CL?=
 =?us-ascii?Q?AwD1orDBJwQG6qPtlnld0i9TZieZPZKqPLzXqqxyyqzQwMkk2zW7iOZC18YN?=
 =?us-ascii?Q?FUz1c4b4Ex3ReV/ohAMZ6GCks/DQuLzpnwKFLDS1fGTubSw4bmOB+B1Xdgm5?=
 =?us-ascii?Q?ttbuGxN3jbAR66q+dzmBrXMva507iLn7zNUM/KxiJoSyJy/i1rY18LaAEit4?=
 =?us-ascii?Q?mh5BJHoXQ/eyWAPAr/nNOFlir2QULoNngBUsBvR4gB1rU6OerjfGiX46MfZ3?=
 =?us-ascii?Q?gM+6G9bd0g1DB2SOTUJD5Bho8n1orGWtGHz3ULx+6eT6tx8n46oIgknkrntm?=
 =?us-ascii?Q?yhuNdOp0FKMIIUq0vQHAKWSlQOz+ZF7dNdVgjlv94Ng5DTw1rAR1uk32eV52?=
 =?us-ascii?Q?bfNaM2arbjWQSpfcxrM4CSA5MEuDzKykQ1LJV+VCGCfO4KM2BDnsazYm2G6b?=
 =?us-ascii?Q?hhOQ5i+A9s3RDcVf1r/3vY5oTeAqoV6/s/fiLO3vV8LbA+Js/NYFa5PTfAe7?=
 =?us-ascii?Q?kALZ8/vl7kmy78emJOFN+BiiT7MxGfRxpOEPAknmce44SHIQq20r9W3F/Rth?=
 =?us-ascii?Q?9ogToIqg9+ATdjNCNvC/qIV2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d2ebf35-536a-49b5-811d-08d96f43fcbe
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2966.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2021 01:33:24.6429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wZP8PYjxtyv9UEDHmQZQzm8UEhwDXn2TjbxXM9fskIFhT/cTn5UHbxJ7/CL+7TwZ8D1IspkfdtT7GP/HtES7rw8jPF42XYYiT2+GgsTu5VM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4321
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109040007
X-Proofpoint-ORIG-GUID: BUkGC17EQk-B_mAvJkNFpYwZ8VlPzIQ7
X-Proofpoint-GUID: BUkGC17EQk-B_mAvJkNFpYwZ8VlPzIQ7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 04:36:25PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    3e12361b6d23 bcm63xx_enet: delete a redundant assignment
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=160cec72300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=63a23a80f42a8989
> dashboard link: https://syzkaller.appspot.com/bug?extid=b187b77c8474f9648fae
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144d07b6300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=171b7fca300000
> 
> The issue was bisected to:
> 
> commit 4611ce22468895acd61fee9ac1da810d60617d9a
> Author: Daniel Jordan <daniel.m.jordan@oracle.com>
> Date:   Wed Jun 3 22:59:39 2020 +0000
> 
>     padata: allocate work structures for parallel jobs from a pool
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=118dccae300000
> console output: https://syzkaller.appspot.com/x/log.txt?x=158dccae300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b187b77c8474f9648fae@syzkaller.appspotmail.com
> Fixes: 4611ce224688 ("padata: allocate work structures for parallel jobs from a pool")
> 
> ==================================================================
> BUG: KASAN: use-after-free in __crypto_xor+0x376/0x410 crypto/algapi.c:1001
> Read of size 8 at addr ffff88803691a000 by task kworker/u4:1/10

The reproducer hasn't tripped over this yet, but I'll keep trying.
