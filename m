Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780F438039F
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 08:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbhENG2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 02:28:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16202 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230059AbhENG2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 02:28:01 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 14E6O5XB013923;
        Thu, 13 May 2021 23:26:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=C4tq7LtSbdwa89O7zK7jKIvDhnJxt7iI5RVcO6yu7Go=;
 b=OaAUh+ZQPSZthThYX1zfLniS9eHHG3W4zgY6JgUdzFRtXRiYMMZi2MbpYCK46FoqMvFV
 DtnnrXs8uotscOTo32fklD6zBUZ2OT53EE4NnFJaFQbQTdEsds9hCFpcPE2Wh+LRvvvh
 kVnXmp49VLS6vpSSYnRcBxc4eai60vj4axc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 38gpnhrvc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 13 May 2021 23:26:32 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 13 May 2021 23:26:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HsOBBaWH0MbqwL9evn6JNe4oEXjRuj6DkcDEzhh2LIUVOmlaxCxdiZn4CO8mCOCCj95WFy1VyrpwI7twmqcfF8x+U2NOS8QCQEZimSc6tY5rYaEQOj5bkqMHgSbaQXHM+0z8UqJV13T/sWX8igrZcamIsHSpYGaCnsSkYZY8X62dnYo3yNH9EWFixgXIhzojO1sS+UpmO6seqFHMWJVGWEJQ5ZKAzJNMuuwFsIXlR+bbDDkb4XUIleZdSIcnur8R0RC4eYqAEmonVD+PKWNCN0oH3Kkg7hEjIlqQXpF11Yr7fnmD8/ZmRlLUujM4F3E/tfIm2K5OP4uYkoV+OHBnyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R1WmiBKQFB076qV6YnSgtLTRPbYO10P60cSKHGiGTuA=;
 b=SwTIUtUbS+1LdjWvARKJ/TL1ZgFoVYx8DF0z3/1gCHFQft1hck9t6qNLMSFovtYdFZV5NYgeP+OzrnZ7ULfXfwl5JdyNwlfiuO+IMV6vFqS5SHazA/c1AF/qG/6hq9RYNMzod2cOxMRyg/VG3wL34Sx7qO52POv6cpepDVK84DfnBi2vvlA+hHgFXKMOP0Ga7sIeMyYOj4fZIlbJuK70W0A0R+Q2IG/583Ck/d/iegurH55cSjbpfQ/3yjDkMUkZJWK7ZBVZJZ1IdCSbwArGPwbikZEYT7WiAL461zvAzmxy2TOr824S+HfG9r12mMqXRmxCN3+dIAm5C+Z/yZSOrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by SJ0PR15MB4677.namprd15.prod.outlook.com (2603:10b6:a03:37a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 06:26:30 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4129.028; Fri, 14 May 2021
 06:26:29 +0000
Date:   Thu, 13 May 2021 23:26:25 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <andrii.nakryiko@gmail.com>, <andrii@kernel.org>, <ast@kernel.org>,
        <benh@amazon.com>, <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 00/11] Socket migration for SO_REUSEPORT.
Message-ID: <20210514062625.5zg626xquffvmrr7@kafai-mbp>
References: <CAEf4BzYumt7BO1BgN8kLXZmbYXuJweH0bWiT-CiDRQfvaRg0kQ@mail.gmail.com>
 <20210513232300.30772-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210513232300.30772-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:8b18]
