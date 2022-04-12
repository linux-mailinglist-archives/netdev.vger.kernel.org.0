Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F21A4FCB8A
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 03:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243100AbiDLBK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 21:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350875AbiDLBK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 21:10:26 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3E536B4F;
        Mon, 11 Apr 2022 18:05:10 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23BMJl5I027745;
        Mon, 11 Apr 2022 18:04:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ur3NH+cHP9wXm7M3GqZQQL3zLj0e/sJrgcRnTyFe7nY=;
 b=ZWtr5Nssf/R/Ji1obTdzereVpX7jgtaIBi49o0YAp/KaEYjBkkVyIOKsp8+ZJ3+MN7r7
 bDXdBSkUKIyO4tXayo2+18xVKMT6W1AXwmJu8kuTrozTGdZeVaIrFLGdCVkF02dd8DRk
 lfX7H5WJx1ENB5o6+n3tOgSlJZA4K9mj2ak= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fb7nwn9x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 18:04:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVBFDaQSqv4W617Q3UjDs+Sf5LOSJDFMUQx6Y8W9RGXGGDUH5A6bMWftnOHS0W0tktbxyco+9VQP+ds//3r/e4kD6dPcPDUhZgTbmX6ZjZAh1l6zPAR6I9ZaYhpxR9NgRXPocSxgKoilzMX9XPOLS7UVNvLM6nz7eRQpi5X+KF8pAq1JlCVzUPu1XGa58AGjCXsebwxdb076lXRC9Psfgi0WZuanLczSM+s1Z38X3LXbur0XmqVW05r6xeyDPWihY2qssS0P/QAs/fBT4Lhk6A0j+CgC+ANabyoHZz2FgGmEgK3g4CWSZINz8fdDGbDVkaFVxBM9zU6Dq96gHuFDkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ur3NH+cHP9wXm7M3GqZQQL3zLj0e/sJrgcRnTyFe7nY=;
 b=NPkgBYrRK3m4Q/VpfKXdaABiuQa3vHBUaNIW9vq2GECQxhNu2kgIALKmwzw+l4JLTYZYwfiYAYoNyo+rqWzy/q3xXDPqBUnBpBLMHPsck0kOENqVYfGPiK0m7hEfyXqG6HkNh5MmyT2NAd8SlkuJ6yHqm3pMw3P3EjsO8v0Bsy17BjFKiGEYMrKSUSFkNHXCGb7RR7+Mwdrd9lwQPsiWo0v7vxTp8Z1Zk5wXEv6MBEssj6cz2pnSzfNIi1mR8B2742DwY9Njt92S5A+vrjUPW+K2tD3jCAuMpVtaeowOpbl6HLVqgsK6f7WksmZN+ee+5UKL5o5kmBQVtnbGkZPXdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BLAPR15MB3972.namprd15.prod.outlook.com (2603:10b6:208:27c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Tue, 12 Apr
 2022 01:04:52 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983%5]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 01:04:52 +0000
Date:   Mon, 11 Apr 2022 18:04:49 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v3 2/7] bpf: per-cgroup lsm flavor
Message-ID: <20220412010449.vmg6r72wf7pilfkw@kafai-mbp.dhcp.thefacebook.com>
References: <20220407223112.1204582-1-sdf@google.com>
 <20220407223112.1204582-3-sdf@google.com>
 <20220408221252.b5hgz53z43p6apkt@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBujC+ds9UOqLjcSoM5SggN4zuyEzKDi=zq4z5sNcTFY+w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBujC+ds9UOqLjcSoM5SggN4zuyEzKDi=zq4z5sNcTFY+w@mail.gmail.com>
