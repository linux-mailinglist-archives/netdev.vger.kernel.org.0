Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9954B8DF4
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 17:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236419AbiBPQ1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 11:27:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235564AbiBPQ1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 11:27:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFB0F390F;
        Wed, 16 Feb 2022 08:27:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABD0D61B45;
        Wed, 16 Feb 2022 16:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A395C340F5;
        Wed, 16 Feb 2022 16:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645028858;
        bh=pEh4L2k9OlwykfyE6yHq4tYTDVuGpXE+S5QkPvGsxIs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rbZyAd4+1IEETsA4jI6CFCdcT8cTsrnfIpBJNmmfUe4lOqhPmHwxQRQvmbDtNclax
         MUG6ajiG3mW1V5Jy89g/fq4G3kuFK02Xxe6VzDXqLUDThSvQCppALbIbYwnDXOjl4X
         FB0USW5gWc9mKCy+UXU/fvJqsHjtobcMWv73kclp8T3gDsPS+hdlaKb83EmGpFgBRk
         QNDUfI0O9InKp34jd9amFfR/JLp7RLL+0GiQXG7Cvxx+7DEz1HvYPM2UseW5Buw64L
         UROwzAjKNWHhwSgF6qSF/pNBrs0MqEqHVnSegshYdr9F7AC5RR73p3Qf8uJnBOQSuM
         NyyVM77QOo+YA==
Received: by mail-yb1-f172.google.com with SMTP id bt13so7255310ybb.2;
        Wed, 16 Feb 2022 08:27:38 -0800 (PST)
X-Gm-Message-State: AOAM530Ct4Vr81ZwU25UcbO+ZzrmP5LtL03A4RKqP3ZxPyuxhp3OcEhB
        TJqsEk3/r/kilGPGriTw+cNudwXjrAAo91tkfWQ=
X-Google-Smtp-Source: ABdhPJzPEvVtn4jSjWY+6ICZuPl2oIeDxMoH3I4SgYfUWi+aAoX3Feze+8QoPVzVUrCoGgyIbsND6ZEHfRTy4Xab0l0=
X-Received: by 2002:a25:bb8c:0:b0:623:b475:d5f7 with SMTP id
 y12-20020a25bb8c000000b00623b475d5f7mr2893894ybg.654.1645028857166; Wed, 16
 Feb 2022 08:27:37 -0800 (PST)
MIME-Version: 1.0
References: <00000000000073b3e805d7fed17e@google.com> <462fa505-25a8-fd3f-cc36-5860c6539664@iogearbox.net>
 <CAPhsuW6rPx3JqpPdQVdZN-YtZp1SbuW1j+SVNs48UVEYv68s1A@mail.gmail.com>
 <CAPhsuW5JhG07TYKKHRbNVtepOLjZ2ekibePyyqCwuzhH0YoP7Q@mail.gmail.com> <CANp29Y64wUeARFUn8Z0fjk7duxaZ3bJM2uGuVug_0ZmhGG_UTA@mail.gmail.com>
In-Reply-To: <CANp29Y64wUeARFUn8Z0fjk7duxaZ3bJM2uGuVug_0ZmhGG_UTA@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 16 Feb 2022 08:27:26 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6YOv_xjvknt_FPGwDhuCuG5s=7Xt1t-xL2+F6UKsJf-w@mail.gmail.com>
Message-ID: <CAPhsuW6YOv_xjvknt_FPGwDhuCuG5s=7Xt1t-xL2+F6UKsJf-w@mail.gmail.com>
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Read in bpf_jit_free
To:     Aleksandr Nogikh <nogikh@google.com>
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
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Aleksandr,

Thanks for your kind reply!

On Wed, Feb 16, 2022 at 1:38 AM Aleksandr Nogikh <nogikh@google.com> wrote:
>
> Hi Song,
>
> Is syzkaller not doing something you expect it to do with this config?

I fixed sshkey in the config, and added a suppression for hsr_node_get_first.
However, I haven't got a repro overnight.

>
> On Wed, Feb 16, 2022 at 2:38 AM Song Liu <song@kernel.org> wrote:
> >
> > On Mon, Feb 14, 2022 at 10:41 PM Song Liu <song@kernel.org> wrote:
> > >
> > > On Mon, Feb 14, 2022 at 3:52 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > >
> > > > Song, ptal.
> > > >
> > > > On 2/14/22 7:45 PM, syzbot wrote:
> > > > > Hello,
> > > > >
> > > > > syzbot found the following issue on:
> > > > >
> > > > > HEAD commit:    e5313968c41b Merge branch 'Split bpf_sk_lookup remote_port..
> > > > > git tree:       bpf-next
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=10baced8700000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=2f649ec6d2eea1495a8f
> >
> > How do I run the exact same syzkaller? I am doing something like
> >
> > ./bin/syz-manager -config qemu.cfg
> >
> > with the cfg file like:
> >
> > {
> >         "target": "linux/amd64",
> >         "http": ":56741",
> >         "workdir": "workdir",
> >         "kernel_obj": "linux",
> >         "image": "./pkg/mgrconfig/testdata/stretch.img",
>
> This image location looks suspicious - we store some dummy data for
> tests in that folder.
> Instances now run on buildroot-based images, generated with
> https://github.com/google/syzkaller/blob/master/tools/create-buildroot-image.sh

Thanks for the information. I will give it a try.

>
> >         "syzkaller": ".",
> >         "disable_syscalls": ["keyctl", "add_key", "request_key"],
>
> For our bpf instances, instead of disable_syscalls we use enable_syscalls:
>
> "enable_syscalls": [
> "bpf", "mkdir", "mount$bpf", "unlink", "close",
> "perf_event_open*", "ioctl$PERF*", "getpid", "gettid",
> "socketpair", "sendmsg", "recvmsg", "setsockopt$sock_attach_bpf",
> "socket$kcm", "ioctl$sock_kcm*", "syz_clone",
> "mkdirat$cgroup*", "openat$cgroup*", "write$cgroup*",
> "openat$tun", "write$tun", "ioctl$TUN*", "ioctl$SIOCSIFHWADDR",
> "openat$ppp", "syz_open_procfs$namespace"
> ]

I will try with the same list. Thanks!

Song

>
> >         "suppressions": ["some known bug"],
> >         "procs": 8,
>
> We usually run with "procs": 6, but it's not that important.
>
> >         "type": "qemu",
> >         "vm": {
> >                 "count": 16,
> >                 "cpu": 2,
> >                 "mem": 2048,
> >                 "kernel": "linux/arch/x86/boot/bzImage"
> >         }
> > }
>
> Otherwise I don't see any really significant differences.
>
> --
> Best Regards
> Aleksandr
>
> >
> > Is this correct? I am using stretch.img from syzkaller site, and the
> > .config from
> > the link above.
> >
> > Thanks,
> > Song
> >
