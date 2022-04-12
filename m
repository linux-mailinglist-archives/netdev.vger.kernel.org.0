Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AED84FEB91
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbiDLXgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiDLXc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:32:58 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C65C6814;
        Tue, 12 Apr 2022 15:21:08 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23CHqQdT001477;
        Tue, 12 Apr 2022 13:19:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=LCblYoNH7nw6JhLpbIlgC2+geCG+hGnVEyOvPFPqYmo=;
 b=U+E6L8jWZj0LlW3/laDBIZsWS0rP6L1YvtY/8ioenCitOmZSXjv6Xlq38dO4TRgEJCZG
 o3MHHliq6ujGdJaQJyqYo3pTEHobiD/QE3F2xNVpJbw9aFid3eDngLeAJ1Fld5IT77QD
 oxgl2KntBPYcfPO2Nkpd8x55H9dBpSRr1Ws= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fd6p3uwy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 13:19:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zs1cQ8MQkGKnFvuQ44g9Q4I4XnMwbrVTwTy25ru19sRiJQgPAQDwVr962YpBoutrL7yZLfj3TO+SlQ6ijAJgurtaE0wqt/i5nWWB6f2ySebdS0rvLull4PTutIOTtg4EsbwC3TthKheHzubGrNYJ9iuJ0RPlvc6RwaBzi25Z8dpk2pNUFxV54Azm3WpAqQ2KIJOJSzHTIXRq+Lp3gsDzh6qSPLLjs/VtNVSs19xGNMlUdLPKsSGzMB1skn7j9T+K1qa9rhzPc0+pLYT3mHda2IIFhuMZehA2KdM7/63ndwb9zDr/9CY2gkTFlgABhAq1UEo/K3zgTqEKy08B8hq9tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCblYoNH7nw6JhLpbIlgC2+geCG+hGnVEyOvPFPqYmo=;
 b=Nww6SzaveY7jAmLzkC9v2tPlitF4w+gijru20wdzzH67GO4fxEjVw1tLQgFtuEChBxoMR6veZIz0oiSbtQLb1Fi2mNTHLft5rcOJo9J4y2h+EdL69O0BTz6NrM7hM6NzdlJwPIRgJCewxGES8ow+GFe/LlbBA0lPlIvKbB4ycpyvPggWmeXkmSBxBdm3kNYYvg88BctaQmR0t4peMNpOdh+WhaL5wJpn2lfgXg54HgfkfPHsqrN1BfQzkVHP5AFkaPXa+lhBWQTmvYf+gT4DoKqr+SA5iYB7EFoK6i4QwWLSk9rR1cDh3ndiWPEHp8fQvb5iyvLbvcknFsoWWSRmZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MW2PR1501MB2028.namprd15.prod.outlook.com (2603:10b6:302:13::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 20:19:50 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983%5]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 20:19:50 +0000
Date:   Tue, 12 Apr 2022 13:19:48 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v3 3/7] bpf: minimize number of allocated lsm
 slots per program
Message-ID: <20220412201948.b2jnefks5ptrt3yd@kafai-mbp.dhcp.thefacebook.com>
References: <20220407223112.1204582-1-sdf@google.com>
 <20220407223112.1204582-4-sdf@google.com>
 <20220408225628.oog4a3qteauhqkdn@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBuMMuuUJiZJY8Gb+tMQLKoRGpvv58sSM4sZXjyEc0i7dA@mail.gmail.com>
 <20220412013631.tntvx7lw3c7sw6ur@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBvCNVwEmoDyWvA5kEuNkCuVZYtf7RVL4AMXAsMr7aQDZA@mail.gmail.com>
 <20220412181353.zgyl2oy4vl3uyigl@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBuc8gVcS6GbSx4P6w2j6jTVXX8QROBjFW953mp0ejQqRA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBuc8gVcS6GbSx4P6w2j6jTVXX8QROBjFW953mp0ejQqRA@mail.gmail.com>
