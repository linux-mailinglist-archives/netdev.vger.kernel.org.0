Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD213D9A36
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 02:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbhG2AqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 20:46:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44002 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232837AbhG2AqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 20:46:15 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T0jT0C011959;
        Wed, 28 Jul 2021 17:46:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vNQl+RBlM9sAigRB8Mqut1D3/C54wcvoh4TLQDpcpJo=;
 b=BOOuOk25NBowK3D2B0HgJOf1vxmekPJEeJL5jrIhKRk9M4x17PqOHtZCiX8uD8eDrJiu
 mTOX1toWejkwfuLVyAJVu42x3RXxyEtw9PvxqjkQOXsFcOF+V34AB8tV2ppt6fDCWtH/
 6Pm/QVbZMFgsPTDHYcgbishHERKRsOxCFKM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a39sskacs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 17:46:01 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 17:45:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bN7bMlQ7W9wZ//FaAreszEqLf3gYZ0+K81h8rQUroQY3D4eqPJ7Hw7RgidvDMqVs8aqe/PTodypACSSkElkhl79VbdIvt17jNHWgfIta1QIYit/EZ59GZ/D95mdxjnTPvEJr6v2+Sg60Ajmm7k8zrCZmkl7Le70YhaUraAeS5TcW33mvTdiAMQ9mquioFR7Icvaq+3bz8HLPaiaLN5+kr2NW0x93nnpYANcZSxIqdHCshyGFJSthx0rwskLU/PjMluSpOP4yPrZ6xJGyk9vQ62xGXiqsVHJYDT/BGAOcSiK4xini6I/AEnvGOYpiXOltqsgSHryN7cGNycnsXcWj9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vNQl+RBlM9sAigRB8Mqut1D3/C54wcvoh4TLQDpcpJo=;
 b=IsAIQd56YooAydXoUwU9CqrYbfZMvOnt69vIBk2TESmLp99tWVNLxGmv06awPsWfOHxliLVUlgSOeRalh3xmS5Q/OOA7zlbe+Ok6JUtG/g0UtN+8tlOTkRJTjqaN6xdlQGIShLhVmqT86bgQnH81Yuex+NpOze68ev0LYuvzW7Mw8xPkZIG/zqBYRsuGETKMt5JJnVJBImQxyfWVF0JbXHSI/18d/AzyYpCWCsEB2TWKtY4dycjnOd8tA1snWgLV25skmcXeVu0GYDKSbb2pRcQC+Scv1BnR3Q6tkYRRAri2swWNBVDvM0HobokSum5Dr/A6MVUAqaw6yN3KNvZlqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4706.namprd15.prod.outlook.com (2603:10b6:806:19d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Thu, 29 Jul
 2021 00:45:59 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 00:45:59 +0000
Subject: Re: [PATCH 13/14] bpf/tests: Add tests for BPF_CMPXCHG
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <Tony.Ambardar@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-14-johan.almbladh@anyfinetworks.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <cbe53391-af77-59c9-a18e-f428f99fecc8@fb.com>
Date:   Wed, 28 Jul 2021 17:45:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728170502.351010-14-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0191.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::16) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:8298) by SJ0PR13CA0191.namprd13.prod.outlook.com (2603:10b6:a03:2c3::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.16 via Frontend Transport; Thu, 29 Jul 2021 00:45:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79784132-8b30-4d23-88ed-08d9522a3b6f
X-MS-TrafficTypeDiagnostic: SA1PR15MB4706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4706D7B2A58DD3A7F8A91291D3EB9@SA1PR15MB4706.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l7mSgnG+NulyNtP8cbmFMgEGZMeNezGzuoLvsMNlXQ869ISaJu+vUe/hne7tneHvICpc9LpkJhVEH4v+tXi2bA45+JeUSpNrt6BB5dJIJmrCPO9F0dNC079CBWCv7sKYawZc+rRRRgHqxCB7Ud7krN45QXs2hDhdmt/sOjDZ0tMkBQW2tlDT3ybrrBTWvOAyi04d8suZ9LFxE0O/gyikkJ9J5U5Ll6U+XSfljsYCZA0w08BnGCLpJCFSGTlPAuOmyLAG4ji1nkdQjdLXLhxivQ45sLvHBWHv/3vzUiJ7CVXe2PlW384KBQgIkfMQL1wlYXveQAyHUGaA2NkPcnFICW/NpXrCysHwo70owIiDpxBoKUDeNbGQGcMOBbWo1Ad4lRc0AALb6vFoTxt/wVj47qy9emBG7BaIXJ7zM1rjqyXpTLfXFSpqfZ7d3hjOiIGJ4L2P5QZYbiYaAPp82UnqsvWa4BzU7fMRMIRTELL+Run5cALPXOCrlzjAWsGNL6O5jh+QpnDkI54DkSDG2hbIVBl/wnBcGySi57icseEckU6c2sPcQSf/MYM9wPc5ZUNxnctfnQSGG+Es6J5XsLo0LshFK2j4QyIhB9gcWV/9jyFsbYkw9i/2bze5HbDd8SYosr3jBbzVXeBYP3GoaFH6XwsIWJKffZnTIlN6JPdVALDbGmGkwJWi68rKpUox2IhYd3eLJWTfeimtusi1Tj3kvwM1tucoyJpUppzrgXD5Mus=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(8936002)(52116002)(38100700002)(186003)(2616005)(53546011)(6486002)(66556008)(316002)(66946007)(478600001)(36756003)(86362001)(8676002)(5660300002)(4744005)(31686004)(2906002)(4326008)(66476007)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFJtSDNsaGhmRHc2UmJtQ2V1N0VMNVYzVUVubHp6cUVqdEM0emh1Q2lFS2xX?=
 =?utf-8?B?Qmh2eWxEdnhTWlVRd0FrbEpiQU5KcGlEWEV0bDRlYTZkb1NUSDQwUURSN29q?=
 =?utf-8?B?SkowcjZzbHBFekNQeGFabnhLcFJNaTNVOXYxdk94Q0hZb01lSmJGd0dJZERL?=
 =?utf-8?B?OXJOTllhVmw3R2tIeG1BVUYxNHJUMm02WDVUWGY3c3kyaFJZRE0ydVN0bzBZ?=
 =?utf-8?B?L1pOQ0ZqZVg1Q0JVYkJmWGN1TWhaeEhvZnZlZ29XY1Avdk9RL0taTlVZQkJl?=
 =?utf-8?B?SEpEc1d2MW0ybHgwTXMrMlBTaWxLWlRHdkNMdkZqS2xlMENOVlVBTkZBa3dC?=
 =?utf-8?B?WkNqNVB2U3JGUU80T3g3c3J3WXRDaWxmODZmNGttVXk2L2g0N1VUckVVVU1h?=
 =?utf-8?B?ZWVvdDRlQ3MyVlowUjZNU3RrK00rU3hmczhBaDllRy9oZHRFN0hjSFo2Zkdm?=
 =?utf-8?B?Vk1tNytKUDhjelVlRUpMUWJpN21YcWxvSDNDV1JHZnltOUMvQXc3cU5DQkg1?=
 =?utf-8?B?U0lGTVlyR3hVcCtIVkJ4cEtZcHN5bklEdDRpcDRDUWJoVjE0b1YyNE1vZjcx?=
 =?utf-8?B?ekhuVVk0b2xXRWxzSWYrM3lFZy9hNjdmYlNPWEdlVDhGSnJmVHo2VUwrWE1r?=
 =?utf-8?B?K2hBVjIzZXo2Q0ZJMnplOHJKdzh2WGFLV1hTcTBzc2UxbmNDN1I2eGIyQU0y?=
 =?utf-8?B?ckRrSVRaTXoxUmtyejRQeklYbDQ4YjdQc0daaHZBUHE0RkhCTkZyRjhKTnJu?=
 =?utf-8?B?ZVFma0R6OUk5R0s0b0V3OFZDZDltUWhxRnRpdWphVFpYSVZyNElXSmthZ3JP?=
 =?utf-8?B?VUlIMzdFcDRIRXptZytmNlRLYWFtaWFOUm9QekRUY3V4b0l0Y2lLUmZKUy9i?=
 =?utf-8?B?UE13REFUcW1Lak1zU0FoOFdkYW9UQ3E3YlB6TUgvd2t6QXBmRW1RRFhLd2Vh?=
 =?utf-8?B?amplVDVMZTlHTGh0c0JaSStnOTRxRlZYM205MG1Pb1g3NUJZY0t2UUl3VDRD?=
 =?utf-8?B?RFVKL2ZuKzV6ZVpRUkI5WHg4dkNXY1BtSDdDK3ZuTy80UGpLaDRIT0NGL1JH?=
 =?utf-8?B?OEhMUWhqVzZIenBuVk5aT3NnZTRUbGRDLzlYcGxRN0FFTnRTUEpYVzdRcVlO?=
 =?utf-8?B?NVdGZXF3UlMrMGNPVTgvdVJTK0UyM2lSRHkzZEdXUjZ5SmphV01qYmlyeXFE?=
 =?utf-8?B?R2hWaVh6RjdnOEMwNU5KYi9JMlUvb0NRbmhYK1krdDM3VGxTK0J4R1BtdlVE?=
 =?utf-8?B?QTByREY0WEFZMXJweU90U240N0kvUUJGRndkN1NRVWcxa0xNQXdPMnM1dnFq?=
 =?utf-8?B?aU9ZRWFMK1hIaVJJcFhtaTBpTE9WQVF1SHFyVlhReEFrTy94ampOTmp1djBU?=
 =?utf-8?B?enVwaEp4N0IvZG82SzVLNzlTcm9iWU4zR0U1UG5lWUpDOCs2Mi81YU82MVJw?=
 =?utf-8?B?ZW4ydGFUUmZSbE8xMmozRjlhNUNYdW5oMkxmcDJSQkl4RTdoa3BsSzlTUm5t?=
 =?utf-8?B?UGZCeUN1MVFxQm1VMGZ5MzJMeEhEYTdWdndSd2pyN3R5MmlzTWxZOHFqTEVJ?=
 =?utf-8?B?TjZyR2p5cE1rNUNTN0hxNklUeWR0NzB6d3VCQ2J6K3B0NXJ0MTBUK0c1VmMw?=
 =?utf-8?B?RCszaTVFamFDRFNQNFU0cUxaSERKTEJYWjAwTEZJMTNGR04wdEpWYnhFb0t1?=
 =?utf-8?B?bk5iSkxjZTdFNFh2WXJCTmd5L2tGY1ZVWmZUZmJhdktSRHNLOUhIdkhFd2hK?=
 =?utf-8?B?eDB6MTZhWnRuVUlFQXlMdTNBRkdiK3FpM0xEaVlqdGJaV0RzRDhPSVZQT3R1?=
 =?utf-8?Q?KKmwb2TyFac1zbowCoAIcRr9sW+E/86e4ZCaE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 79784132-8b30-4d23-88ed-08d9522a3b6f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 00:45:58.9944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XyRk8aw1bzdbICDJROHHDkvmHr4WXfomERn2JiI8flhH0EuC7GzOSVzurNHd64yx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4706
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: HDX3bUiERTNTw5gIbTenIUx56q2smIgA
X-Proofpoint-GUID: HDX3bUiERTNTw5gIbTenIUx56q2smIgA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_12:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 phishscore=0 adultscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 mlxlogscore=859
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290003
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:05 AM, Johan Almbladh wrote:
> Tests for BPF_CMPXCHG with both word and double word operands. As with
> the tests for other atomic operations, these tests only check the result
> of the arithmetic operation. The atomicity of the operations is not tested.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>

Acked-by: Yonghong Song <yhs@fb.com>
