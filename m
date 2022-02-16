Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981C34B7CC9
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 02:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245550AbiBPBi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 20:38:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245536AbiBPBiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 20:38:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E313220D3;
        Tue, 15 Feb 2022 17:38:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEEE6B81D90;
        Wed, 16 Feb 2022 01:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADFFC340ED;
        Wed, 16 Feb 2022 01:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644975491;
        bh=An6Gzjiy9PJBIQlLMy16uDVBiMvq2VU/Zw/2B3HW4RI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=L8IHSnLxGXZTjON5iHPGIfxBlgRg4w88B26WdpWwClqWCPfzbiToTPhtaJXdBL+aI
         4mDpieEpNDEHlTSZgQ3ycCOtxeStuZQ+ij7llEwle9MvOHJjPpsJTHBxDb5MOOoZLt
         W5B4HrkjGqoql3fOoCtbIVz8xd27TH9bH1BzLpjZiaylOAvY9RQmJSg/Vls8vWO34u
         Pxy8nGE86MfPMRQPWAHyAT5NuP3JhgV7sC3ZOtVxagrrt6DoetfV1XCsG5r+JhNMyF
         2EBZtgQ4byhIj4nBI/m7GLKySdzbmSseZjs7EzHlOkGGNsSuLmdp5qXliP0b0dRtrT
         XY5LDXeIDYPVw==
Received: by mail-yb1-f181.google.com with SMTP id l125so1548946ybl.4;
        Tue, 15 Feb 2022 17:38:11 -0800 (PST)
X-Gm-Message-State: AOAM530ikHDzjaYWOYAUahnxyaNU0ELppBiwmrR+1/y++zItPXLWhEXK
        hbqHxv+f8AFDVspO6tmLQ3cpHrTWeHK/z3tzGFE=
X-Google-Smtp-Source: ABdhPJwG4XmD8gNIiQK5EY13nrv4sMK9GL27p7BaAX4IKT6t4ZKiqxEt+3aODNJP7jQrV6YWkHHpsXG5srKjVv7cme8=
X-Received: by 2002:a0d:ebc3:0:b0:2d6:34f5:7d67 with SMTP id
 u186-20020a0debc3000000b002d634f57d67mr491346ywe.73.1644975490580; Tue, 15
 Feb 2022 17:38:10 -0800 (PST)
MIME-Version: 1.0
References: <00000000000073b3e805d7fed17e@google.com> <462fa505-25a8-fd3f-cc36-5860c6539664@iogearbox.net>
 <CAPhsuW6rPx3JqpPdQVdZN-YtZp1SbuW1j+SVNs48UVEYv68s1A@mail.gmail.com>
In-Reply-To: <CAPhsuW6rPx3JqpPdQVdZN-YtZp1SbuW1j+SVNs48UVEYv68s1A@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 15 Feb 2022 17:37:59 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5JhG07TYKKHRbNVtepOLjZ2ekibePyyqCwuzhH0YoP7Q@mail.gmail.com>
Message-ID: <CAPhsuW5JhG07TYKKHRbNVtepOLjZ2ekibePyyqCwuzhH0YoP7Q@mail.gmail.com>
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

On Mon, Feb 14, 2022 at 10:41 PM Song Liu <song@kernel.org> wrote:
>
> On Mon, Feb 14, 2022 at 3:52 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > Song, ptal.
> >
> > On 2/14/22 7:45 PM, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    e5313968c41b Merge branch 'Split bpf_sk_lookup remote_port..
> > > git tree:       bpf-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=10baced8700000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=2f649ec6d2eea1495a8f

How do I run the exact same syzkaller? I am doing something like

./bin/syz-manager -config qemu.cfg

with the cfg file like:

{
        "target": "linux/amd64",
        "http": ":56741",
        "workdir": "workdir",
        "kernel_obj": "linux",
        "image": "./pkg/mgrconfig/testdata/stretch.img",
        "syzkaller": ".",
        "disable_syscalls": ["keyctl", "add_key", "request_key"],
        "suppressions": ["some known bug"],
        "procs": 8,
        "type": "qemu",
        "vm": {
                "count": 16,
                "cpu": 2,
                "mem": 2048,
                "kernel": "linux/arch/x86/boot/bzImage"
        }
}

Is this correct? I am using stretch.img from syzkaller site, and the
.config from
the link above.

Thanks,
Song
