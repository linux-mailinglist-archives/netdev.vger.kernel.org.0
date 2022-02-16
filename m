Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9FF4B8498
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 10:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbiBPJis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 04:38:48 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiBPJir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 04:38:47 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1643E4487
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 01:38:35 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id r8so1554150ioc.8
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 01:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TE0/N8NKeog4OR15kthhPLLES8UDNjbzbBXNMjFbSeA=;
        b=k46ucVdPbgxxOSKlRhGU0xaLrcWt4WvHEENMC4xtG30AcZdCSLk57g8b2P9QRNgY+1
         9qZ/Dm8vza5Pxi+PauLqY+bKOoiY8DXBUAtvlxQEcUal/fNceCyUMhXUbWf9jJeno0jX
         54L/JdiaF03gbvq+u1prS2TbSAf2HU3aWaDbE/tATuu5+xawh/d20Sy1XxCZC/HrPtUR
         w7cuG7/th105tvyGMfUkFPGTZH7SIAX9mJXRqBA19ilqY/18gPO/+TnWvjJvYwiyin5q
         jKnOxd4za/Qlu8N+ZIyAictJKRO/gV56ajIq9T5sWXgF4iuOjXwnZfmCC9wMir1wAgwd
         vebQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TE0/N8NKeog4OR15kthhPLLES8UDNjbzbBXNMjFbSeA=;
        b=HzDOb+PyzGTOXIYet/Z5z4lsYXrLj7wUdYi7WASPxL7ObPxRSMzLkalk2UUECCK7GR
         5BieKHg7XGK3FCmdazlwQduoC4SV57nYe9zyIvrNzqIiLV9W92xq/f95OOyxWJ36WgPj
         ygZ0ODkXyAEfJlVdadIUM8rgtTekzop2t+C0Vl+mzXLsftMgcNrz0fjoukmbcV/2a9A7
         45iTNiD/dtKROHGb8rf7UWtu8sLdM3jSMPB5T8kp9aV4KQGxJNIscyBSHzCIEdGHmveU
         UEUSWfpSXgxUuhzU6uP0TD8djprZ3yMh5sbqrW38l54xlg57fx86j17O87wwFLnUd8zV
         f0oQ==
X-Gm-Message-State: AOAM531UYgqQAFdFFf58ar7qDtGiRs8nTqaDMc9uch+zoCcMT6xVOELm
        Sc9C6u25S0IJeFkkrpfd3lkLVCLv1/Evwu02+5GPEg==
X-Google-Smtp-Source: ABdhPJyNQD9IxCkaSjGSRk/4TtK2L2i/JJLmlTM7W0jsLtAupztU/Ey6mxXkWpEsSw79Y2XlQV2gFXn3smw3IS6hlA0=
X-Received: by 2002:a05:6638:379b:b0:310:bb27:6c28 with SMTP id
 w27-20020a056638379b00b00310bb276c28mr1180097jal.71.1645004315038; Wed, 16
 Feb 2022 01:38:35 -0800 (PST)
MIME-Version: 1.0
References: <00000000000073b3e805d7fed17e@google.com> <462fa505-25a8-fd3f-cc36-5860c6539664@iogearbox.net>
 <CAPhsuW6rPx3JqpPdQVdZN-YtZp1SbuW1j+SVNs48UVEYv68s1A@mail.gmail.com> <CAPhsuW5JhG07TYKKHRbNVtepOLjZ2ekibePyyqCwuzhH0YoP7Q@mail.gmail.com>
In-Reply-To: <CAPhsuW5JhG07TYKKHRbNVtepOLjZ2ekibePyyqCwuzhH0YoP7Q@mail.gmail.com>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Wed, 16 Feb 2022 10:38:24 +0100
Message-ID: <CANp29Y64wUeARFUn8Z0fjk7duxaZ3bJM2uGuVug_0ZmhGG_UTA@mail.gmail.com>
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Read in bpf_jit_free
To:     Song Liu <song@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+2f649ec6d2eea1495a8f@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Song,

Is syzkaller not doing something you expect it to do with this config?

On Wed, Feb 16, 2022 at 2:38 AM Song Liu <song@kernel.org> wrote:
>
> On Mon, Feb 14, 2022 at 10:41 PM Song Liu <song@kernel.org> wrote:
> >
> > On Mon, Feb 14, 2022 at 3:52 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > > Song, ptal.
> > >
> > > On 2/14/22 7:45 PM, syzbot wrote:
> > > > Hello,
> > > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    e5313968c41b Merge branch 'Split bpf_sk_lookup remote_port..
> > > > git tree:       bpf-next
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=10baced8700000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=2f649ec6d2eea1495a8f
>
> How do I run the exact same syzkaller? I am doing something like
>
> ./bin/syz-manager -config qemu.cfg
>
> with the cfg file like:
>
> {
>         "target": "linux/amd64",
>         "http": ":56741",
>         "workdir": "workdir",
>         "kernel_obj": "linux",
>         "image": "./pkg/mgrconfig/testdata/stretch.img",

This image location looks suspicious - we store some dummy data for
tests in that folder.
Instances now run on buildroot-based images, generated with
https://github.com/google/syzkaller/blob/master/tools/create-buildroot-image.sh

>         "syzkaller": ".",
>         "disable_syscalls": ["keyctl", "add_key", "request_key"],

For our bpf instances, instead of disable_syscalls we use enable_syscalls:

"enable_syscalls": [
"bpf", "mkdir", "mount$bpf", "unlink", "close",
"perf_event_open*", "ioctl$PERF*", "getpid", "gettid",
"socketpair", "sendmsg", "recvmsg", "setsockopt$sock_attach_bpf",
"socket$kcm", "ioctl$sock_kcm*", "syz_clone",
"mkdirat$cgroup*", "openat$cgroup*", "write$cgroup*",
"openat$tun", "write$tun", "ioctl$TUN*", "ioctl$SIOCSIFHWADDR",
"openat$ppp", "syz_open_procfs$namespace"
]

>         "suppressions": ["some known bug"],
>         "procs": 8,

We usually run with "procs": 6, but it's not that important.

>         "type": "qemu",
>         "vm": {
>                 "count": 16,
>                 "cpu": 2,
>                 "mem": 2048,
>                 "kernel": "linux/arch/x86/boot/bzImage"
>         }
> }

Otherwise I don't see any really significant differences.

--
Best Regards
Aleksandr

>
> Is this correct? I am using stretch.img from syzkaller site, and the
> .config from
> the link above.
>
> Thanks,
> Song
>
