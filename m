Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E955B541E90
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 00:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380641AbiFGWcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 18:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385450AbiFGWba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 18:31:30 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1768278538;
        Tue,  7 Jun 2022 12:24:31 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257G45og015314;
        Tue, 7 Jun 2022 12:24:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=BWNFgtxu4f/MoKkBqFr9Si5hlE+9kbnXEIGKry5OxE8=;
 b=qL9P0Ut3ZSf9FZ9xTx4PDLOZw9Ikxi7y5Ds/IjkJkbdToiBFTcklzbMj0zC3AS8LFSQS
 lYnHAI1A27KjJcugQKI7FmZuQuUzuhzxK/8VB2eD5e/VrtjER81rJdtRBy6n0cRKvXnH
 Nxl9M09ZEUlbJy5UAwIQUssezJT96WtZHsA= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gj13cmfxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 12:24:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QK4d1+gspKn54IhO1aFezBAmpFdC9S2L9J8QMUwLWpB45184ik2n6NzgKYKZq2aw31Eat1UTyZl55EPahIqmE1l6bIiG2m+a/cbgfNNly8kts87IVD7rsJRRTJIidJqCt4PCSxtVnBOR6TqdGQJs7yP9R3ot/BRKEERwRAPdtQA0Zx7ZlkUGtKXQimfz70SIuF4z52hDu5soO0o7UBID9wK73ySG2vRNLRZMuOWE4KXPULbNOF2kWAlQXwEYeneeq9DuoDic7YTyBetsKO3CF8x2uertXMlQUeX17WArxK7rSMgZw+wf+9hAW3wOoHD3AWWUpxZW/n/c8VFKScPDvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BWNFgtxu4f/MoKkBqFr9Si5hlE+9kbnXEIGKry5OxE8=;
 b=mvbOPucsHwq5ElIekXpc1MBiCe1h4HZeMo5G062b37GPJSrW8279DdDbM5xsQXpAsc0joBoz1Y7J/XMtzRnXZzP+PgUtOU4+v/doPbotbrKEu/UjnyPfT7iTqNJ2c8ZanMywxPBiyMcQXVCn0xbRHuA4CCMxsRtsN+k5OhsLOuouc8sKputO9izkOFus/dpe/AZR9PPC4jgOB3aTgIs6bsYoMBT+phWkQEcjjSew+Pznr4VLMtuF5Err0Js097otJsNnfSlWsaoQnuLCY0v4kfqet7yEovRT5WYbg/aOZXPLTXOQjyp9giXGNiquHr+G5UN74WbfdQW3qq2vAXvL4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM6PR15MB3797.namprd15.prod.outlook.com (2603:10b6:5:2b7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 19:24:13 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0%9]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 19:24:13 +0000
Date:   Tue, 7 Jun 2022 12:24:10 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v8 03/11] bpf: per-cgroup lsm flavor
Message-ID: <20220607192410.sjcorcve3xlvi7co@kafai-mbp>
References: <20220601190218.2494963-1-sdf@google.com>
 <20220601190218.2494963-4-sdf@google.com>
 <20220604061154.kefsehmyrnwgxstk@kafai-mbp>
 <CAKH8qBu0XzFJjh0EZrhgO7SidpdVaszGMmf-DNKmqmf2sLACrw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBu0XzFJjh0EZrhgO7SidpdVaszGMmf-DNKmqmf2sLACrw@mail.gmail.com>
X-ClientProxiedBy: BYAPR01CA0044.prod.exchangelabs.com (2603:10b6:a03:94::21)
 To SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f4b28ed-9b0e-477b-7e1e-08da48bb4dce
