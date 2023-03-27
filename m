Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3736C9BD4
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbjC0HSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbjC0HSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:18:52 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64142E3
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 00:18:51 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y4so31813205edo.2
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 00:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679901530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4SOSbXEG0Fb8pnEs/7/5qiU06ISWs1hPe5OU5AVsCog=;
        b=dJUHNGuG7+9bYEe82YFlMNKISTM99BEW2WR4PIRigO/ZMJN6h1/nfh8Wud+qR3mW04
         dO3kszGvyLSitIkFZbmXmGvlGxHObsuq3wrEAmRDesUcCf6wHmQ4551DUyFP5g+wx5Am
         acq4oMnToV3h0KjvfSNok4nFLDwCsecyK+ioapI0pEZFjExcMBCiNg/F+P786+h5XyxK
         TQzNXcr1TvUjiGVtGDLlw6lk+Jt/1LpxtAWHr6/hzqMtXBvP0LN44JJaJPXjAs7Qe9+a
         BkszWgWdXQVWOotiefMsrnzMoEvvNu+xAccO6caYCxWSwykUVKWzI3hVVoWraBhf2NCH
         37TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679901530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4SOSbXEG0Fb8pnEs/7/5qiU06ISWs1hPe5OU5AVsCog=;
        b=tLrhHcJxClPJhcn7mB+XAcX6Af95+LvEbKWDkYKU09tdy3BURZvTZ2PIFkXgpnkUkJ
         Y4G0YxEsuQAyCWsbHVF6gwG1YIwCF0ct9DUl3ZFCbohi34HNhSHYNNwgH1mANF3JJdhK
         zXzBDYVDy3DzSvXVK9yMnfVCjpgLKxQSi95wU7ykNFcYW8I5HN/HX91Kemc/WIRoO/7q
         9ZgN+d3mBMz2wSRDMIseGGNsxVZwpGqWqIL6SZ3nM0H91OtB3TUlX7T+Kq4AK6oVvhz+
         2uNOlJzHLZ7OQjbfj1cbL1Neyk+xo5RExeV4bLBcLtiimcf4Q6JZdmi2/S1f2EEJyarG
         6kJA==
X-Gm-Message-State: AAQBX9e2d8el6huA+CAgNXR9Aat615OzB3wErfdQacEoKep9yN769oWi
        k8nHNeBdTfUGgfZH9GfRDLy2Wr29p7bNpVAY69s=
X-Google-Smtp-Source: AKy350Y3LS+19lwP/iuz2NDAoOYr1IUqLiYZ+w801Nw7dMsjPLEhN1tNikqPnT0zrw+z4qScCxggQKpw9JPZQ3R/gBQ=
X-Received: by 2002:a17:906:7051:b0:8db:b5c1:7203 with SMTP id
 r17-20020a170906705100b008dbb5c17203mr5253729ejj.11.1679901529603; Mon, 27
 Mar 2023 00:18:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230323162842.1935061-1-eric.dumazet@gmail.com>
In-Reply-To: <20230323162842.1935061-1-eric.dumazet@gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Mon, 27 Mar 2023 15:18:13 +0800
Message-ID: <CAL+tcoBBQT9xdG_NnWoLRAXBH0e2DbAErsM8ubaiByKH41xqqg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next] net: introduce a config option to tweak MAX_SKB_FRAGS
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 12:35=E2=80=AFAM Eric Dumazet <eric.dumazet@gmail.c=
om> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Currently, MAX_SKB_FRAGS value is 17.
>
> For standard tcp sendmsg() traffic, no big deal because tcp_sendmsg()
> attempts order-3 allocations, stuffing 32768 bytes per frag.
>
> But with zero copy, we use order-0 pages.
>
> For BIG TCP to show its full potential, we add a config option
> to be able to fit up to 45 segments per skb.
>
> This is also needed for BIG TCP rx zerocopy, as zerocopy currently
> does not support skbs with frag list.
>
> We have used MAX_SKB_FRAGS=3D45 value for years at Google before
> we deployed 4K MTU, with no adverse effect, other than
> a recent issue in mlx4, fixed in commit 26782aad00cc
> ("net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends on MAX_SKB_FRAGS")
>
> Back then, goal was to be able to receive full size (64KB) GRO
> packets without the frag_list overhead.
>
> Note that /proc/sys/net/core/max_skb_frags can also be used to limit
> the number of fragments TCP can use in tx packets.
>
> By default we keep the old/legacy value of 17 until we get
> more coverage for the updated values.
>
> Sizes of struct skb_shared_info on 64bit arches
>
> MAX_SKB_FRAGS | sizeof(struct skb_shared_info):
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>          17     320
>          21     320+64  =3D 384
>          25     320+128 =3D 448
>          29     320+192 =3D 512
>          33     320+256 =3D 576
>          37     320+320 =3D 640
>          41     320+384 =3D 704
>          45     320+448 =3D 768
>
> This inflation might cause problems for drivers assuming they could pack
> both the incoming packet (for MTU=3D1500) and skb_shared_info in half a p=
age,
> using build_skb().
>
> v3: fix build error when CONFIG_NET=3Dn
> v2: fix two build errors assuming MAX_SKB_FRAGS was "unsigned long"
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

