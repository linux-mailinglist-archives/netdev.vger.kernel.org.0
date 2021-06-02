Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE693991FE
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 19:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhFBR4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 13:56:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64418 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229467AbhFBR4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 13:56:42 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 152HsMdl023756;
        Wed, 2 Jun 2021 10:54:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=dXxOSzlPq2jZF6Wr4l/4mwglCAf6/ddpp7Jmljy64Co=;
 b=SaEzhMR9zby/UbdHXqX6oxEM6NB5e3lk+75Xh+RQRmeJRzhq1UB7Cujqx6k2U7ZsDGZ2
 AL1Jx4dNxwG43QHLrGukgK5eBqnro/fNAEjDTK1ReSL2F9j2SRuSDz32Z+wd+w37N9j7
 3+4OkjppszCg/sVnG4dLMITVtdx3fqDBfLk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 38xby4992e-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 02 Jun 2021 10:54:43 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 10:54:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ft1tVqX1i42vXmJYQMUm2P9Uh5FCPDZjYBxYl2zABLHL/ALGoyWcnpogdee7wFm0Ee5XAQUVcRon/RZXR9H6mUB738aSYZXkCf0O5B/E1OfTZYOThCeo95pEo3w/i1EoE84nnsCiA3pcKWehg2L/g3O/+XGPFYHqPeA4WZZy/aZgmjqB0NnsdHrX+Qt6H82YwBEawb5KadC8Z0U91QRQZ0dhFl+UBOAgQ4NLY03rhmxxJu6wb9TqhrFuBZpMWEgPsuF0SkSS4G14EOUzQh0pnVtW7bo9F5FZZ1wTdUFOoxld9zXANAO88S85RmP+bea8PwnDd7zjsAVSBDALSQ1oWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSz/H/wHPWNRvQbQZRM77Ukmt7dzIdz98uEgQUF5SWw=;
 b=RdzWhZzCChRljtmsa4qakqk/hXx300Faxg7RrVWSKOKQ7bMHXkdafcAxCukiKYpfanI1JUsSaZm1rRmV+xqmBysAUNVOa9irmDo83SNYS2WVNEd6+z5lNo6c860kjql7sB6UW1psYXrS5jKmi53RmPyYSpkUv4cdVmiIeepESp1LOAb6Rd4W1FbAvP1CBGcwCErp4NsrLQOuP4CP9/iuD3YJYaQoeWOQcIxQL1dHswzmn79rgSbgOn/q4xulaFZ3N9L/EScOYitlWqKidFFZ6uwGGlOW9NvBlU+cYVj4QRoIXmmX/9VZJo+lWnh9iNbbEtFRuS3ydGenoOXIxUi+Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY3PR15MB4804.namprd15.prod.outlook.com (2603:10b6:a03:3b7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 17:54:38 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 17:54:38 +0000
Date:   Wed, 2 Jun 2021 10:54:36 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
Message-ID: <20210602175436.axeoauoxetqxzklp@kafai-mbp>
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com>
 <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
 <CAM_iQpU-Cvpf-+9R0ZdZY+5Dv+stfodrH0MhvSgryv_tGiX7pA@mail.gmail.com>
 <CAM_iQpVYBNkjDeo+2CzD-qMnR4-2uW+QdMSf_7ohwr0NjgipaQ@mail.gmail.com>
 <CAADnVQJUHydpLwtj9hRWWNGx3bPbdk-+cQiSe3MDFQpwkKmkSw@mail.gmail.com>
 <CAM_iQpXUBuOirztj3kifdFpvygKb-aoqwuXKkLdG9VFte5nynA@mail.gmail.com>
 <20210602020030.igrx5jp45tocekvy@ast-mbp.dhcp.thefacebook.com>
 <874kegbqkd.fsf@toke.dk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874kegbqkd.fsf@toke.dk>
X-Originating-IP: [2620:10d:c090:400::5:2ff0]
X-ClientProxiedBy: SJ0PR05CA0150.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::35) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:2ff0) by SJ0PR05CA0150.namprd05.prod.outlook.com (2603:10b6:a03:33d::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.10 via Frontend Transport; Wed, 2 Jun 2021 17:54:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 035ec6ac-06c0-47ab-e895-08d925ef7d5c
X-MS-TrafficTypeDiagnostic: BY3PR15MB4804:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY3PR15MB480418E4A87D7C3901E79460D53D9@BY3PR15MB4804.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ABpGFrutp4ywUZSx1R9yCbDT8SVm/Oiuef0ogUzOElk4g6IBVF8mQBlRxYXc82J88IOWve4P/zifBoIDplGbTld/y4HIDUCg/20dc6pg0gVaRXMMkuDOJzTuoMdaxydwo/yeqNJvf3NBDrjuWnG7ieh9AemoydlxFZYjj5//r7yCslz00yWnnc0EqeAmklxnBg9R2vPGT2A9RGtcbuCmZpi8RWWY5/zNSyfMM5ThMHKw/T7ZS734DDLr5eVXzOPojqy7nZkmg7BXZOQ3lg22FFT5jPXtUD8jjbs0GxUkbC6AgbnMfj/Rl/44/4XY9XVTkecZZZAevG7NQVHn5gKExiM67fpfzlJ7YqivJ0N/jXXtyAhtiTBE9i/M8S2TRa5RGPShrqv6es/Kx0+2/gST8sC/giqjlhQP2A+aXftHRroTTAJMIekF4pHNQxf3ri2FPe+CSueBnIYu4qaTWx+vE9Qiy7Ai8U4NdyO1CuORcR4lAwp+Kr+u9HFepHPfnpYaBQugZJjKyvCHthtZGOcWyNwK8xBzWaoYvw74i4XJRdTCh+elF8lcJ8fmCR4Th4N6sT/326z2cvTBnxhOyI1G1pBIUlDW9tXCeY8rKfLGjU8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(39860400002)(376002)(396003)(478600001)(55016002)(5660300002)(316002)(9686003)(33716001)(83380400001)(54906003)(3716004)(66556008)(66946007)(66476007)(186003)(16526019)(6496006)(52116002)(1076003)(7416002)(38100700002)(86362001)(8676002)(2906002)(8936002)(6916009)(66574015)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?Ey298V6XKdxfqET3aK1z+gLEV0scOMq5leJEqR8ECsf0YGIj8glevxqnbv?=
 =?iso-8859-1?Q?8mSUQThFvh/Xy9bdfDm1ruC6bAriIFfDbV4DpYj75VveQxBwwdnHoWUFtL?=
 =?iso-8859-1?Q?Sf+w9KReasAckyWzoUjqRUe4UWzHDmlZOQnsjTohPmiHCnp4eR1IJaMlsH?=
 =?iso-8859-1?Q?MVkni5UFl2383Ei26b6kWAcxJfZwqIh4ZWCiy6KDzcYSSju+mIBFjrUhAk?=
 =?iso-8859-1?Q?8XKa2eJc9m7rk1A1zpn6r/24ZwQwD5i7aep9PPgPq9dmXKzmzDs/ucdVyY?=
 =?iso-8859-1?Q?0QvhSORLKSvXJEnNnBT0OeDyofiPljJwz+sbGVpOnb/Ee8GguloXRGOkLZ?=
 =?iso-8859-1?Q?7fy+OY+eXtwDSAfeD7xPsujg3zKt0A+IhWYRVrQIxka7LUb/7iLe3ds08X?=
 =?iso-8859-1?Q?f6l78FO4U9X+2cosblVLj+ZgYQg8cHOcRK3P1+zcUl/X66WW1ZqcBbFtok?=
 =?iso-8859-1?Q?0oVDh6ujIJe6XR3eLP20UbWHDV8nfOcBgQBB2xME/y75m0HzRnC63a4zBt?=
 =?iso-8859-1?Q?AJOV2AFqdagejWL0rfC4Bhz4s1ztggg96CAXwpZhkNS5aqq4jikp17jR9D?=
 =?iso-8859-1?Q?ShjQK0UKJfiB9rYGUvGSPcGNVOYVXcdd4UTeQhbfKOlLFOtsbjmihQuThk?=
 =?iso-8859-1?Q?5EEihJ0xsJzhjkp8NHbKTxNaHXtgurfABXFVPwgwr6pFwfPMsu4BxGvGJ1?=
 =?iso-8859-1?Q?PAZxedOqe7lye9bOrXMAMIkOt9iZ1IDj0ELNCnTqtjUQ+9G/vQ0myTPiAy?=
 =?iso-8859-1?Q?3hjkxkpnvvbCFTvy+3ifvC47iB6Zcdomf2p5kscvL55TRtxkmeaht6E8+R?=
 =?iso-8859-1?Q?wPiWxF1qlJJrf5fnxSeyULu1OvYBxG4Y12KMpQIeteEeBwDmxqPhV/GQ80?=
 =?iso-8859-1?Q?tUrTNQyUEHZ2AoEIpcZQqcgjwc8OFjDh7nuxJNhtkR4NNdK4CzNhoAG7K6?=
 =?iso-8859-1?Q?XPcguv99sCGYrZkjlPAPo0p18B8Y6TJB6sVWcrWfl9w6YWYfV8I8nOpQgq?=
 =?iso-8859-1?Q?IvRGODQoO2xsr5lYRZXM3iTRVRcbkgwnesfP4yv58/9yaiy88G7VXjirkt?=
 =?iso-8859-1?Q?gHR5TefEQvuh56NyiUyMASOlEPhwnOwy4LUYTCcTbuWXriivh7GqPmY5xn?=
 =?iso-8859-1?Q?7Kl06/g7PcnSTzlacsD1XeA1eiKS+JGdK0IxhUhSE7oqtkUwcSSi8oJfc+?=
 =?iso-8859-1?Q?e7WXdfAhb5cUu0lEk+KV23DWp32xIM47JS+rt4r0vJPqCteKOsA4TCEY5O?=
 =?iso-8859-1?Q?U5ArT9iSdH8X552q3igCGSCk8V0qI110HC0EjC1Y36YU7Z8FaF77oWSmiB?=
 =?iso-8859-1?Q?8XQwOjyuqXup96orpp0YfnDBNkT3vbiO8ZkNlH1AU38fKI+Lp3Xau51zUD?=
 =?iso-8859-1?Q?rLHuPoAAymwJsypKPfPp+6EQE9XJDvCg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 035ec6ac-06c0-47ab-e895-08d925ef7d5c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 17:54:38.8443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /EAL/zaJfQeU9XWv72Py7MbsqfyZt/MK3lpy/P6Q4LwCiUBiKIhcqNvrbuKFPQMw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4804
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: cMNI99tfLZS5XAbCr9jVjF3c3PL7fI6K
X-Proofpoint-GUID: cMNI99tfLZS5XAbCr9jVjF3c3PL7fI6K
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_09:2021-06-02,2021-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 spamscore=0 clxscore=1015
 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106020114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 10:48:02AM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> >> > In general the garbage collection in any form doesn't scale.
> >> > The conntrack logic doesn't need it. The cillium conntrack is a great
> >> > example of how to implement a conntrack without GC.
> >> 
> >> That is simply not a conntrack. We expire connections based on
> >> its time, not based on the size of the map where it residents.
> >
> > Sounds like your goal is to replicate existing kernel conntrack
> > as bpf program by doing exactly the same algorithm and repeating
> > the same mistakes. Then add kernel conntrack functions to allow list
> > of kfuncs (unstable helpers) and call them from your bpf progs.
> 
> FYI, we're working on exactly this (exposing kernel conntrack to BPF).
> Hoping to have something to show for our efforts before too long, but
> it's still in a bit of an early stage...
Just curious, what conntrack functions will be made callable to BPF?
