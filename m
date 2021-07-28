Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36213D99CA
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 01:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbhG1Xyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 19:54:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34886 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232384AbhG1Xyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 19:54:46 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SNrF1V022292;
        Wed, 28 Jul 2021 16:54:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jNOU2MhylzcvCV0jxdIIfNSP1Pj/h6ZeCNPL6XT7Fk0=;
 b=qMMnBtL10Wg0sBUfsqH2gJxvaXabRks5j/CdHF3vcFkz6xWRsl+BWEWKEvbCcrpzORDz
 OvHEqJ2qzv/gWS5PGR1+keVFQFzqcgUO+n4yM7i4czLVCR4YN3kaO9pqb6G+1Hpz++TH
 wsxtB2nQ4LGUbSKdP8i1gUCwkDcnM5Whc2I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a3ecngyvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 16:54:32 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 16:54:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1N3SyObeFrZSqA6tADF0RACkjXg99hDNP7tlqe8jxghbiX7KE/SLh5blLPbXs15ilhxIpxVXPlQi2aw2loxHdFWbsNIx3/N4sPSGsW/OYCqLIOHd7gWWIftTFNnfRHvcCUe2rs5189DQ51yspPZVwlX+aFv6FMFQZ1+tvbVLJ0J829QWmsola2ds8s5MHNm6G2MvuDuf2W3Jon1gFcaR8vK3hZYhZFiHcAbBoeF+ELzXgOUX3NygmhU/mLfswOfq+A/54d+7RmzcYXXVcEQjOLkHolMbUu9lJQI9AzWsWSAHJTBfs6Rv4pZGLSQD+R1Y8LMQwWirBH2QhEcco47zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNOU2MhylzcvCV0jxdIIfNSP1Pj/h6ZeCNPL6XT7Fk0=;
 b=H3LnqlQ99irfMhcx8w2ITg0bWn4idg7dAoRznsQ+kJPFr9/yh0VXs1PEVKZCiG5XIBIwfm9qY2ssC8JoK7sgMMTPcm2LvkR9bhC6Rp9YhAlIcK2ZT9EMUhrJ/Npr6bh0ax8tcEWZ7NbCt9SZMdCRJllRw2CbOns0qB+Azp8y0m4MimM+0Xzh8LMIL4mNo+Frs0iVJKP/BAYSpxzSTBj2zZN9Tmn2rwthikh93hKJSB3fFKPOIwQulXfO8+1xjQev8ifqjasHxSWU5KxyB/4WHOobNsnDo+BSkM05BXLpA840ZK3WUhsACZoUv2cB3yr2C+bOi6Io9FMDkenJ0QJ0fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2479.namprd15.prod.outlook.com (2603:10b6:805:17::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Wed, 28 Jul
 2021 23:54:30 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Wed, 28 Jul 2021
 23:54:30 +0000
Subject: Re: [PATCH 09/14] bpf/tests: Add word-order tests for load/store of
 double words
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <Tony.Ambardar@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-10-johan.almbladh@anyfinetworks.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <60079562-4c08-42c1-6332-f855d46f721b@fb.com>
Date:   Wed, 28 Jul 2021 16:54:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728170502.351010-10-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0265.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::30) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:8298) by SJ0PR03CA0265.namprd03.prod.outlook.com (2603:10b6:a03:3a0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 23:54:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22e458a3-3528-4793-86cf-08d952230a7e
X-MS-TrafficTypeDiagnostic: SN6PR15MB2479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB24791B905A473DE86C4EFD7AD3EA9@SN6PR15MB2479.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pN9tYPzl/87D+5pjOkdfkGNfkPPUODNZfzhUAUCEwZYgs2nkz3l7ONQ7Y2SgKJS+2gYz26NZ3Nieg7RR1Vxz3xATBcAtpsJXDLsZe9eK19bSuvJSFkIQXsPjS0JtwruCgrjIN1PArR8iafwvJYF0D/LvNaxziGMqgVmj6adbPAlUJI2LeWg2hfdDX4a6V9cyE09oFk6RMy8WL2WiAq1+TWO+8DpRWULdFtSQRR6Qjd7XDF9B6V52zWxkM50M6AMzR9UqGSzB0RolsSGSlOv1IFjkgdobBCqCHCCO+XXCQGGblZweQ4k/wq5F7Z6YwtM8TJTv/xmVCcYQCavDWhV5bXZzn3zpm/cwTBPJUjOuC2Gd7SfxZQ8K+72xLs0//YbMEXgwwAZ8LwWE6jn242XORVCjrS8oUKrLZspitSbhlACPTP1Y4sb1MXgHvgPYbk4yELdIpHES5suJ/sIIEKAOsPKJaZlbFM+5IUPL+bik0itNw+p0SpZ1EO4Dh2ttn5l6SpKtUyYTVwlG2Pcqft6hRfvhkAdonHw8Agh7qNr9ZWLeYh1ihihMF3NQ11F8SLDa2PMHfn6rYNa/JWisI9nAkLzh4KLk2BSLV7I5aBVH/OUXJqrCeEXZGgojB84A0CQKXYoCScvOQzzWY7KN2hk0gSF47Mwrq86R3NDRhKt/r6PFzS/JQ+2oSbMZcsoyhDuqEMT8o8bKempwZAvHWZkp9D/BRVEwLLQICWmlKm5ltHE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(8676002)(316002)(52116002)(186003)(5660300002)(53546011)(2906002)(36756003)(86362001)(83380400001)(31696002)(31686004)(4744005)(8936002)(38100700002)(2616005)(6486002)(478600001)(66556008)(66476007)(66946007)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnFxVjkxdERIN3RaZ3FtcWwrV21jcVZqVTIzVm1zOU1FbFN1ci9lNmdheFRu?=
 =?utf-8?B?Z0R6ck13K1RVUHJIOWRqTURDV3lWNmw3VDBlTDdjb0V6UnpNZFZFaGY4NFRx?=
 =?utf-8?B?cjhlaEhwRmsxckpGc3VONUdkbWpwQVRiNzk4d2MrMU5nc0FaTlJWanVIaVBm?=
 =?utf-8?B?cVFPdEEwT2prYktrRTFjVElQMUV4bURiV25pWDh2cEo0TXlYTXhiZUY4ZEdk?=
 =?utf-8?B?aFJBY3c0amVLTmlLcXFJdTNuWFlaVk1xcGVJay81a0h6SEFsZGFnZVo0QUtk?=
 =?utf-8?B?bjA2T0grQlFJYnRBaEZCZkpxdmJoZ3dpN2F3amhvUkhjR2ZOM3dkblpONUlH?=
 =?utf-8?B?cEY1eEM2UWdjMERUWUdOVVd0TzFWV2pNN0VZUmJpSGF2Q2QyM3Y1QmlpdXRG?=
 =?utf-8?B?UUtQWU1kQWpuN3ZXckc1WGxNT3VFWVdOUVE4bm45SjI5RWc1T2JOeGhRdWFj?=
 =?utf-8?B?bThEQk82M2grMFF4ekJXd2N0aDlTVWxmd29MdExxRW43YXlqRzQrcXk4ZFJX?=
 =?utf-8?B?dWh0REpnNjdlRU1GSytLTkZuYTM5QVlzaWxWMy9ydkNCbmw1OEFEMzhhd0dH?=
 =?utf-8?B?czFtNEZkaEtJOTNLVllmNy8vR2RZL0x5MWpxWkQxVHFQUHFkTFgxMnk0d1FH?=
 =?utf-8?B?NWxybkwyRHJkVURrY0pUWmZwVW5QbGtzM2lNMHJUMVpJV2NET0YyaWV2aUpU?=
 =?utf-8?B?dVFCdFk5c1hlVHpqVy81SEYrS1paeXVzeWJ5NlJ0Z2xVNVNyNHVOaGVsTXk3?=
 =?utf-8?B?L2ZQZlVmY0FWUDN6OWlMdCt1cTVFNFA1ak1ybXdyTWdsTi8xODB1L1Q2eGdM?=
 =?utf-8?B?cmI4MGZwc01wZ1prN00walBJbG5DYkExa29vY2R2TGJYQVJTeU53UFFYcnVV?=
 =?utf-8?B?Mm9ocWNKV0JZa0xyUi9pOGtvaU50V0VsUDdENjVhVjhVdVhXMlpSejd0amQ5?=
 =?utf-8?B?UmczN0laY1dBdlJRYUpaQ2FiZ1NaRG9kbEFxWnRTaVRDckpNL0xQeTRIcUt4?=
 =?utf-8?B?eGY0Uzh5T1BHTHR1YTRHV0k4WVJDNmYzNVUySTYwV2JXMnVNajNybDdPYTVX?=
 =?utf-8?B?WVVjd0hydG5WaUxLL3FuTlJtTlc1eCtMWGZlS2hzNWF5YkxwUzFIcDFrS0tH?=
 =?utf-8?B?eHVXaUhyc1gvUHo5QVZxcVJ2YXhvRTVnb0V0WVRHbytBRCtmM0toQVZXTGxD?=
 =?utf-8?B?YTNmTVJGQVRiK0JrWElzdCs5alRQNUpoNW41T0szdllPTnliaWtQck9EZjdm?=
 =?utf-8?B?ZkNNblFEQy8yQm5MbDRRczhVSTJ2c0gycGF3L1RvODNlWEZBK3RzQ3FHa2d0?=
 =?utf-8?B?RW5mR1dwbWFrVytZQW1ZQ0VZUW14N3hmbkFYaGFmdjFRek8xbWNlalY1Z1dq?=
 =?utf-8?B?R1hZQ1NNWlZteHJYNTFiSmhEZFdmR3UxdnA5TTRKSEt5eVFBNzJZQ09OaC8r?=
 =?utf-8?B?MUdFcUV2aGVkM1U2M010eTFQTzd0dW9uVmtHd0hxc213YS9OSzlCSDlUWW1n?=
 =?utf-8?B?Q0VCSXlFL3Y1a0lQbk5ROHFxa1l4Q0l2Uk85UysxWVZVNHJxTVArKzhxczAx?=
 =?utf-8?B?eGdRSjlmNmd4aEF3dEVZT2FEbVFxOWZnQTN2NnFPd3VrcVdWeEN1NkN2ZnVZ?=
 =?utf-8?B?dlhFc1hQblpjUmJyVk9vZ3NUelZSdnIyMnAvcjhuU2ZiQVZJK2I2SlkxRnVS?=
 =?utf-8?B?L1I4cHFsRGNFY2YwbWhJY2dMdVpTUHc2eUNyZEwvM2RUeFVwYlBsbjNkS1Jx?=
 =?utf-8?B?ek5CMk9ub2VjVTZ0VER1ZjRMSDJESXRrL3NZRnFBcis2OWxzaElsM0NvTXpj?=
 =?utf-8?Q?OJZ/guM/Qc8gHkkh3oY5hqYxWqBJjOOykdKtg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 22e458a3-3528-4793-86cf-08d952230a7e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 23:54:30.3972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hp3nVSSQuM7Q+JXQzhS6ILBF450nZ24v8PKk0QcCUs2dKGJcM2f1gAQ8NwLmATjw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2479
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 3P2peNZAggNb_VDU0mAZ8VCT7GHTlLlH
X-Proofpoint-ORIG-GUID: 3P2peNZAggNb_VDU0mAZ8VCT7GHTlLlH
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_12:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:04 AM, Johan Almbladh wrote:
> A double word (64-bit) load/store may be implemented as two successive
> 32-bit operations, one for each word. Check that the order of those
> operations is consistent with the machine endianness.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>

Acked-by: Yonghong Song <yhs@fb.com>
