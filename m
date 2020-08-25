Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB7925239C
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 00:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgHYW1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 18:27:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43086 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbgHYW06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 18:26:58 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07PMOjYb012906;
        Tue, 25 Aug 2020 15:26:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=XeRyep22Ji2ZspBnPkAapx/Bl8aktPUZImhutt//y/8=;
 b=aMQvvgHI7xNWjxHFm3kPKhC7DCxw9WXuihDvg5zbKonyMYjZmK9YCfmLTEKL/4sBMVQe
 kJSMvAv0VTiZ3YsQKfQfQ6dGT0VTXeAGqEMbtOOseP0eGTAH5XInyciAN/HI+1zBPdbB
 7tD6+0dQDOjvwgHiHsw9TEepQdZKkkCC02M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 333k6k5us4-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 25 Aug 2020 15:26:38 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 25 Aug 2020 15:26:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OM7tQfOMC+zpfqheqLfk/eNZng/XiTBBivp5MS0PfCzLAF6RQNuWUbClJcdMa1VfDOnPBHgDXCyMgeOCut9xgFhFaQV8GIOB//BHWDDVq+LYHPxeYKnXuOIcVayJZJ5mK5sWz8PaXorQp1s2vACxfqwB/YRtSL9r60B20YxxGa+SdbWOnK6wX219Lpdr8dxupqEC7i4rQ71vsuawMaHwHawHyT/xcfjktjpBDCcb5+Of6snqVm/to6AW9pmAS8hqvW5CMKe/lF9RTN0OSanizD2NJfHC1tjZwhsIrM7YpjVh7TPRgtBM6HYYBzXKqHwDikGPxt+Wwn0KsAR1heS+kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XeRyep22Ji2ZspBnPkAapx/Bl8aktPUZImhutt//y/8=;
 b=A0SM+7L/Hdd3gyr0zXCIOjkfqnkM1fk3yd442lsQLwrPBfC1TmOtn2VZK5mIp46jMPpO+gHOxlbqRlBdcq2UYm8U22HhFbGPtqvusXzDWV7yYdyvhhImIyw7GuFWDu2DViY1JPubSjzaofaZVRjaSxE3lxIYoOB9pft4cE1E/jcbNGfKnyxh/LyjN+PiTd117Dz1kfy07PhWr0Ns1KYEUIl3t0QRbS/OSSM2FY3siqC2Np7BDmn3a8guy2u5U0pp4i5QCp4T+CKf+P8DychhbNQbSv7izx36kPXW2UbvT3nblFE8sfgjcLnn6yCVidZhYyPp5kax+qq2bujyHTK8eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XeRyep22Ji2ZspBnPkAapx/Bl8aktPUZImhutt//y/8=;
 b=B6i6uJmlhuOEhhnVMf4guI3rWq4MDoErEeTH4GNxUiN59hRWsyDuXY1rRkQ8SoqlgSvI5XthtJT1lDu9lqVDFEqvLptjJQ2HqKD+fPRxuBCtNGiWSrFc6EIbSLtSz4RyRRkLzM+YD3/nXAkEGswgoDDaDANRxh1XcbctgxJSJDk=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14) by SN6PR1501MB2191.namprd15.prod.outlook.com
 (2603:10b6:805:10::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Tue, 25 Aug
 2020 22:26:33 +0000
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::e1a8:24c:73df:fe9a]) by SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::e1a8:24c:73df:fe9a%7]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 22:26:33 +0000
Date:   Tue, 25 Aug 2020 15:26:28 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH bpf-next v4 02/30] bpf: memcg-based memory accounting for
 bpf progs
Message-ID: <20200825222628.GD2250889@carbon.dhcp.thefacebook.com>
References: <20200821150134.2581465-1-guro@fb.com>
 <20200821150134.2581465-3-guro@fb.com>
 <CALvZod625bjHHpDUVYXCZ1hCqyVy133g5cSv2+bhTK_9YfR6KA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod625bjHHpDUVYXCZ1hCqyVy133g5cSv2+bhTK_9YfR6KA@mail.gmail.com>
