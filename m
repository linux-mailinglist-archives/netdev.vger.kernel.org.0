Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4D14F5410
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiDFEUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1851022AbiDFDCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 23:02:00 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9A5ECC6B;
        Tue,  5 Apr 2022 16:54:42 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 235I0ba4009240;
        Tue, 5 Apr 2022 16:54:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=qqxmrWDNqRS1xQ8TeAr3ewvJqGk6RGm8tql375O4Jng=;
 b=KhK1XXjE3lJ+9wGRSc4jhJQu666J1gsHeVHexOCcKVtmfw/4+5IAQdZivXUPYvsmj3s3
 1VJd1Qaxv5iNIQ/nstcm1xjBjcuH0w4+gZGSE6a7OiC5lbh3I7w4NHfmT0gY1ywUuamV
 5a2clGl6F7XX8cK+8pZQYngPecL+ozICuPA= 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f826ybyw9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 16:54:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUi/DB9jsllG+aDZzthDPgbRan0aaT0CqbADToFI9PfS+EcyOoE14s2+qgd13bYv2h/ybJyfhnMdFLcEikT/gVrqIHN/nx7B6j9EocZCmmQsGY4Wr9fVB+1NfHuVmHw6/mk2kmN82CWwjyl/UP5eq7XkoP8q8eMIMsx5kbPM2Vgv8CaSeDyufN8SRzBaIBF/LjB241rvrDbIleyq+RF14pEB1s+n8c8ZYlvMR8Dq40PQUsBfl9R1YLpMMtTBD9i8FNqJHaw7HfIJMtPX6i57QslsiLnIo0yN0W888hfFmFJk4fEAb9GcGLFNeNMRertk8XhbVaZDkYkcZO2soy14xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qqxmrWDNqRS1xQ8TeAr3ewvJqGk6RGm8tql375O4Jng=;
 b=Lh2Lp80Tk+ebDj66GT1vz1ORnIC8wtK70ZxwCj+S+Ta4CISM0yygQCK2HFyCTXW9HpiC5WEZ3ujlyrmrA2kFE8fwnzOV/rmbpqKjzU7WrLDluRKA6SMaaECv5Mt+RquBJT86AKWS8kRl/R5les8os1BjOm1M8dDojbTm2RnF3CSITT947x3xF90gtefdI+RCX8u5HocH96ZCDhp7Lk7whGW5I6EvI8lmuLytLWETic1b0pH9ZW9ZfGiztSXVni7okKAyIn3IKoUJO1TQxtDKPQ9lwqj0yPt/lvDd7eo4L3qcQV/36kXENZAlEEWqLgkEjxs4IN47kxwXI3sr1TNggg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM5PR15MB1804.namprd15.prod.outlook.com (2603:10b6:4:58::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Tue, 5 Apr 2022 23:54:37 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e150:276a:b882:dda7]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e150:276a:b882:dda7%7]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 23:54:37 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Song Liu <song@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH bpf 0/4] introduce HAVE_ARCH_HUGE_VMALLOC_FLAG for
 bpf_prog_pack
Thread-Topic: [PATCH bpf 0/4] introduce HAVE_ARCH_HUGE_VMALLOC_FLAG for
 bpf_prog_pack
Thread-Index: AQHYRIo6ffSmNDMip0KdC6K8yX1qc6zY+Z8AgAE0IQCAAXb7AIAFSdYAgAEZXAA=
Date:   Tue, 5 Apr 2022 23:54:37 +0000
Message-ID: <482D450C-9006-4979-8736-A9F1B47246E4@fb.com>
References: <20220330225642.1163897-1-song@kernel.org>
 <YkU+ADIeWACbgFNA@infradead.org>
 <F3447905-8D42-46C0-B324-988A0E4E52E7@fb.com>
 <6AA91984-7DF3-4820-91DF-DD6CA251B638@fb.com>
 <YkvqtvNFtzDNkEhy@infradead.org>
