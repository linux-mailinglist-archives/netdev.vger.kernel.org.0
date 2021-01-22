Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AB7300D70
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 21:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbhAVUL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 15:11:57 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34808 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730170AbhAVUJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 15:09:47 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10MK4cnf028896;
        Fri, 22 Jan 2021 12:08:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=KC8M0SGoEIJD97rpM5EOpn3zgOSDWvupF1I3GY5ephI=;
 b=XXwDxWE1+H0ELMSaZOXfRDxtAfS2T+xT1iI7k4UgRH1va+M2lYaQyh3mzFk7ztg6liNn
 UpWlkNCrXp6cPiRGPXXO6Y332aiTa75pvhXTOJBgGfKurn8ub/a5dcaYrgURvcItZL41
 Tiow3qtqLjIPPi6LDHOjOD+Ujyus/1xQPeg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 367rx7m2dg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 22 Jan 2021 12:08:40 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 22 Jan 2021 12:08:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lx8R7yR5uQiTUiF0NAwZ4/TtEl4nEoO4o21oD5LK6dFNFNcVyqEQXfoVxOgbfTtndQttYpl8ZBxV7NxEKAsFE6KfJNx8i4nqvC4UCI2dDS8hn8fCCYrRSKD95S3xlOvy80tXclqOXMwrhsD2SIOKj23AD43MsiKKnXg4TxSILeB0AXoQGm0LUXqZUKi9WSCQlQQ+X1QmZE85GgsCb3uHXXTClBlWePL0nShPh80oAVe/ckVMZ6U23K534VYgiUkGb5+fLE7pvmL8zAZMeOhLzxUM3BRUQJTJLyr4mKxES/Oyh3h9/KZysYURr8z12W6KmTSiB30uKzmmZDODSV+t+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KC8M0SGoEIJD97rpM5EOpn3zgOSDWvupF1I3GY5ephI=;
 b=gL5j8uVlln/CGKESAS3TBRKy2u0m02G6Yvm0DKYnyKwEjBgpT0qJF9rINYLgxm2dTuvrf/b9HsVmrpUMm/+igP6DB/aMCuhlz0zWkB7+oCpBbeILMm82RfpKZuBjjHMBr8sixRPgq2LLKI8bmcO/ucVNHrourcEPOPlF2ICCj7xN3waY4mCFvSilCf1qQ0VoNsR225A8F2qk3l3lkeumDTmG+er6NPDRlKu7v7Drc6wqU/vKHguS+7uXwXQqdRkpVdwutmagW4C3UG17sbl5fg5SUI9lSii5G+r4QCIjiy3BmDvESF5imUYADxvlWlLebutvJoJbY7MosDA4UTI+LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KC8M0SGoEIJD97rpM5EOpn3zgOSDWvupF1I3GY5ephI=;
 b=Ns2RmcniI2KqB1FnIYUmgX2QHJzSZ3gB6bXzqjSdEdyfprM97D8IvvSq8Szvo+oltrr0j9kuli3XIBbPt+qXmup2xuRmsvmXzpJRfJAAFU8GpS7bA7iRnsir6o1uqwbhiGxCgG/Xanw2jquJiY3W86Ab2IUNcRS3vo926qXeauM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2245.namprd15.prod.outlook.com (2603:10b6:a02:89::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Fri, 22 Jan
 2021 20:08:38 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::2cfe:c26b:fd06:6c26]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::2cfe:c26b:fd06:6c26%6]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 20:08:38 +0000
Date:   Fri, 22 Jan 2021 12:08:36 -0800
From:   Andrey Ignatov <rdna@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     Martin KaFai Lau <kafai@fb.com>, Netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/2] bpf: allow rewriting to ports under
 ip_unprivileged_port_start
Message-ID: <YAswxL1dZhdbAseP@rdna-mbp.dhcp.thefacebook.com>
References: <20210121012241.2109147-1-sdf@google.com>
 <YAspc5rk2sNWojDQ@rdna-mbp.dhcp.thefacebook.com>
 <CAKH8qBumq7cHDeCpvA1T_rJyvY8+9uCUyb--YAhvcAx3p58faw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKH8qBumq7cHDeCpvA1T_rJyvY8+9uCUyb--YAhvcAx3p58faw@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:363d]
