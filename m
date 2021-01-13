Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF3B2F50F0
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 18:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbhAMRRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 12:17:35 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14514 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728214AbhAMRRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 12:17:33 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 10DH2gxY020568;
        Wed, 13 Jan 2021 09:16:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gT0Z30JEx+02UCcfqvm4mb4iJ9gUDmE35HN+ehgo5Fk=;
 b=lAP/DKbvK7CYvRlIKZ+rroF6Q0CqwrpCcAJJD3gUU5w+9khSWrtNpACCJB6ft8Ugny+d
 Lqu9uNf/6vmOssV4zvrxZN1skcFOAvXYKyAa8QkTU2g4HufNqHc7XzjMwguYVR0+tyOM
 jpOhEZ/6aJdZdQ3BrEitDytlaE1Q/nvCJ4o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 361fpqp8es-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 Jan 2021 09:16:29 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 09:16:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UAOtHHpSM6mLoQ9NkH/abf4W0nXY3D2+pBqC8nNmdCbpXUdec1NOUirXxNuU5NX9E3hXIDrUMCYhjy6ye2ZufAh/JPVqhQn5mxApxYfKYBhF9iQjjWrIxi+nRTm6tglii6NL5GEOghzS9sBPp9lMQ76mZyOKKOYSb9kt0jkunv/jwcT/1T2T7xsawB2ZIh8gb+U0wRdmOymvI792XnFxtuuxspTEuA2ti+ZyHaTGFpsjeW8i5hTuc7HFwMcz/CNmIlNoHta2ffIpuApwTf/7VrNaF9rbJZGix1aNZV8ePvLFHDIIoVwDzSy1E/BS4D3sWogiPmrOsGgxFp4Dam1l8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gT0Z30JEx+02UCcfqvm4mb4iJ9gUDmE35HN+ehgo5Fk=;
 b=iWtLlxexf552jkhw9sUm4O97/FdpH4292HHxiutyc1FGRb/wwXRqPs/JfJnY8rwBB1NUzVkXG/xYGtMUu+bzhazdeQKtA6OSeKy89bS3lFblMBoWlT6ZLB0ryK2OO9JI6riVoO3H/XfPtKU0q8vFNo/kQsmMXHwGw//8XsYfasm4r6HcoC1cBkzKPCj4B8LBpImbKDBfwow3vPylcItL1Zi1gOiUDIKWhpJZBAEh42XgtbCtKhrCmxA6ulxFEvOENl8Q82o09kdC+LncND7Qs87PxM5gu7irADV0H3gKBVlXAdtqcX0PU9KbP1W08bogTe+m8+uzS9B2e4tsTDFmxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gT0Z30JEx+02UCcfqvm4mb4iJ9gUDmE35HN+ehgo5Fk=;
 b=Q0r4HvFSdkYwgbk0YOkaCGxbpAwiUH+sbhJxij01y4ZEFqRXdA8ezWMj+UCPPQnyMWT8qD4Vz8FrG7vP6lJR3fr0FC4TW3kF5Y4v92Sezsolgea4IovxY3DEKLe9QoQfjJvP6CbQNS9DifK/rT/vkTldLlaWKoqOvphTDLjbJLo=