X-ClientProxiedBy: SJ0PR13CA0167.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::22) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d1e7663-fbde-4481-7253-08da1c207349
X-MS-TrafficTypeDiagnostic: BLAPR15MB3972:EE_
X-Microsoft-Antispam-PRVS: <BLAPR15MB3972B11883BD97B647D5833BD5ED9@BLAPR15MB3972.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jtOZshn02ewtkk+ifB6nUQUiyGJcXBK5ZklcBlCluJ4KBuzt0yi88QP07bj0tjRyfhkdhYHDbeH0jYClWn9XHKjD2h0UwhWp1jT3DOad00paesvTFVbbdC5app5liOyTy/koHQi66bQ0RvHF/goRmFntWrz8sXY0WV2/j2O+9XlDMmRQJyq/yuDSClBgtWiQPGMQjrhIFw2JfdQKzh3P5ywjhLxhZ4fTN8s3hknMIbo+v92pwre3V6z12tB3T7pqjQj80q1nz3wEX9evx7+z3wMt5VytK6F01aMrPdyyqZ0KVn1TmsX+/edwk+fdec39d60Mo5CeqQRIcX78jGRtHXgXQ2OF+Zh1+CNmPmTJdSR+OF9qc5tvh7ZDUWP3Yt/WxsR1KjppMhtGVwpXfHPfkf2lPf3b1k4C/xFp6W1db31xHsXR6TguZK2N2fiufynuJWiLnpBMVrtGCDNtTQm7K98dhdX1fh/NL4JT463SYNhsjgx2fe0uGLkkzb72jEqwmYkcTCT/Na9DPICVoDQpXufikYHNi5eBXIsjpuVo8CvbAZO8IxV0MRthDI6D1dSQlktmLOBktk2+6uO5K2FAeckk6datoxXuIb8U6PxV3L8NfaE6XN6fyyAzts+RS1LA5Cr7oPtdDzGDfJx6QmWO5S5GzQsUlSiy1nfgpiRaHLh58szVN2410vsDW8ec2evhu+OYPDf1Vq6OHFCqJLxLo3fS2r6ENOGnpYEKyxd8ye4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(5660300002)(6916009)(86362001)(38100700002)(4326008)(6666004)(316002)(966005)(6486002)(508600001)(66946007)(8676002)(66556008)(66476007)(9686003)(6506007)(52116002)(53546011)(6512007)(2906002)(1076003)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U0wZ9/QVQamz9J8wpXzyLdwzh3VOmAubeHpL9OEvtt3sTBZwJhJXpAq1a8AP?=
 =?us-ascii?Q?VqNJwJ1v7VressaeC+Ka6e9+IS6WqCWEedyk2zohtTTzMEXqQS6bwqm8z1hh?=
 =?us-ascii?Q?2PCw8QeozPXQCa5gEHFH/2OBexmxUGgzE5h7U/wm5Qt0/kOYo9YhEjCvLRJt?=
 =?us-ascii?Q?+ikfZzHi7JSObG+YrPO0yF2u7vyhDXRaE4y8TdmRyCnoO9+iWPqp8Ouxkjfl?=
 =?us-ascii?Q?5GeDufRkFACkJZVbQuShCglZxf0AdH9m2yB4wMv7yVawSPVZbb/Wth1lfISo?=
 =?us-ascii?Q?T0OrPloQOlzVOQW3XipW+4XSYZCHzlowikh8/7PgJAIu62JC3X4Ww2DbruWS?=
 =?us-ascii?Q?wL6eSsp0mPW2hZoEa7khUSHQqDmP/aVoh897yCN44Kv4tBPYH1gUpsycUo6o?=
 =?us-ascii?Q?99IWgZuK8mqhy2P1p0DmBTx82t15SD/8lhSWCrrE0vVi6BJHDYhMQ+pWJaqJ?=
 =?us-ascii?Q?zwFMuGru9qJtipobzPFd8i0OettShb+ln9o91HTl3aQpd03xJDxF4ZjIHph6?=
 =?us-ascii?Q?5YcsOkAcudimpcN0VA/1UwWZg6xgK2KhM0Podudhc8lt4/Ik4/NuwD5wwM9w?=
 =?us-ascii?Q?olu1klEv4X4oaBiV1iQ0g+zdP/OvpuQUSBKOr5qhoOdUSVPuPb9KJjrNtY4v?=
 =?us-ascii?Q?oUDHrU7gRFC/8zAl9mqZqaDLnXf5hQNNIC0EivAnJicpckOyjfyDXJvghNJJ?=
 =?us-ascii?Q?nehgKJSCIynxylYBDkVqobkd5JnMxLP6pL1bYZFFJNGa+4s7LAgU62OtYx0l?=
 =?us-ascii?Q?DEdu0a38KMRDnIB0AUhfHV1JtFusoktEwPOrP+yQ+jam9BcrdlhTFs6dSqVv?=
 =?us-ascii?Q?bKWlnR2rqaOwGdLHfEi0O7U3GzGd1+aWkG4Jmc85FUzhnyrYjRkD9ztZZH40?=
 =?us-ascii?Q?PXTATpWSjxlpd9IhfeHaLoouog3VqwmY/hj5/whAxq6jxKfTXUdJeUJjJUUc?=
 =?us-ascii?Q?lwJ7A/ZEX1nbF9gSskugLD1NqLpKYgzjjDCOQp4EliRLNBLL6akN1cM9eSOA?=
 =?us-ascii?Q?KqijsJpLY/bhrjyRbqszrYYnJKqsK9ID5gyMYTzgz06DTkKWj6dLTFc0fPWA?=
 =?us-ascii?Q?+RrI5IdyrZ+lEWjWdyJExoWBz2bcBvHtvByte1wixTnvA1M3QQYs2HyAaYJ1?=
 =?us-ascii?Q?wNKqYc5bAsQFBflS/eUkdrkS8dhtKKXpJpi+hcsG5SseP0NADtL3eQUIthat?=
 =?us-ascii?Q?J+rMVvjTujd/bt53LvCOExLKPg2wZHmnIwdqLE9Z1gJpBawXlmttWJBqSa52?=
 =?us-ascii?Q?M7wwfWNzZqUgTyh+LQ7iHQIMlcj/lU8/x4zcBl9Ws+thZaVHx3+c7OH9DdIw?=
 =?us-ascii?Q?i3bzc9nK54xSjllod7mr/CbX9xOvOGfrM+MUdspNUinjQGKpamKzIf9ehTqb?=
 =?us-ascii?Q?71eKrmhZLMlbACcxFQhLG/V0pRmdN+8pLbyTwRp71RRhSO+i0aHX1myRQmNk?=
 =?us-ascii?Q?WkSYLThquYBcfo0RfT+mbRUQ7i4856xTYBaZtUsN+tyJktD2tc0BJT8aep0A?=
 =?us-ascii?Q?ssd60hdzuSlDzMDuiECrZzR2Tm4DKA5OoNmBgpfK0lVzzh5g3z7cTJa7W5Ea?=
 =?us-ascii?Q?2FnrbYKq38Mh1DTq88l2pC/UeyrEjjY2bl/1rllJAmvHKGGBdYyz4qVDbpZd?=
 =?us-ascii?Q?07kTrcPF03XH7/w17k/6hUdYDTvZeLopgMrBMpQNTb6A8GEfhGLbedbrKfO+?=
 =?us-ascii?Q?lt1XScUpFxnJDlTfHLsNbiMs2U9qEOUoTBVeLOXm2GES0WFfJ33O3eOpojhO?=
 =?us-ascii?Q?J/ZZRvRS76nw3tLTKlst7wz+aX7ntzI=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d1e7663-fbde-4481-7253-08da1c207349
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 01:04:52.8039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NGJ2Kd/L7HBsAKtZq9qFdoPURdSFxXpm/K/jaU/Aaj1FXQnJkB/axycVVHQKjswI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3972
X-Proofpoint-GUID: TTWCwC6Gd7iznheNMoF5iYcOFA2l-lkX
X-Proofpoint-ORIG-GUID: TTWCwC6Gd7iznheNMoF5iYcOFA2l-lkX
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_09,2022-04-11_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 12:07:20PM -0700, Stanislav Fomichev wrote:
> ":  , wi
> 
> 
> 
> On Fri, Apr 8, 2022 at 3:13 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Thu, Apr 07, 2022 at 03:31:07PM -0700, Stanislav Fomichev wrote:
> > > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > > index 064eccba641d..eca258ba71d8 100644
> > > --- a/kernel/bpf/bpf_lsm.c
> > > +++ b/kernel/bpf/bpf_lsm.c
> > > @@ -35,6 +35,98 @@ BTF_SET_START(bpf_lsm_hooks)
> > >  #undef LSM_HOOK
> > >  BTF_SET_END(bpf_lsm_hooks)
> > >
> > > +static unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
> > > +                                             const struct bpf_insn *insn)
> > > +{
> > > +     const struct bpf_prog *prog;
> > > +     struct socket *sock;
> > > +     struct cgroup *cgrp;
> > > +     struct sock *sk;
> > > +     int ret = 0;
> > > +     u64 *regs;
> > > +
> > > +     regs = (u64 *)ctx;
> > > +     sock = (void *)(unsigned long)regs[BPF_REG_0];
> > > +     /*prog = container_of(insn, struct bpf_prog, insnsi);*/
> > > +     prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> > nit. Rename prog to shim_prog.
> >
> > > +
> > > +     if (unlikely(!sock))
> > Is it possible in the lsm hooks?  Can these hooks
> > be rejected at the load time instead?
> 
> Doesn't seem like it can be null, at least from the quick review that
> I had; I'll take a deeper look.
> I guess in general I wanted to be more defensive here because there
> are 200+ hooks, the new ones might arrive, and it's better to have the
> check?
not too worried about an extra runtime check for now.
Instead, have a concern that it will be a usage surprise when a successfully
attached bpf program is then always silently ignored.

Another question, for example, the inet_conn_request lsm_hook:
LSM_HOOK(int, 0, inet_conn_request, const struct sock *sk, struct sk_buff *skb,
         struct request_sock *req)

'struct sock *sk' is the first argument, so it will use the current's cgroup.
inet_conn_request() is likely run in a softirq though and then it will be
incorrect.  This runs in softirq case may not be limited to hooks that
take sk/sock argument also, not sure.

> > > +             return 0;
> > > +
> > > +     sk = sock->sk;
> > > +     if (unlikely(!sk))
> > Same here.
> >
> > > +             return 0;
> > > +
> > > +     cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > > +     if (likely(cgrp))
unrelated, but while talking extra check,

I think the shim_prog has already acted as a higher level (per attach-btf_id)
knob but do you think it may still worth to do a bpf_empty_prog_array
check here in case a cgroup may not have prog to run ?

> > > +             ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> > > +                                         ctx, bpf_prog_run, 0);

