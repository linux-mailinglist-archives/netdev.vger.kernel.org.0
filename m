Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A04EA1F7
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 17:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfJ3QoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 12:44:25 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35101 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfJ3QoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 12:44:25 -0400
Received: by mail-lj1-f193.google.com with SMTP id m7so3465244lji.2;
        Wed, 30 Oct 2019 09:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K0D4yeQMJikScQHXpqJp1kFntebsgKejFlvwAhgD9Lk=;
        b=KcQhoIHKUCKGCKV6wdZKmBmngUdCe9GtyHfARmXB59NuL0EmJ4cRxSPTBkGfzmrNA5
         NiONgf3HwZJKQh1YP6QKOWEOGLZFhz6jQodwbEmnM/u1U32GhutQhQEG/8d28rcMzF/s
         TCGK/2jBkEtyeC6pqZ0KsVImLW5XHztsqf2uxmrqv6l2XrZv+Q/RNwJSnSdvhf63kEuT
         xPP4dhEbHwbPReRTT5MdPLc326wJH/inV2RmzhiBauOnPboTO2qcVwhf8CLpQphZq9Bg
         65Cvw66bZzy9kWrONtUCTK30K2upFRTgAE8H6RH+1B27E7pskQ5PH+FToZyn9s3M3prt
         957A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K0D4yeQMJikScQHXpqJp1kFntebsgKejFlvwAhgD9Lk=;
        b=hkOAVWV3DGkl5aN3WsyjA+MrJdqvml1Ymhqthxg3OQnDDF8bNw6VrCwLr27MKU14d7
         6sLtbC9ruVpzYyTio7LZmqZR9+K9gy4/kx3mEltXN00NDzDBbVMOiDobNVUrzxPUc2xm
         5JkkGHlSjYZ6e8ZBxMAUCc/lBrDeDgKYTAVc4yq/1lrMuvHhom8Wxh1Ri68W9wxaeVR6
         0hKtzuvykvA6uCGALlCmDABY/ndJim68axoNuCSg13W6UUorGKyEbbhjvTAL8qeBcwbs
         eUywH3AVL66Yt++XDGW2YgoxV2+QgwWeYTEpV1BYdpk6jl2m28vd8RjyMF9EhcHFTxyY
         QUGQ==
X-Gm-Message-State: APjAAAU1z1vnur+w8eEYH694APDwReULiPamSM1UyfCN0M+kMpuP3y2i
        g+PaBpEse0s5svdpKSKYQaoVR+5fQPt99ooZxQo=
X-Google-Smtp-Source: APXvYqxop8bbuy5p7HId7hh2NI5zpbgTOFrY9XmemW+tdbr2uaOs7YrJK2wSi/JNHoJ7pfp2mH8RIO1vtcjL0GvlqYE=
X-Received: by 2002:a2e:3304:: with SMTP id d4mr519739ljc.142.1572453863058;
 Wed, 30 Oct 2019 09:44:23 -0700 (PDT)
MIME-Version: 1.0
References: <20191030154323.GJ20826@krava>
In-Reply-To: <20191030154323.GJ20826@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 30 Oct 2019 09:44:11 -0700
Message-ID: <CAADnVQKNJ9H9yxxuHn72ikfjii4vciVi8S6ztJ4oJCGk5A3FrA@mail.gmail.com>
Subject: Re: [BUG] bpf:
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        X86 ML <x86@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 8:43 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
>
> hi,
> I'm getting oops when running the kfree_skb test:
>
> dell-r440-01 login: [  758.049877] BUG: kernel NULL pointer dereference, address: 0000000000000000^M
> [  758.056834] #PF: supervisor read access in kernel mode^M
> [  758.061975] #PF: error_code(0x0000) - not-present page^M
> [  758.067112] PGD 8000000befba8067 P4D 8000000befba8067 PUD bffe11067 PMD 0 ^M
> [  758.073987] Oops: 0000 [#1] SMP PTI^M
> [  758.077478] CPU: 16 PID: 6854 Comm: test_progs Not tainted 5.4.0-rc3+ #96^M
> [  758.084263] Hardware name: Dell Inc. PowerEdge R440/08CYF7, BIOS 1.7.0 12/14/2018^M
> [  758.091745] RIP: 0010:0xffffffffc03b672c^M
> [  758.095669] Code: 4c 8b 6a 00 4c 89 6d c0 8b 77 00 89 75 cc 31 ff 89 75 fc 48 8b 71 00 48 01 fe bf 78 00 00 00 48 89 da 48 01 fa bf 08 00 00 00 <4c> 8b 76 00 4c 89 f6 48 01 fe 4c 8b 7e 00 48 89 ef 48 83 c7 f9 be^M
> [  758.114414] RSP: 0018:ffffaa3287583d20 EFLAGS: 00010286^M
> [  758.119640] RAX: ffffffffc03b66ac RBX: ffff9cef028c3900 RCX: ffff9cef0a652018^M
> [  758.126775] RDX: ffff9cef028c3978 RSI: 0000000000000000 RDI: 0000000000000008^M
> [  758.133906] RBP: ffffaa3287583d90 R08: 00000000000000b0 R09: 0000000000000000^M
> [  758.141040] R10: 98ff036c00000000 R11: 0000000000000040 R12: ffffffffba8b5c37^M
> [  758.148170] R13: ffff9cfb05daf440 R14: 0000000000000000 R15: 000000000000004a^M
> [  758.155303] FS:  00007f08a18d3740(0000) GS:ffff9cef10c00000(0000) knlGS:0000000000000000^M
> [  758.163392] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033^M
> [  758.169136] CR2: 0000000000000000 CR3: 0000000c08e50001 CR4: 00000000007606e0^M
> [  758.176268] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000^M
> [  758.183401] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400^M
> [  758.190534] PKRU: 55555554^M
> [  758.193248] Call Trace:^M
> [  758.195704]  ? bpf_test_run+0x13d/0x230^M
> [  758.199539]  ? _cond_resched+0x15/0x30^M
> [  758.203304]  bpf_trace_run2+0x37/0x90^M
> [  758.206967]  ? bpf_prog_test_run_skb+0x337/0x450^M
> [  758.211589]  kfree_skb+0x73/0xa0^M
> [  758.214820]  bpf_prog_test_run_skb+0x337/0x450^M
> [  758.219293]  __do_sys_bpf+0x82e/0x1730^M
> [  758.223043]  ? ep_show_fdinfo+0x80/0x80^M
> [  758.226885]  do_syscall_64+0x5b/0x180^M
> [  758.230550]  entry_SYSCALL_64_after_hwframe+0x44/0xa9^M
> [  758.235620] RIP: 0033:0x7f08a19e91fd^M
> [  758.239198] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 5b 8c 0c 00 f7 d8 64 89 01 48^M
>
>
> this seems to be the culprit:
>
> ; ptr = dev->ifalias->rcuhead.next;
>   80:   mov    0x0(%rsi),%r14

with rsi being zero. yes. that's the point of the test.

> I used the patch below to bypass the crash, but I guess
> verifier should not let this through

Could you please send me your .config and the way you
run test_progs ?
Is it with or without jit?

I thought I've tested all combinations. Something slipped through.

> also the net_device struct in the test seems outdated

It's not outdated. It's specifically done this way on purpose.
