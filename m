Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB33C4FEA9C
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiDLX2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiDLX2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:28:23 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B35D4476;
        Tue, 12 Apr 2022 15:14:13 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23CM8V4b031629;
        Tue, 12 Apr 2022 15:13:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Y664oRAF3ysyo63PCeuhW6T6957ywoF2VWueWitOQsw=;
 b=BfF+KIQisi2+iQ4R7pyOcvVnf2T6u9kDHijZTbm7S93XAI6Mu7pLj98NfY1Fn24mXa1J
 vlp41hIU6WHFjOk9tt1F95WMTtq9tHd1nqrNMDfRiKmpyZjJsn5WUwwo9gw/c60OiXAq
 2BFyNTQoPLB7elA4SxF542GScYG2LCPI5Sg= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fdd5ua8rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:13:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKyVDqbRPmCYa2yDrM3HVSs2PfaQ0hvIexGOND4ga3nkVcKciyG69VuVtNvuP8lkLxoxfbmfx+ijAt/0pjAbxNr9SkCA6BGERFjWolEISi5py3wl53XbtO+Gk3A9zs4MCr/MKh5nnfZIypadhE4uJFg1BHWvAuXTPNg7lpy4mw8wJQZ5nvLm7Bw5D0rUM42dWolKaT5Rp+VrulZ7rnUmaSdnuCDAiQIjV4V7RQxOcoIq4S4i/6B4k0NKJtUbYSCps9IRCPV1Qw3JZlzuwghhR2Im3HN9RDdKOO29NIqGzouBXihY1Ay77Ew8xu/MdHFfkFtsy49BltpZsvQav6lVJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y664oRAF3ysyo63PCeuhW6T6957ywoF2VWueWitOQsw=;
 b=iNLUm7XINKqHfCFHgMCeIYe1fArdVrwOppXYU/98+k1gSIdZtZhO+RdU/3uEdR8ifo+1oqLdY4axqmxPSNhSzvckd4BPqbNdp34Df5bI2jA1WLsFjnv8oGlmpLo0nWLvKvoLSu94kKCiz/E3MYEZcCQLyEcGF5UOvnLo0V5/mBUeuBleSp/9xxlK3rBVml5MIxSEAyK3dCQ32i1voGALQi0VDrq0Hl5u3iBYUAb3cyTcnqaQw6sBMfgpvTp58vCr5z1OMdnU6WgoldpRD7b1lxlDXPtb3V0Y3bfZdbXbA270kiYsoeF1HAQsar6rnpCJZQoYgUOiKTYwSDrKVgo9wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4452.namprd15.prod.outlook.com (2603:10b6:806:197::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Tue, 12 Apr
 2022 22:13:55 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983%5]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 22:13:55 +0000
Date:   Tue, 12 Apr 2022 15:13:52 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v3 3/7] bpf: minimize number of allocated lsm
 slots per program
Message-ID: <20220412221352.nmkj6drtmbweawhs@kafai-mbp.dhcp.thefacebook.com>
References: <20220407223112.1204582-1-sdf@google.com>
 <20220407223112.1204582-4-sdf@google.com>
 <20220408225628.oog4a3qteauhqkdn@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBuMMuuUJiZJY8Gb+tMQLKoRGpvv58sSM4sZXjyEc0i7dA@mail.gmail.com>
 <20220412013631.tntvx7lw3c7sw6ur@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBvCNVwEmoDyWvA5kEuNkCuVZYtf7RVL4AMXAsMr7aQDZA@mail.gmail.com>
 <20220412181353.zgyl2oy4vl3uyigl@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBuc8gVcS6GbSx4P6w2j6jTVXX8QROBjFW953mp0ejQqRA@mail.gmail.com>
 <20220412201948.b2jnefks5ptrt3yd@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBtBOcDyMUc63VGnAEU1vhcH0hmWOi3csRhwwVG7PvH-qA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBtBOcDyMUc63VGnAEU1vhcH0hmWOi3csRhwwVG7PvH-qA@mail.gmail.com>
