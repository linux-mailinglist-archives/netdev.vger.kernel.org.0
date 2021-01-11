Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1183C2F1A3F
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 16:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387863AbhAKP4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 10:56:33 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17036 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727996AbhAKP43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 10:56:29 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BFm9fX003030;
        Mon, 11 Jan 2021 07:55:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=svdS1BJFx5KyaaIz4RElJtD/a4H++HgIc3xm+O8JEYk=;
 b=qlpvstZ3JpJpIUbMN3+ek2Z8ZaF2210vE2XlF8tDyQ/8UQb3o0GkidacFp/A1OFJ3VnI
 i63pVbJzxWsJ1v7d0PBbbQqHj4vTY+hLRkPkOvGu7wtR7ritMCvwibAc4wE8JnKllZ/x
 SiPOVBO7P6rmzQa6/DsGp4QtyibbCNFdheo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35yweb58x2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 07:55:23 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 07:55:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXcNIzQmcRs32Z1S32GOKdsFKoZ1ZxNcmC+7FW6BOUPidVrsxKGaeb/Vh6tCHQLcCV9SAMRqjyT0tB6qVa6jVxbxr1k1DiNB9uGfeGqTONlx7QJKMzjkUjtFXm7CIcp2F7E1346+8Er6pSRabQWn9DSu8qFPi6ahb5l4ExnEZy23BUWQ3jf3+I73T9uurUgwd/HtRlo89nNBrzWPsKiwZu2BhppY+QiBfZdZkVLCE2vWbBi56wsujEJEFQZuFGunS3MZW5h9QQDpAs4pt9ymHz+7jJ1qTA83MHqidkY9CsELrCs3euap/U/aSvSEobBSXgWtB5nVdgrImB4cXrHvsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svdS1BJFx5KyaaIz4RElJtD/a4H++HgIc3xm+O8JEYk=;
 b=nRPfkoVaPt76YW5XLGK2RZXXYZyq9bbJUnAAZfEeMGdVgeEoQkUkSeqaFswr5BuWwajpi9AOGJIVW55oYjH9TIVGBvwbjmIxRrL9+izpnCU3StHnwLds3e9hUd5iZ29YnWg5s/ww3vVzF/RUShvG9HdqUgR6sdPm2C11zMPYePe2CHWI8VIx1TfJBHnOFppUP5f64JY3yuhkLfJYieWaE8j934qj+SyjTtrrhTcDf9iI6UKv+c6hcOsxRhm15+UHLNUR3cTRokLv8d3Iv3bZlhciTGbr+HZA1u/v6JiHfCE6GVKlaJYIV2bcKyF8Whjd1JJ0Fo2SXMmfvV0EbkRGbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svdS1BJFx5KyaaIz4RElJtD/a4H++HgIc3xm+O8JEYk=;
 b=fhp1oMJNqo2C6NkBWTmrrLMN6k0/zwngSr0G9SGLPT4ohHB2nPHuVn7z0WuHSGc86I8rGyfM1o69WbbuT7AOvk/QhkH8b9NdzD9NvS2W7TM2R3QQ4gsKbzwlWiygRzD9dH0fG/kck2DTVYprvWgqM91ZaDczLq2aNy2YpkhHDGY=
