Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D7F576BD7
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 06:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiGPEeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 00:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGPEeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 00:34:06 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D432FFD7;
        Fri, 15 Jul 2022 21:34:03 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26FKnDEb011560;
        Fri, 15 Jul 2022 21:33:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/E0k/uUcRiZH1U2omy7mvsc8XISkjoIk/dT0arHVKoI=;
 b=o/n8iAFh1dQlLCsj7etMc4VakpX3QBRG0P6YTnLBrakh6lDsoaNgK8tMmue6Bi79+MvU
 G3GnEFz9sa0qJRS+b2R24QG0QPUcIpDyvV/FnRaWJhAZTl9x6VnsW+ALj2PvAOpJAXkg
 N20dk2CIfMhWI6NLvWZt5ul7MF0pVwhI9VY= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hat5a0pra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 21:33:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAv1qZ5RS+hcMHaQTnz7RHelvSd+DPNtDBYYGu4U0oR9CX9p34TfmqJ205SNr7bGsR5H5SQRETUFanrvErgY68KJuRUhdKaZowLHUBUzMQd6HZ+qe4u+YoRzpX/Khj2PREl4z8tQaOBWvbq0fsTUaMZKWctlqkVnwJyLOjqOE4LjsayyMmxva3DolqrwKUgJF4VESCsgjAaReSbNAkhqjnM9/Gqa6m7YPQt+/85ZNIFlvNZ/r4OogducJcqfwKxonG7RGCBpeswOPZNT1BGLfOxUGWyquh2KfYuyD+TCsStiotz+v+pwPQP6YrhpwNEHGoMKYD51lUKcvwannaF98A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/E0k/uUcRiZH1U2omy7mvsc8XISkjoIk/dT0arHVKoI=;
 b=KHqTqcEAwh0A6OZKkkucH1At4i4+M7ebG7nsgW4YMdAWbWMVLWMmzTluYL1uzXoTLqjPQwuj5mHibc9Gcx6LLdVpnBwwz04i4is5dkp9NAwtj9D11GS5UMH4QInnLIecHtRTEKLRQU1+HuaHfQpiqnGryB5uDFOTI+OdH/Pvlh1XePm8/YoxI9DkEsEOMYDLrFppVgmn5YGQhpDGI8surC0SNBV+yM+vNQsxIR/lO4o6opRPmg937X6vqXN00w38BG95MvGWdGG6BWAv/c+0BD3+3I08zmpHaag8SZvIoTgdRZxKCC78w37aLI2q2ue0tTsddE5X6hGUxleHBNReWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SJ0PR15MB4645.namprd15.prod.outlook.com (2603:10b6:a03:37a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 04:33:35 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5438.017; Sat, 16 Jul 2022
 04:33:34 +0000
Message-ID: <bf56b01d-4c05-0d0b-e85b-219e55606803@fb.com>
Date:   Fri, 15 Jul 2022 21:33:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v6 06/23] selftests/bpf: Add tests for kfunc
 returning a memory pointer
