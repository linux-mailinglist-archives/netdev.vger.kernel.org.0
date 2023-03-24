Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177EE6C7525
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 02:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCXBka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 21:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCXBk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 21:40:29 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30554769F
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 18:40:28 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id cu36so395249vsb.7
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 18:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679622027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y9liUadaUpp2LQeCUq0h4szXksiEx1f6FREIRZOPNRk=;
        b=a9EKfcGjULCDoeM6orIW5bb1MsZTZUEDzko7JcLOYtYLxBFMyVs/sntIpB2i563AD6
         4vyoJ0Jji78khVv02KJlB9DHljhU3GpKTv/RaI9gNrlxJ/YzbXGTFjyupZIWCym1qY0J
         xZ/K5o1PGLs7JqhKsYKY4FKS7eTyCj6yVPYmrnGsF/NamcAW7x0IeBUSUSy9zH62E7O7
         P8M775kS9AaGpojgtiyhrUpZnn3xM9CztkOkLwHvJy9UBprQ7e9JRsWARuiOa0gAwpCv
         YaVvinWE411GxyhZYBxlY6DdJmfEF5ZDzzEgO+ax+VSWTudh1txlCbnXj3Hu/8YKb9dr
         iNOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679622027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y9liUadaUpp2LQeCUq0h4szXksiEx1f6FREIRZOPNRk=;
        b=FFI2cVEOl2l6QLPjTlEZlxNIMc/tnsdQTRhAAPL1cUZavJ/r30JEq1acqWhj4BXZYu
         UiyCD0lC95UOa6aYLKuJAJ5v4wrbzP42MUw6jJGHK23j1SD53b9r0mmb1UyabmNn/LIr
         qW7FTDNH5N4QCZXAbD6rBlxMUZo0N+vauCsAhJflOgQxSWZLhGJ52XrOda3oEZlkS2tE
         IC7sunmHfOudNdG/aUcuEEFO2k2kq8uYRKX3dkEEP7v4IqQ9ea2Qq4Ha81EYWPSjN74c
         qiokp5t8AMPl0m+7TfC9MiTb8xomzvXJ83aSE5eKX6+c4eXhw7XnEr3kL0/LbFuStEyk
         UTig==
X-Gm-Message-State: AAQBX9dbyMeWv55V9Bnp4MoUBgGqCB6LFdu6Pfakzjghs1kmUnfONrlh
        6dYvxhPV8qSOO13IEjgAtdFdx+qDCHs24mCK9zcNQg==
X-Google-Smtp-Source: AKy350YKmKcf9Wr2y1JIMrehMRyptcPFJu7yilkp5Gq2VIozUqIU/NF5cC4JGuiqpp8FbozCCAIepQ8YooKWe7TcmDw=
X-Received: by 2002:a67:a24d:0:b0:426:7bc6:4cb2 with SMTP id
 t13-20020a67a24d000000b004267bc64cb2mr83135vsh.7.1679622026983; Thu, 23 Mar
 2023 18:40:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230323162842.1935061-1-eric.dumazet@gmail.com> <04353d9f-3af0-3d66-6dd8-48c9ef29c132@huawei.com>
In-Reply-To: <04353d9f-3af0-3d66-6dd8-48c9ef29c132@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 23 Mar 2023 18:40:15 -0700
Message-ID: <CANn89iKUFrFx09dCkqtH_eAjEJA9LKkbwackBcU37KAkwNHAEw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next] net: introduce a config option to tweak MAX_SKB_FRAGS
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 6:32=E2=80=AFPM Yunsheng Lin <linyunsheng@huawei.co=
m> wrote:
>
> On 2023/3/24 0:28, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Currently, MAX_SKB_FRAGS value is 17.
> >
> > For standard tcp sendmsg() traffic, no big deal because tcp_sendmsg()
> > attempts order-3 allocations, stuffing 32768 bytes per frag.
> >
> > But with zero copy, we use order-0 pages.
> >
> > For BIG TCP to show its full potential, we add a config option
> > to be able to fit up to 45 segments per skb.
> >
> > This is also needed for BIG TCP rx zerocopy, as zerocopy currently
> > does not support skbs with frag list.
>
> Just out of curiosity, it is possible to add support for skbs with
> frag list for zerocopy if the driver also support transmiting skbs
> with frag list with NETIF_F_FRAGLIST feature on?

We are talking of rx zerocopy, look at net/ipv4/tcp.c (this is not
tied to NETIF_F_FRAGLIST support
because packets land into a TCP receive queue)

>
> >
> > We have used MAX_SKB_FRAGS=3D45 value for years at Google before
> > we deployed 4K MTU, with no adverse effect, other than
> > a recent issue in mlx4, fixed in commit 26782aad00cc
> > ("net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends on MAX_SKB_FRAGS")
> >
> > Back then, goal was to be able to receive full size (64KB) GRO
> > packets without the frag_list overhead.
> >
> > Note that /proc/sys/net/core/max_skb_frags can also be used to limit
> > the number of fragments TCP can use in tx packets.
> >
> > By default we keep the old/legacy value of 17 until we get
> > more coverage for the updated values.
> >
> > Sizes of struct skb_shared_info on 64bit arches
> >
> > MAX_SKB_FRAGS | sizeof(struct skb_shared_info):
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >          17     320
> >          21     320+64  =3D 384
> >          25     320+128 =3D 448
> >          29     320+192 =3D 512
> >          33     320+256 =3D 576
> >          37     320+320 =3D 640
> >          41     320+384 =3D 704
> >          45     320+448 =3D 768
> >
> > This inflation might cause problems for drivers assuming they could pac=
k
> > both the incoming packet (for MTU=3D1500) and skb_shared_info in half a=
 page,