X-ClientProxiedBy: SJ0PR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::34) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 894198e1-3ff1-44bd-fbfa-08da1cd1bba8
X-MS-TrafficTypeDiagnostic: SA1PR15MB4452:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB445207CB89AB37AB83268659D5ED9@SA1PR15MB4452.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NUAMYywolnNE1JUQ3LupHT1Dj/uZKq/q5lbzkTlAe+8bxypNAPgNAQw5VOIp/jDHK4wchf24gLTdWm0dRgQnHWLQmaCzhqn5aqQ8C9DuL8PdtmUdpLsx6MSJVSGJyfv1rMcieCTZcMkXoVKoJDehZLY1l8xdViMQQGjcWW5yNrQYDBlsKu9Zzd0Ur72cZcVlao971KrZi3xuToTQL2PdxwJyBETRiWigle/eolP31ULAjc6VtdiaQyfVeT/KZhaeD9aaQ76JJct2IcTONz8/RiB7AuZUwHbhbWQ21abmUmPZPStqom9UGNGPAgYDei9CwaxmI63G5CvBBNat9tLUju6A98IIXG5bHC2ALw5RITvSl0khF4gEogG9lEQv+Hiu1PMn2T6l4MbSpNyN0UGNHWyykSOwtH0hwK/SLo7IxOGLJvIJJmmG6y6QKOm8MPi/vjGv9tb6rD/qL9rFcDbmK6/csRC2rKh2dcekjTUfwi3Ysl56eUdGvUrD3WIPWJlT4Glj2ALQaxkJKfVHc4TqRhlTkF8HgV1VLbOcJtK5YDPp9l7CPWgpBENjHh6PSFp17Jvrn9ZhZo5fV3bUeku2RW0qTGOoMir350k84Rg6cj0YC7pRKIFtE5Ts1e62uOdS7g3YhuY/3UlgM9zfxEGvQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(6666004)(38100700002)(316002)(6486002)(83380400001)(5660300002)(8936002)(52116002)(53546011)(4326008)(2906002)(8676002)(6506007)(66946007)(6512007)(66476007)(66556008)(30864003)(9686003)(86362001)(1076003)(186003)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V0lU9KtU7RbVYiDO1F4VPLdUoRxvCkqJkb3EYd6ZfjAfIRvV9MpT4Yftbqnd?=
 =?us-ascii?Q?SlbYDsKEFrxZ2MH69kN8H4rUXDngmsn1l1uq9kRRCzt9gIpGDmxNOMlAZ6ts?=
 =?us-ascii?Q?OQlDzyMnL8WPa3dTfjWPjUgm/eeA84UmCcQRgPO+BqhoJdgeFK+jzkTz0Ir1?=
 =?us-ascii?Q?PZwUBp8MO0OckJZPYoSbwSGQ11SL83bxtQEXxPhNxMU+Xx3Y+j3Ph2v8SjCf?=
 =?us-ascii?Q?SuNSbC8/4ZmRcesY81ykw8xhuEd5tHR43Fy95BctM7W8Osam9qm/LBSCG8C5?=
 =?us-ascii?Q?fAqXR5CByKeXMxdx3PeZ4BBNqJBFOqfunJ3qJlGpdf9VSfy+lxDVQg61r7ZI?=
 =?us-ascii?Q?LWgQTpIGHMeM0HMY5h7uaVa45g4Ih8Z/Nll5K+lI7DM5/bxd9XFsCA7f6ory?=
 =?us-ascii?Q?TyHzuFuHegl6CWUmOST5X8MwCssC4p3EhVNYSFQx/Iq25r2aOuuA4NH2bgD/?=
 =?us-ascii?Q?BpF42TQeEeG5BN03O8RwE9L0r9uSdFaj6kFynrwh5SFg+l4OO/njLYzOxllz?=
 =?us-ascii?Q?rKgHGjUzJBq9SuiUBhOCPcoQLpp7uxTN5hF1dfuNj4UVpzhrwnmWmjm/KQZO?=
 =?us-ascii?Q?V01tibTfkFtyFfjrxXMYmdPk0eBbcNS6/66hmSmBvHxUVLXW2h1aHo06/bzN?=
 =?us-ascii?Q?1RVAiJTDI2cEtgVdEStrFLhPrirr6iUXLD+PHuVdXLC0APU8G0N2ujVpNTq8?=
 =?us-ascii?Q?oz+b1T3teVZ2aGoVjEJOq7KvqFQ/wfcVCq1N913qEHgMLfKpf9z7LkuJSxGa?=
 =?us-ascii?Q?ng8qy0B1Puj3vt3/KSfJPjsTiXpOPddTV4yKKkY7M/8zPtEH2XKKR5CxfLwu?=
 =?us-ascii?Q?nY50WBrZ3JKcGr4b6smqD+mnfguz1ChV8mYB8lfszP5SfKzRaNf3ZLQB9tgB?=
 =?us-ascii?Q?iJxVvNr3avuYxI+z4OybtNl7fZQXqZXUU9Bi2bxZWlhRIu57Idxj5pDjlTJW?=
 =?us-ascii?Q?oVTGqVHneypssDfg4SILEkpDGwiqo+mhIpwxWL+JrmjI9cUy1Yl/1JYImY0i?=
 =?us-ascii?Q?HyGxS4AtfbQEBeZvTUTnhXaI7XpOmPaZfsmZp/0AiyF8DpXacg4F6mp5LLyo?=
 =?us-ascii?Q?8pe7syVK77PZXzWQWzkJiu86tNW2M8DFoEhOTFdu31Ra0g2e561eepcC1nBr?=
 =?us-ascii?Q?Cm+yQXvHI++45OvjJqaRAJhzkUze2j2SNFJSuoGEnJWhMX5AIRNqTbVJztRg?=
 =?us-ascii?Q?tUcMe1y2FMcZIckTBZg+nvEkHK02k96n1JUqeQAIPKk/XZHCiiFYplqfFbJz?=
 =?us-ascii?Q?aK0XAv7A6uBeCPdTdOhWOwrpGA3++AXJnMJAP6Hmo98hkn2RAQ3pHPI1ASs0?=
 =?us-ascii?Q?V5IgxWcO/PhfJhC/8Git9sW/Ch6u31ZoD67dQjWFlrbc3gHxsUe+swEvL5g9?=
 =?us-ascii?Q?+mtvUPlRcqXqv5ExCjIizphzU2nqEKl7iOSwy8HoC+jqapjXlTi7kvNivp4K?=
 =?us-ascii?Q?jcmJ7evC4wCUe/ZQPf2f97J+D4+ilyK75plI1+kp0u9cKkjwnv2QBy31vGiK?=
 =?us-ascii?Q?8R7smBV2Jx+qDcBIvFr5V2C4NYhZwyoRsxOgZVT6LXaYQMLGO06IVb/pVE0z?=
 =?us-ascii?Q?l3ZdWzA9nNhkIIok/kYAeAXBF/FJsQ3hGkaJORlqlNnxADHq7P3KEg165kWi?=
 =?us-ascii?Q?LwwMZUQofz1eQMHCdnfBik5EzlC8aTe7qW6eV+4fTe5gdXFipVTdutPjFCRM?=
 =?us-ascii?Q?4hNHJ6rTqYH1n4uIqvBXoNOePjwT//UobidqS2U7ZrLnyZEEiiz11VxfqGK6?=
 =?us-ascii?Q?CVuZb9mwSXUakWnbR2sfsWlDNSdsNfE=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 894198e1-3ff1-44bd-fbfa-08da1cd1bba8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 22:13:54.9752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MidaV5UdQAsHwEULUR//a/hHf/bcCxC0RlTpwA8ssjlWw/DxSiT+A8V/DaGwlyFM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4452