In-Reply-To: <YkvqtvNFtzDNkEhy@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 514ea588-ac1c-49ce-153a-08da175fa4b2
x-ms-traffictypediagnostic: DM5PR15MB1804:EE_
x-microsoft-antispam-prvs: <DM5PR15MB1804039F5B512FE3D98133F2B3E49@DM5PR15MB1804.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c2jFIxzeTIeFKLjRKzMS765BmBsRgcTqG4ZhbDqBfOal+RCFNTvHB+n2LusOhtpkjweTYHV/zKIrK/IcaLFYC/bfIWSXbpJYtOaq9jFEbTRlEysdvI6fNflolKvgKoj08Lrm63Nd4t4IVkDO18bVIEdq0+cHQp4B/u8WYVs1on4QyOl2Nr9w+nUYe7B+2okmW0JbJIWSYohQJhtWp4k6aHpA/HzjbJd6wOnI69FTfOIp6FmQUvIZUeDl8VUR8WEsuftQk0KfhaYzZLZNzQxI43GN/cwo7/GWHkXVrYZRZtjHoLdmGu2ytnB3QcjGbBQa6EVE52voMZk0SJ+R5C5h+szI4jDDc7VLywwR45NAQdbpwfuBTWlPgF8o0ZQeeA+4IYqBv11p2azkccEzkhYnCRlkzwbX1DhW0r5Y4ve51s8RUFuXc+VM9wbUyOsYcddKKabkQPrh8n5rocj0g8a7o0zHROb7u6O+dMLB0dBjVJa6trRsQIW76HIWEYVGcCg5+ilBaikSu3MtzsX+OxJE9QMWwBITtTgWbTXZIhE0rYs130Kr1A8PuvOEJeFxO8IIvj1tQkMjf7mQ7z9ZYXEUFD9vTOH2RR0ezfAUXG19KCoIu4dfoFMqzVO6K5LSGZ0M9s+pPeuLFpkWaia7krHOt0/YTRrUCOxkVwHH03dit/lNSercVD1H4Sop6EAID3Kax4Z6swWucPCy3JuiMUJSa9whctLdS2rDUsVcDlOKKinDxzyNLnB/kp4U6oCHCGVBIF1smyMqCPjMlOa2K0a66w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(38070700005)(71200400001)(7416002)(122000001)(86362001)(38100700002)(2906002)(8936002)(36756003)(186003)(2616005)(53546011)(6512007)(91956017)(8676002)(6486002)(66476007)(508600001)(66556008)(66946007)(6506007)(76116006)(316002)(64756008)(66446008)(4326008)(54906003)(6916009)(33656002)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QHuttHchwjtFwio6x+cch++TnX61o2Wo0zYRvmBJIaikNYwxlYyLWXo3Ffe0?=
 =?us-ascii?Q?vHo0ylWtM6AJiSVVBC5p9IMdPZWoD1i8FqBPK/UKj1QeOo3uhnsdPe7ZRxWa?=
 =?us-ascii?Q?tyrxqPHii3iWmRPffKqxOH4SXVlIQJyvqomzKN96xug2UZRnthwHIv94omH2?=
 =?us-ascii?Q?6WioyhNKhgXUvwcnFPdf+pjNJs1UYPDzLvLb7KKZFoZwO7QIqQmTMOhcc8B0?=
 =?us-ascii?Q?cs+MP4QXN7DWWACtTdKr4q52acf6HpxtJWm7yQdFOH/3nRKo+3nrg55p6K5z?=
 =?us-ascii?Q?zJhOZ/AjG6kCXxi/+5nMb7tZFDUXG0qbkEEoWRhtmKGl+8zp81nf8OviBqTQ?=
 =?us-ascii?Q?SYBzQR8fyw21PJ3jSC2jxRFh211UQDjeWcay5YM6YXczRFZCoXSn4akgBHJ3?=
 =?us-ascii?Q?wLZ+LqNThv3MBYAZtdUNzAhWDL4ADPsxPHegC0Tba4PTNi2Kk42K/Csf5f6+?=
 =?us-ascii?Q?JeeYOQBslw3TazyYERKrORlU2nAsyRkLuWpMCbdUChdS7X7eS+SNo48QJLdl?=
 =?us-ascii?Q?nvVzss1+hbM+mCWGOpnp0otPelF2gPLu/0lJ5UaEDWsA/rb/4xhDpD1DQ5Pe?=
 =?us-ascii?Q?kz0pI46+UjG2Gru8fsw6xKDmAErKjbVzr7P90iyjel27L5JSxq1qV1NBU43Y?=
 =?us-ascii?Q?/ihP25sDjIVt/ewjyvWwN9h9R1bzhbgARdQsJdkNX6kYg7gmZR/X+vBChRMX?=
 =?us-ascii?Q?GDw3BdVH/lj4qXsdaXp0wLpfkbbyg9KtJtFAbawhpGLPjLS3hlDZAceK2Eph?=
 =?us-ascii?Q?80r9fMxg+nv9C3ixNpLGaEmZF3wAAP+jQpYxvB1m5K8Pt5fMXXGI7O9CLgVv?=
 =?us-ascii?Q?NWoara5j2yeM3NHxsTyHhCXsqPY6g1V/dqdKC5wJtexCgfyJXgJG7pSXXVHX?=
 =?us-ascii?Q?wd1KCnoferusdS2D0Pe/Qvl4mUI6BEJgkXpaWMGxFwLHW4QnTkmCiS6xQS5q?=
 =?us-ascii?Q?Kh+tjAyxYsl6F1VqbrDI6M+jilB3A1lt6c5HWmmluIgoBWvr7CcN1FWXK4gq?=
 =?us-ascii?Q?wpmI/6DhkdzwuOwHoB2z7pDVX5c0h3QmAgn16L19H6WLDJZp3yNmc57V0p9q?=
 =?us-ascii?Q?QQlnW813UMBrRkcbH+2vT15vQpoF8EdxDFFpjpmDRGmjQDJw+kpJ7YsM4YI6?=
 =?us-ascii?Q?lhQ7tcx+4Xn5Qwz822fKGraTs0vcFiffUp6CoOpSuXkx506EpA3R3UmAsXiO?=
 =?us-ascii?Q?BU3Aa/YD0Yoc/3Q2yrh8xpxwySVyOU3tOkJrVCEscrbg/4XK3bo8MMpByABZ?=
 =?us-ascii?Q?4sDqokn14QO8pM/BfysDbXCPntg+bzmYrikrdiHoL3xQE2mqdPIntOY11oJ+?=
 =?us-ascii?Q?Nd9o97KUUEKYhiISGW2JOegOyw4pQ8Nm9vnx6fisBX83bL7zGHJFPXENR1Y7?=
 =?us-ascii?Q?kbmea/aMETRuBjR6pV/a7D6Ak1qbBV4IZm6fxp3WVw5ojeQx3Cpu7dwrxkx2?=
 =?us-ascii?Q?IPWLXFSC2ITCsvRUyYV23+X0tCaz0gIJTaJ8rVq8tI9PV0QCM9nIADXXk4eT?=
 =?us-ascii?Q?En+C/c9WRjasL2Vvpue67liV44OdVxb6hO9BBcEwf+D14ROFfigsTOMWq3pk?=
 =?us-ascii?Q?r7bUsvTpUS2yqJmi26uGjJKvTzzmWeYbOFnXMpqojT3xJArxJxNCawd/JK+o?=
 =?us-ascii?Q?7jK10AuuYek8zwzJ2StuBEU5JMDtpQlegW8o5naUhwXsys2UiTfJcsJeA/Zu?=
 =?us-ascii?Q?EVtpz1q1/aM/4SGEwJRk+cLHVvhENSRhDLBEzaE8hm8RDpB/f+/KRZ6KUAYZ?=
 =?us-ascii?Q?GFY7iZmD4TFhMbH3VAMDo3az407wFSiccF/yaxJpu699fage8DDo?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8CA306781FF3BD43BD81B09631D0720C@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 514ea588-ac1c-49ce-153a-08da175fa4b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 23:54:37.7719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v06S8TU81pBk7B0RCnJHDYKlsVYkiVph4xrPUdExd2Qva78ZwaD6AXtOiAppw24qFA+zICsKHtL0rVwFXewnbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1804