[ ... ]

> > > @@ -100,6 +123,15 @@ static void bpf_cgroup_link_auto_detach(struct bpf_cgroup_link *link)
> > >       link->cgroup = NULL;
> > >  }
> > >
> > > +static void bpf_cgroup_lsm_shim_release(struct bpf_prog *prog,
> > > +                                     enum cgroup_bpf_attach_type atype)
> > > +{
> > > +     if (!prog || atype != prog->aux->cgroup_atype)
> > prog cannot be NULL here, no?
> >
> > The 'atype != prog->aux->cgroup_atype' looks suspicious also considering
> > prog->aux->cgroup_atype is only initialized (and meaningful) for BPF_LSM_CGROUP.
> > I suspect incorrectly passing this test will crash in the below
> > bpf_trampoline_unlink_cgroup_shim(). More on this later.
> >
> > > +             return;
> > > +
> > > +     bpf_trampoline_unlink_cgroup_shim(prog);
> > > +}
> > > +
> > >  /**
> > >   * cgroup_bpf_release() - put references of all bpf programs and
> > >   *                        release all cgroup bpf data
> > > @@ -123,10 +155,16 @@ static void cgroup_bpf_release(struct work_struct *work)
> > Copying some missing loop context here:
> >
> >         for (atype = 0; atype < ARRAY_SIZE(cgrp->bpf.progs); atype++) {
> >                 struct list_head *progs = &cgrp->bpf.progs[atype];
> >                 struct bpf_prog_list *pl, *pltmp;
> >
> > >
> > >               list_for_each_entry_safe(pl, pltmp, progs, node) {
> > >                       list_del(&pl->node);
> > > -                     if (pl->prog)
> > > +                     if (pl->prog) {
> > > +                             bpf_cgroup_lsm_shim_release(pl->prog,
> > > +                                                         atype);
> > atype could be 0 (CGROUP_INET_INGRESS) here.  bpf_cgroup_lsm_shim_release()
> > above will go ahead with bpf_trampoline_unlink_cgroup_shim().
> > It will break some of the assumptions.  e.g. prog->aux->attach_btf is NULL
> > for CGROUP_INET_INGRESS.
> >
> > Instead, only call bpf_cgroup_lsm_shim_release() for BPF_LSM_CGROUP ?
> >
> > If the above observation is sane, I wonder if the existing test_progs
> > have uncovered it or may be the existing tests just always detach
> > cleanly itself before cleaning the cgroup which then avoided this case.
> 
> Might be what's happening here:
> 
> https://github.com/kernel-patches/bpf/runs/5876983908?check_suite_focus=true
hmm.... this one looks different.  I am thinking the oops should happen
in bpf_obj_id() which is not inlined.  didn't ring any bell for now
after a quick look, so yeah let's fix the known first.

> 
> Although, I'm not sure why it's z15 only. Good point on filtering by
> BPF_LSM_CGROUP, will do.
> 
> > >                               bpf_prog_put(pl->prog);
> > > -                     if (pl->link)
> > > +                     }
> > > +                     if (pl->link) {
> > > +                             bpf_cgroup_lsm_shim_release(pl->link->link.prog,
> > > +                                                         atype);
> > >                               bpf_cgroup_link_auto_detach(pl->link);
> > > +                     }
> > >                       kfree(pl);
> > >                       static_branch_dec(&cgroup_bpf_enabled_key[atype]);
> > >               }

[ ... ]

> > > +int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> > > +                                 struct bpf_attach_target_info *tgt_info)
> > > +{
> > > +     struct bpf_prog *shim_prog = NULL;
> > > +     struct bpf_trampoline *tr;
> > > +     bpf_func_t bpf_func;
> > > +     u64 key;
> > > +     int err;
> > > +
> > > +     key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
> > > +                                      prog->aux->attach_btf_id);
> > > +
> > > +     err = bpf_lsm_find_cgroup_shim(prog, &bpf_func);
> > > +     if (err)
> > > +             return err;
> > > +
> > > +     tr = bpf_trampoline_get(key, tgt_info);
> > > +     if (!tr)
> > > +             return  -ENOMEM;
> > > +
> > > +     mutex_lock(&tr->mutex);
> > > +
> > > +     shim_prog = cgroup_shim_find(tr, bpf_func);
> > > +     if (shim_prog) {
> > > +             /* Reusing existing shim attached by the other program.
> > > +              */
> > The shim_prog is reused by >1 BPF_LSM_CGROUP progs and
> > shim_prog is hidden from the userspace also (no id), so it may worth
> > to bring this up:
> >
> > In __bpf_prog_enter(), other than some bpf stats of the shim_prog
> > will become useless which is a very minor thing, it is also checking
> > shim_prog->active and bump the misses counter.  Now, the misses counter
> > is no longer visible to users.  Since it is actually running the cgroup prog,
> > may be there is no need for the active check ?
> 
> Agree that the active counter will probably be taken care of when the
> actual program runs;
iirc, the BPF_PROG_RUN_ARRAY_CG does not need the active counter.