Authentication-Results: loongson.cn; dkim=none (message not signed)
 header.d=none;loongson.cn; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2775.namprd15.prod.outlook.com (2603:10b6:a03:15a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Mon, 11 Jan
 2021 15:55:21 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 15:55:21 +0000
Subject: Re: [QUESTION] build errors and warnings when make M=samples/bpf
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>
References: <e344c3fb-b541-0479-1218-23e4752daf1a@loongson.cn>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2ad0aae4-b075-45d1-c1c1-0da8fd98590a@fb.com>
Date:   Mon, 11 Jan 2021 07:55:16 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <e344c3fb-b541-0479-1218-23e4752daf1a@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:6450]
X-ClientProxiedBy: MWHPR18CA0041.namprd18.prod.outlook.com
 (2603:10b6:320:31::27) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:6450) by MWHPR18CA0041.namprd18.prod.outlook.com (2603:10b6:320:31::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 15:55:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8e1e882-5051-4a40-4735-08d8b6494cf6
X-MS-TrafficTypeDiagnostic: BYAPR15MB2775:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2775FB2268ED8ADBF3975B6AD3AB0@BYAPR15MB2775.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:152;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dG99H3QeRFOJO3jcRioCwv+780DxaPdS7Q8JMj06Hb1YkQlyjSyhu5w8e07RvoRe4WugZIx1F75qIIm0nLaveGZ8qfJzb77SDnDJMBPKbmIruvUcQBFsVZbkXsnqm5gW4OBvjG77ZgYoF/wX+ra6YuldoK6XUMY44HAwtSSjtBvtxXqHgqi6oYShuLxtB8v6cUTHT2op6QRx+ZJUoBWpY3EVS5UBqouFAeJy1jbQmzidschWDWsa/oCNyMMLfCHidB59FFkxgAEvr/cA83k2nriOhzhUz0rKSgwqjtW/N0Uj8GGIuxD4g983TMKJ/k3simgnVsvrvSH4TyYhWnowlQEtQmSzdw7REMvX8uyvShWfeWKNASJPejYWMQfkrRBrJe33gVdfS3Ja8Ewt0FMBVpz5YDDJ4J+u1rrxhVEDBsjrEo800KCUxV7Z85VsvoITsJCAM63vnGpVRD2NHp9hBuMBCvh3vjrfdzfNM71BXms=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(376002)(346002)(366004)(86362001)(110136005)(16526019)(2906002)(66556008)(66946007)(66476007)(316002)(6666004)(53546011)(186003)(4326008)(8676002)(5660300002)(6486002)(31686004)(52116002)(31696002)(478600001)(36756003)(8936002)(2616005)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UDZ3N0ZYZjBhRjdIUzJKdythT2FsTDBnVmhmbEtXSngwcitydnl3UVhLaVd5?=
 =?utf-8?B?UklWMSticW1ScnJLaFZUYWFrdm5ZTlgyMklHUDdwUm9wUmhNUGg4OUVRTE4y?=
 =?utf-8?B?eUtmMDBjcUZVUEozQk5hZWtYWjFuOVlxMVM1MHJYeVRjL0tEeG1DY245Qkts?=
 =?utf-8?B?ZWNVM2tjWTZ6V3JndFQwYWRLUXd2UjQzTzZIV2tPVFdESlBuS2hDMzJROXY2?=
 =?utf-8?B?eGVvdTdEbFc2MWpTbmlVUmFvdTkyM2x0ZkdsOXRvaFlYYmFWS3IwbHpKQVpj?=
 =?utf-8?B?dWVIVGE5RVhsMzI4ZHJ6eXRQemFmSzBXTjhOd2FPb2ZQY1FsUXFyTk9mZk9x?=
 =?utf-8?B?RVo4N2Iwa3RLRTdsUGRya2NkQktoRENhaVdUcGU0cUNOM0lYKzNFWUFZU3NO?=
 =?utf-8?B?REs5M3QrcGZ5a1NlRFFMSmdVRmZqblVBKzhVeUpId2tSTFpEZnE2RzkrMmJs?=
 =?utf-8?B?SUhTMzRodkt2Sk1jNjd0RFlKSCtTYlkva2JXZE83ZTM2RTE4aDRxQWZuKzNq?=
 =?utf-8?B?Y0h6bHkrTXJTc1dRQWJxOFVJcGhpTXM0a1lhemU4algvNklLWVlTRG9GLzRa?=
 =?utf-8?B?d0lwSWI2TDZESjRZVnUxeFBWaFlTQ2o4d1Y4VE9aTzVESlphajNaK3MxZWhM?=
 =?utf-8?B?YldNSVQwUEdhbzY3aDN4S2xQK1VhYTlTdTY0bkVQRXBIM25KaFh1M3QwK1RG?=
 =?utf-8?B?UnlNNW13eTB4Q1JmaEU0aTdJNFUvdUgwRUVvRU81aVNLUWhVdyttemoxS092?=
 =?utf-8?B?cVhrUHROeExWd1k3bW5MdHR1eFpJVWRGK1Y5bzV0K2FnVDVFZWRGWGt3T0sv?=
 =?utf-8?B?blhBY016TjhMd3dGOUVlY0s0ajZHU0FMeVNaYkw4b1Qxc0tHWWFVdDd6dWN4?=
 =?utf-8?B?RjdUaUhGSnY4NUNMaklKWDBxblNJby82bmpRRHlabkVvQzdvUk9lT2tUTFFr?=
 =?utf-8?B?VkxmWmVxQk1LRCt6dW8zeDdYYlloR0M1dmFHYm1DcnlweXpSa3VoSFBvRldt?=
 =?utf-8?B?UUpza0pydnBvei9NMnRiZ2dqNHFaU0lZWkdNZ0dteFFXNFY1ZlJsSUd4cUxC?=
 =?utf-8?B?WDgrOW81Yy91OWRxek1RaUtiUVFYdGh3bS9PVDZvaUpWQnBhaG1Fa1lIY3Q5?=
 =?utf-8?B?Z3FiVXdheHpxYnpGTUkxbTQ0Q1BPaVFmNXQ4cmVMcmJ5R1ZyWHBxMlhyTlNj?=
 =?utf-8?B?NmdvZ3R2N3NwWjhEUCs4ZDJVcGFVVDNYdWF1allGYmYxa1QwbVhUamE2NzMw?=
 =?utf-8?B?UEJxQ3dVNDhmaFM5UDJybnVNdEcyK2hKeU91TmFJQTN2L3dLNlRIUTJIRFE1?=
 =?utf-8?B?N1BtMW9CNDg1TGFTUCtYRW5vcWZpKy95ZEc0QWQ0bVg3WXhpNWdZWVVDcE9r?=
 =?utf-8?B?eTJKQWhGWVhuMnc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 15:55:21.1942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: b8e1e882-5051-4a40-4735-08d8b6494cf6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4QLJKjxb8Sm453uIpdw3Y7vz7OBc08Q8fg5ezhi/WScGYsKl8Seosov/RP4KuN7F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2775
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_26:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1011 mlxscore=0
 adultscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101110096
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/21 12:17 AM, Tiezhu Yang wrote:
> Hi all,
> 
> I found the following build errors and warnings when make M=samples/bpf
> on the Loongson 3A3000 platform which belongs to MIPS arch.
> 
> Are theseknown issues? Should I submit patches to fix them? (1) fatal 
> error: 'asm/rwonce.h' file not found

These issues may be mips specific. Sure you can submit patches to fix
these issues.

> 
> CLANG-bpf samples/bpf/xdpsock_kern.o In file included from 
> samples/bpf/xdpsock_kern.c:2: In file included from 
> ./include/linux/bpf.h:9: In file included from 
> ./include/linux/workqueue.h:9: In file included from 
> ./include/linux/timer.h:5: In file included from 
> ./include/linux/list.h:9: In file included from 
> ./include/linux/kernel.h:10: ./include/linux/compiler.h:246:10: fatal 
> error: 'asm/rwonce.h' file not found #include <asm/rwonce.h> 
> ^~~~~~~~~~~~~~ 1 error generated. HEAD is now at 7c53f6b... Linux 
> 5.11-rc3 [yangtiezhu@linux linux.git]$ find . -name rwonce.h 
> ./include/asm-generic/rwonce.h ./arch/arm64/include/asm/rwonce.h 
> ./arch/alpha/include/asm/rwonce.h The following changes can fix the 
> above errors, is it right? [yangtiezhu@linux linux.git]$ vim 
> include/linux/compiler.h [yangtiezhu@linux linux.git]$ git diff diff 
> --git a/include/linux/compiler.h b/include/linux/compiler.h index 
> b8fe0c2..b73b18c 100644 --- a/include/linux/compiler.h +++ 
> b/include/linux/compiler.h @@ -243,6 +243,8 @@ static inline void 
> *offset_to_ptr(const int *off) */ #define 
> prevent_tail_call_optimization() mb() +#ifdef CONFIG_ARM64 || 
> CONFIG_ALPHA #include <asm/rwonce.h> +#endif #endif /* 
> __LINUX_COMPILER_H */ (2) printf format warnings
> 
>    CC  samples/bpf/ibumad_user.o
> samples/bpf/ibumad_user.c: In function ‘dump_counts’:
> samples/bpf/ibumad_user.c:46:24: warning: format ‘%llu’ expects argument 
> of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka 
> ‘long unsigned int’} [-Wformat=]
>      printf("0x%02x : %llu\n", key, value);
>                       ~~~^          ~~~~~
>                       %lu

For these issues, __u64 defined as "unsigned long long" on x64 so we
do not have issues. On your system, it is defined as "unsigned long",
hence the warning. When you try to fix the issue, please make x64 works
fine. The same for above "rwonce.h" issue.

>    CC  samples/bpf/lathist_user.o
>    CC  samples/bpf/lwt_len_hist_user.o
>    CC  samples/bpf/map_perf_test_user.o
>    CC  samples/bpf/offwaketime_user.o
> samples/bpf/offwaketime_user.c: In function ‘print_ksym’:
> samples/bpf/offwaketime_user.c:34:17: warning: format ‘%llx’ expects 
> argument of type ‘long long unsigned int’, but argument 3 has type 
> ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
>     printf("%s/%llx;", sym->name, addr);
>                ~~~^               ~~~~
>                %lx
[...]
