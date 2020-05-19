Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFAEF1D8CCD
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 03:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgESBAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 21:00:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27586 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726573AbgESBAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 21:00:33 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04J0rbwQ002148;
        Mon, 18 May 2020 18:00:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : subject : to : cc
 : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=PE5yJF7+VMNN2lkn9QA3zJHhm9Au9myyKImmSp7E/Os=;
 b=NfWCcQ/V+8EbvitV5gqKYYPOCeL16D7YZpIMeTX5w4AkVCXKnbPIJE85oApr4FSAwwK3
 AhlBxU5ArWRVWVZd37pHrL31Qh6zJX8rPKARv4zv9Vl8zVmkqMITpqNrA7nAoKR9Kqe8
 5mW4nr7o47/ghZ+JmuBGY6z+O+a13Wpm2sA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31305rtw13-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 18 May 2020 18:00:16 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 18 May 2020 18:00:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+EB0f+D01VeMHNnHxAybF589GwNTgiFx9QrTLJOCHrp9O+vX6S4MCh/oYndRMEz6Dk+kn9NMN5l3i2p03TCrkAgwWsm+MPJOLCExxVL+frS2CO1obhsJVPxHiyhPtUm8IxAfdhfXqod3wEULfx5liAxHQBXATk0jiq48qhO8G4wLm4lPs0cxCVezOLDPLsL/L8LLyky7EA9V+cFczd9Lq/djuTTbmBwMNHbGbYvLqefVtlLlZi4wQ65mvGCDKghXV1rHOvqruLFgGR3YAiWgx61wRI5EzbuIIUXJJBB6buQfZBqu7XotmcOK+V7A5SAZdtjXhtnN35kP9MAPvUeGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PE5yJF7+VMNN2lkn9QA3zJHhm9Au9myyKImmSp7E/Os=;
 b=PKSkhvB7LpZDJnoD19scH3mt8mIRWpGnMWhXTLy5PtsKVCnTwQjBqODSbMVH/9kaXlNUJRljavq0niXLiDnGWQXIL0KfzvVZ5T428Ja3iM/CCduKFF7kg3hTgP+gqp9CtmTcY45L3aT5VZXaFeh/gFJk5FvzUOnDwjwr6PTqFtvuMOkUpWoVIOSWb5B2Jlc+Wv2vUkiGP4NTtfFP9z8RsY5D4IbiNDmuM7UTwEW3TUeGAhoikrQbCYvfN5Mrlc97yqsyOft/0XEUFjNta2VS4+qaWgrkIjEQ2wcGR0j9EtyqOCSpLKj6KIsbNzy4iSXMVUuKVbtBLMrj8Sd/E9xUVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PE5yJF7+VMNN2lkn9QA3zJHhm9Au9myyKImmSp7E/Os=;
 b=Do+A8ce8ODTIhKo3hkd52bSEs9V6FWTi/DQIW6tIezWN13wqUrkBB+PV0gguokP+onyYnAZgB4SZBdLDqNAHgvA++lKArOqSUvB8NgA+oAS1CrTfLtdMV5YE7QTAqbYWpB7QclA+o382UHPiyVKu6a9ca/FlfZxEydV8jk9F68s=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2550.namprd15.prod.outlook.com (2603:10b6:a03:151::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Tue, 19 May
 2020 01:00:11 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3000.034; Tue, 19 May 2020
 01:00:11 +0000
From:   Yonghong Song <yhs@fb.com>
Subject: Re: UBSAN: array-index-out-of-bounds in kernel/bpf/arraymap.c:177
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>, Qian Cai <cai@lca.pw>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>
References: <CAG=TAF6mfrwxF1-xEJJ9dL675uMUa7RZrOa_eL2mJizZJ-U7iQ@mail.gmail.com>
 <CAEf4BzazvGOoJbm+zNMqTjhTPJAnVLVv9V=rXkdXZELJ4FPtiA@mail.gmail.com>
 <CAG=TAF6aqo-sT2YE30riqp7f47KyXH_uhNJ=M9L12QU6EEEfqQ@mail.gmail.com>
 <CAEf4BzaBfnDL=WpRP-7rYFhocOsCQyFuZaLvM0+k9sv2t_=rVw@mail.gmail.com>
Message-ID: <45f9ef5d-18e3-c92f-e7a9-1c6d6405e478@fb.com>
Date:   Mon, 18 May 2020 18:00:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <CAEf4BzaBfnDL=WpRP-7rYFhocOsCQyFuZaLvM0+k9sv2t_=rVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0027.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::37) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from stephyma-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f205) by BY5PR04CA0027.namprd04.prod.outlook.com (2603:10b6:a03:1d0::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Tue, 19 May 2020 01:00:10 +0000
X-Originating-IP: [2620:10d:c090:400::5:f205]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b9e7b90-6731-4acc-146b-08d7fb8ffb2f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2550E01FA0A2B4514F835580D3B90@BYAPR15MB2550.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 040866B734
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NBRuypD9zcY0exa9EGlTLHZpkShmpAtkFHcB4u/icmsyoqTy6A38yyf/G9BXbyfmVuTUIbGIZf1NY4uanu8SJ875VWmepI1ZZGsXsRp+6GsF2slzutl+pKcgRdp0nPxB5S8emJbaypvMYDAhuTUUcIewX779kOIWgD9yncO8QNykdw6gAHMmnTTZen6CsmYLZWDpPhzcpzu7LJl5w1inHUGv16owPL1an3Yk8+oDgDPy9K7QKzX4iLktcftIDPk/Qs9FZbVeMD0djVsaulYU2jajwQqp7jw854s3wwBKCNAh5P79nBcM7UDqA6bowVSoE9gSStq+CiMw4377c0gpFq52g9NHUomtViBtsFCM3ZYWeU0abDsS6jRXPOVyUUq/6NKuNHCixPsBLSt/XG2cBIJaI1Ag55hc5BBDqJv9dOkwJ8xsSp1DhiL5LtWyPERFKd0R9FmalovbYGtAdPfhw+kk9itgUjDVCVYtNYOcokU7yzrrCjHYUm4ZjAYHFQy6/RdL5QUDuTFlg1+5kAFhpISfrx/FrazjW2glKf1xGDx2oIh5QNvbfUPHIahS2JSiNy9RkNKyB6OghZMFZbqwn9G1oRbuIbhWxh/IiQAcqZBUBQnm3N+gQUVp1d40y6EmG4D3Knslpkqi76TmYoyRizgtyQs9rXOUvQbo2ppnOVoH5dwNu0gUClXfojOET2VS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10001)(346002)(136003)(39860400002)(376002)(366004)(396003)(8936002)(8676002)(36756003)(2906002)(53546011)(31686004)(6512007)(6506007)(52116002)(6666004)(316002)(86362001)(16526019)(31696002)(54906003)(110136005)(4326008)(186003)(66556008)(66946007)(6486002)(5660300002)(2616005)(478600001)(7416002)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: I2eWxsK6ijGKntgdNnC59BcR3YygcENTRtuQaKkTsjfo2+9NPBm5vmt98ajwXzmFn8nTLKikh7dy2WcbZwG65LF8RmejQk6gge+YUNByEesYOgHjtq+aoEJSioMgoAH2Z3xf6FQKu3GN6tKbuYfGnFrK+NE26AoV6pUITusgiZFGVDg2FdXNm8PeOzPsXSJWoAfldNZo+BT67V4mdiDbCtL9McIVL1Hr51nWGDh6QejFRanTetH9+lT8091HGUldZjyuxlkoY13tPp3/zujCDSOi4w/wiQyivyup7UIdjYWA2cWMPYTz7z5wmfjJW6LvqOjCOd8rhNAD969RdiW5Tj71UJV/wTqhD1/jZCUvOThE7LyIes18MOC8L3qRGEAOHRtI1r4cs8VaYcslu9+7TEjJrRxVaWV/6rCoPYOYvLD0TVJwQXq7+mFKLj4zwuyGMBGvESvVd3c6NSAXWpD2wa3qhely1+5byA6GeDczr4bCzpwucNs0/bMlZHHZ+cnaxXF9nlRSfOOtQc94/o0Y+g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b9e7b90-6731-4acc-146b-08d7fb8ffb2f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2020 01:00:11.3014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SDHabtcaoouTk0cFSHhZfHwG2/cutGnzw0xNPKSa1CZ1pQ6FSQNd7piWZQ2SAxgq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2550
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=27
 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 clxscore=1011
 cotscore=-2147483648 mlxscore=0 lowpriorityscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/20 5:25 PM, Andrii Nakryiko wrote:
