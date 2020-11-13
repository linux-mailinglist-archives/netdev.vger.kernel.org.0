Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC722B24B8
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 20:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgKMTkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 14:40:53 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5274 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726302AbgKMTkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 14:40:53 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADJeONv013263;
        Fri, 13 Nov 2020 11:40:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=w6Q5FuocmmwEJQsv7kWow1sKfM5WGTsFWrbqZi9E3Tk=;
 b=chLSxICNSVoMVYo2kPo3X3roPu/+O727MzrLLtYplnt5ke3kxpLQUX3cJrQJIcp+Sxfn
 rBcK7WpEPTrZGOX7gMkBxBbYgwpM21Mezm1YtWnIpuxRF3Pb08IzRkk7IzPU1pV/R734
 TwxjQPSRN2YWYpBhrVzPL8F4RNgIb6lTJ0Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34seqn4wx6-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Nov 2020 11:40:34 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 13 Nov 2020 11:40:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sp6UWnlLJB0+/TL2/QQmrPDenaegScRCSgE685Q1PjCAS8NbJ4efhrfD3xxnx6Jxiy5U3/p6QgasFE7PViQA7PFER5qlfjF7rWa5hEJYwf2sFvFmW+rYBbfWGoWJAV0HCRb2c9wTSq18jRxdRPE1c9uSS0Tx0hxGvDG4RJyIAw6o//Vl4EVXIeXMkO3EKZ6NuePs0dYOw+M3K3LhvaOm38T2hTryIljn0z5SqPnggmFFzTRhEVR8wJ13byL9iHHuW8atirta22m9RtQXqAEYOBN2O/SiQWLHec6aljvI/NZlXUSoK6Bd1eZ61Hf1LemQZ3zjhp4273ghcd++by5jwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w6Q5FuocmmwEJQsv7kWow1sKfM5WGTsFWrbqZi9E3Tk=;
 b=IIzEVu80PYApbMPnp/5O2djTMe6+txhlFGgw/ImQCCU4Wl2MXfaZEbb7jqsfXkxucLU+pP7ZxwY+irP1evnuTApvAc6FDTlE7If8ygH0J+0/Xr4uxV8jOhPnLxvNe4GzdQ8y72LeBKTkWsPGSWJxnWVdmds+incBF45hNC1L+BesnKyxnm020SwS5MzSYsRPuHiCilMh6u6uSgNgZKp78/Jzn/glEZFZo6Ors9G0M3JRnjQeTR1Yzb3SVIX+9Rm5dYx0e0QPmUyUVjU8I+i+d6y5OEmVC8zyagdODekrDOE9ghBhFOz3ZF3XN6vfUyFAreGPFuy7QBDr6pCWnddCcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w6Q5FuocmmwEJQsv7kWow1sKfM5WGTsFWrbqZi9E3Tk=;
 b=IYxPODSxZO9EwU10N5k4MwAsS+uBRVda67JgqA08AknJ2Q2STALDiOTtwDFI4RDo91YzAQnXFPfAxHsQWK+v7OOqA/oCiC5YvT9Ps0BXoK5uaJx1w+Ga3FMI3/roKHCY3II7vQcPxZ6kmE/4i5nGO4C7OVA1UMcAhH4BA6mWjgQ=
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14) by SN6PR1501MB2191.namprd15.prod.outlook.com
 (2603:10b6:805:10::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Fri, 13 Nov
 2020 19:40:28 +0000
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::f966:8c42:dcc0:7d96]) by SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::f966:8c42:dcc0:7d96%5]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 19:40:28 +0000
Date:   Fri, 13 Nov 2020 11:40:23 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Song Liu <songliubraving@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v5 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
Message-ID: <20201113194023.GD2955309@carbon.dhcp.thefacebook.com>
References: <20201112221543.3621014-1-guro@fb.com>
 <20201112221543.3621014-7-guro@fb.com>
 <3645417A-F356-4422-B336-874DFEB74014@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3645417A-F356-4422-B336-874DFEB74014@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:7f67]
