Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F41C2FC9A3
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbhATDyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:54:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63664 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730032AbhATDup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 22:50:45 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10K3moQl009623;
        Tue, 19 Jan 2021 19:49:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=xZJt1aepH3pNR4HHKasL7XVT++h+k3Umn91Ql/jk6Pw=;
 b=dRbxDZ8u3QIB4zk0PAxFru+XB+hu98cM/+nJ+UCXnyyjMvmNAKsuECvlSQujCzFjDmsy
 F00/piMvqtDG5QvRmCCQy4gQ/pCqj1vieaoRssKusSioIsfL9ssavUvl72pTxSpm7zfu
 un8AQblBQ4+L62/iGk4QqdxKyczxTxpsoRM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3668ph956u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 19 Jan 2021 19:49:56 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 19 Jan 2021 19:49:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pt2GJtTENxhfocMjKxgGeK1OTtByJQgNm91RP53Cp9S6Fq3shI/0GbgVMNqB5LkqCkxB0QN1vuuGiYz8PtN+7LHxgT7G5QPkPIe7jHttJhlBD4QMXTGZqZKo0BsoJIaZBxIRvd+tloLgiRTnVuryqVRJytGt3AW94qwjH1TpnZSWNazABdpjo2Rom1MWoaUyrxLIbQ4crZR8fuemG+iMBUe6pqSysSPOpoo7ljZIGnKfv5vmT7enGPEHZcbJbkgLGbW7qa4Aba+V7aVKGNDp3ASkB/WIUX02B89cdzQFVipfzvW+hNyrGr1Q/NN1woirnnvwTYBd/hiasyPfA0mdkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZJt1aepH3pNR4HHKasL7XVT++h+k3Umn91Ql/jk6Pw=;
 b=IoshRRuVA/jTNVhW4pjgnKFfv+0Zwed7O6vou2J3Mif5wkDUiBuSl3s4nnl2LMPY0LvxJPQx81L+i1Cxa8vKikRKl4K3FWo25PxsVGtIJ4ixw8PxLkBc/R0j2iGa0WCk3zP8Wu2rWKP9+ib2aakLfuWQPt/3wS/sLHRfRoMXYxFHIiirmi/BMlint2J6o00P83QMZf48Db6Z+YVUtM6QdNBJ0EahNCn5+xQHryXPjQ5DlUFG/+fqP6JwXqYQma4gf/2S06VMyHDEuW5mGlhyncnhtrgGhCAf1A5hEzpwiaPuMy1uH9dSR2zo2+F/aNPgBSdbZ6EuHxcLMAVXC22d/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZJt1aepH3pNR4HHKasL7XVT++h+k3Umn91Ql/jk6Pw=;
 b=JPjphiPgD8yclzXEkFLw3maMh6cop9gKVc3Pmnk/V15x2EqZyKfw7wm4q8cnpUcHjDk2YK5x/SmhU7yv+E2UXC0cpySgFcOEm01X6iZctwan32oyLv0WTLQn97wMpDgr/T0C/cuEIcdTuHsaA+J0Q/2TMyizFisrj4NBg0X2+vc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2214.namprd15.prod.outlook.com (2603:10b6:a02:8d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.11; Wed, 20 Jan
 2021 03:49:54 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1%6]) with mapi id 15.20.3763.014; Wed, 20 Jan 2021
 03:49:54 +0000
Date:   Tue, 19 Jan 2021 19:49:49 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Arjun Roy <arjunroy@google.com>
CC:     Shakeel Butt <shakeelb@google.com>, Yang Shi <shy828301@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
Message-ID: <20210120034949.GA1218369@carbon.dhcp.thefacebook.com>
References: <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
 <20210112234822.GA134064@carbon.dhcp.thefacebook.com>
 <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
 <CALvZod4am_dNcj2+YZmraCj0+BYHB9PnQqKcrhiOnV8gzd+S3w@mail.gmail.com>
 <20210113184302.GA355124@carbon.dhcp.thefacebook.com>
 <CALvZod4V3M=P8_Z14asBG8bKa=mYic4_OPLeoz5M7J5tsx=Gug@mail.gmail.com>
 <CAHbLzkrqX9mJb0E_Y4Q76x=bZpg3RNxKa3k8cG_NiU+++1LWsQ@mail.gmail.com>
 <CALvZod4Ncf4H8VWgetWoRnOWPT4h+QDK_CY+oK11Q4akcs4Eqw@mail.gmail.com>
 <CAOFY-A2C4=fWQB69rmP1Ff1Sh=NLCPKT1kD-Lpq29342YJvaWA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOFY-A2C4=fWQB69rmP1Ff1Sh=NLCPKT1kD-Lpq29342YJvaWA@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:bba5]
