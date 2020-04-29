Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2999A1BE91C
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgD2UwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:52:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41476 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726511AbgD2UwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:52:16 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TKj3EK008777;
        Wed, 29 Apr 2020 13:52:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gY4VbB6ZTmHqIDxrkdS9AhYkots02ayu1da8UXGwE/0=;
 b=gMLNllQKKDXUV8RETgHiWA3h0v4XIzuFIvAII5PtptkxZy4aESUxo1pNKCuVawmjOM2P
 NkqN6KH5yP7KC+F07x0cV4F9hyTHf7q39fxywufyHO/+cjMI2KjC3l5SUFSfjUkafg+q
 wZZ97K8ywkgU9+iZoOVBhiPdRDKK+OhYysg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30q4f8ck29-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Apr 2020 13:52:03 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 29 Apr 2020 13:52:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jX5LaqKhsMb2BykdmXShZF990Ac4GvCP0XbQohscAVkT4aTneZm8EzOiwUJ0RcvDGMiLywbzc71XUG8gOsxqQc2jLc6V+RCRPD+l95vNbGRUlz4EgXYvCXz6my2U1vePfhQJJx6vzDfMAP0mkE0kIeF3u3bzaAJG3RZquLhCjEBvitcbUjMcdQHiCSr85kRIJuxXmCxP8oZqUDa+zvN/NLBx3pVTuINTrMfmuUp9pIaDhEaeyrUEXOBr4gnMZMVgzkL9PCynu+QkXNo0NCMgegBWGlciM/Ig2vtevd8dOKXDnXeuUbYHAmlGXEkHIOuIJndsnGSQggC/T2KsS18xpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gY4VbB6ZTmHqIDxrkdS9AhYkots02ayu1da8UXGwE/0=;
 b=Mk8Sctu9mJJK21N1Vqs6G1A33d7XMsdHeO3xfP7XoWU65OPvbDibYw1JAy1uIXqhagghgj1q9em60Y3V3dtXHuWEXvygUYPVlaewdi4g5c/lM7WITLTaW+ECF0n0YZKfirYYMH9cZ8m6GnaGfF1x5OG1MK6vn/Cm91zp3GxdrPX4xGf7CnjSjFUKyeJf9+R41tqPwJBPxj+EB7MPelUkSHTpErG0/0XCGHEoKxE8aXh9q747g0daMnJE0iD53Y+ZQfAEg8LBzXV75XxTOCSrpZgArJ2dXXLH036MG3rDk6e3idPhI/7RVEk3bGXLQHJmvdSSQFR0bwaAZSt9ORYJDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gY4VbB6ZTmHqIDxrkdS9AhYkots02ayu1da8UXGwE/0=;
 b=UW1fBtVwNs2LjTuJEIP4EJKd8d7GOEeTLisk2JLNHo/f4rzFRGWVNzyZT3RjXENvMto2a4yuUt+6WJuyKl7irAml0Wot8z7awWi900q9yKkrQras76tD4sIrhSjOQnEAe0oTQakXGhb+G4qhNS/SoGCUA6p/sc6uXVmziEP0TVo=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2725.namprd15.prod.outlook.com (2603:10b6:a03:158::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 20:51:57 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 20:51:57 +0000
Subject: Re: [PATCH bpf-next v1 09/19] bpf: add PTR_TO_BTF_ID_OR_NULL support
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201245.2995342-1-yhs@fb.com>
 <CAEf4Bzaxg5P2kdoSVK+Tuch5hQVhSXS6c4fWYrLOSc=eWDdfqQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7624d62c-05f5-ccd0-1471-eb64d15ce991@fb.com>
Date:   Wed, 29 Apr 2020 13:51:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4Bzaxg5P2kdoSVK+Tuch5hQVhSXS6c4fWYrLOSc=eWDdfqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR07CA0074.namprd07.prod.outlook.com (2603:10b6:100::42)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:99f7) by CO2PR07CA0074.namprd07.prod.outlook.com (2603:10b6:100::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 29 Apr 2020 20:51:56 +0000
X-Originating-IP: [2620:10d:c090:400::5:99f7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b86a8bc3-5a38-446d-2da2-08d7ec7f2840
X-MS-TrafficTypeDiagnostic: BYAPR15MB2725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB27255F47E7C7D2007757C7A3D3AD0@BYAPR15MB2725.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(346002)(376002)(136003)(366004)(316002)(54906003)(66946007)(31686004)(31696002)(36756003)(86362001)(8936002)(5660300002)(6486002)(8676002)(6916009)(6506007)(53546011)(66476007)(6512007)(52116002)(16526019)(186003)(2906002)(478600001)(66556008)(2616005)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pPfufEhJ1R6kt2Cac3avqdRLj+TAba1VGrscEOsC34YKvKRiczkZAmJeCJD6ip0R3HlZhco14fhNqzkZ7eyB/1oyWxQEZ9xpugRD8gfgHo3HTqVaJS1TafPEG8hfvIfrsm7UNkUIgV+fFdx2sEmslO2TbPcqfqeaUCEdl91dkhWzuDmMn3q8l28K6u4orXZZVvVTeU/yZqWakNW0Hid7yGpKpO5+L8xfngheBwOw2DgjKo5ktWENJ4k7lRKoASKJv/HXSmgtFuqVWdasA7Az9itsbp8ddzHUIkcXeww9l3plXd8nYz1Mq2TSJKr3fungXzFHWEM/II5YsxS1Nb3mtTobj8n3XG/P53BNm5d0VF/E1Mf73khdd/x5pv/uALD6RRCqVA7Fz4SSmB1sySbrqoIFNeuWWoTlHXy1KnX4uVgfSoyXDkOkMA4ospYleEEo
X-MS-Exchange-AntiSpam-MessageData: of9EbDMqRsHjhu8gxapvbZMEM+m+WB22i0U49gERfeENR3zEuk9OIFaO/3zyDubuIpA9hYumI9hFlpzGbz1gu5agOTogbMvyE4/+TzYnS96UEITD0M+E1uHbuNNvSzhlVxNYeNAGceC0XqRVCh71L6xtICRn1+KMfQQR2S+h2sUJrgPpPdds9AO9rhLWbjnXa4HYNObY+9PJShpTlkBRiPPX7UOTPAdZAP4eUHPpX89kisazEgrJ2SoA06pdv/sd8tP+UxHwGVZnjE9iDvL1q5O8iNyxHQHQI2nYo+HYxs77GY/V71Tr735YpH8edVl7M0PZ3HsHVA/tL7tZ1wRDQjDwPuAkc+X5C2tRIZ9KgD3Yp6kV3o7jItuQHs+/JDp7q0Lng4umzRSK7sJ1K3A9lllHcdhUBM3L75DEomb7SzQUy9dhk4nZPXEwYXAQKSxUfxHxHvJGDh9a9X3vL53d1yMUA6JYTOusVoFi+WOTOSbhfUQlQnfKI2Enw0mxvR0Kp0LDRCEjom2zrKXRDfNP1ilZTdSdBjHYFlzJ4r7x0EoSpfhgFTPSAndoStGQ0eY+FFt6xJgP4E3ZyPdamDZBFDmiObQv27ApEsaYoiI90b3qVcYfOrAWWIxAajZNK2p5/ioiNzpYv4phz9WUKobG1A3UF9RgZ35uFMNIQcPPpxgiAUU1sJVHcfJJjWS9lVc1sA1cKoxXF6xrVGGa8K3I42v3e2+cfTK9/J6bjmSeXKpnnTM8m9XfWR4sk7AadYByFUhRYfI4n3B/QJzF+VnQiRp327vlQqCAlNS2pw89tltr/yw86GEU8GUmW5LoJd0HEX1Nj2pksQaPDn/gfGX4gA==
X-MS-Exchange-CrossTenant-Network-Message-Id: b86a8bc3-5a38-446d-2da2-08d7ec7f2840
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 20:51:57.8309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vZlIfnCEMIJdZCtsYF2kTvEbs5TItkDNhlSt9YrJrswXnYJpPojebdfzh2kBh1Wg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2725
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_10:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/29/20 1:46 PM, Andrii Nakryiko wrote:
> On Mon, Apr 27, 2020 at 1:13 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Add bpf_reg_type PTR_TO_BTF_ID_OR_NULL support.
>> For tracing/iter program, the bpf program context
>> definition, e.g., for previous bpf_map target, looks like
>>    struct bpf_iter_bpf_map {
>>      struct bpf_dump_meta *meta;
>>      struct bpf_map *map;
>>    };
>>
>> The kernel guarantees that meta is not NULL, but
>> map pointer maybe NULL. The NULL map indicates that all
>> objects have been traversed, so bpf program can take
>> proper action, e.g., do final aggregation and/or send
>> final report to user space.
>>
>> Add btf_id_or_null_non0_off to prog->aux structure, to
>> indicate that for tracing programs, if the context access
>> offset is not 0, set to PTR_TO_BTF_ID_OR_NULL instead of
>> PTR_TO_BTF_ID. This bit is set for tracing/iter program.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h   |  2 ++
>>   kernel/bpf/btf.c      |  5 ++++-
>>   kernel/bpf/verifier.c | 19 ++++++++++++++-----
>>   3 files changed, 20 insertions(+), 6 deletions(-)
>>
> 
> [...]
> 
>>
>>   static bool reg_may_point_to_spin_lock(const struct bpf_reg_state *reg)
>> @@ -410,7 +411,8 @@ static bool reg_type_may_be_refcounted_or_null(enum bpf_reg_type type)
>>          return type == PTR_TO_SOCKET ||
>>                  type == PTR_TO_SOCKET_OR_NULL ||
>>                  type == PTR_TO_TCP_SOCK ||
>> -               type == PTR_TO_TCP_SOCK_OR_NULL;
>> +               type == PTR_TO_TCP_SOCK_OR_NULL ||
>> +               type == PTR_TO_BTF_ID_OR_NULL;
> 
> BTF_ID is not considered to be refcounted for the purpose of verifier,
> unless I'm missing something?

You are correct. PTR_TO_BTF_ID is not there is a clear sign
PTR_TO_BTF_ID_OR_NULL should not be there either.

> 
>>   }
>>
>>   static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
>> @@ -462,6 +464,7 @@ static const char * const reg_type_str[] = {
>>          [PTR_TO_TP_BUFFER]      = "tp_buffer",
>>          [PTR_TO_XDP_SOCK]       = "xdp_sock",
>>          [PTR_TO_BTF_ID]         = "ptr_",
>> +       [PTR_TO_BTF_ID_OR_NULL] = "ptr_or_null_",
>>   };
>>
> 
> [...]
> 
