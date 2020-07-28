Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0105231235
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732614AbgG1TJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:09:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38532 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728978AbgG1TJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 15:09:19 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06SJ8Q8L008826;
        Tue, 28 Jul 2020 12:09:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=RqMH5FgmY1F/t9obTYlspT62XZJDOpDJ7tAbgJXsE8I=;
 b=EWGZyPdqCZ288D9C+LBN0g3QYTdz2AAiK0zbN41++kEwGHwSSINgY9Ktc1Tz50ZaGvlU
 3x+6o0Hvy4AAgiJoFOxfYwdfct+OmYpQz0rXtZJLSLvQDBUIP3P1+UgV45cSbcMK97nH
 f4NN5LpR1V+HbGFc24dTtqDAeQ8m1BxJj4Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4qs39m6-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Jul 2020 12:09:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 28 Jul 2020 12:08:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2EtBXBqVDku3F9PZMVxlTs0jSplPO35UQQbHW5oMS6eIImcQUR4X0mRRknSMkSSwr3jyffT0LzqgebqStemvonu1kzODtRvBoPoe/QE7goiYi7MdnCsr4Qrk5uIixmreFIlca9yOdQjpEIy/gAAY5vPTUqqWOEx/A39/1LWW9XI+WZJPtNpHRD1H0WQfhBu05I3wLlDyEXaVhIClYcPjxoM0aeV1bKJWvZjbE/nktQp+h8pkS21ESafMy8NRI0lgRxEUVbasHHfb3y/cePAGr8syT3aH0rtF5INna30IcorhzcJM3A8xrESHYy+2b4u0+aTow0U/5g1OnYKbUhHMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqMH5FgmY1F/t9obTYlspT62XZJDOpDJ7tAbgJXsE8I=;
 b=aMIaDPl7AJ5Cak3slndsKcK6Xk/Z8vLsKl4Scvsy0SlhxN0lBLPqheCYusQwWvwamvraVfFfBbuhEVHj9WtYiCOU0G3ZXVDWY1Pp/AEzTBfU+2KgR2tT7yyoHfBRKGKtfht6SxyvkSu66bPYV0PDsnKV4SOpC/CSztNXVzS8XfvkbJYYrWmjsSmEit5HK94Spg/II7/5FNgN1cuwG9wFPASQWw8t/CAhK+NZmRVKpWtFqfijq2dcwbje9qbtf6NB9RJNd5wWy+wAuITsrc01xHl8ySTI96yEKfKK35tnrp522/PipdWwjv99zK3mLXkxuPmWVf+Bhh9adYEQqqDFEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqMH5FgmY1F/t9obTYlspT62XZJDOpDJ7tAbgJXsE8I=;
 b=E0163DWEfW7rBl0g66VNN/c1d1xYnCDJpW3SKsl+cEniDM3y+tKtp46lMmmbkR1D++8K8sp4fMwnkaslSVa0SHYxMwjqKCzP1yxkvEJsqOK3+kNibEdb9VCOdHFSLHZS4MawKT+jSei/9aqs8/lE0u9z8pli4U3DbwPanSlancw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3128.namprd15.prod.outlook.com (2603:10b6:a03:b3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 19:08:33 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1%5]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 19:08:33 +0000
Date:   Tue, 28 Jul 2020 12:08:30 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Song Liu <song@kernel.org>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 27/35] bpf: eliminate rlimit-based memory
 accounting infra for bpf maps
Message-ID: <20200728190830.GB410810@carbon.DHCP.thefacebook.com>
References: <20200727184506.2279656-1-guro@fb.com>
 <20200727184506.2279656-28-guro@fb.com>
 <CAPhsuW7jWztOVeeiRNBRK4JC_MS41qUSxzEDMywb-6=Don-ndA@mail.gmail.com>
 <CAEf4BzaOX_gc8F20xrHxiKFxYbwULK130m1A49rnMoT7T74T3Q@mail.gmail.com>
 <CAPhsuW5qBxWibkYMAvS0s6yLj-gijHqy9rVxSWCk5Xr+bXqtJg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW5qBxWibkYMAvS0s6yLj-gijHqy9rVxSWCk5Xr+bXqtJg@mail.gmail.com>
