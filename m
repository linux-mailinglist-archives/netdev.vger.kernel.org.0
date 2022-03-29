Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA404EB3FC
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 21:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240891AbiC2TPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 15:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238969AbiC2TPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 15:15:18 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C652822B24;
        Tue, 29 Mar 2022 12:13:34 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22TI21D6016625;
        Tue, 29 Mar 2022 12:13:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=Sj6DJycSzF85vRncfLQchvW4lxh2RTiinFt+BxIHPuA=;
 b=OA1ZtiGz0bXQ9YDhIc4JCMNCAAEueas9QfZ4FG4kFSNF33z8L3RVooiYrCYgATppLv5M
 899nGnja7dbimQ7nkC8OtzTwtefv0YW/ewPinRxE/672eQ9Q7Smz4Jw9Z3i0QqbGLPik
 CCzKLZrcs6xy6F7wxgAVp35Be4i9da8GLTI= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f3rcw5vbf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 12:13:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HEHCaNH8+U8vgt2xMOy4xxG9KgHQhHL3PfRJOPUyDJuE4lhUbkl9dX/SYvsWk02aXZTITcfIbXGYXhEVcgLlnbw+ZcUPwfWdIfNbKpJ2VuW5F2kcYiA4q7LU9LRt3UA3+Na3WXlw/CryCzTnagIV0SFw9riK1v7FoBrdM1wr+jfn2yRHj0qz6iS9BZw6wrq9gq/DwWV9xOcDdnYmWyaZpbclHPjyJ0QBhKMF1fUmJ0kXEb13KMQL73N/SK2hcSyZHToMZc1pC1COfbhzXlUwErrTcSUqWJGMACXh8LMpKe8HpivcfDDlm6LZxq5xhWUyajVGNC61z+N1Oep+qSwk/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sj6DJycSzF85vRncfLQchvW4lxh2RTiinFt+BxIHPuA=;
 b=ic1sQCFVIttxj0o5bvA3WfSzTqlWbj/oZ/dr7CZJvw02vrIzjt3HSLNu3D+s4sdl6lhL/EWbSRlNZTyld9KyoSU6g1Y4WmwMZQOS9fu+fTqi0yod1LWBpbGwrKdK3aM7DLBNnr4U2SXgEQ4pQnUe9Uo9KYfEHXVYKjVQPqmP4n+XIqcqMRlVtnMYek8OVDdgwIeKDMgyutFksS2jxp7SJ3QqO8XeTJRhAaOgtGDxP2V2lmNQXMDdGWqXBZiOf4v4Bk3uZrp9EkOLTH4Sn1a4rAiuvjlWivJQ4IH/7EhVrXuiLlfm/WnZDfpvH9GcoNSxlmC5fvyu3MA/RjpMZdG3cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CY4PR15MB1607.namprd15.prod.outlook.com (2603:10b6:903:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.22; Tue, 29 Mar
 2022 19:13:29 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4%3]) with mapi id 15.20.5102.023; Tue, 29 Mar 2022
 19:13:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "song@kernel.org" <song@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "iii@linux.ibm.com" <iii@linux.ibm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "urezki@gmail.com" <urezki@gmail.com>,
        "npiggin@gmail.com" <npiggin@gmail.com>
Subject: Re: [PATCH v9 bpf-next 1/9] x86/Kconfig: select
 HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
Thread-Topic: [PATCH v9 bpf-next 1/9] x86/Kconfig: select
 HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
Thread-Index: AQHYGfmQYHpJmCxW+kSTgNf/KlCER6zRFs+AgASr4wCAAA5KgIAAh7mAgACsFYCAAAlnAA==
Date:   Tue, 29 Mar 2022 19:13:29 +0000
Message-ID: <C7D9C93E-AD07-4EF7-867F-7E66C630FC83@fb.com>
References: <20220204185742.271030-1-song@kernel.org>
 <20220204185742.271030-2-song@kernel.org>
 <5bd16e2c06a2df357400556c6ae01bb5d3c5c32a.camel@intel.com>
 <F079AC10-2677-41B4-A4D5-F07BDE512BE1@fb.com>
 <ee754770889c7b6de13d8e4835c7bd8b15d5e538.camel@intel.com>
 <6080EC28-E3FE-4B00-B94A-ED7EBA1F55ED@fb.com>
 <3ecfbf80feff3487cbb26b492375cef5a5fe8ac4.camel@intel.com>
