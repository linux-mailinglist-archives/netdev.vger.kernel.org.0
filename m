Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A46B3B6B80
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 01:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235463AbhF1Xoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 19:44:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17740 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235368AbhF1XoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 19:44:20 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15SNY6mj006286;
        Mon, 28 Jun 2021 16:41:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=9+NFJ9KtblpDl0TPoiMRuiYxTyOh4kP3KIMdS+KNgUI=;
 b=g4aV46fUyou+2UioTy46VpcdfPlN51qy6bqvL2oowEKqcnHszPY97ehLjBs480gpby7s
 9hnJNbgGoml1ASXUJkHcDNvGOWHDi2hAsC+g+e1aANQWvFMpxKZ6t39ssFilCIuBvjWS
 lt4FqYR2nn16QhPPHtj6GnjbSwD6a2rG238= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39embt1ufr-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 28 Jun 2021 16:41:31 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 16:41:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2OsXsQBmql4xVV8rAsvkW3f4JJril0UHSojB99kcexOpHlbO+GHIw/SaRYCDHvhilMLg6y64+FnzIZnPjnGA4yXeoAc4amwYdyQK9Nexk10Wue9BPy3K2L8Ton3YGqW3KgeL5q5l6o+MCRJ7oCYeczEsSkhQ76JueI/wt8VD55DmgbqAUJgTatOjUXAaM3R7+Lu9792PAZNPUy645632DDvCKE4oGiXHOLg6Z8fRl1tuPdPT5MCLu1Ss+qWirphFqi8KIxw/dptynyqWTx20d5UpG877j8JQGuTyMfWa+06pdDAsMfHNp0yRhgARve+kErsVatdjMbPfMDEcoOj0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHPLXyHY3DXbpCNG9AE1DqGbXQ9H8aaczBtXPcdT5Cg=;
 b=Y2fnf23EwZb/ekFglNn75DG2tZfJFSWO0ooEBzdhj3OpDQz6qeSTPgI6wVu8GwjG7xJh8WPsswm9haN2qRtgTahKXPYfOlQauqxcW5umltUJhx2ILE7ANkgvt/abTGvt+X9RZb2G6xvFYXAWDxiFvCwvJ0FVuAgzJ0baQ3/CYEawsWvgBXvhf+wBFtuZR1RkRrFk+YWLXtyK9ATcT7+suRbXtTKL3ZxruEyHW++jvZtYDP3/6hAXGq2CW3omAPDcRr27fzjdrSXg1Fzg+YTXiHI1anidcQOk35KCno7h1zhBrJJdv4BmbIWWIpD7ta4WoJ7AEhqxGmxdP5pdjkWiOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB4013.namprd15.prod.outlook.com (2603:10b6:806:8b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Mon, 28 Jun
 2021 23:41:29 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::803d:ce17:853f:6ba6]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::803d:ce17:853f:6ba6%7]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 23:41:29 +0000
Date:   Mon, 28 Jun 2021 16:41:26 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Phi Nguyen <phind.uet@gmail.com>
CC:     Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        <syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH] tcp: Do not reset the icsk_ca_initialized in
 tcp_init_transfer.
Message-ID: <20210628234126.ijdbstfmlsycbqbp@kafai-mbp.dhcp.thefacebook.com>
References: <20210628144908.881499-1-phind.uet@gmail.com>
 <CANn89iJ6M2WFS3B+sSOysekScUFmO9q5YHxgHGsbozbvkW9ivg@mail.gmail.com>
 <79490158-e6d1-aabf-64aa-154b71205c74@gmail.com>
 <CADVnQy=Q9W=Vxu81ctPLx08D=ALnHBXGr0c4BLtQGxwQE+yjRg@mail.gmail.com>
 <ee5ef69e-ee3f-1df0-2033-5adc06a46b9c@gmail.com>
 <CADVnQynqMQhO4cBON=xUCkne9-E1hze3naMZZ8tQ-a0k71kh8g@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CADVnQynqMQhO4cBON=xUCkne9-E1hze3naMZZ8tQ-a0k71kh8g@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:170c]