X-Proofpoint-ORIG-GUID: aOK4JqILhLbKsq6_is8zq-SUUKzSiXde
X-Proofpoint-GUID: aOK4JqILhLbKsq6_is8zq-SUUKzSiXde
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

On Tue, Apr 12, 2022 at 01:36:45PM -0700, Stanislav Fomichev wrote:
> On Tue, Apr 12, 2022 at 1:19 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Tue, Apr 12, 2022 at 12:01:41PM -0700, Stanislav Fomichev wrote:
> > > On Tue, Apr 12, 2022 at 11:13 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Tue, Apr 12, 2022 at 09:42:40AM -0700, Stanislav Fomichev wrote:
> > > > > On Mon, Apr 11, 2022 at 6:36 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > >
> > > > > > On Mon, Apr 11, 2022 at 11:46:20AM -0700, Stanislav Fomichev wrote:
> > > > > > > On Fri, Apr 8, 2022 at 3:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > > >
> > > > > > > > On Thu, Apr 07, 2022 at 03:31:08PM -0700, Stanislav Fomichev wrote:
> > > > > > > > > Previous patch adds 1:1 mapping between all 211 LSM hooks
> > > > > > > > > and bpf_cgroup program array. Instead of reserving a slot per
> > > > > > > > > possible hook, reserve 10 slots per cgroup for lsm programs.
> > > > > > > > > Those slots are dynamically allocated on demand and reclaimed.
> > > > > > > > > This still adds some bloat to the cgroup and brings us back to
> > > > > > > > > roughly pre-cgroup_bpf_attach_type times.
> > > > > > > > >
> > > > > > > > > It should be possible to eventually extend this idea to all hooks if
> > > > > > > > > the memory consumption is unacceptable and shrink overall effective
> > > > > > > > > programs array.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > > > > > ---
> > > > > > > > >  include/linux/bpf-cgroup-defs.h |  4 +-
> > > > > > > > >  include/linux/bpf_lsm.h         |  6 ---
> > > > > > > > >  kernel/bpf/bpf_lsm.c            |  9 ++--
> > > > > > > > >  kernel/bpf/cgroup.c             | 96 ++++++++++++++++++++++++++++-----
> > > > > > > > >  4 files changed, 90 insertions(+), 25 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> > > > > > > > > index 6c661b4df9fa..d42516e86b3a 100644
> > > > > > > > > --- a/include/linux/bpf-cgroup-defs.h
> > > > > > > > > +++ b/include/linux/bpf-cgroup-defs.h
> > > > > > > > > @@ -10,7 +10,9 @@
> > > > > > > > >
> > > > > > > > >  struct bpf_prog_array;
> > > > > > > > >
> > > > > > > > > -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> > > > > > > > > +/* Maximum number of concurrently attachable per-cgroup LSM hooks.
> > > > > > > > > + */
> > > > > > > > > +#define CGROUP_LSM_NUM 10
> > > > > > > > hmm...only 10 different lsm hooks (or 10 different attach_btf_ids) can
> > > > > > > > have BPF_LSM_CGROUP programs attached.  This feels quite limited but having
> > > > > > > > a static 211 (and potentially growing in the future) is not good either.
> > > > > > > > I currently do not have a better idea also. :/
> > > > > > > >
> > > > > > > > Have you thought about other dynamic schemes or they would be too slow ?
> > > > > > > >
> > > > > > > > >  enum cgroup_bpf_attach_type {
> > > > > > > > >       CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
> > > > > > > > > diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> > > > > > > > > index 7f0e59f5f9be..613de44aa429 100644
> > > > > > > > > --- a/include/linux/bpf_lsm.h
> > > > > > > > > +++ b/include/linux/bpf_lsm.h
> > > > > > > > > @@ -43,7 +43,6 @@ extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
> > > > > > > > >  void bpf_inode_storage_free(struct inode *inode);
> > > > > > > > >
> > > > > > > > >  int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
> > > > > > > > > -int bpf_lsm_hook_idx(u32 btf_id);
> > > > > > > > >
> > > > > > > > >  #else /* !CONFIG_BPF_LSM */
> > > > > > > > >
> > > > > > > > > @@ -74,11 +73,6 @@ static inline int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> > > > > > > > >       return -ENOENT;
> > > > > > > > >  }
> > > > > > > > >
> > > > > > > > > -static inline int bpf_lsm_hook_idx(u32 btf_id)
> > > > > > > > > -{
> > > > > > > > > -     return -EINVAL;
> > > > > > > > > -}
> > > > > > > > > -
> > > > > > > > >  #endif /* CONFIG_BPF_LSM */
> > > > > > > > >
> > > > > > > > >  #endif /* _LINUX_BPF_LSM_H */
> > > > > > > > > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > > > > > > > > index eca258ba71d8..8b948ec9ab73 100644
> > > > > > > > > --- a/kernel/bpf/bpf_lsm.c
> > > > > > > > > +++ b/kernel/bpf/bpf_lsm.c
> > > > > > > > > @@ -57,10 +57,12 @@ static unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
> > > > > > > > >       if (unlikely(!sk))
> > > > > > > > >               return 0;
> > > > > > > > >
> > > > > > > > > +     rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
> > > > > > > > >       cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > > > > > > > >       if (likely(cgrp))
> > > > > > > > >               ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> > > > > > > > >                                           ctx, bpf_prog_run, 0);
> > > > > > > > > +     rcu_read_unlock();
> > > > > > > > >       return ret;
> > > > > > > > >  }
> > > > > > > > >
> > > > > > > > > @@ -77,7 +79,7 @@ static unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> > > > > > > > >       /*prog = container_of(insn, struct bpf_prog, insnsi);*/
> > > > > > > > >       prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> > > > > > > > >
> > > > > > > > > -     rcu_read_lock();
> > > > > > > > > +     rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
> > > > > > > > I think this is also needed for task_dfl_cgroup().  If yes,
> > > > > > > > will be a good idea to adjust the comment if it ends up
> > > > > > > > using the 'CGROUP_LSM_NUM 10' scheme.
> > > > > > > >
> > > > > > > > While at rcu_read_lock(), have you thought about what major things are
> > > > > > > > needed to make BPF_LSM_CGROUP sleepable ?
> > > > > > > >
> > > > > > > > The cgroup local storage could be one that require changes but it seems
> > > > > > > > the cgroup local storage is not available to BPF_LSM_GROUP in this change set.
> > > > > > > > The current use case doesn't need it?
> > > > > > >
> > > > > > > No, I haven't thought about sleepable at all yet :-( But seems like
> > > > > > > having that rcu lock here might be problematic if we want to sleep? In
> > > > > > > this case, Jakub's suggestion seems better.
> > > > > > The new rcu_read_lock() here seems fine after some thoughts.
> > > > > >
> > > > > > I was looking at the helpers in cgroup_base_func_proto() to get a sense
> > > > > > on sleepable support.  Only the bpf_get_local_storage caught my eyes for
> > > > > > now because it uses a call_rcu to free the storage.  That will be the
> > > > > > major one to change for sleepable that I can think of for now.
> > > > >
> > > > > That rcu_read_lock should be switched over to rcu_read_lock_trace in
> > > > > the sleepable case I'm assuming? Are we allowed to sleep while holding
> > > > > rcu_read_lock_trace?
> > > > Ah. right, suddenly forgot the obvious in between emails :(
> > > >
> > > > In that sense, may as well remove the rcu_read_lock() here and let
> > > > the trampoline to decide which one (rcu_read_lock or rcu_read_lock_trace)
> > > > to call before calling the shim_prog.  The __bpf_prog_enter(_sleepable) will
> > > > call the right rcu_read_lock(_trace) based on the prog is sleepable or not.
> > >
> > > Removing rcu_read_lock in __cgroup_bpf_run_lsm_current might be
> > > problematic because we also want to guarantee current's cgroup doesn't
> > > go away. I'm assuming things like task migrating to a new cgroup and
> > > the old one being freed can happen while we are trying to get cgroup's
> > > effective array.
> > Right, sleepable one may need a short rcu_read_lock only upto
> > a point that the cgrp->bpf.effective[...] is obtained.
> > call_rcu_tasks_trace() is then needed to free the bpf_prog_array.
> >
> > The future sleepable one may be better off to have a different shim func,
> > not sure.  rcu_read_lock() can be added back later if it ends up reusing
> > the same shim func is cleaner.
> 
> In this case I'll probably have rcu_read_lock for
> cgroup+bpf_lsm_attach_type_get for the current shim.
yeah, depending on rcu grace period to free up cgroup_lsm_atype_btf_id
should be fine.  It just needs to wait another grace period for sleepable
in the future.

Also, just came to my mind, if it wants sleepable and non-sleepable
to be in the same cgrp->bpf.effective[] array.  It may need more
thoughts on when to do the rcu_read_lock() and rcu_read_trace_lock().

> > > I guess BPF_PROG_RUN_ARRAY_CG will also need some work before
> > > sleepable can happen (it calls rcu_read_lock unconditionally).
> > Yep.  I think so.
> >
> > >
> > > Also, it doesn't seem like BPF_PROG_RUN_ARRAY_CG rcu usage is correct.
> > > It receives __rcu array_rcu, takes rcu read lock and does deref. I'm
> > > assuming that array_rcu can be free'd before we even get to
> > > BPF_PROG_RUN_ARRAY_CG's rcu_read_lock? (so having rcu_read_lock around
> > > BPF_PROG_RUN_ARRAY_CG makes sense)
> > BPF_PROG_RUN_ARRAY_CG is __always_inline though.
> 
> Does it help? This should still expand to the following, right?
> 
> array_rcu = cgrp->bpf.effective[atype];
I think you are right:

