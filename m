Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8176F252583
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 04:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHZCi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 22:38:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40994 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726635AbgHZCi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 22:38:28 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07Q2P2Ln027267;
        Tue, 25 Aug 2020 19:38:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ddWATERfla7VGEv5e7t8JREuMb1qasGyjNfoV803qDU=;
 b=ZMLFw7zsfm7aCcZqlCwpN8hxKHXeP30EuLLhBgTNbKmBmZonDp32IrHudh20w6yMFFvV
 YNFxcodx6+roA93W/nIDxuspNzO6/BYah5cvdDxpgwXwF/r3dsD36WSwEaHVAAzYj258
 BePfr6xPs3zsRwe+/EaUGtgNuq93q0bOBIU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 335dp9raxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 25 Aug 2020 19:38:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 25 Aug 2020 19:38:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/vxz72fbR42Pq7eCBuSvinYjRLCm+aOOmhuoO9tPJIYre3CQRc20Q00RM+xFO2M4ZFenOAUoJJx4JJzh4u5ohWtEsod82hMRjR9HjnWwPWnD/HjYdRDPw/r1WYF+DB2qZJEpi9Ihfx7+gGTDi7JgYlRrAwuENzFQeID6wlR3AUyLOx1j10rF2i6W/qc3xYxtu67ZQ96wBPR0Bj5lstuBurG4H0QxNVbVnMME/mvCpDaQZhJ4HkYoIhwhiJ6XX9iCJHCDNQEXm0ILSZjrodJ1t0oVFh8CQ/Be4ytVDU1Sk9EzN+XvQyTOjIsAN3hCcEjOxfj/l7fNPmqST5BQZIoYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddWATERfla7VGEv5e7t8JREuMb1qasGyjNfoV803qDU=;
 b=AQb1OL/IS2+uL1Ic93bHWYwxLKR9VY+XLi4rJuOnoM/cQSuZ2nWlIGoZyLwB4qxZAqXNJ07oHNNWiMQcJSUvNY7nSGjxSEArGHIi1zfOmIQhLJwHacjecC3AlsnDVaqnADpGcsXhDtd1thj7s0XaCA4oasr6C5bOjzveJ0gkoJj3CKB7IE2lVhKAw8IRMoBjBWpyOqe/mkUaJXGuacNdfvWi03dFXPpR7cA6GnS5CP8Y0cLrOjQRkkz7hy1U6dstmfIfbkoY8BTTLn7fRh3ML1/w0YNQxi37DmXzT6UrIgWn6yfO5lI5x5zPwhjsew31EnrO1QBC00WAsgMYr4bFVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddWATERfla7VGEv5e7t8JREuMb1qasGyjNfoV803qDU=;
 b=e7Qj9Oq2pa6M+USPfZao1lJHNB1x9D4QJkcuWUBqlrtOubcNCMLH1SZbkjgqNYAaqSvj2QTazmLs51iSW88tx9KROXbojOXXxXFyUBo0s1v5Kepl8Zw8Td1I1zVXk5E+AWXeHbuAM2nSH9XJRK2yxFqWrlgg6zLs/LaKHBK53YU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2215.namprd15.prod.outlook.com (2603:10b6:a02:89::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Wed, 26 Aug
 2020 02:38:05 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e%6]) with mapi id 15.20.3326.019; Wed, 26 Aug 2020
 02:38:05 +0000
Date:   Tue, 25 Aug 2020 19:38:02 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH bpf-next v4 03/30] bpf: memcg-based memory accounting for
 bpf maps
Message-ID: <20200826023802.GA2490802@carbon.dhcp.thefacebook.com>
References: <20200821150134.2581465-1-guro@fb.com>
 <20200821150134.2581465-4-guro@fb.com>
 <CALvZod70cywN0-HCXUPfyLN1vQdOBb46uCRk5E3NkOTDeWcEtg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod70cywN0-HCXUPfyLN1vQdOBb46uCRk5E3NkOTDeWcEtg@mail.gmail.com>