X-MS-TrafficTypeDiagnostic: DM6PR15MB3797:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB3797A5A78AF76A04D23BF275D5A59@DM6PR15MB3797.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fZXSHBRB9365eIecISkr+AZ41OGRjTpTH1b+RQ8eorKPNJ00udXIG+aorAugbKuiDH8w7NbvRtnVvGIzTVkiSTmpYiTc5xATVSKfVtxl7mpoSydYrhBx7/BWjEDDPuvVWbRtMwZrGbYynGcgGE3g+jaXUcK1sZsgHd7HN44zctlMx8+4ahffkwpPerH1/PIUiEnLRLJiHTZNeLFu8gEn3wJjIkDHOw/HxvUDO3LRZUt14Obeh6VSZdeTzaNAgsC2g/pGO6m9vASZbZhovV0cRHGWaI2nrxsQ5Z3JI093bCddPcVytjKNIfwBjoreoi+25sZZdxtakpGG90t5mbkaHwNZw546AGIm/4O3HnYRSgBokE+MLfveWJLfzXEoBgJqIAjJmvVSPCkpYc4tx5/9FfCHDdJl3S6X3j/45nq7pr35h6OWupBayG4uVBHo99h/S3aOvwGeqlr7LqxHdyXtN7LGS3gFAu8sRFE7/rJ7Hkk+4XKMLBEBXqC3xrVg0jHhpV5W8zJ496Zkd94f1nKdnUag3ECfo9mBdZfR9OJ/RV5U8FldpU6GJcFwuEa5813okQ/EDqDR4vPtFwNEVIwZhIcgF/wuOSU577Dmy7ERA5Hi3KiSOQfCvHMjrVQcSGhd/0D5IPTMAXhN0VDtfgnnjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6916009)(9686003)(6512007)(8676002)(8936002)(186003)(86362001)(1076003)(4326008)(66946007)(66476007)(33716001)(66556008)(2906002)(5660300002)(6486002)(316002)(83380400001)(38100700002)(52116002)(508600001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?70eYtlwGOhqKsB+mKudbv7YlVsaoTPeXEpG9ZYsD+EbzZIiU6dUeK1mpjrZ8?=
 =?us-ascii?Q?nboc3t8NIV8AN5wmv7l4m5IvzoYdSwpqQiY70FvmWP8l6XPQq/ArWaWt7CNi?=
 =?us-ascii?Q?EHPZ680X4KmWsd8pds7spiRwWFRkQjxKocmLrnH/xmC/FW2tVZdRTM7YXQGw?=
 =?us-ascii?Q?L1YS1fvsmSjdBndygnf8ymlcW/g3zquDjZiEz72zoVRRD3Opd6t0nGgulGOI?=
 =?us-ascii?Q?t+WIhTXY+kEZUaxZEGWJsrwTpMXndfnI4ynf772RmhW8oRHfsbvBSHQlkbmw?=
 =?us-ascii?Q?NJTFEzg5XG+KW5tS7kDN5BlxEy7tPEfTJdWEC8fMWfWVeUutabIOKCtNOZhK?=
 =?us-ascii?Q?QpoHS70NSyAik3Nuv/edRZwrEpEXrm+SkRXBmJeHABUCgy52RXx9L5cj/n9e?=
 =?us-ascii?Q?fci7DaCjS21W8+NIsl0S1lIp3C+lzJ8r93yT1P1lNNfr5kghFIt/Qi9CYXek?=
 =?us-ascii?Q?oODtSkB6m4Z7beN7KJG8XJhk+/yMTWo2mF12qxS+bVlfLHT6B77AJMH77Uf7?=
 =?us-ascii?Q?X/ct2uM/KGwocowHNzsc+Td/jGrkCCSXh7lB/Wtb8imCR24pYOw8yY+hYRt8?=
 =?us-ascii?Q?9PwyMetXSh0GWlLGsfSVYvO0HLAsfIKAn1R40R0EgsqAxEOV8jB6r24MvInR?=
 =?us-ascii?Q?KP19hxyxN449w+1FOojEMpSslO0aym8BJv5rMOlkX5hJtbyuPzcgraknOnPv?=
 =?us-ascii?Q?0TC2zCh2WJgsCAwKYmz3TF+bzyCRD4OeTDvvLiLlQiOm//xVJz0mWhEnHIr0?=
 =?us-ascii?Q?I0kKM5yiGhsYeSDj9YbdSJhjvuz6V+rY9sDsVKxiwGimOwqxVRs6Wn5QgiYU?=
 =?us-ascii?Q?FkYkTa9IjOoPmJ8dKF4ZVV4bkyxiJXP2A908y6dVRNBjfL1VuABfqV5FaT0N?=
 =?us-ascii?Q?gIynKFdGIJ5y+yLDcIJ735lkv7vsv02PWpOeqXlRj0/8XNNMqiN3GZPVE1Xo?=
 =?us-ascii?Q?HzFY92HJsrQ1oaGrbv00e6jLJozem7YuVlN2cRJGb1R1iIsFWpcIO7PWhwqe?=
 =?us-ascii?Q?P/5lebO/KbxbJBRLTqbQnop8/rcq+RHMaHJihL5idv30xKuplXBfYASNJB1y?=
 =?us-ascii?Q?H3vOWoGGxNOqGPAQE93f4YfX7XNBB9KTI/L3+/k3OgiRmEdH6aAvJ84Up6YZ?=
 =?us-ascii?Q?gFVHZQdMKBhr8k+Sy0jzz+aDA0B8GQYK2k0a0bbyoo8tlbZ7lTUj7rRLaDHM?=
 =?us-ascii?Q?MiSoZLALB8xWol/qtNH5a7yUgyt1h87kn4HyXw2ztjkyOVX4diXJL82jQrVh?=
 =?us-ascii?Q?QoZWz1p6Y9GVQOP7rqXDtVM2wuBw683GcbmvBOPHpgwoB43YgPG1HwJ8Qvv8?=
 =?us-ascii?Q?HzDCDAUO5UUW/OuDKxHkVjTsDQM5PmzTAKdPjTb55vwARlN8op+mB5KSD8ih?=
 =?us-ascii?Q?4ACv59l9POmyjohwhjYtQ01UwXgusujJ83hr7SR2WhtQwZRI8KHbn3UVHXJ6?=
 =?us-ascii?Q?y2erei06elMuRhhAvigjYUfA3dPtwMPKjA9ypGuSM/87f5JbtOEwIagcqN+Q?=
 =?us-ascii?Q?PV30mY6ITtVMRHUYHOt936o9798ZyJf0xl7pdElmu4b7F/uSQf+09izR2UKG?=
 =?us-ascii?Q?zQG+e/GLOsOv4iD7MdEftGZajk7w65EFv01tFhOHfo6uwODEZinf4mH/0QNn?=
 =?us-ascii?Q?sgJoc9orGn0u7Afua5pRxuP3G1aDnjSEDEvUGEt098QSZ+hwMytjZZfVQ1XI?=
 =?us-ascii?Q?aepWI59UTKz87aQwwp8rKX7WumBpkjf1ow7coSWg1P9iG47BHVU2+ovoXqrS?=
 =?us-ascii?Q?6gBC3F0uGc9CQ3gmXeplowD7KjAGZg0=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f4b28ed-9b0e-477b-7e1e-08da48bb4dce
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 19:24:12.9996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CGX1sN6WEqVUw7GMB6l4vXcWwc9FyWTqg3cwBK4T/UCRriJF1dk81VskcumT1DOq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3797
X-Proofpoint-GUID: z6-Tjlt6iMPCXWj03bfQnoB1aSoakWyr
X-Proofpoint-ORIG-GUID: z6-Tjlt6iMPCXWj03bfQnoB1aSoakWyr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_08,2022-06-07_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 06, 2022 at 03:46:21PM -0700, Stanislav Fomichev wrote:
> > > +int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> > > +                                 struct bpf_attach_target_info *tgt_info,
> > > +                                 int cgroup_atype)
> > > +{
> > > +     struct bpf_shim_tramp_link *shim_link = NULL;
> > > +     struct bpf_trampoline *tr;
> > > +     bpf_func_t bpf_func;
> > > +     u64 key;
> > > +     int err;
> > > +
> > > +     key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
> > > +                                      prog->aux->attach_btf_id);
> > Directly get tgt_info here instead of doing it
> > in __cgroup_bpf_attach() and then passing in.
> > This is the only place needed it.
> 
> Ack.
> 
> >         err = bpf_check_attach_target(NULL, prog, NULL,
> >                                 prog->aux->attach_btf_id,
> >                                 &tgt_info);
> >         if (err)
> >                 return err;
> >
> > > +
> > > +     bpf_lsm_find_cgroup_shim(prog, &bpf_func);
> > > +     tr = bpf_trampoline_get(key, tgt_info);
> > > +     if (!tr)
> > > +             return  -ENOMEM;
> > > +
> > > +     mutex_lock(&tr->mutex);
> > > +
> > > +     shim_link = cgroup_shim_find(tr, bpf_func);
> > > +     if (shim_link) {
> > > +             /* Reusing existing shim attached by the other program. */
> > > +             atomic64_inc(&shim_link->link.link.refcnt);
> > Use bpf_link_inc() instead to pair with bpf_link_put().
> 
> SG!
> 
> > > +             /* note, we're still holding tr refcnt from above */
> > It has to do a bpf_trampoline_put(tr) after mutex_unlock(&tr->mutex).
> > shim_link already holds one refcnt to tr.
> 
> Right, since we are not doing that reuse anymore; will add a deref here.
> 
> 
> 
> 
> > > +
> > > +             mutex_unlock(&tr->mutex);
> > > +             return 0;
> > > +     }
> > > +
> > > +     /* Allocate and install new shim. */
> > > +
> > > +     shim_link = cgroup_shim_alloc(prog, bpf_func, cgroup_atype);
> > > +     if (!shim_link) {
> > > +             err = -ENOMEM;
> > > +             goto out;
> > > +     }
> > > +
> > > +     err = __bpf_trampoline_link_prog(&shim_link->link, tr);
> > > +     if (err)
> > > +             goto out;
> > > +
> > > +     shim_link->trampoline = tr;
> > > +     /* note, we're still holding tr refcnt from above */
> > > +
> > > +     mutex_unlock(&tr->mutex);
> > > +
> > > +     return 0;
> > > +out:
> > > +     mutex_unlock(&tr->mutex);
> > > +
> > > +     if (shim_link)
> > > +             bpf_link_put(&shim_link->link.link);
> > > +
> > > +     bpf_trampoline_put(tr); /* bpf_trampoline_get above */
> > Doing it here is because mutex_unlock(&tr->mutex) has
> > to be done first?  A comment will be useful.
> >
> > How about passing tr to cgroup_shim_alloc(..., tr)
> > which is initializing everything else in shim_link anyway.
> > Then the 'if (!shim_link->trampoline)' in bpf_shim_tramp_link_release()
> > can go away also.
> > Like:
> >
> > static struct bpf_shim_tramp_link *cgroup_shim_alloc(const struct bpf_prog *prog,
> >                                                      bpf_func_t bpf_func,
> >                                                      struct bpf_trampoline *tr)
> >
> > {
> >         /* ... */
> >         shim_link->trampoline = tr;
> 
> I believe this part has to happen after __bpf_trampoline_link_prog;
> otherwise bpf_shim_tramp_link_release might try to
> unlink_prog/bpf_trampoline_put on the shim that wan't fully linked?
Ah.  You are correct.  missed that.

Yeah, I don't see a better way out unless a separate shim_link cleanup
func is used during the error case.  That may be overkill.
The current approach in the patch is better.

> > > @@ -10474,6 +10486,23 @@ static int check_return_code(struct bpf_verifier_env *env)
> > >       case BPF_PROG_TYPE_SK_LOOKUP:
> > >               range = tnum_range(SK_DROP, SK_PASS);
> > >               break;
> > > +
> > > +     case BPF_PROG_TYPE_LSM:
> > > +             if (env->prog->expected_attach_type == BPF_LSM_CGROUP) {
> > > +                     if (!env->prog->aux->attach_func_proto->type) {
> > nit. Check 'if ( ... != BPF_LSM_CGROUP) return 0;' first to remove
> > one level of indentation.
> 
> SG!
> 
> > > +                             /* Make sure programs that attach to void
> > > +                              * hooks don't try to modify return value.
> > > +                              */
> > > +                             range = tnum_range(1, 1);
> > > +                     }
> > > +             } else {
> > > +                     /* regular BPF_PROG_TYPE_LSM programs can return
> > > +                      * any value.
> > > +                      */
> > > +                     return 0;
> > > +             }
> > > +             break;
> > > +
> > >       case BPF_PROG_TYPE_EXT:
> > >               /* freplace program can return anything as its return value
> > >                * depends on the to-be-replaced kernel func or bpf program.
> > > @@ -10490,6 +10519,8 @@ static int check_return_code(struct bpf_verifier_env *env)
> > >
> > >       if (!tnum_in(range, reg->var_off)) {
> > >               verbose_invalid_scalar(env, reg, &range, "program exit", "R0");
> > > +             if (env->prog->expected_attach_type == BPF_LSM_CGROUP)
> > > +                     verbose(env, "BPF_LSM_CGROUP that attach to void LSM hooks can't modify return value!\n");
> > This is not accurate to verbose on void-return only.
> > For int-return lsm look, the BPF_LSM_CGROUP prog returning
> > neither 0 nor 1 will also trigger this range check failure.
> 
> verbose_invalid_scalar will handle the case for int-returning ones?
> 
> Maybe change that new verbose to "Note, BPF_LSM_CGROUP that attach to
> void LSM hooks can't modify return value!" ?
I was thinking only verbose_invalid_scalar is good enough.

Having the new 'void LSM hooks' message may confuse the lsm-hooks that
have an int ret type and the bpf prog returns -1.
If keeping this verbose,  I think adding
'!attach_func_proto->type' check should be useful before
printing.  No strong opinion here.

> 
> 
> > >               return -EINVAL;
> > >       }
> > >
> > > @@ -14713,6 +14744,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
> > >               fallthrough;
> > >       case BPF_MODIFY_RETURN:
> > >       case BPF_LSM_MAC:
> > > +     case BPF_LSM_CGROUP:
> > >       case BPF_TRACE_FENTRY:
> > >       case BPF_TRACE_FEXIT:
> > >               if (!btf_type_is_func(t)) {
