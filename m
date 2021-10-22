Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C388B437C42
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbhJVRxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:53:30 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:12636 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231472AbhJVRxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 13:53:30 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MGTlj8026427;
        Fri, 22 Oct 2021 17:50:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=xN6a2kaSq8vQikAF4Ra4tsIH/qb251x6LnsDfBDk/vk=;
 b=nJEAcLKrTgqPP1j7Wea3n5HhPZIsvD4unE7N6UhDYaYUwjuC49Y1OpH+2uJtnHlCU9b4
 JrllYTCjO5Nk2lMC0WbqZQiy6leDMxQcrKnaVJBBg8+XiM/26ixjzXCrowxKUm/P9Wka
 ncVRw3MpnGMApiR6NueUCFkp+knYFR57Q/SURV6LepkC8v08GnMXlqIue4fHOP5B3oio
 PatiaeBO0WJO4Tm2HoeE517+flN8gwxF7WYVz9sztE2ot8YLjE7jidSXNH6nLtTP3k77
 JIeaO9pwJpcJsxFruS7oupDoKokgS5sy9neXOAnPGU8toRnh2AJOBNYZQrSRt5DcgsE6 nQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3butfgaj4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 17:50:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19MHfLdX150388;
        Fri, 22 Oct 2021 17:50:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by aserp3020.oracle.com with ESMTP id 3bqpjay60q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 17:50:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbmvOe8G7fd3CSvKTzrRnRHFuxgI9Apezm5zgrjJE1qSgexrskMoR/fN1ZrHfaRF6Zq5/jwTN28KNloZz4f9uvTpjbSPMw4CLE1tAJI6zNSpMYQWBzrNPc/+VOSh+YrwTkduZ1aOdABU26WDTeV63J566zS9UoFbwNC/NvTXrSykURF9b//02INq3J5eguNDg6EqXN3QpSjU0zEzTBza+DoZWfujAb3YItE01k+8Fqvb8JT2wFnipqJKbln0126TXLhlQnbGKAV+5OtLhD67AbYhEPP9jYr1WMiVV0nxRe+Q6UrRr45SV/taoAH9l/gLvRR7SxDNjKeHi5xh3jJj/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xN6a2kaSq8vQikAF4Ra4tsIH/qb251x6LnsDfBDk/vk=;
 b=Q3PTAhKiMScIXQys3y8RpYqJOBNKGtK1qM6SYhi0eBFuLUxoA8QdiqeLxF9b6IqKsnQkDWn7k24g3EZ0QFsmEaB9a16fcA5YQ9my4HfD93sLeqS87Mt4OMK7YvJsxv3y524rI53zFAEl4lIM4I4qn+ZZNvyapd6dzM/tZE5a2gHMPjIFfFDV0XXMZM6mT/DSnr2GxKSFbJphTVH70yguvvYD+idxlzEstTJWXR4xxcOtTR8BWhCUlpJJI6TJl+DuvawYtfoTb3+iRuuaSWZA5jRmWyNYfFSr4UBPMPOfOyN7cbWuOR5zkQjFiuYmwmL3SFPUdtcFt69gRO/Ua/jZgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xN6a2kaSq8vQikAF4Ra4tsIH/qb251x6LnsDfBDk/vk=;
 b=v+Z/gSr7MJL+MNjC4XxHVyx10tb9da8LUaSTg3x87tyZUcuNulND+9DsGO8HVOIK/O/j5JOmADijNoWTKoaXFSq1znOOyvMUh5/rur9z1v+HnVTn2GStAKCzgd3up5lGmg70auBaAXUXIugnPpk/SpZiQ5wig2edo0FOWxk2v14=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27)
 by BYAPR10MB3464.namprd10.prod.outlook.com (2603:10b6:a03:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 17:50:45 +0000
Received: from BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::938:e546:a29a:7f03]) by BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::938:e546:a29a:7f03%6]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 17:50:45 +0000
Date:   Fri, 22 Oct 2021 13:50:41 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Dave Watson <davejwatson@fb.com>,
        Vakul Garg <vakul.garg@nxp.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] net/tls: Fix flipped sign in tls_err_abort() calls