> On Mon, May 18, 2020 at 5:09 PM Qian Cai <cai@lca.pw> wrote:
>>
>> On Mon, May 18, 2020 at 7:55 PM Andrii Nakryiko
>> <andrii.nakryiko@gmail.com> wrote:
>>>
>>> On Sun, May 17, 2020 at 7:45 PM Qian Cai <cai@lca.pw> wrote:
>>>>
>>>> With Clang 9.0.1,
>>>>
>>>> return array->value + array->elem_size * (index & array->index_mask);
>>>>
>>>> but array->value is,
>>>>
>>>> char value[0] __aligned(8);
>>>
>>> This, and ptrs and pptrs, should be flexible arrays. But they are in a
>>> union, and unions don't support flexible arrays. Putting each of them
>>> into anonymous struct field also doesn't work:
>>>
>>> /data/users/andriin/linux/include/linux/bpf.h:820:18: error: flexible
>>> array member in a struct with no named members
>>>     struct { void *ptrs[] __aligned(8); };
>>>
>>> So it probably has to stay this way. Is there a way to silence UBSAN
>>> for this particular case?
>>
>> I am not aware of any way to disable a particular function in UBSAN
>> except for the whole file in kernel/bpf/Makefile,
>>
>> UBSAN_SANITIZE_arraymap.o := n
>>
>> If there is no better way to do it, I'll send a patch for it.
> 
> 
> That's probably going to be too drastic, we still would want to
> validate the rest of arraymap.c code, probably. Not sure, maybe
> someone else has better ideas.

Maybe something like below?

   struct bpf_array {
         struct bpf_map map;
         u32 elem_size;
         u32 index_mask;
         struct bpf_array_aux *aux;
         union {
                 char value;
                 void *ptrs;
                 void __percpu *pptrs;
         } u[] __aligned(8);
   };
