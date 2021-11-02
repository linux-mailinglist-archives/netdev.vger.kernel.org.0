Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E506442626
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 04:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbhKBDtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 23:49:13 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:26221 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbhKBDtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 23:49:13 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HjwlS5pW2zSh1R;
        Tue,  2 Nov 2021 11:45:08 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 2 Nov 2021 11:46:36 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 2 Nov 2021 11:46:36 +0800
Subject: Re: [PATCH bpf-next v2 1/2] bpf: clean-up bpf_verifier_vlog() for
 BPF_LOG_KERNEL log level
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "Andrii Nakryiko" <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20211029135321.94065-1-houtao1@huawei.com>
 <20211029135321.94065-2-houtao1@huawei.com>
 <ebdd6730-1dfc-1889-eae9-00211bd82803@iogearbox.net>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <a88d1a54-59e5-e0ca-8a9e-d212dbfc3dc6@huawei.com>
Date:   Tue, 2 Nov 2021 11:46:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <ebdd6730-1dfc-1889-eae9-00211bd82803@iogearbox.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 11/2/2021 6:01 AM, Daniel Borkmann wrote:
> On 10/29/21 3:53 PM, Hou Tao wrote:
>> An extra newline will output for bpf_log() with BPF_LOG_KERNEL level
>> as shown below:
>>
>> [   52.095704] BPF:The function test_3 has 12 arguments. Too many.
>> [   52.095704]
>> [   52.096896] Error in parsing func ptr test_3 in struct bpf_dummy_ops
>>
>>       if (log->level == BPF_LOG_KERNEL) {
>> -        pr_err("BPF:%s\n", log->kbuf);
>> +        bool newline = n > 0 && log->kbuf[n - 1] == '\n';
>> +
>> +        pr_err("BPF:%s%s", log->kbuf, newline ? "" : "\n");
>
> nit: Given you change this anyway, is there a reason not to go with "BPF:
> %s%s" instead?
>
My bad, and will do it in v3.