X-ClientProxiedBy: SJ0PR03CA0361.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::6) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:170c) by SJ0PR03CA0361.namprd03.prod.outlook.com (2603:10b6:a03:3a1::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Mon, 28 Jun 2021 23:41:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a8215db-7c06-4627-1ab1-08d93a8e4046
X-MS-TrafficTypeDiagnostic: SA0PR15MB4013:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB40134DE9B6D3A15301EDA47FD5039@SA0PR15MB4013.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C4Mj9RkI/ImIhx6G4Nb2t6P1gZGdi4Md3Bnt+sVn8TM9QfReKS/DTmu5TimXoiP86nlUHqeJESpE7yWWxHuGXoj9gkNGWGzBSNcXKHYcLn4PLbqqJ6ZlJO6AGd/FDcWrwXmPk3ubXZPHMQCD+jL/VC9KYg7FCIl+AL6SSac5WqvZqpv6TZ6Z9NSguYQmSvmJde/awek74ntFhj/8YEbAL5ONnWHV09JgStCxnfN7QxyVK9TMhTYNFz0s9t5hkJkBbkAZiUDWuPCJuD4WCO3V0Z3NeSYSDTC4p73TlpxshN6TOPG7Kz+Cr7TcF9K/dUnXBoIYHf05YW/Lea1Y5mj2ROQ7+iIuhbJrefVZx4JOUxYnVfEloNIQJ8eFJsvB+dNJsMe89sLJJ/6vhnkFZkgdZlY0WuTOY+j717G3SGvQ3+0MWmjLyLIXG25M7Hsd7hKC00f4HjBsF/0o7Ux3Zwl+RYcIkvCACniPxdRfsuXeCxFh+uElo4SZ9vqR9Hz5u3+VHtJn49ZPKUVu9aSPQ+9pZCXArolZxW2y/1E5P7B0p0ofRT9NnzpKb8Sstb88AFH//OhRxcVEITvOVNDisxAFoVSBzbHfY6RNmjvWZtpE+1pXXoUg0PTZYFGr/WtModwpuIuMDKb/J+R61BRph+yVPYTsbaaXd/mloFWTBq6ekV2A1ARYv6JbuG1B/9J8NYFGHPA/Aaa0OfsyeTTAsY9aBeD/BxEWxaKuYnAv1/y/Vhr56xqD++RQORE44GwL0YH2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(8676002)(66476007)(66556008)(66946007)(966005)(3716004)(5660300002)(1076003)(8936002)(38100700002)(6506007)(55016002)(4326008)(478600001)(52116002)(316002)(6916009)(7416002)(86362001)(54906003)(2906002)(7696005)(16526019)(186003)(53546011)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yN8Sj+nceTgtuGZ0q698ecYj54IMUYEjNo1cprENttpmPSGYAtcRYEOWt8tJ?=
 =?us-ascii?Q?I9jSTGYP5LN7ORw1OmaZsSqp7TBzqOg+H3R3X5nf5wa8RuYTkGMNWQa99+oM?=
 =?us-ascii?Q?YiO8u8M8uRXzqh3+XZ/2NwKXDiqC8Tz8vFNgA4W6ptC9IWpQQwzGllI9VAxD?=
 =?us-ascii?Q?G18beyXr3S5ntxilsI8xIRSnqdJWthCnIrpNj6G673yye0jCTssd0dzeOF01?=
 =?us-ascii?Q?psKez+DhD3kztRjxbeJC7JWa9Tx2ahngDwM3YgeMWgeRBxFm/C+voZA2V9jb?=
 =?us-ascii?Q?nvZifeheLrVOZ+7e1YIDJNOs8CfmMSt+SrGrOElc1MxDDry30My8m5HUHnMh?=
 =?us-ascii?Q?jdrOH30Y3U8CKuwDH96VhoFQY/PXLgTtJPGD9F/Fo5YX2sTo9P/zQhGfaCM7?=
 =?us-ascii?Q?83uN7pfOoNTesrI3nCJcMRqJl/S7T7Dkb6ZRFvpFN1Pkqrck5sNA/+liqQxH?=
 =?us-ascii?Q?C5sjYP7aCUqjmvc60f4g1sUkupFs0MwZoD9G9E7ltLpeoCDOSJlfhICFBINR?=
 =?us-ascii?Q?UMvxY/lnTn563ZN+K0Kz/la3ZmkRtkQEdi9+igauph1Y4c1TAuxmkJzFvnL9?=
 =?us-ascii?Q?+wRgFDB68OVbp++bPJ/wQG1Nht7v/Vx1saKSnruFAgI5NLWpPY4w8mCTSYn7?=
 =?us-ascii?Q?FYeg4Pb0o2LyBIwvENIfX/qWJHFk0CNrFoMM6pS5XDMdrgqX3y/hKJgqKvqA?=
 =?us-ascii?Q?Uul1YFJw4K02rKYYfsfEsdSoD3Ai0aadO+u42aN9S57msFSl3nE1oJlmj7tu?=
 =?us-ascii?Q?KRYySpys7Tf2v41zlO5eGldDqpAEx6Cm41eijqMf2z27BdLvJefef0LDD7V9?=
 =?us-ascii?Q?9O8ZbBWr93Z11bLTYd0dfoZHHKIpGpPYnqiucOUvCFhlvf6n+Do9TNcry6Aw?=
 =?us-ascii?Q?gHGoCAdn7F+uVKQBgbcFOHGXkKHoCRk3hybLXsvrycuUQCdoUmhhgq7ICnn/?=
 =?us-ascii?Q?X4C5uFECv4TEhYoHks2ifUCZHm4GWgrv2jB0Em2pMNvrh0d+VaL1ZvlzbdKN?=
 =?us-ascii?Q?r08Rse3l2o09Qi3c7O2n0mK28Cam225v4+HcxqN/ZBLtik+ODFrzz8b5fdNI?=
 =?us-ascii?Q?tzZyKliRvQzbuS46OPfEAiH2THceeQmZYGKqswjCloZ+AxWOxJi20fUCHtBN?=
 =?us-ascii?Q?IkzFOE9zXqvJaXGF/Dyns3AugBQlhwgZ4jHEB7ffU/I0lpOnk7tZCNUSXxAW?=
 =?us-ascii?Q?5Bp48MlpofmkHrdckO1aESsYuKmY+Xh9ldWKx/l3TU3XUkKy9thHMq2g914Y?=
 =?us-ascii?Q?zxklmuyr9Eaa9yFZKgWeJkiwDrmLNJYUBYXfSFQOF8BNOJV0Pz2XUbM7UbV6?=
 =?us-ascii?Q?WsO5Oi1aUiMmycOvRaSJHJZl6SU0Hk9dRqX/3hKO7PbYDw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a8215db-7c06-4627-1ab1-08d93a8e4046
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2021 23:41:28.9760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WlPPFf6kx2TLbbC6UZ3SmvW+02r4F4om4U5PEXoZRPcq5BrwmXkH4HY00h003IyB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4013
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: WygZp_tpxBGjIcSB5Auj0fuhRkBJADPH
X-Proofpoint-GUID: WygZp_tpxBGjIcSB5Auj0fuhRkBJADPH
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-28_14:2021-06-25,2021-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106280153
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 01:20:19PM -0400, Neal Cardwell wrote:
> )
> 
> On Mon, Jun 28, 2021 at 1:15 PM Phi Nguyen <phind.uet@gmail.com> wrote:
> >
> > On 6/29/2021 12:24 AM, Neal Cardwell wrote:
> >
> > > Thanks.
> > >
> > > Can you also please provide a summary of the event sequence that
> > > triggers the bug? Based on your Reported-by tag, I guess this is based
> > > on the syzbot reproducer:
> > >
> > >   https://groups.google.com/g/syzkaller-bugs/c/VbHoSsBz0hk/m/cOxOoTgPCAAJ 
> > >
> > > but perhaps you can give a summary of the event sequence that causes
> > > the bug? Is it that the call:
> > >
> > > setsockopt$inet_tcp_TCP_CONGESTION(r0, 0x6, 0xd,
> > > &(0x7f0000000000)='cdg\x00', 0x4)
> > >
> > > initializes the CC and happens before the connection is established,
> > > and then when the connection is established, the line that sets:
> > >    icsk->icsk_ca_initialized = 0;
> > > is incorrect, causing the CC to be initialized again without first
> > > calling the cleanup code that deallocates the CDG-allocated memory?
> > >
> > > thanks,
> > > neal
> > >
> >
> > Hi Neal,
> >
> > The gdb stack trace that lead to init_transfer_input() is as bellow, the
> > current sock state is TCP_SYN_RECV.
> 
> Thanks. That makes sense as a snapshot of time for
> tcp_init_transfer(), but I think what would be more useful would be a
> description of the sequence of events, including when the CC was
> initialized previous to that point (as noted above, was it that the
> setsockopt(TCP_CONGESTION) completed before that point?).
+1.  It needs to first explain when was the very first CC initialized.
