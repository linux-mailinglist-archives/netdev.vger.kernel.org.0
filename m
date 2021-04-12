Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0541E35C869
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242236AbhDLONm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 10:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238980AbhDLONl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 10:13:41 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FEEC061574;
        Mon, 12 Apr 2021 07:13:23 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t22so6107582ply.1;
        Mon, 12 Apr 2021 07:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=slIvEgmXb6ApgwSAbOaDZIRhYdLk3zxnLjjOYTdh2b4=;
        b=IPK63SsE7RjajsVnBPK9Puh5HwwVnDQn+9otRXwlJBNJ2QjcnbTkiuoRHBVGne0tlA
         Wpa7NqwjmFVHhhLlQJwPh2ls9LH2XIC0U03z0hFzxyJ1btE47ZvS0gwrXeZSDE6K1hV/
         ZXRN92mwsHF1vEqa67AjJWygaFV8sXtyM1jr85nTaUg0ylscFSXTf1AhGhOMz399C50g
         8tSpNfDXZGtqVdWPEfDXfcADgzyH4V4HvV/QReRgM31puvRVRpwpnmg1yhYRcGEb4umG
         WX5ZATa4x+/14RKMfe3mpaMPNAXGuxTsH37NNPDf9pxg6xNvje2jEXxU4RqbAQ3jckfl
         YQVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=slIvEgmXb6ApgwSAbOaDZIRhYdLk3zxnLjjOYTdh2b4=;
        b=VvzJrrzLNGD5NoPImlSfQz9tuyrPnom5Zt2QbUsTrVELYdMwR5CmcV16YLaFJ3f6Gg
         Ww+Tkg9bYCjJ5R3PZU7J8NSTtpRnp7TBL7a9hIA1EDUvOH3whhuggUwsDGjD3riiAQfT
         8bILpvA+FwlevNzxmqwXSgtJHXbHVr+h9Hm8GvdkwFA28nhAL6hbJKefgfT8VLZG4h+h
         Q91oqYA3Ku2PlV9BJz4vzv8JXDSOBMgY33xvLkXicMqW+9MU/obGCZD7qE1dzKHYzRc+
         H7WmNXgBYuQ/aWIcy9HsvshnnTZDR6tDEDhHqWQ+vcEICtRUgcPrSnmhyfczsLemQ7Ru
         BbJw==
X-Gm-Message-State: AOAM530Jvx8j6h2pTNijDRGF9P8fmAfcfbc1z9Le1TOmcFX6kkdgCHJ1
        6OADGX4vF8L/CyUI20ooKAFhnUBFnLNSqLMOCY8=
X-Google-Smtp-Source: ABdhPJwbcD7vO7diUEhreS0GiKV45vQwq4TEFi8fE7grTKSQlVAS6+5WfI422PGQiDnV9/T7h2vdzGrwvqTuca1HJNQ=
X-Received: by 2002:a17:902:b494:b029:e7:36be:9ce7 with SMTP id
 y20-20020a170902b494b02900e736be9ce7mr26450279plr.43.1618236802988; Mon, 12
 Apr 2021 07:13:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210331122602.6000-1-alobakin@pm.me>
In-Reply-To: <20210331122602.6000-1-alobakin@pm.me>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 12 Apr 2021 16:13:12 +0200
Message-ID: <CAJ8uoz2jym_AmCyMt_B32YBAEsjTNpaQF-WAJUavUe3P5_at3w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/2] xsk: introduce generic almost-zerocopy xmit
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 2:27 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> This series is based on the exceptional generic zerocopy xmit logics
> initially introduced by Xuan Zhuo. It extends it the way that it
> could cover all the sane drivers, not only the ones that are capable
> of xmitting skbs with no linear space.
>
> The first patch is a random while-we-are-here improvement over
> full-copy path, and the second is the main course. See the individual
> commit messages for the details.
>
> The original (full-zerocopy) path is still here and still generally
> faster, but for now it seems like virtio_net will remain the only
> user of it, at least for a considerable period of time.
>
> From v1 [0]:
>  - don't add a whole SMP_CACHE_BYTES because of only two bytes
>    (NET_IP_ALIGN);
>  - switch to zerocopy if the frame is 129 bytes or longer, not 128.
>    128 still fit to kmalloc-512, while a zerocopy skb is always
>    kmalloc-1024 -> can potentially be slower on this frame size.
>
> [0] https://lore.kernel.org/netdev/20210330231528.546284-1-alobakin@pm.me
>
> Alexander Lobakin (2):
>   xsk: speed-up generic full-copy xmit

I took both your patches for a spin on my machine and for the first
one I do see a small but consistent drop in performance. I thought it
would go the other way, but it does not so let us put this one on the
shelf for now.

>   xsk: introduce generic almost-zerocopy xmit

This one wreaked havoc on my machine ;-). The performance dropped with
75% for packets larger than 128 bytes when the new scheme kicks in.
Checking with perf top, it seems that we spend much more time
executing the sendmsg syscall. Analyzing some more:

$ sudo bpftrace -e 'kprobe:__sys_sendto { @calls = @calls + 1; }
interval:s:1 {printf("calls/sec: %d\n", @calls); @calls = 0;}'
Attaching 2 probes...
calls/sec: 1539509 with your patch compared to

calls/sec: 105796 without your patch

The application spends a lot of more time trying to get the kernel to
send new packets, but the kernel replies with "have not completed the
outstanding ones, so come back later" = EAGAIN. Seems like the
transmission takes longer when the skbs have fragments, but I have not
examined this any further. Did you get a speed-up?

>  net/xdp/xsk.c | 32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)
>
> --
> Well, this is untested. I currently don't have an access to my setup
> and is bound by moving to another country, but as I don't know for
> sure at the moment when I'll get back to work on the kernel next time,
> I found it worthy to publish this now -- if any further changes will
> be required when I already will be out-of-sight, maybe someone could
> carry on to make a another revision and so on (I'm still here for any
> questions, comments, reviews and improvements till the end of this
> week).
> But this *should* work with all the sane drivers. If a particular
> one won't handle this, it's likely ill. Any tests are highly
> appreciated. Thanks!
> --
> 2.31.1
>
>
