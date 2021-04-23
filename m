Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E30B369A5F
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243721AbhDWSrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:47:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28358 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243716AbhDWSre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:47:34 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NISAH4025186;
        Fri, 23 Apr 2021 11:46:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=90LGfudfZ9+W6qy0LmWy78w9DRd+hIBzhRsrKrwuVGQ=;
 b=icz/phwSwGiro0V1WM5ZOkKs/V9qKcOQaz9ISqAPsKAr1PMPO65QRY26QJTam+1hLK7g
 rOACi8skAMWddLz2D8DeO7pJbZwYsV2qUo9u6Xwcu7OeD4XnBUncQ6y/+F1X1dWdd2RU
 Iq9uRluR6p5enAxk8ZT+GfutEPEC0XUActk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3839sh8qa1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 11:46:45 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:46:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mUBQjBztY6QO0qJgWIMNNjES/vNeIDU2lueiGCB82Yj+pTY2wJlv1H/B6uSC6x2TIgwTFhQW0N/8FZ4X42F0jdtHQSuBif7GnTU7LfnsvuiQF1u1gRhkkKqe/TYMmps0SyzEigDcN4mc0oSzKmit8hFsLcn6dt8iuRrflWQu3InGUwy9aO7O7KAQhXLq2CfEEdkZ/tgm+VUXYdX+MJSpA+DM62noUPBaRjXG2/XxU2IKJN/ma7i2XRQyjzZ+hmSduAiTWw/WsJSLdS4J5HXNUxQP8bAbDqeqQgyG1fOmKJTj/mt99BQxBHhpDnujBCYaWKS/1C9H7ubonOSknQKmHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90LGfudfZ9+W6qy0LmWy78w9DRd+hIBzhRsrKrwuVGQ=;
 b=I87l3sCJciEjxuc3AXsk8MkSsJ0/91QCakGS/OiZc2e+1FOaiF4+KwmBumn9m/m9PdHPFCnw4yTZ56Iw3CBG9Tk4RPlERaD/VzyvToPXW0Z3l+KGsbkRhllvfCR677T5z/geraQQkc6REq0uCNin3ikVDjHrDrPBwJig8ohSaaZIIkpACOsLE4YEs8MXMP3QUP9fepfd9XzFtOisM6b0mf9XeWMLBQXniMkOnbSSwYojjIYFOZ1lt5bORZkX10thVeGflzzjauZj0LHQuDkE4BUgC6nLoE+PCweStpy08b2Njb0j58P9np0gGSNgE3YigZPnAUi6bb2wRJ+4Y6dYow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN7PR15MB4159.namprd15.prod.outlook.com (2603:10b6:806:f6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Fri, 23 Apr
 2021 18:46:42 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 18:46:42 +0000
Subject: Re: [PATCH v3 bpf-next 11/18] libbpf: add linker extern resolution
 support for functions and global variables
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210423181348.1801389-1-andrii@kernel.org>
 <20210423181348.1801389-12-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <56eaffb0-b9da-371c-d1e1-6ae5f998e158@fb.com>
Date:   Fri, 23 Apr 2021 11:46:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423181348.1801389-12-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bc07]
X-ClientProxiedBy: MWHPR18CA0043.namprd18.prod.outlook.com
 (2603:10b6:320:31::29) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:bc07) by MWHPR18CA0043.namprd18.prod.outlook.com (2603:10b6:320:31::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 18:46:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0de516b3-035b-4966-1056-08d90688234f
X-MS-TrafficTypeDiagnostic: SN7PR15MB4159:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN7PR15MB4159D60450AF33B03586D392D3459@SN7PR15MB4159.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eIrAnKTO0X0N5I/kvF8IfbRXqqoduGS2hw7rS9LMtYhl0M481nxUc5D8/PTcKF/OfFqyerE2SubmGEsdpFXiwZlNLsvURZhqSqYCP55EbGS7kfy5aIuU25M7OD0gb813DW0hxGePebuOoXiaevJKbPzMAnrTywCVVU8cDBZBZ4FeEWVHPH6/0tz8hLx3xhPBUWEdXo58B13Ikfo34XtXXL251xi2VsKo1HUkUgyJj0aJIWIN4mLMMwu3YgKbXD94vRMIgmx6vk3sjfQGzMiyQ0kgeARHtMRmV6fNcI6itSL5+/z315pTAYqUPuMOeEGiK96VFNMwZOd5esQzIlBzvDXc4t5EpgY7cvwvZU8PQwNCoQJg8KSw3Dx8O5mLMM4mq2hOcJdjyjfLv0T5XVWKBlVZS2gTPFPoF3mYkHNr13V4FzCCQjPiQoj2evWlpvYPZhqvmq9VAYrGmUwIsDA0pfavAivMsT+7iGG95aSNUEvsHz/EreT7lQEExDlxCITjXv/o2wtBkP3rkq8RjRXyYpPKlS7q5O6joJMhk0XCzlbj9bPdRNP8dP1voS4+hKN78nbBurFTMlxafnkh7/uZcUIVd/70YmaGJSYHja1I2Lds7ThXDVmAvDitVZD0uNCoJ1EleCyHpXZr/Euo51b+KxQHRSi44SfLQhh0y6Hp9NpO+aWXXazDcLbo65qtvn29
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(136003)(346002)(396003)(8936002)(186003)(53546011)(86362001)(66476007)(36756003)(2616005)(31696002)(83380400001)(8676002)(52116002)(31686004)(316002)(4326008)(5660300002)(66946007)(6666004)(2906002)(16526019)(478600001)(66556008)(6486002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VUVTVk1EbHc3ZTJJWS84TGpYL2F0aDU5TGoyNmtIL0JrMGdtMmhzRWRBYzkw?=
 =?utf-8?B?c0RZQmRWUk11bmdLWW82L1I0cE5pd0Q4dzA3YW0xa3R0TzNBajF3Nmp0RTl6?=
 =?utf-8?B?ZjA4cmRmdi93R29FQ08zbDFqeWdDc3YvWlh0ZnFnY2RyM3Z6UGtFdlpTTS9a?=
 =?utf-8?B?RVd0MWJNbWQwTWxXOVdNa1RyWUFRVm9FTGNUKzZ6RS9TN0lXZkp5S0NPT0pE?=
 =?utf-8?B?bS83Y0V0RHdub3lvVDA4WTVVODg5OUdqaTNkUXdDWHZtendxTVdrRklpUk12?=
 =?utf-8?B?SDVJakJGRUNJKzV3Z1VBekZCdVNkN2w2UnY2VURySVhWVHhNWmh0QnpDaHI2?=
 =?utf-8?B?V1dWT0R6clJodVdrb25HSVFjSmZad2dSZnNXczY5MXZNVUFjQTFiVnpVWDUr?=
 =?utf-8?B?dktGVkZ5Wk52KzQxRWZUeVBURi84U3M1OVVaeVRRMkpubnBoTUk0QkhCTHFQ?=
 =?utf-8?B?YzFSNitrOVpRcEtJSWlZU1VWVitHT3A1UGkzYjlqS0NzSk5sSk5EVmxWclNR?=
 =?utf-8?B?Ti9zT0hYTkRld0draXFxWnk3Slo0L1hIVU9xdWhmY0dlRFZueUtVRUZQQnFh?=
 =?utf-8?B?Q3Y4a1h1amdOemRSWTE3WEY5NW0zWWx0N0JYYnhZenBkVWovUld6aHEvY29G?=
 =?utf-8?B?Qkt1U1BxWVBHRitUZWRTbEFnTnFFdnYvWjU2VXhHclZSV3pHUElKWGlhNjM2?=
 =?utf-8?B?YnNTbkVCSG1sV1ltRXF0bFg1b00rOEw1eE41ZWxwZzNrTzNqRlBHOGpoRUNI?=
 =?utf-8?B?ZGRHcFRtY3Z1Q1J6MVlGb0FuQWF4QkZWWGlzbGZldmdYTElmbTV3bkV3cko4?=
 =?utf-8?B?emluSDJXTE5jRUZ0WURGOW01WG4rS2NEbTlPelVOdWlNZFdzeFpOZjhlZTlh?=
 =?utf-8?B?NjNrelE4dGpwWTY5RmJFV1cweEhTNS9RVlZLTGZyVk0xengwb1ZpbmpEVGVa?=
 =?utf-8?B?WDNldXB2SEROQisvajZGTjRyck8rL08wN0tETkkyeUJMZmdQVk9MbzhTOFNv?=
 =?utf-8?B?ZXp1QnJlUkZ4aEFWZDJHd2gvbUUwWk5pVUs1cjhBaWNyQjg3RlhIMk5MNkdJ?=
 =?utf-8?B?bXlLS3Uwc05UOHplU3pubjhJT1ZuMmYrQUtHSXQ2ejJGclJ5amlpdjNKTEJj?=
 =?utf-8?B?Ykg2SzRNYzNrWWt4aUw2MmxYMHJZZHMwdXAwb2tXN1hGcFN1aDI3aFlzSGhn?=
 =?utf-8?B?bDNsNWFhd0hheVgza2Q0SHhwdjVEck03cXlKU2pSYWVRRU9HK1dFYWU1TStP?=
 =?utf-8?B?bzNybUdFQ2NscTRSRnFsWWQvSEMvZGNNckpQcThtZkppdFFNZmovN2FxRFlY?=
 =?utf-8?B?SFJ1RG84aVRaL04wUk1zbGZ6Ni9LNEhwRk40MzFad2RXOTZkY3AyVjZKbFl2?=
 =?utf-8?B?MUN5TGhxK051SXVuenhFeHFsc3FscHJJa2JJS0xWWVozWVRIemZTUGtnU3Q5?=
 =?utf-8?B?L3FIOXhsL2ZDd0dSWG1PYmdsUXNVMHovOWpmSkFvQVRoODYwZ3lwUnNHamFI?=
 =?utf-8?B?SFZ5WW9hQVMrQmEwODFYYjFJL0ZGMWVSeDU1QzZuU2RGZkRabWEybTZIS0M3?=
 =?utf-8?B?c0NxU21FUm43dzY5cm9zY25odkIrOFptVU9iZ0dpMkptY3ZxdG5XN05JQnY5?=
 =?utf-8?B?MXlIcVZSZmR2VUhtaFZpbkJKU2JmZjAxK2FTM25GaGtVUktSTTBiOHFBUE5W?=
 =?utf-8?B?YnBXTWoyR1BWQUI4VXVoTkFzY2N3Z1VaZ3J6ZFpjRXVDREtCYkJ3ajJXZUtV?=
 =?utf-8?B?VEs0dnFPQTBVT0JWQll5M0U0VnRyT1UxeGhjWHhDYzJuaStGdmxBSzVUWkhh?=
 =?utf-8?Q?V2QoCMcjsGba9gKzUmYfpKwTtgboxTbHZNhIk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0de516b3-035b-4966-1056-08d90688234f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 18:46:42.8098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7hMs0c8JQROyF500XduWHOx+Zeg7zmHR2YwxdbahopUyXqqOIpaXzQ29axFqX11r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4159
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: pe8SDtlsj2azg6PrnJep4iH_PKCoEJbt
X-Proofpoint-GUID: pe8SDtlsj2azg6PrnJep4iH_PKCoEJbt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 malwarescore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 11:13 AM, Andrii Nakryiko wrote:
> Add BPF static linker logic to resolve extern variables and functions across
> multiple linked together BPF object files.
> 
> For that, linker maintains a separate list of struct glob_sym structures,
> which keeps track of few pieces of metadata (is it extern or resolved global,
> is it a weak symbol, which ELF section it belongs to, etc) and ties together
> BTF type info and ELF symbol information and keeps them in sync.
> 
> With adding support for extern variables/funcs, it's now possible for some
> sections to contain both extern and non-extern definitions. This means that
> some sections may start out as ephemeral (if only externs are present and thus
> there is not corresponding ELF section), but will be "upgraded" to actual ELF
> section as symbols are resolved or new non-extern definitions are appended.
> 
> Additional care is taken to not duplicate extern entries in sections like
> .kconfig and .ksyms.
> 
> Given libbpf requires BTF type to always be present for .kconfig/.ksym
> externs, linker extends this requirement to all the externs, even those that
> are supposed to be resolved during static linking and which won't be visible
> to libbpf. With BTF information always present, static linker will check not
> just ELF symbol matches, but entire BTF type signature match as well. That
> logic is stricter that BPF CO-RE checks. It probably should be re-used by
> .ksym resolution logic in libbpf as well, but that's left for follow up
> patches.
> 
> To make it unnecessary to rewrite ELF symbols and minimize BTF type
> rewriting/removal, ELF symbols that correspond to externs initially will be
> updated in place once they are resolved. Similarly for BTF type info, VAR/FUNC
> and var_secinfo's (sec_vars in struct bpf_linker) are staying stable, but
> types they point to might get replaced when extern is resolved. This might
> leave some left-over types (even though we try to minimize this for common
> cases of having extern funcs with not argument names vs concrete function with
> names properly specified). That can be addresses later with a generic BTF
> garbage collection. That's left for a follow up as well.
> 
> Given BTF type appending phase is separate from ELF symbol
> appending/resolution, special struct glob_sym->underlying_btf_id variable is
> used to communicate resolution and rewrite decisions. 0 means
> underlying_btf_id needs to be appended (it's not yet in final linker->btf), <0
> values are used for temporary storage of source BTF type ID (not yet
> rewritten), so -glob_sym->underlying_btf_id is BTF type id in obj-btf. But by
> the end of linker_append_btf() phase, that underlying_btf_id will be remapped
> and will always be > 0. This is the uglies part of the whole process, but
> keeps the other parts much simpler due to stability of sec_var and VAR/FUNC
> types, as well as ELF symbol, so please keep that in mind while reviewing.
> 
> BTF-defined maps require some extra custom logic and is addressed separate in
> the next patch, so that to keep this one smaller and easier to review.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