The patch itself looks good. Please feel free to add:

Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>

Thanks:)

> ---
>  drivers/scsi/cxgbi/libcxgbi.c |  4 ++--
>  include/linux/skbuff.h        | 16 +++++-----------
>  net/Kconfig                   | 12 ++++++++++++
>  net/packet/af_packet.c        |  4 ++--
>  4 files changed, 21 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.=
c
> index af281e271f886041b397ea881e2ce7be00eff625..3e1de4c842cc6102e25a5972d=
6b11e05c3e4c060 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -2314,9 +2314,9 @@ static int cxgbi_sock_tx_queue_up(struct cxgbi_sock=
 *csk, struct sk_buff *skb)
>                 frags++;
>
>         if (frags >=3D SKB_WR_LIST_SIZE) {
> -               pr_err("csk 0x%p, frags %u, %u,%u >%lu.\n",
> +               pr_err("csk 0x%p, frags %u, %u,%u >%u.\n",
>                        csk, skb_shinfo(skb)->nr_frags, skb->len,
> -                      skb->data_len, SKB_WR_LIST_SIZE);
> +                      skb->data_len, (unsigned int)SKB_WR_LIST_SIZE);
>                 return -EINVAL;
>         }
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index fe661011644b8f468ff5e92075a6624f0557584c..82511b2f61ea2bc5d587b58f0=
901e50e64729e4f 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -345,18 +345,12 @@ struct sk_buff_head {
>
>  struct sk_buff;
>
> -/* To allow 64K frame to be packed as single skb without frag_list we
> - * require 64K/PAGE_SIZE pages plus 1 additional page to allow for
> - * buffers which do not start on a page boundary.
> - *
> - * Since GRO uses frags we allocate at least 16 regardless of page
> - * size.
> - */
> -#if (65536/PAGE_SIZE + 1) < 16
> -#define MAX_SKB_FRAGS 16UL
> -#else
> -#define MAX_SKB_FRAGS (65536/PAGE_SIZE + 1)
> +#ifndef CONFIG_MAX_SKB_FRAGS
> +# define CONFIG_MAX_SKB_FRAGS 17
>  #endif
> +
> +#define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
> +
>  extern int sysctl_max_skb_frags;
>
>  /* Set skb_shinfo(skb)->gso_size to this in case you want skb_segment to
> diff --git a/net/Kconfig b/net/Kconfig
> index 48c33c2221999e575c83a409ab773b9cc3656eab..f806722bccf450c62e07bfdb2=
45e5195ac4a156d 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -251,6 +251,18 @@ config PCPU_DEV_REFCNT
>           network device refcount are using per cpu variables if this opt=
ion is set.
>           This can be forced to N to detect underflows (with a performanc=
e drop).
>
> +config MAX_SKB_FRAGS
> +       int "Maximum number of fragments per skb_shared_info"
> +       range 17 45
> +       default 17
> +       help
> +         Having more fragments per skb_shared_info can help GRO efficien=
cy.
> +         This helps BIG TCP workloads, but might expose bugs in some
> +         legacy drivers.
> +         This also increases memory overhead of small packets,
> +         and in drivers using build_skb().
> +         If unsure, say 17.
> +
>  config RPS
>         bool
>         depends on SMP && SYSFS
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 497193f73030c385a2d33b71dfbc299fbf9b763d..568f8d76e3c124f3b322a8d88=
dc3dcfbc45e7c0e 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -2622,8 +2622,8 @@ static int tpacket_fill_skb(struct packet_sock *po,=
 struct sk_buff *skb,
>                 nr_frags =3D skb_shinfo(skb)->nr_frags;
>
>                 if (unlikely(nr_frags >=3D MAX_SKB_FRAGS)) {
> -                       pr_err("Packet exceed the number of skb frags(%lu=
)\n",
> -                              MAX_SKB_FRAGS);
> +                       pr_err("Packet exceed the number of skb frags(%u)=
\n",
> +                              (unsigned int)MAX_SKB_FRAGS);
>                         return -EFAULT;
>                 }
>
> --
> 2.40.0.rc1.284.g88254d51c5-goog
>