X-ClientProxiedBy: CO2PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:102:1::14) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:8b18) by CO2PR04CA0004.namprd04.prod.outlook.com (2603:10b6:102:1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Fri, 14 May 2021 06:26:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 444c82cf-3f08-4e9f-ac12-08d916a13591
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4677:
X-Microsoft-Antispam-PRVS: <SJ0PR15MB46772EEB43A22EBC60B3A7B2D5509@SJ0PR15MB4677.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: beYL2xSkncl4Y5pGgD8FG37GJt5ilv4UX7rsHQN5FdCPaGMhDRCc3PjLBODD26AGuj21LUruiAU6KfZRhAXwpZSV8xx17OD2yrjzMztlGleQbD0nJ4v9YA+CUlsffeewpNoyaR4TBSWLc2n3Xe/f8abgWpL5DNCcJc6dU0To8y18Ksxd6/FxrR1C9OdqEdJK/yDPyZZ38XSYrLzIMw4EGRdfrMWkEnrpiKO77/nNL+KxGeoJv+KswjOq4sD7bZQokAXfMYujsqZmlsQ7htvtu73JVelH0mwwZk3ky3d8e/JED70rYNmmuLsxKrg6LCWxdd4B3TeVM0Jr0kI9s09X464ksknePiIlucdsVP3hd9fAaAJyyy8bOrFwI+64xJuOmFhtp3VvSQh6/gxO5W5fW5DHRtK0SjgLHuJyB01wrqGP2GIRm15TI6i9gk6a1JisID4AI6cpjURbuGDcvxp+TUGGlekL05JGzdQPpyNkeUDixvRVnui/F1Z2UnRwprSfT/uZIJcDQ8GOt2kn8lEsvanKM8ev9B+hJe/RCUL6JaJxQA9xs1xLtHE36c76e14w10+4XRzxYdIHuXNDhm42uh6Yv/+ThzUyDnCWRljGAXVi2HwXb93GDN9OJ9dn+Yvknhn7Jqmho5CRdNLvK9SBcpNePoiO5T8ge7yfIFeeq7k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(316002)(38100700002)(6496006)(1076003)(6916009)(53546011)(83380400001)(52116002)(55016002)(9686003)(66476007)(66556008)(2906002)(66946007)(966005)(7416002)(478600001)(33716001)(6666004)(8936002)(5660300002)(86362001)(8676002)(4326008)(186003)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Z5O1PXgL5J2uF8W4SVXJ+RkMjhcByfhuW/uy8V1nji6Pl9A5T7n/XPDRmzkL?=
 =?us-ascii?Q?h7XnZCU0wWi40WNTuSKH5s0cxBu+Du96IE8WMnAiRjg92sq+lPwmZm0b1NYi?=
 =?us-ascii?Q?AAunUrBaG2Oox0QlbXwI7crmOgFnqvKvHXmx4+7TqVUJ7Or45eHNMrSMaQaV?=
 =?us-ascii?Q?noIr7amU5uVprdJ+cPCdFVXgH8p73GPhv+k0DdMM3i2Y53HPxSTpOO18Grw0?=
 =?us-ascii?Q?zIwCddblW0IPd7wb/1NFVUAzb4qSG3EI23xkVnzqwE67vGEZ/9ds7whK/rC1?=
 =?us-ascii?Q?KlK43Lr1/kiG+aTmyLr2kTMCqM2ymaQN/rhG04Uczgcf+qhliKr/cgXYu0hi?=
 =?us-ascii?Q?DNn0dsq6YVIq4rGmXd5T6XMzYoUUZmLscpNzH6Lr1/a7iSK1dJ5EM5Nbjs5J?=
 =?us-ascii?Q?1liyhQSnJUj1HdlRUXkMgaMjTbioPG87+HXOuiOW7dwGNd3FpiSUhEByZyzi?=
 =?us-ascii?Q?TXTC+iUE8YArbXo0vHEx3+6dB7FA4E4UwnpLuRnRBB2bbto7PysyhQt7cLIr?=
 =?us-ascii?Q?JX1ZO81QCu6fyuWFj2mFTnzlgWnxR51oYa6mKg7SLIGgwMccqZChw7bA6Sbz?=
 =?us-ascii?Q?C4xZ/j4lmiJjLad7JA2yWTdE27jrSSQPyjOmzbExLMIb5i8Njek8PlrJlEta?=
 =?us-ascii?Q?fcFBrcdEYlmg3c73ChDmpshpM1KDFkz0/1H2pZSKMDcQBwJG8xSq06xAUQE4?=
 =?us-ascii?Q?fnyvPfPS9NOWKL4GIi+SbnCfhVyYMg3AhPLPQnfP1qENWKhXmSJtRy+aanNP?=
 =?us-ascii?Q?+Xaj5DrUnMtTP5yywQdckFYWObN7AHcfwZ8PkAHhFQkWLO9Jv70EMSO9eZPj?=
 =?us-ascii?Q?srI2iCFENkxJ3hfI6ArRwgf7Ta2+0lnQQRoESDagIJYulxJOq46UxyNdHCtx?=
 =?us-ascii?Q?tib1CZQ59kB7r+iVSLI4xktrL3iCmPQ6RUMAtparQyk330S60VB6rp0BHNeQ?=
 =?us-ascii?Q?Cuo7nE0VJ5rRzTPmLhLKWINn32XD1PKV4KtT0YGtTyT9qvYYjq9bjZYqXz8o?=
 =?us-ascii?Q?HhGPaHDy/lYVYNtFBJOKsJOWkzvVM4DN0MoRWBFyxWwJQkjSl2M1NKvkTYyr?=
 =?us-ascii?Q?xiFCocTTbARxW1KhgyA65MdXG5PVevMTTB96bXdF3fYUG7MHk8MJKwLK3SuX?=
 =?us-ascii?Q?X9B5KK8WSTz44ok7WqKDmZTURbhuX9euopkTXd/65lhqxlkOD4uC6oyEy3Wu?=
 =?us-ascii?Q?3qUVO2BJ+Rbo3JPF40//Eu8Wqa+rYOslFGObizykktMQeONQwRO1TL97pfiL?=
 =?us-ascii?Q?FxR3rC/aNM6vcQUF4rKaO7MUMAS2vEbIuyMCdEtCXitwg8XxaeVtP48fzWa8?=
 =?us-ascii?Q?RY4HUw9bjUzF5GnKOn6yogmBduWO5VCTXQR4Qd/jYMO2tg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 444c82cf-3f08-4e9f-ac12-08d916a13591
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2021 06:26:29.6969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ft+gekZ0OM1UIgpdan2pzb3HXU3RKJA8JkHmveVpcM4882+RCPqIhg1WM6tFHqmk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4677
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: VPiWDNhANzK2sakD6rFFOWxd0TcJR2IQ
X-Proofpoint-ORIG-GUID: VPiWDNhANzK2sakD6rFFOWxd0TcJR2IQ
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-14_02:2021-05-12,2021-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105140046
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 08:23:00AM +0900, Kuniyuki Iwashima wrote:
> From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Date:   Thu, 13 May 2021 14:27:13 -0700
> > On Sun, May 9, 2021 at 8:45 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > >
> > > The SO_REUSEPORT option allows sockets to listen on the same port and to
> > > accept connections evenly. However, there is a defect in the current
> > > implementation [1]. When a SYN packet is received, the connection is tied
> > > to a listening socket. Accordingly, when the listener is closed, in-flight
> > > requests during the three-way handshake and child sockets in the accept
> > > queue are dropped even if other listeners on the same port could accept
> > > such connections.
> [...]
> > 
> > One test is failing in CI ([0]), please take a look.
> > 
> >   [0] https://travis-ci.com/github/kernel-patches/bpf/builds/225784969 
> 
> Thank you for checking.
> 
> The test needs to drop SYN+ACK and currently it is done by iptables or
> ip6tables. But it seems that I should not use them. Should this be done
> by XDP?
or drop it at a bpf_prog@tc-egress.

I also don't have iptables in my kconfig and I had to add them
to run this test.  None of the test_progs depends on iptables also.

> 
> ---8<---
> iptables v1.8.5 (legacy): can't initialize iptables table `filter': Table does not exist (do you need to insmod?)
> Perhaps iptables or your kernel needs to be upgraded.
> ip6tables v1.8.5 (legacy): can't initialize ip6tables table `filter': Table does not exist (do you need to insmod?)
> Perhaps ip6tables or your kernel needs to be upgraded.
> ---8<---
> 
