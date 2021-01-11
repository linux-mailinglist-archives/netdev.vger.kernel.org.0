Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2D72F24F1
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405391AbhALAZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:28 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46132 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403822AbhAKXLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 18:11:11 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BN94GC004386;
        Mon, 11 Jan 2021 15:10:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=4JmkX1nYbWn8XUGN/Ymh8YlheCoHCbqa8fzTBqW5Lqs=;
 b=omtk7Pn6TJlsRWw0ZG0kmgCTb39YgUOV+VsrB7kNFeh2FSI4OL5PffbIpeTZ4u3rlalf
 RDkYhoK+IGWSmXuywTT71e+hftWKDy+4hmt2jMDIaFJ5mQxujxaKwE9wvFmnoeOjEThS
 Ig0oEmYfcLT6eNEeBO+Lt/8Tiy1hIT6rre4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35yw877jng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 15:10:15 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 15:10:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3cn6rU5O4wiChZNqEZg7HeckewkhYHJoZCgNU5TUYRkasAQPl5M3RCYotq5vm6IoaTqpCcsXXZi4GTBuCPQUsj6AjSiUkAS9PzFU1iZvTjhEg0s5ozOOZp33TzYUXbt8b7D4XLSeWeXw0ZeakgqeH+JaL3JwXqey4iDxPWs5z6Ys/etbJoC9ZA6NAt0yk41JcjN9oJcQ3e2x62hz+eGIqcyT8B5PyPPSYooikBpn+vPgtSLJgk3y50Mz5OhrCE0ekmXZDy2mCW4z3CbLoFs5whF5Zspm8qHycSqE/wCeN7t+xNuS0ia6cEcWZmecq3nUhk+41E/9w0fxb7otoah3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JmkX1nYbWn8XUGN/Ymh8YlheCoHCbqa8fzTBqW5Lqs=;
 b=auL8CiZqViEmPi6d23MNVWFwWcSuU/qdFoQ/zGaVb7cQ4CgEz2ugdZH+AbtUFCLldxRCY7ZfSI9enVAk2iszhyfsl6glSdxkt14NSQcOMQT2vcE3dv9+agZmvSnxgZrmsoYnagUeMrpmaTZ4nEota455nKW6a/BzOClUsyvG9tpKmveM45nO4kS46FXf42rVnIt/+F9VyrYA4vi7/Rc/mu79kSQUe5sr/sYVgZ5Uj/eaUWNMn/sf12nWx6nlj3qgf1MpiqZ1yLPc8sbE/ovqaj5S9OEROJ/2XW92Dl7P4v+zLjYmaHTsLBA5am8zQC77voBkT5eFaJb+I1UeNWjPhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JmkX1nYbWn8XUGN/Ymh8YlheCoHCbqa8fzTBqW5Lqs=;
 b=V2IiogQKA7HTIX4AakPRr0Dyc2wNvXnqu59KURnEOdBYb0qJYqHsPLJ7san6kKTYs9xRk0JptqBETjQyTsvgzvBkSJ4ZApH0++i9aujulfrwb61zCAnHjW7fWfOsTOTHSFFcT30TV/39lobGwXCOER7fimXK4Y0+zFCOZkYzC0g=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2407.namprd15.prod.outlook.com (2603:10b6:a02:8d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 23:10:12 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66%3]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 23:10:12 +0000
Date:   Mon, 11 Jan 2021 15:10:04 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf] bpf: don't leak memory in bpf getsockopt when optlen
 == 0
Message-ID: <20210111231004.4mym7fjt5geywotg@kafai-mbp.dhcp.thefacebook.com>
References: <20210111194738.132139-1-sdf@google.com>
 <20210111223147.crc56dz52j342wlb@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBtM_56n15sxVV1CT9c0XGm-W1neYhUktasd1qGHJoN9mQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBtM_56n15sxVV1CT9c0XGm-W1neYhUktasd1qGHJoN9mQ@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:e2df]
