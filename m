Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC464BA854
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244433AbiBQSed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:34:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244497AbiBQSe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:34:26 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D060927141
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:32:55 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id m8so2916994ilg.7
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5szz1MBv04IhvJQTuicCFg9n79Ee81Ajv+vxZc2S/PM=;
        b=Ps04vo2SWQavePQsV73gJIC/NPh2WNLyzcfayq16ntkFlSX2GTe8l3tSz+/ZOQ9rwr
         zjo01q4nEDnBnAhJlmw5sXQNDj2G1pcjNSlcwU7ttHkcHvmigK5ilr4BpG1+9IQPOz5g
         78kgbQznhJGSMhqaf5gQWhN18EQZoyYiT7n6vBB1NslIhm3kX6QNzUpi9z4YP3tV5dfK
         4eBktFr9Auh9VJDfwDeGIjXDGaKeCUpoPmXQdPIsXDrTo7wljGR1K0YRvfL8pIe6WcD+
         Vg00xInx0qnd6EqlKxcFdmMFNd1MtCh9blhKdzrCGvgbv6W0sq3zhGc8LZruaHc47DWE
         ZnPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5szz1MBv04IhvJQTuicCFg9n79Ee81Ajv+vxZc2S/PM=;
        b=OSNpvzUOte9UKHg7gyB+l7O/9f73oG7P4Fg8yQYnJLZe9meUN0Xy2kmZpyhfWIWneL
         5FNLx70HA5Uzb2WevLN6dZv+dMHpY4Od5A4EMz9I4kxStSba5h8phxOfnw7P0BvDxGY3
         veHPMkR/7HS+N/7qDLFOI+7+v1UyQzlXNWYAkY4Hf3Zi/HzRTcQGl8NE4NLCJW7rxcmq
         ocosPZyC/uqNXYZRVfJJTd5EOc37gbr4JZjTPqQq0YfpSXiVEE7C7XcWaILoPMKVmu75
         LZnugECH0olxp4k9j4eOD0E79vw3COgdE7y6JCrZe4gsp5jWF9inyOYEaoeGfXP5jdNS
         BP6w==
X-Gm-Message-State: AOAM530QPx689Fn9EwXz7n/BkMPOgyK5XJ21yB8Wn/Fq20ToIWGIc8bp
        rCafIPwg3Vskmt4tNNEc9C6Nq5qAY2TB5srLZHWd1w==
X-Google-Smtp-Source: ABdhPJxQ+YQ+5rUSAu8FuSrPRvVUDrwPDiJ0gRVMwUHY6yjrAD08IqApzeUOhk0e4FuIDC6MRxrp88SyyUw6El+2EaI=
X-Received: by 2002:a05:6e02:1c04:b0:2be:4c61:20f4 with SMTP id
 l4-20020a056e021c0400b002be4c6120f4mr2814376ilh.245.1645122774541; Thu, 17
 Feb 2022 10:32:54 -0800 (PST)
MIME-Version: 1.0
References: <00000000000073b3e805d7fed17e@google.com> <462fa505-25a8-fd3f-cc36-5860c6539664@iogearbox.net>
 <CAPhsuW6rPx3JqpPdQVdZN-YtZp1SbuW1j+SVNs48UVEYv68s1A@mail.gmail.com>
 <CAPhsuW5JhG07TYKKHRbNVtepOLjZ2ekibePyyqCwuzhH0YoP7Q@mail.gmail.com>
 <CANp29Y64wUeARFUn8Z0fjk7duxaZ3bJM2uGuVug_0ZmhGG_UTA@mail.gmail.com> <CAPhsuW6YOv_xjvknt_FPGwDhuCuG5s=7Xt1t-xL2+F6UKsJf-w@mail.gmail.com>
In-Reply-To: <CAPhsuW6YOv_xjvknt_FPGwDhuCuG5s=7Xt1t-xL2+F6UKsJf-w@mail.gmail.com>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Thu, 17 Feb 2022 19:32:43 +0100
Message-ID: <CANp29Y4YC_rSKAgkYTaPV1gcN4q4WeGMvs61P2wnMQEv=kiu8A@mail.gmail.com>
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Song,

On Wed, Feb 16, 2022 at 5:27 PM Song Liu <song@kernel.org> wrote:
>
> Hi Aleksandr,
>
> Thanks for your kind reply!
>
> On Wed, Feb 16, 2022 at 1:38 AM Aleksandr Nogikh <nogikh@google.com> wrote:
> >
> > Hi Song,
> >
> > Is syzkaller not doing something you expect it to do with this config?
>
> I fixed sshkey in the config, and added a suppression for hsr_node_get_first.
> However, I haven't got a repro overnight.