Authentication-Results: loongson.cn; dkim=none (message not signed)
 header.d=none;loongson.cn; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by SJ0PR15MB4204.namprd15.prod.outlook.com (2603:10b6:a03:2c8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 13 Jan
 2021 17:16:28 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 17:16:28 +0000
Subject: Re: [PATCH 0/2] Fix build errors and warnings when make M=samples/bpf
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
CC:     <linux-sparse@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <clang-built-linux@googlegroups.com>,
        <linux-mips@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>
References: <1610535453-2352-1-git-send-email-yangtiezhu@loongson.cn>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <0a85390d-b918-ab56-cccf-e3896f0f50e9@fb.com>
Date:   Wed, 13 Jan 2021 09:16:24 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <1610535453-2352-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:e777]
X-ClientProxiedBy: MW4PR04CA0424.namprd04.prod.outlook.com
 (2603:10b6:303:8b::9) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::13f6] (2620:10d:c090:400::5:e777) by MW4PR04CA0424.namprd04.prod.outlook.com (2603:10b6:303:8b::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Wed, 13 Jan 2021 17:16:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b531cf23-35fe-43e6-60b9-08d8b7e6f69d
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4204:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR15MB42040C4D663822B7651F500ED3A90@SJ0PR15MB4204.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pu09rn1ihN2KUp4KZmdOLIUf376R/SoCcNM5STdNzOfh8Jji5mOnQZ7k2LOp4rzgQNviiDDbhlh27rqaxD6PKBJOEC0u9Zjnc3WbjDIE2+LLuncLIGQdRAB3o9/G5h5gwjSUtOh+e95+TF0gUsxslptGgVTJjE8xdkXd4RatFLJGg0NohG+kFfdJ1B6oRa0dcgEz2nBO4jBQ7pi4pdHSMMZwGQtd7CbArr7iPyMVxra4oLFX3KpC34hlH7P2ZtFBhhN5cq9gFOPoXko1SxFpQ8/I79wT+NOv19pDhntSvYKoE6FcpSAh9g5EGpVSEGU8RlQ46siwJEam4CX3kCeWELGei+IxTi4eHC2L22g2Pg9TSNogC++e8OQ+omvoEwNa1hG20yZyftddMG6EfOZ9Da4gVYyAT6/bw/YiNc7hJ1hSwVJ1z6JodnknQLnNEyXftVdZH0FE9ZnhAPK+td4ie0pue0PzrbKhSuMvRb/31bqXvIWUr11UOaJ1/oA8bUr8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(346002)(39860400002)(6486002)(83380400001)(2906002)(921005)(4744005)(53546011)(86362001)(316002)(4326008)(16526019)(8676002)(31696002)(2616005)(66476007)(52116002)(66556008)(66946007)(110136005)(8936002)(31686004)(36756003)(7416002)(5660300002)(186003)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S2djRGNUOURtbnhYdlpBUjdTZHp0ZnQyMEZES3B1TDgrTnVlUWtKbC8rc0ZH?=
 =?utf-8?B?MWtnOTJGVjNMaHI3TjdwaVFjalNubUxnNWNxRE9HWG5FZ3hzY3Bhcm9PTnB5?=
 =?utf-8?B?N1YwSklYNEEvRFpRM1Z2VVBYbkNveStqT0xvcW1leDUrK2V5S05QbXhRbWkz?=
 =?utf-8?B?Y25RQ1dYQ1p6TjJ5TndSek91T1FQdVMrTmpza0xKU0pLdFR0Zm9rc2RtOVd2?=
 =?utf-8?B?WjFQcVVTZERjRWtvZEhkQjJpenRNNG4wOUxUMjBCTmJjVWJVVEtOWE1qSE1u?=
 =?utf-8?B?WDZMOUUwdW91cEN3V0tQV2ludnFNREpDSmc0a1FOa3dKOFFERDRYNWVIMEQy?=
 =?utf-8?B?UytYVHloT3c0eVlMRTAwSGVKdktsaDluVkowckduR3ZDOWUwZVlIQXhhaHU0?=
 =?utf-8?B?aElIK0lZbFdzb1JqNmhZdXc3UjZobDZON0l6UWVNNkxwM2RISzc5WVFkNzFp?=
 =?utf-8?B?VVMvYWp1L1VJelNzZmFYS0hLV3RjcFFHUXRiUUlxUkgyZUJpbjJPVTBTZ0cz?=
 =?utf-8?B?U2x5eHptbUt0K3hlS1p3ZnVwMEVGY3dabXpaQmlLZjFSRVNjb00wZldnd2pX?=
 =?utf-8?B?aG5kcGFoOEtnQXJSYkU3Y1Z3UVVqL1p6MUVOUmRCamt5STBOKzFYMXJsWThj?=
 =?utf-8?B?Qk5HTktVa1dNZkcxRVhPbkljV3FQbVJCM1FGU0VQZDVkQzl5aWRnTWgvQ2Yx?=
 =?utf-8?B?eWI3K0FUY2QzTXVoeXVPTE0raHZReHRNRUM5QUV5S3gyQ1VEMERsOGZlYVdF?=
 =?utf-8?B?cWFObmowNGFncVBpRStjWG9xSzlWalovV3RNSFRFT0dpNmpHUUVUeEQvQWpw?=
 =?utf-8?B?RndOSTZVaHBwejFXWlZ6eE1rdTQydExHU0NsYk5jQ09YRi83aGxiNHIzNWFu?=
 =?utf-8?B?TWRkU20vS3RvSUxSNnBBNE1lTkc2eUNFYWNqQmNTdjhjWEhVNzlob3JQTG10?=
 =?utf-8?B?QWEreXlUQ1ZhajY3ay80OVd5VjNtOGdNWStsVG04MEp2TkhLSHh1MWhvaVB3?=
 =?utf-8?B?TCtuZHZiVXNIZDFBRnJQbjNrZWlMSmxVd0NpQ1E5UGxiaTBndUxjR3FCQ0ZZ?=
 =?utf-8?B?eXdBbXlIdkFzT0lnb0JsZGVGMDF0Y3FScVFPM0YvZFNUMTREeDdNM0pBeVlj?=
 =?utf-8?B?NWhPRG5RQlJZYzVva3JML3JIZjc2MVpJZENDcmdPOGpCeHM3cjEvVWRkelVy?=
 =?utf-8?B?QXY0UXE5cDhkUnE5WmptWDBCbm9keGhqbHpXWk94eTcyT3FOVVhwb3hLOWEz?=
 =?utf-8?B?dzE5U2RGUnhMczd6bitleTZPbmtEM0YwK1BmSDRWMTFNNVkrWE0wZEtJaVpj?=
 =?utf-8?B?RUtsZUNWbTdQakZQd0M0cXpraGFhVUFFbVpqWldLcklWbS9Wbmh1czJOUnpn?=
 =?utf-8?B?c3FScGp3ZVhQR3c9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 17:16:27.9815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: b531cf23-35fe-43e6-60b9-08d8b7e6f69d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /O+Sbztf3KQQ7OKzSonOzRKAL9N3+hr8Atfo0ijK1nj37UdeFjbl6h/1oQMIUsNO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4204
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_09:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 phishscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130103
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/21 2:57 AM, Tiezhu Yang wrote:
> There exists many build errors and warnings when make M=samples/bpf,

both fixes in this patch related to mips, please do mention in the 
commit message that this is
mips related. x86 (and arm64 I assume) compiles just fine.

> this patch series fix some of them, I will submit some other patches
> related with MIPS later.
> 
> Tiezhu Yang (2):
>    samples/bpf: Set flag __SANE_USERSPACE_TYPES__ for MIPS to fix build
>      warnings
>    compiler.h: Include asm/rwonce.h under ARM64 and ALPHA to fix build
>      errors
> 
>   include/linux/compiler.h    | 6 ++++++
>   samples/bpf/Makefile        | 4 ++++
>   tools/include/linux/types.h | 3 +++
>   3 files changed, 13 insertions(+)
> 