X-ClientProxiedBy: BYAPR07CA0059.namprd07.prod.outlook.com
 (2603:10b6:a03:60::36) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:19ed) by BYAPR07CA0059.namprd07.prod.outlook.com (2603:10b6:a03:60::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 19:08:32 +0000
X-Originating-IP: [2620:10d:c090:400::5:19ed]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b9afbfc-294f-4c1e-b02b-08d833299f0d
X-MS-TrafficTypeDiagnostic: BYAPR15MB3128:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB31288F6B7DA0CFA2462A5EF7BE730@BYAPR15MB3128.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nBdzl0adiZf9YJRu1a4G81jIs//5LaJn4L9us2enTXYytkXZfVOS24rKZMJxyo+fnab72BpLPHkM4vFq/e4nZfmBFW4NVi5XhyHaUUMYXiNQQZsOpJfhVBCCUUvJPVY8CTMEr8nB8NMifjKazz490P4JAHBBXK+5cW6dEW5XNEgNHAkNfoSVV/6kjXpl/3M9mf6iAPsqT47/ll4HHhtdeFcFnv/Rj0gs3Koz6wUxgwnEkxMUIKsS3a3tqCrDY0lcJ0Gc0mdmkGrVRO5+Wb29gbVGmeAhHWftYKJm4NauOyE0mbP521CCiv9KheV4zyNnUDxdcvpTA0Glt+95mof+jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(396003)(366004)(136003)(39860400002)(316002)(33656002)(2906002)(83380400001)(4326008)(7696005)(54906003)(53546011)(52116002)(15650500001)(16526019)(186003)(6506007)(478600001)(5660300002)(86362001)(66946007)(66556008)(6916009)(1076003)(66476007)(9686003)(8936002)(8676002)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: wowWe5JNXetmYsc0FRyMdagGQyKJeCjmgZ7gr9D7i6VEPh85vfFVMMq5wlPxnXLWx/k8T7XjzE5/b+j2beUiIAeyVgFi7vzO2O7Hjr5eU7syDdpXA31OWCOYPupJY65ECVkM78IRlIraqUp/fw5P+Rzip++liguqELEl4utADVFBIJHtQL2FbQPcKpwbDnIaxUYFSPWz2fH93EyhXTSAbAvFQ5lVOOeYTWOEwgSG6tPal39vyc0s3Oom5Afoz27Olg53coN4z6hN6M0PyRG/4H74vxOwkVe7dFvuaI8Bip6/sDA1Wn6CVPiOU5Fkv5dO+nygHL7/1yTI5vxRSUNuyC4P3+Js/3BhqUXrJQ3KZR61ZLn8cFTrkOxqiEBE56a4R5ruQ2ewx+rXa3ifSWa4hPQkJ01ueDnFiER/NXBMUFknxEoITbNlM29WoAgp6ze0UZQpmfYdm/IYIlg5QKFf5eyK5bEQCuJ4KXE7uzTnIwdrOQzYQKT63zHBPHQQpqD3PIiwRCRcs6H4X7rWSqHvcg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b9afbfc-294f-4c1e-b02b-08d833299f0d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 19:08:32.9114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VET0SkMlTt/ZSnDAz0ndkJR8ChS/WgUdrzD7JmnRlLacP3vs49pvPRMtaUTzbZOX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3128
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_15:2020-07-28,2020-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=1 malwarescore=0
 clxscore=1011 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007280136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 11:06:42PM -0700, Song Liu wrote:
> On Mon, Jul 27, 2020 at 10:58 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Jul 27, 2020 at 10:47 PM Song Liu <song@kernel.org> wrote:
> > >
> > > On Mon, Jul 27, 2020 at 12:26 PM Roman Gushchin <guro@fb.com> wrote:
> > > >
> > > > Remove rlimit-based accounting infrastructure code, which is not used
> > > > anymore.
> > > >
> > > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > [...]
> > > >
> > > >  static void bpf_map_put_uref(struct bpf_map *map)
> > > > @@ -541,7 +484,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
> > > >                    "value_size:\t%u\n"
> > > >                    "max_entries:\t%u\n"
> > > >                    "map_flags:\t%#x\n"
> > > > -                  "memlock:\t%llu\n"
> > > > +                  "memlock:\t%llu\n" /* deprecated */
> > >
> > > I am not sure whether we can deprecate this one.. How difficult is it
> > > to keep this statistics?
> > >
> >
> > It's factually correct now, that BPF map doesn't use any memlock memory, no?

Right.

> 
> I am not sure whether memlock really means memlock for all users... I bet there
> are users who use memlock to check total memory used by the map.

But this is just the part of struct bpf_map, so I agree with Andrii,
it's a safe check.

> 
> >
> > This is actually one way to detect whether RLIMIT_MEMLOCK is necessary
> > or not: create a small map, check if it's fdinfo has memlock: 0 or not
> > :)
> 
> If we do show memlock=0, this is a good check...

The only question I have if it's worth checking at all? Bumping the rlimit
is a way cheaper operation than creating a temporarily map and checking its
properties.

So is there any win in comparison to just leaving the userspace code* as it is
for now?

* except runqslower and samples