X-ClientProxiedBy: MW3PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:303:2b::7) To SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:7f67) by MW3PR05CA0002.namprd05.prod.outlook.com (2603:10b6:303:2b::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.21 via Frontend Transport; Fri, 13 Nov 2020 19:40:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 203f1137-de98-45a2-29c3-08d8880bf989
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2191:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR1501MB21910B15AACB5547BBC5FA4FBEE60@SN6PR1501MB2191.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7jkAdyQJkdw1g4u2x69WMvFQCgs7HQq1ip340aTshc9RqCBuv8shuaxM7DrJ0nPxnFi61Qrd11CMvjW09Cf3tRU5L49Li8MdzxnNSvMl8PQozL0nv0WZoAD7rymvgwXabEU/8e4LU30Dz/Fq11IUiYIakLtRP3zbEwLjwpcX3CVcg0OFfY9FS+YFd7ZaS4R0MDPK8ehLtMU9xtLNbkJTSsqw2HAwev7HQFqj8/2znUdZE9i6LfZlIjYN7PxueX5VmBXbUOHZFe2g4ZS9mw5SP+mVX1/hQR2f8+gtXwKse0h2N0Xp2hByHI676A8rdhflenrVPaCqyX6fIuD/lGDIIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB4141.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(346002)(396003)(366004)(316002)(2906002)(5660300002)(8936002)(33656002)(1076003)(7696005)(86362001)(83380400001)(478600001)(4326008)(186003)(6666004)(66476007)(15650500001)(52116002)(16526019)(66556008)(53546011)(9686003)(66946007)(54906003)(6862004)(8676002)(6506007)(6636002)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 2pVpyIhaje3+MvT997ltrAUnjR1Ut5brQ7MbyKPHX2tiv8WIVR1+wfsFGxIREYE0jGh9FcM1p0CQc0D4mzdjNTs2y667Wk+H2ZT/6lCkQMxWPIbc432DH835mBj2L2D7AruPo7eba+FpTBz2V7cYfCCv3rnXMLduLBxEyF/gNPsrjJlRh8RgKH/Ibiznx4G/rEaB5UnrZLdxrQNxmVHO9I26SKLetcvzQmsh6AvsYBIkxx1WGftiH40zO9u5C7Rtpn9ftKdwlNdtITIlqJSykT5NvgllnumX2CpwC1GvYf5uR7Y3mPDXR/OrOUhCpRuNKNWqmRhMVylorYEdt4xVpTi9f2J2imJPrNntNaA0XUWHW6/k2hllukHRixd+3y52jXS1kl/8GYdOCZATPpmnLn0DKfDl13D24+CONcfbXDSpX/BWmFDI62Fsy9ZkmxvXualcfj734wakOb/vx5wErZcMfMWhwhX5/IRxhiO7OO6fbfK8++MR++CF5D+Nhw3bPSWs9bvjx+p6lCS2weMqsMLh+7unysR259dNGyFwnNtpV1oGRZ2tH9ILw1tERkKVUAAdiQcl5AOp/kefKGYKb+zodMwjhhmjNxDb05Sn/Wp6vlq4mI+ycWe0VDCKgjqwCLuv9nUYHSEFTn813fZWxTr2PIvTBrDZ30H5zzsg7blw9ttzuxu1K6tWEC2mOEGBpgL/mPi+pNhVA3eJoh0u6eCW3EHrAYRaa9RFa1vposgrcVMaLyA3SvdHtbT2fkkcpO1RYp46GCoN/QZTVWoDW/wbGPLO92f9MgR2WyzwjkAqQVi3rngnlyZKOeMdVmj+ztzd0gHCq3xk0vZ5QgwewP47yD+Dm7I6UiWyaLzBc2SYptThGMnQWgJi3ilecoWb0sieNsiQnQ03SfEEZD61isIvw/HCKlLwMkEYO7v4WSk=
X-MS-Exchange-CrossTenant-Network-Message-Id: 203f1137-de98-45a2-29c3-08d8880bf989
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB4141.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 19:40:28.7018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZmVz8xg1eM5zjwiVgLLsMth3752goZiIn0FUovRr2s9TBpS/XySnv+d+29NCRAc4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2191
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_17:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=798
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 adultscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=1 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011130127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 09:46:49AM -0800, Song Liu wrote:
> 
> 
> > On Nov 12, 2020, at 2:15 PM, Roman Gushchin <guro@fb.com> wrote:
> 
> [...]
> 
> > 
> > +#ifdef CONFIG_MEMCG_KMEM
> > +static __always_inline int __bpf_map_update_elem(struct bpf_map *map, void *key,
> > +						 void *value, u64 flags)
> > +{
> > +	struct mem_cgroup *old_memcg;
> > +	bool in_interrupt;
> > +	int ret;
> > +
> > +	/*
> > +	 * If update from an interrupt context results in a memory allocation,
> > +	 * the memory cgroup to charge can't be determined from the context
> > +	 * of the current task. Instead, we charge the memory cgroup, which
> > +	 * contained a process created the map.
> > +	 */
> > +	in_interrupt = in_interrupt();
> > +	if (in_interrupt)
> > +		old_memcg = set_active_memcg(map->memcg);
> 
> set_active_memcg() checks in_interrupt() again. Maybe we can introduce another
> helper to avoid checking it twice? Something like
> 
> static inline struct mem_cgroup *
> set_active_memcg_int(struct mem_cgroup *memcg)
> {
>         struct mem_cgroup *old;
> 
>         old = this_cpu_read(int_active_memcg);
>         this_cpu_write(int_active_memcg, memcg);
>         return old;
> }

Yeah, it's a good idea!

in_interrupt() check is very cheap (like checking some bits in a per-cpu variable),
so I don't think there will be any measurable difference. So I suggest to implement
it later as an enhancement on top (maybe in the next merge window), to avoid an another
delay. Otherwise I'll need to send a patch to mm@, wait for reviews and an inclusion
into the mm tree, etc). Does it work for you?

Thanks!
