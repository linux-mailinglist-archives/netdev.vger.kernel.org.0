Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB96362426
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 17:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343860AbhDPPkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 11:40:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23526 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240673AbhDPPkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 11:40:41 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13GFZdHO025560;
        Fri, 16 Apr 2021 08:39:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=yFiKKtK1+hkiAuT0g442sJ0xzL1mtHVUUVjyCLo1AzI=;
 b=hFsKX5fIDG7ELXjP4+8mZDCWKwaB7VLohzzKoUrGxGvQ2QWy+UZ0ka1RpG5Zfj8jLhmZ
 fAFOYmk7ee2WWxGKPJb4pEVy0CPbuk7oKYxAii1i1lj+u+gSXti15MnZNQUdnjxeyoWZ
 6GgkV181YINWcN2JgiIAzfJNIzf4IO8xIDw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37yb9y0sng-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 16 Apr 2021 08:39:29 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Apr 2021 08:39:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAAMouYlVtapTsZxwpMk7VIyNwZcb31LtFDxX4sR5KJIZ4dixDyYxosdgJfLmK3nzyaIU9P5vVnTj4Zq8pMSC7pwZdxJ8T5ZisatzSM3gZr8DO7f85p4Kr5sREhH6NHPg2eCelVlDbAqiXelpBWP2LR+qVLmu+ydvjeFqpZ7Jmq4RqHyHR2RPOcqPJJYFldICA8WmfW4K8GMZSRBhWIr2kIpfqdexRXFxKYELx0Sfa/QucrMUgL7rr+7FugHI0sMhedHuoo+aYm0EIxFoKbZp0uwszhjetJWtjI4aEai0CaPnR+bHcWupJL6kkFtgd31MuD3aVs9Ix8uU5Zq6szDLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFiKKtK1+hkiAuT0g442sJ0xzL1mtHVUUVjyCLo1AzI=;
 b=aRQQYYT9bR1IauX+CpIIZ7lvJEJjdUk0IUlNUnNQuuWRtvG1c8VWPrg9QuxQpJF1X5O/4uBa4/EEG90Bsuk9qDBH3WTQBNWxwvz+ugZWmQEz7JmTsQEhcsDZwfg0nkdcawF7zH9eky+3lBsqbCrLGyUZtZNPbeke++9MNvmRQ6wWWwEXJCiyHTVd4/njCP84E0kJGfS6dWOO4g0dcQlITp4p61/ULc24qdIGKkXZ7IBDaxekLznGwltjqfoXyWRqiyckLcvYBL7zj687uDGr5MuShJtFgHEuQZ+aIPP2+xU0AThiLVp2x7K/wgQHbUwMMSaVzCVTaGf0mIbKPJuF8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB4096.namprd15.prod.outlook.com (2603:10b6:805:53::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Fri, 16 Apr
 2021 15:39:25 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3999.038; Fri, 16 Apr 2021
 15:39:25 +0000
Subject: Re: [PATCH v2] tools: do not include scripts/Kbuild.include
To:     Masahiro Yamada <masahiroy@kernel.org>,
        <linux-kbuild@vger.kernel.org>
CC:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>
References: <20210416130051.239782-1-masahiroy@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7e449775-7e57-384f-8d96-a32f651c2ff0@fb.com>
Date:   Fri, 16 Apr 2021 08:39:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416130051.239782-1-masahiroy@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:7e08]
X-ClientProxiedBy: MW4PR02CA0028.namprd02.prod.outlook.com
 (2603:10b6:303:80::28) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::112e] (2620:10d:c090:400::5:7e08) by MW4PR02CA0028.namprd02.prod.outlook.com (2603:10b6:303:80::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18 via Frontend Transport; Fri, 16 Apr 2021 15:39:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73019d81-c0f8-40bb-2576-08d900edd01d
X-MS-TrafficTypeDiagnostic: SN6PR1501MB4096:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR1501MB4096BCF66F47839B45EBD760D34C9@SN6PR1501MB4096.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:632;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bdWa4frvnXP+f1ftHF6UxntSVmZ/hwGYWWStCl4PB0HMzkkRi/jZHKw7qAeAH3olxfsIyczu8PBrvswNpoN5GVgm7RHVWhkz/JF5S7BEmjMD4wllSzyXooesOZBjoNXczBGsoKT+HgNu5PnT9Zrjep3HPXSt2V8zKTNfQERlRDAjpWCqsg6mS1JFcin+kD6Eh9NQGjk5USOSXQkuM/oPBOPxQm+hKo+9OLmf5vBPpEhj/YYaLVuy8pAi6oRvCyiEh9zjze4lmj59lsXbz4HjsBy7ItqaACZDmK9bXbQf7G1nNspHztgIXp6r9WcE2oyoTP8jl2rEgz9ahzP8WczDfnBwytnVk0Dtw3tJXXwJiS8d8E917514inpWUatEVknMK7+mxjWxsnijHCUNNNbkHcFZB7bhwiTc98BVxYFxFeJIaoVd9C5DYQqjrDahlSfLcforiFMmuEt1MXshb2kCmVR6+bJ4Djhr3mcfkDzqsN7vaasWge+PiBAhyyotNzkGzOo5dlpK6SeR1dvGVLhC2Xb9PDFlM8RdnJOZr4ADu9mr0b7p7RUbBgYOwIEhpzC9JLddnP24e2OFqmfUc/OBtlnEI3ccJJUPp+4JqeODJ7DEnu5RQgVuWYiJ5llOdDIp4X6Slrtw4EB8dX65OanVV19QYYn/BclTO+YUaE1JuPmaPbm3QC5QZfyrRCv9uzA3sI6iDMFAdVv80bOSLRjRt2XMM/lxUGkyMNJIo0ssKeVMJO86NY83HST63K65ZzQjS57BACZC3BCzQrconkmEhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(366004)(136003)(8936002)(16526019)(38100700002)(966005)(31686004)(54906003)(66476007)(186003)(8676002)(36756003)(83380400001)(52116002)(478600001)(2616005)(2906002)(5660300002)(4326008)(53546011)(6666004)(316002)(31696002)(7416002)(66946007)(66556008)(6486002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RmtlR1hkMm1udlc5VjNGWVZuSnlTTVJtYnhvZjRQSjRNWm0zMGo3QlV0L05D?=
 =?utf-8?B?QkJ0SjNicGRFRGNOUGhKTjBNQ2crQ1cyc0trYmEvdEFta1lETjh1VnQ5dnJE?=
 =?utf-8?B?eXFnMjJBN3ZQOU9XRHVjWVhNRjBOanBGWDl6bm9NRG5xdXVsMENCUTU4SmhV?=
 =?utf-8?B?RHIvaFBrekxJQTNVZ1NWRTZQUU9QcFJpelJSaUpzZ29RcFl1S1lhc1Rrc09y?=
 =?utf-8?B?emlNdm15dkNqeTAxaUJwYkxreVhOdks5V2pkYVNiODE1Q0dUWG1UWVdTcGFY?=
 =?utf-8?B?QldIdENEU2RabEVBdE0vV1p5dVVxWkM3M0lqRjUrWFpjR08yd09lQU1jcEJJ?=
 =?utf-8?B?S2FRdFB2UzVaODdCZ0hXOHJhRk1yOXNiZk1CazFLTDBZcXhmUWhqSkt3eVVr?=
 =?utf-8?B?ZVpxSUxraEtUUEZwb0ZFSkdvWVN3RXpGczJUVEJMVGlCVUtqTjFUcE0rWkFt?=
 =?utf-8?B?ejhJMWhEcEJ1Y0VDSDdwN1FLbUtidlFoYnJEdm9kb2NkODNtQnprd2UxWXVX?=
 =?utf-8?B?M1oxd2hNVk5ocGpKdlMvbGF6N3lRUG4yMkIwQTRxd0xoeXMyU0NSa1c5cnU1?=
 =?utf-8?B?dk1tQmdDNytPbVBWSGV4VVlzVTlMRjN4am5yYUhiZmlHazltdUNCYUtJbktG?=
 =?utf-8?B?Y2VDNTdsTDg3SGwxMUtuOUdkbHJpN2tCUDE1UUt2d3QyMkpXVkdOYTA2MWw5?=
 =?utf-8?B?cEovR1AzNEZIaTNxbTkrRm1taVJzbWpXZk54WEpmZVMyUCtzRjlLZ2NOM3VK?=
 =?utf-8?B?VkZKc2c3Rk5sanBvL3R1VHhMRFJxR250OVJKVUlBS3RaQlgrVFZoNFlPUnZU?=
 =?utf-8?B?WjFwbHpPMjdjU0ltRDBwVkJqdnBuaVFRanRWYzU4bnhWSlN6RGtBbjNlVzZ0?=
 =?utf-8?B?U1NBNlNFRFp0SGY0cGZ2OU1mMzBCbDcxNTZQajBLMmFrbzJhek1vMFlSMjgr?=
 =?utf-8?B?VkdOVW1mT0hvemlrY3hFZ1ludUtKODJDSWtsYWt3N3VVMjhXcEc1MXRkd1d1?=
 =?utf-8?B?clBVVHZKK0F6NElpenl6QUhUa2JWRTNvbVMxeTRkVjJzRlBXRGhPalFUcWlO?=
 =?utf-8?B?MXd5M3ZLSjhYR1Q0aDNDaEJwamtySzB6L0VteW1lenczMUFBczRKQVd6Y0N0?=
 =?utf-8?B?ZDRIOU1EZk5BeUNGRFdoK1dqQktCZC94NGx5UWwrbU9zTi83SGJwQmIrYlZ1?=
 =?utf-8?B?TEtlTmhObllDU2R4Ukp2SFp6YjJJWlpRNVc2V01jRkN3aUtCK3NyT08zaTRF?=
 =?utf-8?B?bXZJUnRLTkRucnM0bEFyclpmeUtBNFlmdFJWOThyY3l2d3BNUi9Vc3VZc2NO?=
 =?utf-8?B?bHFlT2pYODBBalZYL3V0S1RobGNYd1ZNTHhmcEhXcitsQU9JajhXeVZmQUcz?=
 =?utf-8?B?THRCbGkwSktIVXFZZ2JsRXJpMWpzWENlLzB5SFVjQWJ2TWxpaThvREpUS2hl?=
 =?utf-8?B?L01LZHY4dVlPVllDZDJqQzYvdlVUazBxRGIwZWNxeUxtT1VGTndibnJNMmNj?=
 =?utf-8?B?REJuaVU2YWNHOEQwU0V2S0czUTN2WUY0UGNPLzZZMDRvN0c5YWpOdzUvVTNF?=
 =?utf-8?B?WkVmMTFNT1hFSjEreGdnaEthOCtybkphN0c3YkVrVEZQSGJmRmJKTm1zL2M4?=
 =?utf-8?B?bVZweTNONU5PTmt3bzNXOStLdkhBRzNPMTFKOUlaZzlNWFIvTUFOdXJmcFNp?=
 =?utf-8?B?WlFDV3ExMVZuNEYrRkI2bTJLV3NZc3ptRklaaHNhL2ZnMy8wS2xha2hidVhH?=
 =?utf-8?B?MGh5dm5xTU5hY3AyVHJNMUlEdlMzSzROYUpUUnQwdDRFSzJrbUpFK1BGdDdZ?=
 =?utf-8?B?ZUlMMWd0bHRGR0Z3SElqdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73019d81-c0f8-40bb-2576-08d900edd01d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 15:39:24.9815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: frQYsBVKrAJuF7vR7Ase/SOP0L9L2ECQ258+t52vP1ugcNmlbB5gbRxycKzqTur9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB4096
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: k9WzYygd2JGmHK6poT92UlZawSVUkF2v
X-Proofpoint-GUID: k9WzYygd2JGmHK6poT92UlZawSVUkF2v
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-16_08:2021-04-16,2021-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 suspectscore=0 impostorscore=0
 mlxlogscore=999 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104160114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 6:00 AM, Masahiro Yamada wrote:
> Since commit d9f4ff50d2aa ("kbuild: spilt cc-option and friends to
> scripts/Makefile.compiler"), some kselftests fail to build.
> 
> The tools/ directory opted out Kbuild, and went in a different
> direction. They copy any kind of files to the tools/ directory
> in order to do whatever they want in their world.
> 
> tools/build/Build.include mimics scripts/Kbuild.include, but some
> tool Makefiles included the Kbuild one to import a feature that is
> missing in tools/build/Build.include:
> 
>   - Commit ec04aa3ae87b ("tools/thermal: tmon: use "-fstack-protector"
>     only if supported") included scripts/Kbuild.include from
>     tools/thermal/tmon/Makefile to import the cc-option macro.
> 
>   - Commit c2390f16fc5b ("selftests: kvm: fix for compilers that do
>     not support -no-pie") included scripts/Kbuild.include from
>     tools/testing/selftests/kvm/Makefile to import the try-run macro.
> 
>   - Commit 9cae4ace80ef ("selftests/bpf: do not ignore clang
>     failures") included scripts/Kbuild.include from
>     tools/testing/selftests/bpf/Makefile to import the .DELETE_ON_ERROR
>     target.
> 
>   - Commit 0695f8bca93e ("selftests/powerpc: Handle Makefile for
>     unrecognized option") included scripts/Kbuild.include from
>     tools/testing/selftests/powerpc/pmu/ebb/Makefile to import the
>     try-run macro.
> 
> Copy what they need into tools/build/Build.include, and make them
> include it instead of scripts/Kbuild.include.
> 
> Link: https://lore.kernel.org/lkml/86dadf33-70f7-a5ac-cb8c-64966d2f45a1@linux.ibm.com/
> Fixes: d9f4ff50d2aa ("kbuild: spilt cc-option and friends to scripts/Makefile.compiler")
> Reported-by: Janosch Frank <frankja@linux.ibm.com>
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

LGTM although I see some tools Makefile directly added 
".DELETE_ON_ERROR:" in their Makefile.

Acked-by: Yonghong Song <yhs@fb.com>