X-Proofpoint-ORIG-GUID: GgN7tVFU65_vh8wVEdt3TOX7gnwKIl-S
X-Proofpoint-GUID: GgN7tVFU65_vh8wVEdt3TOX7gnwKIl-S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-05_08,2022-04-05_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 5, 2022, at 12:07 AM, Christoph Hellwig <hch@infradead.org> wrote:
> 
> On Fri, Apr 01, 2022 at 10:22:00PM +0000, Song Liu wrote:
>>>> Please fix the underlying issues instead of papering over them and
>>>> creating a huge maintainance burden for others.
>> 
>> After reading the code a little more, I wonder what would be best strategy. 
>> IIUC, most of the kernel is not ready for huge page backed vmalloc memory.
>> For example, all the module_alloc cannot work with huge pages at the moment.
>> And the error Paul Menzel reported in drm_fb_helper.c will probably hit 
>> powerpc with 5.17 kernel as-is? (trace attached below) 
>> 
>> Right now, we have VM_NO_HUGE_VMAP to let a user to opt out of huge pages. 
>> However, given there are so many users of vmalloc, vzalloc, etc., we 
>> probably do need a flag for the user to opt-in? 
>> 
>> Does this make sense? Any recommendations are really appreciated. 
> 
> I think there is multiple aspects here:
> 
> - if we think that the kernel is not ready for hugepage backed vmalloc
>   in general we need to disable it in powerpc for now.

Nicholas and Claudio, 

What do you think about the status of hugepage backed vmalloc on powerpc? 
I found module_alloc and kvm_s390_pv_alloc_vm() opt-out of huge pages.
But I am not aware of users that benefit from huge pages (except vfs hash,
which was mentioned in 8abddd968a30). Does an opt-in flag (instead of 
current opt-out flag, VM_NO_HUGE_VMAP) make sense to you? 

Thanks,
Song

> - if we think even in the longer run only some users can cope with
>   hugepage backed vmalloc we need to turn it into an opt-in in
>   general and not just for x86
> - there still to appear various unresolved underlying x86 specific
>   issues that need to be fixed either way