X-ClientProxiedBy: MW4PR03CA0373.namprd03.prod.outlook.com
 (2603:10b6:303:114::18) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:e2df) by MW4PR03CA0373.namprd03.prod.outlook.com (2603:10b6:303:114::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 23:10:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ab2df0f-1b37-4743-24e8-08d8b6860c56
X-MS-TrafficTypeDiagnostic: BYAPR15MB2407:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2407814ECB7B09A586C78D0AD5AB0@BYAPR15MB2407.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iEci27dIJVx3Nsuw6kDx4dArhMb/dhbl9aXXXleEuN8J+YRy880WEo0s0E4UQSX/ZSoJqvQ7lDYd+BuoVKkYXyTYU4gIY0x13pqYAzPO5VvLfmG4tEYMez0DnzTDokiRSS6+aXZyCKe8B9PdRJ8K1p3IXy6JZSFb9JIe50jFqTsPCY7xcmdhLHWfecqOHpP8OgwoGjWsmprPrXQBOOvm9Yp7yW9chcXLLkKCV08cx41Mk5B/LVE9DkU3eMoqyFqU0NFSmCqalhhLim92SPK1Ek1w5o54fBWX59HY2SaWj2eTdTYbtiosMyrpZ6+UTwSk5WahVxR3Nu+3FTlTUtk1ZwC15gTyYHop1fYEODrIgRlP48HS2Fc5KJizXl618awtH/vzz9YNZ5+A9C1DWFZPoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(346002)(376002)(39860400002)(6506007)(53546011)(83380400001)(186003)(16526019)(1076003)(86362001)(478600001)(52116002)(7696005)(55016002)(54906003)(8936002)(8676002)(9686003)(316002)(66476007)(66556008)(66946007)(6916009)(6666004)(2906002)(4326008)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Za/rET6I3U8mdglk8A4zHQFss7TJNXfYQ4WzsAqeUbamImSn9ozWR+nXdSae?=
 =?us-ascii?Q?QygBh7yr4bdVDqg34gicWZRJsMzOI/2VaZGv8d7JVF+kDswJMjGWLxRycqBV?=
 =?us-ascii?Q?a+IMto/PD7LLTMUulHlfyWZLL3dvCQMMA4uCdrdCGmQ5WEXfsMAVoOobeVPA?=
 =?us-ascii?Q?+FxJChiFmf21rKH2jD4d+1Nv7nMtRdGpD4NgLNRGVSol4HifRivXINi1xoAv?=
 =?us-ascii?Q?BIRDY1NebSDBGEe/hE1e4XrTLn+JQ1h367X+LGw76rW5liq283x6aT1ACPQX?=
 =?us-ascii?Q?uOy78/wrdk6ivnKp3g/g8HbGd+Km8ljvUlIXLyEXR6qNFg0/N9uuweEE8sFk?=
 =?us-ascii?Q?HfOgSsfM3IlKGcjAHJEEHmX2ZmrS5f4dugqgE5WRI+gTHBoEVnOHRMAXnDy+?=
 =?us-ascii?Q?4i6o6qqn0x490hYiEDFUCDB8P7CMwkpu8WvOAlPGNLYkZONC0DS6fFT8lGOx?=
 =?us-ascii?Q?bDVYiDyYgGOM7R+dezjIEF+F6zmPOpKB3VUnCE8KnSHf/xgHgMusKf8yzqbh?=
 =?us-ascii?Q?C7zqCJYkOpWT5hB4OTAQwT1kar3jmMsnDf2zu+Qmdk4FuF2Gcg7mZMH0N/8G?=
 =?us-ascii?Q?+BP+rgwCtF/jD5aJORvlu/eIr4YHDZOymOWakoV8O1ssExF36w836A6zVCaU?=
 =?us-ascii?Q?FbvuKPes4XL19ksVC3jeWea/lWYCDm2jXfYUVtgI+Go6CEP92ywsdqxhaFyi?=
 =?us-ascii?Q?1nSw8+KPnzd+ygN5BFcZtU9Ku/9flYW7aElCWyahiwYGXt9nc6WPuKnoEXIg?=
 =?us-ascii?Q?5kr3Y9pLvttNwlUHflNV36oqLKBcEg32Bhb3qFRegDwmZFS+ah8+UnSwCGdh?=
 =?us-ascii?Q?3H8uTqKKvj2+hkjYXy725o1WS4riAPmKm+B0UuIS1VHvmNrPGc5ugWN32NZG?=
 =?us-ascii?Q?0yML1bzXYkODenH4SoB0tsF/d3DxMVJL+SROHJAtw5Kv8uRUU4vmElToVQl0?=
 =?us-ascii?Q?RFDBIwKuhVIkbtBprweusuRrwDZsX4afgCU/WPJlm2ia/qG5JaVTf4cZ8ft8?=
 =?us-ascii?Q?zXorXwDKRsY3m7pvhJLsEMorQw=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 23:10:12.0181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ab2df0f-1b37-4743-24e8-08d8b6860c56
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4YQCERnXsnud5vTGI8QfwVbsUfGLGtnyNYSpZ9F2LDxOsXm6Jok+OQGTw9uU3vAP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2407
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_34:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101110131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 02:38:02PM -0800, Stanislav Fomichev wrote:
> On Mon, Jan 11, 2021 at 2:32 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Mon, Jan 11, 2021 at 11:47:38AM -0800, Stanislav Fomichev wrote:
> > > optlen == 0 indicates that the kernel should ignore BPF buffer
> > > and use the original one from the user. We, however, forget
> > > to free the temporary buffer that we've allocated for BPF.
> > >
> > > Reported-by: Martin KaFai Lau <kafai@fb.com>
> > > Fixes: d8fe449a9c51 ("bpf: Don't return EINVAL from {get,set}sockopt when optlen > PAGE_SIZE")
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  kernel/bpf/cgroup.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > index 6ec088a96302..09179ab72c03 100644
> > > --- a/kernel/bpf/cgroup.c
> > > +++ b/kernel/bpf/cgroup.c
> > > @@ -1395,7 +1395,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
> > >       }
> > >
> > >  out:
> > > -     if (ret)
> > > +     if (*kernel_optval == NULL)
> > It seems fragile to depend on the caller to init *kernel_optval to NULL.
> We can manually reset it to NULL when we enter
> __cgroup_bpf_run_filter_setsockopt,
It feels weird to reset the caller value at the beginning while this is not
intended to be an _init() like function, so I avoided it.

