Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460874F8891
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 22:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiDGUeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 16:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiDGUdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 16:33:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57E629F581;
        Thu,  7 Apr 2022 13:19:28 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 237IAlVT012428;
        Thu, 7 Apr 2022 12:57:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=6sw++YMruD3/PdTzWGWNJ6cQ8Ve73KloYJEfR7vJdyk=;
 b=M817vN3WOuDfjCaHKwUw6PRlMfvNphattn9hXwOivagndqkmF6JlEyyZJZcWQ0NguPgG
 BipvWsMMaokKAJ80XjWGqBTQQLHoIGFxPUxzCk4qpH8AicLFQf8npFF60fWzWrR86D7v
 0Z992V20SwmR8xKterfw/9ACxVPvVKloqm8= 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f9gmr165k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 12:57:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZ84XtZRCmlPe3pPC5uVcRrqYfoTnjhEej4tnntOk4NS8tt4r3ZuCBSqkzI/w5kjLkqrgaW/eZewxWBRUbPbKCEZ7BxoXNn+qkVZdJwLDvhW5Sl89l5p64DoVC/RrqqMAEv7LgsMWpwE55RYj6YblCXItLxq45hY5jZVLhViRp65MnfMBI+GQfKtQ1TtiO80Wgww6w00jtIARzTNrz+6pfXMg9Ej2EaiFuMclgQTlvLn52MQXPsDGPS/kTvsJxXPoZY/9YvPpPZjmHrMZI5tOmlPHokAEGcAUMFMDuYJir4n6PihHMXABNGBE4dsMBqpmLxEWsg+y3YMaS0AIURE7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6sw++YMruD3/PdTzWGWNJ6cQ8Ve73KloYJEfR7vJdyk=;
 b=XRchjW8EYEQbxVk2sQKjJQ2LEl/P0TGy11bpKbiGTofdVHLMKL+g/wF3vAxouiR9jxEQmvmtu1zSysm3Q6uAiBBbTcMheQWMMyweWbg0a4I9+HtYqIYvnuwLlIPK8zRGo2jCDF/rH5NMBVJJoS1QbFDU8WOaBsvKLkvQ6Qw4DHARZSDfxxnCjjCPjvt6xjNIEClF8bHuSzr6UfIEmO8YEByTzIQsOGO+vVTbrrl5q04z0g4/j2AlZ3xDK/1U1mcDaa1w+3zf0ilReAqHkxctDEOyfAOUZjf0x0Q4B2AYtBg2450K1fYDwLjBXnrHNC5RmOLSGwmzlk8a6VyJvs7FsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BL1PR15MB5315.namprd15.prod.outlook.com (2603:10b6:208:386::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 19:57:25 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e150:276a:b882:dda7]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e150:276a:b882:dda7%7]) with mapi id 15.20.5123.031; Thu, 7 Apr 2022
 19:57:25 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
CC:     "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>,
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
Thread-Index: AQHYRIo6ffSmNDMip0KdC6K8yX1qc6zY+Z8AgAE0IQCAAXb7AIAFSdYAgAEZXACAAuJiAA==
Date:   Thu, 7 Apr 2022 19:57:25 +0000
Message-ID: <16491AB0-7FFD-40F5-A331-65B68F548A3B@fb.com>
References: <20220330225642.1163897-1-song@kernel.org>
 <YkU+ADIeWACbgFNA@infradead.org>
 <F3447905-8D42-46C0-B324-988A0E4E52E7@fb.com>
 <6AA91984-7DF3-4820-91DF-DD6CA251B638@fb.com>
 <YkvqtvNFtzDNkEhy@infradead.org>
 <482D450C-9006-4979-8736-A9F1B47246E4@fb.com>
