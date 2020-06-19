Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0EF2001B0
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 07:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgFSFjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 01:39:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18058 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbgFSFji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 01:39:38 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05J5Zov1032630;
        Thu, 18 Jun 2020 22:39:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=hssOyjzmred26mwhielFG6kz6wChBN6jzCcSYO3fH5s=;
 b=PlrhxmncZV/rfvbw4yXwyNZQJP+SMWELv+0NpMIs4Nb2CoYBJqBk7RAx7xgQXF91c79b
 wI6A1avST4ri91ofiTH+14J5+2ydBMFvcmGUj5EVdVxbG3SwlbPR3dgXuSVBEnGwcGnf
 QoWdPGElHhPXrdyseuiZIECGgkAbNh5m6Lo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31q66105re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Jun 2020 22:39:21 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 22:39:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4duUzXDIQbKTbofKKxqV0HyFNFcvd9uqgaVdnIcWuOox3TzcKCw3PhWk9QQ6BuNRWWDqkEgt8bSUGS/qxRq504OiX6JrnAlQBiLECfKSwiRX94x77ClR0UVdOz4Y6sQrTxT1YZOTZk2hSSF1t3v5VhgQrbtkhfLtfLF1aXdboMm4Ha3lyo0/kT67+CZzE5yvG2pS9L6Yd9rDREDT18qIeLz/ULhzQVQLG8q95dRmzN7cAi0eY/UZ9iou42oYdwT1jU0ronrCHyZyIIFNOGM0XVsZykBvJctpig8Chomwyoi/1pInexhJ5PJcjk9x1dmR+2Ag7rkk4qcxJa1OeKp1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hssOyjzmred26mwhielFG6kz6wChBN6jzCcSYO3fH5s=;
 b=cwsbrh43kiZA24Slc1H3l5B6GyBCCnEcdz5JVsRIv9qUZuMWKSGFRv1d3kIMmLAuYfODBSMd3hmuAE39+5ntApcJbyi36xl5hS2BvasktSSwu5MVWS7ohkAkPcY3a5DJK8Kf4rreErt8B6zdeJJiuRFGBIghdO5NagnLLSmKVgyFrK6Jw0Wx+WmHyLk5ncPHUr5tlEOGGtgCnlZW96MIeZY3NJcXh5MheME/PV5dbkFRKHw3MD7TZOYOKpwNZW/Nlmv/8OYTZq4BQcgLdjbABvtJ4qK7OSUhShBy4dGAFSGr11/34ko7+BHZmeI1Drw9WZKlm8oE7805Bb2RyoZC9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hssOyjzmred26mwhielFG6kz6wChBN6jzCcSYO3fH5s=;
 b=iTrcQhprRt4u4D0DjHYg7Z5YesarWRlfNql7+HMoeAe7ek18SNttqWY1DVSQubDE3u94/aI1o8ekqtJzjvUHUVE59YdVrWnyuhz5eTu0XPVjEwJ3OZlHD3UN3s0t2iLpH5X2r0X1/LWB2D+hG5eV1kRqAV7jEeMwO40Ea1i38nw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3570.namprd15.prod.outlook.com (2603:10b6:a03:1f9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.25; Fri, 19 Jun
 2020 05:39:18 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 05:39:18 +0000
Subject: Re: [PATCH] bpf: Allow small structs to be type of function argument
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Andrii Nakryiko <andriin@fb.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        KP Singh <kpsingh@chromium.org>,
        Masanori Misono <m.misono760@gmail.com>
References: <20200616173556.2204073-1-jolsa@kernel.org>
 <5eeaa556c7a0e_38b82b28075185c46a@john-XPS-13-9370.notmuch>
 <20200618114806.GA2369163@krava>
 <5eebe552dddc1_6d292ad5e7a285b83f@john-XPS-13-9370.notmuch>
 <CAEf4Bzb+U+A9i0VfGUHLVt28WCob7pb-0iVQA8d1fcR8A27ZpA@mail.gmail.com>
 <5eec061598dcf_403f2afa5de805bcde@john-XPS-13-9370.notmuch>
 <CAADnVQLGNUcDWmrgUBmdcgLMfUNf=-3yroA8a+b7s+Ki5Tb4Jg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4aec5fb8-9f9d-d01b-dd58-f15d50c5e827@fb.com>
Date:   Thu, 18 Jun 2020 22:39:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <CAADnVQLGNUcDWmrgUBmdcgLMfUNf=-3yroA8a+b7s+Ki5Tb4Jg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::22) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::11f0] (2620:10d:c090:400::5:b39d) by BY5PR04CA0012.namprd04.prod.outlook.com (2603:10b6:a03:1d0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Fri, 19 Jun 2020 05:39:17 +0000
X-Originating-IP: [2620:10d:c090:400::5:b39d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 136b5e40-9e75-4698-8619-08d814131c3b
X-MS-TrafficTypeDiagnostic: BY5PR15MB3570:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB35700D851FFD54D1C58182F6D3980@BY5PR15MB3570.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bp3JH1NTg06dE7nn5PnKmA6Ddrq+9jsT7S6nby+iOyVgn06Z+ipwfYANM0U5Q+IlhMEg+wo6L8IEHd/Vt+VAfxFcvSb5g9kqINKWuPc8P2kRuY1sVrVhVmFU/JgI1UdXqYLvtWUBu5bHZPU+Xe2ANysMekZnfW+flyDFdaaRM4eHrRGYRh0Rv1j26X4lBvHozracTPm8FN6MF4RHV4jrZH8kIr3Q0TMBOZjY8zg9hMLcitlTqX8/5LMc4/tBwn/wtzMf6Uxn+X7s8q6Q9y5lIodZAe6EnKGre+I+4YZ/EH2IEp0Rtx8MMV465aSARjjtvnsjYhQAiw40+xKVoqIoCZm4k5AwcOjG39oN1t8O45TmChLOoK8y2c0GB5zTP9RH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(396003)(136003)(346002)(39860400002)(366004)(316002)(6486002)(16526019)(7416002)(31686004)(186003)(478600001)(8936002)(8676002)(110136005)(54906003)(5660300002)(52116002)(4326008)(31696002)(53546011)(36756003)(66946007)(66476007)(66556008)(2906002)(86362001)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: vwJjoKju+g6ZE2SH6U5lCcuKOivTzeVcv8apihpdXaYSrkLx5+0m2gR2BT+mvS4mZTTTMNqwG/GgsQwBd9lzJps4Zy+eIvVlJdRGwu9xXorYHJmuiJ8g8s0w5gGKuWjj3egTP0di/dGoSSovW/hxdg9OsSIDShI77dTgGM1cMvrzBQ5nCfJRbGYCB2g7kUfUHhASwRvWQlB0LnM7PgtPEvo7Rpa9/ATGRpyDVfVzCNzv10aImGzu/MeMEehnbaF3o7T12/himDkWt7QQ/m7rNJ3SOizuL+YgeBWI5136LosvndSjCgljTWTnVBd4FMrrOGV5UqddM7LEemJNPOVb6nYAqtSlSU9dsFsA4kr0agGAAjaO5k6WZx4QW/stkvn9ecRUBMkGx2k6KuewIU068Wc7rOA9iVWchELfGUdL6J87ndRxU8ROQqGGrj63ALqel/zyiGu5Yg4v3psXjdyPXmWp/sxLE+3YXrTc2DnBzrgDB3xV/Qoa74SWnDbYBFifRBkah1DOZ6SY9g0t3AB2wg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 136b5e40-9e75-4698-8619-08d814131c3b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 05:39:18.5291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PrWy1ZlrSCFLel31BUjWwImgunXQo0YtLYSbvHUL56herV3G2TSutH2ieqZzzXDq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3570
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-19_01:2020-06-18,2020-06-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1011 mlxscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 impostorscore=0 malwarescore=0
 cotscore=-2147483648 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006190039
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/20 7:04 PM, Alexei Starovoitov wrote:
> On Thu, Jun 18, 2020 at 5:26 PM John Fastabend <john.fastabend@gmail.com> wrote:
>>
>>   foo(int a, __int128 b)
>>
>> would put a in r0 and b in r2 and r3 leaving a hole in r1. But that
>> was some old reference manual and  might no longer be the case

This should not happen if clang compilation with -target bpf.
This MAY happen if they compile with 'clang -target riscv' as the IR
could change before coming to bpf backend.

>> in reality. Perhaps just spreading hearsay, but the point is we
>> should say something about what the BPF backend convention
>> is and write it down. We've started to bump into these things
>> lately.
> 
> calling convention for int128 in bpf is _undefined_.
> calling convention for struct by value in bpf is also _undefined_.

Just to clarify a little bit. bpf backend did not do anything
special about int128 and struct type. It is using llvm default.
That is, int128 using two argument registers and struct passed
by address. But I do see some other architectures having their
own ways to handle these parameters like X86, AARCH64, AMDGPU, MIPS.

int128 is not widely used. passing struct as the argument is not
a good practice. So Agree with Alexei is not really worthwhile to
handle them in the place of arguments.

> 
> In many cases the compiler has to have the backend code
> so other parts of the compiler can function.
> I didn't bother explicitly disabling every undefined case.
> Please don't read too much into llvm generated code.
> 