but yeah, I am fine on this way also and won't oppose it strongly ;)

> I didn't bother since there is only one existing caller.
> 
> But you patch also LGTM, I don't really have a preference.
> 
> > How about something like:
> >
> > diff --git i/kernel/bpf/cgroup.c w/kernel/bpf/cgroup.c
> > index 6ec088a96302..8d94c004e781 100644
> > --- i/kernel/bpf/cgroup.c
> > +++ w/kernel/bpf/cgroup.c
> > @@ -1358,7 +1358,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
> >
> >         if (copy_from_user(ctx.optval, optval, min(*optlen, max_optlen)) != 0) {
> >                 ret = -EFAULT;
> > -               goto out;
> > +               goto err_out;
> >         }
> >
> >         lock_sock(sk);
> > @@ -1368,7 +1368,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
> >
> >         if (!ret) {
> >                 ret = -EPERM;
> > -               goto out;
> > +               goto err_out;
> >         }
> >
> >         if (ctx.optlen == -1) {
> > @@ -1379,7 +1379,6 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
> >                 ret = -EFAULT;
> >         } else {
> >                 /* optlen within bounds, run kernel handler */
> > -               ret = 0;
> >
> >                 /* export any potential modifications */
> >                 *level = ctx.level;
> > @@ -1391,12 +1390,15 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
> >                 if (ctx.optlen != 0) {
> >                         *optlen = ctx.optlen;
> >                         *kernel_optval = ctx.optval;
> > +               } else {
> > +                       sockopt_free_buf(&ctx);
> >                 }
> > +
> > +               return 0;
> >         }
> >
> > -out:
> > -       if (ret)
> > -               sockopt_free_buf(&ctx);
> > +err_out:
> > +       sockopt_free_buf(&ctx);
> >         return ret;
> >  }