In-Reply-To: <482D450C-9006-4979-8736-A9F1B47246E4@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61fcc885-8b37-4237-9480-08da18d0d66c
x-ms-traffictypediagnostic: BL1PR15MB5315:EE_
x-microsoft-antispam-prvs: <BL1PR15MB5315152B9F7CBC341FBBB1A2B3E69@BL1PR15MB5315.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ARGEm+mUo7zuthPB/BjiKFHjYouaBKkRY2Q0UCJEVfgBER4+RYtDfznyfLvbrXKYFJhTfzr6Iy/hKNN7HoNGXDr7eLkyteviMY20TXdECyGLLlTuTqZrcH4RUdqW7/+mB1FfUtsHvP5TDdc5vz0vaf1MxeYKGDh1IRvmu0mk4GzfAiUXmpHpeKt8Rj+eBcJHWMhkO9VELs0vei6G8umHTpb0GNsCZK8JQj3d5t+eusfnENVqG3mYAvkmDa/6g81k6cMCs3QPRFjxKYMk73JyLhQuYY8WmnvGik170rJUeIwA71wPnTNeSdw4DBkfvxECFkNijVXe9Z4CdyWNjd8+T/Y1D4lYj9GzMqfJToVcyrShhWAoB7dyoAm60wEzgdzM3WHX0ppzPegXh1L+H4BstHmyB/xXk0Ir1I7lYMks/sFJ4GF/oLOKcenYOMLmO8ALIaiPde9eBHcg5ZHbCNSktpx3EmTl4IFJpvlxHOuKx5rhacmMUmZ1VdIRzAfl7Ba6MSCZPvUtLXMZuMUX8Auqa2XAalrPbWAqFRrI8xNe/dDNuWlc6MBYpiKGhVpSft7jGk6qpAm0ZjA7x1WY2ZRjLPJfMlGvtPMVB8oc1DQqcwrdsy+r2js03343ED+ypzrw6Oe4IIroyscKGuahIMFW+Hbs9xioRvhW93oTt7Xv5BXbet5SNbpRP+hVqC+4mzVH3wI567tlkakNNGJNm0Mgx686B4hzKMOGeIJJlRTSLjSTvISxyyHiDVZ78LCHOm6anQQY/mBv/okJHZLtxRc54g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(6486002)(71200400001)(33656002)(122000001)(7416002)(38100700002)(36756003)(508600001)(8936002)(5660300002)(2906002)(66556008)(91956017)(76116006)(66446008)(64756008)(86362001)(54906003)(316002)(4326008)(53546011)(2616005)(8676002)(186003)(6512007)(110136005)(66476007)(66946007)(6506007)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fzntdh3OGyEV4Yjp/i3kIXaymhSzFjufsVx8ZGhZ6mKPuuIAdO+op2d3jRCM?=
 =?us-ascii?Q?hXMfyQLvsIeHdy/u7sxd9G1V72YqT7SuUcZvGbCjA15p5Ez90n7WEGfEs8Ih?=
 =?us-ascii?Q?T0Xf7LUph8iJe0WgmsJwy7tmvyKo68KRRoIak2pG9AJh29hIuh/6rwu4lWiS?=
 =?us-ascii?Q?pUksSa6wDWKvSxVS4BVlHxjz9v3rg5eUaMPOGBoijwaYsDT2slntHTNtQb6Y?=
 =?us-ascii?Q?XiRqe22diXQlEaL/uuZ2YufdMJ/7C5Eyj3TC1SQbu7B0jhJuhRaLhLduteMX?=
 =?us-ascii?Q?EvQovPnOpR+aswn8JAAHCXYMzczhfA4eDvArX7AM6zT60RAOYS6vyV/YhvDd?=
 =?us-ascii?Q?8Qcc4qe1hz3wmhf6si0DDiudSzaEG37WurKqvrtThFcGvxo4jKdAHPQIcobo?=
 =?us-ascii?Q?SPGlv/JXdnE5bZVGJG4YCzuQSTHtaFaLu4XNTpfT/PDfyBol00TPkJajnD62?=
 =?us-ascii?Q?hQ7lKKow23jYT4XFRFAV0NGkuBQt0EP4MAenoQEioGCQ1VwZtRc4lHvXrXxP?=
 =?us-ascii?Q?jICNpd/1ZShusf/ERC9qFdoucMmz2GbpFXTAxKJSrMA+RHqzVYGJvIYuoYGs?=
 =?us-ascii?Q?ozGVfLHowEaxYmoagAQ5EGxCUsaaCp36PbajAq33y9zNfboSlKijXzWsHAWZ?=
 =?us-ascii?Q?Ng3S0Jn4kF6lWiYWgWNPMrkEb+stlSYRnt3E6dRMZ3Jo99p5fBhHu0PvXmrZ?=
 =?us-ascii?Q?PgHELDZbtvkItNrOuwqJ3+qJP/OtHdK+Sp9DiSwvzjZFUj++viAjOPSUFZ83?=
 =?us-ascii?Q?vCLX3pIbGJ7rN2I0P2ANYbGu/vLEvDcBX5rXZIzaKvlNhUVTuePI4BakHwS8?=
 =?us-ascii?Q?88a0wPn7nNbfuizZM1ZHRELE1so3krATsNrZNRbuum109f9JhM8/5JNMowLa?=
 =?us-ascii?Q?qVm7qpDWimo4jx1fGc9yt4nMhSf1BLxymvcC8yujrU8YP4j4OgxGkDktxS3+?=
 =?us-ascii?Q?eRjrg6ML6JLMrq6LI7/D5IEdm3NwYF9hZHOhHyI9oRbvRuFFym+l70bKdnpZ?=
 =?us-ascii?Q?clMd6W7bNM2pMrikUOSbxpgzTZiX+AQvAJrYu1NvZBSXWnTyftmKc6ioncam?=
 =?us-ascii?Q?RZVZh2IECbh/wb2sQ6jBgxNfSRzmGC3AAHvEeP1oFXjbEX9Nl29Jg+DdD7Ft?=
 =?us-ascii?Q?NxWILEo6qQQCXTbimcWkndLrRQnsnYtRkZ4ICxiCpXoVM6VM4RzMBExkOvkU?=
 =?us-ascii?Q?A6Pky7uQpQN8D+wbfHGKHZTRDgsnsdosH8I917EisxxNdkyvfykoR0EzZIYj?=
 =?us-ascii?Q?dOXWpz+F8e5DaikDiYn2GigmD/N6+MD1ieHP6XbqE1BcoM2w6BH7Y8A1bE1d?=
 =?us-ascii?Q?AeIIqxGnYn1JzzAT3zcWbNomKCTWZ1sBox2w7qhnA40GgEHEbRzNoQ0mOsfI?=
 =?us-ascii?Q?CiCci0a7K6EzINwZFS9OzZDXhi1YsNNJYlHccRkkkJLkEiY2WV6itHp1+Fq+?=
 =?us-ascii?Q?FuuOWIKpTOAGYP6ANq7Ob0L0QguSFZX9n5PvbVOsTfVihJC3xZCORqzVCXFr?=
 =?us-ascii?Q?PS+gszs/NHsA5H/dZSEoy2W6VZZerfuGdKnsBpdukYHC0xWb2A4uIGi7iQjF?=
 =?us-ascii?Q?kUh3+n/hok8tZU4jVPKefqI7WFv8ZpsGsXwNrQC5MeeWC/TVSFXhZ8NeFFV0?=
 =?us-ascii?Q?pYfIbfvdd55h4anhkC2K9OGM092l8dwXDFgVFX4CBpm545CmTfr+fSki0LKO?=
 =?us-ascii?Q?P3yh9OqJZpdOdKQvUF2/Q48sPCMaaapoVnPGOioylFntOt7tXfOYpyRrIbuY?=
 =?us-ascii?Q?T0UI7rAvmHSHoH/ufwoVQjLEKTY5JzzyHrXWkxpEKbM1uJnj/NuN?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AC9C167C86148C439B85C72DDF0698CC@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61fcc885-8b37-4237-9480-08da18d0d66c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2022 19:57:25.5738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oamr50X7viepaDu/5CJW12Rs2Cxp/OB60a4wQsRbp9GQM5QjMLfklPwaWis6ERF1ZXKPCTR/OIsEjejuclHuIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR15MB5315
