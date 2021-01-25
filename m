Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C1D3022D5
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 09:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbhAYIgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 03:36:01 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40866 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727061AbhAYHMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:12:31 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10P75dpG004271;
        Sun, 24 Jan 2021 23:10:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=QZZuuAUK608hiDd3Q08/To16meAw6N8oG3WerzhEeq4=;
 b=Cy6aUDi/j38onwxO/ElqcVyqBYGhcz9zs/zfVYCwTlK7rGLHssEuhGbi8EGzCXRVN7Jb
 6R4C/zXEste8yt8gzvJ4FY7x+YfmZ1xCOTZTDiEn/tO73jaPNT+yeDk+z4hYKfXCJNWU
 KHgWaFNOl8R42D8JTnxZMn4s8kyujoUemBg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 369509ujhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 24 Jan 2021 23:10:25 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 24 Jan 2021 23:10:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zm/Hr9cPohPaYdx8i6YPnv7jIqbk8z47VqmWGP2asYDiN7VEdiZTkuHMf6qsspWls/jLxevwQEPA/48gnrLuSCQGHfby4g7qzrZegrZDv6Iqwu9irKpxgQt24tf7mB1Dz8hR+4tgxNWH8/+TXbfyYIjz1uu+Bl829BEc7Is7q/r3gZrTm8V7+W3J6bdlzjbyD4/njE0h/3oI4/BQbYX9ztGmRxP8jqkmr9suYnmZZumJZWBQebjIWg5d4AcEIQwMEJG6F9bu3MGIFQpGUwtfkT2VFgrlQERCVxf56XjjaLx3O+Zqglbcjl+ojvN0s87l6BYahwcOI8Q7bpKZKP5X7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QZZuuAUK608hiDd3Q08/To16meAw6N8oG3WerzhEeq4=;
 b=SzmQMNTlZCAtq3vYL3PLh5vLXsQdBHdKODauCBGIibAQbW9Gzhjkxfb6wUv1k69UudRMMCoqHsbruKBtxiDgTCoLA8k2YNQmiDCewcdmU5334wzNpjfqrvC3ySGyrfQ+xYEiio5prcN6LkdYQrRGj7bkucS+emZdFax56+/zNRNRdfFcPHL4rnt4bftPSB2emvB2PE7xfVzqQPAf2DK6XxjxQSujisZANkU+I3rbAd3QAonbBzMc5MV1po7yCguhf0N4WGZliiNWNKB+ONNpuExK3KRivScv8YPKGjsFO0FTAMxB1HhEA0hiaZxRiJeDSDvTKsWZuDegY2TSbLbeqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QZZuuAUK608hiDd3Q08/To16meAw6N8oG3WerzhEeq4=;
 b=TyD1zMBQYN9KJZrUDNUTabrYp6eMj82rkP/1R0CmCb/TD1BW3fa2LJIPPTQUIwhSYfvXbyslIZdlG+HzHdB2d8xXNRfikb7GkTTY/ESNHOK49WVogyhV40UF6m6rBPRwak7OVj4iuNPHMpoRfkLw0RRnVbO57PrsJNoV24dnhiE=
Authentication-Results: loongson.cn; dkim=none (message not signed)
 header.d=none;loongson.cn; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3714.namprd15.prod.outlook.com (2603:10b6:a03:1f7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Mon, 25 Jan
 2021 07:10:22 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5%5]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 07:10:22 +0000
