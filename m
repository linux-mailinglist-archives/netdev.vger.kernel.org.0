Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8DA1DDAA1
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 01:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730736AbgEUXAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 19:00:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54274 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730041AbgEUW77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 18:59:59 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04LMuhBN015994;
        Thu, 21 May 2020 15:59:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=t7qcgm4juQPVFPlc/WEX4PbtuRCYJMqkG2pjdI0Uq5k=;
 b=lSo4wANnYL6ALt3RkOkgO4qGXVBYiKYc9JjLBdg6317/COeanQ20w9lSVohsTeOZlVM7
 CxMseW1M4rUBug40VbfQ9jSj/7g2yyJGQE5DddUdp3cHn6JqYBF46s+oMjobowW6y7in
 KW5LzOU2RoFkFNfPgqhFr6f8Dk157gPBB50= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 314qu0ywpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 May 2020 15:59:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 21 May 2020 15:59:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAnSAQbip1vk8opWViabDLCL0THWdkHd9WA/muONdcM73YAK6ZABr4Jf7Imy+ozXc5ZvUFT8T+22LfS5I7YLUtH2s4V7h6hHBMLhiHCN53VxdxqEyx/HWt8CNx6wHgncOOrgRk9ywUIg9Mbt4kX+6pQ9avjGpwVZ7Bs6LBjwk19ulGPkPDDTcHCHQT7ReGBh8KatBoPVki2g8DRem4rDHw0hA+Lgv1z3VxjutYI+/5DjHTtMTOqdqSI0BFOiMN/HMgfsZUclIrhJctUitbiB+4J4gmuEk3T3ITfQXlI813ROXrTiMnAixImPxAzpB6QoW0rzd4XFCmlA3+Kckbal0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7qcgm4juQPVFPlc/WEX4PbtuRCYJMqkG2pjdI0Uq5k=;
 b=DwS3TdP11qoy5gpn4fEnKv7Bt+RddPy394JeIW95j8zrYTNUT/RVH3xnIlmuloNzVkEZKVYkSvMa90j/basKJNCysMMr0iv42ucEQbwQYKddA2+PSUCaIKlRbmKUiTDwgjMdfHtcLx78f8h/l8l0Hx5TOzRnKa81gDoBTSUdEbCYhvnq9Ej8fc3R03pYNVuGPQBBBLmleKOK4BSBK3jHVqeY4RBBV+B0TVfqarxeywPpnGMMl2F5uMj98bUlbRgmQy8IfUISX3cxN92npK/5rgBMLw8KWJhS4x2txgD3ncLlN93fY3cq51VBMY9KSE9y99hUdd9cvXGu0edcW/nKxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7qcgm4juQPVFPlc/WEX4PbtuRCYJMqkG2pjdI0Uq5k=;
 b=fVkRwCtZXzypC+ZFfpg/c7GFtFCWZm7Iowi8+geWFEu1gkLFXYnbXOK0VF4Dbafd2jLB0w+bk+YirtJKZqoA79a8kdx7ZjMjTrNWW+oXzzyJ8JaSl40rIRxVMGQnFIq0H6uy1rnCmz5hEcr6/jiyjs2qhFr57mH25ThBljDLsHY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3588.namprd15.prod.outlook.com (2603:10b6:a03:1f7::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Thu, 21 May
 2020 22:59:41 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::71cb:7c2e:b016:77b6]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::71cb:7c2e:b016:77b6%7]) with mapi id 15.20.3000.034; Thu, 21 May 2020
 22:59:41 +0000
Date:   Thu, 21 May 2020 15:59:39 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 0/3] bpf: Allow inner map with different
 max_entries
