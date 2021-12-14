Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA8247450B
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhLNO3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbhLNO3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 09:29:52 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB944C06173E;
        Tue, 14 Dec 2021 06:29:51 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id r7-20020a17090a560700b001b0e876e140so1408872pjf.5;
        Tue, 14 Dec 2021 06:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M8eB2exAYp0OeqaMao6k/q2Xo+1P1Y1TfH0SnU7ne7I=;
        b=NndogFKxKzCQsKgyJZ8NykCinS1tw5EtUDZIyDrIhqluDhT7TL6yROvjQsolzp+mUb
         0k3DJi9MYxkVrmCljTgUvdBO2AdnRwlyyHlRrtpcdYyfG4eMxUt0EcV9gWK5Ebs0KVsZ
         d6zumXZNYn3wuNkYRpHYfvRXF0XVD+Ur9TB607QC0kzGXwv92i2RLoP9cH1bVT4rqj0g
         uwS6IIF0ZDog/SgTXrftMhWMXPc1j703Q5QGykS7ljuiUt5gFKlD5rgAhl/Na9ME2Js6
         SxeOStqWB1sHoB5pSZcmYtE4GirFx9MU+t3XHrsoKgfW/cwTdlc2Ia45w4WJxtK/WrsN
         v3Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M8eB2exAYp0OeqaMao6k/q2Xo+1P1Y1TfH0SnU7ne7I=;
        b=T4ZW5tQtzWFDh7L8Ml4yke6W2zLVevG5nAHj8LJXFf2W4y4RPRfUwOxUEiliwuXG/B
         gu4hTfqLyoUB9La1So78dItHtLN54+870rq+tmiQBPK+dvY8KJjwV73m/sapqCC5Nvc5
         F+OeaiZl7Q1CuBQMoli7q4Og+RwhmiUPWXTLNF7LS2XcCxMgHo2cCUeepC2NWuKt9ThI
         K+20hVjBdOn7E6TgXOfM1KOeYo5Hk3msJv9JsEsYoc09KI7A6rzLti4rRlogpXQmw4VM
         Q/r7o8b2Zo5cpOZqLPRnJggpOPnzfbkg5WiJb8NX0Vo9zojjMEy5vKd53G/G77oxxDXf
         CDVw==
X-Gm-Message-State: AOAM5333n6JZfceacOwgbdj60Hrh7tlxqWHkDQ4lJu4/Ulrt2pFkKi/N
        CE5gXHsLR76z5P5P1SoWbD4+BcQ1fBA7CJ9kdHw=
X-Google-Smtp-Source: ABdhPJxhEN2plc4Yh/9TIm+xCOJzk4PJPRvyrvl0I6A0S6/k8HuJrkrEndf1Wx7btA13rXWyT3zEKNb8SHkWZavvgZk=
X-Received: by 2002:a17:902:e88f:b0:141:f982:777 with SMTP id
 w15-20020a170902e88f00b00141f9820777mr5954504plg.68.1639492191458; Tue, 14
 Dec 2021 06:29:51 -0800 (PST)
MIME-Version: 1.0
References: <20211214102647.7734-1-magnus.karlsson@gmail.com> <Ybip7mXZuCXYTlwn@boxer>
In-Reply-To: <Ybip7mXZuCXYTlwn@boxer>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 14 Dec 2021 15:29:40 +0100
Message-ID: <CAJ8uoz1ioNtZyCRG2b3OH4pGh8b2CwHeXKC=M+4Xtf0OouxORw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: add test for tx_writeable to batched path
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 3:28 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Tue, Dec 14, 2021 at 11:26:47AM +0100, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Add a test for the tx_writeable condition to the batched Tx processing
> > path. This test is in the skb and non-batched code paths but not in the
> > batched code path. So add it there. This test makes sure that a
> > process is not woken up until there are a sufficiently large number of
> > free entries in the Tx ring. Currently, any driver using the batched
> > interface will be woken up even if there is only one free entry,
> > impacting performance negatively.
>
> I gave this patch a shot on ice driver with the Tx batching patch that i'm
> about to send which is using the xsk_tx_peek_release_desc_batch(). I ran
> the 2 core setup with no busy poll and it turned out that this change has
> a negative impact on performance - it degrades by 5%.
>
> After a short chat with Magnus he said it's due to the touch to the global
> state of a ring that xsk_tx_writeable() is doing.
>
> So maintainers, please do not apply this yet, we'll come up with a
> solution.
>
> Also, should this be sent to bpf tree (not bpf-next) ?

It is just a performance fix, so I would say bpf-next.

> Thanks!
>
> >
> > Fixes: 3413f04141aa ("xsk: Change the tx writeable condition")
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  net/xdp/xsk.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index 28ef3f4465ae..3772fcaa76ed 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -392,7 +392,8 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *
> >
> >       xskq_cons_release_n(xs->tx, nb_pkts);
> >       __xskq_cons_release(xs->tx);
> > -     xs->sk.sk_write_space(&xs->sk);
> > +     if (xsk_tx_writeable(xs))
> > +             xs->sk.sk_write_space(&xs->sk);
> >
> >  out:
> >       rcu_read_unlock();
> >
> > base-commit: d27a662290963a1cde26cdfdbac71a546c06e94a
> > --
> > 2.29.0
> >
