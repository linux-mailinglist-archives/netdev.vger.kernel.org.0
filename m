Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DB22339F7
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgG3UrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:47:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5346 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726539AbgG3UrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 16:47:04 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06UKjafP004298;
        Thu, 30 Jul 2020 13:46:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=98L+6IA6qjO2g67W2tKi8j3Hlywts0AhMj8JLqqcEVc=;
 b=pjbecsg8j+wuDZ1aXVMyAbzmvWCrmzAOi5PjRmrnfWsatfl/vJ5mVne/5YipeQLq119/
 boJs2UUdTLyYIFbZ+NU+NsBKpNRuTt8TxoDL9OXq6Mu8hbbRUkpAfv/Gy65oOBsDpX1i
 NH+G7zUtSLoK1sX278wWM7pGtG+N0L6goh8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32kcbuxtwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Jul 2020 13:46:50 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 13:46:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvTo9hjriUnNpT4AvUeYfxDV62Re4pEsA1OznMg43MfkLPN3FQ+xtbCrC3S+eH181x0h2Kq4KOJK1Ws2BsZRZNtp8O6aRt/XwzsRx0FA7LyT0oXtDz/4N7zQWfsGuZbpT6zXcc3+jHMxLcyguX6eGfQ86zaBKYXJxWuA1+MqTjVfIQEl5waSO7GCLZrUI5kXYydkd0lyP7KgPeilpagCPLtehs5H3+72UUggl+RVI/+kOHVL/8oRAegy9PvZ4bH+XDcl5jJpY89YEJa7L9Ha0v/JkPenSExLGRNf+u/0ndQ0VZ2AFTFkESN7JoGp7VZnmY4i0g48PoQ3aCNLwHISXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98L+6IA6qjO2g67W2tKi8j3Hlywts0AhMj8JLqqcEVc=;
 b=Px0OUCrCqHQZWKh+LO0VBPxfhmwMrXzY0YP/RSd5oeu68FJXhNsBA/7MJAaEt4k2pMtxFxooOBANsZtE8ZxTLLffEKTAgrlJ/RfjZYJsGZF7zXyqo9na3xbVsJPJBPEp1tXuNY25s4y9ZIOm1Ohb4sSKEADVQzZ06lDyzmQh2RyGlIZCBMHeiYp/KPG44+9XKVkL3FLgs8CnOSlSllXAGmCxnBUY3NWfw8qwTxVSJOTMnzL7yfbMySFHE1EgZJKrN7T6gJaDfrIdCLQLaP5kExV599TaL46KlC8bWC8VzuwkuNFqsRAV7fo9ZoK/ftMY9ngDZNtQwLm7V09M92mMFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98L+6IA6qjO2g67W2tKi8j3Hlywts0AhMj8JLqqcEVc=;
 b=b3LJUawO1dZ01X32Wc+fkkyswegDT6s80+OnrRBro14GtPOzsXgpEqjs5MDsW4wESmMSs15VpsmTNoDNBx8OwB5nvB9L/dz3Hu3iyQp6hz6MXorPJefgzeQDbeZnQnQaPjcIJ14o76Xl1fJ0R0bnqtxMHKlTIj5EcwUNEoWDC7Q=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2870.namprd15.prod.outlook.com (2603:10b6:a03:ff::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Thu, 30 Jul
 2020 20:46:31 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e%6]) with mapi id 15.20.3239.017; Thu, 30 Jul 2020
 20:46:31 +0000
Date:   Thu, 30 Jul 2020 13:46:28 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 29/35] bpf: libbpf: cleanup RLIMIT_MEMLOCK
 usage
Message-ID: <20200730204628.GA712334@carbon.dhcp.thefacebook.com>
References: <20200727184506.2279656-1-guro@fb.com>
 <20200727184506.2279656-30-guro@fb.com>
 <CAEf4BzZjbK4W1fmW07tMOJsRGCYNeBd6eqyFE_fSXAK6+0uHhw@mail.gmail.com>
 <20200727231538.GA352883@carbon.DHCP.thefacebook.com>
 <CAEf4BzamC4RQrQuAgH1DK-qcW3cKFuBEbYRhVz-8UMU+mbTcvA@mail.gmail.com>
 <20200730013836.GA637520@carbon.dhcp.thefacebook.com>
 <CAEf4BzaZhyus7Kd-08vrVW9sr6gHGj1mCBgUY-NCWUOfdEJgHw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaZhyus7Kd-08vrVW9sr6gHGj1mCBgUY-NCWUOfdEJgHw@mail.gmail.com>