Content-Language: en-US
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
 <20220712145850.599666-7-benjamin.tissoires@redhat.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220712145850.599666-7-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0120.namprd05.prod.outlook.com
 (2603:10b6:a03:334::35) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef47c817-a301-4782-c33e-08da66e45852
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4645:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2GZuv7N/sCHItcNyHVTz4nDszrTWJe3LPlo7gA1xU1g7ry5Ao3lt6+GYYCZnzDs8lnAxRWu+D8j5yuNictMdEq2ybyOZpLMiuKCsivlA//GP2vmT/44BX2T3jGHstiCAlFVL86jYSAl/L8/db37U76pt5eNQMPusOZeKl7x2JR1RPBECtSzFbFssglZHGh6E+TnTJ72qqtcr8+ybpW1x6c/ZamiScZXdB8UCfDWXKg0DmuRds3Izor/hVOSp70z4qrw6Wp5W6Zu9B9xv5rqUai7qIkCWIJixo7lPyEfx9iVKreNk5AE8VwdfPbgfJziFBvWgpLfMDsMdTJ5cHWn0J2DgGLeY7hWhuRcqIxElNNFqNyiGkAa0TfjGdW3uA2Vmfu5ZENEf+lGjav0BnKoD/rbexseEmplahhIRV5eLUdeWvnJ45lkxe0kYXUtV7TXx/w6K6K+PKdNMjDaLZW7OQU2nTDuxzrviZNFIwvZAND/qxtxun+VQuOmAzfPW0ag8jEJyXf1fiLA7srTmvWKWlTfd91ygjnoBlfl/FjpK3Jo9U1rIYAYlsvLQlTN4fRnWbeF5gHZ3HC8TmcrsgZSVyDzfSohZ8qd4070Bil+UL7H+0j9YJUY51cAW9I0RJxl/N+PqChcvAAeinLzdrWLMu55nUATC7zDPzNOvc603zvh0tmSKfII4Ds6RVR6CvATMYzIl2kYd40M27+sYeiyWYkHWZv6cFX26BTfxdUVcQD/xL26XGLpQmudLiMwziQsGCVPgTlDPvDByvj+Oqj/jbxjfTdNOqa+37xgiLa2LykAod5p5WKgwNAOpRT/arBpxQrjhzZdIqzsYcffvyLEeGmzxb5mqNw03CU5Z6RGkRwA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(8676002)(316002)(8936002)(4326008)(110136005)(83380400001)(36756003)(478600001)(6486002)(7416002)(5660300002)(31686004)(66556008)(66476007)(66946007)(6512007)(41300700001)(2616005)(6506007)(186003)(2906002)(921005)(53546011)(38100700002)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mml1S1RWcndKd3BuWCtLV0tLQk9hdGJlNEQwQjh1Qm9mTkgvRUsySDZ3T1Y5?=
 =?utf-8?B?bExkL0VCaHM0ZVRJMm0ydzk0aEVabHlDek4xUmdzUVJ0WDMyUTlCNERXempv?=
 =?utf-8?B?ZDczZTdHSmNJOTVwTHh2T1FqZnJJM25JTm13bkJXbnlTaDExdm5sNThyM0Uv?=
 =?utf-8?B?SGEwZXM4WW8zUUR0dEFVZFBSQnVFWmRSK1BJQi8rZDNNSElhYjlaQ3l1TGRu?=
 =?utf-8?B?Ty8yRStTaCtHQnc2YWx6d013b3lWS0RNNnk2Z2poTlIxcEk0cHQzTFptaFE5?=
 =?utf-8?B?aDFJdWR4alFBeDFSTTB0MU4xT09wbkJ2ZnUzLzVYMGxRSGYrQmUramRqYnRE?=
 =?utf-8?B?bVBoSmlDZ0lIR2NtOGE1V01JRVJURFZUSE43ZVdJWE42WXR4clpkdE00akVP?=
 =?utf-8?B?a2cxRjNXczdDL245WEJoQytOT1JpeE9yN3BnRnRVV0IvZC81VC9CT0QvV2hk?=
 =?utf-8?B?czFOc3ozeFpBN3VwanVmcERkam9aZ1ZYcFB6OWw4T2hrOEZuRENnN2JiOTB6?=
 =?utf-8?B?dnFYT3ZmZjdpeTJvSkF1RnNkM0t6SkszY1ZnM0Y1eE5XdjZEOVZCRThoV2Mv?=
 =?utf-8?B?Zk5OL3kxaTJ1aC9HZUhnTWJJWDZUMVQ5VjA4ci9hMFdPLzZ3bE9zTWRYYjVz?=
 =?utf-8?B?WTZ5cng2VmZ2VGpObzFrWS81c3VXZGU5bTFWcDdLSVZHRnNhajVZemwwbHgy?=
 =?utf-8?B?cWtwZ3gxTElBUEFhb3pOV3BkQmZlVHhDVkUyOHpDSHltZkFKZ1NYWWhZUlB6?=
 =?utf-8?B?bUNZell2Ny94anBCRXp3MWxCWnQ3eC8yR3RsUjd5bDZ4aUFzZWdiaktIOU9o?=
 =?utf-8?B?MWtmaW9aRFVGUkNQMlhpVnI4QitheTVJa3VBeDM0bjVnQVk3ZUYxTGx6UDhk?=
 =?utf-8?B?Rzk5bCtiZ1NLRWVpYUZmWkdGc3poMW5vU3Z6b3RiekU4VXZZQmtNNlpHOHlV?=
 =?utf-8?B?UkQ1MHBNOGVXcU5TK3dDNCs1L0tTUm03TmF5RkVrTDhUUDdFU21OZlBCRmlJ?=
 =?utf-8?B?aGx3eWs2YkFITy9JWXpNUTJ4eVZ2Mml1aVFaSmNRVjJkUUZNY3ZVYXBxbXFu?=
 =?utf-8?B?R1UwM3I2VXBBc3padnNWU0Fjc0VGaHgzOUt2a1J3bXJhVm85eldPR05ZYzA0?=
 =?utf-8?B?OTg4WDZBRTRZVGdMZHlOTmR5bnlUeFhlaytuS3FkU0xSbkZXdk1jRkFmci80?=
 =?utf-8?B?TWVRR1VQcThOSm9iNlAzSUJoQlpJdkJDSUZLNDJBUG1GWVFXVGZTVUJKRXVQ?=
 =?utf-8?B?RnBQNGNBYjl4cWJVbENtdGpvS2FUMEx5WHh5bEw3WStwaDhIUzJDRUtYc3Z0?=
 =?utf-8?B?QXJ1MHEyd2F4Y0FtS3R6aXBGOVdjUHlSL0NOU1JNRXZLRm9Pck96L2JjcnNN?=
 =?utf-8?B?WkhhdFg3QzY0VHVaWVhmd3BKaW1FT1hzSk1TOXEyNDFmUTgwdGpNOElVTFBV?=
 =?utf-8?B?L1FmQXVIV1BnaGtwTkQ2VVplSGdUajJxTzQyMWNzQWxCU3haeVYyK2gyTVRS?=
 =?utf-8?B?TUtHWDc3WFNtRjNwdHhnQmdXRmk3RGdHQ09TbXplZlVaSmFieGFJVDcwQTM5?=
 =?utf-8?B?L1Z3cXlzWlpOUjZPZkE5ejhBTWRlYjZzZWZPYVErVTl0Ni94UUVlUDFTMERC?=
 =?utf-8?B?ZkFicElRbzFyY3U0aGpkMHkwTGpYanpjSDI0NUJBaXBZalRqM0lOVSs2THBO?=
 =?utf-8?B?MWIvZ29hQUhmYjh1bllLV0hGL21NeDhHbk1WaitLK3pYTGI4ZGt0c3JBSEl1?=
 =?utf-8?B?eVZ4UHFOaGUzTjU3WDd3T2FZdTJhYU1IU3dUSEZmZWVxeTY5dEFXQ1NBd0g0?=
 =?utf-8?B?ejFXVHpreVZDYlg3WkFIOGlvZDRtbGpwTDFndHJlVjVQNy9MVG9FcjZ3dDFo?=
 =?utf-8?B?b3FRdG9PV0ZZZTVMZXZudGE2bGkzdnRxNWhuTEhrKy8vL2pwMS9KdUZ5R3Ez?=
 =?utf-8?B?dzV3c21xT2lOQnEwYTBwc2s0blg0OUIyUGZtSFNxZ3FXZVdqWGpYT3lja2N0?=
 =?utf-8?B?dUhiNXZrdm8vbzJJTjd1UmlES1ZFS1BscFFlVmFEa0FKQXlqckk2WVNydVZ1?=
 =?utf-8?B?VDRaTk9PUHJHZ01xYUF2M2k4NGZxQ2RXRzRqWG9jNnhmTDJFNHhjRWdKdjVF?=
 =?utf-8?B?ZU1LSm1CWkVSMkVzaVVUTkJ3WDYzbHIrVmltRTJURzFuUzJnQUowNDFrek5a?=
 =?utf-8?B?VXc9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef47c817-a301-4782-c33e-08da66e45852
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 04:33:34.8304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GR/l59+y0MXzcTSNqWfPu5iumA3mRXgPfsOC5q5GeDFZJ/jamd5O7nltmu90e6Ob
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4645
X-Proofpoint-GUID: C0GSx3o68rdKKte8Pwxehp_JkOIZR0eL
X-Proofpoint-ORIG-GUID: C0GSx3o68rdKKte8Pwxehp_JkOIZR0eL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-16_03,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/22 7:58 AM, Benjamin Tissoires wrote:
> We add 2 new kfuncs that are following the RET_PTR_TO_MEM
> capability from the previous commit.
> Then we test them in selftests:
> the first tests are testing valid case, and are not failing,
> and the later ones are actually preventing the program to be loaded
> because they are wrong.
> 
> To work around that, we mark the failing ones as not autoloaded
> (with SEC("?tc")), and we manually enable them one by one, ensuring
> the verifier rejects them.
> 
> To be able to use bpf_program__set_autoload() from libbpf, we need
> to use a plain skeleton, not a light-skeleton, and this is why we
> also change the Makefile to generate both for kfunc_call_test.c
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> ---
> 
> new in v6
> ---
>   include/linux/btf.h                           |  4 +-
>   net/bpf/test_run.c                            | 22 +++++
>   tools/testing/selftests/bpf/Makefile          |  5 +-
>   .../selftests/bpf/prog_tests/kfunc_call.c     | 48 ++++++++++
>   .../selftests/bpf/progs/kfunc_call_test.c     | 89 +++++++++++++++++++
>   5 files changed, 165 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 31da4273c2ec..6f46ff2128ae 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -422,7 +422,9 @@ static inline int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dt
>   
>   static inline bool btf_type_is_struct_ptr(struct btf *btf, const struct btf_type *t)
>   {
> -	/* t comes in already as a pointer */
> +	if (!btf_type_is_ptr(t))
> +		return false;

Why we have a change here?

> +
>   	t = btf_type_by_id(btf, t->type);
>   
>   	/* allow const */
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 9da2a42811e8..0b4026ea4652 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -606,6 +606,24 @@ noinline void bpf_kfunc_call_memb1_release(struct prog_test_member1 *p)
>   	WARN_ON_ONCE(1);
>   }
>   
> +static int *__bpf_kfunc_call_test_get_mem(struct prog_test_ref_kfunc *p, const int size)
> +{
> +	if (size > 2 * sizeof(int))
> +		return NULL;
> +
> +	return (int *)p;
> +}
> +
> +noinline int *bpf_kfunc_call_test_get_rdwr_mem(struct prog_test_ref_kfunc *p, const int rdwr_buf_size)
> +{
> +	return __bpf_kfunc_call_test_get_mem(p, rdwr_buf_size);
> +}
> +
> +noinline int *bpf_kfunc_call_test_get_rdonly_mem(struct prog_test_ref_kfunc *p, const int rdonly_buf_size)
> +{
> +	return __bpf_kfunc_call_test_get_mem(p, rdonly_buf_size);
> +}
> +
>   noinline struct prog_test_ref_kfunc *
>   bpf_kfunc_call_test_kptr_get(struct prog_test_ref_kfunc **pp, int a, int b)
>   {
> @@ -704,6 +722,8 @@ BTF_ID(func, bpf_kfunc_call_memb_acquire)
>   BTF_ID(func, bpf_kfunc_call_test_release)
>   BTF_ID(func, bpf_kfunc_call_memb_release)
>   BTF_ID(func, bpf_kfunc_call_memb1_release)
> +BTF_ID(func, bpf_kfunc_call_test_get_rdwr_mem)
> +BTF_ID(func, bpf_kfunc_call_test_get_rdonly_mem)
>   BTF_ID(func, bpf_kfunc_call_test_kptr_get)
>   BTF_ID(func, bpf_kfunc_call_test_pass_ctx)
>   BTF_ID(func, bpf_kfunc_call_test_pass1)
> @@ -731,6 +751,8 @@ BTF_SET_END(test_sk_release_kfunc_ids)
>   BTF_SET_START(test_sk_ret_null_kfunc_ids)
>   BTF_ID(func, bpf_kfunc_call_test_acquire)
>   BTF_ID(func, bpf_kfunc_call_memb_acquire)
> +BTF_ID(func, bpf_kfunc_call_test_get_rdwr_mem)
> +BTF_ID(func, bpf_kfunc_call_test_get_rdonly_mem)
>   BTF_ID(func, bpf_kfunc_call_test_kptr_get)
>   BTF_SET_END(test_sk_ret_null_kfunc_ids)
>   
[...]
