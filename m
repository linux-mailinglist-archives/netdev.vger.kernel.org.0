Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27B91C64D6
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 02:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgEFAHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 20:07:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63582 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728717AbgEFAHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 20:07:38 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04605lT0028078;
        Tue, 5 May 2020 17:07:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Ej22LqxQ8kYbK9FRD8vAnj7h3+Ekgh+uslrqJN6KLBo=;
 b=csUleS2asbSYh4wLefSv/umhBkdOGR1A7DQ4wHoikvw8Xwm16QdJCdEp7MaxIVJyCCJp
 tDLKZcBKq+zras4ce06qyBIY8PTC7+ICoKECXMRv6rOxtwXSS5OVuKV2ULKOQt4UHEdS
 5U15iW+SpkBC/ofs8BNs4DEr+sixL1LlKts= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30srp66638-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 May 2020 17:07:24 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 5 May 2020 17:07:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnbaSzVqspZ4B5b1MZoc1EVVNE2kA7+4Mil1uVwZm2Pn9znppBj5GJWn6CxK2ZVDlpcu6DVrPF+6fkVfWuUVdKnXMASsKJ3UqJaeOIOKC4MsQHzUVCCazThb3cJxS5SyppZ3OigSGbrwk1pMJghyiI5O6htc/oTIqdiVtTmPfnQnqU5mUv9+pv9/EbzSIQJCIgrrStDoJPQ2s25WjQtsvGzDfcWtFk7zc+e9lCzYPVRnnTz7NtPo4e8o4kKDH33b11RCo8KeM+yEAZ/u3Bfxm0GZznxQrxjxylycHtUHz039fGj8AvDpnlYgMxo1LTnX8MS+Moi7hB3YsS8YgAgpJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ej22LqxQ8kYbK9FRD8vAnj7h3+Ekgh+uslrqJN6KLBo=;
 b=ieFvz64KVSmAuLIT6kD/bm6Tpa0K8nmgOd+OUeg3kTU9K3dwfzEDHPiDfhAIR22FQ7hr1JhtNsJ/oAwkxanNhodYN3B9ac8Mqfcnrgct1EIvQiuy/UdkhVcH4h6FAsthlk7fQHIoGVofcaKTPTl4mnF+FZmZVGQzIe7vYswifUX16ojXhMMaoen8O76JlH3ZMWgd3gyB6Fs94qAAGuZtYFfZxeYyZ/ox/zLCHjYb5Rjgi5IIB5ZtoysMDkYlxTGnrsKkq/+WX2Z4nfajIT2AkbNdPQ6f8nRIibA2a1vI64Cc/y+hL4jbrHTkRDyi2Era5AhGYv9PhI+6M281pFVoFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ej22LqxQ8kYbK9FRD8vAnj7h3+Ekgh+uslrqJN6KLBo=;
 b=AnZHIpgNI5d8ZRXBVhUb0pn77JfI3GM2GlpcKYk0KpX+WU2KqNJMP2+m0mtf19YiIsUg1JXLrYF4FKOhuR47XrHQaAKcoDBNX93jqFqZz4vDiJSWkkCrq2cvUKU0w/O/Jwoht9e3Q36MAh0sK41KIVDHf94Dv2IMhxdYydzuXmo=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3430.namprd15.prod.outlook.com (2603:10b6:a03:107::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Wed, 6 May
 2020 00:07:21 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 00:07:21 +0000
Subject: Re: [PATCH bpf-next v2 02/20] bpf: allow loading of a bpf_iter
 program
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
 <20200504062548.2047454-1-yhs@fb.com>
 <CAEf4BzY456K4YJt6JhGD4y0uDfdwmzJvHDjze=Cct9Akf1-9gA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2a01bde2-ffcd-02e0-0961-5b85f8b7c113@fb.com>
Date:   Tue, 5 May 2020 17:07:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzY456K4YJt6JhGD4y0uDfdwmzJvHDjze=Cct9Akf1-9gA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::41) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:f717) by BYAPR03CA0028.namprd03.prod.outlook.com (2603:10b6:a02:a8::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 6 May 2020 00:07:20 +0000
X-Originating-IP: [2620:10d:c090:400::5:f717]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07c617ad-44e8-408f-3314-08d7f1517249
X-MS-TrafficTypeDiagnostic: BYAPR15MB3430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3430B4DD97FC86C5A40B67DFD3A40@BYAPR15MB3430.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TADk/0q9tcVRQNqc6Gc2D0TgTltZOVfSjr+liz4J675wHdwe+P9e2ZUjn+L/oqXmLDDa4boV2E4GGBY62R5S3c9blfdII3EGU+YQgbV7fZF/3ovbVETti/A9G4IaYoU6KCBi1Dn81xPYxaF4EZP+uS4djumsa6oT1JyfbL1O/YYBtSUz6yb/yGvRUDRROtPc180Uuzjv8309yG7j5m42j5P83yOF4Sh4/Gi0jDl4JAsYVo60up5kf65znfeUGBVpZiH9tZuU0xsYDSZI00Nhea5p2JL1ndxq2gouDL5CV74cPdtkK6sNelv13160xkuIny7Dz8bgGxhkHqOP534Ci/yCEvz6rtkrqvoNuLOK6LluZsLgvhSVKi/TkL7KSASMsee+yxE92WvSMqdh5lh83Kib+AnRPwsxW+fl0bN7GljEaauK1j9+HpaVF6RHD7wilwpcveE1lYuHzPlL56Z4FdyouY4b9x6qFifVUlIQpZhhWopIDSCL3yQZZbbOPzVHMcbvDvHiH2iJZMpCgn2b2/Jd4Nc5G3vDSrHL0MGuXVdsPCaI8PYW3IVCQ32Xyej+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(366004)(136003)(346002)(376002)(33430700001)(31686004)(86362001)(36756003)(186003)(54906003)(6486002)(6512007)(53546011)(16526019)(2616005)(6506007)(478600001)(5660300002)(33440700001)(2906002)(66476007)(52116002)(66556008)(8936002)(6916009)(8676002)(31696002)(66946007)(316002)(4326008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Kbez8L4AREXxwxtc2f5CvUqRyAyQ4rEznKcUVxLjn73fncg3kyw/iMQ7a83L419XP7QqkaGBhgC2BJVWNkqytfGYbBuCNcGqKikb2il12d5rwQZ9qJSWN7dJBUdvADJTC/X2hHBoScorJXSR2V3E2Nc01ZZFVNTa9QyDXCiCZg48+bAK/PJXiGyYHmrppG8A4llDAbTj0HP8fRjKJHjVNeCjVnCno17BX41Z6ZjxkX/9FGPeaPYWdAn5T8dHfl1In5IJGnvcK+CT/EimwWiN+XBY4exfgvdUiqc/z4TItiIbsdfXb2Mf1CW7OlQgYMZzqyTMw2laxzqgftX4z/onJTiHlKyOZp063o7Vk8K4Hqt1xAutWDd6l8nW/52K+r5yVYUi6iwRgxHu+qubvtrrGvWgyciWjSH2UbKXeTShdXYt2mfxq42Im+RUOOTn7pQWFicuXzUIUY7KspYpvJWf3WYqc6lYeeaLmzmD5UCtTGv3FbJsuVkeDJaUfl6SLUj3X4nQYHLU17ayhOKYWrASE5hV2L4IGNccnB8+ByAcVavm+EOCQBRRsXejpFHn5sJqpOPVVHjtM7uV7dzbUkVwj1JYVAbQrzthyI/4mNorqMajrcFOY9f2u/mUo1U/FVsoXGndhgMmdHK1ejOCNmLncYGh+Yuo6eLbVPQZTcXAatUhvh74TVeCfz1Jbx1qAIKhRHYE63GObk5jRhkZfLic+01he+a9esv0rzEmBf5muV1nxO7wHHpHlwCilXc5EfF2zpyq/nGIfeNaq0b+R1XFkSMKfEx0Rzrco7fyBdIfwLH4Ay7enRO18vtb19XdV/MSXtJ4isK8Dxq0kyXTp3ORAw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c617ad-44e8-408f-3314-08d7f1517249
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 00:07:20.9388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1H+vqIQn2VzFlnABP9d2Lf0Ro+yd2KsJ4IXtRkGCPzyR/XLCaiNpP9iXSa4L+Vcd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3430
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_11:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/20 2:29 PM, Andrii Nakryiko wrote:
> On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> A bpf_iter program is a tracing program with attach type
>> BPF_TRACE_ITER. The load attribute
>>    attach_btf_id
>> is used by the verifier against a particular kernel function,
>> which represents a target, e.g., __bpf_iter__bpf_map
>> for target bpf_map which is implemented later.
>>
>> The program return value must be 0 or 1 for now.
>>    0 : successful, except potential seq_file buffer overflow
>>        which is handled by seq_file reader.
>>    1 : request to restart the same object
> 
> This bit is interesting. Is the idea that if BPF program also wants to
> send something over, say, perf_buffer, but fails, it can "request"
> same execution again? I wonder if typical libc fread() implementation

Yes. The bpf_seq_read() can handle this the same as any other
retry request. The following is current mapping.
    bpf program return 0   ---> seq_ops->show() return 0
    bpf program return 1   ---> seq_ops->show() return -EAGAIN

> would handle EAGAIN properly, it seems more driven towards
> non-blocking I/O?

I did not have a test for this in current patch set for bpf program
returning 1. Will add a test in the next version.

> 
> On the other hand, following start/show/next logic for seq_file
> iteration, requesting skipping element seems useful. It would allow
> (in some cases) to "speculatively" generate output and at some point
> realize that this is not an element we actually want in the output and
> request to ignore that output.
> 
> Don't know how useful the latter is going to be in practice, but just
> something to keep in mind for the future, I guess...
> 
>>
>> In the future, other return values may be used for filtering or
>> teminating the iterator.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h            |  3 +++
>>   include/uapi/linux/bpf.h       |  1 +
>>   kernel/bpf/bpf_iter.c          | 30 ++++++++++++++++++++++++++++++
>>   kernel/bpf/verifier.c          | 21 +++++++++++++++++++++
>>   tools/include/uapi/linux/bpf.h |  1 +
>>   5 files changed, 56 insertions(+)
>>
> 
> [...]
> 
> 
>> +
>> +bool bpf_iter_prog_supported(struct bpf_prog *prog)
>> +{
>> +       const char *attach_fname = prog->aux->attach_func_name;
>> +       u32 prog_btf_id = prog->aux->attach_btf_id;
>> +       const char *prefix = BPF_ITER_FUNC_PREFIX;
>> +       struct bpf_iter_target_info *tinfo;
>> +       int prefix_len = strlen(prefix);
>> +       bool supported = false;
>> +
>> +       if (strncmp(attach_fname, prefix, prefix_len))
>> +               return false;
>> +
>> +       mutex_lock(&targets_mutex);
>> +       list_for_each_entry(tinfo, &targets, list) {
>> +               if (tinfo->btf_id && tinfo->btf_id == prog_btf_id) {
>> +                       supported = true;
>> +                       break;
>> +               }
>> +               if (!strcmp(attach_fname + prefix_len, tinfo->target)) {
>> +                       tinfo->btf_id = prog->aux->attach_btf_id;
> 
> This target_info->btf_id caching here is a bit subtle and easy to
> miss, it would be nice to have a code calling this out explicitly.

Will do.

> Thanks!
> 
>> +                       supported = true;
>> +                       break;
>> +               }
>> +       }
>> +       mutex_unlock(&targets_mutex);
>> +
>> +       return supported;
>> +}
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 70ad009577f8..d725ff7d11db 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -7101,6 +7101,10 @@ static int check_return_code(struct bpf_verifier_env *env)
>>                          return 0;
>>                  range = tnum_const(0);
>>                  break;
>> +       case BPF_PROG_TYPE_TRACING:
>> +               if (env->prog->expected_attach_type != BPF_TRACE_ITER)
>> +                       return 0;
> 
> Commit message mentions enforcing [0, 1], shouldn't it be done here?

The default range is [0, 1], hence no explicit assignment here.

static int check_return_code(struct bpf_verifier_env *env)
{
         struct tnum enforce_attach_type_range = tnum_unknown;
         const struct bpf_prog *prog = env->prog;
         struct bpf_reg_state *reg;
         struct tnum range = tnum_range(0, 1);
......

> 
> 
>> +               break;
>>          default:
>>                  return 0;
>>          }
> 
> [...]
> 
