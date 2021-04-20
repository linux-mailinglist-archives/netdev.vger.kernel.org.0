Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7D6364F8F
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 02:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhDTAh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 20:37:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35196 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229758AbhDTAh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 20:37:57 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13K0ThRF017661;
        Mon, 19 Apr 2021 17:37:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=RIMCVVqYdQOEtsj3XLKAeM0juPbrv9H2f7q/5uy0PgU=;
 b=EOQw+fLsgm5cv31gAbf6Nfvr29oWMnQlP4H395c1/WvedUnItUoyW6Pym2eDKdarY+g+
 uhxLshlWa4tR9JT9B+vJc845wbXtRhxq/BSjXEH1ARMFyF/C+2EwYrORzFkEjLfFPFWN
 o59NaIS54Rq6nOqJgj3vAU/9fmeMjeOz9Jw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 381mf6r0w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 19 Apr 2021 17:37:13 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 19 Apr 2021 17:37:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rh5ILqf7gawLvIckSZuh+MO6/kJUhWzAMsySdonzoIwyP6vD2zeJsRDQJXl62mOSedxsgJW/f8cYGfwhzPhY8QPiAu7jJIHwe6sRtTu3BnFX9yzTN9bMLOedDlucsL3ulfK8hsIkeYh3/e2WdZKLFSu69g6FfJMRC0n+5QfNbFGlDpnjpTU0xtAVscaxZjT4x6WPMxhKIMDC5FcyZJRoL5QWO4pu78TbhMg5SQ3QYn4fN5Aw0UMZFDC4O7sMYxKNXgs2VbU5b2nLig260L8seGdxWyfdOhEpgxHwzn7x9rLE8oC5tMIgx8877pMTjWUcdNqe/VsaTGfqt9pEcY8yQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIMCVVqYdQOEtsj3XLKAeM0juPbrv9H2f7q/5uy0PgU=;
 b=QplhB+TK93hpRyHSCLF+t62mTT53VUvykeUhDEKQmlUX04Rrk1SIDqMlgb4AeBBXHqUC7nNVumUtvdtLJx+6DInhAR2zMp/WNEnHmxC3qmYRo8jLRuA902xy+/ZGMsnOMYRgT3XAyAQ/9HsjSzNSoiLGl4YHSwztgLWzQNFMAdFMYGUUmLmvZ0/2IyWEH2e96dsdKmlHuW7AVPSjoBhUGrOfHtCXkvSi5hNWq8HQ2SXAQtnxSDWhJ6IVq+hVh8RTTHgMLi5E6HtlheZNJVT4mTvyYCZ9x5Gt5DwrMYN7Jf0Gq1IzTZLkbOU4ChmRZ1xKaB6HC00S9ED2tskEdFW7kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN7PR15MB4240.namprd15.prod.outlook.com (2603:10b6:806:109::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Tue, 20 Apr
 2021 00:37:09 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 00:37:09 +0000
Subject: Re: [PATCH] bpf: Fix backport of "bpf: restrict unknown scalars of
 mixed signed bounds for unprivileged"
To:     Samuel Mendoza-Jonas <samjonas@amazon.com>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bsingharora@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20210419235641.5442-1-samjonas@amazon.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <eb031747-1c5c-2c30-15e3-f9c6b858e2dc@fb.com>
Date:   Mon, 19 Apr 2021 17:37:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210419235641.5442-1-samjonas@amazon.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:b724]
X-ClientProxiedBy: MW4PR03CA0255.namprd03.prod.outlook.com
 (2603:10b6:303:b4::20) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1664] (2620:10d:c090:400::5:b724) by MW4PR03CA0255.namprd03.prod.outlook.com (2603:10b6:303:b4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.17 via Frontend Transport; Tue, 20 Apr 2021 00:37:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8bf99fc-dfdb-4c0f-e133-08d903946e9b
X-MS-TrafficTypeDiagnostic: SN7PR15MB4240:
X-Microsoft-Antispam-PRVS: <SN7PR15MB42404B92F934F766F04BA268D3489@SN7PR15MB4240.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UxNah4miMtOF0hj0wmo1yW/btcqYBtNJNTH38t6Bz5Y+J3qelMtZ+XssMDNtADFU9QwclTb12s8uVn78B+KeBAKPFgk6HphAtK3jzsC6Q1ktyU0CASfvEGv5hFLipivAuxM79owyfqziHcYbfxao0wkUGNSnwOoGvSI41XfGwmQhwRjtnTmdn7kaY89LUXYLWHzZ59l2eGaTkq+y+MD2E+FMxmBLzQU9yQEU6ly4/BKtVgB/3Q3mQ0YyHatKLD1HAEI3dhOyjM7OGbEA4q0rqB11u0cEv2A2+jMji/UkDUaMMkBUIBOmJyfSAZbVowO+QmPNhPt9hwbQmHCWxWUZJB5iRI4BGnmCP8uXqqJfe/RFk7VL/bJGy96YVyauxsc2NWQMwMUTrbmAckjNzhysRl5Wp/1dy8Y7yrrpqg9qcOcguPoFX0eUkiTZ9sYUltfBRcwKVOWN9LwEmpY3EcdBFZ7cXb2sjDdp9bi5YoW5CV6B4iVXYoCgd+CFnqf7ScSjikv0AUmQ713pFEaPA0V06DniVNkhFYGAbzFhgAv1mYfKmCZnxPaNGe+gYYZaZyanXn0PfmwkHtS5D0Kx1Iu2ZJnfa4ESh3yI9zR2DL+fu+1FDUrXAyQDD5K4CwoEO15F0EuwT3YX3BjCAwDAeNvUbmILl2Ih9eyN4/sV4BuEd94LtxPC7aqBwlWTdrr3Nn57
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(346002)(136003)(376002)(478600001)(8936002)(6666004)(54906003)(66556008)(16526019)(66476007)(66946007)(4326008)(53546011)(316002)(52116002)(8676002)(83380400001)(6486002)(186003)(31686004)(5660300002)(4744005)(2616005)(86362001)(38100700002)(36756003)(31696002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZTdsTlljZ25zQmUrNVZLY09TSVVIRDBHa2c0blZQYldxb0JVMjFkVTFTWHlV?=
 =?utf-8?B?VUJnWmp1c1BrM3ROOUh6ZVA5UnAzZkx6YWN6TDJwcmFNNWFPTkE2RGt3WVcz?=
 =?utf-8?B?VVpZVUpTTHpUK2l5S0tMQXZHQ0crZGQ0N0N4ejJqVkRPb0NybmlqTjZkUXZn?=
 =?utf-8?B?LzNiUmhkMG13RXU3b2tPa3ljd1JkZlJ5dkxGbzhoT1V2ZVY3TjZrYzNaT29J?=
 =?utf-8?B?OSt3aVEyQVpRRG9Va2ZuUkludjh3dHo3YnhkSTcwVVNmNHFGWUo0ZzM0bllV?=
 =?utf-8?B?a0ZjRHpta3djZ1dMalpKVmZNNGM0bDZ5Q24wamRKcU03RXRYc1g3WlpyTTBD?=
 =?utf-8?B?YVo1a0pzQ3ZEZHZRMnMydWhTMWEwekhzYUJQMDkzbFprOFFSd2tiYmpvMldW?=
 =?utf-8?B?eTNhQ25tbEdkNjFLb3AzbDlkbmpTNjdmOWszSTVONndrK3Jtd3ZmSXA2NzRi?=
 =?utf-8?B?aUkzcks0Q1k3QTVuY09Wbkhhb3V0clFnNndiMmpGQzdqK0RKZ1dWbkRrTVZZ?=
 =?utf-8?B?U2xWVXlNY2JpNmpPRnR3dE9qUEhrNFZ6VDlTbXdyZ2xUdnVtT0dkalljYTNh?=
 =?utf-8?B?ek9nOGcweEx5cU5BSkhORWtBMkdlL01YZ3pmR05vUW9SdTRudmJuU1oxc3Bs?=
 =?utf-8?B?Y1pzRjFHcGpITDdWTVJPU1l3bkhZV3hhSkx3U2FKNTdZRGN1ell2RTZadTNP?=
 =?utf-8?B?c29SeFlFSDZiVHZ3NHIxNFFKWWFQalFtTE5aeE9sTklLdnhzU3dVRE40QjhW?=
 =?utf-8?B?R0NjdjFPbyt0RU9RKysvbjFsWlJkNm5XU2V2dTI0ajRwaUY1WWRTT0pyVVh0?=
 =?utf-8?B?aUp4WEo3aDB1blc5NVIwam41NFBYNll1TEVMZ1lDSFU5M2ZjQkgrWkpUNCtl?=
 =?utf-8?B?UUE1YmhXQzI4Q2dFWUVYVDNsRWNwQ1ovd3pxd0l0TTRXQmdXbDJ2RUhqOWg2?=
 =?utf-8?B?RW5tUkFycENlNVkzVks4UEw2RDhRRllKcHQzektTdmk0Qll2VnJML1l0RTVa?=
 =?utf-8?B?VnRwT25VRUpETDRVZFlJMTY2KyszaVBhRmR2ZUNVQW5JWmxpa1lWSzBNSkNC?=
 =?utf-8?B?VWlxWU9hS0tjVmgweVlnK3VWTnA4NGV2OUYxdm9neTk1LytPeU1ENjB6ZmxW?=
 =?utf-8?B?bGpvZDJmZkk4dUF0S2NRN0tTNFlFck1aUnpVOGhuMjhQZThXRUNCSnpiemJv?=
 =?utf-8?B?emRYczVPUUNpMC9BWFNYNkxGcERWMzRtZUVnN1hMZ1NYYVBJRUcrZG1ic1cx?=
 =?utf-8?B?Wk1CZTYvUWx0MTFiNkdPMnlBdFZhMWRBS2FiUUw3aTlYRWJhNlVaTm8zZEtO?=
 =?utf-8?B?WStOZHdzNDZiTWxmaXhlRmduK0tjb2ZCM0VDdjVtSVA2WnJvSXJPeUdsSWM4?=
 =?utf-8?B?a0NSMDNrNGdWejdtcU5nMklveS9CVHhYYjZad1FydUJ3OUF5U09pTjdLZmhQ?=
 =?utf-8?B?WEdCUWJjZlJieWYxVlJRb09FMXQ3S3ZodmJDTVhkUW4yQ29NSVE1Z0JnYjZs?=
 =?utf-8?B?UDBWRStHZ3pCeWJSZW94UU9ETzk2d2RNbm5QV3ZpT0lTRzNxSTVPWWZvWnlo?=
 =?utf-8?B?a0RtM3ROMXNBTkxIYW9kTWRhRWxlRVo0STByb01lNDRLNzRHMzlxcTBkVnhG?=
 =?utf-8?B?OFpSeTRLN05KSm0zRFRKQkR1WDFnU0lCMU5Demd0QkZrY2ZjSzJCSTFxNTdn?=
 =?utf-8?B?RGh5TXcrZHExOUFJRjc3c3RNOENvN1BQdnZXRENXMkVvOHd4NzB6VXRhZWt2?=
 =?utf-8?B?OXRIeUpRbFZvNE5KU1dvTzgvWUIvMnVRN3o2K05jcGgrcG16ekROZmNhaWRw?=
 =?utf-8?B?RmFoaGlXdzc1RlpoRG42UT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b8bf99fc-dfdb-4c0f-e133-08d903946e9b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 00:37:09.6477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3UzkjFBR0AmmFIdKbwtFFV65HXGQO7rV9Ho1moqP6MiCkg4Xwc5v7jglSomjCj3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4240
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: GL-qWmu7ZCtAOVM2FJ0kGnnwPXPNoP81
X-Proofpoint-ORIG-GUID: GL-qWmu7ZCtAOVM2FJ0kGnnwPXPNoP81
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-19_16:2021-04-19,2021-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 priorityscore=1501 clxscore=1011 mlxlogscore=918 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104200000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/19/21 4:56 PM, Samuel Mendoza-Jonas wrote:
> The 4.14 backport of 9d7eceede ("bpf: restrict unknown scalars of mixed
> signed bounds for unprivileged") adds the PTR_TO_MAP_VALUE check to the
> wrong location in adjust_ptr_min_max_vals(), most likely because 4.14
> doesn't include the commit that updates the if-statement to a
> switch-statement (aad2eeaf4 "bpf: Simplify ptr_min_max_vals adjustment").
> 
> Move the check to the proper location in adjust_ptr_min_max_vals().
> 
> Fixes: 17efa65350c5a ("bpf: restrict unknown scalars of mixed signed bounds for unprivileged")
> Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
> Reviewed-by: Frank van der Linden <fllinden@amazon.com>
> Reviewed-by: Ethan Chen <yishache@amazon.com>

Just to be clear, the patch is for 4.14 stable branch.

Acked-by: Yonghong Song <yhs@fb.com>
