Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A472F3B0C
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406937AbhALTrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406756AbhALTrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 14:47:40 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8B8C06179F;
        Tue, 12 Jan 2021 11:46:59 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id p13so4235147ljg.2;
        Tue, 12 Jan 2021 11:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nLuzLYNt5T8osq7JXeaiHrLO6+i9dEnVYqGJgVkKi9Y=;
        b=vYfNW4936VSfsfaE4FPjVdNXto4N/M6kGen+8Mc9PnTNtkt3FVhlO9Lji+rTbggdvU
         efVCBHX+QBBFFLAFdKchQ9dGckH15dNbIkoMq40g8WcfI8bO4r8omaKScS211OynYzio
         pwt0Af28IscLBvCfEPiZOP32LiaGnrTdwTR8t01o0T8cix8TCiWYtr2bztCZ7EK7HmeC
         CG3gbo/QgzsMZwhBldrnwCNwPwwfDG8/cDqA3S16bIuaw2LV5L8InT8eWdbL5WxiA1iD
         rB3byLm4YjGBcbnHqTtCMuvlbGkrDi88jaoc8oqgOVG7r/OokbENWKJ7gGq16KhulWI0
         HrYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nLuzLYNt5T8osq7JXeaiHrLO6+i9dEnVYqGJgVkKi9Y=;
        b=fjqn4NsamChvqZhLXDepzqXB44JWpAHsk/BBFtoIA6yzEnxDY8Ydq8ILGD4XmMlBoC
         x+FvAovBnCJJaRghpWMPQEpvd2MhIiUlWdM+CPEjAkHP9EU6Iqzm4DlXvylg35UuN9Au
         QM4FUW6fZfoTEvzwez6/Z92S1AlF9XbsSOobxmazt3QMXP0470PpH74ogMg81woWtGTA
         P6viVsxH9yKUoufiY4qBRxsO0QMPQhXvh9uKex62JLTCf0wh7FlL0vsK1O7WmqGW8S6V
         HpHVNOWrtSB1nBDfpQN8UjKLcE6/7NogHv4yPpYFnQOs8JGw0vX4Pdh4yjZLSPfa6Pp1
         G/Fw==
X-Gm-Message-State: AOAM532lzIPpAiIwIGHetI6oKHXeLypttXmwRH39VZe2hpOpDiFHcSpW
        i/5wVdo9optl5SFVbVaWRcDZ1RKMdSiWgpAS4w0=
X-Google-Smtp-Source: ABdhPJwZhBCGKnrIy2pClnDTPtHGtrdA4y52ofV0ZvmD0av1lZET+wEvea6DglcSlWgjWslhNj+O3PtSrJmX0zO8gd8=
X-Received: by 2002:a2e:878a:: with SMTP id n10mr350199lji.236.1610480818432;
 Tue, 12 Jan 2021 11:46:58 -0800 (PST)
MIME-Version: 1.0
References: <20210112194143.1494-1-yuri.benditovich@daynix.com> <20210112194143.1494-4-yuri.benditovich@daynix.com>
In-Reply-To: <20210112194143.1494-4-yuri.benditovich@daynix.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 12 Jan 2021 11:46:46 -0800
Message-ID: <CAADnVQ++1_voT2fZ021ExcON0KfHtA8MyHc-WYe-XXJoPTD6ig@mail.gmail.com>
Subject: Re: [RFC PATCH 3/7] tun: allow use of BPF_PROG_TYPE_SCHED_CLS program type
To:     Yuri Benditovich <yuri.benditovich@daynix.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Willem de Bruijn <willemb@google.com>, gustavoars@kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        nogikh@google.com, Pablo Neira Ayuso <pablo@netfilter.org>,
        decui@microsoft.com, cai@lca.pw,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        bpf <bpf@vger.kernel.org>, Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 11:42 AM Yuri Benditovich
<yuri.benditovich@daynix.com> wrote:
>
> This program type can set skb hash value. It will be useful
> when the tun will support hash reporting feature if virtio-net.
>
> Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> ---
>  drivers/net/tun.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 7959b5c2d11f..455f7afc1f36 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2981,6 +2981,8 @@ static int tun_set_ebpf(struct tun_struct *tun, struct tun_prog __rcu **prog_p,
>                 prog = NULL;
>         } else {
>                 prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SOCKET_FILTER);
> +               if (IS_ERR(prog))
> +                       prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SCHED_CLS);

You've ignored the feedback and just resend? what for?
