Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1FB368928
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 00:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbhDVW47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 18:56:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5508 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235502AbhDVW46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 18:56:58 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13MMrkbP006641;
        Thu, 22 Apr 2021 15:56:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=E8JUdDTAQtyArEOfehaMNfqFPpv47yGk1NfYY6wTAWY=;
 b=lozOJVg5Vo6CBmm8Nj6w+70RpONHfqs5eSc7Tl8pu09e97l8iGlGELVDWtjz1YauF8po
 K/CZsmS7Wfae/MtAdl+PyYmb4Zk4x7snbXC3cgM/EnRRyu98fZIun0h/jj9Dhm7F1x3D
 5PwO6VjFV4KQcAVIZrd/VoJoaxkwkNtx7SA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3839sh3f2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 15:56:10 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 15:56:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=id/FQeLi/0Exg9vZiXlCMGTbPdG7Hu7n9Hyq6YahfyQFuR0/iFpolEmM03+qOH7e8panTgTMA4RWKpOh9nB7CfyaYRXYyE6AD13i8OqRIElOl6jnP18cObkQmgcwQeampCWjuTnfnFpKMnL6yWfj0Ih+6G/HOxQ0uCX+WxvofLC9j/k39VoYxFrM9HR9mPidMBkLa0oAhQO0ANMqsbrDByTYkxWEsZGmT0LtZsM8+e9JcZDi39v0kUoZHOU4wGesQHIntsBUm6NdBzqSlk2zW9IFwvHwpGJYF3SWJCePFohhuXi17+GyGhaEHe+v4l+Gcbrfr7ucVzzno4Kjj0gvyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8JUdDTAQtyArEOfehaMNfqFPpv47yGk1NfYY6wTAWY=;
 b=OEp+UrA9RVmzmEKDDvP6a3w0baaoJgpieohB1G8xysTRLjHq8YMgbYt64u/GpyWIjwqDP11cpFaTvpM8J9KjfYx5wH+uS1uLmOoIybq5xBB7yoeWnyC1fCnkfPe34QJ14liZSLHJUIeNf66FXSSFuaaHkGNyiAiD8NQ7gNW1H794PYqVOfAsyhJGXtI7fdXt2VGkwxd4N2GLTvz/47Ca6enZWYHN2Zt2EaeWdnj8V9xNmJxjBhtuZEK7734cw+i2MAFGLyqftXMoHqYzfdQLGPhUJYm6TUMagE9T3WrgGdspvyRu39eg6uiywLatiHJG2X+ZPEXhkfL2WkE2b64BVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4450.namprd15.prod.outlook.com (2603:10b6:806:195::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 22:56:07 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 22:56:07 +0000
Subject: Re: [PATCH v2 bpf-next 12/17] libbpf: support extern resolution for
 BTF-defined maps in .maps section
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-13-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d85c8d5a-7eaf-1d6b-afff-7fddd2083982@fb.com>
Date:   Thu, 22 Apr 2021 15:56:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-13-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:83f]
X-ClientProxiedBy: MWHPR1201CA0015.namprd12.prod.outlook.com
 (2603:10b6:301:4a::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:83f) by MWHPR1201CA0015.namprd12.prod.outlook.com (2603:10b6:301:4a::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 22:56:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cda86f3c-7ee4-4cbb-9166-08d905e1d083
X-MS-TrafficTypeDiagnostic: SA1PR15MB4450:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB44505BB1BF1869FE7AFE71BBD3469@SA1PR15MB4450.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CpoqgGqwgQ1V9iKa4//YOdQB14/FKs5kaDv85IizmVeVTsBZKriV/WJtzSf9Yo2z+DlmieOYvtYBwFbx2Eq73zcgEO7JSJd9Pi999298NbXbGo2iBXrUeucP83ATOLT9rziTzvgneKahOAGWssxxhXgHP06+ey42c5NdDaTQfIpUBt6Vvm36roYsbz2+AYIzj9JCz49Ba2wB9oO8SXFbIc79vdP4RCjSL4oF7YrnJEjrZiSU284Q5g38GabMGk/wl+xgLTXbcSoxAs9lULgqFugKyWCkmuG2v+frl40bUJPt41Fa7D0L7VdO+vexOs9ashwX1hT+ro/RfrrgQEcUpadjv1EueFE+fCG5v/qDtg0IrdhimKHtyL2Ca0EU4BJ1GIwu4qRmBSoPSXQ+VTolPTXckfO7JFXaTCkTjU7FzViJFVLDkLnsH3HbTqViP4MMtlD0ETEvaLXSvb17G5hGDcXV+R4q5YNxDXnGaNL3L4es5GfaLH7LXekushiKZEi1Q1zJtC+KFaAVvNrrSpA7e4JkybhG8kVCGYgusT0v8dBJyfM1Xh1VjGsWEP0BVs/1V8JxC+4AtUniBcxoovAdFKdxYytuNu1Q6TGbGnFQ0jbOhrMnccMvfNrFoYa1Sbw5cordKX90X9RAIMiLUF8WYh6HiZoMRfUicf5l88mnQtj+x9HjIi295RAxTgqCh1GTgZD01QOJNBR9TxV+CNhzuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(396003)(346002)(478600001)(4326008)(66946007)(316002)(66556008)(5660300002)(86362001)(66476007)(6486002)(2906002)(31696002)(52116002)(38100700002)(186003)(2616005)(16526019)(53546011)(8936002)(8676002)(36756003)(31686004)(142923001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RjkxZ1Yxd3BwZHMvbkpRVWVqdzBsVlJGdVRlUkVSRGxtTjB0UUdpUGg4R2Q0?=
 =?utf-8?B?YUYydzFuYkNGam5lejVyUmdIMkhLa1R0N1Z4ejlOa3lnQUl4MmVSdnB4L0I5?=
 =?utf-8?B?S3hFdkhDdG14Yks4R3I5bm9PaFJnSEpxVE1NclJzakpEa29iOE1lZnlyTG9W?=
 =?utf-8?B?a0tvZVNTVEtxMlp2dFA2L1YvSVBhNnczemRGUy9QL3ExQzZndXkxQ3RyeXZS?=
 =?utf-8?B?REFjVThsMTNPS2FJZkJPOXlJV1ppTHhIYUkzK2lqMDE0b2tZZys2aUs0eHAz?=
 =?utf-8?B?ZUxyQVU3NzFDQTZ5MC8reUk0aGtwbFI3aUtDVW84dWRZY0laQUVMT1dPa1Fn?=
 =?utf-8?B?SmdmZGNUNTB1OTdzT2UwZ09OTDN5dVlaRmpBOVJxSFR0cnA3YU1uWTUxZ2dB?=
 =?utf-8?B?RUI1TkcxUGlYYjhOME9od3VQY245SVUzbk14WGNSSXlVZnRRcmdzYjNTK1A3?=
 =?utf-8?B?U0dvT1g5U0lLYnpWeW9ydVJEWFRsMTJZZnZGNlJIM2g1WUVmN052L1AvTUpv?=
 =?utf-8?B?R0wvYUxEcU9FV05sODJZMGxUV29OVGQrZXhkcGszb0VtS0xyTVFLUUQrU0ZE?=
 =?utf-8?B?UWdJTitRakVucXE4N2lkNjRTOTNiMTZvQ2doQitzQXRtOVpESTJsZWt5KzJq?=
 =?utf-8?B?OHZQN1cydzVhdFQ0c09PVWVsb21WREt0VEdiZW1hakl1RFFBNkszRmFkMllH?=
 =?utf-8?B?K09nSEIrR2trNUtFN0NYbUtGL2hZTHErc0ZYMHI0UG16Kzg1Vlp4Z2Mrb3ln?=
 =?utf-8?B?dERVOER3VXlEeGd0cjI2Z3V6bEFhbzBqc2pkc3QrM3lLUzVia1ZxcytQaytI?=
 =?utf-8?B?ekNNRUExWmpQSE5kTUk4bC9hWGhhYzZoVUFsd0E2R212SVUyK0VBa2xGTHFJ?=
 =?utf-8?B?OVV2SWF3eHRyczgzQ2dHcFhnWEhHaDNmUFRZWXJ0Yy9HWmE4SWt4VnRRTlBO?=
 =?utf-8?B?Szk0dG44dWVWcGZ3ZkV2RkdGZGxhTlBlVjlxUHdhN2d5Q01sQS90WGptcld3?=
 =?utf-8?B?aGh1MUFzZDBodmdVQ0NxWjlEcXFzdm8zMXRudEJoVk00Uk1wbXMrUWszNVNs?=
 =?utf-8?B?MkRpRDR6NTBvYzVTMkdPZXFJbS9USTZIclhZTHFVVkl2SUYzWnFjZWdxQm1x?=
 =?utf-8?B?cW1MTUQzMDdIQ2ZuN3BoMnRzVFM4cEhmNW5rTHU1eXBkZXdiQW10UncrZzNL?=
 =?utf-8?B?TWVtNkY3NzV4K0VYcGR1L3VIVVczckZyamhLUHNMdFBFQWJlZ2RIOFhla3k5?=
 =?utf-8?B?TFU2L0xDcFJ0Z2ZLdTA2c2VBeExCRXJDakJEU1BFV0NQdWJnYXhiN2pvRzdM?=
 =?utf-8?B?QUJLUGVwTTdlM3ZGd05WbE9Dc2o4eVAzRzkyZXBldWlXaC9mcGpOeGVTYW9W?=
 =?utf-8?B?eHR6dzRrc2JSN2lKeVBSV1BKQmVXQkREbGR0eWdrUGx6K2lTMG80OWo5amU5?=
 =?utf-8?B?QnNQQzBnRzAya2h1Mm9XZG1hRTdiSWkrK0FrK0pDNWV0ZmJ0eUFJSVJXekRl?=
 =?utf-8?B?Q3EwYVhpZHNjSExNOXdzYmVqdllMZlRiN1lWMnJUdGhuZWlwUlBJTUQ1cnFk?=
 =?utf-8?B?MmU5V3RuTCtPQ0M1dWh6c3NRc0VDOHlVUWZSenlIQUloK3J0TC9ab1BORGdT?=
 =?utf-8?B?cjhZRjhkU1ljMU9BdUQ5ODRYQzNRbTI1M0RjVWtwVjdLY2xFTnJnWlVnWWFv?=
 =?utf-8?B?OTN3KzdwTG1xUndWU004amhWOUxhcERMaUNvSERGS2djZCtaNkxwU0RrVE93?=
 =?utf-8?B?UUk0ZTVJeTVla2tDOUtzcHVHb2JDSU13NlBjWGN6L28zZzZDMW9VQnNpUHJx?=
 =?utf-8?B?N2VSZzVqRHVEK2RCRmpHQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cda86f3c-7ee4-4cbb-9166-08d905e1d083
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 22:56:07.5508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wfzdv1/WpUAeH0rmBB3qHGs4IyA8SjdgaTDgZ+/G4anE44Bxuhd9gCkSwR44vS1T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4450
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: NfZGaUMjpFah_RHGmfL7H2EUPhHoj2gR
X-Proofpoint-GUID: NfZGaUMjpFah_RHGmfL7H2EUPhHoj2gR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_15:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 malwarescore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220167
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> Add extra logic to handle map externs (only BTF-defined maps are supported for
> linking). Re-use the map parsing logic used during bpf_object__open(). Map
> externs are currently restricted to always match complete map definition. So
> all the specified attributes will be compared (down to pining, map_flags,
> numa_node, etc). In the future this restriction might be relaxed with no
> backwards compatibility issues. If any attribute is mismatched between extern
> and actual map definition, linker will report an error, pointing out which one
> mismatches.
> 
> The original intent was to allow for extern to specify attributes that matters
> (to user) to enforce. E.g., if you specify just key information and omit
> value, then any value fits. Similarly, it should have been possible to enforce
> map_flags, pinning, and any other possible map attribute. Unfortunately, that
> means that multiple externs can be only partially overlapping with each other,
> which means linker would need to combine their type definitions to end up with
> the most restrictive and fullest map definition. This requires an extra amount
> of BTF manipulation which at this time was deemed unnecessary and would
> require further extending generic BTF writer APIs. So that is left for future
> follow ups, if there will be demand for that. But the idea seems intresting
> and useful, so I want to document it here.
> 
> Weak definitions are also supported, but are pretty strict as well, just
> like externs: all weak map definitions have to match exactly. In the follow up
> patches this most probably will be relaxed, with __weak map definitions being
> able to differ between each other (with non-weak definition always winning, of
> course).
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

I think strict enforcement of extern/global map definitions is good.
If library want people will use its maps, it may put the map definition
into one of its headers and application can include and have
exact the same definition.

Acked-by: Yonghong Song <yhs@fb.com>
