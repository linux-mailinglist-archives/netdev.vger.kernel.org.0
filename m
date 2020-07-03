Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C94213452
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 08:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgGCGjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 02:39:05 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:60148 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgGCGjE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 02:39:04 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id CEA5DBC146;
        Fri,  3 Jul 2020 06:38:53 +0000 (UTC)
Subject: Re: [PATCH] Replace HTTP links with HTTPS ones: BPF (Safe dynamic
 programs and tools)
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Andrey Ignatov <rdna@fb.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
References: <20200702200516.13324-1-grandmaster@al2klimov.de>
 <CAADnVQKaL7cX2oCFLU7MW+CMf4ySbJf3tC3YqajDxgbuPCY-Cg@mail.gmail.com>
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
Message-ID: <b06e1efb-b2e6-b06b-bf24-1369c42e8ace@al2klimov.de>
Date:   Fri, 3 Jul 2020 08:38:52 +0200
MIME-Version: 1.0
In-Reply-To: <CAADnVQKaL7cX2oCFLU7MW+CMf4ySbJf3tC3YqajDxgbuPCY-Cg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +
X-Spam-Level: *
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 03.07.20 um 00:08 schrieb Alexei Starovoitov:
> On Thu, Jul 2, 2020 at 1:05 PM Alexander A. Klimov
> <grandmaster@al2klimov.de> wrote:
>>
>> Rationale:
>> Reduces attack surface on kernel devs opening the links for MITM
>> as HTTPS traffic is much harder to manipulate.
>>
>> Deterministic algorithm:
>> For each file:
>>    If not .svg:
>>      For each line:
>>        If doesn't contain `\bxmlns\b`:
>>          For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
>>            If both the HTTP and HTTPS versions
>>            return 200 OK and serve the same content:
>>              Replace HTTP with HTTPS.
>>
>> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
>> ---
>>   Continuing my work started at 93431e0607e5.
>>
>>   If there are any URLs to be removed completely or at least not HTTPSified:
>>   Just clearly say so and I'll *undo my change*.
>>   See also https://lkml.org/lkml/2020/6/27/64
>>
>>   If there are any valid, but yet not changed URLs:
>>   See https://lkml.org/lkml/2020/6/26/837
>>
>>   Documentation/bpf/bpf_devel_QA.rst          | 4 ++--
>>   Documentation/bpf/index.rst                 | 2 +-
>>   Documentation/networking/af_xdp.rst         | 2 +-
>>   Documentation/networking/filter.rst         | 2 +-
>>   arch/x86/net/bpf_jit_comp.c                 | 2 +-
>>   include/linux/bpf.h                         | 2 +-
>>   include/linux/bpf_verifier.h                | 2 +-
>>   include/uapi/linux/bpf.h                    | 2 +-
>>   kernel/bpf/arraymap.c                       | 2 +-
>>   kernel/bpf/core.c                           | 2 +-
>>   kernel/bpf/disasm.c                         | 2 +-
>>   kernel/bpf/disasm.h                         | 2 +-
>>   kernel/bpf/hashtab.c                        | 2 +-
>>   kernel/bpf/helpers.c                        | 2 +-
>>   kernel/bpf/syscall.c                        | 2 +-
>>   kernel/bpf/verifier.c                       | 2 +-
>>   kernel/trace/bpf_trace.c                    | 2 +-
>>   lib/test_bpf.c                              | 2 +-
>>   net/core/filter.c                           | 2 +-
>>   samples/bpf/lathist_kern.c                  | 2 +-
>>   samples/bpf/lathist_user.c                  | 2 +-
>>   samples/bpf/sockex3_kern.c                  | 2 +-
>>   samples/bpf/tracex1_kern.c                  | 2 +-
>>   samples/bpf/tracex2_kern.c                  | 2 +-
>>   samples/bpf/tracex3_kern.c                  | 2 +-
>>   samples/bpf/tracex3_user.c                  | 2 +-
>>   samples/bpf/tracex4_kern.c                  | 2 +-
>>   samples/bpf/tracex4_user.c                  | 2 +-
>>   samples/bpf/tracex5_kern.c                  | 2 +-
>>   tools/include/uapi/linux/bpf.h              | 2 +-
>>   tools/lib/bpf/bpf.c                         | 2 +-
>>   tools/lib/bpf/bpf.h                         | 2 +-
>>   tools/testing/selftests/bpf/test_maps.c     | 2 +-
>>   tools/testing/selftests/bpf/test_verifier.c | 2 +-
>>   34 files changed, 35 insertions(+), 35 deletions(-)
> 
> Nacked-by: Alexei Starovoitov <ast@kernel.org>
> 
> Pls don't touch anything bpf related with such changes.
https://lore.kernel.org/linux-doc/20200526060544.25127-1-grandmaster@al2klimov.de/
– merged.

https://lore.kernel.org/linux-doc/20200608181649.74883-1-grandmaster@al2klimov.de/
– applied.

https://lore.kernel.org/linux-doc/20200620075402.22347-1-grandmaster@al2klimov.de/
– applied.

https://lore.kernel.org/linux-doc/20200621133512.46311-1-grandmaster@al2klimov.de/
– applied.

https://lore.kernel.org/linux-doc/20200621133552.46371-1-grandmaster@al2klimov.de/
– applied.

https://lore.kernel.org/linux-doc/20200621133630.46435-1-grandmaster@al2klimov.de/
– applied.

https://lore.kernel.org/linux-doc/20200627103050.71712-1-grandmaster@al2klimov.de/
– applied.

https://lore.kernel.org/linux-doc/20200627103125.71828-1-grandmaster@al2klimov.de/
– reviewed.

https://lore.kernel.org/linux-doc/20200627103151.71942-1-grandmaster@al2klimov.de/
– reviewed.

This one – no, pls not.

Why exactly not? Are these URLs not being opened at all (What they're 
doing there then?) or have all who open them the HTTPS everywhere 
browser addon installed?

> 
