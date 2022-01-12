Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE0248C81B
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 17:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbiALQUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 11:20:06 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3804 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355107AbiALQTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 11:19:22 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20CGETVG032205;
        Wed, 12 Jan 2022 16:19:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=RIkxDjnQRPm1cR7hCtl/ceOoNN335pkKjJVvk1O0q+s=;
 b=whmFBbusG2vhdJk+IQv3ObYSvuMlMg2hrUDiF6T3VoLDsTppENFPtwYeeGzyqoWn5447
 PixiQWC8rww1NVlIkABCISbwUNo9FSv7lUoSJrSyCVgPbDUfNq7ymJqPS4QQtvJIdCX5
 QYgc5Ns4d71Ec91yfbxjPIXbSn9q95TPi8Jj8RL5Bv7h+d63EmBacTT3kwuTCiTOL59C
 4HSqx2762QZXkMts+ijvRDUo2XfKO1wYRoRfHm2W8Q/IUthHomWcyuKTqUrTyCOTKEFo
 kHN+cGPzbPGAkRT20x556K+f+Iv4BxcsGfXfnsp5PF+9VyJSZyETAiR0d+qSotttwWDN Og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgmk9estt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 16:19:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20CFvhX4159325;
        Wed, 12 Jan 2022 16:18:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by userp3020.oracle.com with ESMTP id 3df42puq4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 16:18:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYBVZM49SYmRT7J5ANeSiMRk52QiPaijXDMGci+G9V1elZpv2wnYS1ON35bMTlIZcDSp2JIsns4alL0XxgKuCV3gbdUP9MrR8dU4/wW7gXR943lQXXhyg6siSZ8BDu6DVd0pfFsuBEG7Co9P9ZCrHGtuZW452s5I2AMh27WnQPq6qDxaKBv5ogYCf3O0OljcSSg7bi32uZSOaoYT01DrYSvJyAna4/n1jZ+Tk8APdzv+U46gqZ4kCAWHlXyV7EIlvsg5butahlhWHCoCLBFNk08Q8XOg9tG5LZD3VbqHiWmBs0I5NPZBDJ51oi06NvDAAe5+lRCMeJC39pVFndboRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RIkxDjnQRPm1cR7hCtl/ceOoNN335pkKjJVvk1O0q+s=;
 b=B0Uzmf0QBfPOBZvem48iesBezrAf1GEVEcfXGAI0+Q1bzexgMIhvOfuLFGxK5l2HYD95cRL1g6M4ML3ZJqFkEZk6JjSC/Zrl5oiV7osDiO1ebXCeg2Kzl+oaseLPuAS7hNxqMWbUpiIK2gVzz+W82EFwgzkIBExZdaNBBXKck6k8w4f8gS2WwK+GNPfr6LZBonHmGU+IE78eWf2lrg4MvzmcV7nbcyqdEPRXi8Wpz+QmfcVooAem8VMp3iYBkxpqfUouarrmqymuP2HPqFnejU5GPifGG45qm3ORjKpC6YwG71jKctgzv+upkvZfJfK03F8f6dvgc4YR5ldsgLRorQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIkxDjnQRPm1cR7hCtl/ceOoNN335pkKjJVvk1O0q+s=;
 b=P3psRMKvGATjD/cW1329MUovMcgT8MmJFuSZuqLFBswGZot57d9Rac6xjCMjVuy/xc1fyT8ljPGsNvpbFd9GTMdLXMJjjKNf+aF7BtEfHg4Q7LPh78YVP7IXk4fBJfhWH0gW/9PFFlZtfi5EdYXn+E16fb0taRXFYwT+x3ALEUU=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3600.namprd10.prod.outlook.com (2603:10b6:208:114::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Wed, 12 Jan
 2022 16:18:54 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::31c1:e20b:33a1:ba8c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::31c1:e20b:33a1:ba8c%5]) with mapi id 15.20.4888.009; Wed, 12 Jan 2022
 16:18:54 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 0/4] libbpf: userspace attach by name
