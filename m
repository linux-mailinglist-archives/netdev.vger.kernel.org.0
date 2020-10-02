Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E14E281E88
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgJBWlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:41:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7710 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbgJBWlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:41:10 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092MeMTt004780;
        Fri, 2 Oct 2020 15:40:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=wgYkSypn3L4Is+yo3Jtwi8DIfDtnr8iLvKo4C008ceA=;
 b=CdcZj3tSrz90LMTvq1W0sSPMfd4WHbKozlzKJQXqbNdOQrYdDs8aWzVzzo7MautkC3wo
 3+khmgcEsv/ej+gi/fVfyHnvTdGIh+xgIBfVGcYHa+mwH74x5xF3BmBJA8MsHe/2700N
 cClrA0v5xbBC9AAw55Uy0Xu5t8Ln+sx/vfo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33x6gua9ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 02 Oct 2020 15:40:52 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 2 Oct 2020 15:40:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kbraSe/2w7u6XHfKDjYwb8oZWwBKMhJywIEWzNqWohOoEm2I/M7g26irKA4pWoFlZ2O2idEeT1TJ0lL2LYAyfXIc9mo3KHzKusWl8qNct/eUPkhogEWo0hSdjH0vJEosUq2pGdax4UIl06RVG4C2bzLF+Z7RSXSHlRm7nkqzdGlg+IU4NA/3cejKxyA8LmcP3BQX3EDbpWFwwg6qLq1ypKdQmLtsQKQw3WeliyPlJBJYl/NFNczdWAqH9ociK1pQDh5qSvug/fnQ14BXOv+Wn+Ag1SwlO79XZ7jPtrt8bLlk09Qrq1hQsBy0HoFJocPsuuxBGchHg5A02bRKkSvyRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgYkSypn3L4Is+yo3Jtwi8DIfDtnr8iLvKo4C008ceA=;
 b=nxMbIsyhAStzcm+7kHhJDp0J0enqHLC1JXQRC1IObE12fQ7Efq4MU6rdzwfVgXYzh1HdZgJw6Ac/JIZ+rSTzc9vpFM2gTfnlgm+Dzpj9xVlWOtlVxmk9eHWmEJMcWoDT8A34upwpusiFUJ5VZtBIb8iESWH+JjWXmXlLjamtPFrpbu73u3C5WjWYCMylyZljivRSnSqBiFXoq3tATfdYRdq++T2HHebj1oro9tFhUUZfKjTbkIj6VGjNh1o/KTHTPmzaq3uUbeyaJ1t4gJ5fAGbqKUbgV8KjotUCD5UoE5es64owDLuEXiz9e9HGsQMqSPqs9w3R0ZiWFgnBa+vq3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgYkSypn3L4Is+yo3Jtwi8DIfDtnr8iLvKo4C008ceA=;
 b=gF0+rRaksSEwdy5x/tU7DxGbsWQkGndRhp1qpDI5C9lF3CFfvunAaR2KJtkDWtiSk1N7Z0Y882uEFd9B9vM32HvHFXbj4qN8n8OUD7KMSH3CJzMw/Hte0tPrrHYvb4hB8U18zxEWgoxWF05BKM5R3s2CYKiPY68X9gGUdSU9NDc=
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3192.namprd15.prod.outlook.com (2603:10b6:a03:10f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Fri, 2 Oct
 2020 22:40:34 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Fri, 2 Oct 2020
 22:40:34 +0000
Date:   Fri, 2 Oct 2020 15:40:27 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Song Liu <songliubraving@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next] bpf: use raw_spin_trylock() for
 pcpu_freelist_push/pop in NMI
