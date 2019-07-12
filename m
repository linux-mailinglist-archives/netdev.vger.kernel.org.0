Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8799566F8F
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfGLNGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:06:40 -0400
Received: from www62.your-server.de ([213.133.104.62]:50626 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfGLNGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 09:06:40 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlvG2-0005bx-96; Fri, 12 Jul 2019 15:06:38 +0200
Received: from [2a02:1205:5069:fce0:c5f9:cd68:79d4:446d] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlvG2-000Wat-0C; Fri, 12 Jul 2019 15:06:38 +0200
Subject: Re: [PATCH bpf-next] libbpf: fix ptr to u64 conversion warning on
 32-bit platforms
To:     Matt Hart <matthew.hart@linaro.org>, Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
References: <20190709040007.1665882-1-andriin@fb.com>
 <b4b00fad-3f99-c36a-a510-0b281a1f2bd7@fb.com>
 <CAH+k93ExQpYy+g+WUNvv+bDDzDcJR-2WYongJqv4WbMcPV=sRA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ea3c62c8-214d-1ad9-9235-7d52d7c36143@iogearbox.net>
Date:   Fri, 12 Jul 2019 15:06:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAH+k93ExQpYy+g+WUNvv+bDDzDcJR-2WYongJqv4WbMcPV=sRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25508/Fri Jul 12 10:10:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/12/2019 02:56 PM, Matt Hart wrote:
> On Tue, 9 Jul 2019 at 05:30, Yonghong Song <yhs@fb.com> wrote:
>> On 7/8/19 9:00 PM, Andrii Nakryiko wrote:
>>> On 32-bit platforms compiler complains about conversion:
>>>
>>> libbpf.c: In function ‘perf_event_open_probe’:
>>> libbpf.c:4112:17: error: cast from pointer to integer of different
>>> size [-Werror=pointer-to-int-cast]
>>>    attr.config1 = (uint64_t)(void *)name; /* kprobe_func or uprobe_path */
>>>                   ^
>>>
>>> Reported-by: Matt Hart <matthew.hart@linaro.org>
>>> Fixes: b26500274767 ("libbpf: add kprobe/uprobe attach API")
>>> Tested-by: Matt Hart <matthew.hart@linaro.org>
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>
>> Acked-by: Yonghong Song <yhs@fb.com>
> 
> How do we get this merged? I see the build failure has now propagated
> up to mainline :(

I just applied the fix to bpf tree, will go its usual route to mainline.