In-Reply-To: <3ecfbf80feff3487cbb26b492375cef5a5fe8ac4.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ffcfb28-63ed-4a3b-dd09-08da11b835a2
x-ms-traffictypediagnostic: CY4PR15MB1607:EE_
x-microsoft-antispam-prvs: <CY4PR15MB1607ADA4FB0B1BE3480486A1B31E9@CY4PR15MB1607.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eeH1DTb155I+GQRvw9mshkCMda8hF6IwFmhTexHKfYNISS5RoUc+Ksotale7u0NKVQoF8wtWr40O0lUyQZuudRnU7leP/0E77bEdscVlfyXOTvFv70WfdmzDsHZNad8iRmQMHUDwMYYiepiId1FK3D1iSdoF0Whii5kns+CQFOmhFQsWsl4tnn2jrYt5a6fJXlwanp26Oy2J7gGabWa0ix5WnT46hjwzFojpfG2+sIpW0dmlO9Qj8mYhmqvAYwIyKoFL+8Yef1sZ81U+y0iU14n02/L0dUje8o4+WBNv/7SRGw96u5w/uqTJ8O0xaO67M6I872ZLSOi6vE4tOEPmM/WazHmtP6OVE+hHVghBZ+NulgXVjUJZyvRI0Nk2SuBc4U81iLnwDLfIAz1JQtCZag14eI5FsVUTnh2dg3yyGw3JRMIUYQNWiuWTgHuaJpRu+xUZ1l6f8EZ6TKCXIkUNyPXb9C+VzzCDdZB/qJxLOUIKpcoIIbAVpcGVVp+3hRL6ioOQhZgoRjOH3ZzsIpLSSUe+o8o5LFc5dfStefUxgyrsNmUOyjlUSNWwnKRL3Kz23LJxx3/uwqO1ZJLegVnkZnaPgNx5tSGRO/B6iJUzws8aGkjvGL9JtGek+iRIfdqplgD11NvWsfavzdBltHwDJErP6nky3LZYDoXeaKvHAFh8108AQ+uovJPlP6Jz1Kb/5WqucSrQE5B+UVlmQ/H/uxbalcwIJ5Ti/4ZG33N8JAeTWXewR0TQPd6nwoHYF9o7WEfiYX87iZlM/CrxSwX0j9MKahdHguxL9CAPegbo/NHXVPuGzvi+shdt0EcxbANpMEH5cmGAetIAZpbNmrJTnLgz/xLnTfvec18MkWc5vvI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(6916009)(2616005)(7416002)(76116006)(66446008)(91956017)(4326008)(54906003)(6486002)(8936002)(66476007)(36756003)(966005)(316002)(66946007)(66556008)(8676002)(508600001)(64756008)(122000001)(86362001)(186003)(2906002)(6512007)(83380400001)(6506007)(38100700002)(71200400001)(53546011)(38070700005)(33656002)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ilO6RaCUQaJRF0z9YG6AS6MC1RBESrRY6drNrn/i70BlQmcoF5NpT7QD6c0W?=
 =?us-ascii?Q?pxlz/pdM+6H0Du5bfGwrqDc/XFv9+CNTUIVTGnTq5qnmCM5ISVqLnaG45CAe?=
 =?us-ascii?Q?PcdHdDWNjNJHKmBSVjMvKeHEWRTsJTihcWYvzEwgvEVJAtO904RdDGdomrl0?=
 =?us-ascii?Q?iviYXxWOPkf8hUD745+jLrZ91f4ENda9cIErcq8wzLhcRSktblVqEFJZIZf5?=
 =?us-ascii?Q?CePIvZJDk8rHKbcJ5hEKRpNSd6wdQlECTST1iEz8yIMUj/iK010YB6bdkHiX?=
 =?us-ascii?Q?KhNU/HJbdQZXpubDt2oMDYcuYnyaHgPOY1osiHKr5uQjXCWEjQ7tpCvgQ4vB?=
 =?us-ascii?Q?UtOuNIFhrszKncnkD/nb+skzfsfYUjJHba5wIEb8NmEL93Q6C1tmnIZxe3yP?=
 =?us-ascii?Q?e/7PpY9aKKCT3ApohC3MhOy9bZH5AwnITZUtF9gwmx35egkcqtyowmx71/8t?=
 =?us-ascii?Q?Tw7vFvL3k5WoqEPuk7x21qnTaOytmttGIfRLIequRnpTBQJSO+ZyTei2KMzK?=
 =?us-ascii?Q?1RhyDFSRWOQnJpNRaRft+hnjnS3eIqkS43788AQGRq5TVeSDAe9Kjn00DUOo?=
 =?us-ascii?Q?/6t6DVxket1ZeKhfhRvVLlhMO8CYpYidu5m+MF0hJExTaebTa8YVXSxJBi7R?=
 =?us-ascii?Q?f7YhGr4co3v5H5wg9q2GPNKCESlOCkd06J+PPYdCeAfaEqdWzSOhLXWEoNG7?=
 =?us-ascii?Q?6igfCoxKMi9iMvDzft/+mia/t95dbcXV6MWzvcEGf3DqNzFU7YQgdg5nojz2?=
 =?us-ascii?Q?BAWLcypFPfLtBV0kL3DVwpwi5Wjn+W852igcPKQJIWJKJgVwf/M3DiDSJhzZ?=
 =?us-ascii?Q?2dN4G5TRIUTOYT6V7a+zKI0evzfAvgWxqYUBFGtUNUiv2qsE2+ZUcEo53t2+?=
 =?us-ascii?Q?O3W5kAcwvPl4I3ErIRe/gZS5XBbRi7W+AfTKtll1oDpyoV3cO9H7X5RVqHFl?=
 =?us-ascii?Q?1EaFRUs1eSVLlRtUbOnkm7I/aG3Tv21dvsbzMsXXrvt1vIla/XMPNEw0JPcs?=
 =?us-ascii?Q?kV4AbWuR66pD4zjMQ9Z3paeQAdzeo0KHdBLbMrVCUwFFFu4EzksqQerfldlL?=
 =?us-ascii?Q?y6XNK96RQ/+48uppevn7JVjUCAg9FB0X+2d+Haq9GXXgNiyTtetM3Fotblld?=
 =?us-ascii?Q?k5SKgzGwqw1p4Qc8xO4wMuIFx2KsSoPBqZLvi6GPOhTl84wJv/n5yfsWE1Gu?=
 =?us-ascii?Q?x/kgj7bjJBJfdAKI9kOE0WSMBdsVKx92nijGRfMi6g7fWv4044jLLU5cJTJV?=
 =?us-ascii?Q?6SIDzuSpk8UeEDSwHzHtu4RicE+nwKkUpkRH1ClS68C3HJPWwE9zxAkGo2RD?=
 =?us-ascii?Q?gjzj68/3dobaSGJ20VH4Z9mF16EtPleETaMnxFsWfQ/63L75IueZTCbG9ZIs?=
 =?us-ascii?Q?lEuYJo/W2cdi+i+jihWhnvYBLUPPrVwOMAGqyUO5WHtOkbx6S+eljtFS3H5I?=
 =?us-ascii?Q?ERwEY6cH6PublZobCERA843PaCHlafKYxDwCq5fknjXu7MrF+Qtc4Jk6hYdy?=
 =?us-ascii?Q?S3REzg0fjnGPiJsNBdmZMeW2p6x0EOmn8W3LJMHfamxBksXOSGeZ/pxGP/Vs?=
 =?us-ascii?Q?jWJBqdIDbj3WMWT3slrLJUMG5TufHRFwk3nYpAzKfCIzdsIJQwwVlrr94FF8?=
 =?us-ascii?Q?I0ZysxxkAEun8/8zhOWOvy7j6k36UoUa6U6OtfaIEIEGYSvEALAkxbs9afnY?=
 =?us-ascii?Q?LaeCxktwNHpXDa7FS7cPbOTi/9eFr9fQ2ePjGMglKuUTt51UewB67357XyOA?=
 =?us-ascii?Q?89/6k2sLvbn7vOr9MOnCSXUPAaf/soC26kL47cC/1nX9J5f6ZAQQ?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <692D63A776BDB744A420CEE7ED73C280@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ffcfb28-63ed-4a3b-dd09-08da11b835a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2022 19:13:29.7085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hRVxWr1OGraSLgVM5emOGw6iiULo7EMa013GFJ103dhD4+WlmAV5MpD7Es3RqH2TjpzsxlwiU5KqO6WVTI5rRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1607
