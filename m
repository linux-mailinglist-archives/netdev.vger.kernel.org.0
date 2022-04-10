Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B194FAB66
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 03:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbiDJBhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 21:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbiDJBhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 21:37:02 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEBE289A2;
        Sat,  9 Apr 2022 18:34:53 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23A0xRwX011688;
        Sat, 9 Apr 2022 18:34:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=b1hvu3TXAhQ1TJQxwkj5YSfgoCgaEa7irK3geL1RJyk=;
 b=HN9Ow8hiiTvRNc6VwCxJV2Oh3ULHa65ZbaD1NvgBWuKdiwvuZ3Eq/Leyv+YoRBeG0s5/
 bxlMvmIJpXYvnWefmd1p98ciDcH+ajwrbyvMIXFvji6OMnhXJAkOdckkJ1SQ89BXblYu
 qYZfuXYwKzzxnFzmuMOTQXRp4iR1au7XRVA= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fb9f326sr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 09 Apr 2022 18:34:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYHMJt9fN6Gnk4Z2Mw0y8oz8GC+EDzvH1hhXCEeinUeP0v8aykY/Yn9pAKsatcdzQ9r+7nqjsTOJdJBGCZ/GUXwBBE8PF96aZE4cclAFyci2345MlC3DR+QkgURh3Z6X9QUV6mWNcYy4r1t0OYS8R0f1yi8g2Jwmmpq5Z1i7OvPSvSP65QLTK1Nf1+juW0jfVeEjWUew5r0Ngm+2ckLwfnpxLkfPSERIO12qVaNKRaSfH4C26jOphAd14e/BqNY9E9TG1j7yTkezROSfL6lFpeIHdW/0MIKkpl9u/ptQTLkP9QsHubqFdhhmoMdbUnQEYXxPg+nAG27nExC19/kpzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1hvu3TXAhQ1TJQxwkj5YSfgoCgaEa7irK3geL1RJyk=;
 b=fCwSAHEHvslaf+ybgiT9i/7TpGGDYV5LljlSBTjSDYkMbFVt1zIyYrxNbnY31Y4BvrQakGJ6bKVVLnZsqBLUDzwBwuVkZzJXmWpM6kN1mrHj0QCIymcfmvyn2Had/sI2KrfqefI43QQxc4AuI7cEHPsb8gpLZM461vvdqEavhDrfdslE1JK6tvZsOyukcXXKfl10tT5LN3S8B1Yfx/u9rRJn1vVvSVaWlO1dxhfonPzQxE3B6KAJ3DMZb4hi1bU0VzdI+3ygayqqRuSuzPsL1s95IwsGqyhg1cIqiE6aB7Cmhor3Rc9jh2WuX3a8/ihXckmgo2XrdfEECwKkDrle0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA0PR15MB3869.namprd15.prod.outlook.com (2603:10b6:806:8c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.28; Sun, 10 Apr
 2022 01:34:50 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e150:276a:b882:dda7]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e150:276a:b882:dda7%8]) with mapi id 15.20.5144.028; Sun, 10 Apr 2022
 01:34:50 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Song Liu <song@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>
Subject: Re: [PATCH bpf 2/2] bpf: use vmalloc with VM_ALLOW_HUGE_VMAP for
 bpf_prog_pack
Thread-Topic: [PATCH bpf 2/2] bpf: use vmalloc with VM_ALLOW_HUGE_VMAP for
 bpf_prog_pack
Thread-Index: AQHYS5mtQh1GNVF2tku0imT819YdPaznDoGAgAFQoYA=
Date:   Sun, 10 Apr 2022 01:34:50 +0000
Message-ID: <B9CEF760-23C2-489A-8510-2CC6F6C3ECB8@fb.com>
References: <20220408223443.3303509-1-song@kernel.org>
 <20220408223443.3303509-3-song@kernel.org> <YlEZ1+amMITl7TaR@infradead.org>
