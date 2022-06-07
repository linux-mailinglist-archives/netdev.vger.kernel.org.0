Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2184D542044
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384833AbiFHAU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391417AbiFGW40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 18:56:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C5730BF1F;
        Tue,  7 Jun 2022 12:57:59 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 257G4Yv5029634;
        Tue, 7 Jun 2022 12:57:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=U3grxyfNnh0m9nDuMCnMu1nYR+l1esuxZBU9SJVvghY=;
 b=ExgRo/PcSOAkb1H4PdALdnYIRgpXWOVslaf9Hbqx+uDKmCUuCaeDNWg6v+cCopfD1RA7
 9AQSmxwGNm9hHwBcJysLm0hC8flHJgc2TqUxnXl0QQ8UdK859wqedpqVpzmtjn6kQNDa
 NSwncZVZ5sN+nq3NuPn3a0x3p0nmY51mJFw= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by m0001303.ppops.net (PPS) with ESMTPS id 3ghy4sw2gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 12:57:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3Ys2NlxztQoG+dVtn6pCvMcIgDFrasi971JWSFfQ2y9eZhU3tYLbtwPq1SYMvxuig2T8CU/ATqIfm8AvvI3bwSsLJ/6etuNHGy13Btl7q6MG9gg389Ejc4OTH0ERpbb6U2eveYD7XN+0ajtwuHPPh1Q4L+C0Q+3zVEFsEcDm2UPA3pB10oNQb9MpDwbDJzM9QDLPAFqDL8s1ChsllTLGzWAOCWzCNZRsbrJuuWWemoDuzWxKF/JymvahIXGZh0SRZ1Dl+hepqPdNt6e8c4bDZtLa8gRD9NzCZjacWQCGY/sBorzJ8Mrxmwz3iFp0as4ABa2kPoaIKgJwjyxzcEOoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3grxyfNnh0m9nDuMCnMu1nYR+l1esuxZBU9SJVvghY=;
 b=T4FVjsbe9ks2EhLh377ZS3FkvKQzMaS/8otNBpiOgwCwGD8iABTSRtnLUnKMHF0SrP9XWZrpPuDTIXKj8djyJmzuzU0952YlvxQ93oXmcvt5IqTrzxFlczq+QuFnhy9BZsq0kBlNfRa5yY8KN3mFPUAmxKhA5tgYF4DZXVK8+OeFXWhXiGdF/bQp0zEquvtRAQAqrFioi1qDptwZpYV2TAyuELnfn6asp8wgpo+31/moCqzbJCOM7AfGuZGmiNshS0PNZULi/0PmFdT6DILVuSTPU8U0MdFlKozELI8dn3jlrqaTg7Ps88P2fAoNfwV0h5sD+THsCA5VV7jSdgSHZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MWHPR15MB1613.namprd15.prod.outlook.com (2603:10b6:300:123::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 19:57:19 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0%9]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 19:57:19 +0000
Date:   Tue, 7 Jun 2022 12:57:18 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v8 04/11] bpf: minimize number of allocated lsm
 slots per program
Message-ID: <20220607195718.v3ftibtcujcuzubr@kafai-mbp>
References: <20220601190218.2494963-1-sdf@google.com>
 <20220601190218.2494963-5-sdf@google.com>
 <20220604063556.qyhsssqgp2stw73q@kafai-mbp>
 <CAKH8qBvY++bswS8ycJyGVR0DsKsyXNhKv=MzwD2FkJY4wSYFbg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBvY++bswS8ycJyGVR0DsKsyXNhKv=MzwD2FkJY4wSYFbg@mail.gmail.com>