X-ClientProxiedBy: SJ0PR03CA0145.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::30) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e355eda-80f3-4f9e-091f-08da1cc1cbf1
X-MS-TrafficTypeDiagnostic: MW2PR1501MB2028:EE_
X-Microsoft-Antispam-PRVS: <MW2PR1501MB2028014867EB71655531749BD5ED9@MW2PR1501MB2028.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lm3BNCua1c/GyzuytbLnNUAiV+pn6nAnMVndx3RtIh3YHXeD/SKiIlyjvM7C5+sEubUvDO3cY/quI7ms2UtaI9dP9Z1P+KYFrUYG6/WyCqdBEem2/J7yWFjn0w0pS+vf5qm035RvjBZ1wnKZ2aWa3E7saWL1TnGlaZqLB/r8HbtrHCym0fe5Ox4q9Q28v4OFBwb3GA0J8xezYww5sOUZND7o/C1K/NDTbMU2crdCdyu0+TJ3eisrFQF/fi5ky3q60/ih4v1KfejMrD0+CWTJNOiFx2n+aSmRo+rKC+PgLDXVsONNdH1KPvKGv2SlmnrSHUsmu8RILjvw8JHaSqJD42PXkz0srgZpCjRmrofr+phWkBNmSvOJkIpXofaXuWiD+k06+53Ctia4fPlHypTj68aHgsKMX7qztzvbOnREZmNBw3KRGoJ+g6GoH48tp/wVkwoC8S8/XpIqStodVw956FTC1kndxk7NTXkBxM6QT13cwEoMia7br7/Ea7BGu4Vewy4Di5EHVx+ZChFX/S+wNQuD/UuvOWqdaBlRBOtsr/9G0R5qHOOGds9NpUAEFk+fbrIlbI5Aq7dImkjKjUdat1TGY1ZU7G9S8mnLtoFJCHGW3p2BoNzgi6bGrmH7Tss8hD8To2tO3bgFV25PiC0R9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(66556008)(52116002)(9686003)(6512007)(6506007)(53546011)(8936002)(2906002)(38100700002)(508600001)(6486002)(6916009)(66476007)(1076003)(186003)(316002)(5660300002)(4326008)(8676002)(66946007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JjJn7115Pb/m2aiFx1MCYbMYQtrKB4glJSc+k7eLVzMJ7Aq/F4y7Jw98fzzJ?=
 =?us-ascii?Q?zjqN5S4KHCYjWQGFc+ccef9aMZiwU5ardPTSds4SNw4n9Mvo7DCDOuK8EZIK?=
 =?us-ascii?Q?j3/o5UU/BL1vk3IHZN3nB8IZFnxRC/Si6QT4lXwTrW2++7MWNFFreQHl7XlM?=
 =?us-ascii?Q?7dudFBWfLJR83qBXidFpI/00FwXVMhfJ73kPNbKrBAu17TfwUNdRfd/ho5MG?=
 =?us-ascii?Q?sBrYSOXPbLqFi2Y1fZKCKgrc2tDvgpXX7ebxDF/ga5+ZQMAOJJAk0MQloZ0z?=
 =?us-ascii?Q?xCTYlXEucedxLX2TFO3hWnCvS05hYVagRv17c/T+AyC29ckl7VWrPjL/rVQc?=
 =?us-ascii?Q?WK5b1lVFLYoeubCMKAgOzMK16AK6foBNlcnyO6qOy2+zL1S7LLYvxBv8JBhp?=
 =?us-ascii?Q?P++eM1xDu+Dpa9HrBg2QHM/reWsbg3tIg/u6BoavZPTM7j21iRbh+ZplEXcE?=
 =?us-ascii?Q?wSoi4LsRuRd/sFArADeQJTlZvqvEwQIq/OIaCvUrqD6RbFx9g/RhBZyH/6ya?=
 =?us-ascii?Q?mHclHYZo2j5lBUd1PSqqPf4CZ0WP5MQusm+QMyztFKYchbnkLe2MAKgiE7zW?=
 =?us-ascii?Q?LgU3v1GyKwLAINci97mOw/Yv2Nl5lCKOlVmCWg7NhH63KgZmZ+BDBlwYV/u8?=
 =?us-ascii?Q?FHQMzR90TJ9hpPicn7543nfAl2R5D71M+2s30qOmAiUdfSGUxTf7+Gkl+y9/?=
 =?us-ascii?Q?qQOWHxb4v4cHBkllV307HKpas5p5osgN0yUEY8CbWkUIgWaYIimV5buKi5fZ?=
 =?us-ascii?Q?WWjn9Kj0qvOkOz2o5EGZtJDgvFlisogIrYpy0hu1M1yP23PEWG5R5UsCRuEv?=
 =?us-ascii?Q?pG7NWjWmuV+EdsGSPrD93wtAn0OjafQ7KcaBjR1zzIUWdTxL2O1abfY3uNfq?=
 =?us-ascii?Q?9pHeiPupqpTtsoXbeEf/bS79A6nZPjtR7LIjLbwtZcb6QcTZVVTMDo2keqQX?=
 =?us-ascii?Q?UcCl7gTL3nGLQvHOHDiBVVlnItyuMicKHA4M/Ok18lqDTFsC8BFCOhsofuLy?=
 =?us-ascii?Q?PaR2ymSt8vs/6g+blN5PT1AJjW7Hbwbsh69pmlXtQIlw/O6ai9kHE2GwtvGn?=
 =?us-ascii?Q?A+O6YdRTiXgVktaYxE2ATvSVV9OBwCX7INahPMO4yX8KqhXsdjqLQDkOctuf?=
 =?us-ascii?Q?dJ4I4399zW1mQa01Jdeui9E+qoRaOFs0C3Px2g9OGfvgG/gcKKtt5VSXcwjx?=
 =?us-ascii?Q?Tzo8fG4t9Ppe5NC4LgpDxZB7IbSNat8fYESoZShBsEqP5lZo9Fye0hcM33SB?=
 =?us-ascii?Q?fNwKnI9G/0nKd8BGdR7KQKffbXNGgPvdFXJp7Tn8EnLRgE7QWkJji3dFgHxm?=
 =?us-ascii?Q?wFYUFpD4F8s7iiQH0Ir/20hq4Ri05QAbqfoqMIzvWY7fakZ9ir2pTckq3OQP?=
 =?us-ascii?Q?5q+pItIBthRBCGq6M+olbSvmTYb9HZjkpxosIAMTMkpfq4EOJ/Qpizp2cgrb?=
 =?us-ascii?Q?hLHLyapgBY0+y9uRfo4OC5SUYCkMyO5TF8xTxBCzkucuxB3h2eKloN2cpwcZ?=
 =?us-ascii?Q?nGfjqB8H/f9IHGv/gCij4MwGBeTruyOgXguGqY+rFu3mCahJNfV4XiI5NVCs?=
 =?us-ascii?Q?SLz3HPl7iClRxz/WTHVD7f6WK9qG8KiC8zhoWxVnHDq8xS5lkR7gcmhhoSoD?=
 =?us-ascii?Q?3k3/KMNyprJF2PJK7zGyqW0i+Grc0MRRbG7menYsngGzgejmDpetpI2jPLxC?=
 =?us-ascii?Q?tsctsh0KVPz5GDctDm1FZ2mfST4x3LIpE6EUbzB/1rZWttF+Vv7w76ob1QQ3?=
 =?us-ascii?Q?zgUXWM6VL0goKmfmomJdutXmY8RQzW4=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e355eda-80f3-4f9e-091f-08da1cc1cbf1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 20:19:50.4214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ejPALDvpbhjBzoWXx1keKopsy4QlzNm8VKzK2ADu6Kc3sBwsVZ7y9KNf/lNAJSYs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2028
X-Proofpoint-ORIG-GUID: ngqAte16VjiPfNHrfS83Z2HfJ4O-p3lp
X-Proofpoint-GUID: ngqAte16VjiPfNHrfS83Z2HfJ4O-p3lp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 12:01:41PM -0700, Stanislav Fomichev wrote:
> On Tue, Apr 12, 2022 at 11:13 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Tue, Apr 12, 2022 at 09:42:40AM -0700, Stanislav Fomichev wrote:
> > > On Mon, Apr 11, 2022 at 6:36 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Mon, Apr 11, 2022 at 11:46:20AM -0700, Stanislav Fomichev wrote:
> > > > > On Fri, Apr 8, 2022 at 3:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > >
> > > > > > On Thu, Apr 07, 2022 at 03:31:08PM -0700, Stanislav Fomichev wrote:
> > > > > > > Previous patch adds 1:1 mapping between all 211 LSM hooks
> > > > > > > and bpf_cgroup program array. Instead of reserving a slot per
> > > > > > > possible hook, reserve 10 slots per cgroup for lsm programs.
> > > > > > > Those slots are dynamically allocated on demand and reclaimed.
> > > > > > > This still adds some bloat to the cgroup and brings us back to
> > > > > > > roughly pre-cgroup_bpf_attach_type times.
> > > > > > >
> > > > > > > It should be possible to eventually extend this idea to all hooks if
> > > > > > > the memory consumption is unacceptable and shrink overall effective
> > > > > > > programs array.
> > > > > > >
> > > > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > > > ---
> > > > > > >  include/linux/bpf-cgroup-defs.h |  4 +-
> > > > > > >  include/linux/bpf_lsm.h         |  6 ---
> > > > > > >  kernel/bpf/bpf_lsm.c            |  9 ++--
> > > > > > >  kernel/bpf/cgroup.c             | 96 ++++++++++++++++++++++++++++-----
> > > > > > >  4 files changed, 90 insertions(+), 25 deletions(-)
> > > > > > >
> > > > > > > diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> > > > > > > index 6c661b4df9fa..d42516e86b3a 100644
> > > > > > > --- a/include/linux/bpf-cgroup-defs.h
> > > > > > > +++ b/include/linux/bpf-cgroup-defs.h
> > > > > > > @@ -10,7 +10,9 @@
> > > > > > >
> > > > > > >  struct bpf_prog_array;
> > > > > > >
> > > > > > > -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> > > > > > > +/* Maximum number of concurrently attachable per-cgroup LSM hooks.
> > > > > > > + */
> > > > > > > +#define CGROUP_LSM_NUM 10
> > > > > > hmm...only 10 different lsm hooks (or 10 different attach_btf_ids) can
> > > > > > have BPF_LSM_CGROUP programs attached.  This feels quite limited but having
> > > > > > a static 211 (and potentially growing in the future) is not good either.
> > > > > > I currently do not have a better idea also. :/
> > > > > >
> > > > > > Have you thought about other dynamic schemes or they would be too slow ?
> > > > > >
> > > > > > >  enum cgroup_bpf_attach_type {
> > > > > > >       CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
> > > > > > > diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> > > > > > > index 7f0e59f5f9be..613de44aa429 100644
> > > > > > > --- a/include/linux/bpf_lsm.h
> > > > > > > +++ b/include/linux/bpf_lsm.h
> > > > > > > @@ -43,7 +43,6 @@ extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
> > > > > > >  void bpf_inode_storage_free(struct inode *inode);
> > > > > > >
> > > > > > >  int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
> > > > > > > -int bpf_lsm_hook_idx(u32 btf_id);
> > > > > > >
> > > > > > >  #else /* !CONFIG_BPF_LSM */
> > > > > > >
> > > > > > > @@ -74,11 +73,6 @@ static inline int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> > > > > > >       return -ENOENT;
> > > > > > >  }
> > > > > > >
> > > > > > > -static inline int bpf_lsm_hook_idx(u32 btf_id)
> > > > > > > -{
> > > > > > > -     return -EINVAL;
> > > > > > > -}
> > > > > > > -
> > > > > > >  #endif /* CONFIG_BPF_LSM */
> > > > > > >
> > > > > > >  #endif /* _LINUX_BPF_LSM_H */
> > > > > > > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > > > > > > index eca258ba71d8..8b948ec9ab73 100644
> > > > > > > --- a/kernel/bpf/bpf_lsm.c
> > > > > > > +++ b/kernel/bpf/bpf_lsm.c
> > > > > > > @@ -57,10 +57,12 @@ static unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
> > > > > > >       if (unlikely(!sk))
> > > > > > >               return 0;
> > > > > > >
> > > > > > > +     rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
> > > > > > >       cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > > > > > >       if (likely(cgrp))
> > > > > > >               ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> > > > > > >                                           ctx, bpf_prog_run, 0);
> > > > > > > +     rcu_read_unlock();
> > > > > > >       return ret;
> > > > > > >  }
> > > > > > >
> > > > > > > @@ -77,7 +79,7 @@ static unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> > > > > > >       /*prog = container_of(insn, struct bpf_prog, insnsi);*/
> > > > > > >       prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> > > > > > >
> > > > > > > -     rcu_read_lock();
> > > > > > > +     rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
> > > > > > I think this is also needed for task_dfl_cgroup().  If yes,
> > > > > > will be a good idea to adjust the comment if it ends up
> > > > > > using the 'CGROUP_LSM_NUM 10' scheme.
> > > > > >
> > > > > > While at rcu_read_lock(), have you thought about what major things are
> > > > > > needed to make BPF_LSM_CGROUP sleepable ?
> > > > > >
> > > > > > The cgroup local storage could be one that require changes but it seems
> > > > > > the cgroup local storage is not available to BPF_LSM_GROUP in this change set.
> > > > > > The current use case doesn't need it?
> > > > >
> > > > > No, I haven't thought about sleepable at all yet :-( But seems like
> > > > > having that rcu lock here might be problematic if we want to sleep? In
> > > > > this case, Jakub's suggestion seems better.
> > > > The new rcu_read_lock() here seems fine after some thoughts.
> > > >
> > > > I was looking at the helpers in cgroup_base_func_proto() to get a sense
> > > > on sleepable support.  Only the bpf_get_local_storage caught my eyes for
> > > > now because it uses a call_rcu to free the storage.  That will be the
> > > > major one to change for sleepable that I can think of for now.
> > >
> > > That rcu_read_lock should be switched over to rcu_read_lock_trace in
> > > the sleepable case I'm assuming? Are we allowed to sleep while holding
> > > rcu_read_lock_trace?
> > Ah. right, suddenly forgot the obvious in between emails :(
> >
> > In that sense, may as well remove the rcu_read_lock() here and let
> > the trampoline to decide which one (rcu_read_lock or rcu_read_lock_trace)
> > to call before calling the shim_prog.  The __bpf_prog_enter(_sleepable) will
> > call the right rcu_read_lock(_trace) based on the prog is sleepable or not.
> 
> Removing rcu_read_lock in __cgroup_bpf_run_lsm_current might be
> problematic because we also want to guarantee current's cgroup doesn't
> go away. I'm assuming things like task migrating to a new cgroup and
> the old one being freed can happen while we are trying to get cgroup's
> effective array.
Right, sleepable one may need a short rcu_read_lock only upto
a point that the cgrp->bpf.effective[...] is obtained.
call_rcu_tasks_trace() is then needed to free the bpf_prog_array.

The future sleepable one may be better off to have a different shim func,
not sure.  rcu_read_lock() can be added back later if it ends up reusing
the same shim func is cleaner.

> I guess BPF_PROG_RUN_ARRAY_CG will also need some work before
> sleepable can happen (it calls rcu_read_lock unconditionally).
Yep.  I think so.

> 
> Also, it doesn't seem like BPF_PROG_RUN_ARRAY_CG rcu usage is correct.
> It receives __rcu array_rcu, takes rcu read lock and does deref. I'm
> assuming that array_rcu can be free'd before we even get to
> BPF_PROG_RUN_ARRAY_CG's rcu_read_lock? (so having rcu_read_lock around
> BPF_PROG_RUN_ARRAY_CG makes sense)
BPF_PROG_RUN_ARRAY_CG is __always_inline though.
