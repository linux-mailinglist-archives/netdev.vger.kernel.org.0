Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C656D3329
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 20:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjDAScz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 14:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDAScy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 14:32:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1336F1BF4C;
        Sat,  1 Apr 2023 11:32:51 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 331FAccV021489;
        Sat, 1 Apr 2023 18:32:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=LEk9zyAOJ9e8nn1bXwLNhQoewD04mkFHKmWDe25wTMM=;
 b=GbETILgvillmM4AoDVzT9DpANVRUaTacREjdRuXCZHQtu/LJRBQMQSWf7ZQw3mKqTR3b
 9RLPGLukxxbruIQ0T72dH8zDKkblF0HjYmEICGGnz9Wq5UuWzrnlwqb/vJwr4Yvmw3x3
 uNmoN0qLaS2lwbn3pMDrQSIb1xYgvF1+ow6ShnrJ9ZKTpy9+cQfI5jboagsbdLFkiJkJ
 Ry4zCK+JszeLyfr9Oo1OCDTfcRUEIAK4yqkssrGI+cvroUp8qZehRE2a9to7pcyuRcWK
 ftLNwv4sguOumN0MwTehobuYe7q/0P9bzb2QVkiNyZQ+wt56up5MhDjhInqrAsCs81RP 6Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppb1dgtkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Apr 2023 18:32:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 331IIvTS005607;
        Sat, 1 Apr 2023 18:32:34 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ppssc0cxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Apr 2023 18:32:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtBtU3Q8TWsNVo6WQPpfN1fsEqgJwJJg3Hmtb5YDc+yqek52aWDr6KYsmEnQsM5VmwfNy9v6q9LzqGGXas2bMcFq+c73SNJ8NiDQ30PUfXp0+GNuoybHqUZSLk40SJoUCGe5SKkvjLty5NU1QT/T9t3+GP7s4KPRlzK0ylD1Qxi3lfie5EqzfqGuroK1FSCZCTJpV7RQUB8kyY7X4SyuhoK8B/8SubwJRoJt3eYzPHKapYsIMR3POB+EVkh7+MvPAou2r0Tv9oAF+w2f1OBVR8gQe60EoNC042r5yOz4AgD8oq4QMP360eYW2dGI+cJjwaBYKwIzbJ9+bYOkMya5aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LEk9zyAOJ9e8nn1bXwLNhQoewD04mkFHKmWDe25wTMM=;
 b=lPyDrE8hjkSnl/Lzq+ptca/bYBr4A6HBVN4f8oOS8op3aLMRUbW8vC5sRFl5wNjgagj8CtU4MEHj8vD8VFHYu0Nqhyml60jHrYXnPITVM/gCwNo91gsZgd5iNRKUe7gjmwwS6Dzt/Lr7IpywdwxwTbYXvp+uLbn1wkxiOga3zUbWwiCCcVMijWmUkUZjBKe9u8DibHA66ieDQNS22roAKO2F1DG8QOAa+qrq8x01VNFeeNpksDpKWQ7KmaHV2bMW0AmGd6TBvUaQe6cs24Zlc6HHiPfuwLbyPsLCzwpTuOTv3DTLM/+P80IjZaNoTq9IDVflY3grZeKhOW+nybZzIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LEk9zyAOJ9e8nn1bXwLNhQoewD04mkFHKmWDe25wTMM=;
 b=XNFclG6TXogYEL98ipzd9uFQg6yc0Q0Cj40n7aKGZMQg27uwWGETxKqlvj5xFb8CffNI85lr6ErrR6mvHaM8Ko1PQz0O/SCXHevY+BKBzjCN0Qz4w7XBo2a0uDtxhB/YdWwy2a8pG8ZNT8N4ZppwR/5a2p4zePi+ySNdaHSojx0=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by PH7PR10MB6250.namprd10.prod.outlook.com (2603:10b6:510:212::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Sat, 1 Apr
 2023 18:32:31 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%3]) with mapi id 15.20.6254.028; Sat, 1 Apr 2023
 18:32:31 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     Christian Brauner <brauner@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Subject: Re: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some bugs
Thread-Topic: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some bugs
Thread-Index: AQHZU53jvr0f3jRxyk20sGUEtokB+a75b4CAgACKCICAHO/eAA==
Date:   Sat, 1 Apr 2023 18:32:31 +0000
Message-ID: <AB1355C3-08FA-4A96-A5E5-56FCF35D4921@oracle.com>
References: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
 <20230310221547.3656194-3-anjali.k.kulkarni@oracle.com>
 <20230313172441.480c9ec7@kernel.org>
 <20230314083843.wb3xmzboejxfg73b@wittgenstein>
