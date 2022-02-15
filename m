Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD9E4B63B6
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbiBOGlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:41:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbiBOGlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:41:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A86B7C50;
        Mon, 14 Feb 2022 22:41:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21B15B817A0;
        Tue, 15 Feb 2022 06:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25BDC36AE2;
        Tue, 15 Feb 2022 06:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644907291;
        bh=jEmPVNZaBNwt/VLaRLc3lHKKicFk8z2UL+ikTy2DTQI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JwYoRmnaQEoFzUSq4tfhgUI8/LxYHECZ+i2D+1+J74DSWArNIsM9FCwb+T8mKbOsh
         RSNWgcVWh9EJ/etpOjmpPZauvrj+QaCjvTCjCaZkiHR3F5qmHisDUiK9SSUo2qXBLY
         Yj4h0xL71i5a8/1oIelqnABk0CJVn43MiVew+rcgqk4N5IaMxH2dM/ULoT5Lh5Itv4
         JIhwCy0WX+RoPrhc9KPQifO/ou7WeN0X33qJ9b1zQLDPfwpM6+uWlkxNSmaALrhVEj
         kRQ4nOXGLGi7HG7PwaihDIjIRot/wjJnjiBOuY3Mg393XYtdXVoGQ6/ACn1YCo3n4Z
         n7RgzsEI+FRMQ==
Received: by mail-yb1-f172.google.com with SMTP id p5so52903496ybd.13;
        Mon, 14 Feb 2022 22:41:31 -0800 (PST)
X-Gm-Message-State: AOAM532TOcXuCx8Y5vHNvLO3pvtqPpKj7/YYqVf93WR45A+26wnHIxiY
        YoD3C0PlJKX4zwcdmTEtHe5h0abhwp7lcSz3NkE=
X-Google-Smtp-Source: ABdhPJzswv2sMMGR1rXWoD7A42tM1dR/Z1aNC51Ziw3g8/36nUyzOBhKeFLX0p7x0D7ZhQw2xxq2Ng3glg3YGjqy2lM=
X-Received: by 2002:a5b:a03:: with SMTP id k3mr2546249ybq.219.1644907290851;
 Mon, 14 Feb 2022 22:41:30 -0800 (PST)
MIME-Version: 1.0
References: <00000000000073b3e805d7fed17e@google.com> <462fa505-25a8-fd3f-cc36-5860c6539664@iogearbox.net>
In-Reply-To: <462fa505-25a8-fd3f-cc36-5860c6539664@iogearbox.net>
From:   Song Liu <song@kernel.org>
Date:   Mon, 14 Feb 2022 22:41:19 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6rPx3JqpPdQVdZN-YtZp1SbuW1j+SVNs48UVEYv68s1A@mail.gmail.com>
Message-ID: <CAPhsuW6rPx3JqpPdQVdZN-YtZp1SbuW1j+SVNs48UVEYv68s1A@mail.gmail.com>
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Read in bpf_jit_free
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     syzbot <syzbot+2f649ec6d2eea1495a8f@syzkaller.appspotmail.com>,
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

On Mon, Feb 14, 2022 at 3:52 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Song, ptal.
>
> On 2/14/22 7:45 PM, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    e5313968c41b Merge branch 'Split bpf_sk_lookup remote_port..
> > git tree:       bpf-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10baced8700000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
> > dashboard link: https://syzkaller.appspot.com/bug?extid=2f649ec6d2eea1495a8f
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+2f649ec6d2eea1495a8f@syzkaller.appspotmail.com
> >
> > ==================================================================
> > BUG: KASAN: vmalloc-out-of-bounds in bpf_jit_binary_pack_free kernel/bpf/core.c:1120 [inline]
> > BUG: KASAN: vmalloc-out-of-bounds in bpf_jit_free+0x2b5/0x2e0 kernel/bpf/core.c:1151
> > Read of size 4 at addr ffffffffa0001a80 by task kworker/0:18/13642
> >
> > CPU: 0 PID: 13642 Comm: kworker/0:18 Not tainted 5.16.0-syzkaller-11655-ge5313968c41b #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Workqueue: events bpf_prog_free_deferred
> > Call Trace:
> >   <TASK>
> >   __dump_stack lib/dump_stack.c:88 [inline]
> >   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> >   print_address_description.constprop.0.cold+0xf/0x336 mm/kasan/report.c:255
> >   __kasan_report mm/kasan/report.c:442 [inline]
> >   kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
> >   bpf_jit_binary_pack_free kernel/bpf/core.c:1120 [inline]
> >   bpf_jit_free+0x2b5/0x2e0 kernel/bpf/core.c:1151
> >   bpf_prog_free_deferred+0x5c1/0x790 kernel/bpf/core.c:2524
> >   process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
> >   worker_thread+0x657/0x1110 kernel/workqueue.c:2454
> >   kthread+0x2e9/0x3a0 kernel/kthread.c:377
> >   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> >   </TASK>

I think this is the same issue as [1], that the 2MB page somehow got freed
while still in use. I couldn't spot any bug with bpf_prog_pack allocate/free
logic. I haven't got luck reproducing it either. Will continue tomorrow.


[1] https://lore.kernel.org/netdev/0000000000007646bd05d7f81943@google.com/t/

> >
> >
> > Memory state around the buggy address:
> >   ffffffffa0001980: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> >   ffffffffa0001a00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> >> ffffffffa0001a80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> >                     ^
> >   ffffffffa0001b00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> >   ffffffffa0001b80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> > ==================================================================
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
>