X-ClientProxiedBy: BYAPR07CA0034.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::47) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BYAPR07CA0034.namprd07.prod.outlook.com (2603:10b6:a02:bc::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 02:38:04 +0000
X-Originating-IP: [2620:10d:c090:400::5:75b8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc66c436-9e89-4a7e-14a9-08d849690f4e
X-MS-TrafficTypeDiagnostic: BYAPR15MB2215:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2215DB41F0036FF8CE8BA33CBE540@BYAPR15MB2215.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n76nI93Mdj2wcPIahJDyD4p5sMK9xEr25xbAE4OYKwO2PSSsV6B//ie+ctaMds+H2zDl/yRvRnzHJzOeDMvub37y9GC+4XRtlkA4MyeFYYARDAI8LOtZPNiKdYwwOduU8y/hrR4Geh/Ix3JXgckAGD+BDueu8hQooe93qoCrSvw4RM0AULX/P2D6wMF0mw0/sLnrrhbo1hgnxIL4arfdTyp1peNUZPpY3M95y8hMykY6FJpdOLQ8vglCx1PVflKrw/KBJhzdRKrWnMgVmQzmdP4QppfKQmDcOfSY1SJ1CoEnbpBYCx1DUzrWOdLPklhubDS78ojHYMxnRsT7ZwAvOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(39860400002)(346002)(376002)(956004)(33656002)(86362001)(66476007)(66556008)(54906003)(4326008)(52116002)(186003)(53546011)(16576012)(83380400001)(15650500001)(316002)(9686003)(8936002)(5660300002)(8676002)(2906002)(478600001)(6916009)(66946007)(1076003)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 3dhVIPtDhBSJ/Tshe/i5y4CChUQGNlRMQusCci9Me8ZQD0Q9HmKEcw+vMWDLIV2xDPvZ6y0CTOGwgVZYCJjFNynNCCXGW5zcQm1+ke9tyx0Hw0YvnvIdC/tMb57RvVsk8NNsNGbNY9O6LeSLrjKWVuyyDZBikOCY0yrwxhM/bxuhPy55w7D8gJhH5VTOHlzVaAeF8+hDz8X9+/FnWL9IuYb5FmbcgEIpi50FpPuhimjTPx2vJkN8G7ATMYKJszUhQw2SSQHCkWtXLPzj0oI3coAfXJmLDMsE0nu5Cw9pBPpJ6qf6v8XS7NXYH4XsRYCubL7B719NdU8SLfoBZwLs9jOOR54WhEBIRwhVcjp2luxRmER5R0W0N8JqSHYuHIZat1EmL/paU/cyEyeva4AV2gg13UWMjMkO6LS3L2Z2XeJadXw7mcV9DW9V4IrMjXRBFc6GdAOhtzDh957qWwKFHBlPPnlnrLyqsGD4rZqWbrriblMBO065mERAVJeXNObeKPGmw7xhk/rP7j/jtT6JHHmf+Om6vdFGt55+I1OQFuLI3B6gq1hG/6xqVy72BF05rYMKh0n9T0lCKaQCNJ0vksyPUZLuKbcPGhtZ0P1xxPy0b/CyR6zcG+GH1pmsAwxMVpvgE5q9aWB4u2o7/7A56+SxDv2mANelUwIxEA+HJWQ=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc66c436-9e89-4a7e-14a9-08d849690f4e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 02:38:05.3002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YV1f4ucp2OhKqmWQ/W5lN/JvcfRoLxF6XQXJVlB7dRi09tyXKYfYjRKQAcC+qplD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2215
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-25_11:2020-08-25,2020-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 suspectscore=1 phishscore=0
 clxscore=1015 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008260018
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 04:27:09PM -0700, Shakeel Butt wrote:
> On Fri, Aug 21, 2020 at 8:01 AM Roman Gushchin <guro@fb.com> wrote:
> >
> > This patch enables memcg-based memory accounting for memory allocated
> > by __bpf_map_area_alloc(), which is used by most map types for
> > large allocations.
> >
> > If a map is updated from an interrupt context, and the update
> > results in memory allocation, the memory cgroup can't be determined
> > from the context of the current process. To address this case,
> > bpf map preserves a pointer to the memory cgroup of the process,
> > which created the map. This memory cgroup is charged for allocations
> > from interrupt context.
> >
> > Following patches in the series will refine the accounting for
> > some map types.
> >
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > ---
> >  include/linux/bpf.h  |  4 ++++
> >  kernel/bpf/helpers.c | 37 ++++++++++++++++++++++++++++++++++++-
> >  kernel/bpf/syscall.c | 27 ++++++++++++++++++++++++++-
> >  3 files changed, 66 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index a9b7185a6b37..b5f178afde94 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -34,6 +34,7 @@ struct btf_type;
> >  struct exception_table_entry;
> >  struct seq_operations;
> >  struct bpf_iter_aux_info;
> > +struct mem_cgroup;
> >
> >  extern struct idr btf_idr;
> >  extern spinlock_t btf_idr_lock;
> > @@ -138,6 +139,9 @@ struct bpf_map {
> >         u32 btf_value_type_id;
> >         struct btf *btf;
> >         struct bpf_map_memory memory;
> > +#ifdef CONFIG_MEMCG_KMEM
> > +       struct mem_cgroup *memcg;
> > +#endif
> >         char name[BPF_OBJ_NAME_LEN];
> >         u32 btf_vmlinux_value_type_id;
> >         bool bypass_spec_v1;
> > diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> > index be43ab3e619f..f8ce7bc7003f 100644
> > --- a/kernel/bpf/helpers.c
> > +++ b/kernel/bpf/helpers.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/jiffies.h>
> >  #include <linux/pid_namespace.h>
> >  #include <linux/proc_ns.h>
> > +#include <linux/sched/mm.h>
> >
> >  #include "../../lib/kstrtox.h"
> >
> > @@ -41,11 +42,45 @@ const struct bpf_func_proto bpf_map_lookup_elem_proto = {
> >         .arg2_type      = ARG_PTR_TO_MAP_KEY,
> >  };
> >
> > +#ifdef CONFIG_MEMCG_KMEM
> > +static __always_inline int __bpf_map_update_elem(struct bpf_map *map, void *key,
> > +                                                void *value, u64 flags)
> > +{
> > +       struct mem_cgroup *old_memcg;
> > +       bool in_interrupt;
> > +       int ret;
> > +
> > +       /*
> > +        * If update from an interrupt context results in a memory allocation,
> > +        * the memory cgroup to charge can't be determined from the context
> > +        * of the current task. Instead, we charge the memory cgroup, which
> > +        * contained a process created the map.
> > +        */
> > +       in_interrupt = in_interrupt();
> > +       if (in_interrupt)
> > +               old_memcg = memalloc_use_memcg(map->memcg);
> > +
> 
> The memcg_kmem_bypass() will bypass all __GFP_ACCOUNT allocations even
> before looking at current->active_memcg, so, this patch will be a
> noop.

Good point. Looks like it's a good example of kmem accounting from an interrupt
context, which we've discussed on the Plumbers session.

It means we need some more work on the mm side.

Thanks!
