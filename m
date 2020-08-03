Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61866239D7F
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 04:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgHCCaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 22:30:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19448 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725820AbgHCCaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 22:30:21 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0732TVVf002816;
        Sun, 2 Aug 2020 19:30:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Xm3TrpEP/jS2tWW6RXSqPi+H85/3E6x++xj4AxZedcw=;
 b=p491Tomn3emOzK4WcouUBcP1wf6C7R3+UbjfP9mOgzk2JPHyVCGvH26fodr4FK6lGtNO
 K9n6OXsoP1uqKe9Q5zA0nryu7ddux3HRVBWSVW6ief3jqAuEr6sWqOkcZLmY6cZgO1oe
 TOSBAQZQcNg1pyAHHAErZ2F/rq6h5ZIOBzc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32n81fmxvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 02 Aug 2020 19:30:07 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 2 Aug 2020 19:30:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+SmUtXFW9Zku/b1AxBB5N9xeu4ujyr6kQWSzLjt7v35m2gBDxHrC4wCkSbDVtVzJpsA8bNwISL8N2o79FZrTqUE6zzR6DTKaPCSqMp67MQx+9A2/XzXmOOc8VIouOohdvt8OVnwo5h66zqNrINbDG8HTxYFbceGLVGJ1HSEbnPSjTT1UFnis2EF8TrsRwQNc3oz1worazbHgcfKxH0j2AMcXrFxJjS4gJ3iVbFsyfIPlaZG+Avj2e7QkMi0Enw/SKTHB4NCrG5/RXOF4Kkam/kkihDP9+YvlrD1ubudH8ofDyAi8Pnd9DdHonnrmky3+nmDyAUaswceQbIY7FhHig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xm3TrpEP/jS2tWW6RXSqPi+H85/3E6x++xj4AxZedcw=;
 b=TGAY+R+EnxxT3LxXIy9WVUB/BMgca+jW/FkwCtEg16H6o8gBl97p/WFiWwjGUeKV4DCFbhoiOjCR2j+HNOxpxZUFWimWgS+KD3e7nPKHF4PNrIfEm3P9qQC0pgbBBCYXBU27LenJrUnKpMw/tRjj/vYet0WWB9S9UuiINQUscDJyGl7ow/yAsKH8ZLW0zU4MOjBaLxPjjZnQzSSiFZcx7A3KczYiiE50i1EuHvY+r+ztBqzjeR7jlC2exFpOm6o8bK2pGTk+ljhi4h5h+T3S1wr3M6I73Jl5hkIW1ZDcpaeyW/dJ6yl26cCGIDGs6pJLl//15LCiTge+hNG3V4pX6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xm3TrpEP/jS2tWW6RXSqPi+H85/3E6x++xj4AxZedcw=;
 b=cVP1Sx4WKotnNwSboIelzmCkxnq66ytnTqPeH644Th5yA1d8ypzBm9XTTrLWH3lkJSxEiNjn7jEwR5t6zsha3VCixCafigZSKwlf+fTCQmb2x4r49ZTLMST2g+qlzVfMJC7rm9d0LsNRm3LByIIqbr0rHNBZTZT5sL5dv94saeQ=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3620.namprd15.prod.outlook.com (2603:10b6:a03:1f8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Mon, 3 Aug
 2020 02:30:04 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 02:30:04 +0000
Subject: Re: [PATCH bpf-next 2/2] libbpf: support new uapi for map element bpf
 iterator
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200802042126.2119783-1-yhs@fb.com>
 <20200802042127.2119901-1-yhs@fb.com>
 <CAEf4BzaeT1HULBE0dQULSF62Wm6=t49Dc8jjHVJ9Nt1noxeCtQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <bfed5f77-f64d-15f2-bbad-a1e6d9ddec0e@fb.com>
Date:   Sun, 2 Aug 2020 19:30:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CAEf4BzaeT1HULBE0dQULSF62Wm6=t49Dc8jjHVJ9Nt1noxeCtQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0060.namprd02.prod.outlook.com
 (2603:10b6:a03:54::37) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1092] (2620:10d:c090:400::5:342b) by BYAPR02CA0060.namprd02.prod.outlook.com (2603:10b6:a03:54::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Mon, 3 Aug 2020 02:30:03 +0000
X-Originating-IP: [2620:10d:c090:400::5:342b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f38d64f-d278-4f95-ac23-08d8375520ed
X-MS-TrafficTypeDiagnostic: BY5PR15MB3620:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3620D3483A8A53E97A1C2E8ED34D0@BY5PR15MB3620.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ZBDnLwnoLDBv9XdWOqA5S+NFq3LUjbIY3O5ijcleqCKT3mZL71bpwHOrGadgZCVV4lWwa6yg7RKPdczjcClpQIG2nOoeP7TO6cq8OlVKHgOOvRqECvm1R1NkvB/m8oBT53QINfRSErLen+5zyLMQHz9OY1yPlIi1yCwnIxvRcHb2XteVHIPp7w+tNXIq+m32ErXI28Jtv6TCY0uNm4V+qeIl9JcJY8EltDcQ5DTfxKdBqS+viDaV7nU7A8pNF3iUvAim0bwLP8llLvKY091B4ZP4/R2c+C0R2S2y7oo3iISty9D50w0DnQJe433KzsZddWJuMpdvyIw9n0XnqI4/3JlraSex3iMg2oQDUehuWnbBxjXnhgrklcF/PGDpDAK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(136003)(39860400002)(346002)(396003)(31696002)(66556008)(16526019)(53546011)(86362001)(66946007)(186003)(2616005)(66476007)(478600001)(52116002)(36756003)(316002)(54906003)(6486002)(2906002)(8936002)(6916009)(8676002)(4326008)(5660300002)(31686004)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: +c+b2v3SCuZUEU4Z3U5HIsXS6BJUDKTmmw7to3qPv4jG197XFyRKfuVZbihCLxRAL35LJDnlkEYvaNP1uX4mxjqjPjE6l3VYjpQ1chz2mmUB7EfcakZqD/tTFeE6ozB5a/RkRjapm9ZfojG0/mrgTYTvpMvrtdN5ts1LETXduN6VwZBkX9xHLMPwKYfYW3LHLxDIm9xT/WKQUsmKy2U1Z5CeNbaVn5Wg4zm/OFMgvMnBa85CWITPK1gqtxq4kCOyyumjxT/TkrNvfavEYdPTIlO6ggnEAQXzCKizQJTavBUOO7ba3IUQiPRwiMSm1Jjq2/hZMk6Bbwmb3MTjqjkvoYl7GlCacTzZg0j01DniIVDTkzapiXrltuzNun9q1V413S9nnZKLVYIOdNL0j/FwDSsgRfoos++PCOj8XA4CFn675Gilc8RwSJ7GRxb4/QyOiSBjoy0NaUySIKM0Jg6RsV7Yx/VCZgNZigV6p93v5iiQ6yUZ/C9Twe78qp1WadYo44J7GOBDi22sRf9XZaRm+5+jiC0qXv2WxMBWjaO4/onnGo65B+/RRyZa4i1IjyykTEVEldKc/YM3Ecno/R2M5VlAENv4MYOco46ijZNHH3MSi4RWyQDpcvP9byi30/pIM33X8tJM3M6YJJQQ1lAkBc3codUJihdZMOYJw6g50L7KpZakbOGRB5aFoggr+DpT
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f38d64f-d278-4f95-ac23-08d8375520ed
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 02:30:03.8769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8voF0KOnNmLyGmTJjEvzJY5MFEo3Ftd0S5ITvWcgeFyZX/o+DWZfULZJkGf3Q97o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3620
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_01:2020-07-31,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 spamscore=0 impostorscore=0 mlxscore=0 phishscore=0
 suspectscore=2 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030016
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/20 6:35 PM, Andrii Nakryiko wrote:
> On Sat, Aug 1, 2020 at 9:22 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Previous commit adjusted kernel uapi for map
>> element bpf iterator. This patch adjusted libbpf API
>> due to uapi change.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   tools/lib/bpf/bpf.c    | 4 +++-
>>   tools/lib/bpf/bpf.h    | 5 +++--
>>   tools/lib/bpf/libbpf.c | 7 +++++--
>>   3 files changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
>> index eab14c97c15d..c75a84398d51 100644
>> --- a/tools/lib/bpf/bpf.c
>> +++ b/tools/lib/bpf/bpf.c
>> @@ -598,7 +598,9 @@ int bpf_link_create(int prog_fd, int target_fd,
>>          attr.link_create.prog_fd = prog_fd;
>>          attr.link_create.target_fd = target_fd;
>>          attr.link_create.attach_type = attach_type;
>> -       attr.link_create.flags = OPTS_GET(opts, flags, 0);
>> +       attr.link_create.iter_info =
>> +               ptr_to_u64(OPTS_GET(opts, iter_info, (void *)0));
>> +       attr.link_create.iter_info_len = OPTS_GET(opts, iter_info_len, 0);
>>
>>          return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
>>   }
>> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
>> index 28855fd5b5f4..c9895f191305 100644
>> --- a/tools/lib/bpf/bpf.h
>> +++ b/tools/lib/bpf/bpf.h
>> @@ -170,9 +170,10 @@ LIBBPF_API int bpf_prog_detach2(int prog_fd, int attachable_fd,
>>
>>   struct bpf_link_create_opts {
>>          size_t sz; /* size of this struct for forward/backward compatibility */
>> -       __u32 flags;
> 
> I'd actually keep flags in link_create_ops, as it's part of the kernel
> UAPI anyways, we won't have to add it later. Just pass it through into
> bpf_attr.

Okay. Will keep it.

> 
>> +       union bpf_iter_link_info *iter_info;
>> +       __u32 iter_info_len;
>>   };
>> -#define bpf_link_create_opts__last_field flags
>> +#define bpf_link_create_opts__last_field iter_info_len
>>
>>   LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
>>                                 enum bpf_attach_type attach_type,
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 7be04e45d29c..dc8fabf9d30d 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -8298,6 +8298,7 @@ bpf_program__attach_iter(struct bpf_program *prog,
>>                           const struct bpf_iter_attach_opts *opts)
>>   {
>>          DECLARE_LIBBPF_OPTS(bpf_link_create_opts, link_create_opts);
>> +       union bpf_iter_link_info linfo;
>>          char errmsg[STRERR_BUFSIZE];
>>          struct bpf_link *link;
>>          int prog_fd, link_fd;
>> @@ -8307,8 +8308,10 @@ bpf_program__attach_iter(struct bpf_program *prog,
>>                  return ERR_PTR(-EINVAL);
>>
>>          if (OPTS_HAS(opts, map_fd)) {
>> -               target_fd = opts->map_fd;
>> -               link_create_opts.flags = BPF_ITER_LINK_MAP_FD;
>> +               memset(&linfo, 0, sizeof(linfo));
>> +               linfo.map.map_fd = opts->map_fd;
>> +               link_create_opts.iter_info = &linfo;
>> +               link_create_opts.iter_info_len = sizeof(linfo);
> 
> Maybe instead of having map_fd directly in bpf_iter_attach_opts, let's
> just accept bpf_iter_link_info and its len directly from the user?
> Right now kernel UAPI and libbpf API for customizing iterator
> attachment differ. It would be simpler to keep them in sync and we
> won't have to discuss how to evolve bpf_iter_attach_opts as we add
> more customization for different types of iterators. Thoughts?

Good suggestion. Previously we don't have a structure to encapsulate
map_fd so map_fd is added to the bpf_iter_attach_opts. Indeed, we can
directly add bpf_iter_link_info to link_iter_attach_opts, and this
will free libbpf from handling any future additions in bpf_iter_link_info.

> 
>>          }
>>
>>          prog_fd = bpf_program__fd(prog);
>> --
>> 2.24.1
>>
