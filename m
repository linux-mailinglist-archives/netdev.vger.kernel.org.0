Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C565423299B
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 03:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgG3BjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 21:39:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55994 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726194AbgG3Bi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 21:38:59 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06U1aFo8004370;
        Wed, 29 Jul 2020 18:38:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=fP6wWtu47bksrf2R7SULsTWRdAFlgFIlY55eLmUswxY=;
 b=lgcuNzZvLI1fQ9+jMpLLPy86xMTznKw1vaMGZqNOHqfTpVZqH9HFW2UTdnCRvZwFSF/u
 KpykMKztXRiuMVdOU2pvL5Fhudv22In9pPfMY6YRN9R8s+l3tOBlteuPCRfnKMVhTIP7
 qardDncQJOtvSdfE1sVgdNQT6SbccYr9oc0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32juqwpbuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Jul 2020 18:38:44 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 29 Jul 2020 18:38:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTv58QJiKpeb4I+VQcDJ3htG/MsD+EmTkIL7my+EBRphm9uUXcxwP/In7vx+M2HwJjPHXBLr6zOoDKtdhPOd/4a25yb1wmZntX+ynfHMUulq8gQ/qy8aRzQQBRWYJ2ucISap99Uww/Aw/todR5TIOMPyYVGzjhEvCvy6D/wcCzKyij53SYXPKJPkaF+gF+6qhZfmLWRJz1nIPnocxnvOlzFxxr8uS9f/GlBB6soqrPM5O8juPdP4eBegZcHgZP9XURKzVWg5tjRxUJ1KwEmhsDLNwPc+FgJG6ebJeXn/1YM8OgM6/N2/K1/hE/lXegg1HPsZTqDohnbP75dR+D0cgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fP6wWtu47bksrf2R7SULsTWRdAFlgFIlY55eLmUswxY=;
 b=aUMltO30kD6OWHBwEK3LLW/nXmfH2oHxD8YsPmFEcBZyoOK1Qzy8ZHlFmyg3rNc/D1fmAkBlVO054D7GYsYrJpIVsoXNo591p8dfMgEpCnStj0gJSOAzGU91M0i1aFkL9FN16B3joRedvM0yNjTIvawZRsoZayx3kEzjB5YJvBXqRyQ30Bt3zey0V3Xqqn7YMcLT520c252O+QgBvyJ8+pB1T+kjoZ60GFDgroEACSWam/kHI3HsUSmjJ8dFbLPXd+F6bW8SXW9tZtU1xP4dFNStN+GZ/M1tmDTWKsrNrPtdt6iiGFgWdQYVomkEIob31XN/PIQ5X5cfCMw5Sfiw8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fP6wWtu47bksrf2R7SULsTWRdAFlgFIlY55eLmUswxY=;
 b=PLubrujrfLvSyPhZuq6pGg9mGiiFP6i140NwwA6hh9P2SfVwOXQLBgBP29Rat5024dWOQ4iaqpbwH2NZ+B3j5jI6bNrvsKoPRjKphgsxN5eZpTBMfDckDik4QibR6V/CYm+fkGx4wN4eP1gqli3fuxT8QPrCXtB/Oqd2sQVJ+Pc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3398.namprd15.prod.outlook.com (2603:10b6:a03:10e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Thu, 30 Jul
 2020 01:38:40 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e%6]) with mapi id 15.20.3239.017; Thu, 30 Jul 2020
 01:38:40 +0000
Date:   Wed, 29 Jul 2020 18:38:36 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 29/35] bpf: libbpf: cleanup RLIMIT_MEMLOCK
 usage
Message-ID: <20200730013836.GA637520@carbon.dhcp.thefacebook.com>
References: <20200727184506.2279656-1-guro@fb.com>
 <20200727184506.2279656-30-guro@fb.com>
 <CAEf4BzZjbK4W1fmW07tMOJsRGCYNeBd6eqyFE_fSXAK6+0uHhw@mail.gmail.com>
 <20200727231538.GA352883@carbon.DHCP.thefacebook.com>
 <CAEf4BzamC4RQrQuAgH1DK-qcW3cKFuBEbYRhVz-8UMU+mbTcvA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzamC4RQrQuAgH1DK-qcW3cKFuBEbYRhVz-8UMU+mbTcvA@mail.gmail.com>