X-ClientProxiedBy: CO2PR04CA0198.namprd04.prod.outlook.com
 (2603:10b6:104:5::28) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:363d) by CO2PR04CA0198.namprd04.prod.outlook.com (2603:10b6:104:5::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 20:08:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15d2e6cb-c2a8-417d-e849-08d8bf118166
X-MS-TrafficTypeDiagnostic: BYAPR15MB2245:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB224591705822EEECD736822EA8A09@BYAPR15MB2245.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wrkvKQUcixFyRKx8dF/vw9Pl54jTxGL4CO1MZZ+8Zrdpes2lni87z0tHggOZiyl8fFN8p4OHDF2J9XGbSS5JZ9o8E1xnDQhu3JepIGFYczdPggJ+wySrX+lcRInFDmBPsiYVxdh7ib0lDuxqEzhcj1A91XBpKjfqlZ1LqVjWNHKWKqeb6kKqefk+ulLrwmuoZ8VnZ0BQwuVexb/xJvLIIPH4vkP9Eg4GalB5dRQUVk+c7VtPAcBlxdBqgGtmGp4OFR68Bylpw8VNi5e/iniwmLYSLQz4ZOaxLcxaGCehL9tUZjruV5dDNEi3uHmWqd76AzySlK/tg0h6tNulhni3XZsGnMFGFoo3FSiQcNLMz+06P5jpKXDxAVcI1eNd3iJfRcZ+kK9j0/jmLgS463cGWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(136003)(396003)(39860400002)(86362001)(9686003)(66476007)(8936002)(6486002)(5660300002)(83380400001)(66556008)(2906002)(66946007)(52116002)(186003)(4326008)(478600001)(8676002)(53546011)(6916009)(54906003)(316002)(6496006)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MXByQXRpU2lDRERRWEhGMTAzTEFGbkNGTTYzTm1aQkdabkdHZEtmcEZQZlU0?=
 =?utf-8?B?NDNINGZXVk5ibCtJb0VKUktxRk1vUTBoV0NWSzBnL3R5ZDBiRVVzMGZWb0lV?=
 =?utf-8?B?Snh1UmVaZHpMYm9xZTBLSDRTamRSc2JsZmNSVU5LOUFsaW02SmQwU3NlSFV3?=
 =?utf-8?B?K1RTeHZqYWk0U0c3bnNOSFJqcVpNcEROWFlqei9iTVg0Q2hGODFRZHZMdGdY?=
 =?utf-8?B?U3BZZGwwMTUwU2ZEWHNPNHN6T01BZGs0MmQ4WjU1RjlBV0FjQkJqMEpLRlFi?=
 =?utf-8?B?dGV6SFhlb1B2SzMvSTRRclRCMGlSVVpScHZnQ1ZmL3JaSThUNm5FQWw3ZmUx?=
 =?utf-8?B?cy91Tkkzc1NCVlFINWhIaWFGZVFvSEJ1MXFXbjBvOUc4SU5OTENlQnc1b0dO?=
 =?utf-8?B?ekRvRFJOYjJYcjJJVmxrYnJBV3dNQnBaWVpRZUxnRzVlSU9LZGxIR01ieTBM?=
 =?utf-8?B?ZVk1ZGRCemg4d2JzVEc2cVllZkoya3NGZEtXbkQ0MlI1WWVaL0dTbUFGQ3dJ?=
 =?utf-8?B?b3JKUHRQSmRzdU1YZGFqSUJOMkdQbmsxV3JXQUo5UUQxNHV4eHJ3cUkyL2l0?=
 =?utf-8?B?TG40VkFGMWthRWZkV0xYNG1kakZjbFEvdURNRitBbjRKUlkwOW03aEFPb2hG?=
 =?utf-8?B?REw5UmZEMXRxNzh6LytEejRjaHNhQmVRZUY3L1FiOTY0RkNiUUxXOVVQRXRv?=
 =?utf-8?B?UVFDU3kzT1cwVE9IREcvNnc0ekQwOGFVbUk3QnhFeUpLN25jRFNiU3Q1OWt4?=
 =?utf-8?B?SFdTa1VITktCRnI4QTc2V1IvdjZZNUwzdlJFeTR5MkRTbytEbXVXM1lYN3hZ?=
 =?utf-8?B?MUk4SVlkcVBwdXVxWGNBTStmS0ZWb0MwTU14OWdTUmRuc1UzZVlCOFAvOS90?=
 =?utf-8?B?QTFTOEFzRWQvRXBySWhyZ01NVkpPM1FTMzFIWURwdzBPa1dpWEgwRCtZeFli?=
 =?utf-8?B?SW1vZWxzQzd1OXZZRlFRbjY1RUdZMDBCM24rTlg0bW1ZNFNoVjY5Ykx2d2ZR?=
 =?utf-8?B?bk5vcEdYeVpmNTdKWHM0QmZTZTUzTmExb1FLd0djUU9Pd3M3cjRzaStTUGxx?=
 =?utf-8?B?RmhUSVNpN29qSnFYbnZFcmluSTdmOEJsN2l5UGEyaEI4UG1nYW15SURqblhr?=
 =?utf-8?B?bE02bEpETEVkSi9COWhUUlpxeGc3ZHBzSkhUbGxpZ25pZVNoWlJNeEJSSHNS?=
 =?utf-8?B?U3h5aTJ5aGhodlhpWjY0NnV0YmJQR0YvNnFBeGFGVGhDbzkvQkowbVR0dUFF?=
 =?utf-8?B?bysyL3RqRklKM3ozNEp1SVZzdGRIRTJzaXdpN0Flb00rUzFjVjhMOWJVSml0?=
 =?utf-8?B?WFZRVDZGLzBSSzVPNFRxZjNwUEFTMitKTkRhdVREbDE4NGN1Vm0vYXZZZEdH?=
 =?utf-8?B?cUxoMVFyUlZ5RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 15d2e6cb-c2a8-417d-e849-08d8bf118166
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4119.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 20:08:38.1827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P7D/y/q+pgl0/JSR2pN+D5AW2ZyB18lRakucZM56YMKfEYH4axNAqB2YwFAQuuSA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2245
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_14:2021-01-22,2021-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101220103
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> [Fri, 2021-01-22 11:54 -0800]:
> On Fri, Jan 22, 2021 at 11:37 AM Andrey Ignatov <rdna@fb.com> wrote:
> >
> > Stanislav Fomichev <sdf@google.com> [Wed, 2021-01-20 18:09 -0800]:
> > > At the moment, BPF_CGROUP_INET{4,6}_BIND hooks can rewrite user_port
> > > to the privileged ones (< ip_unprivileged_port_start), but it will
> > > be rejected later on in the __inet_bind or __inet6_bind.
> > >
> > > Let's export 'port_changed' event from the BPF program and bypass
> > > ip_unprivileged_port_start range check when we've seen that
> > > the program explicitly overrode the port. This is accomplished
> > > by generating instructions to set ctx->port_changed along with
> > > updating ctx->user_port.
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > ...
> > > @@ -244,17 +245,27 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
> > >       if (cgroup_bpf_enabled(type))   {                                      \
> > >               lock_sock(sk);                                                 \
> > >               __ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, type,     \
> > > -                                                       t_ctx);              \
> > > +                                                       t_ctx, NULL);        \
> > >               release_sock(sk);                                              \
> > >       }                                                                      \
> > >       __ret;                                                                 \
> > >  })
> > >
> > > -#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr)                              \
> > > -     BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET4_BIND, NULL)
> > > -
> > > -#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr)                              \
> > > -     BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET6_BIND, NULL)
> > > +#define BPF_CGROUP_RUN_PROG_INET_BIND_LOCK(sk, uaddr, type, flags)          \
> > > +({                                                                          \
> > > +     bool port_changed = false;                                             \
> >
> > I see the discussion with Martin in [0] on the program overriding the
> > port but setting exactly same value as it already contains. Commenting
> > on this patch since the code is here.
> >
> > From what I understand there is no use-case to support overriding the
> > port w/o changing the value to just bypass the capability. In this case
> > the code can be simplified.
> >
> > Here instead of introducing port_changed you can just remember the
> > original ((struct sockaddr_in *)uaddr)->sin_port or
> > ((struct sockaddr_in6 *)uaddr)->sin6_port (they have same offset/size so
> > it can be simplified same way as in sock_addr_convert_ctx_access() for
> > user_port) ...
> >
> > > +     int __ret = 0;                                                         \
> > > +     if (cgroup_bpf_enabled(type))   {                                      \
> > > +             lock_sock(sk);                                                 \
> > > +             __ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, type,     \
> > > +                                                       NULL,                \
> > > +                                                       &port_changed);      \
> > > +             release_sock(sk);                                              \
> > > +             if (port_changed)                                              \
> >
> > ... and then just compare the original and the new ports here.
> >
> > The benefits will be:
> > * no need to introduce port_changed field in struct bpf_sock_addr_kern;
> > * no need to do change program instructions;
> > * no need to think about compiler optimizing out those instructions;
> > * no need to think about multiple programs coordination, the flag will
> >   be set only if port has actually changed what is easy to reason about
> >   from user perspective.
> >
> > wdyt?
> Martin mentioned in another email that we might want to do that when
> we rewrite only the address portion of it.
> I think it makes sense. Imagine doing 1.1.1.1:50 -> 2.2.2.2:50 it
> seems like it should also work, right?
> And in this case, we need to store and compare addresses as well and
> it becomes messy :-/

Why does address matter? CAP_NET_BIND_SERVICE is only about ports, not
addresses.

IMO address change should not matter to bypass CAP_NET_BIND_SERVICE in
this case and correspondingly there should not be a need to compare
addresses, only port should be enough.

> It also seems like it would be nice to have this 'bypass
> cap_net_bind_service" without changing the address while we are at it.

Yeah, this part determines the behaviour. I guess it should be use-case
driven. So far it seems to be more like "nice to have" rather than a
real-use case exists, but I could miss it, please correct me if it's the
case.

-- 
Andrey Ignatov