> > using build_skb().
> >
> > v3: fix build error when CONFIG_NET=3Dn
> > v2: fix two build errors assuming MAX_SKB_FRAGS was "unsigned long"
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
> > ---
> >  drivers/scsi/cxgbi/libcxgbi.c |  4 ++--
> >  include/linux/skbuff.h        | 16 +++++-----------
> >  net/Kconfig                   | 12 ++++++++++++
> >  net/packet/af_packet.c        |  4 ++--
> >  4 files changed, 21 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgb=
i.c
> > index af281e271f886041b397ea881e2ce7be00eff625..3e1de4c842cc6102e25a597=
2d6b11e05c3e4c060 100644
> > --- a/drivers/scsi/cxgbi/libcxgbi.c
> > +++ b/drivers/scsi/cxgbi/libcxgbi.c
> > @@ -2314,9 +2314,9 @@ static int cxgbi_sock_tx_queue_up(struct cxgbi_so=
ck *csk, struct sk_buff *skb)
> >               frags++;
> >
> >       if (frags >=3D SKB_WR_LIST_SIZE) {
> > -             pr_err("csk 0x%p, frags %u, %u,%u >%lu.\n",
> > +             pr_err("csk 0x%p, frags %u, %u,%u >%u.\n",
> >                      csk, skb_shinfo(skb)->nr_frags, skb->len,
> > -                    skb->data_len, SKB_WR_LIST_SIZE);
> > +                    skb->data_len, (unsigned int)SKB_WR_LIST_SIZE);
> >               return -EINVAL;
> >       }
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index fe661011644b8f468ff5e92075a6624f0557584c..82511b2f61ea2bc5d587b58=
f0901e50e64729e4f 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -345,18 +345,12 @@ struct sk_buff_head {
> >
> >  struct sk_buff;
> >
> > -/* To allow 64K frame to be packed as single skb without frag_list we
> > - * require 64K/PAGE_SIZE pages plus 1 additional page to allow for
> > - * buffers which do not start on a page boundary.
> > - *
> > - * Since GRO uses frags we allocate at least 16 regardless of page
> > - * size.
> > - */
> > -#if (65536/PAGE_SIZE + 1) < 16
> > -#define MAX_SKB_FRAGS 16UL
> > -#else
> > -#define MAX_SKB_FRAGS (65536/PAGE_SIZE + 1)
> > +#ifndef CONFIG_MAX_SKB_FRAGS
> > +# define CONFIG_MAX_SKB_FRAGS 17
>
> There seems to be an extra space before 'define'.

This is indentation. Pretty standard I would say.

#if xxxxx
# define ....
#else
# define ....
#endif


>
> Also, is there a reason why not to keep below old logic
> if CONFIG_MAX_SKB_FRAGS is not defined?
>
> #if (65536/PAGE_SIZE + 1) < 16
> #define MAX_SKB_FRAGS 16UL
> #else
> #define MAX_SKB_FRAGS (65536/PAGE_SIZE + 1)
> #endif
>
> It seems with old logic:
> 1. for kernel with 4K page size, MAX_SKB_FRAGS is 17.
> 2. for kernel with 64K page size, MAX_SKB_FRAGS is 16.

This is for CONFIG_NET=3Dn configs.

I am pretty sure nobody would care about having 17 or 16 frags per skb
for such a silly config.

Let's not confuse readers.

>
> >  #endif
> > +
> > +#define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
> > +
> >  extern int sysctl_max_skb_frags;
> >
> >  /* Set skb_shinfo(skb)->gso_size to this in case you want skb_segment =
to
> > diff --git a/net/Kconfig b/net/Kconfig
> > index 48c33c2221999e575c83a409ab773b9cc3656eab..f806722bccf450c62e07bfd=
b245e5195ac4a156d 100644
> > --- a/net/Kconfig
> > +++ b/net/Kconfig
> > @@ -251,6 +251,18 @@ config PCPU_DEV_REFCNT
> >         network device refcount are using per cpu variables if this opt=
ion is set.
> >         This can be forced to N to detect underflows (with a performanc=
e drop).
> >
> > +config MAX_SKB_FRAGS
> > +     int "Maximum number of fragments per skb_shared_info"
> > +     range 17 45
> > +     default 17
> > +     help
> > +       Having more fragments per skb_shared_info can help GRO efficien=
cy.
> > +       This helps BIG TCP workloads, but might expose bugs in some
> > +       legacy drivers.
> > +       This also increases memory overhead of small packets,
> > +       and in drivers using build_skb().
> > +       If unsure, say 17.
> > +
> >  config RPS
> >       bool
> >       depends on SMP && SYSFS
> > diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> > index 497193f73030c385a2d33b71dfbc299fbf9b763d..568f8d76e3c124f3b322a8d=
88dc3dcfbc45e7c0e 100644
> > --- a/net/packet/af_packet.c
> > +++ b/net/packet/af_packet.c
> > @@ -2622,8 +2622,8 @@ static int tpacket_fill_skb(struct packet_sock *p=
o, struct sk_buff *skb,
> >               nr_frags =3D skb_shinfo(skb)->nr_frags;
> >
> >               if (unlikely(nr_frags >=3D MAX_SKB_FRAGS)) {
> > -                     pr_err("Packet exceed the number of skb frags(%lu=
)\n",
> > -                            MAX_SKB_FRAGS);
> > +                     pr_err("Packet exceed the number of skb frags(%u)=
\n",
> > +                            (unsigned int)MAX_SKB_FRAGS);
> >                       return -EFAULT;
> >               }
> >
> >