86   	 	   ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
0xffffffff812534bb <+155>:	mov    -0x10(%rbx),%rdx
0xffffffff812534bf <+159>:	movl   $0x0,-0x38(%rbp)
0xffffffff812534c6 <+166>:	movslq 0x300(%rdx),%rdx
0xffffffff812534cd <+173>:	mov    0x500(%rax,%rdx,8),%rbx

[ ... ]

1375	array = rcu_dereference(array_rcu);
0xffffffff8125350d <+237>:	callq  0xffffffff81145a50 <rcu_read_lock_held>
0xffffffff81253512 <+242>:	test   %eax,%eax
0xffffffff81253514 <+244>:	je     0xffffffff812537a7 <__cgroup_bpf_run_lsm_current+903>

[ ... ]

1376        item = &array->items[0];
0xffffffff8125351a <+250>:    lea    -0x40(%rbp),%rdx
0xffffffff8125351e <+254>:    mov    %gs:0x1af40,%rax
0xffffffff81253527 <+263>:    lea    0x10(%rbx),%r12

[ ... ]

1378        while ((prog = READ_ONCE(item->prog))) {
0xffffffff81253541 <+289>:    test   %rbx,%rbx
0xffffffff81253544 <+292>:    je     0xffffffff81253596 <__cgroup_bpf_run_lsm_current+374>


Do you know if a macro can work as expected ?


> /* theoretically, array_rcu can be freed here? */
> 
> rcu_read_lock();
> array = rcu_dereference(array_rcu);
> ...
> 
> Feels like the callers of BPF_PROG_RUN_ARRAY_CG really have to care
> about rcu locking, not the BPF_PROG_RUN_ARRAY_CG itself.