X-ClientProxiedBy: BYAPR05CA0102.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::43) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3243f3b9-33f5-47c6-ca08-08da48bfedeb
X-MS-TrafficTypeDiagnostic: MWHPR15MB1613:EE_
X-Microsoft-Antispam-PRVS: <MWHPR15MB1613F28190DD5FB20892C26CD5A59@MWHPR15MB1613.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ON3plSSgwUMOYaUNbQmKf1cz0Fiai8RNBqIV89jrJoTDhPXBoC+I3L81h4j3dncvmxRfG9CnxODi27IBxDWuQ0ixbaBW67SR2f/gK4UGMx+BhIWXUTi8T9HFgeMZEh43ZZ2nsQvvBnEhhSIayCbtqEZbQsDCONubAXacUyXlEdwfudwwlA5JFVRKRqtf7dMdJf+O/SuXA7jskirmyd30irJB8U38vpeCmCABOFTFwSWD3cbGJAcOJvIIVx+/YFu+Jg/KWJhPC59HJKgZ5jDmCB7hFN5af+9N6zKjdKQL/xi3uAfydxjJNzNhonauaVav5hREOyXL2fmPiOwVkhBsnjJ6eUD/5k6w0DXGJp03Zi21fHHjN1hFkZPnb28WlAALkiOPy+J56GzIyNIlrDYaB/p50OazRBfF52vSBhLQkrgXny5YcE0GG1itgRZbhf7Rjw/WLB4QrdrU1XA9Pl6k8BEphrqj93UiTRGR3AXALX6lp1HVjAi+fvvfOGU5ZdqLwLppvliw17oxcZOoGpE1sbje0AqAFaLcSvbZepXR50NaWDEaLq8VGg/Cu9AyarIhxXvK0FdZe06nYYaPLqZa1gY/OeEPqWh0q8qV7s2oNQb6VtVtEKWAp51zAiY/LoMvcFeC4dBvy7r2PjXamFoALA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(66556008)(8676002)(83380400001)(2906002)(8936002)(33716001)(6512007)(9686003)(316002)(1076003)(6916009)(6506007)(52116002)(186003)(508600001)(66946007)(5660300002)(66476007)(4326008)(38100700002)(6486002)(4744005)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aDHj8N8y5mxJn0mylhe2kqetUtLeYrjf+1ZcFHV255pvYVXiJEyTPDWB9opu?=
 =?us-ascii?Q?CMgftIhQZVzcO6Cu8lHlNtYmXDGFzZX2+9PAi0SPwT2leBB6ks280RmsUBSh?=
 =?us-ascii?Q?IbKJe0511WEbfLI3nh0svzhgYqAGiu1IjZtgGuBJCUSe+nj/g78mbbvcfZpy?=
 =?us-ascii?Q?BpDfDP7bYt3LRTMh1UQzGsCILH0v2hrcj7t1FaLXzQu30BTqgjZhhZ4ZCoch?=
 =?us-ascii?Q?a5o33he4sKaAJENtn9JCK+Q5jKZEvbiG11odpWwX3sq9HcEb/AsVqNr+ZWAf?=
 =?us-ascii?Q?9pfK+fQKLP76QM3qtGXSkhANxSMIUguxECJ7xJCk0B33oGwRdjeTocpxGK04?=
 =?us-ascii?Q?XUmLJTvNCSHNiv7f3M/1BR7WMBEw317L1o+9smiZ4Y3crjAk0NBDoJzgOJJx?=
 =?us-ascii?Q?+ZKWIkcNQRhqicjl4QcS4i//vmDYOcemAAOssO/4vFOcXK0QPrHxFPY0aelQ?=
 =?us-ascii?Q?se4H9D2ZyZ2Q9qxIw5c5kYn7v2uWEwzcKmmazZadSZwX/FikbUmpeKzuvttA?=
 =?us-ascii?Q?IBxNxrIznbKDGzOthsVFsGdvWq7bR1aeQcDtnMnw00YjihV2BTXcIi4/oEQK?=
 =?us-ascii?Q?zY4LgSmb27uEQv7nYqh01IWbxHN3E7N611aIxJLHheB173k/dulfLt+5UxFq?=
 =?us-ascii?Q?MtgACdorTON8iV7skNQ1X3Sz+KE+28bVIOFqH+rtSqBUhy7/VwiQcBDp7rtq?=
 =?us-ascii?Q?uJSa9uVeLc7KGOE/I02ycq1pijWM9O+FgrnprT1qUG64Lmy6OCpof+R6ea3M?=
 =?us-ascii?Q?d2xkqRqmpPErwNe76zNvkEqQ41sGioalOegT7EoHoPaVNdlWyd+zEqwEMQRn?=
 =?us-ascii?Q?TaJBTI8lNoGWuzwn5/VhuySHmN99iiTU9hup7vSDREpqi4wyPqC6se1Yy8i2?=
 =?us-ascii?Q?T8Hzp7zgWBt1QvHOc8aanWQKgttSJvsf8AGdi169tVDLtXqd8sjY5dnMcfub?=
 =?us-ascii?Q?TnE1htNXvIU4PN4UImsBcEfNDMh8BgNXgtZuL36DsL2pHDXXwczHiRYDgLvK?=
 =?us-ascii?Q?ADSQ94s0bxTjtqrk/442qqmvKwH6s/7cJOJZvTdnBP8YLBSNECwvc/3psGy1?=
 =?us-ascii?Q?l5HmWIkwz/8zBCjRQAq18IMq+e3E4gJYxZo90UCb1CB+RLF+cVM8yS2KyXmZ?=
 =?us-ascii?Q?H8swgGto9p7DyNRbphasZAXpMTvZr0PtW/zPFvDwCsi//GIYUkh2Wo8JmRYj?=
 =?us-ascii?Q?jxs+i27YbSgrGH6rH31eOOE/1PJTR13uVX6tas1gnKymaIHwGZ2F4LTllbCH?=
 =?us-ascii?Q?llpr6gbk9U9+Hnj2j3nGoDer6zDYf+z75dAn2SEmWhxXwhF+3GXPJICrtTQH?=
 =?us-ascii?Q?So1Bq1w48c2UOghYnzzyN5ugebUOHE8t7iGyfUzswnqIfdNo8l5OdQeUYFK0?=
 =?us-ascii?Q?rULVQPed+TcbWoMRWP4mxIr1G621ROMXpwi7o8j51ujpHVVz1IWTmIUF5uW9?=
 =?us-ascii?Q?LM9QwD9ru5F4dvggYnKT52LPpB9H77ycTlI+YhXk847PAIWrX5187yPseoqd?=
 =?us-ascii?Q?u14CMC/HeRDE1y0MIlsy4igBKCERIlB1gHLSOc1OCUa8vCs6YGsr/NhlpVmv?=
 =?us-ascii?Q?QZ7M6jr7rL1g9/4k5fCsXRnij6aRWdEFgpa6c5O4wdCGq6boTWlseGuddQQ5?=
 =?us-ascii?Q?fxDgPuDz3HZ/VS+fjitarEhetuSVXDF3/zHW+qoNRezJkfEnPPskRGyxxXjE?=
 =?us-ascii?Q?HgbutxNLsGygIixiJpGaqAG6UKJL2aLjo/k2OJGgozcyUndGNt6xhz7+wGYb?=
 =?us-ascii?Q?DsO4r0hKYoqk6AlJJWuy6I3zaugR0Jk=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3243f3b9-33f5-47c6-ca08-08da48bfedeb
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 19:57:19.5827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RHj4dIXhpUZpHFPcCdOdJgfpdFfYWupLFhhazHlpTBBKwvB42TvCbzijrzTQM2Pv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1613
X-Proofpoint-ORIG-GUID: vzD-gdskCa3qt6lRis-DyosVWnoBOeN8
X-Proofpoint-GUID: vzD-gdskCa3qt6lRis-DyosVWnoBOeN8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_09,2022-06-07_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 06, 2022 at 03:46:32PM -0700, Stanislav Fomichev wrote:
> > > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > > index 091ee210842f..224bb4d4fe4e 100644
> > > --- a/kernel/bpf/core.c
> > > +++ b/kernel/bpf/core.c
> > > @@ -107,6 +107,9 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
> > >       fp->aux->prog = fp;
> > >       fp->jit_requested = ebpf_jit_enabled();
> > >       fp->blinding_requested = bpf_jit_blinding_enabled(fp);
> > > +#ifdef CONFIG_BPF_LSM
> > I don't think this is needed.
> 
> enum cgroup_bpf_attach_type is under '#ifdef CONFIG_CGROUP_BPF', so it
> fails in some configs without cgroup/bpf. I was trying to move that
> enumo out of ifdef but then decided that it's easier to fix here.
> Should I instead try to move ifdef in bpf-cgroup-defs.h around?
Having ifdef here is ok.  Should CONFIG_CGROUP_BPF be checked ?
