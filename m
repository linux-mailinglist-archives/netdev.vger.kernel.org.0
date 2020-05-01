Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806821C2075
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgEAWQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:16:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40088 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726045AbgEAWQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:16:34 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 041MEAwU032196;
        Fri, 1 May 2020 15:16:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=+EbVcgh6/SZCwmKsNQ2iGg6yOKvIwmxCN7wgESDm59o=;
 b=llpVpFJuQet6lT24mSSnyCwMHyo53zrgusyD6NPOrxSJPcfDNEQMil278+ZiA+0BEEHp
 opmko1+5hpV0Hue6xHMF2NukPmGR0YEQwz+OCL88ZQ0gfu9nypruuoOD7RSA4+tIgfRK
 PBVXZ6iytBJUkWcy5qriwp16rva/4SQ+b/w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 30r7ee639v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 01 May 2020 15:16:18 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 1 May 2020 15:16:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fp6jRVzahuG4zFBiUvjhZza7vXnMv73vbHm1aMPCttY0puHmNTRrjrWbCTWuSv/MG61bvfS3dfxiGFHMNvY8PZUU8832I6ExutjyBtNwoYfk80k1JLDGFm+JAgEB3tv0FgAp6FWAm5Cz2lx/ki9N4QVRYi6lv4PExsW4wqI3Ir9KMZcZq38tsaaTqpDWIAyJgFU54S9vFoPqewckbrguJGtng/++IpK4opv4fE5rramsYur8kMqabsimK+5odpREPfVUG4iS4QkaFj+AEVf+VufiGxfa09tyERYMSYV1pStEybDDyu9MQm5AqjwkiD7z/B+V2xZA+U1W841+ZakpGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+EbVcgh6/SZCwmKsNQ2iGg6yOKvIwmxCN7wgESDm59o=;
 b=QbfQIn7qfNgK7Pfx6whSyG1U5zGWHlOGZLnAKUd5wTVJQKs5H0vMOVJEKdefLr3Jqa4wUlfNATfSCY4X/ctQENRkwEI/RnocccNg0XDxtcDc1mn0dXeZtD4q5En31vTEYDeoK8BjSdBqP4loaMLTqybp4WzvzOTdVjLirLZC5uLm+18Q92tCy/5HVBXfBgLyylLYMoKohXQfQuPPgl/gTHZhj/GIzZqpHLvSAAoog3mqUGkkjqhwa6J8D/4ASKd/k56i+kQ74KIHBscvz5SrwhQcs92kXWe6gy2irnieBUkN4IhrJ1K+MT/qlw23xBSrDyIEMcDKvxmyxGxXF+XXRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+EbVcgh6/SZCwmKsNQ2iGg6yOKvIwmxCN7wgESDm59o=;
 b=hYZa4DlHpVioQIqyP6drLuyOIJgZ7uMPQax0/grGRPZ5nlJlTy+oIgpVgMpemCb6VftKuAvtDrfKxSiZfKnzTD1s/q1vDH9QLIxMr+W/pAB0GLfHe/sHapUN1m1b4J0OhmVFpsYoG2QlmxAsRdKjgTl8dx7jEuSWmo4FIcd4qMw=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2871.namprd15.prod.outlook.com (2603:10b6:a03:b4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Fri, 1 May
 2020 22:16:16 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2937.028; Fri, 1 May 2020
 22:16:16 +0000
Date:   Fri, 1 May 2020 15:16:15 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v3] bpf: bpf_{g,s}etsockopt for struct
 bpf_sock_addr
