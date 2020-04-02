Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7BA19C621
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 17:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389429AbgDBPki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 11:40:38 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34162 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388972AbgDBPkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 11:40:37 -0400
Received: by mail-lf1-f65.google.com with SMTP id e7so3144533lfq.1;
        Thu, 02 Apr 2020 08:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1+2erfkkbu3TLnQgP4FNOMyrP6eIdZu6/WJPUCTbdAA=;
        b=QiJY6vAFVaADxgmOmeE784cvy5UzSNFL7qXv9U7OiG/ZMEuwa2vEwY6vVWcaccQ7na
         GbAEDP+GKI/k7Z4eVfyfmSz10A/spb4g63pOAA3oq6T/nxAAd3YUVZOuzoqxoF3wW+PZ
         qFpyF74CkGNiCdMXkCbmmeBtF20TG/+rjyFJSvz4kQY/Euvsp7hRzDziIIm0nnx9VHw/
         j37WbJT9HhQEk3LDifhUHXz33V1hGVfNvTalDT9wQtshYzrIjXb72WeZPCKw2+9LATR4
         8/6cxXD8+ZnYsyxq2OTIkr6OKTFV3DJOYwoLKFDF0/QHs1li4pbHyfpO2TP66E/0SDuZ
         hxeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1+2erfkkbu3TLnQgP4FNOMyrP6eIdZu6/WJPUCTbdAA=;
        b=UWKsQ/EjjHANV9fLPgBni5oyPbDuTlHhQ7B8wH9bW+p1Q45etwe9a2FOLVkUNUMVwG
         W30k76KOx3JjcoffDPv7ki0pITqam0iQPabpmw5peoFqbgZoKsc2e3zLIOmWvnvVMcHj
         fLKazb0hpYPmrsuvJA7R5nWhb9trTj1ptwUGsZXSuU71n5GN2eZDT+XG0UvRgKyVYLxT
         Qtl4PH9QudOew7it/NY9BgHM0q1pSuFj/mJP7dlq7psaU5SRp3jhALwjwMbET3Z4ftGk
         7TCNx26wLUSlpC9QPJJECnhhTt/6WaMDTB8RisjQLyr9h0lQw+6sPwHtinIjqy15PN4Y
         5g0w==
X-Gm-Message-State: AGi0PuaaMPw8GauXvn0zkVSKsxgM5ie5/7v0dnmfT58q5A6gOTCERg1I
        US9GSYayGON622+QjrYpVqotdirxuNQmKxKsZ88=
X-Google-Smtp-Source: APiQypIdvYJc6O/exwVrWe6ToU6iOSXmBNO1FTBzi81ghhxfIzKlP+jfokCDAjIOMT0OgNS+I5in+pfDYpMcW1SGxZc=
X-Received: by 2002:a19:40ca:: with SMTP id n193mr2503030lfa.196.1585842035185;
 Thu, 02 Apr 2020 08:40:35 -0700 (PDT)
MIME-Version: 1.0
References: <fb5ab568-9bc8-3145-a8db-3e975ccdf846@gmail.com>
 <20200331060641.79999-1-maowenan@huawei.com> <7a1d55ad-1427-67fe-f204-4d4a0ab2c4b1@gmail.com>
 <20200401181419.7acd2aa6@carbon> <ede2f407-839e-d29e-0ebe-aa39dd461bfd@gmail.com>
 <20200402110619.48f31a63@carbon>
In-Reply-To: <20200402110619.48f31a63@carbon>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 2 Apr 2020 08:40:23 -0700
Message-ID: <CAADnVQKEyv_bRhEfu1Jp=DSggj_O2xjJyd_QZ7a4LJY+dUO2rg@mail.gmail.com>
Subject: Re: [PATCH net v2] veth: xdp: use head instead of hard_start
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Mao Wenan <maowenan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, jwi@linux.ibm.com,
        jianglidong3@jd.com, Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 2, 2020 at 2:06 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> On Thu, 2 Apr 2020 09:47:03 +0900
> Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:
>
> > On 2020/04/02 1:15, Jesper Dangaard Brouer wrote:
> > ...
> > > [PATCH RFC net-next] veth: adjust hard_start offset on redirect XDP frames
> > >
> > > When native XDP redirect into a veth device, the frame arrives in the
> > > xdp_frame structure. It is then processed in veth_xdp_rcv_one(),
> > > which can run a new XDP bpf_prog on the packet. Doing so requires
> > > converting xdp_frame to xdp_buff, but the tricky part is that
> > > xdp_frame memory area is located in the top (data_hard_start) memory
> > > area that xdp_buff will point into.
> > >
> > > The current code tried to protect the xdp_frame area, by assigning
> > > xdp_buff.data_hard_start past this memory. This results in 32 bytes
> > > less headroom to expand into via BPF-helper bpf_xdp_adjust_head().
> > >
> > > This protect step is actually not needed, because BPF-helper
> > > bpf_xdp_adjust_head() already reserve this area, and don't allow
> > > BPF-prog to expand into it. Thus, it is safe to point data_hard_start
> > > directly at xdp_frame memory area.
> > >
> > > Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
> >
> > FYI: This mail address is deprecated.
> >
> > > Fixes: 9fc8d518d9d5 ("veth: Handle xdp_frames in xdp napi ring")
> > > Reported-by: Mao Wenan <maowenan@huawei.com>
> > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >
> > FWIW,
> >
> > Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
>
> Thanks.
>
> I have updated your email and added your ack in my patchset.  I will
> submit this officially once net-next opens up again[1], as part my
> larger patchset for introducing XDP frame_sz.

It looks like bug fix to me.
The way I read it that behavior of bpf_xdp_adjust_head() is a bit
buggy with veth netdev,
so why wait ?