In-Reply-To: <YlEZ1+amMITl7TaR@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2c65d41-3e20-4b35-d309-08da1a924e15
x-ms-traffictypediagnostic: SA0PR15MB3869:EE_
x-microsoft-antispam-prvs: <SA0PR15MB3869EA38C4D23099CE4015EEB3EB9@SA0PR15MB3869.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9lTfuJ64Va5B3z8lO6KgeSpyFK2620YNrLTuCTNH18ktWka0M8970pBE8Q3tPobhQS2tJlFGQ96SGQKPoem9xTvzFMcwQeCwCNY5HbpW6bq38Eo1JbQuzqAAOMTOE2jfhVbfWtqeGGK96YpfU0GS+vXecETynXg7fCB7X6HGMxuQMMqMbFy/AMcGvsW8GmX3vqUwJtMdqJlRWNaFk17S3zEErl7zLVU7kx/qecZ2/LXDON1fSdaxBPVMVovNSiUbsp1BYVhNZT06SBcE4hiuYpOFR+stHmGwZ+pbKEWssNIJbU2QCOflPRu5ryaAPCR2/e4LLFkFa283/uFH0nTOi0f7Xuxz99tNLzYZYVD3Mpr4OPSU474Zp7E+JsxixeeQTq9AENBo+J+wJ9xZaPBXoooOhUHrmGPZwYWFbSKxNy6HmRmYywFEsgB+Fh8hjt65XArhbWqQEFfiEAEZfHkomYZuzZvFhUSsnin0/oiHziBN8cwCmhQBnLwEGxt33sjReubcCOYartsWukjWNzxRcuiXGV7j6+pAx5Ayxbg6q9aOiDCII2JOeqhLE5+dDfdD1GCFfEyYvHPIRnNe3FZEqHJDgxZMw1g9OGbMmJjpE0tVafPY4+Jus+ECToGulE0IYplxmOSLtF5n/R7RIluduQuWP9Td37L//l06VYQzu6ajIRthc4uxpwwoUEx5KQtc2HbHU4MkYX0eN0w/nNhyMBOsJqc/FrhlUAKBc6s/1b+aMQt5JTVqBb703LX/yCGxsm5Wt3NJmPIO0640LNIoQA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(38100700002)(86362001)(2906002)(122000001)(5660300002)(7416002)(8936002)(53546011)(6506007)(6916009)(2616005)(6512007)(54906003)(71200400001)(36756003)(6486002)(316002)(64756008)(66946007)(76116006)(66556008)(33656002)(8676002)(4326008)(66446008)(66476007)(186003)(91956017)(508600001)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h9Lh7RJ+kfCj/gAfikc0ty2z6M0sQXhWdVF0c7g0/Cz0LRaYFHTCFNyRSoN/?=
 =?us-ascii?Q?tetVisbI938j+J88UJrooewCTwWffI0QjyqH+XSLdFSNl2pNMVQp6EblaCmH?=
 =?us-ascii?Q?pztb+IQ5fC5k8Pdl4gPCtSjwbVOdIe3yTyVg7kNx3h6dYoFD4p/2TcxHfIM7?=
 =?us-ascii?Q?k2yWBPlDQdvo6UgHmx8KHh/EQvSXA8vGTIovMB1DbaxNw8i7YYXSUGLgXdwZ?=
 =?us-ascii?Q?5SVeZKF9kBQRE1VUn4oisL+u4ZCfmF6B7p8qjGBH3lZFiG7giW0dv1olF65A?=
 =?us-ascii?Q?jBRZvGujEiY1pUtM73UjX6KcnxU4ybrLd8bi2ArfdwVLntzbANGEQ/lcC2yk?=
 =?us-ascii?Q?fJFQTTnGjQ6WsXRNLSYZOtTol5RUtd77shIGfzXYgZsNQ21xWPlb5aQU16fW?=
 =?us-ascii?Q?IKGKgBp4X55h8/ni8O/GZN0hm1bgF2AFW5xhef+CCouQ6ZOt+c4SWZzTWIuV?=
 =?us-ascii?Q?AD2aCX5DoQFMRrBU1+EX+TCOags31nSpq0fC7RGtgfyzxWBvWMKuL40jbsnv?=
 =?us-ascii?Q?GSVXGQ+em5JUKY01RhA4ODi3qC6kL02M96pmQa1ynjZzWKRHil1C93Flmwdr?=
 =?us-ascii?Q?5UTQ8fE78kx5p2Jbj8wtOE48AQaD7sqhtQFamZ1ldUYnNBiwngmlrOnlSpcj?=
 =?us-ascii?Q?8LLLAKgxBRpa/OvC1UesJr3xpXnu+nR7L81ubeIspPqAqqr2LEJNtkU86fz1?=
 =?us-ascii?Q?ppku8M6d8mhZmchAtsiafRvBA0sgwfrEN0GWtB0Eima3IqLxabSfHmJoX5+b?=
 =?us-ascii?Q?Q+iQRSjmAW18ZvnW9Z91waTRjWnhv+Uh+0EVjpPGp/Edj4VCa8248+A0odMU?=
 =?us-ascii?Q?XajBy8+gc3bjETz4mVNxUCf9+cM1HKdcWr3bSVnR4B5odUQBqgexl+fpg6or?=
 =?us-ascii?Q?drORk8uCe38de1ST2K5Wvi6H318CM0W2KTcSM20U6DbS9TjO/4i96DDKst3T?=
 =?us-ascii?Q?2JarsZnbWaXqI/r5TINrLqjcZEuLqeB8/ZVQIJqqA428oY037i45FSRXrmb4?=
 =?us-ascii?Q?YBO3pFj+m0w5Wj8wizlmVMi1PKhBoFpnkwjLr6w6OVGZBQdAQlos8yX/43ut?=
 =?us-ascii?Q?nRLl51QCtiH5+vh0HQLjY9M0RS7C3mT86rxBZIyOiQGRv1qQQ31ZIeT/h/AC?=
 =?us-ascii?Q?DroQgRLHLxout4/JPtxgcdxjQpqwn5HreDMYuQJSZHAb4aIrvLyMKpkx2DSa?=
 =?us-ascii?Q?EUFvQoaRepdEEdB1vB5MU4utiBmy273s/EliSuGCUxKTgCReFXAz030Ro3Wi?=
 =?us-ascii?Q?YMWmdbnnuR7YcdLopC9Ia85w3MlkR67Xy2yISTYJ8ooDYy5oc0CPQnkonHgE?=
 =?us-ascii?Q?LGbKVoPQztRqXWpsmZWQ5t0ieMWWItZThoGcGwN5ZY4Ee6due1cKs4oUy/qd?=
 =?us-ascii?Q?6QXo6AjG2TNDfkVkKWWhHoYKUv4UZ4DYltmmoRQwIztmBhJIyf/kJ2LIqkRA?=
 =?us-ascii?Q?qm0+kpvWieTrzFtlVCVkX88O6IkCP0N7bPCLmCe75rymo3ktCKrXF7Y43+vE?=
 =?us-ascii?Q?vAOtCHMWT/Qpx0JtQ3TpyjiImh9NqyeVQaUlEE5E2rD9zRGRsW63J0LfKtFE?=
 =?us-ascii?Q?dSO8AiHzYR8xkcFJJxQz8QAI456yHN/Bs0+/EF11ruvGwT6lsIcl3dClpQox?=
 =?us-ascii?Q?qtlSl8C9q+pRzLTu0LUApPbqMRoNp4CZEpfxJInEAownt0kjwH60nkURwU+q?=
 =?us-ascii?Q?AdgDwgJklFodKClc8oj8iRlhZbLr0CdNX1uNIN2BXJRZLBllXWIlpy+AJ+zs?=
 =?us-ascii?Q?hz7L8rziylSfTp/hh5GQE18mJrOYexqLyiDiT7f76GKXb7hU9Ziu?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CC0A5E5A44EB5E44BCB068BB739514D9@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c65d41-3e20-4b35-d309-08da1a924e15
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2022 01:34:50.3322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fUGtfkCEMNo+Gx+leDK0ekshorTCErN4HARsupqbYGNvx2owdWJ8ta7bZWjGh9/0d17vGIfFPVkFpRit4MBMRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3869
X-Proofpoint-GUID: 0l0kO1m9jV6ylUpHslfEOECgY-jvw_KO
X-Proofpoint-ORIG-GUID: 0l0kO1m9jV6ylUpHslfEOECgY-jvw_KO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-09_25,2022-04-08_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 8, 2022, at 10:29 PM, Christoph Hellwig <hch@infradead.org> wrote:
> 
> On Fri, Apr 08, 2022 at 03:34:43PM -0700, Song Liu wrote:
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
>> +	return __vmalloc_node_range(size, PAGE_SIZE, start, end, GFP_KERNEL, PAGE_KERNEL,
>> +				    VM_DEFER_KMEMLEAK | VM_ALLOW_HUGE_VMAP,
>> +				    NUMA_NO_NODE, __builtin_return_address(0));
>> +}
> 
> Instead of having this magic in bpf I think a module_alloc_large would
> seems like the better interface here.

AFAICT, modules allocate a large piece of memory and put both text and
data on it, so modules cannot really use huge pages yet. 

OTOH, it is probably beneficial for the modules to use something 
similar to bpf_prog_pack, i.e., put text from multiple modules to a 
single huge page. Of course, this requires non-trivial work in both 
mm code and module code.

Given that 1) modules cannot use huge pages yet, and 2) module may
use differently (with sharing), I think adding module_alloc_large()
doesn't add much value at the moment. So we can just keep this logic
in BPF for now. 

Does this make sense?

Thanks,
Song