Message-ID: <20200521225939.7nmw7l5dk3wf557r@kafai-mbp.dhcp.thefacebook.com>
References: <20200521191752.3448223-1-kafai@fb.com>
 <CAEf4BzYQmUCbQ-PB2UR5n=WEiCHU3T3zQcQCnjvqCew6rmjGLg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYQmUCbQ-PB2UR5n=WEiCHU3T3zQcQCnjvqCew6rmjGLg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:510e) by BY3PR05CA0008.namprd05.prod.outlook.com (2603:10b6:a03:254::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.8 via Frontend Transport; Thu, 21 May 2020 22:59:41 +0000
X-Originating-IP: [2620:10d:c090:400::5:510e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16d11536-2a3d-4c2e-eab6-08d7fddaa567
X-MS-TrafficTypeDiagnostic: BY5PR15MB3588:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3588F58D9404764A1F5C0609D5B70@BY5PR15MB3588.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 041032FF37
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jtb9bSJdjHiJcYxcRCjo3GMAzlt6EIpXdfeGfdpawO130E4vqvhhFS244Eor87y6eoQC6p5IEI92DlM8nsx3vc+oBXsoVSnRd+mADxydtUdz1Nuq6MgBG8VaH2YF3JPJW5dOK42JYbsuIpRJzvfb3bNIEAIgP3lcwH/8iNyAXZyB97dRa/2TiakuzbybCCeUjm8W2/jljyoQk1PaGJhgxnra9sBht8Or8kk/EkY4a0FBl+n68AEWrQ29e50l0zS1zuyDmzMThCdqUO7LXkdcmOG5Hb/WS40kXlAMfi50qGc+KIjNPk3X4CFqzQCaRoVwWzTQZIBjnKT7RqpYESY++Ul775e0lSziedPfRv59OGRFnkg8RaPHdcbTPUtnZje5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(366004)(39860400002)(396003)(136003)(376002)(52116002)(6916009)(9686003)(66476007)(316002)(66556008)(4326008)(7696005)(1076003)(54906003)(55016002)(2906002)(478600001)(5660300002)(86362001)(16526019)(8676002)(186003)(8936002)(6506007)(53546011)(66946007)(343044003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: t5YAulk/fMwQ26c+AkZV4YqaTOvNlsNt3r56PSbdCDK8h8QwTmx0E4/1juZx4Rq11TjEjTyFOhLkKlpIxEsNf8CETyoqJv7etWh2vN0MM87QFMOXi+j4TNLWrWwpwWhx29PCXCMSO0gEburAN//pTaoS08EP+Tpt6rLkvrkvXLxQDilNBYgH/6UI49SwaF8ZCBYrtVMIV1mnpimQpvRF62I7w7sBp6E5RnZnY6SDKx/35YBFMlDPqorwmNweCROrz+dJJoG0YLSHnyyBwFicovGaGytpNX4f7ivYf8Yq7nGMuIJhn6XA0XX0e/0vsReXMY8sXnF0SSdyS7zXOn1bk3j52MkhPKwTR0YqiRtVNliOk3zJ0rnB0gFQt2IuYbOLNdvxno4tneDIw+BUQbRwUTtJ/LHOWEi2j+qXNhEvYCya8klembE9ts/92mNPTgC4R4mdMZbYekfqajv1vAc7YN9HAlO0b+he78nDk5S/8Q8aEpGlrHQ2FrsdpFalHxRCgv8kUbnymfFYIstRlI2Tjg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 16d11536-2a3d-4c2e-eab6-08d7fddaa567
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2020 22:59:41.7692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 198JGsxUeX5I3lj1zglLrr1405OEi18lJ0ASD9/JOuu0OHgZG3M86HUsHAFde5qR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3588
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-21_16:2020-05-21,2020-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 adultscore=0 mlxscore=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 clxscore=1015 cotscore=-2147483648 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 03:39:10PM -0700, Andrii Nakryiko wrote:
> On Thu, May 21, 2020 at 12:18 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This series allows the outer map to be updated with inner map in different
> > size as long as it is safe (meaning the max_entries is not used in the
> > verification time during prog load).
> >
> > Please see individual patch for details.
> >
> 
> Few thoughts:
> 
> 1. You describe WHAT, but not necessarily WHY. Can you please
> elaborate in descriptions what motivates these changes?
There are cases where people want to update a bigger size
inner map.  I will update the cover letter.

> 2. IMO, "capabilities" is word that way too strongly correlates with
> Linux capabilities framework, it's just confusing. It's also more of a
> property of a map type, than what map is capable of, but it's more
> philosophical distinction, of course :)
Sure. I can rename it to "property"

> 3. I'm honestly not convinced that patch #1 qualifies as a clean up. I
> think one specific check for types of maps that are not compatible
> with map-in-map is just fine. Instead you are spreading this bit flags
> into a long list of maps, most of which ARE compatible.
but in one place and at the same time a new map type is added to
bpf_types.h

> It's just hard
> to even see which ones are not compatible. I like current way better.
There are multiple cases that people forgot to exclude a new map
type from map-in-map in the first attempt and fix it up later.

During the map-in-map implementation, this same concern was raised also
about how to better exclude future map type from map-in-map since
not all people has used map-in-map and it is easy to forget during
review.  Having it in one place in bpf_types.h will make this
more obvious in my opinion.  Patch 1 is an attempt to address
this earlier concern in the map-in-map implementation.

> 4. Then for size check change, again, it's really much simpler and
> cleaner just to have a special case in check in bpf_map_meta_equal for
> cases where map size matters.
It may be simpler but not necessary less fragile for future map type.

I am OK for removing patch 1 and just check for a specific
type in patch 2 but I think it is fragile for future map
type IMO.

> 5. I also wonder if for those inner maps for which size doesn't
> matter, maybe we should set max_elements to zero when setting
> inner_meta to show that size doesn't matter? This is minor, though.
> 
> 
> > Martin KaFai Lau (3):
> >   bpf: Clean up inner map type check
> >   bpf: Relax the max_entries check for inner map
> >   bpf: selftests: Add test for different inner map size
> >
> >  include/linux/bpf.h                           | 18 +++++-
> >  include/linux/bpf_types.h                     | 64 +++++++++++--------
> >  kernel/bpf/btf.c                              |  2 +-
> >  kernel/bpf/map_in_map.c                       | 12 ++--
> >  kernel/bpf/syscall.c                          | 19 +++++-
> >  kernel/bpf/verifier.c                         |  2 +-
> >  .../selftests/bpf/prog_tests/btf_map_in_map.c | 12 ++++
> >  .../selftests/bpf/progs/test_btf_map_in_map.c | 31 +++++++++
> >  8 files changed, 119 insertions(+), 41 deletions(-)
> >
> > --
> > 2.24.1
> >
