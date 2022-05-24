Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8232532FE1
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 19:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240094AbiEXRvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 13:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240104AbiEXRu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 13:50:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FAC5DA07;
        Tue, 24 May 2022 10:50:58 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHWCFO027476;
        Tue, 24 May 2022 10:50:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=9TiAeXflFMLCLK/socDRSdroctcnitdlMAHl6I+wqKc=;
 b=brkadNKj0nwhwo7qaUiW64VjlwiqSEm89+H9Blqx4g3Q89EErzgkOMpBmixDdqVjNK7e
 96h4rdt9uBciKhaAhKaAUjAWRj5yFabrHQvTCeW1mOLVVyYBdI7lPtJyy1DfoCEOczcE
 9Puk+8oKbE9On7GLcMOIz4DTPT1JQbZaWPU= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g93uhr52n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 10:50:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gegF3jEV+LRmPd4W1I7lpBdmscR0elh6UThGMNp6ui3PG99eiRmOcus/CXS3xwwqRd5+PdAcNcaTFet8u1jFHmwBg3DjZTXzn96owRe9wkLrQBguw/OxfU439A7l5Akx6PMKhs8x8XuQNlwKQxwVz9yVNg1Mqx2HYDUYkYTXK2ZdRW92U5c6lq3o11cYCI/auY6G31k3KEJR1Og3RNk6cZ2y/aEit3J+rukon4Pj/9sK6PvnzDR716vHmdrUPqzHPjNU55M2G4D/bFH5TGCunVHX06pPF31vZP8+xT4gURzO51v04M+Jfhf+zr1M8wTEfxSExuLW7frahYw/DJrXhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9TiAeXflFMLCLK/socDRSdroctcnitdlMAHl6I+wqKc=;
 b=IPcNOI9pyH5RXF60UVaaQqXp8I16Xcklpm+I1LzyrMV37/iZlsNtrnfjZ39ajK3uVNMpqDuHdR7XlhbQmvNKNkGeeBwRG/ecOR3xH3b4o+zwrAqlv6E+cFxqGZUnrx9MLEBJVm2KLeyMFlDcT+5FezBKeP5ct1fDNfOxrtQIIyl0t4CMsXb5iRMEjXxt3O+llVXGaw+IT0Q3WVED7FFS4Q8Wk6KlCDTiJWyz0hfdc7xCR2pJQBiDWWV5h46394Z6fXjlC7j55TGze3VfaRHy809EnsdR29OhtIR4Do8OBQjVZFaFOaQBwiyJEWiqZrER/ueeCqRrkldbg9m3tol6VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MW2PR1501MB1980.namprd15.prod.outlook.com (2603:10b6:302:c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.21; Tue, 24 May
 2022 17:50:38 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::44a1:2ac9:9ebd:a419]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::44a1:2ac9:9ebd:a419%6]) with mapi id 15.20.5293.013; Tue, 24 May 2022
 17:50:38 +0000
Date:   Tue, 24 May 2022 10:50:35 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v7 05/11] bpf: implement BPF_PROG_QUERY for
 BPF_LSM_CGROUP
Message-ID: <20220524175035.i2ltl7gcrp2sng5r@kafai-mbp>
References: <20220518225531.558008-1-sdf@google.com>
 <20220518225531.558008-6-sdf@google.com>
 <20220524034857.jwbjciq3rfb3l5kx@kafai-mbp>
 <CAKH8qBuCZVNPZaCRWrTiv7deDCyOkofT_ypvAiuE=OMz=TUuJw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBuCZVNPZaCRWrTiv7deDCyOkofT_ypvAiuE=OMz=TUuJw@mail.gmail.com>
X-ClientProxiedBy: BYAPR11CA0047.namprd11.prod.outlook.com
 (2603:10b6:a03:80::24) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 867a3eee-759f-4c06-68a2-08da3dade94d
