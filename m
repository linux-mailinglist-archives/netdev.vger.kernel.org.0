Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B9F2C7C4A
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 02:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgK3BHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 20:07:12 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44578 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726304AbgK3BHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 20:07:11 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AU169W3014983;
        Sun, 29 Nov 2020 17:06:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=HRGEq+T9rejAhK0Hm/7UKsxtzUD6yQG/9LWlndRlKkc=;
 b=UNloYML8FxXUjObs3v1E3oKOci3LtMZOv5NRVGEHQFPaCRcNCbXNuxAtZT/m2n7kADH9
 g/k5/lI1qipZ+XeUJF82pBkBiX+fFWkH92uviQFb0PhjLpO03WTyCF+HkjEHAhRjCrEI
 l/bs0Tuu9DnnIWp6X9wo1IUFKQB0d4SPFX0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3547g8ab7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 29 Nov 2020 17:06:10 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 29 Nov 2020 17:06:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hzkz0XAv/l+IQXQkvDEXf0lth4FKZMNievRkCch2NqVi4XaZYMPzTKkmta959BcwhxC4pz2B1MiKyeG8fED6RurRlEwsQviytAUgsU87Jp/3QgTa1rb61+NSiuLFE20dHd7xH3ZNLctX8ul1kWeivk4KDcYr6eUfgWHiGy5FJM9QXZL6XZtYbQL1RBB4dO3OABB1m1MkkY+x5EtJhDnA6vpSv4Wka7cSjZTZjE0/YBOXsJ3k9FjVa979QjaeH7/6TmuV1rEmyURp4aazLWiS8J2wyS4WNg8JbgvAjPUumuI3cd7nXUKIBWl3lQtX+gvRMa7Dlr4sajqKYmnAvdTpvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRGEq+T9rejAhK0Hm/7UKsxtzUD6yQG/9LWlndRlKkc=;
 b=IdjZbl7o8Kojyu51Ee97/YpSwtqfT3kSOmWFeRQyDZwzhqgbnrsO6kyHH6wDjMdRyVYwHPRnb5BTlQK0JXPWmIkiyy2i12TmWHDxo8LSoUk12bq0t9qy1xQHcyFo4KFjG3qmR67pJGWqEwcBfvXUTVQH5AjQdbcSG3A2Zp9XerA2yY1qt6rId5c9zkc2g1CCJaNVlFGLRura/i31RDrBXORivPa8MLjGNrebpzKwVZCwAODEGUH0mstPOJmQ1L4T5Qw0SEmq+YtWDn9p5bUzaYdquNVARt3IH+emrLWEzserHN3xPnhJhbjAb+Xpt+YyXIpp0vpyBEFuld96pUhH7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRGEq+T9rejAhK0Hm/7UKsxtzUD6yQG/9LWlndRlKkc=;
 b=akhP47GNWxxC3FR+LiljJ51f06FsgNRjlBG7vf87v9xEgOaWuq3oDzQKs1cNbAk9gJ8xWQJhAqifz4J9wuWGtVwlzpSBm2SPIMJO6t+Z1QqVG/FCgEkPdas3EP93Gvj4aB08q/AIw+sYnX4CFihvqNPxY2jGyEf3o5lDyPa+NDA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2696.namprd15.prod.outlook.com (2603:10b6:a03:156::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.21; Mon, 30 Nov
 2020 01:06:02 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::258a:fe57:2331:d1ee]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::258a:fe57:2331:d1ee%7]) with mapi id 15.20.3611.031; Mon, 30 Nov 2020
 01:06:02 +0000
Date:   Sun, 29 Nov 2020 17:05:59 -0800
From:   Andrey Ignatov <rdna@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 2/3] bpf: allow bpf_{s,g}etsockopt from cgroup
 bind{4,6} hooks
Message-ID: <20201130010559.GA1991@rdna-mbp>
References: <20201118001742.85005-1-sdf@google.com>
 <20201118001742.85005-3-sdf@google.com>
 <CAADnVQLxt11Zx8553fegoSWCtt0SQ_6uYViMtuhGxA7sv1YSxA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQLxt11Zx8553fegoSWCtt0SQ_6uYViMtuhGxA7sv1YSxA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Originating-IP: [2620:10d:c090:400::5:7ff0]