Message-ID: <20200501221615.GA27307@rdna-mbp>
References: <20200430233152.199403-1-sdf@google.com>
 <20200501215202.GA72448@rdna-mbp.dhcp.thefacebook.com>
 <CAKH8qBtcC7PhWOYLZKP7WeGjP4fY0u_DRQcDi51JkY2otcRYiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKH8qBtcC7PhWOYLZKP7WeGjP4fY0u_DRQcDi51JkY2otcRYiw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: BYAPR07CA0106.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::47) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:be22) by BYAPR07CA0106.namprd07.prod.outlook.com (2603:10b6:a03:12b::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Fri, 1 May 2020 22:16:16 +0000
X-Originating-IP: [2620:10d:c090:400::5:be22]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da9e04fc-b57d-4773-3c74-08d7ee1d4443
X-MS-TrafficTypeDiagnostic: BYAPR15MB2871:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB287161264984BF91AD7BED7DA8AB0@BYAPR15MB2871.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2RT629dmHIjqhptR2ULvVHJdl2NDKg5RHQid+pKmZMH9NM/Bc9P1T5QUC4As8Fz3nNhUfVAorGvbPLhJtwCA3lA893Ww84vXMDZehOPKxv7fUoKRrwZtmMH7IhBZUdFfG1/hxS6UwsyaWu4jxyeCKhyCQFmDtsPAZ2Ns13JB1LhWDC6I0+w9BvJKhLHN8Ts5+23rzxjLKRePeMZhnJFiZgzvYRmFxwTYdGp28Tn+m4dyjG/LhNJxRYcVzeWjeN/jbi3fJNPPQRcJJUCk8xXZZyQc6AxdV6GZTQhov5Me3U2X4GUlWrsPEJjfXhyWujxSAWbWmdAvUezDgZh51LzCd64UQJPDZ0KME0bRqVJ87DL+C2xIkWEd2QvNJKcNV3YWb0umCSux9Tlcfw7PVyY4FFYZa39ZrMoTpH3L8EYe7ahzcsB1amIqwg6DsGQnuRLbkX9FPwJgSa50TPDW/skGlb7xyhd5w6k0TvW2eGxzZb4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(346002)(136003)(366004)(376002)(39860400002)(396003)(316002)(33716001)(54906003)(8676002)(4326008)(2906002)(6496006)(6916009)(6486002)(5660300002)(52116002)(8936002)(1076003)(16526019)(186003)(478600001)(9686003)(33656002)(66556008)(53546011)(66946007)(66476007)(86362001)(142933001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 80wSE1Q8k3peu7nPL5GO7WWyE7eXM+cWZpQ6WTRsS6KtX/8iJWqfwkIbs/GBDSvL3v3Uxr+ItzNZQI9HMxIeQ490o5dsc44wh7am9M6sDTDBgdd+l64QYcPhc7GA6iNsjfNjvV9RrzE8ZO7jQs+6lqAIphsr8Tu3ePOojQ7HaULT5U8FLu+XsoRdgptfqWfFg6LIXFLFGlzzzZHDzKevRaZOG+89sKmzuDPQ7ZqvScGWw5z3LsC3J+F0jbSiCJBzzTcU0BJO5YeAmaBtml9pz4nHQW+lUTBMTkKqgOYgRAwi6dx9vukIy0Hhnyi/KtVEwT28ePDTREwb9cVFitJVTJ2o1UsjJFRPeONvaRmb87kl9/1V0H6PdvtiP7ffRMDT+1N4ahakWmsUoJCCtfPlxcZ0Uq1v4dnmFa7Z8NihvvKZSEjrs8QPZTXEUCZRQzl7aTM0v3/8KwQ3n4FbY49VBkfYsCRy9nn00I4xIEO2ZpvkphqGrkzUSYsNqNgL++fBAHnsEYdlveCeKq3cLZxbA3BkgysD7N8xXlg8ct3djgqB+Jn/BJPMD04jxM5zvblI5F8kxs7TAnfIxXiVquq9CdNm0TR6jiYUozeM1k5L0+W5EURiE+M0KIrQCNcWeslZnz5RBFmWx3bE5WeapyXrSmKbIwrKgS+yrvFjc39EVLG8gTvE9T3fTOmzOxWdnFQxuYmNhuO3WR9p9XXwHVlluOZKrO9EpDgzI1NTKgGlOTgDGcGrNYl/ueTUCZJTzgwU/34xn/KTSWl39dlbClyKTuG2tcSfbz28TFZkxdxDA/3UOuZqQyr4Lyj3gim7xp1zk3dzAO65ZBYoDiZH7kOItA==
X-MS-Exchange-CrossTenant-Network-Message-Id: da9e04fc-b57d-4773-3c74-08d7ee1d4443
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 22:16:16.5532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hzAOfT5rcmZx2UJmy/L8UDI+KAuQEvw0R4Cw3QmB44kLLCJi/xdtMXqpVT/RvlJG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2871
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_16:2020-05-01,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 mlxscore=0 impostorscore=0 adultscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxlogscore=999
 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005010155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> [Fri, 2020-05-01 15:07 -0700]:
> On Fri, May 1, 2020 at 2:52 PM Andrey Ignatov <rdna@fb.com> wrote:
> >
> > Stanislav Fomichev <sdf@google.com> [Thu, 2020-04-30 16:32 -0700]:
> > > Currently, bpf_getsockopt and bpf_setsockopt helpers operate on the
> > > 'struct bpf_sock_ops' context in BPF_PROG_TYPE_SOCK_OPS program.
> > > Let's generalize them and make them available for 'struct bpf_sock_addr'.
> > > That way, in the future, we can allow those helpers in more places.
> > >
> > > As an example, let's expose those 'struct bpf_sock_addr' based helpers to
> > > BPF_CGROUP_INET{4,6}_CONNECT hooks. That way we can override CC before the
> > > connection is made.
> > >
> > > v3:
> > > * Expose custom helpers for bpf_sock_addr context instead of doing
> > >   generic bpf_sock argument (as suggested by Daniel). Even with
> > >   try_socket_lock that doesn't sleep we have a problem where context sk
> > >   is already locked and socket lock is non-nestable.
> > >
> > > v2:
> > > * s/BPF_PROG_TYPE_CGROUP_SOCKOPT/BPF_PROG_TYPE_SOCK_OPS/
> > >
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Martin KaFai Lau <kafai@fb.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >
> > ...
> >
> > >  SEC("cgroup/connect4")
> > >  int connect_v4_prog(struct bpf_sock_addr *ctx)
> > >  {
> > > @@ -66,6 +108,10 @@ int connect_v4_prog(struct bpf_sock_addr *ctx)
> > >
> > >       bpf_sk_release(sk);
> > >
> > > +     /* Rewrite congestion control. */
> > > +     if (ctx->type == SOCK_STREAM && set_cc(ctx))
> > > +             return 0;
> >
> > Hi Stas,
> >
> > This new check breaks one of tests in test_sock_addr:
> >
> >         root@arch-fb-vm1:/home/rdna/bpf-next/tools/testing/selftests/bpf ./test_sock_addr.sh
> >         ...
> >         (test_sock_addr.c:1199: errno: Operation not permitted) Fail to connect to server
> >         Test case: connect4: rewrite IP & TCP port .. [FAIL]
> >         ...
> >         Summary: 34 PASSED, 1 FAILED
> >
> > What the test does is it sets up TCPv4 server:
> >
> >         [pid   386] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 6
> >         [pid   386] bind(6, {sa_family=AF_INET, sin_port=htons(4444), sin_addr=inet_addr("127.0.0.1")}, 128) = 0
> >         [pid   386] listen(6, 128)              = 0
> >
> > Then tries to connect to a fake IPv4:port and this connect4 program
> > should redirect it to that TCP server, but only if every field in
> > context has expected value.
> >
> > But after that commit program started denying the connect:
> >
> >         [pid   386] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 7
> >         [pid   386] connect(7, {sa_family=AF_INET, sin_port=htons(4040), sin_addr=inet_addr("192.168.1.254")}, 128) = -1 EPERM (Operation not permitted)
> >         (test_sock_addr.c:1201: errno: Operation not permitted) Fail to connect to server
> >         Test case: connect4: rewrite IP & TCP port .. [FAIL]
> >
> > I verified that commenting out this new `if` fixes the problem, but
> > haven't spent time root-causing it. Could you please look at it?
> Could you please confirm that you have CONFIG_TCP_CONG_DCTCP=y in your kernel
> config? (I've added it to tools/testing/selftests/bpf/config)
> The test is now flipping CC to dctcp and back to default cubic. It can
> fail if dctcp is not compiled in.

Right. Martin asked same question and indeed my testing VM didn't have
dctcp enabled. With dctcp enabled it works fine.

I'm totally fine to keep dctcp enabled in my config or start using
tools/testing/selftests/bpf/config (I've always used my own config).

Another options can be to switch from dctcp to more widely-used reno in
the program (I tested, this works as well), or even check
net/ipv4/tcp_available_congestion_control and use a pair of whatever cc
available there, but up to you / BPF mainteiners really, as I said I'm
personally fine to just enable dctcp.

Thanks.

-- 
Andrey Ignatov
