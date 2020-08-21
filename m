Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398D624CE24
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgHUGm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:42:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53074 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725844AbgHUGm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 02:42:56 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07L6ef0o024952;
        Thu, 20 Aug 2020 23:42:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=EisWmRtK2pAsaZckJYSYiZelDr1edqEH11rvAkusncQ=;
 b=Z3pSVpQcCe4JKufBZs8OrvjYimd8lYoqmpq9ttAstIwuCeNgd62yVryWUx20+D4dxYXj
 6m7PNX5aix9mB9OYzliZ1ckPCvbRDGlDGkiJeZJjGbyK5z3jFOTxkL5jbfN2LBcPqDc6
 TPCnXYvCzqZipeN+S3ot1b5xh6qymtot+PQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 331hcbxupr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 23:42:42 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 23:42:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLaH7/3edXF0ApFKBLJhatPmXHBdYp6SQ4hyKS1qnyvV933nKK14xqHZfbRpW5YJN4jVAI04YId7F6BFQJYGb7dZ0AoitesF6dKvFg+jKwvFlDIV+R+euMIEKzu5KE726XjF/aiIlqV8c1XGXps+plkW7/R3sUaoY/dSc6bSzEdmJmCTlN0kMdtk18szZav+wVBvWuoA9tP6ngxI5cUn1meiZ19JWWCsTwlZ+Q02oz71N/o/YppjsdTG4J15OXFB8wVqCVb6jG3YdISki31ak4x/XJg5FS/JqRPZHhIx3wtvgyl7zwA2lWBuv0jNYIb6WY4jRSt80y2/rbLfdTwrxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EisWmRtK2pAsaZckJYSYiZelDr1edqEH11rvAkusncQ=;
 b=S/firUkfiXGTVtJWhKstozpnFJbSWTnHLRjlGbyYBz2Oy6eVzxI6O+/TlBR6f42AU4Qj+Y05e4+a5lNMpNZEF9pXipoYgSQXDrObt7W9ExmYyHja6qJD5lU/rs2Vego3dY0cjF+2nJnY+OOvydh4Y9cNMFTYfFe6DdDX8iJ6onLSSAhU5ZHvpWqNqbBK8EB6tOkjfEaXTE1YZJt2VEqjoT/lh9V/6h0DNXNfc6TE7uaYabH1JFC3Uzo7DM/TUBPKGo/k2SXhbZZdBGLPo4i0Mhxil9bNllM1OcRfKTCrFE+EbE2bDD+hjv8a9chkMedhdhsGqpXMUHXZ46bk81+p3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EisWmRtK2pAsaZckJYSYiZelDr1edqEH11rvAkusncQ=;
 b=NGb8J/fndU/DpO7eVMF8eLIht3J/G70l8zaIQ6J/AMf3b265Rrj36uHVkbftFc+cq9totcaNQ2gN0dUJ/4UxAYArDbrSuJ4RtN2jAfirhTl/BmPyFymjGDfRtO7B3Gfnt9HG0B1iRccK1eJTiBtTZqtmS09mNdXDhqrn/mquJsQ=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3301.namprd15.prod.outlook.com (2603:10b6:a03:101::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Fri, 21 Aug
 2020 06:42:35 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Fri, 21 Aug 2020
 06:42:35 +0000
Subject: Re: [PATCH bpf-next v2 1/3] bpf: implement link_query for bpf
 iterators
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200820224917.483062-1-yhs@fb.com>
 <20200820224917.483128-1-yhs@fb.com>
 <CAEf4BzZ32inDH2MhLFv5o8PiQ9=4EGR0C75Ks6dWzHjVsgozAg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <08982c2f-b9a8-3d30-9e4c-4f3f071a5a58@fb.com>
Date:   Thu, 20 Aug 2020 23:42:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CAEf4BzZ32inDH2MhLFv5o8PiQ9=4EGR0C75Ks6dWzHjVsgozAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0011.prod.exchangelabs.com
 (2603:10b6:207:18::24) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BL0PR0102CA0011.prod.exchangelabs.com (2603:10b6:207:18::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Fri, 21 Aug 2020 06:42:34 +0000
X-Originating-IP: [2620:10d:c091:480::1:a192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3cddc7e-a492-4916-422c-08d8459d637c
X-MS-TrafficTypeDiagnostic: BYAPR15MB3301:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB330124CA9BBEC8876E7F0A6DD35B0@BYAPR15MB3301.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QwbpofUQ4V0Wlj7Y3ep29JXnOi1277sE9HV5uNObz4gcz8xlyxuA7Y2NtEIwmS+mdLi56+MHxfn2pN8p1i9jdcgtj/pX+ziDx5ts0v5UW1K4Iv5ML/XSX6siG2/Egf96E9rVnn7dwuyP88RXr+A/rb/cshuf7xTht5Ix78fBvB7ECSV5AlUgS4ZdZrfDC6YwxrMcXC7XoXeN+4aviSfrtGHeeTGFQH7fPcp8oqLDFL1MeUVHP0RYNcAsZXIXj38j2T/BkP/qol3vx/BqdpF7OOvkuckiaWqm2V1SzxOTq7ZK+gosoP78wIqyTei1+Gaw7asSZXUpb4RXOesrWLd++JuP5bEv73R/GD0Wv1KXDKIVVqUjchbchfGWIwxzVcn4Objsjz16lFHC/Zc2rFmTRShXIdG5COpRJAO/FzP161s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(366004)(136003)(396003)(2616005)(956004)(66556008)(53546011)(6666004)(8676002)(66946007)(6916009)(31696002)(4326008)(478600001)(8936002)(6486002)(31686004)(110011004)(5660300002)(52116002)(2906002)(66476007)(86362001)(16576012)(36756003)(186003)(54906003)(316002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ROi0+nEHZMxVrUAWga8RhlEod23ZLa6iYGPXkiUSNqbIBI/nTspgvcL7c+3Dvt1LaiC0y6kU85ZzlVYhUpjkOH9dGuhdqr8PqQTx8b16wPQBAMva3pNHBKlnMuIx7tM6YCAb6w9FYhYHTqnrmnCh9wVC3oiKkvS3ifbEskwbxVzObcnt+OUgJwHkn+O7G23GToevZqkyV7ZBDl7U/gI3D752sBwqyEEDsKYzAABhz0u++Bg1N91ABJBUZPztI2oCQB5b2Ox64+77J/9HRJGeM9aNhZpkZp2EBuXpF7w/wnjwFTngPZRmIuHzN1krGQUxo92rNs8dylRqyVzWzLMatTTQVrWHH8Tuji9uo9wXy1ChiUDVg3PYGEIOsEqmm4+2cWS4rXUWv2nywNHJWut0LpDANKByhhFI2Kb6C51wjKzYA3oPebpbczV3ai6jHamWBMy1O1k+lI7sLIuKQ5dDrFEU7cqDaJ6l/D+h9SZTm6USX+V3ahMAfE1vtUgnCQAoA9HaijsUdwFIK5PPsl7gXvOd91rZZLV2cW6HwQg/UdokyHD/B9v22X8L3BYfeNz9Z9bV+xm9S1qjZkPlF1yfGVcdUVOnn3Uppw5bRf3OrVBRGUvZFKlovF92/WA/8AQkpLsDKrlizObx6Z+HIyVA/gmw1lfWuh/O7ogngW1LFr2sNqosjHmnROfC6em5zLjn
X-MS-Exchange-CrossTenant-Network-Message-Id: e3cddc7e-a492-4916-422c-08d8459d637c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 06:42:35.6393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GlXYASzaoOGSV2JMT/WXDGmtPaPWZYwiGzUkxoE0Ywp+e3BUA8Ut/fvNqIHMxrfa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3301
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_05:2020-08-19,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=0
 mlxlogscore=967 lowpriorityscore=0 phishscore=0 impostorscore=0
 adultscore=0 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008210064
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/20 11:31 PM, Andrii Nakryiko wrote:
> On Thu, Aug 20, 2020 at 3:50 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> This patch implemented bpf_link callback functions
>> show_fdinfo and fill_link_info to support link_query
>> interface.
>>
>> The general interface for show_fdinfo and fill_link_info
>> will print/fill the target_name. Each targets can
>> register show_fdinfo and fill_link_info callbacks
>> to print/fill more target specific information.
>>
>> For example, the below is a fdinfo result for a bpf
>> task iterator.
>>    $ cat /proc/1749/fdinfo/7
>>    pos:    0
>>    flags:  02000000
>>    mnt_id: 14
>>    link_type:      iter
>>    link_id:        11
>>    prog_tag:       990e1f8152f7e54f
>>    prog_id:        59
>>    target_name:    task
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h            |  6 ++++
>>   include/uapi/linux/bpf.h       |  7 ++++
>>   kernel/bpf/bpf_iter.c          | 58 ++++++++++++++++++++++++++++++++++
>>   tools/include/uapi/linux/bpf.h |  7 ++++
>>   4 files changed, 78 insertions(+)
>>
> 
> [...]
> 
>> +
>> +static int bpf_iter_link_fill_link_info(const struct bpf_link *link,
>> +                                       struct bpf_link_info *info)
>> +{
>> +       struct bpf_iter_link *iter_link =
>> +               container_of(link, struct bpf_iter_link, link);
>> +       char __user *ubuf = u64_to_user_ptr(info->iter.target_name);
>> +       bpf_iter_fill_link_info_t fill_link_info;
>> +       u32 ulen = info->iter.target_name_len;
>> +       const char *target_name;
>> +       u32 target_len;
>> +
>> +       if (ulen && !ubuf)
>> +               return -EINVAL;
>> +
>> +       target_name = iter_link->tinfo->reg_info->target;
>> +       target_len =  strlen(target_name);
>> +       info->iter.target_name_len = target_len + 1;
>> +       if (!ubuf)
>> +               return 0;
> 
> this might return prematurely before fill_link_info() below gets a
> chance to fill in some extra info?

The extra info filled by below fill_link_info is target specific
and we need a target name to ensure picking right union members.
So it is best to enforce a valid target name before filling
target dependent fields. See below, if there are any errors
for copy_to_user or enospc, we won't copy addition link info
either.

> 
>> +
>> +       if (ulen >= target_len + 1) {
>> +               if (copy_to_user(ubuf, target_name, target_len + 1))
>> +                       return -EFAULT;
>> +       } else {
>> +               char zero = '\0';
>> +
>> +               if (copy_to_user(ubuf, target_name, ulen - 1))
>> +                       return -EFAULT;
>> +               if (put_user(zero, ubuf + ulen - 1))
>> +                       return -EFAULT;
>> +               return -ENOSPC;
>> +       }
>> +
>> +       fill_link_info = iter_link->tinfo->reg_info->fill_link_info;
>> +       if (fill_link_info)
>> +               return fill_link_info(&iter_link->aux, info);
>> +
>> +       return 0;
>> +}
>> +
> 
> [...]
> 
