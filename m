Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3580F4ED0D5
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 02:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiCaA2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 20:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiCaA2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 20:28:00 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196933EBAC;
        Wed, 30 Mar 2022 17:26:11 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22UHKXE5018340;
        Wed, 30 Mar 2022 17:26:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=duiOfKt7qqHjSmXG226U54oY36fJXkIAOLOr/wBFeN8=;
 b=Y6M5qMiug/1cDCWaaWn1S3L3L4Y4ZQIAklkmD4xBSxiymHiWmZeM3AnzH/8j16wv4hQO
 7AhmluuVDJic37SYSspQ5kaw6jKTKgeF20X92FlTH6xj1u40mBIh8GzQsh5n03boOoy9
 WJ5Qoe7Z2eMTcN39iOB4a3HDa6BLMq2jUdA= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f4nfhnh99-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 17:26:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CDR2DRoeqIsyiaVJ25SdwV5RukGRMbQ/pkKam10WJOgQgVA4iJ9y3L5RRALauPikZNS4BE0QBVFoUFqgnnKdM5BPKCMqORMrGfx5vw36vdXNZRYXkE45odIWAYrvZ6r1TG2Jrk2Hol1FjKHmqDqaQMpvD32gI89s3Ug24pTewWPwGAHSmaMxUWR1NTynRs90IyT9gRVekStiRqza0LcJMOJDQALN8TUzjlrAPmcX75TitmX/RoAbdzUKIhAf9Gq5dnb9W93YI7YHAl6BuoynCufR9SSs7YKVwDqhiKUQsym8Ix2a5F2uMmLZFsl6HPn3RgVjYnWz9N+u0Omn9coe7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=duiOfKt7qqHjSmXG226U54oY36fJXkIAOLOr/wBFeN8=;
 b=bws6I/TEcIe2Mq/HfhZ80bV/30TgdbgIBFb5kFUE0pkL9BPOQs2EKbmXd+2JTRV9nqJliHvScAjcVxfO3ZhfQhrzPtwau7jlm+/xlvH1b2xXkIMh93Yz7hDy2buVWwXqaa35NaqKo6+RqQxE0nDhJIbsBDrhutA555PyYDxWRc+TeYeK2VvG2y06Qx715SuqEHBs2KaNgWElEP02F0wNRAEc3FIQvRG588NXvIu9ejFm61fNaSGeI+K4OWlj/brxbS1VmRMa/gK6Tr/cMVSxWspE1wq5nZxhTrflmTguVUzUtTmAiLH4l3fRZteh3GuUXUTqZE8XUXC4l0shF937FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8)
 by SA1PR15MB4840.namprd15.prod.outlook.com (2603:10b6:806:1e3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.26; Thu, 31 Mar
 2022 00:26:07 +0000
Received: from PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::e487:483c:b214:c999]) by PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::e487:483c:b214:c999%3]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 00:26:07 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "song@kernel.org" <song@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "ast@kernel.org" <ast@kernel.org>
Subject: Re: [PATCH bpf 2/4] vmalloc: introduce HAVE_ARCH_HUGE_VMALLOC_FLAG
Thread-Topic: [PATCH bpf 2/4] vmalloc: introduce HAVE_ARCH_HUGE_VMALLOC_FLAG
Thread-Index: AQHYRIpIhivpG0IWnUKnHM36adfOLqzYlfEAgAAMzAA=
Date:   Thu, 31 Mar 2022 00:26:07 +0000
Message-ID: <6DC57B01-BB2A-49DF-A554-B6C8B025B562@fb.com>
References: <20220330225642.1163897-1-song@kernel.org>
 <20220330225642.1163897-3-song@kernel.org>
 <96db8116c0c2680cb5c3b45d19706c1cd064ab6e.camel@intel.com>