X-Proofpoint-GUID: lc6Os9fKfu_krNaGV57VUU9rzssqhY9R
X-Proofpoint-ORIG-GUID: lc6Os9fKfu_krNaGV57VUU9rzssqhY9R
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-29_08,2022-03-29_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 29, 2022, at 11:39 AM, Edgecombe, Rick P <rick.p.edgecombe@intel.com> wrote:
> 
> CC some vmalloc folks. What happened was vmalloc huge pages was turned
> on for x86 with the rest of the kernel unprepared and problems have
> popped up. We are discussing a possible new config and vmap flag such
> that for some arch's, huge pages would only be used for certain
> allocations such as BPF's.
> 
> Thread:
> 
> https://lore.kernel.org/lkml/6080EC28-E3FE-4B00-B94A-ED7EBA1F55ED@fb.com/
> 
> On Tue, 2022-03-29 at 08:23 +0000, Song Liu wrote:
>>> On Mar 28, 2022, at 5:18 PM, Edgecombe, Rick P <
>>> rick.p.edgecombe@intel.com> wrote:
>>> 
>>> On Mon, 2022-03-28 at 23:27 +0000, Song Liu wrote:
>>>> I like this direction. But I am afraid this is not enough. Using
>>>> VM_NO_HUGE_VMAP in module_alloc() will make sure we don't
>>>> allocate 
>>>> huge pages for modules. But other users of
>>>> __vmalloc_node_range(), 
>>>> such as vzalloc in Paul's report, may still hit the issue. 
>>>> 
>>>> Maybe we need another flag VM_FORCE_HUGE_VMAP that bypasses 
>>>> vmap_allow_huge check. Something like the diff below.
>>>> 
>>>> Would this work?
>>> 
>>> Yea, that looks like a safer direction. It's too bad we can't have
>>> automatic large pages, but it doesn't seem ready to just turn on
>>> for
>>> the whole x86 kernel.
>>> 
>>> I'm not sure about this implementation though. It would let large
>>> pages
>>> get enabled without HAVE_ARCH_HUGE_VMALLOC and also despite the
>>> disable
>>> kernel parameter.
>>> 
>>> Apparently some architectures can handle large pages automatically
>>> and
>>> it has benefits for them, so maybe vmalloc should support both
>>> behaviors based on config. Like there should a
>>> ARCH_HUGE_VMALLOC_REQUIRE_FLAG config. If configured it requires
>>> VM_HUGE_VMAP (or some name). I don't think FORCE fits, because the
>>> current logic would not always give huge pages.
>>> 
>>> But yea, seems risky to leave it on generally, even if you could
>>> fix
>>> Paul's specific issue.
>>> 
>> 
>> 
>> How about something like the following? (I still need to fix
>> something, but
>> would like some feedbacks on the API).
>> 
>> Thanks,
>> Song
>> 
>> 
>> diff --git a/arch/Kconfig b/arch/Kconfig
>> index 84bc1de02720..defef50ff527 100644
>> --- a/arch/Kconfig
>> +++ b/arch/Kconfig
>> @@ -858,6 +858,15 @@ config HAVE_ARCH_HUGE_VMALLOC
>> 	depends on HAVE_ARCH_HUGE_VMAP
>> 	bool
>> 
>> +#
>> +# HAVE_ARCH_HUGE_VMALLOC_FLAG allows users of __vmalloc_node_range
>> to allocate
>> +# huge page without HAVE_ARCH_HUGE_VMALLOC. To allocate huge pages,,
>> the user
>> +# need to call __vmalloc_node_range with VM_PREFER_HUGE_VMAP.
>> +#
>> +config HAVE_ARCH_HUGE_VMALLOC_FLAG
>> +	depends on HAVE_ARCH_HUGE_VMAP
>> +	bool
>> +
>> config ARCH_WANT_HUGE_PMD_SHARE
>> 	bool
>> 
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 7340d9f01b62..e64f00415575 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -161,7 +161,7 @@ config X86
>> 	select HAVE_ALIGNED_STRUCT_PAGE		if SLUB
>> 	select HAVE_ARCH_AUDITSYSCALL
>> 	select HAVE_ARCH_HUGE_VMAP		if X86_64 || X86_PAE
>> -	select HAVE_ARCH_HUGE_VMALLOC		if X86_64
>> +	select HAVE_ARCH_HUGE_VMALLOC_FLAG	if X86_64
>> 	select HAVE_ARCH_JUMP_LABEL
>> 	select HAVE_ARCH_JUMP_LABEL_RELATIVE
>> 	select HAVE_ARCH_KASAN			if X86_64
>> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
>> index 3b1df7da402d..98f8a93fcfd4 100644
>> --- a/include/linux/vmalloc.h
>> +++ b/include/linux/vmalloc.h
>> @@ -35,6 +35,11 @@ struct notifier_block;		/* in
>> notifier.h */
>> #define VM_DEFER_KMEMLEAK	0
>> #endif
>> 
>> +#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG
>> +#define VM_PREFER_HUGE_VMAP	0x00001000	/* prefer PMD_SIZE
>> mapping (bypass vmap_allow_huge check) */
> 
> I don't think we should tie this to vmap_allow_huge by definition.
> Also, what it does is try 2MB pages for allocations larger than 2MB.
> For smaller allocations it doesn't try or "prefer" them.