> but now sure it worth the effort in trying to
> remove it here?
I was thinking if the active counter got triggered and missed calling the
BPF_LSM_CGROUP, then there is no way to tell this case got hit without
exposing the stats of the shim_prog and it could be a pretty hard
problem to chase.  It probably won't be an issue for non-sleepable now
if the rcu_read_lock() maps to preempt_disable().  Not sure about the
future sleepable case.

I am thinking to avoid doing all the active count and stats count
in __bpf_prog_enter() and __bpf_prog_exit() for BPF_LSM_CGROUP.  afaik,
only the rcu_read_lock and rcu_read_unlock are useful to protect
the shim_prog itself.  May be a __bpf_nostats_enter() and
__bpf_nostats_exit().

> Regarding "no longer visible to users": that's a good point. Should I
> actually add those shim progs to the prog_idr? Or just hide it as
> "internal implementation detail"?
Then no need to expose the shim_progs to the idr.

~~~~
[ btw, while thinking the shim_prog, I also think there is no need for one
  shim_prog for each attach_btf_id which is essentially
  prog->aux->cgroup_atype.  The static prog->aux->cgroup_atype can be
  passed in the stack when preparing the trampoline.
  just an idea and not suggesting must be done now.  This can be
  optimized later since it does not affect the API. ]
  