Message-ID: <20211022175041.qqaoarqzq7xkt4pi@oracle.com>
References: <20211021183043.837139-1-daniel.m.jordan@oracle.com>
 <20211021151603.215ab29e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021151603.215ab29e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: MN2PR13CA0031.namprd13.prod.outlook.com
 (2603:10b6:208:160::44) To BYAPR10MB2966.namprd10.prod.outlook.com
 (2603:10b6:a03:8c::27)
MIME-Version: 1.0
Received: from oracle.com (98.229.125.203) by MN2PR13CA0031.namprd13.prod.outlook.com (2603:10b6:208:160::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11 via Frontend Transport; Fri, 22 Oct 2021 17:50:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2810cf51-c854-4844-d638-08d995847926
X-MS-TrafficTypeDiagnostic: BYAPR10MB3464:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3464EF9F15AEE4603E26C94ED9809@BYAPR10MB3464.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cpUcpPGA3Zw6rJ+dBJC3PLMMMpobb3ysVVeQNFDvVd11oOWZYNkDXPVh9o6isLuO3ZCyYcJS9Gx0arMafA0Se7c2RDoLEWQBFYZcbibQQ+2C207wuWvFpxzsp8S9kw0O/HRZzHXuwmlmpwdloK4JO+uUH/fzjxsxkV1wKRKEf9muNJQ2tlPXBB9cvWWZJUqk+yJsfDTPyhIETAMubOXEQl1F4alWB4VeoUL9MhLYFRox1MRjXwDEl2jjDVNIjxa5+YdPAEZjDhv6UmT6LgBlL4ohXFwMo2+BewWwS4NP2ZNIU6CfC2KDPAPr5NMt6OfMXchKtgqGjtUPocqcNp3fbXe8DXh2wnrwv16NxNC/cKhl6Dow68Ar69aA9jdpuUqx97KScEPzgiiSTA6Yl26lKnSsjyxXbBt+pxpl1IfUJ42oMHio3WKK6tlo6pxJFK+b0808PgxVIKBOaekkuKFyvUvXHBm0kJ1B8gXIsqPiAZ1Ukcytag5vMyAe5xqU9yl5C0PpxfeCLDLBpdBriClhLnCjZvbgaI8hBQN3POpxZLbGJIBIoHXgOkJuk1kYBryvZ4EbJgaPbb7jgJDe2/uNClgXGL3lSjZeoFp3lLgyoJ+MebbdZITE/x16ojwSz6stFLO8xKM1riLQxD4M4G633+9VOeVSoX1KsnBOir9ZPKGCDAw+hEMG61esZA45FCcfeuME1x0cqPJeG5MxfUNGZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2966.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(956004)(66476007)(66556008)(66946007)(186003)(6666004)(4744005)(2616005)(38350700002)(55016002)(8886007)(4326008)(38100700002)(54906003)(1076003)(26005)(86362001)(2906002)(316002)(5660300002)(7696005)(52116002)(8676002)(36756003)(8936002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZQvmTwuAk/KikCf03E7MXGT5j6Qzlt5FK3HdR/2VSwkhy1RAVqwe0gbjjMBW?=
 =?us-ascii?Q?2gcvFArVUpUwqknvB3up/+TRQ3+eG+2lGwBuSMt5ufGeuJ/P6hM1AIs+B81B?=
 =?us-ascii?Q?gXLYaj47CYzZpxSmdaQ1utLSle6WulzUSDgBd6dRwsvUwiA4yWqSphfz4HDS?=
 =?us-ascii?Q?MGTabU9gxiiMmEQjTbd/4iiT7xNebdSrqMEY2qOJSQXKivhc30EBV5fOFaBu?=
 =?us-ascii?Q?kutjIv2/bCbI8dfjxr7ei7NgEvGUme69wfPGPySQeu/w3NRje6u0Abf6H1V6?=
 =?us-ascii?Q?6NmwgBHCAhj9qfsLoTj0d/fEa9Pi6IxnJiXQlk03vr9ufJM+uJXbE1SriRjm?=
 =?us-ascii?Q?pfEow59oPs5fMRQdV/gKLNaix2kBATexUjwGUqLuCle70RHVTizg4PyhpFXK?=
 =?us-ascii?Q?0O8oj70TRK0XQiOgWPBPcVuStjHjLnO8AZPwJ9IWeh79mLTW8QtGd/O9yxyc?=
 =?us-ascii?Q?ZozRFsfnkx2qlSprJTlCAvxyqvkK6EnmrZfBZULO/w3esWA+pm1EpqBZYS1t?=
 =?us-ascii?Q?CZ1f6w2e2wX3iZv8L3UlyTPEWQlXCBqyx/kiLCOSN9IxxrVeA6bgtZktxweM?=
 =?us-ascii?Q?Dv5kPsPKLQvSySKKO3+Z3i+3g3PI5CFZrkDrRU5vhItTmsIwvZYByrRr3av/?=
 =?us-ascii?Q?YwLMYB52T956UNZM7P4r8gMy4ZEac8uFi10Y1FmR7sQKxtVgzwi3xowpya1B?=
 =?us-ascii?Q?dioysAiuQ+EdvvjLn4rI5+hUhqHKnT8cihzyfcREYGJYtlY4nQ+VpgWHtY7u?=
 =?us-ascii?Q?9iCfemDlPpLkcgdtLPD30PsdbESZYgAO4wBT4cugWogr3KYoBYk9dFq3knF5?=
 =?us-ascii?Q?9TQoQChAh/NI4a4T4r/yWCTldnlkCB4zMAxWVOOWzShMa0G5uXIupAea8QJK?=
 =?us-ascii?Q?3e8r/11lCM706UrUEHDshwCgW6zlbyvJhbTHNmhjPzN67s/Efr5hPL8e226a?=
 =?us-ascii?Q?5oXev0QfjeqlePq6VRIQuFuFuZcMR83wv4sAk7EOPitXvlwyrRtoeTcgztHA?=
 =?us-ascii?Q?wHep//N5YEB8yRXxFSJ4Buy+Q5IUHEBXkUWlJ3LwWvvEb4woHm53UJXZR5Th?=
 =?us-ascii?Q?7C4bsL2KhRenPe2odgNVg2NhqqDH75b3YofUdKczAS3ZqmTyUJc+s6y0yrbp?=
 =?us-ascii?Q?IY9UbrfuXjq1G1Am/drd8sL2srWeTRq9tfbgWFlvM+vilwOK9Qe/TQLlTTjo?=
 =?us-ascii?Q?NjCl1P5Fj7OzDYqiYyFcLzFIxmk08Sgqeb52QWmWeQudmmJhTpzr4vK4hHTR?=
 =?us-ascii?Q?+ktBPU6KiOxDfedlFtOgIBY/hLDCTxZ9uIRFYC0BiN1SMSgNMdQegCvDoOh1?=
 =?us-ascii?Q?EkwcpObVjgy7SdSZ9uXMT39RTdHtkch1Px/p8zTrGluRfSdU/3VFG+5wV66h?=
 =?us-ascii?Q?/scGo3HzB/ZjC4485nB+UKg1XdeEFXAweYFXHHNTzSb3VfL+werdHpTot0uv?=
 =?us-ascii?Q?ys/TI7Fvyi8ajUNWEvYC4c4Gxla0i5a8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2810cf51-c854-4844-d638-08d995847926
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2966.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 17:50:45.3044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: daniel.m.jordan@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3464
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10145 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=945 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220102
X-Proofpoint-GUID: v8DMbwBvQNmPOO1M_ZR2xOjcaQZ1JJcb
X-Proofpoint-ORIG-GUID: v8DMbwBvQNmPOO1M_ZR2xOjcaQZ1JJcb
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 03:16:03PM -0700, Jakub Kicinski wrote:
> Looks good to me

Thanks for looking.

> the WARN_ON_ONCE() may be a little heavy and fire
> multiple times, but hopefully compiler will do a good enough job on
> removing it from places where the argument can't be positive.

True, well we could uninline tls_err_abort() since it should always be a
slow path.  I'm kinda inclined to do that absent other opinions.

> We should probably also fix this assignment:
> 
> 			ctx->async_wait.err = sk->sk_err;
> 
> I think async_wait.err is expected to have a negative errno.
> 
> But that can be a separate patch.

Oh yeah, that does look wrong, I'll send it in the next version.