X-MS-TrafficTypeDiagnostic: MW2PR1501MB1980:EE_
X-Microsoft-Antispam-PRVS: <MW2PR1501MB1980AF42E90099E7C911D4F4D5D79@MW2PR1501MB1980.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HAL+pkUYCn7WxekhaauKSVDnxvb1ucqbvCkqYuvdF0VgZlu35YxZKTvW9WHgE0mDPyjanr50kbHRX6KPKM7HlaeELMjjTUwlU0h3yUrnbTX5SzPB5U141QiCl1Ek7392qukK1JVEKbN3aR+uLGbwpRBeXQ3s6TUPL/ufg0kUdbSxvyx5dS15b3K+2ifgb2Rln5hPVFYhHB8R/95c5fNpyQSAdP98AGJTju4nz+kGzPLf+aQCGpuQNw7wOEAi2SO+4sHL06iuz/b6dSOMgreQKvlSWWwa0fYDMQng1c/7r1p17HPC3TZOrS09xHrJxiqv22AN/W0L9C/cBu6sH5yM3J2z++bUKPa83PpSjDy5S4KRMypS69TIw+HyyghnqwQOU4DmziSKgyVH0sXWgXErwogsx0Y/55dYituFJv9f7cCAnThNIgycV9KrvI2ZGM/WnoCKi08Fe9pyQtvdkLssnNJJKczs2inG3yh0jkhzVFJUovSeNZBblTneqbE+qJ1XLA8sUM1bYLdimpCFKo+GmmTXvpXVMwihBJcHKnGJojgtDkCoB/AKfzZrLK7weMH585BgzRBsB5VpapaYkSNSotiHdSqGpsfPSFbyv2VM2FlpZRa2ByyrefmfUoK0pTqc+iQcXMkFt5MkS2kQXZEY9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(66476007)(316002)(6486002)(4326008)(33716001)(6666004)(52116002)(2906002)(86362001)(66556008)(6916009)(38100700002)(508600001)(53546011)(6506007)(8936002)(1076003)(186003)(66946007)(5660300002)(83380400001)(9686003)(6512007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WAAbBjmU7WJ5XPHCwT+BUKCpIubMUe6vU8NBvpWcqibL2RUmdZtN1Whcms1s?=
 =?us-ascii?Q?TE0IkbSWmRA2yXX1o5kv/2J/E0xb1zZEegpFvif0pKNe1vxQny9Ln5cvCJwa?=
 =?us-ascii?Q?mVODUC4Wr7CMju5/qZeF0ZfSQmzigDSDvtMtaInA342aykEg2nKW7CrO2CrD?=
 =?us-ascii?Q?2C1YzMdSAAOO/5HpnVnXubniJxUJWyXsEw/YR+7rg2QpU6Aw3qO7IVSarYMf?=
 =?us-ascii?Q?KE0fem/tJX2zSMxR4Xq8FK3KOImobKQa0IusILQ8WA0Qatxo6DlwLoB0vkln?=
 =?us-ascii?Q?1HywcEt+4DSlvZq6dnfJRCacprvLcup1BuIYotnP/JNleExxb0+Csu7jrY7J?=
 =?us-ascii?Q?wdQPoprOPKcy6ctONo9/3bUqNb9nnzGkX/4of547njDGuMdgoQZuAwwlOwf2?=
 =?us-ascii?Q?ldqi+fhG+WoK6e9oQRJjtY+/U4TXEfHPgFJ9KWJpnYZGx8CVW2+Bz+G0uxbt?=
 =?us-ascii?Q?1mrorfrJlnHbdxp4KGR1PM97sAelQ39nkWq4NNE6GU4sSP9sk7yI7w727GsU?=
 =?us-ascii?Q?sCapC4ODyZHiZyXrBxmB7xuMc5fh1vU1RnB3RKL7oN4sgLzEwWZrszi5TRY6?=
 =?us-ascii?Q?GOWolovTGq1i4PfTrZ0qbjionnIeFhNr+Bb7EDBOI4nOPeCoDsDIAQOtyVIR?=
 =?us-ascii?Q?hK+awdaOXw+EZ+YuZyXA5uHKO+HBCVES2Gd+LWMe7prwXV8zRpf7NAOuXMPI?=
 =?us-ascii?Q?EZ0IQ2mAYKLmRGjRxpCmLWDtOUiuIM3X85kM14uao1Lqo7cih1NBrMroYIx4?=
 =?us-ascii?Q?T6r4Pb8J1cXhOCRXuvhBFGrBGIql/0Xj2SEGUyvAzNst15YaATdxdEuTotCS?=
 =?us-ascii?Q?65EeEyVaDesN6DGFNm9nC0Ts7Kysym61QFBtVzJzASwjyn6L7wIRTBDrpEx5?=
 =?us-ascii?Q?fdgZ9qwpq6R/++Kq6NQnSM3K7rd+7OAcFe5ob40nvnlRYLhh5y/kXlJmYeWs?=
 =?us-ascii?Q?+0N965JdMVYvKuq7PSQwc3hVDy6mhmjfRLhcrRKhAYbG4U1/1RqdSkjAD7JD?=
 =?us-ascii?Q?d6XBlOemiN+I/FE1Oc232P4U6Pj/B5AtpQWE2fG6t9EZtcfxBE42gs0JY8FT?=
 =?us-ascii?Q?nrWjJyMHBaEl+1Z1HwOa8Q/47+VDpvFVZImEGySzVSMR1efePMtj2pZgro4G?=
 =?us-ascii?Q?1y59WSDWaKuS4lJgc5dL8kHaK7pgiOHHbhqUkSo2pLSlMJ5h7EK0hLpBrxKW?=
 =?us-ascii?Q?49AEgl+x86lFrXvYyG8pzkCKBG2kfPj0KwcDriL+DG2qamzv18AM1wsDqHeL?=
 =?us-ascii?Q?dbFLUEi/f+aiXGVDKx3NsYlyWg4QMI+3leW0ANRM5GMrez9nl6tGacS93n9N?=
 =?us-ascii?Q?85g+ke6P/8qP6LbMj/xA0AXM94gdgsDdV/tUul33jvyRdRAmuJeUneLmR+p9?=
 =?us-ascii?Q?U1NSXZ9KfsIH8a5MboJGwufCLWeJVkUAJgTwWbeesoHGphkHfDLafYVFv7vd?=
 =?us-ascii?Q?ZOmDCqYyRgPJQ2ScPfBpuc6AWSQoB2xGtnEzO8btsRDb+aB+y/lgkeqyvAcf?=
 =?us-ascii?Q?v3yawd4n9W/80FxSCf0HhGUdefk4pxElnfeISMA/Uk8ZaRBM7HWZK1W/4BA8?=
 =?us-ascii?Q?zpdUX+LNhsEZXFT2XhfGo/Wqj2J0TOhqyjvLLyIoctfhRH227NiGUouVRUuX?=
 =?us-ascii?Q?ckSqxS2CuXTJeM0tRYuFw/Hym+cYaaHLT0POm/hDkOjFWCbbRFAshnqq6WFb?=
 =?us-ascii?Q?jk9Yj7HcaYw9Ja+tsG0G5soFKBoWLT3jhQcnGq5NNXwjeJTG/qMWVYey366H?=
 =?us-ascii?Q?FVv7q3haFZMF/73JxDoQTNEPyrCrS/U=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 867a3eee-759f-4c06-68a2-08da3dade94d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 17:50:38.0698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9MRjZKiYqJUVPRQTHpidraivuw89cIplkNrJeU/izTXDGpPXxDHDyLpPSUjbLFCB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB1980
X-Proofpoint-GUID: 5vSG5Dr5dpLI870dRPZsA3b3GGSzDQ-T
X-Proofpoint-ORIG-GUID: 5vSG5Dr5dpLI870dRPZsA3b3GGSzDQ-T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_08,2022-05-23_01,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 08:55:04AM -0700, Stanislav Fomichev wrote:
> On Mon, May 23, 2022 at 8:49 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, May 18, 2022 at 03:55:25PM -0700, Stanislav Fomichev wrote:
> > > We have two options:
> > > 1. Treat all BPF_LSM_CGROUP the same, regardless of attach_btf_id
> > > 2. Treat BPF_LSM_CGROUP+attach_btf_id as a separate hook point
> > >
> > > I was doing (2) in the original patch, but switching to (1) here:
> > >
> > > * bpf_prog_query returns all attached BPF_LSM_CGROUP programs
> > > regardless of attach_btf_id
> > > * attach_btf_id is exported via bpf_prog_info
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  include/uapi/linux/bpf.h |   5 ++
> > >  kernel/bpf/cgroup.c      | 103 +++++++++++++++++++++++++++------------
> > >  kernel/bpf/syscall.c     |   4 +-
> > >  3 files changed, 81 insertions(+), 31 deletions(-)
> > >
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index b9d2d6de63a7..432fc5f49567 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -1432,6 +1432,7 @@ union bpf_attr {
> > >               __u32           attach_flags;
> > >               __aligned_u64   prog_ids;
> > >               __u32           prog_cnt;
> > > +             __aligned_u64   prog_attach_flags; /* output: per-program attach_flags */
> > >       } query;
> > >
> > >       struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
> > > @@ -5911,6 +5912,10 @@ struct bpf_prog_info {
> > >       __u64 run_cnt;
> > >       __u64 recursion_misses;
> > >       __u32 verified_insns;
> > > +     /* BTF ID of the function to attach to within BTF object identified
> > > +      * by btf_id.
> > > +      */
> > > +     __u32 attach_btf_func_id;
> > >  } __attribute__((aligned(8)));
> > >
> > >  struct bpf_map_info {
> > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > index a959cdd22870..08a1015ee09e 100644
> > > --- a/kernel/bpf/cgroup.c
> > > +++ b/kernel/bpf/cgroup.c
> > > @@ -1074,6 +1074,7 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> > >  static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> > >                             union bpf_attr __user *uattr)
> > >  {
> > > +     __u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
> > >       __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
> > >       enum bpf_attach_type type = attr->query.attach_type;
> > >       enum cgroup_bpf_attach_type atype;
> > > @@ -1081,50 +1082,92 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> > >       struct hlist_head *progs;
> > >       struct bpf_prog *prog;
> > >       int cnt, ret = 0, i;
> > > +     int total_cnt = 0;
> > >       u32 flags;
> > >
> > > -     atype = to_cgroup_bpf_attach_type(type);
> > > -     if (atype < 0)
> > > -             return -EINVAL;
> > > +     enum cgroup_bpf_attach_type from_atype, to_atype;
> > >
> > > -     progs = &cgrp->bpf.progs[atype];
> > > -     flags = cgrp->bpf.flags[atype];
> > > +     if (type == BPF_LSM_CGROUP) {
> > > +             from_atype = CGROUP_LSM_START;
> > > +             to_atype = CGROUP_LSM_END;
> > > +     } else {
> > > +             from_atype = to_cgroup_bpf_attach_type(type);
> > > +             if (from_atype < 0)
> > > +                     return -EINVAL;
> > > +             to_atype = from_atype;
> > > +     }
> > >
> > > -     effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > -                                           lockdep_is_held(&cgroup_mutex));
> > > +     for (atype = from_atype; atype <= to_atype; atype++) {
> > > +             progs = &cgrp->bpf.progs[atype];
> > > +             flags = cgrp->bpf.flags[atype];
> > >
> > > -     if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > > -             cnt = bpf_prog_array_length(effective);
> > > -     else
> > > -             cnt = prog_list_length(progs);
> > > +             effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > +                                                   lockdep_is_held(&cgroup_mutex));
> > >
> > > -     if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> > > -             return -EFAULT;
> > > -     if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt)))
> > > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > > +                     total_cnt += bpf_prog_array_length(effective);
> > > +             else
> > > +                     total_cnt += prog_list_length(progs);
> > > +     }
> > > +
> > > +     if (type != BPF_LSM_CGROUP)
> > > +             if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> > > +                     return -EFAULT;
> > > +     if (copy_to_user(&uattr->query.prog_cnt, &total_cnt, sizeof(total_cnt)))
> > >               return -EFAULT;
> > > -     if (attr->query.prog_cnt == 0 || !prog_ids || !cnt)
> > > +     if (attr->query.prog_cnt == 0 || !prog_ids || !total_cnt)
> > >               /* return early if user requested only program count + flags */
> > >               return 0;
> > > -     if (attr->query.prog_cnt < cnt) {
> > > -             cnt = attr->query.prog_cnt;
> > > +
> > > +     if (attr->query.prog_cnt < total_cnt) {
> > > +             total_cnt = attr->query.prog_cnt;
> > >               ret = -ENOSPC;
> > >       }
> > >
> > > -     if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> > > -             return bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> > > -     } else {
> > > -             struct bpf_prog_list *pl;
> > > -             u32 id;
> > > +     for (atype = from_atype; atype <= to_atype; atype++) {
> > > +             if (total_cnt <= 0)
> > > +                     break;
> > >
> > > -             i = 0;
> > > -             hlist_for_each_entry(pl, progs, node) {
> > > -                     prog = prog_list_prog(pl);
> > > -                     id = prog->aux->id;
> > > -                     if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> > > -                             return -EFAULT;
> > > -                     if (++i == cnt)
> > > -                             break;
> > > +             progs = &cgrp->bpf.progs[atype];
> > > +             flags = cgrp->bpf.flags[atype];
> > > +
> > > +             effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > +                                                   lockdep_is_held(&cgroup_mutex));
> > > +
> > > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > > +                     cnt = bpf_prog_array_length(effective);
> > > +             else
> > > +                     cnt = prog_list_length(progs);
> > > +
> > > +             if (cnt >= total_cnt)
> > > +                     cnt = total_cnt;
> > > +
> > > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> > > +                     ret = bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> > > +             } else {
> > > +                     struct bpf_prog_list *pl;
> > > +                     u32 id;
> > > +
> > > +                     i = 0;
> > > +                     hlist_for_each_entry(pl, progs, node) {
> > > +                             prog = prog_list_prog(pl);
> > > +                             id = prog->aux->id;
> > > +                             if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> > > +                                     return -EFAULT;
> > > +                             if (++i == cnt)
> > > +                                     break;
> > > +                     }
> > >               }
> > > +
> > > +             if (prog_attach_flags)
> > > +                     for (i = 0; i < cnt; i++)
> > > +                             if (copy_to_user(prog_attach_flags + i, &flags, sizeof(flags)))
> > > +                                     return -EFAULT;
> > > +
> > > +             prog_ids += cnt;
> > > +             total_cnt -= cnt;
> > > +             if (prog_attach_flags)
> > > +                     prog_attach_flags += cnt;
> > >       }
> > >       return ret;
> > >  }
> > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > index 5ed2093e51cc..4137583c04a2 100644
> > > --- a/kernel/bpf/syscall.c
> > > +++ b/kernel/bpf/syscall.c
> > > @@ -3520,7 +3520,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
> > >       }
> > >  }
> > >
> > > -#define BPF_PROG_QUERY_LAST_FIELD query.prog_cnt
> > > +#define BPF_PROG_QUERY_LAST_FIELD query.prog_attach_flags
> > >
> > >  static int bpf_prog_query(const union bpf_attr *attr,
> > >                         union bpf_attr __user *uattr)
> > > @@ -3556,6 +3556,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
> > >       case BPF_CGROUP_SYSCTL:
> > >       case BPF_CGROUP_GETSOCKOPT:
> > >       case BPF_CGROUP_SETSOCKOPT:
> > > +     case BPF_LSM_CGROUP:
> > >               return cgroup_bpf_prog_query(attr, uattr);
> > >       case BPF_LIRC_MODE2:
> > >               return lirc_prog_query(attr, uattr);
> > > @@ -4066,6 +4067,7 @@ static int bpf_prog_get_info_by_fd(struct file *file,
> > >
> > >       if (prog->aux->btf)
> > >               info.btf_id = btf_obj_id(prog->aux->btf);
> > > +     info.attach_btf_func_id = prog->aux->attach_btf_id;
> > Note that exposing prog->aux->attach_btf_id only may not be enough
> > unless it can assume info.attach_btf_id is always referring to btf_vmlinux
> > for all bpf prog types.
> 
> We also export btf_id two lines above, right? Btw, I left a comment in
> the bpftool about those btf_ids, I'm not sure how resolve them and
> always assume vmlinux for now.
yeah, that btf_id above is the cgroup-lsm prog's btf_id which has its
func info, line info...etc.   It is not the one the attach_btf_id correspond
to.  attach_btf_id refers to either aux->attach_btf or aux->dst_prog's btf (or
target btf id here).

It needs a consensus on where this attach_btf_id, target btf id, and
prog_attach_flags should be.  If I read the patch 7 thread correctly,
I think Andrii is suggesting to expose them to userspace through link, so
potentially putting them in bpf_link_info.  The bpf_prog_query will
output a list of link ids.  The same probably applies to
the BPF_F_QUERY_EFFECTIVE query_flags but not sure about the prog_attach_flags
in this case and probably the userspace can figure that out by using
the cgroup_id in the link?  That is all I can think of right now
and don't have better idea :)
