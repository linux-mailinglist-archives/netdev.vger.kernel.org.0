Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B4D4480FD
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238794AbhKHOLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 09:11:51 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:14728 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbhKHOLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 09:11:50 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HntG072SHzZcxd;
        Mon,  8 Nov 2021 22:06:48 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 8 Nov 2021 22:09:00 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 8 Nov 2021 22:09:00 +0800
Subject: Re: [RFC PATCH bpf-next 1/2] bpf: add bpf_strncmp helper
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20211106132822.1396621-1-houtao1@huawei.com>
 <20211106132822.1396621-2-houtao1@huawei.com>
 <20211106192602.knmfk2x7ogcjuzvw@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZ-g2U-=kLihD3xNkWsZrkg+B29Es=WZqCH1+r5V95sVg@mail.gmail.com>
 <CAADnVQJv1NXV2ZHRQZu8YqOdQzdtD+Ydezoh-usvYvVdqyc0Gw@mail.gmail.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <94849d3f-81f0-703d-f5ce-87581cbbbc75@huawei.com>
Date:   Mon, 8 Nov 2021 22:08:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQJv1NXV2ZHRQZu8YqOdQzdtD+Ydezoh-usvYvVdqyc0Gw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 11/7/2021 4:32 AM, Alexei Starovoitov wrote:
> On Sat, Nov 6, 2021 at 1:07 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
snip
>>> I was thinking whether the proto could be:
>>> long bpf_strncmp(const char *s1, u32 s1_sz, const char *s2)
>>> but I think your version is better though having const string as 1st arg
>>> is a bit odd in normal C.
>> Why do you think it's better? This is equivalent to `123 == x` if it
>> was integer comparison, so it feels like bpf_strncmp(s, sz, "blah") is
>> indeed more natural. No big deal, just curious what's better about it.
> Only that helper implementation has two less register moves.
> which makes it 51%/49% win for me.
> .
I agree with Andrii that bpf_strncmp(s, sz, "blah") is more nature. I can run
some simple benchmarks to show whether or not the difference matters.

Regards,
Tao.
