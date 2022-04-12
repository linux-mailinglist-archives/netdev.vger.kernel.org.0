Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C71D4FCBEE
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 03:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbiDLBjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 21:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344327AbiDLBjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 21:39:10 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D7121E10;
        Mon, 11 Apr 2022 18:36:51 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 23BMK0LJ006182;
        Mon, 11 Apr 2022 18:36:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=V6kumjzwO5cLxpW1Be3s8aIxjYwIjJxGz2twNMRyd+Q=;
 b=Lk1BKhyLE8slmpxTXu2N1uKsEG11bRiTBf6xRt2eyOjrf4APyEXG3C+rXJN0OPocYdsa
 v15f2qMGqzq9QlIhofdSaODbgf6Ei2f6FoQR3M/3t6sAwu2+uIDJ7tSrW6V2gymWiv3/
 aU/+QiCKPuVLCNgxZron4EdLHruEZGuTDt0= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by m0089730.ppops.net (PPS) with ESMTPS id 3fckykcs1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 18:36:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3neg+D11Kn7NQmQOfA5sdqcKW5ozIVUZN7vjDV+sYUlL1fg/6xH43l+uEFdM6yas2XrhMdqNqjauPV9YGGZlz6WHtWeqDFep8IvteSiZWiQHU1y2K1PGal7kN2h53HEUxHVwPd4WursYWHjHEpRB7ybF1r+aEWHCJZdFCP6YQ1eog0DwNi5Wl6zGITFnRQhKW2XkXJoKV9zAgahcw7sQEs2Zz782HI/Cjcg7jMdXOmpQCrBsfQ8Ldom8Zq0ObmkpstnSpc60rdDMlImmhVepVHC3HFpIjp8VO/KWY7LrSijnqF4ptuVwHEZ67RVR9ieM3puGNx1D6R5lx5hlttuHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V6kumjzwO5cLxpW1Be3s8aIxjYwIjJxGz2twNMRyd+Q=;
 b=Ce7OkOdLsi0TGJNAqyMvfKYHhdBY0fc2IpD3dcGwUayQQ73eGBNHOog7PrPEX09zwSPwnPEC3RjbN7/4HxorOkfYJ3lU6o2r+HbIYWHYb/MMS99t+WGGOHSy24RmL+9dxJRNn6mEYnBom37Ng1GBlWWmDO48hsUq/v4xIJyz6yg2fNQj71dNMfR4+O0f1/wiJSfm6atnh6Dw7sa+btaJ78NnwzgQvvA3siAE8uJ62kv6wPMSIRmuuOEMLNd4Rfs0BjuZGYiDyTbgGsiBf7/PypEIt03YJ8Rqf3V/0djvlDe9EUG04Tf7giZxC5kvEKRNo+1uYB5kauud472RABzgZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by PH7PR15MB5125.namprd15.prod.outlook.com (2603:10b6:510:139::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 01:36:34 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983%5]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 01:36:34 +0000
Date:   Mon, 11 Apr 2022 18:36:31 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v3 3/7] bpf: minimize number of allocated lsm
 slots per program
Message-ID: <20220412013631.tntvx7lw3c7sw6ur@kafai-mbp.dhcp.thefacebook.com>
References: <20220407223112.1204582-1-sdf@google.com>
 <20220407223112.1204582-4-sdf@google.com>
 <20220408225628.oog4a3qteauhqkdn@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBuMMuuUJiZJY8Gb+tMQLKoRGpvv58sSM4sZXjyEc0i7dA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBuMMuuUJiZJY8Gb+tMQLKoRGpvv58sSM4sZXjyEc0i7dA@mail.gmail.com>