X-ClientProxiedBy: BY5PR16CA0002.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::15) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:aebb) by BY5PR16CA0002.namprd16.prod.outlook.com (2603:10b6:a03:1a0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Thu, 30 Jul 2020 20:46:31 +0000
X-Originating-IP: [2620:10d:c090:400::5:aebb]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b8f2fae-872a-4860-6265-08d834c9a3c4
X-MS-TrafficTypeDiagnostic: BYAPR15MB2870:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2870F4FC466877DD72874667BE710@BYAPR15MB2870.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hf4sHHQQ3cXapE+HyQz/2yUZtHertccavJdbMY96jbihFEns6yqjAUjN28o/dvxaHeLw+vvGWYBWo/F0r94lde2Xd9zhvJkhBJsYjK1byx+t8rU+u37z7yftwJT2RWcJ0Dz8y8sKVKO79vPgp/beFiU+dBcXaS4HuCQLJBrA2eScfL5QCTvVbJ0+R0c7GZeehr1220+AkARhV4FMFXbLSTCNGo8p3j+0v+kbvN9ccx2uwgkfVibCAPxLr3r2MI+kTPEy0+JvDC49RuXjfPb8wHm8VLpJHF5TE0Zy31GIWYdVLxpWS/pmWB4T8ehs0AqhyZRqYnYLdHrRMOfFpFT48g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(366004)(396003)(376002)(346002)(66946007)(66556008)(9686003)(6666004)(86362001)(8676002)(6916009)(55016002)(1076003)(66476007)(8936002)(316002)(83380400001)(33656002)(186003)(16526019)(7696005)(54906003)(6506007)(52116002)(478600001)(5660300002)(2906002)(4326008)(53546011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 0QZWwZl+wQsz4S+pUc3bz1O0jGU7qQI2PS/DiLOxW14bMcygbv/3drJ2ErlWtIOOBanYU+7gUPADeYWQngTY1CfmLqfJy8WN/WCArQ8tyXHfYkweNG78Xu4ulEYz1l5bHc1gn7d1e6GmdkvBObPww3G3S1jIimG5g5e44SpvRhRC2mkp8f/HBJwon0TNBqDQ4d4+G6QvKShHEUwMLVOXQpPXEOs68Sn+UA0pM7SJFXpQ3feGpMssmNvMOxZ8DqzwkKSttYBXcXQftXoJuz28SvAF63/SBamKNUarVeBlRXymlhZUYHVj52AyTkT1FWcRjdNTy0MEl5QEToFpC5ntf/HOdxfdpBn+Kn0h/9ScNIaqpMgOOF/j/JuY2HOV+3UbywjHD6lGF0lBzGeaZzrHU0gYlZ/BWryPFb3xJOdDZcTYAv8Caz8R1lY1IsmhaEc2tXXnA6ocyHqzAvxARnZfG6Vj9m7miV7DLd7UWBDClwbP/8n/IWgie7t5s4H4tmuYHmaEkWlM5xxR/RSbUOI/7A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b8f2fae-872a-4860-6265-08d834c9a3c4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 20:46:31.5471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Am3La02DP4YQO2lIyGGGVnDQnB7YfWMW+1kxFCINeSf4rorgBe1OWErfhaoeNdlS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2870
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_15:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 clxscore=1015 suspectscore=1 phishscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300146
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 12:39:40PM -0700, Andrii Nakryiko wrote:
> On Wed, Jul 29, 2020 at 6:38 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Mon, Jul 27, 2020 at 10:59:33PM -0700, Andrii Nakryiko wrote:
> > > On Mon, Jul 27, 2020 at 4:15 PM Roman Gushchin <guro@fb.com> wrote:
> > > >
> > > > On Mon, Jul 27, 2020 at 03:05:11PM -0700, Andrii Nakryiko wrote:
> > > > > On Mon, Jul 27, 2020 at 12:21 PM Roman Gushchin <guro@fb.com> wrote:
> > > > > >
> > > > > > As bpf is not using memlock rlimit for memory accounting anymore,
> > > > > > let's remove the related code from libbpf.
> > > > > >
> > > > > > Bpf operations can't fail because of exceeding the limit anymore.
> > > > > >
> > > > >
> > > > > They can't in the newest kernel, but libbpf will keep working and
> > > > > supporting old kernels for a very long time now. So please don't
> > > > > remove any of this.
> > > >
> > > > Yeah, good point, agree.
> > > > So we just can drop this patch from the series, no other changes
> > > > are needed.
> > > >
> > > > >
> > > > > But it would be nice to add a detection of whether kernel needs a
> > > > > RLIMIT_MEMLOCK bump or not. Is there some simple and reliable way to
> > > > > detect this from user-space?
> >
> > Btw, do you mean we should add a new function to the libbpf API?
> > Or just extend pr_perm_msg() to skip guessing on new kernels?
> >
> 
> I think we have to do both. There is libbpf_util.h in libbpf, we could
> add two functions there:
> 
> - libbpf_needs_memlock() that would return true/false if kernel is old
> and needs RLIMIT_MEMLOCK
> - as a convenience, we can also add libbpf_inc_memlock_by() and
> libbpf_set_memlock_to(), which will optionally (if kernel needs it)
> adjust RLIMIT_MEMLOCK?
> 
> I think for your patch set, given it's pretty big already, let's not
> touch runqslower, libbpf, and perf code (I think samples/bpf are fine
> to just remove memlock adjustment), and we'll deal with detection and
> optional bumping of RLIMIT_MEMLOCK as a separate patch once your
> change land.

Ok, works for me. Let me repost the kernel part + samples as v3.

> 
> 
> > The problem with the latter one is that it's called on a failed attempt
> > to create a map, so unlikely we'll be able to create a new one just to test
> > for the "memlock" value. But it also raises a question what should we do
> > if the creation of this temporarily map fails? Assume the old kernel and
> > bump the limit?
> 
> Yeah, I think we'll have to make assumptions like that. Ideally, of
> course, detection of this would be just a simple sysfs value or
> something, don't know. Maybe there is already a way for kernel to
> communicate something like that?

For instance, we've /sys/kernel/cgroup/features for cgroup features:
it's a list of supported mount options for cgroup fs.

Idk if bpf deserves something similar, but as far as I remember,
we've discussed it a couple of years ago, and at that time the consensus
was that it's too hard to keep such list uptodate, so the userspace should
just try and fail. Idk if it's still valid.

Thank you!