Subject: Re: [PATCH bpf-next v2] samples/bpf: Set flag
 __SANE_USERSPACE_TYPES__ for MIPS to fix build warnings
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-mips@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>
References: <1611551146-14052-1-git-send-email-yangtiezhu@loongson.cn>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <831a3003-d617-5eeb-b93b-595e1cad8eea@fb.com>
Date:   Sun, 24 Jan 2021 23:10:18 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <1611551146-14052-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:c1c3]
X-ClientProxiedBy: MW4PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:303:8f::34) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1946] (2620:10d:c090:400::5:c1c3) by MW4PR03CA0029.namprd03.prod.outlook.com (2603:10b6:303:8f::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Mon, 25 Jan 2021 07:10:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a2299fe-5330-4bf3-e2f9-08d8c10047a4
X-MS-TrafficTypeDiagnostic: BY5PR15MB3714:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB37141B81FFBEA4E7997C7EA1D3BD9@BY5PR15MB3714.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MEUbWIRNc+PnzYGMAmkIz74dJ7PR/WwskdCvQb0hiUv78zBAhTdQJhfqshWM6n+/mCrodPEkyS/oOcwDl32z1QnuLldoRwjdAWfJ79FDrbPKGuw0G0GYBnxol8KXZKkP8YkinPQDXmOxPrFEoI53Wx2wVo4JjLQo0szrLJg0E+fio0/C6/wJYnbYbzNFVu8lpSJYk2yG+zcyH1PzvoB/1s0OhKRwyPZ3efjChZOG4SAup7b5JzvlMIMPkHhvKdQPlanmuL8rbOfzWRL8JLXrcfsAef5H8v/NcF0T2to0JU0SKotMeDYAdpNZ1dyB81WM+Z7zx7/XUMlw03+PK7hcR/N/HHjlTbU6RFCokOnjnGaf9Z+v7/6EgoICZK0pX2rl7T/siDQ2ZlJpOUwexGyAZ8FLXxJgPPBMMsQDOLjEWOU6SrXd46XE0Mj2RZfqzwLCIrFa3Eihuq4OR1Xj/P2qgOsgxmIkulUontE/S8s6d0g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(39860400002)(136003)(346002)(7416002)(31696002)(66946007)(66476007)(2906002)(86362001)(66556008)(36756003)(478600001)(8676002)(4326008)(83380400001)(31686004)(5660300002)(53546011)(52116002)(110136005)(186003)(16526019)(8936002)(316002)(6486002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OEVvKzV0ZDV5WWVPMUdWak1SOXhLbkpvQVYvd2JqOUJUNFNpUDVZK3hsV1FG?=
 =?utf-8?B?RHhYVVN5aTdnSEIzSXlPZXFsd1NhY09QMGZTeTdxYm9iTTdYdXFaRWE3anlm?=
 =?utf-8?B?ajBqNlIycXA2cC9SRFVMMElHSVl6RzBSbmdTdmFIcXFkR3VNdVV6VXJxUmhv?=
 =?utf-8?B?RFVtZk12Y2xqWUJkZWwwdUQvT1QzUnBHckJjMnQvbnEyL1FuTjQyMk5xTlA1?=
 =?utf-8?B?Y28rajlzOGh0S3grS1RHWjR2L1htbmpnYTE0bzhMMmZiWWxaSXh4czZSa002?=
 =?utf-8?B?THVpT0lCWWFHVUlyT0hQR25sYWpBekFZQzVEVWJNa2JjbUlSNWFNZm9NS2tz?=
 =?utf-8?B?MjNzNlc1aUlRQmQ0ZzBLbkVBcGd1Q1BWRTZGZTVMZy9tbngzSGRHRWVFdEow?=
 =?utf-8?B?L2JHbWkvengzdHN2MFlnSGJhK1hRQnNWUXhleWNHNWdhMkV6aTQzK1VDSEhE?=
 =?utf-8?B?VW5SeGNpV0diZkxLd3RtVnZBU0dEazFsbzVsY0tnc2MzUmJOaXVFTitoS0Nu?=
 =?utf-8?B?Q0dmOGNtSmtYY0hEUkJWM1RwTUVUMk1rM2ZrRHpnWGVyeUhQNGIyOGp3ODZL?=
 =?utf-8?B?S0l1RU5kUDZZWjllNjVweWdicDJyZExmRVY2MjJBNzZhOW1Pc3JlT0oyRFdX?=
 =?utf-8?B?ell4V1FFMlpWakVGdVc5STZyTWh4NGswL29ja3RPZEl6eFNwckk4bitHVTZV?=
 =?utf-8?B?YkcrSGRIZnM1eDJFNzJhc25FZnJncnQ1QmV1Vk5iVDhCZm5OWWpRQkc3MTVO?=
 =?utf-8?B?RlN0ekF3NnNmZm1WQkc1eDVkSi8vZXRLVEF4UzFiMXdwb0NvZW51TENNdGNS?=
 =?utf-8?B?YVk4dHFnb05va0RleUdUeGQrWWVybzdYNGxJMUtYVnYyVEpsS3YrbExHUHRu?=
 =?utf-8?B?MlZSQzBLZ0hrVFRQbTlheUkrMHU3N21iR09MTkRuVkdWZmltcWsvajh3Rlho?=
 =?utf-8?B?OTdleVpRL1JVWkN4c0EraVVpVjVaWG9OcnBzTWQ0SGYxSDlBdHU5VXBGQTl5?=
 =?utf-8?B?REhQZ01yekdUbDN3c3dBNW9CeGtxcjUvNXNvMFN1L3FFWDJGUGMwbmlqY2Vi?=
 =?utf-8?B?eFJJK0FmcWsxanpGWmhKSFIveGdtWWZVRnF2V2MwRXo3RTJDT1lwQUtNczN6?=
 =?utf-8?B?M3NlRWlqQlhpMmwvWG9ESE92NDd3aHhZY3phcFp2ZVFCNTAzam5BTUVFM1ls?=
 =?utf-8?B?eDhTalFxVWIza0tuSktlRzZkRCtncXFJK2NjaWNuajhVT21wNGdIWnNFM3R0?=
 =?utf-8?B?WDVQVmUzckFIMGRHcWJVV3g2R2lXUnJJdVRLYU8zWEluWllOZ21BNVlpM2F0?=
 =?utf-8?B?ODc4RjUzb0xTc2RpazMvUzk4K25tamR3bC81eldNb2JFN2xudlI0U3M0dVc4?=
 =?utf-8?B?bVlqWkEwUTE0d0RqVmJrSWZUYmNKT0dLd294WmRzc0R5VmdGTHYrSjNLNWlh?=
 =?utf-8?B?cDNqNmgxa1BMdXF2VEVkYk5iZEdTYXpwOXhQNEhIdTBmcUpjYVhreTFqcXlV?=
 =?utf-8?Q?njPIl4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a2299fe-5330-4bf3-e2f9-08d8c10047a4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2021 07:10:22.0773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J6RZC9+turdNMZdS8FJoo9r0dPdCgGEIzWXsx0LZugLyz4JXTJh0nB+K2O6St/BM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3714
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-25_01:2021-01-22,2021-01-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 bulkscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101250040
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/24/21 9:05 PM, Tiezhu Yang wrote:
> There exists many build warnings when make M=samples/bpf on the Loongson
> platform, this issue is MIPS related, x86 compiles just fine.
> 
> Here are some warnings:
> 
>    CC  samples/bpf/ibumad_user.o
> samples/bpf/ibumad_user.c: In function ‘dump_counts’:
> samples/bpf/ibumad_user.c:46:24: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
>      printf("0x%02x : %llu\n", key, value);
>                       ~~~^          ~~~~~
>                       %lu
>    CC  samples/bpf/offwaketime_user.o
> samples/bpf/offwaketime_user.c: In function ‘print_ksym’:
> samples/bpf/offwaketime_user.c:34:17: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
>     printf("%s/%llx;", sym->name, addr);
>                ~~~^               ~~~~
>                %lx
> samples/bpf/offwaketime_user.c: In function ‘print_stack’:
> samples/bpf/offwaketime_user.c:68:17: warning: format ‘%lld’ expects argument of type ‘long long int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
>    printf(";%s %lld\n", key->waker, count);
>                ~~~^                 ~~~~~
>                %ld
> 
> MIPS needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
> 'int-ll64.h' in arch/mips/include/uapi/asm/types.h, then it can avoid
> build warnings when printing __u64 with %llu, %llx or %lld.
> 
> The header tools/include/linux/types.h defines __SANE_USERSPACE_TYPES__,
> it seems that we can include <linux/types.h> in the source files which
> have build warnings, but it has no effect due to actually it includes
> usr/include/linux/types.h instead of tools/include/linux/types.h, the
> problem is that "usr/include" is preferred first than "tools/include"
> in samples/bpf/Makefile, that sounds like a ugly hack to -Itools/include
> before -Iusr/include.
> 
> So define __SANE_USERSPACE_TYPES__ for MIPS in samples/bpf/Makefile
> is proper, if add "TPROGS_CFLAGS += -D__SANE_USERSPACE_TYPES__" in
> samples/bpf/Makefile, it appears the following error:
> 
> Auto-detecting system features:
> ...                        libelf: [ on  ]
> ...                          zlib: [ on  ]
> ...                           bpf: [ OFF ]
> 
> BPF API too old
> make[3]: *** [Makefile:293: bpfdep] Error 1
> make[2]: *** [Makefile:156: all] Error 2
> 
> With #ifndef __SANE_USERSPACE_TYPES__  in tools/include/linux/types.h,
> the above error has gone and this ifndef change does not hurt other
> compilations.
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>

Acked-by: Yonghong Song <yhs@fb.com>