X-Proofpoint-ORIG-GUID: 8B_y3vWwaYWIBzfrfT9V0bGBNbiHT0mv
X-Proofpoint-GUID: 8B_y3vWwaYWIBzfrfT9V0bGBNbiHT0mv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-07_04,2022-04-07_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicholas and Claudio, 

> On Apr 5, 2022, at 4:54 PM, Song Liu <songliubraving@fb.com> wrote:
> 
>> On Apr 5, 2022, at 12:07 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> 
>> On Fri, Apr 01, 2022 at 10:22:00PM +0000, Song Liu wrote:
>>>>> Please fix the underlying issues instead of papering over them and
>>>>> creating a huge maintainance burden for others.
>>> 
>>> After reading the code a little more, I wonder what would be best strategy. 
>>> IIUC, most of the kernel is not ready for huge page backed vmalloc memory.
>>> For example, all the module_alloc cannot work with huge pages at the moment.
>>> And the error Paul Menzel reported in drm_fb_helper.c will probably hit 
>>> powerpc with 5.17 kernel as-is? (trace attached below) 
>>> 
>>> Right now, we have VM_NO_HUGE_VMAP to let a user to opt out of huge pages. 
>>> However, given there are so many users of vmalloc, vzalloc, etc., we 
>>> probably do need a flag for the user to opt-in? 
>>> 
>>> Does this make sense? Any recommendations are really appreciated. 
>> 
>> I think there is multiple aspects here:
>> 
>> - if we think that the kernel is not ready for hugepage backed vmalloc
>>  in general we need to disable it in powerpc for now.
> 
> Nicholas and Claudio, 
> 
> What do you think about the status of hugepage backed vmalloc on powerpc? 
> I found module_alloc and kvm_s390_pv_alloc_vm() opt-out of huge pages.
> But I am not aware of users that benefit from huge pages (except vfs hash,
> which was mentioned in 8abddd968a30). Does an opt-in flag (instead of 
> current opt-out flag, VM_NO_HUGE_VMAP) make sense to you? 

Could you please share your comments on this? Specifically, does it make 
sense to replace VM_NO_HUGE_VMAP with an opt-in flag? If we think current
opt-out flag is better approach, what would be the best practice to find 
all the cases to opt-out?

Thanks,
Song


> Thanks,
> Song
> 
>> - if we think even in the longer run only some users can cope with
>>  hugepage backed vmalloc we need to turn it into an opt-in in
>>  general and not just for x86
>> - there still to appear various unresolved underlying x86 specific
>>  issues that need to be fixed either way
> 