X-ClientProxiedBy: CO2PR07CA0070.namprd07.prod.outlook.com (2603:10b6:100::38)
 To BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:7ff0) by CO2PR07CA0070.namprd07.prod.outlook.com (2603:10b6:100::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Mon, 30 Nov 2020 01:06:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4aa1b51-b92a-40a2-980d-08d894cc1b4a
X-MS-TrafficTypeDiagnostic: BYAPR15MB2696:
X-Microsoft-Antispam-PRVS: <BYAPR15MB269604EC62DF34E2154DD78BA8F50@BYAPR15MB2696.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ZDxKHofz7e1pIyKA7A9aSpCcir1f4TE8a/AoUxQCAMO2Ly63+QVd/nFJoKHa6dnlFphej7fGYd4YtnWNcFl/sjS805HDhK14nq7xgbhhml4IELGyouGk0XcUhRQq/mqMx2pyREQxBj0G0plzdGhrx/5EiZ4azd9X01LMtUtE6ABB8wu45cA8WNTK6Ty1WKfHzyywl34axEhPaQ2dRoQrxQE27ytuzMCXBWq2YJ3jkQQ6FqBAwikmnTuvXAGbsaFrDrEG5SS/K9X8WwkMvDEEcOpJelYE0w6h71XMheYfTis6Mhri9eVzPSt//MI5DWhe9ZQxkqdYdB+9hPQfKlTkB8kntj7gGUwp3p2L6bNOsi/Ha77An4wluYQidTm0TZv4MgI9yMEm0wQLDJjo0E4/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(39860400002)(136003)(366004)(346002)(376002)(396003)(6666004)(478600001)(54906003)(66946007)(316002)(6486002)(66476007)(66556008)(4001150100001)(186003)(16526019)(33656002)(6496006)(966005)(1076003)(2906002)(9686003)(33716001)(8936002)(83380400001)(6916009)(5660300002)(53546011)(4326008)(52116002)(8676002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S2JPbGZFYmNIb2lKMjRjT3JFNllpTkRZK1F3NlovTDU5UWtzcG9qVVYrL05P?=
 =?utf-8?B?b2M4R1laS2loNktxZ2JwQ0tyVk53NXJha1R0RDJsZm9Gem9mMzRmYmFRNTQy?=
 =?utf-8?B?cU9HWlk0czRtTlZQZGdsTVhMeUhKZkYxU0taZVhRdmQzMExhUnJSUE1OYVkv?=
 =?utf-8?B?VEpPb2xaTE0ySFdxSkJXVjdOcU4zQUJoVUx4L3Q1VHk1NXp5cUovUUFnRDVL?=
 =?utf-8?B?SGtvV0VmTnUvcXNtZmR2bG5VeFNpUUFsbWxndjhKSFdHNE9NaWt2MzFTYWlU?=
 =?utf-8?B?WGwveWxLQUxhYmJJVzdXejhxWUdVMDNTOUVtVFBYUzZLV1gzTDE3TmJ0SDFW?=
 =?utf-8?B?bjVTU3hSQmwwd2VFUUJEMUZjbUF2aGd4NWJXeDJrbWhnZ2hPN2pPdUl5NndS?=
 =?utf-8?B?TzBIUGREdExJSjZ3N3pSdkZpeDRJVXFGUVA4cXNTMGVhMGJnRlZRYmdjc05z?=
 =?utf-8?B?VWQzSjNONXdjUEludFhUVU9GUnlVRThYalFHM0Z2eDV0eWJ3SWdHYUo5TUlX?=
 =?utf-8?B?UjA1cVJsY1o1dU1obkEwTFBnaXBJRHZ0d2xNZC9qcXRSYldLNHJvcXYzdDRj?=
 =?utf-8?B?cUkzZ3dNYzFBN0dFZ0FDbGxvWk5xVHFISXp6QmczRU8vMWljb0JMdzA5RFRQ?=
 =?utf-8?B?d2VpTE1uUlN1d1ZrMzNOaEl0cHp4amovWUxXMmxrTXloZVdKd0Mxa2lsd0Qx?=
 =?utf-8?B?Qm9zZjFtZ1R5RzdUT0lTaWNSZ015VjYwV3h3dVVubTNkTmtLNXN6RW10b2lL?=
 =?utf-8?B?WjFEbFdEUzBmZGNqVHlBQ3lrOURobHIydXVNa090TFlDR1BkQm14Qk9jQUVs?=
 =?utf-8?B?MUk0Z1JrSTA5L3lGWllOTUNaMEtENHZoQ1o5M2pMY0RpTG5MMGE4eG93R2du?=
 =?utf-8?B?ZklQUnZsdGEvclFKNE52VjBXQ29WcFBmS0JaVjhwZXNpc2pBcHZQby9vbnRZ?=
 =?utf-8?B?TVJHWHVUVUcvMm04V29mbk1pN1hGYTU0VStSU1d6Q1pJRFdXRHF6akJITkVp?=
 =?utf-8?B?YVBVb2lvUjl5QkVFYjE2SnR0Q2lKaFpGaGhSTGxVWFFMZ2h0RUhkeGZvVUdk?=
 =?utf-8?B?N0lkbEhJVTVDN1B0TDZqcWlLREwzZVZpS2tPRExWZHZNeEYyUWdKbmRxQzFL?=
 =?utf-8?B?M0xCbndPcWxldFlVV1BRSXdVVjB6S1hRUVQvWjZuRTVPd25QcWJQd0UwQVhY?=
 =?utf-8?B?ZzJKcGxPTk50by9sTW5LUXkwR1h4MGtHeGlYdHg0UGZFSmdONTE3RkRUZlV2?=
 =?utf-8?B?VC9DanlMUjhTd1RJZEwyRkdsUzAzNnErVWt3a1NWUWhJdVpZWkVBbkliY2JH?=
 =?utf-8?B?aGhxR0FURUVQMmQ4THk4OUtBc09kOHZUNkZJUnRWZE04VDZYZXZXdU1VMTVx?=
 =?utf-8?B?WVdSVFBxNDVweUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d4aa1b51-b92a-40a2-980d-08d894cc1b4a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4119.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 01:06:02.6447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: masTyh4Z1eNwuYB7x84UB+DTxGbkbAkLmVPRPwvl9QfNKrQKHKoAYmhxRMriRXzF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2696
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-29_12:2020-11-26,2020-11-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1011
 spamscore=0 suspectscore=0 phishscore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300003
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> [Tue, 2020-11-17 20:05 -0800]:
> On Tue, Nov 17, 2020 at 4:17 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > I have to now lock/unlock socket for the bind hook execution.
> > That shouldn't cause any overhead because the socket is unbound
> > and shouldn't receive any traffic.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/linux/bpf-cgroup.h | 12 ++++++------
> >  net/core/filter.c          |  4 ++++
> >  net/ipv4/af_inet.c         |  2 +-
> >  net/ipv6/af_inet6.c        |  2 +-
> >  4 files changed, 12 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> > index ed71bd1a0825..72e69a0e1e8c 100644
> > --- a/include/linux/bpf-cgroup.h
> > +++ b/include/linux/bpf-cgroup.h
> > @@ -246,11 +246,11 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
> >         __ret;                                                                 \
> >  })
> >
> > -#define BPF_CGROUP_RUN_PROG_INET4_BIND(sk, uaddr)                             \
> > -       BPF_CGROUP_RUN_SA_PROG(sk, uaddr, BPF_CGROUP_INET4_BIND)
> > +#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr)                        \
> > +       BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET4_BIND, NULL)
> >
> > -#define BPF_CGROUP_RUN_PROG_INET6_BIND(sk, uaddr)                             \
> > -       BPF_CGROUP_RUN_SA_PROG(sk, uaddr, BPF_CGROUP_INET6_BIND)
> > +#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr)                        \
> > +       BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET6_BIND, NULL)
> >
> >  #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (cgroup_bpf_enabled && \
> >                                             sk->sk_prot->pre_connect)
> > @@ -434,8 +434,8 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
> >  #define BPF_CGROUP_RUN_PROG_INET_EGRESS(sk,skb) ({ 0; })
> >  #define BPF_CGROUP_RUN_PROG_INET_SOCK(sk) ({ 0; })
> >  #define BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk) ({ 0; })
> > -#define BPF_CGROUP_RUN_PROG_INET4_BIND(sk, uaddr) ({ 0; })
> > -#define BPF_CGROUP_RUN_PROG_INET6_BIND(sk, uaddr) ({ 0; })
> > +#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr) ({ 0; })
> > +#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr) ({ 0; })
> >  #define BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk) ({ 0; })
> >  #define BPF_CGROUP_RUN_PROG_INET6_POST_BIND(sk) ({ 0; })
> >  #define BPF_CGROUP_RUN_PROG_INET4_CONNECT(sk, uaddr) ({ 0; })
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 2ca5eecebacf..21d91dcf0260 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -6995,6 +6995,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >                 return &bpf_sk_storage_delete_proto;
> >         case BPF_FUNC_setsockopt:
> >                 switch (prog->expected_attach_type) {
> > +               case BPF_CGROUP_INET4_BIND:
> > +               case BPF_CGROUP_INET6_BIND:
> >                 case BPF_CGROUP_INET4_CONNECT:
> >                 case BPF_CGROUP_INET6_CONNECT:
> >                         return &bpf_sock_addr_setsockopt_proto;
> > @@ -7003,6 +7005,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >                 }
> >         case BPF_FUNC_getsockopt:
> >                 switch (prog->expected_attach_type) {
> > +               case BPF_CGROUP_INET4_BIND:
> > +               case BPF_CGROUP_INET6_BIND:
> >                 case BPF_CGROUP_INET4_CONNECT:
> >                 case BPF_CGROUP_INET6_CONNECT:
> >                         return &bpf_sock_addr_getsockopt_proto;
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index b7260c8cef2e..b94fa8eb831b 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -450,7 +450,7 @@ int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
> >         /* BPF prog is run before any checks are done so that if the prog
> >          * changes context in a wrong way it will be caught.
> >          */
> > -       err = BPF_CGROUP_RUN_PROG_INET4_BIND(sk, uaddr);
> > +       err = BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr);
> 
> I think it is ok, but I need to go through the locking paths more.
> Andrey,
> please take a look as well.