Oh, that's unfortunately not a very reliable thing. The bug has so far
happened only once on syzbot, so it must be pretty rare. Maybe you'll
have more luck with your local setup :)

You can try to run syz-repro on the log file that is available on the
syzbot dashboard:
https://github.com/google/syzkaller/blob/master/tools/syz-repro/repro.go
Syzbot has already done it and apparently failed to succeed, but this
is also somewhat probabilistic, especially when the bug is due to some
rare race condition. So trying it several times might help.

Also you might want to hack your local syzkaller copy a bit:
https://github.com/google/syzkaller/blob/master/syz-manager/manager.go#L804
Here you can drop the limit on the maximum number of repro attempts
and make needLocalRepro only return true if crash.Title matches the
title of this particular bug. With this change your local syzkaller
instance won't waste time reproducing other bugs.

There's also a way to focus syzkaller on some specific kernel
functions/source files:
https://github.com/google/syzkaller/blob/master/pkg/mgrconfig/config.go#L125

--
Best Regards,
Aleksandr

>
> >
> > On Wed, Feb 16, 2022 at 2:38 AM Song Liu <song@kernel.org> wrote:
> > >
> > > On Mon, Feb 14, 2022 at 10:41 PM Song Liu <song@kernel.org> wrote:
> > > >
> > > > On Mon, Feb 14, 2022 at 3:52 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > >
> > > > > Song, ptal.
> > > > >
> > > > > On 2/14/22 7:45 PM, syzbot wrote:
> > > > > > Hello,
> > > > > >
> > > > > > syzbot found the following issue on:
> > > > > >
> > > > > > HEAD commit:    e5313968c41b Merge branch 'Split bpf_sk_lookup remote_port..
> > > > > > git tree:       bpf-next
> > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=10baced8700000
> > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
> > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=2f649ec6d2eea1495a8f
> > >
> > > How do I run the exact same syzkaller? I am doing something like
> > >
> > > ./bin/syz-manager -config qemu.cfg
> > >
> > > with the cfg file like:
> > >
> > > {
> > >         "target": "linux/amd64",
> > >         "http": ":56741",
> > >         "workdir": "workdir",
> > >         "kernel_obj": "linux",
> > >         "image": "./pkg/mgrconfig/testdata/stretch.img",
> >
> > This image location looks suspicious - we store some dummy data for
> > tests in that folder.
> > Instances now run on buildroot-based images, generated with
> > https://github.com/google/syzkaller/blob/master/tools/create-buildroot-image.sh
>
> Thanks for the information. I will give it a try.
>
> >
> > >         "syzkaller": ".",
> > >         "disable_syscalls": ["keyctl", "add_key", "request_key"],
> >
> > For our bpf instances, instead of disable_syscalls we use enable_syscalls:
> >
> > "enable_syscalls": [
> > "bpf", "mkdir", "mount$bpf", "unlink", "close",
> > "perf_event_open*", "ioctl$PERF*", "getpid", "gettid",
> > "socketpair", "sendmsg", "recvmsg", "setsockopt$sock_attach_bpf",
> > "socket$kcm", "ioctl$sock_kcm*", "syz_clone",
> > "mkdirat$cgroup*", "openat$cgroup*", "write$cgroup*",
> > "openat$tun", "write$tun", "ioctl$TUN*", "ioctl$SIOCSIFHWADDR",
> > "openat$ppp", "syz_open_procfs$namespace"
> > ]
>
> I will try with the same list. Thanks!
>
> Song
>
> >
> > >         "suppressions": ["some known bug"],
> > >         "procs": 8,
> >
> > We usually run with "procs": 6, but it's not that important.
> >
> > >         "type": "qemu",
> > >         "vm": {
> > >                 "count": 16,
> > >                 "cpu": 2,
> > >                 "mem": 2048,
> > >                 "kernel": "linux/arch/x86/boot/bzImage"
> > >         }
> > > }
> >
> > Otherwise I don't see any really significant differences.
> >
> > --
> > Best Regards
> > Aleksandr
> >
> > >
> > > Is this correct? I am using stretch.img from syzkaller site, and the
> > > .config from
> > > the link above.
> > >
> > > Thanks,
> > > Song
> > >
