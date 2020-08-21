Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812F524CE2A
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgHUGpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:45:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27444 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726119AbgHUGpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 02:45:08 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07L6f2WJ020633;
        Thu, 20 Aug 2020 23:44:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=yISYY2dh8ZzfetWhbAU/zc4dKf7mNTzad3vqv8JUNtg=;
 b=dVSGG5A1GIDmj3MYpMh25SCrzhjhiQT56pD9NDmB654FiGD06o0qqjDP/6HP+79rHH+1
 YfjzM6GwXs/ln1TYh3MkR5PKA8FXz/CH7pVJ3ouKDXCekaoI+dmcHHv8KGL918fXYrss
 S+28ESNZY7epT03nMA25MilbHSarXt6EW+Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p3tvnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 23:44:53 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 23:44:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d931I/chfWuq3/54zi51SiD93KyuVRPW0h9GIz+3nK9TbkFQ0ZueCVEi7PUUFD7iNY6imRM129QFj6Ki0N8Kde3ktQBh5Xaf/ghukN8qWghk4dNt/SzejZ1JlvVxPVueChKearGf/BHxsDKI7P5V5rCzOH9Lp05JwMw4+GapdIFExXYHhn8/cNcEBnuP4jx7D5E2uiN1UYSoDCGojoZUYynyS9pmY+KLyrbqV/8q6XWg4TpL49jLpd475gonwFV9Aqe+o2kvoBJja3dl8UklmPBArAZhW1YuiJdTarWMbsGfOWKMkUcu2K+/BaQkNCrRqeyzBHX9FZWqmIQfUY9pPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yISYY2dh8ZzfetWhbAU/zc4dKf7mNTzad3vqv8JUNtg=;
 b=SgrfBRHhClthNVCMJMjK+jIp8I7fXmKQaCsXpIfP4evnN4IKS1Wsu8Qo9sgmRtQBMBv+LHflceG60DMqDRiBDefWG+V95Pk9pwApI2rvdGUYhWHOJiWUHzxW5USUXPCmgwEyNFB3kh294v2iJ/hmnY7e8rGU8CkCqKlabcYsWe4mYlUd/36lmUtuHoaGQabfn/6cOvPTP1hKCcTYYgmeeX57jNnmpGg/KTvGBooVCi1yFrCZvWjw+bP8HmM7cELZ76X1ZFAZ5Jh9q3bP+tf0a4FWJgkIM66JtWaij2mPZ1DpsLNjKzzpQ5FAptno8QiN3BiZr4lCoXf4vEIltvOnmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yISYY2dh8ZzfetWhbAU/zc4dKf7mNTzad3vqv8JUNtg=;
 b=XQaKv+rVk7Y5bSnQOYV9tYrporb0kA1ada6xAyrkHr1Hneq6nybHm0gaQldaYnthV3B5XwhYuoyKzKbZBo1DEHMbiWlTK8L3n39UbA52+xf5nF/+KExNf51+FSRsMb2BmB1PgwVp2rilYboOspLue7azXW5b3OnxwdIIgxGM6+o=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3301.namprd15.prod.outlook.com (2603:10b6:a03:101::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Fri, 21 Aug
 2020 06:44:50 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Fri, 21 Aug 2020
 06:44:50 +0000
Subject: Re: [PATCH bpf-next v2 2/3] bpf: implement link_query callbacks in
 map element iterators
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200820224917.483062-1-yhs@fb.com>
 <20200820224918.483254-1-yhs@fb.com>
 <CAEf4BzaqMO5YgDhSf2gmhbDsp8md5kfvyrUqOc_AyD_3jJBmeA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <dfc3ce7f-35df-a2e4-1c0c-4e2669fbe8b4@fb.com>
Date:   Thu, 20 Aug 2020 23:44:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CAEf4BzaqMO5YgDhSf2gmhbDsp8md5kfvyrUqOc_AyD_3jJBmeA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:208:23d::30) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR06CA0025.namprd06.prod.outlook.com (2603:10b6:208:23d::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Fri, 21 Aug 2020 06:44:49 +0000
X-Originating-IP: [2620:10d:c091:480::1:a192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99a91e93-4216-4dbc-5404-08d8459db3fe
X-MS-TrafficTypeDiagnostic: BYAPR15MB3301:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3301FDD332D5860292C84942D35B0@BYAPR15MB3301.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 52Gqzw2BUiGDiLvdl6BEGvC/zw38kjQn65Jnko4oo2vrKjcoN6QoruWIlvRRTVAMf2fzvQBsLiOgnO5Vl7JZZBHJNY+EmjTa3ZnZn6UjyaeeAP9RtViplwaoEfkz5rN9DMOttbztp4yD1ThlVrzaSSC4tzLbu4A12clHKY+TJcJAiEEtxNrx75UfGM8A50+uwCygBGh3EXDFIZGs2hNy+ue5o/EdFUkjXE3VwWfngZ8dw9Kgg4eTrVqEuJNnZXiWlU6acdAwL8IOtHigQfsoGL0MyZ5nXnNECX3is6LkJUJ8GFtLfYWEUk2stjcTERfVbrzzBEOjARa6BD2mbtDplScSilUdqosDDEHzRwvGtrPRUViLIyRySHIszbgCt4LW1dTlDRuN0/ssqFcuBkgk5dUlACmJuMGCZ4Ev4C9jKpY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(366004)(136003)(396003)(2616005)(956004)(66556008)(53546011)(6666004)(8676002)(66946007)(6916009)(31696002)(4326008)(478600001)(8936002)(6486002)(31686004)(110011004)(5660300002)(52116002)(2906002)(66476007)(86362001)(16576012)(36756003)(186003)(54906003)(316002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 4Uylzly6s3CY5VkmA1l3vKkwEeHcEOIA3lhri9EI70y3G3iwgTlXkoxoh4xLJc29576oAxFi75mcRH+ZAn38xhE+MtwvcCUOVq38TyC4s5sbqEJBM01k2MsPimm7rtZwDSFh+TboVy4+yPTU7BJEzzdCYQM5lZOybZwwlZYzHq6/2Z9Re7BBp2PSUSNVvZCRmGaYH5gaJCIb31MVA1poi51VUgSf75fD2WDbn/xkVS8ub7Vd9keTr2qz12U+Aw2pj9y95t9V7LLY2chs6cKP5MyIja4L05uqr84HJouiBpHnloyxD3W87giSS4Odtk7tWAf13yZut1yXuUEOPgKZeRlVK2vl02LU/IerRz3lDnLM0Z3YWONehLQvzGAzSoWPCmd6WmN43oQyRja4lArZ51ogRZm3kKuUA/6QlS0t8/LiWc/q9Ll8gPbEwx0CVQ0E/ENoqz/sure955qDBQifmGCwZwOLvGzG5LidWZvXUba+wkIrpXuM923DWbNXEXzF0qX/TD4UXqS2m4LFoowEHMnwZQPQM+6RYA0mMBxLnf1aUmXpxJi0KhoDK455LxBI6NP8oWVGLcQ4Q8FDqw4JyprPjmh911SL9j/qNXfxGr4cb+uNCNLi0kWYQfZWon08Zg69dtsPc1ayQyE1Ky3Kug1qd+DFSUQpaHtnYuAkCR7lqiDv8MIIEctyaYz4NzoB
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a91e93-4216-4dbc-5404-08d8459db3fe
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 06:44:50.6925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R1X/SaKc50JNHwKqVDeBJqm8yiMCnowh9XS6CwGKaIByOTraceDq8xmtGsQ/+bKP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3301
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_05:2020-08-19,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 mlxscore=0 clxscore=1015 suspectscore=0 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210064
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/20 11:33 PM, Andrii Nakryiko wrote:
> On Thu, Aug 20, 2020 at 3:50 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> For bpf_map_elem and bpf_sk_local_storage bpf iterators,
>> additional map_id should be shown for fdinfo and
>> userspace query. For example, the following is for
>> a bpf_map_elem iterator.
>>    $ cat /proc/1753/fdinfo/9
>>    pos:    0
>>    flags:  02000000
>>    mnt_id: 14
>>    link_type:      iter
>>    link_id:        34
>>    prog_tag:       104be6d3fe45e6aa
>>    prog_id:        173
>>    target_name:    bpf_map_elem
>>    map_id:         127
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h       |  4 ++++
>>   kernel/bpf/map_iter.c     | 15 +++++++++++++++
>>   net/core/bpf_sk_storage.c |  2 ++
>>   3 files changed, 21 insertions(+)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 529e9b183eeb..30c144af894a 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1256,6 +1256,10 @@ int bpf_iter_new_fd(struct bpf_link *link);
>>   bool bpf_link_is_iter(struct bpf_link *link);
>>   struct bpf_prog *bpf_iter_get_info(struct bpf_iter_meta *meta, bool in_stop);
>>   int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
>> +void bpf_iter_map_show_fdinfo(const struct bpf_iter_aux_info *aux,
>> +                             struct seq_file *seq);
>> +int bpf_iter_map_fill_link_info(const struct bpf_iter_aux_info *aux,
>> +                               struct bpf_link_info *info);
>>
>>   int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>>   int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
>> diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
>> index af86048e5afd..714e74556aa2 100644
>> --- a/kernel/bpf/map_iter.c
>> +++ b/kernel/bpf/map_iter.c
>> @@ -149,6 +149,19 @@ static void bpf_iter_detach_map(struct bpf_iter_aux_info *aux)
>>          bpf_map_put_with_uref(aux->map);
>>   }
>>
>> +void bpf_iter_map_show_fdinfo(const struct bpf_iter_aux_info *aux,
>> +                             struct seq_file *seq)
>> +{
>> +       seq_printf(seq, "map_id:\t\t%u\n", aux->map->id);
> 
> nit: I think it's a bad idea to have two tabs here to align everything
> visually, might make parsing unnecessarily harder

You are 100% correct. This is on purpose to please visual alignment.
I debate with myself to add extra '\t'. But yes, it is bad for tool 
parsing. I will fix it in the next revision.

> 
>> +}
>> +
>> +int bpf_iter_map_fill_link_info(const struct bpf_iter_aux_info *aux,
>> +                               struct bpf_link_info *info)
>> +{
>> +       info->iter.map.map_id = aux->map->id;
>> +       return 0;
>> +}
>> +
>>   DEFINE_BPF_ITER_FUNC(bpf_map_elem, struct bpf_iter_meta *meta,
>>                       struct bpf_map *map, void *key, void *value)
>>
>> @@ -156,6 +169,8 @@ static const struct bpf_iter_reg bpf_map_elem_reg_info = {
>>          .target                 = "bpf_map_elem",
>>          .attach_target          = bpf_iter_attach_map,
>>          .detach_target          = bpf_iter_detach_map,
>> +       .show_fdinfo            = bpf_iter_map_show_fdinfo,
>> +       .fill_link_info         = bpf_iter_map_fill_link_info,
>>          .ctx_arg_info_size      = 2,
>>          .ctx_arg_info           = {
>>                  { offsetof(struct bpf_iter__bpf_map_elem, key),
>> diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
>> index b988f48153a4..281200dc0a01 100644
>> --- a/net/core/bpf_sk_storage.c
>> +++ b/net/core/bpf_sk_storage.c
>> @@ -1437,6 +1437,8 @@ static struct bpf_iter_reg bpf_sk_storage_map_reg_info = {
>>          .target                 = "bpf_sk_storage_map",
>>          .attach_target          = bpf_iter_attach_map,
>>          .detach_target          = bpf_iter_detach_map,
>> +       .show_fdinfo            = bpf_iter_map_show_fdinfo,
>> +       .fill_link_info         = bpf_iter_map_fill_link_info,
>>          .ctx_arg_info_size      = 2,
>>          .ctx_arg_info           = {
>>                  { offsetof(struct bpf_iter__bpf_sk_storage_map, sk),
>> --
>> 2.24.1
>>
