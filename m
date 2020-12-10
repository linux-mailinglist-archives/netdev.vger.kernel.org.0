Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBEE2D621C
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 17:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389899AbgLJQiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 11:38:23 -0500
Received: from www62.your-server.de ([213.133.104.62]:53330 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730905AbgLJQhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 11:37:38 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1knOw1-00006j-09; Thu, 10 Dec 2020 17:36:53 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1knOw0-000Gmm-LC; Thu, 10 Dec 2020 17:36:52 +0100
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix selftest compilation on clang
 11
To:     KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Jackman <jackmanb@google.com>,
        KP Singh <kpsingh@google.com>
References: <20201209142912.99145-1-jolsa@kernel.org>
 <CAEf4BzYBddPaEzRUs=jaWSo5kbf=LZdb7geAUVj85GxLQztuAQ@mail.gmail.com>
 <20201210161554.GF69683@krava>
 <CANA3-0dvt3FH8=ZYO7CfW0YKeQemNcsP76j441wW31-WE1_o4A@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d0dbe550-5d75-29bd-cded-7ecd86f41719@iogearbox.net>
Date:   Thu, 10 Dec 2020 17:36:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CANA3-0dvt3FH8=ZYO7CfW0YKeQemNcsP76j441wW31-WE1_o4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26014/Thu Dec 10 15:21:42 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/20 5:28 PM, KP Singh wrote:
> On Thu, Dec 10, 2020 at 5:18 PM Jiri Olsa <jolsa@redhat.com> wrote:
[...]
>>> It's hard and time-consuming enough to develop these features, I'd
>>> rather keep selftests simpler, more manageable, and less brittle by
>>> not having excessive amount of feature detection and skipped
>>> selftests. I think that's the case for BPF atomics as well, btw (cc'ed
>>> Yonghong and Brendan).
>>>
>>> To alleviate some of the pain of setting up the environment, one way
>>> would be to provide script and/or image to help bring up qemu VM for
>>> easier testing. To that end, KP Singh (cc'ed) was able to re-use
>>> libbpf CI's VM setup and make it easier for local development. I hope
>>> he can share this soon.
> 
> I will clean it up and share it asap and send it as an RFC which
> adds it to tools/testing/selftests/bpf

Thanks!

> We can discuss on the RFC as to where the script would finally end up
> but I think it would save a lot of time/back-and-forth if developers could
> simply check:
> 
>    "Does my change break the BPF CI?"

I'd love to have a Dockerfile under tools/testing/selftests/bpf/ that
replicates the CI env (e.g. busybox, nightly llvm, pahole git, etc) where
we could have quay.io job auto-build this for bpf / bpf-next tree e.g. from a
GH mirror. This would then allow to mount the local kernel tree as a volume
into the container for easy compilation & test access for everyone where we
then don't need all these workarounds like in this patch anymore.

Thanks,
Daniel
