Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3258543F46F
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 03:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhJ2BnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 21:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhJ2BnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 21:43:14 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7ECCC061570;
        Thu, 28 Oct 2021 18:40:46 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so9376511pjl.2;
        Thu, 28 Oct 2021 18:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YoFHrPI4vQheNaDgbRphVcApKfwEqMeNML0BpANj1Ik=;
        b=LAguYGWdq3s/gYN1GO03WTKpCqLwpnndyIgDKyvEUc5kjsoA2SeMMRm6buNGGiqY6C
         hY+w35L+8EQb7Gb10w4J8t1Vo4xu4Rj1I1IOxLoOLr8X8ESpohedoHwQ/NFLANCLKhOZ
         MQVV6LAbjumnBJ6YZb3EYU79Oqvm2a6yGS1pXm7eH6thw9mtHx3ml1BoPUygSLU5ZrE9
         Lr9vp3O10SwcifDkyGX3lD8k8B9+R1ATngWNsi0MyjmoyYemLssdfsRT+/yEJg8shZCM
         qx1UitOPi6to0EOVBm/4lIrseLTwuW3xPbCWQQFhDxQ46fjkG5jVc7GlKNOBLA2Cm0Fg
         SfLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YoFHrPI4vQheNaDgbRphVcApKfwEqMeNML0BpANj1Ik=;
        b=T/yHED9+fnAOBGchAcoZ4ZS/EXq5kOBTL3Tjnr1TNsSLKqSJDVmVMcYau4wOrcQRxH
         +8g9w8txkc9cKf9En0GfeQHMQvEIC7iapDzIEFmxK73Jz6OEWU+kiEvAVcd4N6+n56m5
         sQalMzho989YspRUJ/GoFH/4m91660CNXQSFigy2unIlBR2UhchP/w0d4s1irGDFeDtr
         i5yzstRP9/17Nb9dgLZhxxSx9zIs/e9Amj4bIId3WVxrtuNfDqIGG8sb7hxr1VKq+nlm
         lYLZi3Iq+K6kIe2mYqxS76pMIIbg8tBnkZOEDJr7h3HvSbxCEkgsZ2b0V2rOTHd3OAbM
         4FVg==
X-Gm-Message-State: AOAM531nbB7iagallPhCjTu9JCJA4udOyhPyLZKOeeNw8GD7kDer9liI
        72REZP/6schDYM9Pmp6RBNldpOSAJ4rGrM9xcqY=
X-Google-Smtp-Source: ABdhPJz5qrgc/SWgIkzxmJIWTPyp85xnFOvc0wdaE1L2J5NDfHNH9ZUwLAFrTDs/rrSIBbh7UFQkXzz0/hWCK+l7pZQ=
X-Received: by 2002:a17:90b:3148:: with SMTP id ip8mr8250241pjb.62.1635471646161;
 Thu, 28 Oct 2021 18:40:46 -0700 (PDT)
MIME-Version: 1.0
References: <20211012065705.224643-1-liujian56@huawei.com> <20211012065705.224643-2-liujian56@huawei.com>
 <6172d739dfbbe_82a7f2083b@john-XPS-13-9370.notmuch>
In-Reply-To: <6172d739dfbbe_82a7f2083b@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 28 Oct 2021 18:40:35 -0700
Message-ID: <CAADnVQL0GG7Yk20hJ_J5i0X9RFKwU2ma7eFomut4fi3pzNZffw@mail.gmail.com>
Subject: Re: [PATHC bpf v5 2/3] selftests, bpf: Fix test_txmsg_ingress_parser error
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Liu Jian <liujian56@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 8:22 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Liu Jian wrote:
> > After "skmsg: lose offset info in sk_psock_skb_ingress", the test case
> > with ktls failed. This because ktls parser(tls_read_size) return value
> > is 285 not 256.
> >
> > the case like this:
> >       tls_sk1 --> redir_sk --> tls_sk2
> > tls_sk1 sent out 512 bytes data, after tls related processing redir_sk
> > recved 570 btyes data, and redirect 512 (skb_use_parser) bytes data to
> > tls_sk2; but tls_sk2 needs 285 * 2 bytes data, receive timeout occurred.
> >
> > Signed-off-by: Liu Jian <liujian56@huawei.com>
> > ---
> >  tools/testing/selftests/bpf/test_sockmap.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
> > index eefd445b96fc..06924917ad77 100644
> > --- a/tools/testing/selftests/bpf/test_sockmap.c
> > +++ b/tools/testing/selftests/bpf/test_sockmap.c
> > @@ -1680,6 +1680,8 @@ static void test_txmsg_ingress_parser(int cgrp, struct sockmap_options *opt)
> >  {
> >       txmsg_pass = 1;
> >       skb_use_parser = 512;
> > +     if (ktls == 1)
> > +             skb_use_parser = 570;
> >       opt->iov_length = 256;
> >       opt->iov_count = 1;
> >       opt->rate = 2;
> > --
> > 2.17.1
> >
>
> Hi Liu LGTM sorry about the delay there I thought I acked this already, but
> guess now.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Hmm.
patch 1 is causing a crash.

./test_progs -t sockmap
#124 sockmap_basic:OK
#125 sockmap_ktls:OK
[   15.391661] ==================================================================
[   15.392635] BUG: KASAN: null-ptr-deref in dst_release+0x1d/0x80
[   15.393337] Write of size 4 at addr 0000000000000042 by task test_progs/1358
[   15.394144]
[   15.394326] CPU: 3 PID: 1358 Comm: test_progs Tainted: G
O      5.15.0-rc3-01147-ge4bcff4e3384 #3617
[   15.395415] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[   15.396653] Call Trace:
[   15.396929]  <IRQ>
[   15.397163]  dump_stack_lvl+0x44/0x57
[   15.397569]  ? dst_release+0x1d/0x80
[   15.397970]  kasan_report.cold.15+0x66/0xdf
[   15.398430]  ? dst_release+0x1d/0x80
[   15.398824]  ? sk_psock_verdict_apply+0x149/0x460
[   15.399341]  kasan_check_range+0x1c1/0x1e0
[   15.399789]  ? sk_psock_verdict_apply+0x149/0x460
[   15.400308]  dst_release+0x1d/0x80
[   15.400679]  skb_release_head_state+0x100/0x170
[   15.401178]  skb_release_all+0xe/0x50
[   15.401580]  kfree_skb+0xa1/0x230
[   15.401957]  sk_psock_verdict_apply+0x149/0x460
[   15.402450]  ? bpf_sk_redirect_map+0x2b/0x1a0
[   15.402974]  sk_psock_strp_read+0x239/0x550
[   15.403452]  __strp_recv+0x4a7/0x1b70
[   15.403917]  tcp_read_sock+0x1d2/0x760
