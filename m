Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386AC1CB65E
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 19:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgEHRxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 13:53:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48770 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726756AbgEHRxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 13:53:06 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 048Hq58K013135;
        Fri, 8 May 2020 10:52:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=v/RhlaFNR4KGeU5C1uuq96SEYGSPxQCb4i908K0m5Qs=;
 b=odWAYJjcyEtyz2+ydoP9bZ/WqZ5VEd2fcuaPjD3pZdyGmc/uvTZU7dUigpeWNiE4U0m0
 xzfsmRo0zXi7IRGAT9nN/7kTZrVn7NM9MCxjYRkMpTdmTG5kFP8XEBL7xCvh2MbJMPoW
 8f3TbXnwpiCa63LFeEE5IZ9sflp33AP+nDE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30vtdfd11e-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 May 2020 10:52:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 10:52:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5Cw5/qnwIDdnamCVwoxCvrNC/vdHHdGRq9ku9Lp7ghhPXjVUYquqBJbrXspYwpKyVYWNykTnIEVBfBDf8CQtYK9c7k6VcHZgA+G2jICcV41EzSPuCfZT5CIzQDaphAz5+pUi8aYJKckuJD1JTcsgTaIpmLyd3Gwg/6Zw5nz7T8plkM1q8/BfkwIVAUm9wJSiohGhI+fDx07CzUh3M53SOFgH0RYkbXdieaTRSH94eyYQupHqbQCEIBSvUqLCYL8QsxItB9rJLUBfRK4lvIvXyOTZvmDevbUH3SHvz68hw5XMJENRFmRSsyDlYLTd76/MBZKex2VSkaGy/jy8/Heuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/RhlaFNR4KGeU5C1uuq96SEYGSPxQCb4i908K0m5Qs=;
 b=MzEuWyfVLj4H2fj6oxHHisa6rppHOvaX7kW9Tue6KuB7/8EQ3gpgCMLF3MdJqeKGtQ1aMBNqrAp49DJaRhHB/3qwhcIcGCd2hvzyh1MmznhLhah1LJnaYP4eKmLtv2tAyQGsctOlT0QU09Wq4dsBadyrrH+uCHb3pC2wvtmx2d+LhUXlQQhbxI75fTlOiX5FbL4Ye15QqDMghliGAwZnOLAs7mJ6rlLB7Ig5krh8yfQpv6bvmrdkKVbfjI8YqM+Pz3iVTdf2yx00jsT3vFP+Atgra7VwHcnMLn3W0AdJlIsB/NcdnygpZHR9d+3stvcxjRUGp7iPRE7nderpwaLvsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/RhlaFNR4KGeU5C1uuq96SEYGSPxQCb4i908K0m5Qs=;
 b=ahmbI+F25b2myCQX+1gqRyy44asNamSWiqzPGv3ZFiLPoJmmo/9zw1lqKq7onCAUZfLmFMelTJhDebV+0jFza3ZZ64SiHCKH1tR3jVi5hkJwVxz6JxxxOzxnYqmm94z19Na4tUAYvNerqxCBSW7VUGvh5kh226WBK7SD5zsCZ88=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2197.namprd15.prod.outlook.com (2603:10b6:a02:8e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Fri, 8 May
 2020 17:52:36 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Fri, 8 May 2020
 17:52:36 +0000
Subject: Re: [PATCH bpf-next 14/17] libbpf: Add support for SK_LOOKUP program
 type
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        <dccp@vger.kernel.org>, <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
 <20200506125514.1020829-15-jakub@cloudflare.com>
 <CAEf4BzaE=+0ZkwqetjDHg4MnE1WDQDKFHqEkM825h6YMCZAdNA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c3eb3e32-237f-af0b-69b4-3233ab65490c@fb.com>
Date:   Fri, 8 May 2020 10:52:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzaE=+0ZkwqetjDHg4MnE1WDQDKFHqEkM825h6YMCZAdNA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:a03:117::19) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:8097) by BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Fri, 8 May 2020 17:52:35 +0000
X-Originating-IP: [2620:10d:c090:400::5:8097]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 861f8c07-e7a7-4330-4418-08d7f378977c
X-MS-TrafficTypeDiagnostic: BYAPR15MB2197:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2197FF0383D6F5915259AEC1D3A20@BYAPR15MB2197.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DtUYyDgyec6zXFJ4B59Cv9BN0zqqr4I+DVipp/mFKfiPiyE82jx7dVjG8URJbMz7X2C+UKOjHnXxhYX2kWXgAjBymgjK9/+mCDktxzkTybB6gDBJ/9UJVHQtYO6+epjfhj0yDO0o6bdC1GVve2uU9CBfMOU74rHPesHD8x+3tiLkfcB5KfKqCNV+2yaulav28QKWZYUPFVkCm5lBJd+xT4v7YWPUSRJubBVC/OSq8XrblbcaZtkZGU+mngwvKB3CvgzaOkRtsSyeCAYY0Njaf8TMaN9PmPRRdGBFsBWiPsyGY8uXCU0Sx3tZC5GCJ9bsyopSOgHagiiPpO8/xb/8w77oYKNe6lsHhn9IXuA5KTC1xW+lqobOhkZP7s0fLyr8X6HQaO0GGbsvbWVxM1L3Sue+UYiM9yBTnkUJ0hG/PmoXlGIrnNnTIqb9f6TDaLw9GR6dpvl9J5hsycW9YvOThLS+mmPCDzNPfSIGHCREr5XYgpJTj+IxpP7dJ4JKYB+/Nh3wZaKiKB4JBZWGd7ftUFR7WFuOgXi62+lFJ4XsKdKongprZTWQRtPZjIpbzGonZhh9StUddfxnpAAuvqi7Kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(136003)(39860400002)(346002)(376002)(33430700001)(7416002)(2906002)(2616005)(16526019)(36756003)(186003)(316002)(31686004)(31696002)(6506007)(53546011)(52116002)(86362001)(33440700001)(110136005)(54906003)(66946007)(4326008)(66476007)(478600001)(66556008)(6512007)(83320400001)(83300400001)(83290400001)(8676002)(83280400001)(83310400001)(6486002)(8936002)(5660300002)(21314003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: k6v9AzxKaVUyPcjI1V4RE4UHgqfbUiScvih5LUAtYwfwRsmVb32NenDmhYrAK7snTFZr3aY4xliPhGD7OeOS5fhUH65h8nyjAP7VQ9+AcOTnMvHgjsFDvw8gA+TL1mMDa/Bfgkk6zzIF7o8pcZURqrsyFEBnviw52qqGkbtlPzu90iA6H0tsYxEp/3JpcT5jSFHfTEDGlPv1HWBGNS/d9j+7JyeYlNa2lT+ojrPVVbE0/tM1IU8bVGSnBUTun2g2661OX9b2IeoOYJwsVd8WOMC7twmvvUQRUgtHWy0EjV53ilaPM97c9XlM7meuhfbc1V07zjVnNlQnIc51dEr85Nrr2Z6N3pq5FtV45BlP/vDYpmVpraKoxOiivsOAX3bmXICoO0f6/IhiXcrlJbM9CJv3ke7Uc5wy6DkKBzpXmuhfxg/+tQkNCsPL1tXOfHvBRjTJF/WiuZ3pjW5Y8EFkLviHx/3BA/jNuRzUQl/2avVlt5KlATTovBM/SUlegOI1uKKmfkNeJzXyEJ+jEpGLTA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 861f8c07-e7a7-4330-4418-08d7f378977c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 17:52:36.0472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: crLCnoolIxc/r11MQ/o4BeuOnhy6K23AmgMQM+9Em+xPMT9o1er3HAaMnEKdBorF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2197
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_16:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=999 clxscore=1011 phishscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/20 10:41 AM, Andrii Nakryiko wrote:
> On Wed, May 6, 2020 at 5:58 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> Make libbpf aware of the newly added program type, and assign it a
>> section name.
>>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>   tools/lib/bpf/libbpf.c        | 3 +++
>>   tools/lib/bpf/libbpf.h        | 2 ++
>>   tools/lib/bpf/libbpf.map      | 2 ++
>>   tools/lib/bpf/libbpf_probes.c | 1 +
>>   4 files changed, 8 insertions(+)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 977add1b73e2..74f4a15dc19e 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -6524,6 +6524,7 @@ BPF_PROG_TYPE_FNS(perf_event, BPF_PROG_TYPE_PERF_EVENT);
>>   BPF_PROG_TYPE_FNS(tracing, BPF_PROG_TYPE_TRACING);
>>   BPF_PROG_TYPE_FNS(struct_ops, BPF_PROG_TYPE_STRUCT_OPS);
>>   BPF_PROG_TYPE_FNS(extension, BPF_PROG_TYPE_EXT);
>> +BPF_PROG_TYPE_FNS(sk_lookup, BPF_PROG_TYPE_SK_LOOKUP);
>>
>>   enum bpf_attach_type
>>   bpf_program__get_expected_attach_type(struct bpf_program *prog)
>> @@ -6684,6 +6685,8 @@ static const struct bpf_sec_def section_defs[] = {
>>          BPF_EAPROG_SEC("cgroup/setsockopt",     BPF_PROG_TYPE_CGROUP_SOCKOPT,
>>                                                  BPF_CGROUP_SETSOCKOPT),
>>          BPF_PROG_SEC("struct_ops",              BPF_PROG_TYPE_STRUCT_OPS),
>> +       BPF_EAPROG_SEC("sk_lookup",             BPF_PROG_TYPE_SK_LOOKUP,
>> +                                               BPF_SK_LOOKUP),
>>   };
>>
>>   #undef BPF_PROG_SEC_IMPL
>> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
>> index f1dacecb1619..8373fbacbba3 100644
>> --- a/tools/lib/bpf/libbpf.h
>> +++ b/tools/lib/bpf/libbpf.h
>> @@ -337,6 +337,7 @@ LIBBPF_API int bpf_program__set_perf_event(struct bpf_program *prog);
>>   LIBBPF_API int bpf_program__set_tracing(struct bpf_program *prog);
>>   LIBBPF_API int bpf_program__set_struct_ops(struct bpf_program *prog);
>>   LIBBPF_API int bpf_program__set_extension(struct bpf_program *prog);
>> +LIBBPF_API int bpf_program__set_sk_lookup(struct bpf_program *prog);
>>
>>   LIBBPF_API enum bpf_prog_type bpf_program__get_type(struct bpf_program *prog);
>>   LIBBPF_API void bpf_program__set_type(struct bpf_program *prog,
>> @@ -364,6 +365,7 @@ LIBBPF_API bool bpf_program__is_perf_event(const struct bpf_program *prog);
>>   LIBBPF_API bool bpf_program__is_tracing(const struct bpf_program *prog);
>>   LIBBPF_API bool bpf_program__is_struct_ops(const struct bpf_program *prog);
>>   LIBBPF_API bool bpf_program__is_extension(const struct bpf_program *prog);
>> +LIBBPF_API bool bpf_program__is_sk_lookup(const struct bpf_program *prog);
> 
> cc Yonghong, bpf_iter programs should probably have similar
> is_xxx/set_xxx functions?..

Not sure about this. bpf_iter programs have prog type TRACING
which is covered by the above bpf_program__is_tracing.

> 
>>
>>   /*
>>    * No need for __attribute__((packed)), all members of 'bpf_map_def'
>> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
>> index e03bd4db827e..113ac0a669c2 100644
>> --- a/tools/lib/bpf/libbpf.map
>> +++ b/tools/lib/bpf/libbpf.map
>> @@ -253,6 +253,8 @@ LIBBPF_0.0.8 {
>>                  bpf_program__set_attach_target;
>>                  bpf_program__set_lsm;
>>                  bpf_set_link_xdp_fd_opts;
>> +               bpf_program__is_sk_lookup;
>> +               bpf_program__set_sk_lookup;
>>   } LIBBPF_0.0.7;
>>
> 
> 0.0.8 is sealed, please add them into 0.0.9 map below
> 
>>   LIBBPF_0.0.9 {
>> diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
>> index 2c92059c0c90..5c6d3e49f254 100644
>> --- a/tools/lib/bpf/libbpf_probes.c
>> +++ b/tools/lib/bpf/libbpf_probes.c
>> @@ -109,6 +109,7 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
>>          case BPF_PROG_TYPE_STRUCT_OPS:
>>          case BPF_PROG_TYPE_EXT:
>>          case BPF_PROG_TYPE_LSM:
>> +       case BPF_PROG_TYPE_SK_LOOKUP:
>>          default:
>>                  break;
>>          }
>> --
>> 2.25.3
>>