Date:   Wed, 12 Jan 2022 16:18:45 +0000
Message-Id: <1642004329-23514-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0080.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::13) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cba21e9-2a85-4a1d-2b3e-08d9d5e73a7d
X-MS-TrafficTypeDiagnostic: MN2PR10MB3600:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3600625CD1CB8E6FBC676107EF529@MN2PR10MB3600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tJUjt5DnnLsjoIPi1dGjmevo1pBID0Cfm3h40rQUhLz+BLe9SBuAg9BnPVXo62xWzusYZ6mK4yn7bV/Y69AsyR9OUj0GGR7OXE2oIIR7Q632y50FmhhLeVFDPL3FQbZWJG11haicXgle+cbDKe3sgKVSz7lQFGfEnwJfwcc8Qx2ybT0bGT6tOGq9X4hiHMCzxlz7UR8X1h6E6tjZqn8HZrXKYPKRZ2uFXF31JCG6ycu5ebEqDHtLSecDYxgunBHYyuIttobTIK5eb9xAGadVQ12QUTFQ8ox3UBYMokfd/j3k2bNLlh7HI7UVKllT+jnUOFySb8lQF59pPRXKtmurpOEwSGQAuhpbRA4ZziiYX4mi8ngCaKqQC456hpy8qj0pfKRy/D2QfobywgLcTjv+mQEYn+00v+KSGXAzNQf9MCHRHOeMPtlpg0+PXmO8Y6t2E0Zk0aqtnEb9LwX/ZjJfzHuSbdcZuOmbTzAGbc9pQXnCklR6nkF79bctS5vTTxKiKO4J/oFne+vsJeElXXPc9uqEQFsaCmw3ng+0VDUKVl/zLTQZ/R8VDHJZCHg0fE28HLxw74tc9LUjoU1xvunmuZC9DHLtQ8MiPsoLs8KKgeFkfLrATv5A4NF4jn1mXgFOqTJYAxmL5Wqaf5Xa6JYZuldpUm4Q4DDtL+pAG9o4djVqPQq6S6EW8mAtwZeI9usEwyi5xtzUVxeKoZdLk3vdeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(8676002)(66476007)(8936002)(6486002)(36756003)(66946007)(2616005)(5660300002)(44832011)(107886003)(6512007)(66556008)(316002)(86362001)(7416002)(83380400001)(2906002)(4326008)(52116002)(26005)(38100700002)(6506007)(6666004)(186003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?92NzbGMqPlZbnyjmJdIp5Ob+GmqcNSYQC3sqeDteGcV2bn4ZUp5xGQr9AOtg?=
 =?us-ascii?Q?4g/bFAX/1ZJEbLgu1ynqpIixM5gUAZghlyEl7OhlRgw+dnqXi66hy92MYEkT?=
 =?us-ascii?Q?fzb8N2E5mLpoExHaQ7jK4+du55jSJ+69rgFM/X2KQ2P1rKGS5ZBfJtAQcABC?=
 =?us-ascii?Q?b9NMNNkix0T+JXd9IcCjFp3n8mV4QEGo2KAwVrnq1HZRyZ9i7HmpqG+wBbHL?=
 =?us-ascii?Q?4dBmpf+Dh6xqU6Q5YqNoo5havXSGKjij+nVMwrPbjZngm/yGWwhBU7mvUAno?=
 =?us-ascii?Q?8vMSre25UqRtltkR3rTUrbUgqD3Y/OhLTyRK2GQ8LIvru36ivY11Hw/NGICI?=
 =?us-ascii?Q?+at+OEmhF6O/88mTh7WHMwLx/uNR9we9q3m/XbKzzvu+SQgE8BhAyqv+hycX?=
 =?us-ascii?Q?806gI5lIMF2SjW6+6drhSF77yhEcnisPxcsTEd+ZXnQ/dTEqlKp7+zD6aIRe?=
 =?us-ascii?Q?wP0jVnrssPoU97EftYZ3BLi0z3MSuDBp+uXO+8SAELyNxkQEUV0ac0VT+ObK?=
 =?us-ascii?Q?VI/ay6zalimlHV8358WMLDE590tWjPxRYz7evmglwYjiNE4ctGrikll68N4i?=
 =?us-ascii?Q?wW63GLq3BfIvqQ1oCP21RoljQVScOK7qM8zL8AbuEStlR8CCcoSVrOZSh4bY?=
 =?us-ascii?Q?5X2S9+QRfPq+LNHt0OSmqPR6IBWsBBxg0UZs0QIbg8omkIPGeZKOb0vbj7i/?=
 =?us-ascii?Q?IbyP70u8juw+TUfINZjpCwdTrsEWENFbTtB+78L/nsNg13ysIgTx0XwDD45x?=
 =?us-ascii?Q?oFtDjaG0TCNCSycyHKmUTSOeIHdpyY39+hDc4rnS7De8oy8YmnQdLot4VIFZ?=
 =?us-ascii?Q?NLGE3fTctQtUISLCdJ2wF5+efLooUQK4iKhd16q/WIUk0eaW/qw/YHc+0ZAe?=
 =?us-ascii?Q?kBgRQAC8bSQ4b2v9//kAJwBZOYcK4BVRf8hf7FdvNtPjwIY90Z2juf0pYUi0?=
 =?us-ascii?Q?7a0ChBIeIki33e4egaTtEJy2Q9Yen9inckdIrSudcgwzQZTXq8Glj7H/xm9v?=
 =?us-ascii?Q?mmPGDKMlMbFzm6M3pdiguKgn+atLWeqDyaPX4JGNqd2uPzS+mTk7AaWefZzq?=
 =?us-ascii?Q?++Mz4jRpv/iu2P2fzOZ9KErxnqohDL2g5ui1WefutapzXLYVQ1E7q6NL2zw0?=
 =?us-ascii?Q?4JxmJIkD+1xC/I2UlwhWY7b7np75JFVmExiP9itkEZAejnZi6J5ZWGg4Z/qu?=
 =?us-ascii?Q?fYD36k06OFYTX1tms2fpehc5z+vybFB8kGJ6IffzvVX7R54QmI7wxOCtr20R?=
 =?us-ascii?Q?j0XDAChGOEq0FaBh/dhZJpCMBV/3IRmVfun6N7i2quKqv9X43rFXWyy9RpYl?=
 =?us-ascii?Q?irmOvzgOBqXrbP7qeeKSol7Nyj59vNFwMDT8QS7EUOHV9qeL36VYV+HBAIQQ?=
 =?us-ascii?Q?ph4tnDpdNe8zpWSfN3uvoPd01Yf4Q6i/gozkB8vIuoWDL7r8zX+20afb2Qhi?=
 =?us-ascii?Q?eo5CygziA7uYroa43MRHTw+wzlEeD2ES29a8a6X+3o2tR1MxC98tk2JhRaiQ?=
 =?us-ascii?Q?k6F1yzZdqCUd291RnY8Lk0EPxsWo4CoUIrjvL/UMi1N0tn/QSepK1QoHGGxd?=
 =?us-ascii?Q?pClM+JwhVDbDp01LI7nERW3ZoZpEQYVDBZ+cMrA7Pl1yLvUGfrrPnebG/1n/?=
 =?us-ascii?Q?az3e4VIDpN+dQcz5fHtBN08=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cba21e9-2a85-4a1d-2b3e-08d9d5e73a7d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 16:18:54.7422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C8j/7XuYIfI0sTVx3J/4cK1iZoDpxqMW2Du+pvA/v7xpjyryduogYWAMcfflOXZP6nSX4lIaTV0iKTIUBqO1Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3600
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10225 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=855 spamscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201120103
X-Proofpoint-GUID: go16qRACFbQPlDTg8E9jW4MfDiZAREIk
X-Proofpoint-ORIG-GUID: go16qRACFbQPlDTg8E9jW4MfDiZAREIk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is a rough attempt to support attach by name for
uprobes and USDT (Userland Static Defined Tracing) probes.
Currently attach for such probes is done by determining the offset
manually, so the aim is to try and mimic the simplicity of kprobe
attach, making use of uprobe opts.

One restriction applies: uprobe attach supports system-wide probing
by specifying "-1" for the pid.  That functionality is not supported,
since we need a running process to determine the base address to
subtract to get the uprobe-friendly offset.  There may be a way
to do this without a running process, so any suggestions would
be greatly appreciated.

There are probably a bunch of subtleties missing here; the aim
is to see if this is useful and if so hopefully we can refine
it to deal with more complex cases.  I tried to handle one case
that came to mind - weak library symbols - but there are probably
other issues when determining which address to use I haven't
thought of.

Alan Maguire (4):
  libbpf: support function name-based attach for uprobes
  libbpf: support usdt provider/probe name-based attach for uprobes
  selftests/bpf: add tests for u[ret]probe attach by name
  selftests/bpf: add test for USDT uprobe attach by name

 tools/lib/bpf/libbpf.c                             | 244 +++++++++++++++++++++
 tools/lib/bpf/libbpf.h                             |  17 +-
 tools/testing/selftests/bpf/Makefile               |  34 +++
 .../selftests/bpf/prog_tests/attach_probe.c        |  74 ++++++-
 .../selftests/bpf/progs/test_attach_probe.c        |  24 ++
 5 files changed, 391 insertions(+), 2 deletions(-)

-- 
1.8.3.1