X-ClientProxiedBy: BYAPR07CA0105.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::46) To SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BYAPR07CA0105.namprd07.prod.outlook.com (2603:10b6:a03:12b::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Tue, 25 Aug 2020 22:26:31 +0000
X-Originating-IP: [2620:10d:c090:400::5:551c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 539ae2cd-6168-4cce-e1fc-08d84945eb8c
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2191:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR1501MB21918F93F7E8B8BFEA2D6BCFBE570@SN6PR1501MB2191.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FJADUdL8y507b1Z9kU4AIyTu4hVLulAEQ23oSs8vFA+3Iuujcg0p1G3gEvybJCj3Q1xxrg+ei8j125EqehS2eItBwfGDC00pnm5RS+n97Pwo2c7z3duLNTtZanMQC3qQ0vY8Ha/z3i/IamThs9ZKvcBn997hwAt3H6y917XRePz/hw//Up80uYDl24xR/Z4FkhzN4tfXssG5nOuquqhxipkxpUnr1Bd/e8YDPpOy0XdeynXFxx1Qa8G9EEdSGH4sq+B3+FEpC2HgUdqEBHzSNqZ6xA346wg4rz0ec8/HkofYRH5X3Fs8Sryq5FGZSvl8PlAXRee5NkLe6wuToI1JgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB4141.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(396003)(366004)(136003)(376002)(316002)(66946007)(33656002)(54906003)(6486002)(6666004)(956004)(83380400001)(9686003)(52116002)(16576012)(8936002)(53546011)(6916009)(5660300002)(2906002)(15650500001)(186003)(478600001)(1076003)(86362001)(8676002)(4326008)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: DB4TT85H/YEFHk7IfijxWYOHEAP6FCoO8HfHqLoViGxFqeigaGnAXfZCae6NOOVWneWO+QQEjncaY3avSXoUNTqyYCI41B+92Cn4tGGEYaxwmdDicUwnZMENuK9N058QBK0nvIzGso7nd8/ZcI/dRbW45nAa46pWo6yvEPNOc/vtx/ZSr04jI5tGA61SlCkUP2pW7aT8DfiRiyoMUSybDng8TsKp028xx3H0ToNKKDG7Nhkur9/zLPSJh6yB1hhtxpGzdN7kqgL9LTYdWzduRgvQSMNWh8pmc5dBC8rxO834zOpC1kYVacFsDTrvmuHhHzVffQlaPDQC2GacK2K5txaYHDBWwFv2R2miSNZwfWZljBzuao1jfZiz79LhuFL6wNhzLEcvaCMHspsJJP2lyEac+OYTf85jCMr1C2RAux6bSQOmzHF4f/sq/KaFc/Mr3IZfXUqc42XIpvjjHnpDAptzuxZT/vEI9q0IR88eGOGL+GYyrSuwDgkpuEweirUb7hu1rhkb9a5F7vMgw1BgUQ8RhIm/hyyDa9WCH88AIFKcRBSWx56vDY5i+2M8rApu4TNGAI6M509RiS+QNgvsGp3Y3i2Ri/qPB/OM3TmFVzNPTtfrB6D//9jCUTHLnrp2jsneWQDdz/crnVAvkDlINZT6QS8o0RmZKxoCHg/VQ1M=
X-MS-Exchange-CrossTenant-Network-Message-Id: 539ae2cd-6168-4cce-e1fc-08d84945eb8c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB4141.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 22:26:33.0822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BABPflTf8rGeu3rjrlUdU7DZLKsUyvqRTZ+Sw/dtnTBEHarBJuNmraMhDd+XoWav
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2191
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-25_10:2020-08-25,2020-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 spamscore=0
 mlxlogscore=986 phishscore=0 adultscore=0 mlxscore=0 impostorscore=0
 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250167
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 12:00:15PM -0700, Shakeel Butt wrote:
> On Fri, Aug 21, 2020 at 8:01 AM Roman Gushchin <guro@fb.com> wrote:
> >
> > Include memory used by bpf programs into the memcg-based accounting.
> > This includes the memory used by programs itself, auxiliary data
> > and statistics.
> >
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > ---
> >  kernel/bpf/core.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index ed0b3578867c..021fff2df81b 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -77,7 +77,7 @@ void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, uns
> >
> >  struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flags)
> >  {
> > -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
> > +       gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
> >         struct bpf_prog_aux *aux;
> >         struct bpf_prog *fp;
> >
> > @@ -86,7 +86,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
> >         if (fp == NULL)
> >                 return NULL;
> >
> > -       aux = kzalloc(sizeof(*aux), GFP_KERNEL | gfp_extra_flags);
> > +       aux = kzalloc(sizeof(*aux), GFP_KERNEL_ACCOUNT | gfp_extra_flags);
> >         if (aux == NULL) {
> >                 vfree(fp);
> >                 return NULL;
> > @@ -104,7 +104,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
> >
> >  struct bpf_prog *bpf_prog_alloc(unsigned int size, gfp_t gfp_extra_flags)
> >  {
> > -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
> > +       gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
> >         struct bpf_prog *prog;
> >         int cpu;
> >
> > @@ -217,7 +217,7 @@ void bpf_prog_free_linfo(struct bpf_prog *prog)
> >  struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
> >                                   gfp_t gfp_extra_flags)
> >  {
> > -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
> > +       gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
> >         struct bpf_prog *fp;
> >         u32 pages, delta;
> >         int ret;
> > --
> > 2.26.2
> >
> 
> What about prog->aux->jited_linfo in bpf_prog_alloc_jited_linfo()?

I tried to approximately match the existing accounting, so didn't include this one.
But I agree, this is a good candidate for the inclusion. Will add in v5.

Thanks!