X-ClientProxiedBy: CO1PR15CA0109.namprd15.prod.outlook.com
 (2603:10b6:101:21::29) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:bba5) by CO1PR15CA0109.namprd15.prod.outlook.com (2603:10b6:101:21::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Wed, 20 Jan 2021 03:49:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fdf1bb4-ddcb-41ce-a089-08d8bcf67241
X-MS-TrafficTypeDiagnostic: BYAPR15MB2214:
X-Microsoft-Antispam-PRVS: <BYAPR15MB22147FB866639C9174417CA0BEA20@BYAPR15MB2214.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jul1gIzMbzFGuGgtumwAlSRN5qDbhps/7kPTE171f9WpV55PxWQwrSsqkEZVaAin3hvu8XsAU9+bXoJS9EWEVAPTfuPJ8oJwQcVgFzyYZbL+CudHF/oYC6pLDieLCNUJj4Ry8LH+Tf0uNJKMuItvOeydPSduus9DN19yVws15gsRvU/MP3E7KMaOL7bME1lxFiWKrXvprpc/NslmPpxDnRZQsOYMxLJp0myEzuyy7cbadShl8pGMGoggo9W3o8+d8FjXDg7Nh83Zmu4nT2W6cy8gP7UGsfznpn/Xy5zlXFGnrPn+GFMTOzN5vZIBTe0g5hSnJVRRnP85a0s77M0A0CA67cBt4Amc+vjQe4fjuof9cZRgZpoOO6zHTVpNGkDy7VNynAj4AidAGaQ7dx+lXdk4Qkx7sBJTH8/Ldav2IQGIJJJ2rZ8wOV4dIhften7Iuyv5egdmLgb3t+DATqTFBERCg2Qw1ywhdKb+1y8Var1coQ+iZnkk5EzrwzrD+KhJuHEFMgyw+ouBRbg4UpDDFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(366004)(346002)(66556008)(8936002)(86362001)(66946007)(83380400001)(478600001)(66476007)(1076003)(55016002)(15650500001)(6506007)(16526019)(8676002)(2906002)(53546011)(316002)(7696005)(186003)(54906003)(33656002)(52116002)(7416002)(6666004)(5660300002)(9686003)(6916009)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sqtyd8sA90kZjBFuIYkBRVWGIWlXhXJw+UGd6xAM+xQSgcWRZ3+WiXhzXP4j?=
 =?us-ascii?Q?EHGTI7sOxM/MbmjV2tg+soGGXQ8Qu9H05T5Xu8p0+FBzJamdsSDnCbRYPtZN?=
 =?us-ascii?Q?3veQaVLAnrp7juGjMjvZQ6YVrTIh8FIgATb90HxmjlH48hwWcFQqm1W8sSxR?=
 =?us-ascii?Q?tfJrDuTtGbxQseuEqFgTpobYp0WSoNPUMwRzUycfxHbfwYFHbaQyKtISXSk8?=
 =?us-ascii?Q?mShSRkkjIIS79djrN5Wksddptme5r7DmAR6xG2zCD5Yx6FidlqFmsQVD34Rk?=
 =?us-ascii?Q?Qa1DiI0pzJc0VwIzyx67c+GXphj1sqbr5Ht9Wq8GHuS/HJ4ShbxfxaDHwqXF?=
 =?us-ascii?Q?qHSxzfGuUshTJxdjAponjCmx/6vzomnOIkTngvlRalbQcQeDvtV3BEWQ7Hcf?=
 =?us-ascii?Q?da4+x8f4GskJIQtJE84RlIE4tHFvxPXeJLfqLblK/6KUB5BHBqYJJhFdq3PS?=
 =?us-ascii?Q?4zryTmfypmA+iSgkGJrksZCf/+nSTUyDYKBA7DQJpS/Cfgfv6D6NfhTY2mDf?=
 =?us-ascii?Q?m7QdjzAHqNXGVLYTeeud9mbS9rJmCW80ouD2lw74e8vofczNVY2a/RbuxU0X?=
 =?us-ascii?Q?cc0Hge8j1B+wCbl/YD4dVUACdIXouGCNKhge0S+xU3rZqbDhjnwMZkj5hSpc?=
 =?us-ascii?Q?Of+G+O0fhqOfNgTL8I9+lZyjP6wnZopATrlcsFf1kkJFPALy2vJ/K4pHZfpV?=
 =?us-ascii?Q?lCgtO82Rcix4CdNQpAc+jHUHi5CA6RayLlQYmGEq/Ujizg67FZpYUV6gtdhD?=
 =?us-ascii?Q?hgEkRFIFS0d+MIUT1xixLE1di6qg1B0tBf7vQCn3t09Q36/mTGPYhPnrB1+A?=
 =?us-ascii?Q?PEipYi2zKg1m+gwSTFjaWZ0qEybAh7CUeIXVbID4S06U/cgksY/VtKzz8JE1?=
 =?us-ascii?Q?S9p8uOTudsJfBHZTd0xnUBQO2SGU7OUaMCUvTCq5T64vjHX1HiApcqtlwuq1?=
 =?us-ascii?Q?lapLN5VsS18jDRZOxDDh4HUdEu8wU4nYv9Zhtnh8g5LoOOlvnSeiisJ9nMDA?=
 =?us-ascii?Q?oVoFvLzQPFccTBS90rb0XdmTIA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fdf1bb4-ddcb-41ce-a089-08d8bcf67241
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2021 03:49:54.1183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9xPVm2kG9JsKaI4CQ6z/NUyDssevgno4Kmdx3fdgcu0gavAuV+dszRBmRWWsaWi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2214
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_15:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 adultscore=0 clxscore=1015
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101200020
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 07:31:51PM -0800, Arjun Roy wrote:
> On Wed, Jan 13, 2021 at 11:55 AM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > On Wed, Jan 13, 2021 at 11:49 AM Yang Shi <shy828301@gmail.com> wrote:
> > >
> > > On Wed, Jan 13, 2021 at 11:13 AM Shakeel Butt <shakeelb@google.com> wrote:
> > > >
> > > > On Wed, Jan 13, 2021 at 10:43 AM Roman Gushchin <guro@fb.com> wrote:
> > > > >
> > > > > On Tue, Jan 12, 2021 at 04:18:44PM -0800, Shakeel Butt wrote:
> > > > > > On Tue, Jan 12, 2021 at 4:12 PM Arjun Roy <arjunroy@google.com> wrote:
> > > > > > >
> > > > > > > On Tue, Jan 12, 2021 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
> > > > > > > >
> > > > > > [snip]
> > > > > > > > Historically we have a corresponding vmstat counter to each charged page.
> > > > > > > > It helps with finding accounting/stastistics issues: we can check that
> > > > > > > > memory.current ~= anon + file + sock + slab + percpu + stack.
> > > > > > > > It would be nice to preserve such ability.
> > > > > > > >
> > > > > > >
> > > > > > > Perhaps one option would be to have it count as a file page, or have a
> > > > > > > new category.
> > > > > > >
> > > > > >
> > > > > > Oh these are actually already accounted for in NR_FILE_MAPPED.
> > > > >
> > > > > Well, it's confusing. Can't we fix this by looking at the new page memcg flag?
> > > >
> > > > Yes we can. I am inclined more towards just using NR_FILE_PAGES (as
> > > > Arjun suggested) instead of adding a new metric.
> > >
> > > IMHO I tend to agree with Roman, it sounds confusing. I'm not sure how
> > > people relies on the counter to have ballpark estimation about the
> > > amount of reclaimable memory for specific memcg, but they are
> > > unreclaimable. And, I don't think they are accounted to
> > > NR_ACTIVE_FILE/NR_INACTIVE_FILE, right? So, the disparity between
> > > NR_FILE_PAGES and NR_{IN}ACTIVE_FILE may be confusing either.
> > >
> >
> > Please note that due to shmem/tmpfs there is already disparity between
> > NR_FILE_PAGES and NR_{IN}ACTIVE_FILE.
> >
> > BTW I don't have a strong opinion against adding a new metric. If
> > there is consensus we can add one.
> 
> Just wanted to see if there were any thoughts/consensus on what the
> best way to proceed is - should there be a v2 patch with specific
> changes? Or is NR_FILE_PAGES alright?

I struggle to see why these pages should be considered file pages.
(NR_FILE_MAPPED is a different story).
I'm ok with slab/kmem, sock and a new metric, we can discuss what's
the best option out of three.

> And similar query, for pre-charging vs. post charging.

IMO double accounting is bad. If it means post charging, I vote for
post charging.

Thanks!