X-ClientProxiedBy: BYAPR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:a03:74::14) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:9282) by BYAPR05CA0037.namprd05.prod.outlook.com (2603:10b6:a03:74::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Thu, 30 Jul 2020 01:38:39 +0000
X-Originating-IP: [2620:10d:c090:400::5:9282]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0248e60-2ab7-4eb1-dfc3-08d8342948fd
X-MS-TrafficTypeDiagnostic: BYAPR15MB3398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB339819828465A9657AEF71FBBE710@BYAPR15MB3398.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D4eJA4UZhnNuEFqD20+B84hdY40u2My+w0YLZssl7ca2IqgXxV4p9Nhsq7MvAVDI0x3XSjmesT8MmkrN8JZjYYgpH0x0s8WvwMHBKRvtBPEmoCsVdSbKLjqn613U7rEfIh0IZra68EMK3NxgB0z3AE/kxXCHQun94ARRLF3EeHOAqJp/8ogttejGKMt2816RP5z8zMZulJv7/HCEcpcnx4omUa0h9h63fd6hWzNM35SHqOdtb/sI0W6RBgg+VnQzlHYrOZnseoHgby78GsMoZlcyNuRqLw4mwFI2Goi/CvfuXzGLosvLcVyKjNYtR/IyvhR5Ldb/dZstyzU8gspRrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(39860400002)(136003)(366004)(376002)(53546011)(6506007)(33656002)(1076003)(86362001)(8676002)(83380400001)(7696005)(4326008)(52116002)(5660300002)(54906003)(66476007)(66556008)(6916009)(2906002)(55016002)(66946007)(316002)(6666004)(186003)(16526019)(478600001)(8936002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 59+VrRaN6YiE8FOnX1BRwFOMAhQ1H5LPuc+V3neLUoal4kxvp1Vb9Eeo5aCxG2M2reNDKI3TxDCMPqiR3I4p0PBl+KyVPn8Eqv6adgJ76y3CkUSVdn5xJCtknMUsrlPh7AyTbCUZcOlfXT7q3HwsZcu8m5TnonypICJ1jo5BjqBo9U21gd+5M0NDmyR8if0rq0u4uLBFf6QtHUGh297gQ9sbpIXqcZSlVHLSa06O3vQykCrFoxUa2WchExuVtJ+BUcAkemMh6CcXkIPTWxwK1I/+XtvfT+luuD5wBujYREaZigFf55KgmirPtBUo69jsv3qHr/959oM4lwiCsnpZzNsWq2hsFuwOoh51YHwxVyOh3JNh+EwKOquTyKA4BPUzY5A1vpzfEZoZSkPdeZ9rYyERfIMO1TuHSkhgB6nPRSNRWGAn978xQM0Pey3+IACvcwZvHURJK24BvpXOnGuiTsqtElsQ78YuTOfGje5PP6iYBucj3hLaM0olDUm4ZaRZXoMToqBhvguRZPstk4MAMQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: f0248e60-2ab7-4eb1-dfc3-08d8342948fd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 01:38:40.0833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qISZIKmAjFvHaE997ktQDMS26nMVhzBJLLJVs+ALLRnhQtMmm1OdITFwJhkLLl3Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3398
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_01:2020-07-29,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0 impostorscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007300009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 10:59:33PM -0700, Andrii Nakryiko wrote:
> On Mon, Jul 27, 2020 at 4:15 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Mon, Jul 27, 2020 at 03:05:11PM -0700, Andrii Nakryiko wrote:
> > > On Mon, Jul 27, 2020 at 12:21 PM Roman Gushchin <guro@fb.com> wrote:
> > > >
> > > > As bpf is not using memlock rlimit for memory accounting anymore,
> > > > let's remove the related code from libbpf.
> > > >
> > > > Bpf operations can't fail because of exceeding the limit anymore.
> > > >
> > >
> > > They can't in the newest kernel, but libbpf will keep working and
> > > supporting old kernels for a very long time now. So please don't
> > > remove any of this.
> >
> > Yeah, good point, agree.
> > So we just can drop this patch from the series, no other changes
> > are needed.
> >
> > >
> > > But it would be nice to add a detection of whether kernel needs a
> > > RLIMIT_MEMLOCK bump or not. Is there some simple and reliable way to
> > > detect this from user-space?

Btw, do you mean we should add a new function to the libbpf API?
Or just extend pr_perm_msg() to skip guessing on new kernels?

The problem with the latter one is that it's called on a failed attempt
to create a map, so unlikely we'll be able to create a new one just to test
for the "memlock" value. But it also raises a question what should we do
if the creation of this temporarily map fails? Assume the old kernel and
bump the limit?
Idk, maybe it's better to just leave the userspace code as it is for some time.

Thanks!