Sorry for delay, I was offline for the last two weeks.

From the correctness perspective it looks fine to me.

From the performance perspective I can think of one relevant scenario.
Quite common use-case in applications is to use bind(2) not before
listen(2) but before connect(2) for client sockets so that connection
can be set up from specific source IP and, optionally, port.

Binding to both IP and port case is not interesting since it's already
slow due to get_port().

But some applications do care about connection setup performance and at
the same time need to set source IP only (no port). In this case they
use IP_BIND_ADDRESS_NO_PORT socket option, what makes bind(2) fast
(we've discussed it with Stanislav earlier in [0]).

I can imagine some pathological case when an application sets up tons of
connections with bind(2) before connect(2) for sockets with
IP_BIND_ADDRESS_NO_PORT enabled (that by itself requires setsockopt(2)
though, i.e. socket lock/unlock) and that another lock/unlock to run
bind hook may add some overhead. Though I do not know how critical that
overhead may be and whether it's worth to benchmark or not (maybe too
much paranoia).

[0] https://lore.kernel.org/bpf/20200505182010.GB55644@rdna-mbp/

> >         if (err)
> >                 return err;
> >
> > diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> > index e648fbebb167..a7e3d170af51 100644
> > --- a/net/ipv6/af_inet6.c
> > +++ b/net/ipv6/af_inet6.c
> > @@ -451,7 +451,7 @@ int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
> >         /* BPF prog is run before any checks are done so that if the prog
> >          * changes context in a wrong way it will be caught.
> >          */
> > -       err = BPF_CGROUP_RUN_PROG_INET6_BIND(sk, uaddr);
> > +       err = BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr);
> >         if (err)
> >                 return err;
> >
> > --
> > 2.29.2.299.gdc1121823c-goog
> >

-- 
Andrey Ignatov