In-Reply-To: <96db8116c0c2680cb5c3b45d19706c1cd064ab6e.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8bbec41-f158-4870-adab-08da12ad0c96
x-ms-traffictypediagnostic: SA1PR15MB4840:EE_
x-microsoft-antispam-prvs: <SA1PR15MB4840E149CCE7F4B01449F9C0B3E19@SA1PR15MB4840.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dXN2zel9Oh8RJuFNajK8QsG7e9Jwh3GGGPieYa5UJ3hWkRBCyMgLGjdT6AhqRuMDyhpeC6/4ZXvAFYqVR/55hJSFNTAtr4NeAcJ49woyUWAAeiYZOJLT6LixmteoFXBFMHKE8go35VAbueq1O4XHYet1ENo4f0mfWW7bUSkb/PwHho15TsIGRnhCRN+PrrIkmQqNvMynmNPYVcmAghWeY5qvy8IgTv62LctceK2zu0tzQYmdxRpV0SzAhqhL9poi2pcGHmBftHeAgAcFnFQLMIaJMRRX3PSP/C53P5GKCgJcxu0icsmhxMw5jpKkJlpgW1k6TllEZq8eLlo3U54L1+JELrD0oUangtBAMvfloD5XnmsBBt9/41yiyZ23WShGk3SPuM+9kEtX0GpyMcGDQuodPT7W8ODL2Ty9egBmfF1GECl+E3TR796YfTjJKGfsezFT0mvS9yGW25j1IFxxf7QHLDXP5W3m8i4vyYotP8dOya0z5o1CniY2aPQUc0rQjfrUF8k3SKsmYxz0HCvUMsS280k1FEAAQFRHpWGO7Oy/auvwDNztuAwMQKYMcG6OOACS7x+ZPeYEzjokzt28epadgy/eLLUmJgaozYrpXimkZZdUaZtNMMFVTNEG2jXouxC1I2ENDYV1hnDGQve2d9uhP0xrKq14CPinCHH5s49Tex+T+l5zupEo2sfOovjqlnF0LH15VBKAL4i3R9gxyFu5ebJcjxJV+gVtGI4Pi0KglJ7swM7cVBPPSZmnGvAWNKVpQPApFIRCdmpFhZzzeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5117.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(2616005)(6512007)(5660300002)(508600001)(6486002)(6506007)(33656002)(186003)(36756003)(53546011)(7416002)(38070700005)(8676002)(64756008)(66946007)(66556008)(66446008)(54906003)(2906002)(6916009)(38100700002)(122000001)(86362001)(71200400001)(76116006)(316002)(8936002)(66476007)(4326008)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RO33iFazg60LOX25vqhi7/UdV1KTmorEnwLknazNX+dRw+tU9gLup/MHoebQ?=
 =?us-ascii?Q?5iRWF1cQI4CwrWhH6lrCEPYV6j4eKbLk1c3U1IVSIVydZeGKDcQFOu+TdmaU?=
 =?us-ascii?Q?s3hlseeLbZqCdPaPQdoZfxTHNmQ4YqQ10cqz1/BoP9WKnXuO4BhTs1NwnM6J?=
 =?us-ascii?Q?T6jWXHi5NrYRlL5A+sGxOybhUUZDROxzt41Mljj/NZ6PBziyXm4edBolKJ4M?=
 =?us-ascii?Q?rIPwiVBIjnUPybcyIoX+ugSS5j73c7nJmzWcEKKHiWzVrJMFBaHNqIcYI/uN?=
 =?us-ascii?Q?HNuHTrgeUSiiRnI0j2869CpKGydHU8yDJjz+x0MlPaqY5KJdAxGP7CxxHca5?=
 =?us-ascii?Q?uPN4KHn86y176OE0FbeDRGBSf9VkhrDa6500jFKv8nCu1C8aGCtKHkVpLAl0?=
 =?us-ascii?Q?ef+GDmBRjj9oqYtFQ2JVryAd+i+uT6NHHUj/1/SpSyjo21aYOsgSS/8Jld4S?=
 =?us-ascii?Q?aNMI/Rfv4Ou8hqh3EWGwMAJSfn5jpSeRjjgxLt/mzf56GoalVyT3cGDR8Uog?=
 =?us-ascii?Q?j+K+ZB7q6uQPDVMautbz7cnPiCme+ElENUy+OkI+N2oSII1Q1uI7YlWfM1Wc?=
 =?us-ascii?Q?ltcX+KVzMwKKC9bLLLwa3MEgq/1lQQ2iBHfcVaiYeWXiL5ds1ZwrAn/NiApT?=
 =?us-ascii?Q?Kcyp7kIg7ge7TPez6EVKI0iZpxZDaTVC+et3ayxp72MDJIqORwTeER/+GZsx?=
 =?us-ascii?Q?+CtN2ENnWG7PfGAO2WBYcQQXXt4aakBVZVyTULZ+hY1mi2uw8f6Ee+I3ffRV?=
 =?us-ascii?Q?orN4dulTwQY/SeraJlGRJk58e6xmj1lujjAa2JxTqVB6R2Dq4jljB+NWjsKi?=
 =?us-ascii?Q?FpT8JxqlVQIqPYBd2xhLTUjjCgeNTUzazpPsDdBDSJGkPoVRghPPbrh5Y1+l?=
 =?us-ascii?Q?YznsD2YTo3kTIPtaKZ/45NedTXubYzH5ciK5TfVa9x3fsEF8ZlWwxpMZSjC6?=
 =?us-ascii?Q?vMhXJt/T953/KtbJ6EHLYl8/EZVP0gulo0R3tKyvj2AldRiF68exSGetsdtw?=
 =?us-ascii?Q?5fjIh4UiAXVjQT5RODBhizP9VJY//iWZIQLHxahUEfByb2Ij4yWuLXDpiIol?=
 =?us-ascii?Q?+roGY1hrMjKXNar65SUm7fzp7c6De0gCOol1jECr6EaT/2gTKC+A+p936411?=
 =?us-ascii?Q?7WVOJwDZSyHs57bhkLPlJ06naZPFhbXu4WcPOY2Fyn+s8Ldn+Jj2Xs9/s/MR?=
 =?us-ascii?Q?/cMuZCpQJyoa4N2irx6bqBU4Em9mMisXJw+pzMZq/9rwq7fV/ugVcYs6QoA2?=
 =?us-ascii?Q?GtZxKSXseiZyzFv0abAokNzQ9imrIvamGsoOs3OKIwgNiN6CL5y1Wj+NfXI9?=
 =?us-ascii?Q?M4s9ElVmL4zD6cCmUE7aZ8ZVn6KzzjIa3euoY0giyt8v4A15hpy6mY9E4Jmq?=
 =?us-ascii?Q?Nb1bLA17TqBnqCMjMfE0+TJRQO9vcLOorqiYAPjiQUyAj+JA6m7uMBhypmk2?=
 =?us-ascii?Q?V+Fgw70UG1W8V/BJWFyjWTsxQAj5Ruwuax1F6Yu6EzMc06GE5GyUX+j5GaYk?=
 =?us-ascii?Q?5bWWpkHw082sMJM6YO1BwOcjRBqOOdOoro7fqYYGQbW9W/P8wlTOdNBXTlVh?=
 =?us-ascii?Q?J/XNV6dkQPr+dFJlHxK75rFAa0M3nNm6i4vyj55B0hWBdTOKjExYAieb1mAu?=
 =?us-ascii?Q?RFMvIl770diSej8Q/Yi/gsjlGkILHfNytGwnVU1LuFUKcdaO6y5kcefiFL8s?=
 =?us-ascii?Q?OY2MCV6xE2wWZ3YMsN1hjaip2wsFzpJCjjDrDtwxdNbrzi2jrbUTME0fHooG?=
 =?us-ascii?Q?Ge18dC7B8j7CB8Y9ZxBo9iPJ1OBN3qXERwVqEDydWKKVy9ZTc1fx?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23057C0F319A4B44BA5890A21E819455@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5117.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8bbec41-f158-4870-adab-08da12ad0c96
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 00:26:07.5252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XawdOxWo8Dz94FYYp63pu4bg8vvjCi7crpKuL4/lRQDxIFPxavWAsyYYCfZfZ9ASQjn9qiCqqRHk8Qr+kL6MSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4840
X-Proofpoint-GUID: NhJsbammsKBd0guScloMbMgCroz6GAw9
X-Proofpoint-ORIG-GUID: NhJsbammsKBd0guScloMbMgCroz6GAw9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_06,2022-03-30_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 30, 2022, at 4:40 PM, Edgecombe, Rick P <rick.p.edgecombe@intel.com> wrote:
> 
> On Wed, 2022-03-30 at 15:56 -0700, Song Liu wrote:
>> With HAVE_ARCH_HUGE_VMALLOC_FLAG, users of __vmalloc_node_range()
>> could
>> use VM_TRY_HUGE_VMAP to (try to) allocate PMD_SIZE pages for
>> size >= PMD_SIZE cases. Similar to HAVE_ARCH_HUGE_VMALLOC, the use
>> can
>> disable huge page by specifying nohugeiomap in kernel command line.
>> 
>> The first user of VM_TRY_HUGE_VMAP will be bpf_prog_pack.
>> 
>> Signed-off-by: Song Liu <song@kernel.org>
>> ---
>> arch/Kconfig            |  9 +++++++++
>> include/linux/vmalloc.h |  9 +++++++--
>> mm/vmalloc.c            | 28 +++++++++++++++++++---------
>> 3 files changed, 35 insertions(+), 11 deletions(-)
>> 
>> diff --git a/arch/Kconfig b/arch/Kconfig
>> index 33e06966f248..23b6e92aebaa 100644
>> --- a/arch/Kconfig
>> +++ b/arch/Kconfig
>> @@ -864,6 +864,15 @@ config HAVE_ARCH_HUGE_VMALLOC
>> 	depends on HAVE_ARCH_HUGE_VMAP
>> 	bool
>> 
>> +#
>> +# HAVE_ARCH_HUGE_VMALLOC_FLAG allows users of __vmalloc_node_range
>> to allocate
>> +# huge page without HAVE_ARCH_HUGE_VMALLOC. To allocate huge pages,
>> the user
>> +# need to call __vmalloc_node_range with VM_TRY_HUGE_VMAP.
>> +#
>> +config HAVE_ARCH_HUGE_VMALLOC_FLAG
>> +	depends on HAVE_ARCH_HUGE_VMAP
>> +	bool
>> +
>> config ARCH_WANT_HUGE_PMD_SHARE
>> 	bool
>> 
>> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
>> index 3b1df7da402d..a48d0690b66f 100644
>> --- a/include/linux/vmalloc.h
>> +++ b/include/linux/vmalloc.h
>> @@ -35,6 +35,11 @@ struct notifier_block;		/* in
>> notifier.h */
>> #define VM_DEFER_KMEMLEAK	0
>> #endif
>> 
>> +#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG
>> +#define VM_TRY_HUGE_VMAP	0x00001000	/* Allow for huge
>> pages on HAVE_ARCH_HUGE_VMALLOC_FLAG arch's */
>> +#else
>> +#define VM_TRY_HUGE_VMAP	0
>> +#endif
>> /* bits [20..32] reserved for arch specific ioremap internals */
>> 
>> /*
>> @@ -51,7 +56,7 @@ struct vm_struct {
>> 	unsigned long		size;
>> 	unsigned long		flags;
>> 	struct page		**pages;
>> -#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
>> +#if (defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>> defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG))
>> 	unsigned int		page_order;
>> #endif
>> 	unsigned int		nr_pages;
>> @@ -225,7 +230,7 @@ static inline bool is_vm_area_hugepages(const
>> void *addr)
>> 	 * prevents that. This only indicates the size of the physical
>> page
>> 	 * allocated in the vmalloc layer.
>> 	 */
>> -#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
>> +#if (defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>> defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG))
> 
> Since HAVE_ARCH_HUGE_VMALLOC_FLAG depends on HAVE_ARCH_HUGE_VMAP, I
> don't think you need both here.

