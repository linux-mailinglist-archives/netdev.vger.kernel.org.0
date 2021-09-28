Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16FD41AF04
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240682AbhI1MaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:30:17 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:22373 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240610AbhI1MaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 08:30:17 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HJdwg4gKCzRTR6;
        Tue, 28 Sep 2021 20:24:19 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 28 Sep 2021 20:28:36 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 28 Sep 2021 20:28:35 +0800
Subject: Re: [PATCH bpf-next v2 2/3] libbpf: support detecting and attaching
 of writable tracepoint program
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20210918020958.1167652-1-houtao1@huawei.com>
 <20210918020958.1167652-3-houtao1@huawei.com>
 <CAEf4BzaVaOiwkNgFQjwRfy9V_5NqiEyPMj-_AotO5TYeWiva3g@mail.gmail.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <140f8e1e-cdc7-efd5-1411-f1cd2ffe304d@huawei.com>
Date:   Tue, 28 Sep 2021 20:28:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzaVaOiwkNgFQjwRfy9V_5NqiEyPMj-_AotO5TYeWiva3g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 9/22/2021 5:42 AM, Andrii Nakryiko wrote:
> On Fri, Sep 17, 2021 at 6:56 PM Hou Tao <houtao1@huawei.com> wrote:
>> Program on writable tracepoint is BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
>> but its attachment is the same as BPF_PROG_TYPE_RAW_TRACEPOINT.
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> ---
>>  tools/lib/bpf/libbpf.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index da65a1666a5e..981fcdd95bdc 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -7976,6 +7976,10 @@ static const struct bpf_sec_def section_defs[] = {
>>                 .attach_fn = attach_raw_tp),
>>         SEC_DEF("raw_tp/", RAW_TRACEPOINT,
>>                 .attach_fn = attach_raw_tp),
>> +       SEC_DEF("raw_tracepoint_writable/", RAW_TRACEPOINT_WRITABLE,
>> +               .attach_fn = attach_raw_tp),
>> +       SEC_DEF("raw_tp_writable/", RAW_TRACEPOINT_WRITABLE,
>> +               .attach_fn = attach_raw_tp),
> _writable is a bit mouthful, maybe we should do the same we did for
> "sleepable", just add ".w" suffix? So it will be "raw_tp.w/..."? Or
> does anyone feel it's too subtle?
raw_tp.w is fine to me. Will update it in v3.
>
>>         SEC_DEF("tp_btf/", TRACING,
>>                 .expected_attach_type = BPF_TRACE_RAW_TP,
>>                 .is_attach_btf = true,
>> --
>> 2.29.2
>>
> .

