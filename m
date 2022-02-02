Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790314A6B8D
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbiBBFoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiBBFoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:44:07 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFCCC06173B;
        Tue,  1 Feb 2022 21:44:06 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id u14so38342633lfo.11;
        Tue, 01 Feb 2022 21:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5f3DJzlhkLU+KnecyEw0I9PzHYf518gWguuBWUK7iTA=;
        b=Pc+yGLstMPtuzf7PyH2n9krkpusMX8gnmf4EygtouMy/oczZtRbPv+COm9Q59spJjU
         9NI+p0CTJvLi7Ob2P0JNhD6YDcCVVE8Rssvh14u221UiiesplEK5yTtnJQOSbKHiplGc
         HEyXxqg9eZjMR51xdPwwAAs1MFdV6ReBOh7TDpy3I0VhenpWB3Ywpcfa2IKVRvbAd7yc
         UENkr5N4OtM7EKBdpyaJwVZnTGdWU2aQ+dDfxug6mkrwkJv6aDox/QG0FXpv+gIP9UaU
         9rnsW7ZbWeYvE6K0PzilvJm0hEMneSXAn9PrJk2qptyZtnGkiogExIsiMh8vZaznV0yi
         XU8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5f3DJzlhkLU+KnecyEw0I9PzHYf518gWguuBWUK7iTA=;
        b=EznCL2MtttzX4FPz8WD3JnzxBjlF/kId4LQOjasOXVRdayBTlKBfVrJk0bTVf+4x6c
         mAzwI7y30U0z70ib3Tt7bjk3fzd6vkDgvlVo3rewS/OJhak8eo3Ao0EbdXrVC0sZCPKQ
         8kiBv8BuVbLmqJfoNNFD3uO+jqB0+Hr5s2npovAYrRNuK8Stg0+0jtGxc1VQwoVwbxIq
         Qh9VdBN20PKDtL9A9IvkJZ2lplUVI0EqbKMty0nxCIMqI4ePDt5AXgLhoMKY+An58S5V
         2KsMRRLUAQOeVJmEuS8Ymqxv1+4l7gnWgTP4+dLb3kwniloL+jCUmYbPHHFRy1wTqwze
         C95w==
X-Gm-Message-State: AOAM532ioL700H1fGPRvEANk6CebDAzy6+yE4yATGF3Ph9+5Qsr/gp3f
        03pxUbp9UEP7uKsWrUr1PKwDffLo1GHziP6kwK8=
X-Google-Smtp-Source: ABdhPJzn5zhkg3GjH6nD4SmZrfUZ6yvkCQEtwtM9lgWiqqsU5K74Nrc7RkHgt+WsSAo65YHZQZfgHjA9No2fKOJJG58=
X-Received: by 2002:a05:6512:110f:: with SMTP id l15mr21860071lfg.161.1643780644930;
 Tue, 01 Feb 2022 21:44:04 -0800 (PST)
MIME-Version: 1.0
References: <20220131114600.21849-1-houtao1@huawei.com> <36954dbd-beab-9599-3579-105037822045@iogearbox.net>
 <CANUnq3ZneUy1LZBsR59s-QwzqK0pfRrf-2DPL7nQ3rgCnANJ6A@mail.gmail.com>
In-Reply-To: <CANUnq3ZneUy1LZBsR59s-QwzqK0pfRrf-2DPL7nQ3rgCnANJ6A@mail.gmail.com>
From:   htbegin <hotforest@gmail.com>
Date:   Wed, 2 Feb 2022 13:43:53 +0800
Message-ID: <CANUnq3a+sT_qtO1wNQ3GnLGN7FLvSSgvit2UVgqQKRpUvs85VQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: use VM_MAP instead of VM_ALLOC for ringbuf
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Hou Tao <houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Feb 1, 2022 at 10:25 AM htbegin <hotforest@gmail.com> wrote:
>
> Hi,
>
> On Tue, Feb 1, 2022 at 12:28 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 1/31/22 12:46 PM, Hou Tao wrote:
> > > Now the ringbuf area in /proc/vmallocinfo is showed as vmalloc,
> > > but VM_ALLOC is only used for vmalloc(), and for the ringbuf area
> > > it is created by mapping allocated pages, so use VM_MAP instead.
> > >
> > > After the change, ringbuf info in /proc/vmallocinfo will changed from:
> > >    [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmalloc user
> > > to
> > >    [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmap user
> >
> > Could you elaborate in the commit msg if this also has some other internal
> > effect aside from the /proc/vmallocinfo listing? Thanks!
> >
> For now, the VM_MAP flag only affects the output in /proc/vmallocinfo.

Just find out that the VM_ALLOC will be used to check whether or not
the mapped area needs to be marked as accessible by commit
2fd3fb0be1d1 ("kasan, vmalloc: unpoison VM_ALLOC pages after mapping").
And the patch can fix the vmalloc oob access reported by syzbot [1] ,
I will post v2
to illustrate that.

Regards,
Tao

[1]: https://lore.kernel.org/bpf/0000000000000a9b7d05d6ee565f@google.com/T/#u
>
> Thanks,
> Tao
> > > Signed-off-by: Hou Tao <houtao1@huawei.com>
> > > ---
> > >   kernel/bpf/ringbuf.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> > > index 638d7fd7b375..710ba9de12ce 100644
> > > --- a/kernel/bpf/ringbuf.c
> > > +++ b/kernel/bpf/ringbuf.c
> > > @@ -104,7 +104,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
> > >       }
> > >
> > >       rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
> > > -               VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
> > > +               VM_MAP | VM_USERMAP, PAGE_KERNEL);
> > >       if (rb) {
> > >               kmemleak_not_leak(pages);
> > >               rb->pages = pages;
> > >
> >