I think we still need this one (_VMALLOC || _VMALLOC_FLAG)? 
Note that this is not _VMAP || _VMALLOC_FLAG. 

> 
>> 	return find_vm_area(addr)->page_order > 0;
>> #else
>> 	return false;
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index e163372d3967..179200bce285 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -46,7 +46,7 @@
>> #include "internal.h"
>> #include "pgalloc-track.h"
>> 
>> -#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
>> +#if (defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>> defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG))
> 
> Same as above.

And this one could be just CONFIG_HAVE_ARCH_HUGE_VMAP?

> 
>> static unsigned int __ro_after_init ioremap_max_page_shift =
>> BITS_PER_LONG - 1;
>> 
>> static int __init set_nohugeiomap(char *str)
>> @@ -55,11 +55,11 @@ static int __init set_nohugeiomap(char *str)
>> 	return 0;
>> }
>> early_param("nohugeiomap", set_nohugeiomap);
>> -#else /* CONFIG_HAVE_ARCH_HUGE_VMAP */
>> +#else /* CONFIG_HAVE_ARCH_HUGE_VMAP ||
>> CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG */
>> static const unsigned int ioremap_max_page_shift = PAGE_SHIFT;
>> -#endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
>> +#endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP ||
>> CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG*/
> 
> Same here, and for the rest below. I think having
> HAVE_ARCH_HUGE_VMALLOC_FLAG depend on HAVE_ARCH_HUGE_VMAP like you did
> is nice because you don't need to special logic for most of the huge
> page parts. It should shrink this patch.
> 
>> 
>> -#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
>> +#if (defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC) || 
>> defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG))
>> static bool __ro_after_init vmap_allow_huge = true;
>> 
>> static int __init set_nohugevmalloc(char *str)
>> @@ -582,8 +582,9 @@ int vmap_pages_range_noflush(unsigned long addr,
>> unsigned long end,
>> 
>> 	WARN_ON(page_shift < PAGE_SHIFT);
>> 
>> -	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>> -			page_shift == PAGE_SHIFT)
>> +	if ((!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) &&
>> +	     !IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG)) ||
>> +	    (page_shift == PAGE_SHIFT))
>> 		return vmap_small_pages_range_noflush(addr, end, prot,
>> pages);
>> 
>> 	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>> @@ -2252,7 +2253,7 @@ static struct vm_struct *vmlist __initdata;
>> 
>> static inline unsigned int vm_area_page_order(struct vm_struct *vm)
>> {
>> -#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
>> +#if (defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>> defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG))
>> 	return vm->page_order;
>> #else
>> 	return 0;
>> @@ -2261,7 +2262,7 @@ static inline unsigned int
>> vm_area_page_order(struct vm_struct *vm)
>> 
>> static inline void set_vm_area_page_order(struct vm_struct *vm,
>> unsigned int order)
>> {
>> -#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
>> +#if (defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>> defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG))
>> 	vm->page_order = order;
>> #else
>> 	BUG_ON(order != 0);
>> @@ -3056,6 +3057,15 @@ static void *__vmalloc_area_node(struct
>> vm_struct *area, gfp_t gfp_mask,
>> 	return NULL;
>> }
>> 
>> +static bool vmalloc_try_huge_page(unsigned long vm_flags)
>> +{
>> +	if (!vmap_allow_huge || (vm_flags & VM_NO_HUGE_VMAP))
>> +		return false;
>> +
>> +	/* VM_TRY_HUGE_VMAP only works for
>> CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG */
>> +	return vm_flags & VM_TRY_HUGE_VMAP;
>> +}
>> +
> 
> It won't return true in the case of just CONFIG_HAVE_ARCH_HUGE_VMALLOC
> and vmap_allow_huge. If you have CONFIG_HAVE_ARCH_HUGE_VMALLOC, but not
> CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG like powerpc, it should still try
> huge pages like before.

Yeah, I missed this one.. Will fix in the next version. 

> 
>> /**
>>  * __vmalloc_node_range - allocate virtually contiguous memory
>>  * @size:		  allocation size
>> @@ -3106,7 +3116,7 @@ void *__vmalloc_node_range(unsigned long size,
>> unsigned long align,
>> 		return NULL;
>> 	}
>> 
>> -	if (vmap_allow_huge && !(vm_flags & VM_NO_HUGE_VMAP)) {
>> +	if (vmalloc_try_huge_page(vm_flags)) {
>> 		unsigned long size_per_node;
>> 
>> 		/*