X-ClientProxiedBy: BYAPR05CA0095.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::36) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1548e785-9d80-47fd-fcb9-08da1c24e0ac
X-MS-TrafficTypeDiagnostic: PH7PR15MB5125:EE_
X-Microsoft-Antispam-PRVS: <PH7PR15MB512576E31E63D10C1A9FCA21D5ED9@PH7PR15MB5125.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B/g0BAmeCn03ADOdMoHyTyOhl6Af+ZeVPzv750g8MTZCc+bf5UXtIWSPJKo+p/w0Daydwwy2B8KSXQHFaWEg0NG5Y7jhOevrOmoIGfU9Ml++DQHrOTRayfgo4f7D43Fl8auqb/AQHAJd5S6+4puy3PvlVsaiDfvk8ZD5/NW0nMcCwyXq1MqqqZDjXYPk31BGYAkjP2atmQwd0bkB+uS7UIsZJdwYS27XbbPnjnqRowPg+4+4u956Y0OVJ0mG+Np2eb/IHwriiXkNQWXmrtrVKJFuRT8sfhyEpiKIeNqrqmy832wFzj85Ykr/sxfJjtyDFiOMtjm3l0qP7yNI5aFhygOjB64mOginquskEhFMG+PMz1pogEmfS1LLwwdlJsL5P+ps6L+fmexeqTCmk1MlmVXx9YZwJbQ5yZa5B6SMdNylknttlvVnGtBw9L7TPR9YLK1xudaDxl2fOLgFIfS3P/TW3VhNX+Kr7Olj9Eg+d7fWh1LETrOJGeFkRaXKvqrINPKn0PswemmjcfvzeYmwOc42aNBc3AwR3pyNMx9OatgH2/0N8Y05n7h6aGL0CgFPY167mgsfxMtvELvj9R2splfU9sDYSbkBIzWzWHIrP1z3Uav/o6Oz91Zlt2WBHxw+5pVKWK1k9+Xd5I9a0xNCow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52116002)(9686003)(2906002)(5660300002)(316002)(83380400001)(1076003)(186003)(6512007)(508600001)(6666004)(6506007)(8936002)(53546011)(6916009)(86362001)(8676002)(66556008)(66946007)(4326008)(66476007)(6486002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XvLFFjyjvv/CI64ECvMAVAbryHrQu/r2iCxcMi4aRdt3KoU3LtD3fJ956yJ5?=
 =?us-ascii?Q?XIiy8j4WS2bdNH/uvuwHPUj9iNQdIzYo7rZ6eEyxNtrDCMmj1GckP+3WMs7T?=
 =?us-ascii?Q?emlfpquCAE3UKua4Y8n+uwMgBvU2DhFZgVcMlPmYqrjoqtgvZFLKbv3amOrU?=
 =?us-ascii?Q?dhP+/3yLdb4HCdjPQrKY94NIHnnnuNYmOSyjg2pPuwrDEMO3M2qwbXv+ZrJB?=
 =?us-ascii?Q?LarhoUQ41nRfjRROFx69gLdSzjd4MCWy8LiVIJs7IKx3gvqTzyL9XeclG20g?=
 =?us-ascii?Q?xSzzBR+JBudhlvpn0RmgL+F9K62ePQgOwWDHJWMRN5p3LHtbAX+w/n/budwS?=
 =?us-ascii?Q?o7HQ2StffpgnI38jd7tkzEi+xZh2AF+esUCjjef3RADtgj+w0/x0qlzMzKjz?=
 =?us-ascii?Q?Q5Em1Af4bACHE0UrmXgK63bIdy4rvk5vzTmXFjn23Zwh0al05pM5zPFiYjWb?=
 =?us-ascii?Q?ZsfGBI/h6l29Ax8/G+Zdfzdpg9LfsqHPzwt5kVJpRihTHxkwRtGXdR+fwxy+?=
 =?us-ascii?Q?mLsZKTfTeGU81gOfq74Qkf4cE3wVbK5VOCrUjrj4uNZ3XA6cCaQQptXTSFdi?=
 =?us-ascii?Q?oQUgW63IqnYsb9THF0P9nUJQeou6CN+LXVoE0gYvCXV7uC5ge4nnVzAvI/ie?=
 =?us-ascii?Q?xyoDXEpOIa9ccwfAPE6ZTo3QHiL+N4iO72GmNTGfES0jkj2Q2hNUOJcBoiR8?=
 =?us-ascii?Q?pLoFcg9jv6pX5HEeXpOvOmTLFRxEdrXcTYBm66Di/qKrPgQ4PUUS/fF6PNaY?=
 =?us-ascii?Q?4YbYEN9Pev/VkV8YsftRpFOLgxlq/g8+Bxy3oqQbgAyH6LBsBBhpPkCEu7Kr?=
 =?us-ascii?Q?ypSVISPIZaYDI01HhbbialZRyLawSBTSOo8O150z0nBQltyEXLleRyb4zcIL?=
 =?us-ascii?Q?68mWVRVmN9Ep8ygoF3uvEyic6xNhxEp0Qafn0Io1w8z3iDfc/31bO339rspS?=
 =?us-ascii?Q?9aJH9JiOSElm3gfYATTInoTxLfWPesjgTS3Zt6/OqMrP4YAKL6oAn1oubgO/?=
 =?us-ascii?Q?bC3C0hDsv4J8pgs904Ns3fEj6E77oPpKiItij1EnMDRQx4G+fETEMG3HZWZM?=
 =?us-ascii?Q?tA9iJAMal6VDtF0RWx4V/rGs8B0nCDBPHfPlnZ7CVPmZ3GeizRIG3qizh9MY?=
 =?us-ascii?Q?qrAMH39K3qsOCIGrt8xOj0yhKRXsFnEL3/NuiukexOgICjDaVGKFOSiJq5hK?=
 =?us-ascii?Q?fQqVszZo5RRTJusVCmrN2R/RwqhgbdSCO/m+aosAuoFQL/L42k+aw3rjtwDu?=
 =?us-ascii?Q?uGmzZ4YWFIg5iC3HGuzmhWf+I4xcYuJOudINEQB+VWSRw3LHZARxKiRUx1ZX?=
 =?us-ascii?Q?xT8Jz1x8VYlBi75w1faqk3R/PcQWKCdDvaW7hpqjjwrY6lFYehGGpZLihSJC?=
 =?us-ascii?Q?C9otMMD16RRcbaKKyjD4Xoa+f1MyagDVNldrKSD4+eMJEVLGqona4wcRJ4lK?=
 =?us-ascii?Q?Sqrz3toatYNcK83G3nT28x0+HKu1p7CbeSpJYjsQMzkFoxXkbOlhZA1ql24Y?=
 =?us-ascii?Q?Ro0e5u5/XfQWreYiLVNX6rmMzARTFUREVEnhAq0WD/GkXmdORGUD+WByU3bh?=
 =?us-ascii?Q?BL6sdBZe0C9tIk3lvmRGecQ4AtMJpu0YUkEnco7j1ok6nPL170EgHWtvXLBj?=
 =?us-ascii?Q?DDOu1eM7AnzN47YqP/F8V4NOHWhdlQh2n6WmgJeJKbJqdAmKlMb7Ve+h9G+e?=
 =?us-ascii?Q?kNPaRvo+WXv9pWt2pLvbc/j66EKD7mRlGQk/a3MgofYLM8i7Z+1zDMxyf07W?=
 =?us-ascii?Q?a8mmmGtNbMFrs411meUTGw43Cm7Wcec=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1548e785-9d80-47fd-fcb9-08da1c24e0ac
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 01:36:34.1898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2TuIxKs0LSwieZHYE3xdrOP3Dr2CedXx4dy9HbIGCkOT24LYw6sJDAowKM9CmsQK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5125
X-Proofpoint-ORIG-GUID: 22OweY-QcEELjvg-38XmtdU_EqjPL2av
X-Proofpoint-GUID: 22OweY-QcEELjvg-38XmtdU_EqjPL2av
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

On Mon, Apr 11, 2022 at 11:46:20AM -0700, Stanislav Fomichev wrote:
> On Fri, Apr 8, 2022 at 3:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Thu, Apr 07, 2022 at 03:31:08PM -0700, Stanislav Fomichev wrote:
> > > Previous patch adds 1:1 mapping between all 211 LSM hooks
> > > and bpf_cgroup program array. Instead of reserving a slot per
> > > possible hook, reserve 10 slots per cgroup for lsm programs.
> > > Those slots are dynamically allocated on demand and reclaimed.
> > > This still adds some bloat to the cgroup and brings us back to
> > > roughly pre-cgroup_bpf_attach_type times.
> > >
> > > It should be possible to eventually extend this idea to all hooks if
> > > the memory consumption is unacceptable and shrink overall effective
> > > programs array.
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  include/linux/bpf-cgroup-defs.h |  4 +-
> > >  include/linux/bpf_lsm.h         |  6 ---
> > >  kernel/bpf/bpf_lsm.c            |  9 ++--
> > >  kernel/bpf/cgroup.c             | 96 ++++++++++++++++++++++++++++-----
> > >  4 files changed, 90 insertions(+), 25 deletions(-)
> > >
> > > diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> > > index 6c661b4df9fa..d42516e86b3a 100644
> > > --- a/include/linux/bpf-cgroup-defs.h
> > > +++ b/include/linux/bpf-cgroup-defs.h
> > > @@ -10,7 +10,9 @@
> > >
> > >  struct bpf_prog_array;
> > >
> > > -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> > > +/* Maximum number of concurrently attachable per-cgroup LSM hooks.
> > > + */
> > > +#define CGROUP_LSM_NUM 10
> > hmm...only 10 different lsm hooks (or 10 different attach_btf_ids) can
> > have BPF_LSM_CGROUP programs attached.  This feels quite limited but having
> > a static 211 (and potentially growing in the future) is not good either.
> > I currently do not have a better idea also. :/
> >
> > Have you thought about other dynamic schemes or they would be too slow ?
> >
> > >  enum cgroup_bpf_attach_type {
> > >       CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
> > > diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> > > index 7f0e59f5f9be..613de44aa429 100644
> > > --- a/include/linux/bpf_lsm.h
> > > +++ b/include/linux/bpf_lsm.h
> > > @@ -43,7 +43,6 @@ extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
> > >  void bpf_inode_storage_free(struct inode *inode);
> > >
> > >  int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
> > > -int bpf_lsm_hook_idx(u32 btf_id);
> > >
> > >  #else /* !CONFIG_BPF_LSM */
> > >
> > > @@ -74,11 +73,6 @@ static inline int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> > >       return -ENOENT;
> > >  }
> > >
> > > -static inline int bpf_lsm_hook_idx(u32 btf_id)
> > > -{
> > > -     return -EINVAL;
> > > -}
> > > -
> > >  #endif /* CONFIG_BPF_LSM */
> > >
> > >  #endif /* _LINUX_BPF_LSM_H */
> > > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > > index eca258ba71d8..8b948ec9ab73 100644
> > > --- a/kernel/bpf/bpf_lsm.c
> > > +++ b/kernel/bpf/bpf_lsm.c
> > > @@ -57,10 +57,12 @@ static unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
> > >       if (unlikely(!sk))
> > >               return 0;
> > >
> > > +     rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
> > >       cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > >       if (likely(cgrp))
> > >               ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> > >                                           ctx, bpf_prog_run, 0);
> > > +     rcu_read_unlock();
> > >       return ret;
> > >  }
> > >
> > > @@ -77,7 +79,7 @@ static unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> > >       /*prog = container_of(insn, struct bpf_prog, insnsi);*/
> > >       prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> > >
> > > -     rcu_read_lock();
> > > +     rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
> > I think this is also needed for task_dfl_cgroup().  If yes,
> > will be a good idea to adjust the comment if it ends up
> > using the 'CGROUP_LSM_NUM 10' scheme.
> >
> > While at rcu_read_lock(), have you thought about what major things are
> > needed to make BPF_LSM_CGROUP sleepable ?
> >
> > The cgroup local storage could be one that require changes but it seems
> > the cgroup local storage is not available to BPF_LSM_GROUP in this change set.
> > The current use case doesn't need it?
> 
> No, I haven't thought about sleepable at all yet :-( But seems like
> having that rcu lock here might be problematic if we want to sleep? In
> this case, Jakub's suggestion seems better.
The new rcu_read_lock() here seems fine after some thoughts.

I was looking at the helpers in cgroup_base_func_proto() to get a sense
on sleepable support.  Only the bpf_get_local_storage caught my eyes for
now because it uses a call_rcu to free the storage.  That will be the
major one to change for sleepable that I can think of for now.