Message-ID: <20201002224012.kafu4edg2bz6x2x6@kafai-mbp.dhcp.thefacebook.com>
References: <20200926000756.893078-1-songliubraving@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926000756.893078-1-songliubraving@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:a8b0]
X-ClientProxiedBy: CO2PR04CA0152.namprd04.prod.outlook.com (2603:10b6:104::30)
 To BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:a8b0) by CO2PR04CA0152.namprd04.prod.outlook.com (2603:10b6:104::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 2 Oct 2020 22:40:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2609ee6-60f9-4435-eb84-08d867242cb0
X-MS-TrafficTypeDiagnostic: BYAPR15MB3192:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3192EAC70077146E9A8FEACFD5310@BYAPR15MB3192.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nv0blf9DNZbah7vtmrL/hl7RU0NDtyTYaw/fjnFia3ENQ7RAoid4SVRtKCDWOfllSpjKxgSxu6s4ZIIiI6zx/NHCyEHM8YuT342BpGP2soAfA1CC6wFsyJkuOZVlzUuciWmAcVVO47R8rpbtAK5gxmSR9DO2upyvxlZ02J352L8JSz1E4MVfmCSE8ztA9uUTVPm7EzgJ6BqbR9edqgG9ZehxN2PstMvWRQ/E1rTi5cQKFAWZHWaFBU0DjZCJkk/R7saOQAvbWe5SpAUPNHAlppdTJibirz43Gse2atEDfBOpcyJ11LnZtVfhh2Q+p/q+HWDEBz9XzbHhKSnH+b4GPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(366004)(376002)(346002)(55016002)(52116002)(7696005)(8936002)(9686003)(2906002)(16526019)(186003)(1076003)(66476007)(478600001)(316002)(6506007)(6636002)(8676002)(86362001)(66556008)(66946007)(4326008)(83380400001)(6666004)(6862004)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: tnxH5bSoS5KHCxX3yVlm1/hmMPROpFJxf+npqSGdwgdEmPuXiXhauo/RrQFCo8SFWFoS5aoIYg5hyqm/Bp9C7h3m86SRzUZ/wgfBYnflS1ZUKpSEXh6CbiFjCGvTWfdt0X91UHgG8TPgi3Xrqkib24RISZ4ZQCZ98yK+qcugHTAhjSBQB7aIfLFJiqOHxT6rIXNsVD3mg8TMgq++AP9STeP1b7BieNWTgiD5HnkTmp8VFUScxFw/VrixrznR+wOEcu4bbOCq05lzb48L9e71mxLC6hyoXUB2yxYkMIfO2q4dd9L9U4xqQ44rdoDwWjoSSR5bP3u9NT/gujZX1ym1q70/ABZ0v2Q45LHdWPLrjnmylfedAQiqQMfZD17cDAwNLaOJ7+9USSYOVEnZj9gUB4iNjiqgjoyK9MYPwuSgCFJQph8l73y8X+FUe0mue1siEyddpp7OvwPJnrGy62kXX0saSjdMWT+j2tYnNyclReNB2f3sUAYQq0FJS6cnNnShD83nPdoLj2JUe2ATFnGJjoZHoOmsmn/B3fyNZdCrE0jSPU/38UBfrgp/amUzhwc62ilq7SZaKpCuLoAO7EoAeYg6ez+H7HYI4i2t5NM9C0K95CH8D20VPMvt4fPjV7w1RzRPzo/jvZdyB8Ubi/7T3kycBiorSzaGXMDnPML+nBQ=
X-MS-Exchange-CrossTenant-Network-Message-Id: d2609ee6-60f9-4435-eb84-08d867242cb0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 22:40:34.2249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fnv3G0CiR4mlBpzvO143cytCEKEgo8pvyp+5P9z2F7MeLN7B428um6T0plNoa1Dr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3192
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 suspectscore=1 phishscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2010020173
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 05:07:56PM -0700, Song Liu wrote:
> Recent improvements in LOCKDEP highlighted a potential A-A deadlock with
> pcpu_freelist in NMI:
> 
> ./tools/testing/selftests/bpf/test_progs -t stacktrace_build_id_nmi
> 
> [   18.984807] ================================
> [   18.984807] WARNING: inconsistent lock state
> [   18.984808] 5.9.0-rc6-01771-g1466de1330e1 #2967 Not tainted
> [   18.984809] --------------------------------
> [   18.984809] inconsistent {INITIAL USE} -> {IN-NMI} usage.
> [   18.984810] test_progs/1990 [HC2[2]:SC0[0]:HE0:SE1] takes:
> [   18.984810] ffffe8ffffc219c0 (&head->lock){....}-{2:2}, at:
> __pcpu_freelist_pop+0xe3/0x180
> [   18.984813] {INITIAL USE} state was registered at:
> [   18.984814]   lock_acquire+0x175/0x7c0
> [   18.984814]   _raw_spin_lock+0x2c/0x40
> [   18.984815]   __pcpu_freelist_pop+0xe3/0x180
> [   18.984815]   pcpu_freelist_pop+0x31/0x40
> [   18.984816]   htab_map_alloc+0xbbf/0xf40
> [   18.984816]   __do_sys_bpf+0x5aa/0x3ed0
> [   18.984817]   do_syscall_64+0x2d/0x40
> [   18.984818]   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   18.984818] irq event stamp: 12
> [ ... ]
> [   18.984822] other info that might help us debug this:
> [   18.984823]  Possible unsafe locking scenario:
> [   18.984823]
> [   18.984824]        CPU0
> [   18.984824]        ----
> [   18.984824]   lock(&head->lock);
> [   18.984826]   <Interrupt>
> [   18.984826]     lock(&head->lock);
> [   18.984827]
> [   18.984828]  *** DEADLOCK ***
> [   18.984828]
> [   18.984829] 2 locks held by test_progs/1990:
> [ ... ]
> [   18.984838]  <NMI>
> [   18.984838]  dump_stack+0x9a/0xd0
> [   18.984839]  lock_acquire+0x5c9/0x7c0
> [   18.984839]  ? lock_release+0x6f0/0x6f0
> [   18.984840]  ? __pcpu_freelist_pop+0xe3/0x180
> [   18.984840]  _raw_spin_lock+0x2c/0x40
> [   18.984841]  ? __pcpu_freelist_pop+0xe3/0x180
> [   18.984841]  __pcpu_freelist_pop+0xe3/0x180
> [   18.984842]  pcpu_freelist_pop+0x17/0x40
> [   18.984842]  ? lock_release+0x6f0/0x6f0
> [   18.984843]  __bpf_get_stackid+0x534/0xaf0
> [   18.984843]  bpf_prog_1fd9e30e1438d3c5_oncpu+0x73/0x350
> [   18.984844]  bpf_overflow_handler+0x12f/0x3f0
> 
> This is because pcpu_freelist_head.lock is accessed in both NMI and
> non-NMI context. Fix this issue by using raw_spin_trylock() in NMI.
> 
> For systems with only one cpu, there is a trickier scenario with
> pcpu_freelist_push(): if the only pcpu_freelist_head.lock is already
> locked before NMI, raw_spin_trylock() will never succeed. Unlike,
> _pop(), where we can failover and return NULL, failing _push() will leak
> memory. Fix this issue with an extra list, pcpu_freelist.extralist. The
> extralist is primarily used to take _push() when raw_spin_trylock()
> failed on all the per cpu lists. It should be empty most of the time.
It is tricky.  LGTM.

Acked-by: Martin KaFai Lau <kafai@fb.com>
