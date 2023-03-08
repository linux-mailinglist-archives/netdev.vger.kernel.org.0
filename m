Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AEE6AFCC9
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 03:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjCHCNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 21:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjCHCNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 21:13:34 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0869FE40;
        Tue,  7 Mar 2023 18:13:29 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id o12so60068904edb.9;
        Tue, 07 Mar 2023 18:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678241608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uDmqpI3iGfWF0L8Eququv4XMsNLZbjQlVIecq8LOf4Y=;
        b=HZxOwbW1wMRACfPkH0edExpU8AU3Xxo5TVuETh8nHWzzMm5JeTq9T0sfrvqwBUyxoC
         wpgWrE4IvTpL0CIsSU24m8PFNEv0gx9JkgO2IxpjjyrT37g8lp0jmC1o76JfOMmFLjpH
         BCy6Blu+yMjbjsflrfiO7f/Gmo061ckCYg9t6K9VyjI7ro0JpZLIWZLYSJO82Pq4mbPZ
         Va9fDU0YDQX1kjo54drvVVrK2LsbsdFedCVgATjZpHDMEh6W8BqLHXqpdc5lQYGe1tCC
         8Rg9M/fDIsA6+HvcXg7TBEnDSnYU7Bya1RL8gk70MzBOcAhk+Sy8wniA32Uw0Ln8H8S/
         8GKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678241608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uDmqpI3iGfWF0L8Eququv4XMsNLZbjQlVIecq8LOf4Y=;
        b=oQgEcyRP2jWdAVxKW/1SUBypVd0eUWwiQPXkM1kofwgMGrd7LMHQqnOIy2Wy1zSJfq
         3bYotDawDZiSA3+K/R0ozykMz3Q9ueWYZgsF9iqy2Q13uMLBPelrGcdfZ1gW1uQmvUP4
         emtfUPVNRa82EtJzHodarF093ZO8dRc4FCmmi/CZ07R2LVH+v7GN0VQ1ILXVlXiT3VPF
         Ivvvrim+OHW5GOGmQqDEj/LDPHYmFyWZ0K7q5PnVIneeaL2GiGookyvi0O63+RExCPUQ
         JlKiPgm8gXzvH9xhmadZCUAOlHOLl5VR+gzCU2ciTP8ZDjEthDj0BP6I0vdbiLgqIPi0
         U+TA==
X-Gm-Message-State: AO0yUKWGlEI+QycEzHcZD0eH7Ndk4XZoNfRVL3L99kmjUVt1/eeTubhN
        eAZcy6i2uWxNXJQYKDuDTenGTjPtOHbN8PqsW6E=
X-Google-Smtp-Source: AK7set+z/zraB9ppbT/i0abXK22k8L7sj7F0zNcwkSfcGkUZ+UuNb33Lv6N3tHlZ1DHmgT22Bwdp0RFFPBWzaPpZOO8=
X-Received: by 2002:a50:8e5d:0:b0:4c8:1fda:52fd with SMTP id
 29-20020a508e5d000000b004c81fda52fdmr9293564edx.8.1678241608035; Tue, 07 Mar
 2023 18:13:28 -0800 (PST)
MIME-Version: 1.0
References: <20230307015620.18301-1-kerneljasonxing@gmail.com> <2ad119bd1f24f408921b16eb0ebdf67935d1d880.camel@redhat.com>
In-Reply-To: <2ad119bd1f24f408921b16eb0ebdf67935d1d880.camel@redhat.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 8 Mar 2023 10:12:51 +0800
Message-ID: <CAL+tcoAejCA8jX_y+DmgcMKFMoY_1cM6+-EuT7r0QMO-5kn+dw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next] udp: introduce __sk_mem_schedule() usage
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     simon.horman@corigine.com, willemdebruijn.kernel@gmail.com,
        davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 10:55=E2=80=AFPM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On Tue, 2023-03-07 at 09:56 +0800, Jason Xing wrote:
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > Keep the accounting schema consistent across different protocols
> > with __sk_mem_schedule(). Besides, it adjusts a little bit on how
> > to calculate forward allocated memory compared to before. After
> > applied this patch, we could avoid receive path scheduling extra
> > amount of memory.
> >
> > Link: https://lore.kernel.org/lkml/20230221110344.82818-1-kerneljasonxi=
ng@gmail.com/
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> > v3:
> > 1) get rid of inline suggested by Simon Horman
> >
> > v2:
> > 1) change the title and body message
> > 2) use __sk_mem_schedule() instead suggested by Paolo Abeni
> > ---
> >  net/ipv4/udp.c | 31 ++++++++++++++++++-------------
> >  1 file changed, 18 insertions(+), 13 deletions(-)
> >
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index c605d171eb2d..60473781933c 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -1531,10 +1531,23 @@ static void busylock_release(spinlock_t *busy)
> >               spin_unlock(busy);
> >  }
> >
> > +static int udp_rmem_schedule(struct sock *sk, int size)
> > +{
> > +     int delta;
> > +
> > +     delta =3D size - sk->sk_forward_alloc;
> > +     if (delta > 0 && !__sk_mem_schedule(sk, delta, SK_MEM_RECV))
> > +             return -ENOBUFS;
> > +
> > +     sk->sk_forward_alloc -=3D size;
>
> I think it's better if you maintain the above statement outside of this
> helper: it's a bit confusing that rmem_schedule() actually consumes fwd
> memory.

It does make sense.

Thanks,
Jason

>
> Side note
>
> Cheers,
>
> Paolo
>
