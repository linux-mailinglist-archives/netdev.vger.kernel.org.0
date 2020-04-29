Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0E71BD3E6
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 07:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgD2FJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 01:09:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23168 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726305AbgD2FJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 01:09:31 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T564V5026481;
        Tue, 28 Apr 2020 22:09:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=HvmLBat2QBeSxMNjSLYhl5qeTx6KzadN8lpABODAhhE=;
 b=JT3PzdHgVMMf3Q74mlj/aoKLllgjenf/nSmb6YtK8I++NYalQtZ4VOn1pgOEUgYPYVic
 ExOz+4qpkmqS30SmIsl5ou9sfZs8KQ8HQR28MwHncMLFJUnnedZx7xnlZrhP55+MQaRD
 WYL/VyHx84ehNm/h7e4ReZyrWk2OIaVB5YE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n5bxcrf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 22:09:19 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 22:09:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ni6jLyETo84T62/WAcaOUpdYB6kGfjPyVqjom0DNR1y63NE8JKtcjOjVqBQ8/RjpWnNyHXAe5aYSmWE7FI6Se223ngZBZyCfnYt/SKWxQdUGWJSaF1gLcS3dlyFHV8FGjeJJ3t9sLVOtk3MtWVKCjHMJK9nN8iPhu7MxmXfBaOGOO5Py24Py59qxwOPR5FxX90WpiOGG+g1bXRjk8dSvyixEAvR3tHE7JQohBKIrwAVyyVCDnQg1vM4XHHEUC14T2QoGmAUH9STOsDdHMK0Fm7jQ7EbvJgVBB9Ey8k9bRLxTOEi0ztfgZgCCdBgI2fQGaEzdlhca8HSX/3RmpN2vig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvmLBat2QBeSxMNjSLYhl5qeTx6KzadN8lpABODAhhE=;
 b=BChf0zBIgC07rcqVkJxBTcQk7v9LsBMXb6McXJBwX6eqdU+GD/RPkueaqb/WnMod91rUnMZUNDrQfhAAJQuL/NNv6/Q+IgmjwUIjC8zdb6FJCPpcfZJD8lit+ql5a5ISbLP8P/7AFrZSLcI2/ZpsgtSaZFK4Sp1qTK/BrP2l5MIPVtRZhjIjwPk+GTA8Ze8gc/7bTJz8TZkEY7f/CWgdW9Spc0IMMDf69uCU+Cy1VXAXtqbZFZVeqm5khu5CdF6B7Cl20rrxKb9d95RG5sb5Y+6pwMYkIwdcOHSKwoXVVONTHpIz2CnPLqWPuXsuMkT5AFhuo5VQV9f7yepBzhc7cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvmLBat2QBeSxMNjSLYhl5qeTx6KzadN8lpABODAhhE=;
 b=Vj2TWJbVJC6dsm8YvbtBia4UxeW+eEmdzEVzEKyGoCMh81FkHGUxJUrCoz4eHt5dR6IXJN49lebElz4n9g90NbnrsnCPZXLkFdSKAxIf61pQKY6qvvyNeUWH+k7uOpl9vG/mcHcoHwbqOPkr4dIQqWsdbvLzl45gcXKmDR14Ze0=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2853.namprd15.prod.outlook.com (2603:10b6:a03:fb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 05:09:17 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 05:09:17 +0000
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
To:     Alexei Starovoitov <ast@fb.com>, Martin KaFai Lau <kafai@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
        <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201237.2994794-1-yhs@fb.com>
 <20200429003738.pv4flhdaxpg66wiv@kafai-mbp>
 <3df31c9a-2df7-d76a-5e54-b2cd48692883@fb.com>
 <a5255338-94e8-3f4b-518e-e7f7146f69f2@fb.com>
 <65a83b48-3965-5ae9-fafd-3e8836b03d2c@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7f15274d-46dd-f43f-575e-26a40032f900@fb.com>
Date:   Tue, 28 Apr 2020 22:09:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <65a83b48-3965-5ae9-fafd-3e8836b03d2c@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR20CA0034.namprd20.prod.outlook.com
 (2603:10b6:300:ed::20) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:e9ab) by MWHPR20CA0034.namprd20.prod.outlook.com (2603:10b6:300:ed::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Wed, 29 Apr 2020 05:09:15 +0000
X-Originating-IP: [2620:10d:c090:400::5:e9ab]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8466c10c-472b-4d99-5985-08d7ebfb773f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2853:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2853B26D7939EA9F39C9F900D3AD0@BYAPR15MB2853.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(366004)(39860400002)(136003)(346002)(66476007)(66556008)(66946007)(6486002)(54906003)(36756003)(86362001)(8676002)(2616005)(186003)(110136005)(8936002)(316002)(16526019)(4326008)(478600001)(5660300002)(31696002)(6506007)(31686004)(2906002)(53546011)(6512007)(6636002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h9k0EeKAnS29riJIqnRcFv/UJtqEEScqTBit1j0pVgvB5Llt8SVMRMg1UFYsY8wSEnyVAkw+EIA+KROZ3ofxVYDBTUoQ9+1Xypd0p64iEHnICG2layxwL93dR7Msu3iO3nw008FnN/OvCfEFkovd9FfAbk9DeefplgHnf2WVrtfkjqea6/vy5K57ave9rb0e/suM6PN4oOy6EtiYwkFJPvVJDdL1XAKTyNg+CyUG8AIdvKz95JKck1QK0llj7E5IC0v9JwvNikJmAW7dvztX43B211kI8kLx15CTMf3HGTvtLJL1oyPCxmzfyw6DcIcV1sbFHSEVuwoXS+8IM6a/g+eO6YKwU5OJyYsP70oO+hwphnDxH8d6pcNBZvxlQ8gDOXELZuKiAbRCCnldZZa1MR7309eqBSchVLmnM1h3wPHySpip2FAKTA9STI1JO7OZ
X-MS-Exchange-AntiSpam-MessageData: KKZagiw3FOsRkabzNahQ8MSkc28I8Fg4bigT+n5GJpvZxC86w5N+GbYigQuM5CFLRwrlAqIi6k4TdNWiM+Vg+uIfbacEchrUnPnqSBP45F4s9TDwUbbqZj19zqAtOsM/PPqk6vqkTsVG7c9aN6GDGvJg66oWG+++qL9isqtVbYEAcjcYrBtOoPubIsKXauHo3WAvmzmJHDeTwWD9LH4lcSl7OjQl1jl1C36UJNtvzMAm+0R6x2tiwVRQtj7avYaxNks5R8Mu0ks4T8JcLgoG1fUI4qH6NHqjAhzAj4zDT4Txp5wW+5eTVNwvaaCPHiVkCnWpBrJBvFPeyRoHiWaqCivFRQ25lb76HbkTKMtx5o2Jeoz32T/KJjyYofSaorPL9LylgsqWDuhsmNmTXi0K7ZAWsgbgrdOwvAO+zJmdHW977ZE+quNzfdC4BP6c4TIw8u1X44LmdNOzht+3TB/oIQyUwW9F8T8YNlQcwMIkJ/CDwZ2MRQPCB5Jw7e0RSOiy4uGu2Lb4krAlk9sDyYEhe74xOK2MimH6bP+XRABz3gQN4XeuQeIGaNMqxdq5kSrnvGBIIRCCk6mL3gMeSu6gnq7qhD13NG60MbNfoGcCdJq7FpEl3GAKJ1M8LmGEHnOHTkfVwkDSxEUa5nlayDonTvOjRIWnrrxW9A4c1UbFj+SmvAH6vzs1SRYrQAdnKPM8JETIopZX+SGbX0pbUr1IZ24YouDTZ3hHtYtFIDv4dp2s4QEAjuffiWiQjgItc1iiIY4CQFt712ucS8q1lyW5gBq88pGeM9yWDzPQnONFD9FgP9lx/M2rQI3BblAC+3F/ShAAthhEJ/v0zvzwZy+H1w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8466c10c-472b-4d99-5985-08d7ebfb773f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 05:09:16.8672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hJnUzAG0rViOmuBvgROscTJabg+9ze8Bs4RJsjLReMNSJRs2wSAV5bANKQ5TQdla
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2853
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_01:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290039
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/20 7:44 PM, Alexei Starovoitov wrote:
> On 4/28/20 6:15 PM, Yonghong Song wrote:
>>
>>
>> On 4/28/20 5:48 PM, Alexei Starovoitov wrote:
>>> On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
>>>>> +    prog = bpf_iter_get_prog(seq, sizeof(struct 
>>>>> bpf_iter_seq_map_info),
>>>>> +                 &meta.session_id, &meta.seq_num,
>>>>> +                 v == (void *)0);
>>>>  From looking at seq_file.c, when will show() be called with "v == 
>>>> NULL"?
>>>>
>>>
>>> that v == NULL here and the whole verifier change just to allow NULL...
>>> may be use seq_num as an indicator of the last elem instead?
>>> Like seq_num with upper bit set to indicate that it's last?
>>
>> We could. But then verifier won't have an easy way to verify that.
>> For example, the above is expected:
>>
>>       int prog(struct bpf_map *map, u64 seq_num) {
>>          if (seq_num >> 63)
>>            return 0;
>>          ... map->id ...
>>          ... map->user_cnt ...
>>       }
>>
>> But if user writes
>>
>>       int prog(struct bpf_map *map, u64 seq_num) {
>>           ... map->id ...
>>           ... map->user_cnt ...
>>       }
>>
>> verifier won't be easy to conclude inproper map pointer tracing
>> here and in the above map->id, map->user_cnt will cause
>> exceptions and they will silently get value 0.
> 
> I mean always pass valid object pointer into the prog.
> In above case 'map' will always be valid.
> Consider prog that iterating all map elements.
> It's weird that the prog would always need to do
> if (map == 0)
>    goto out;
> even if it doesn't care about finding last.
> All progs would have to have such extra 'if'.
> If we always pass valid object than there is no need
> for such extra checks inside the prog.
> First and last element can be indicated via seq_num
> or via another flag or via helper call like is_this_last_elem()
> or something.

Okay, I see what you mean now. Basically this means
seq_ops->next() should try to get/maintain next two elements,
otherwise, we won't know whether the one in seq_ops->show()
is the last or not. We could do it in newly implemented
iterator bpf_map/task/task_file. Let me check how I could
make existing seq_ops (ipv6_route/netlink) works with
minimum changes.