In-Reply-To: <20230314083843.wb3xmzboejxfg73b@wittgenstein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|PH7PR10MB6250:EE_
x-ms-office365-filtering-correlation-id: 4e970ac9-e106-44a9-f6b0-08db32df744d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e8zUJo6+atLBpfhHaCpA6p5OMA7gRHWzfti76HdD5Sn5at+u4iXSLlAiRIkXLHvRNAa1loA3CglB2ZJiBFmhWhLlkRJWNerPLsGfcyPSHnIh36QnaPtfWBGAYAfIRCgCGFDP5SFla5soXqKhuH2qqjOJl8pGn8LyLMNHEeEBuA3B4qlvdRFr4Nb3Yw1KjlBQL06y9BTWSfCsiXL4w99kC6giPPHL7mevuVH59LijcP3gWHogeS46PTy3vKmvacESPnnbf6uepkhKAiWTPFOtNAqP3WbyjKYS1v6NnxHj8tMMVy9vIU1a+pj8XKHlrN4/R7nJP4VaLczZ7taTI0F18LVQNenS1B4f+O8EcSaXcEf94Qge0lzMH0u1LksNR9nwn5kkuqs47xbuN54J7DTsNRQTyMStFAt7olpbKtL2CHbQhTUP5lyccCNUe8OZEn8hK9WQUXDML/p9LAikSl927N8/lG/sT4FNVtxAZOQ7PmGVXzwhiF15b/hSRRgocOAYaSG2EwoR9qrqsTD16fkzF2Ex/MdGNGw/+KW5wqOCFfO5LDKXQ4TcjqSA7+FMVjGdeVa+P9J7/+pk9VenzJskPnOwJjBFDhQFcR/R4e5xLsRSTx9mEZdn6Emp2vFQofWVdIsuViTMtSopPDeOTN+TxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(38070700005)(86362001)(7416002)(36756003)(83380400001)(53546011)(5660300002)(33656002)(2616005)(186003)(8936002)(122000001)(6512007)(2906002)(6486002)(107886003)(6506007)(71200400001)(41300700001)(4326008)(6916009)(54906003)(38100700002)(316002)(66946007)(66476007)(64756008)(76116006)(8676002)(478600001)(66446008)(66556008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eWsbkFMZ4GDeVfQeC5e7KrDE3OWZWGOdnK8mgcd50QnZadKJEYpvXSH3DDJZ?=
 =?us-ascii?Q?q67msNXd7qbz3SV9OkC8UqsObWNr/mckegCasf8OyHlX8j/Pxoe6I0Fptm7g?=
 =?us-ascii?Q?rEiki1FgwpjlPPBtR/GC4x55J4y6NWHC4p/i9kahntcZH6rp0muvw3WG4lq+?=
 =?us-ascii?Q?Re37CXHz3OkMm+GXgeennR2KJT7wCJSCj+jDGGKuoG1NRRpLC7GPzWX5bnoN?=
 =?us-ascii?Q?IzHsiA72dU8rlBnFIka2LH/Hkz5jOiKEM2ZERtCON5BxzaSPxYwkdvf1TIZ8?=
 =?us-ascii?Q?x5nCclokxwFWrgn8cpj9ZUStABl/Q3cFuynBlp+4g6EA38pBDRoQL3nm6hQF?=
 =?us-ascii?Q?9+yVo+cACvXGBsVBmxZxkUNkwHN5F3ZMd4LDievfn9Lb8/4fO+dLoRMjIfOJ?=
 =?us-ascii?Q?jCd2sWSFSgz0MALWCzP3NaKYPTkwCvIh2/f5W/yXPUOA+xtCxgk3w9HPRjwr?=
 =?us-ascii?Q?ivs2n0G2qKcLY7czmToF27Wg8R2NNBOsm4h6+QrIZCYiB81h3maQKc/7s2xF?=
 =?us-ascii?Q?1YC9NkCDYIwCnDvdzoM1fpAq78FZeZ0F2E/JoMVwFADXCCI9E+2mK5al/RkU?=
 =?us-ascii?Q?66keUrNYrQ11O7vGAYYghenFwzjDObTiToDcQHSTly4fpJ429yupzSLwQWN1?=
 =?us-ascii?Q?dU6rfyivrS6vjRLd45M7MHnBHKPeMNgOFNgf2UY7dPoeNEPX9U/N7mECXRWf?=
 =?us-ascii?Q?tqeaJad2AsK2D95Toy0Ny5MWcIJPHmvEMF5NdpFL4JUsQ9rJ/arvZhJhZ+Fc?=
 =?us-ascii?Q?t+ifqzIKVcjkOYmwBe0RXuCH5rIDYAHTvsHVQEUnOyfofgv170+TsORSiGlG?=
 =?us-ascii?Q?hlAF55IxlyJg7eGfghT0w1pnxJ5Sh+4I/JQkBQszKXXXXMbtRHXnD7R/ofG1?=
 =?us-ascii?Q?wSBiepi/YZitmr9ShDJf8dOunpqEW3X05kmFBijpiUzjxU+hpN6NQHpIb3oa?=
 =?us-ascii?Q?olwn05dWRwdvVs+3O2YB8qM+AUaivCuIkak5xRqzKtz3HXEfVdWZzAZKy2Sp?=
 =?us-ascii?Q?LWsexHaRGqGmLkX80S4S5ZTNOamccOabXOgCRnbgSQyI5WsaE3I1HG4LFd4Z?=
 =?us-ascii?Q?tkSOEXIgUeyR4+9IEbyM8dzSu/fSiBu7i0gVuqek5Mts+1kp+gonleh4dSDX?=
 =?us-ascii?Q?NhCpJX9mUYbNua5EpJFDxh8pRi4+TJf9bpTELQT9y4+kzqUe7HjPKKG8FJRy?=
 =?us-ascii?Q?+ckIH831L4ldePQbhG1Izc9uPBC/o9rn7B6k4IrNEmPpU87junyH46043cB2?=
 =?us-ascii?Q?F8UvRJXj2y7BCE2h06lJNlziyNCdXOtV97If66eqyMvt/JmTMSJpY251Kdbn?=
 =?us-ascii?Q?NZyRnw642DLKEDRolQC7XSAdNbE1DzZ5D8pQqi4vAhpg7Y69amjc8ltwohTL?=
 =?us-ascii?Q?rg8sML8YlVks1MrnVOIl1lirKMBgq8k1K5o8hGOYCozfqWmT14XlVFbx4hBa?=
 =?us-ascii?Q?FZnyBhjjFvtQzS08c3+3WhIfMzOZqhVnOSW7haegqyuVObR7qb4l67yGqqDT?=
 =?us-ascii?Q?V37/OkMiaO/y3IxwfdzEi0Kv2xtPPPP4i2o42uU6TAnFwUwkON/ehUcvz6gg?=
 =?us-ascii?Q?t6JHG/7+mcejOy8jvv0EYElCumHQLmDuPRNlPqIpon28YPyV+Huo2LJk0RZw?=
 =?us-ascii?Q?HDBFGTaj14ZyhtX+P8Kc3la6R7mNFVnAD6taPS0TUFFt?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AD87CC0145A06E458186C690FB77050C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?9rU3vxIQgWpjvhtgwxE6K9Ew3oiZInB3skL3X75asL/M+uzmR6jEdKEmQoLk?=
 =?us-ascii?Q?KOyV5sOm0ESic6sh1VSpQcfURFsNZifluRnuYWbmTfr0GwTqnRvycDX0/IW1?=
 =?us-ascii?Q?UZH+8APy0+RZmp1BtAEZioJC25PuQfrEWVQZbksYxeSo43lYyoPNhRGbD0bl?=
 =?us-ascii?Q?l4e8nT0wK4QGtJr2crDkzbM017R5APFxgfqCQKYabRAJI0zfLaB+yBMnYi7L?=
 =?us-ascii?Q?JH/uHIWeV5dzSKLEw1A4nS24hHVw9/YS5NJXQVTuMvRhKs51Bss8chMvpTCK?=
 =?us-ascii?Q?CEDEgNpr55o0IQbuAowC0pybYORwwdu3nwlGhpWqZcfE1c3uH7b8XV8rbAyB?=
 =?us-ascii?Q?432WykTX7e7soiw3nrNxydAf0D+WDQEHTPUlnAgX+YmwuivC8BgQHs6Aiptv?=
 =?us-ascii?Q?+9057MePAPUbCl8CcBs0Pl6OJ1mLNR6fcLfa2U+mNM6IUbR8qkn0YZknvCVE?=
 =?us-ascii?Q?69ROdiNS+eVnarc7bGlJ45ZksWPJgp4S6Xwj0K8WkWWohn+s8NyIdiCDrMVu?=
 =?us-ascii?Q?K3b/UTLk2J0mSxCWPMWxptbxWlpISIkM38vCCkamB2TkB9mGfv1Ktp+Z0fst?=
 =?us-ascii?Q?s/3looe0FMQ+JgvAiISVMseiBEylE4wKTqzeYwZWqJqMBjD5ORXjwIJYgoJV?=
 =?us-ascii?Q?ocVOHUZWAehD03jJGdvjo/iPRq5vSq4w6DBA+DSizxbAFdODEZtePCn86iet?=
 =?us-ascii?Q?jVgnlTKGznfZkMUmCg16PKJPiu+OWPzT2EFt4U4b/j4qVMVm64sVSsk9poSd?=
 =?us-ascii?Q?dST8HotKKIF22PDAawJz+9Xh0YPK1WhsxFmhwlFMCCzhAuu9ODWAxB736xMa?=
 =?us-ascii?Q?EC16pWw5r8V1pDJ5eJDp3/4Ev8uqmhV4RJ0Ae/zQGyFHzNC7N9o0xC/AMfTy?=
 =?us-ascii?Q?zdD4/jfEltSX2CZtnzwgZ8y45FJDUpHQ/JS0j1LLaC+mrqOZrtOmAm7arB3e?=
 =?us-ascii?Q?3Jgc/PIHta+i2/ZF4rbIIKA+SwhPEmpkz9pkr5tupGQVc8857q3m5ZxeP6jo?=
 =?us-ascii?Q?zETFOFOXdBbmrG7uqUYX1lxVQHFn074PQrX9dnQ54485jOhR106d6kKCY30h?=
 =?us-ascii?Q?BRpOS0aurfIOWHtN1StMDus464RtSw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e970ac9-e106-44a9-f6b0-08db32df744d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2023 18:32:31.3385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cVROXJYWJq6kw9C0cEbID2IjeTxkdzaDdni4FZ3duSSVFXyKXyVIbDxo355Wd2MNzzXRLZhEshImhlblFp6euxRIBI1OxBZxdbh8OkZ/z48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6250
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304010168
X-Proofpoint-GUID: dwMAR6ht2szuxVN6hBTSo-cgrgyZt5Xp
X-Proofpoint-ORIG-GUID: dwMAR6ht2szuxVN6hBTSo-cgrgyZt5Xp
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 14, 2023, at 1:38 AM, Christian Brauner <brauner@kernel.org> wrote=
:
>=20
> On Mon, Mar 13, 2023 at 05:24:41PM -0700, Jakub Kicinski wrote:
>> On Fri, 10 Mar 2023 14:15:44 -0800 Anjali Kulkarni wrote:
>>> diff --git a/include/linux/connector.h b/include/linux/connector.h
>>> index 487350bb19c3..1336a5e7dd2f 100644
>>> --- a/include/linux/connector.h
>>> +++ b/include/linux/connector.h
>>> @@ -96,7 +96,11 @@ void cn_del_callback(const struct cb_id *id);
>>> *
>>> * If there are no listeners for given group %-ESRCH can be returned.
>>> */
>>> -int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 =
group, gfp_t gfp_mask);
>>> +int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid,
>>> +			 u32 group, gfp_t gfp_mask,
>>> +			 int (*filter)(struct sock *dsk, struct sk_buff *skb,
>>> +				 void *data),
>>> +			 void *filter_data);
>>=20
>> kdoc needs to be extended
>=20
> just a thought from my side. I think giving access to unprivileged users
> will require a little thought as that's potentially sensitive.
>=20
> If possible I would think that the patches that don't lead to a
> behavioral change should go in completely independently and then we can
> discuss the non-root access change.

Hi Christian,

Could you take a look at v4 and let me know your thoughts, so we can start =
a discussion on that thread? Do we need more filtering based on user ID /ot=
her parameters for exit status? Can we allow just non-zero notification (no=
t the exact exit status but just whether it was a 0 or a non-zero exit) be =
available to non-root users?=20

Do other folks have any more comments/suggestions?

Thanks
Anjali