How about something like:

#define VM_TRY_HUGE_VMAP        0x00001000      /* try PMD_SIZE mapping if size-per-node >= PMD_SIZE */

> 
>> +#else
>> +#define VM_PREFER_HUGE_VMAP	0
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
>> 	return find_vm_area(addr)->page_order > 0;
>> #else
>> 	return false;
>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> index 13e9dbeeedf3..fc9dae095079 100644
>> --- a/kernel/bpf/core.c
>> +++ b/kernel/bpf/core.c
>> @@ -851,13 +851,28 @@ static LIST_HEAD(pack_list);
>> #define BPF_HPAGE_MASK PAGE_MASK
>> #endif
>> 
>> +static void *bpf_prog_pack_vmalloc(unsigned long size)
>> +{
>> +#if defined(MODULES_VADDR)
>> +	unsigned long start = MODULES_VADDR;
>> +	unsigned long end = MODULES_END;
>> +#else
>> +	unsigned long start = VMALLOC_START;
>> +	unsigned long end = VMALLOC_END;
>> +#endif
>> +
>> +	return __vmalloc_node_range(size, PAGE_SIZE, start, end,
>> GFP_KERNEL, PAGE_KERNEL,
>> +				    VM_DEFER_KMEMLEAK |
>> VM_PREFER_HUGE_VMAP,
>> +				    NUMA_NO_NODE,
>> __builtin_return_address(0));
>> +}
>> +
>> static size_t select_bpf_prog_pack_size(void)
>> {
>> 	size_t size;
>> 	void *ptr;
>> 
>> 	size = BPF_HPAGE_SIZE * num_online_nodes();
>> -	ptr = module_alloc(size);
>> +	ptr = bpf_prog_pack_vmalloc(size);
>> 
>> 	/* Test whether we can get huge pages. If not just use
>> PAGE_SIZE
>> 	 * packs.
>> @@ -881,7 +896,7 @@ static struct bpf_prog_pack *alloc_new_pack(void)
>> 		       GFP_KERNEL);
>> 	if (!pack)
>> 		return NULL;
>> -	pack->ptr = module_alloc(bpf_prog_pack_size);
>> +	pack->ptr = bpf_prog_pack_vmalloc(bpf_prog_pack_size);
>> 	if (!pack->ptr) {
>> 		kfree(pack);
>> 		return NULL;
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index e163372d3967..9d3c1ab8bdf1 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -2261,7 +2261,7 @@ static inline unsigned int
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
>> @@ -3106,7 +3106,8 @@ void *__vmalloc_node_range(unsigned long size,
>> unsigned long align,
>> 		return NULL;
>> 	}
>> 
>> -	if (vmap_allow_huge && !(vm_flags & VM_NO_HUGE_VMAP)) {
>> +	if ((vmap_allow_huge && !(vm_flags & VM_NO_HUGE_VMAP)) ||
>> +	    (IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG) &&
>> (vm_flags & VM_PREFER_HUGE_VMAP))) {
> 
> vmap_allow_huge is how the kernel parameter that can disable vmalloc
> huge pages works. I don't think we should separate it. Disabling
> vmalloc huge pages should still disable this alternate mode.

Yeah, this makes sense. I will fix it. 

> 
>> 		unsigned long size_per_node;
>> 
>> 		/*

