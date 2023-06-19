Return-Path: <netdev+bounces-11840-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2007A734C36
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:17:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42FD31C20956
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 07:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A5534C9F;
	Mon, 19 Jun 2023 07:15:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C68A882B;
	Mon, 19 Jun 2023 07:15:40 +0000 (UTC)
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDFC1A8;
	Mon, 19 Jun 2023 00:15:39 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id 6a1803df08f44-5e5b5da22b8so7159926d6.0;
        Mon, 19 Jun 2023 00:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687158938; x=1689750938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q+/8qVGQjVqHW+KEwqLOGYUXfYVcQ4v9V0W7eVIJCrI=;
        b=mk9qYz2MRzUnP17L1LYUNf3bhh+BDcjAtIYrOanoIDKpNk2j+DeLXCzXfCtLhFCe0h
         Ar+6fC1fwDLfVe5ZhmK3u174vTtOX/u7xpgb2tsGm8uu3Na9NpSS/hfF7n7vt/yQWsxR
         ZZfMk2HHlzwzAK3l5bKBzZCNDzgrzqZpDNmy4+ZxIWyyaJPXRLYgga6rSyNM7bna4/uo
         E2WODFJqq6Gv0BkS+Pl4lcUIHb+qdaE3VGXUBz3lj6k+uPPbBGo8F6d49Ctk/CcsysF5
         DOROCWQSaFO7sKP6SC05+4apIw1PBqHiu/1PNbaTHUnJbFuWc0yLKFPr1y+fXiELtSUK
         thbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687158938; x=1689750938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q+/8qVGQjVqHW+KEwqLOGYUXfYVcQ4v9V0W7eVIJCrI=;
        b=S9jSxkTQN2a+NkngZuAY+MhAQP6A88aXQBtInhZ98ucZPecL24YtXzw53Ntv25yOaN
         z6IP1+jY7PMbRC8jD5USC2h3BmZjCIM5JrX/PRwmYouIBLvxiDabphC6If5nFFyac6Wu
         rYPQcSJUBkk5zlpITnGgOLRN2qD3tGNuxsXMJNigOALCldBdQBR3YwTN+yPhEVHMpoiT
         nwTipwNeLyo4+stUElcevH3cEfldD/dqepEd5h4Mh0sWPn5wOugqrzJDD2oGuwAwezTK
         GYNZnUT/1iVS2TW2Ty7MAE6Nad28y++8DbSTpXep0TJ5O5c5oLgBjKMGkXUkLyuz3KAx
         aGxg==
X-Gm-Message-State: AC+VfDz/56xbmVAhn6GwPLbd9rAK12ipCj/PA1UPTW5ijAyVvILVyO5n
	TMcop3P1Oksvn5vUHy3Bxf2Tj0l/0RDeehxLPbM=
X-Google-Smtp-Source: ACHHUZ6AcbWaaDofNjvqNiLuNDEUSAVp9lKL+uwjJglq54/CwJheT5Qj3XLtDR+1PwUFM8fY+OjYeAbygHiXth2s/ng=
X-Received: by 2002:ad4:5b8a:0:b0:62f:e4de:5bed with SMTP id
 10-20020ad45b8a000000b0062fe4de5bedmr11022014qvp.5.1687158938194; Mon, 19 Jun
 2023 00:15:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <87cz20xunt.fsf@toke.dk>
 <CAKH8qBuAUems8a7kKJPcFvarW2jy4qTf4sAM8oUC8UHj-gE=ug@mail.gmail.com>
 <CAJ8uoz2Bx3cd7braAZjZFNYfqX0JjJzSvr4RBN=j8CiH8Ld5-w@mail.gmail.com>
 <CAKH8qBscx=SWSCL_WTMPyNPu=63OzFJcenCySds2KoV1agWW9w@mail.gmail.com> <ZIzr5ffeHsUqppaS@google.com>
In-Reply-To: <ZIzr5ffeHsUqppaS@google.com>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Mon, 19 Jun 2023 09:15:27 +0200
Message-ID: <CAJ8uoz2zOHpBRfKhN97eR0VWipBTxnh=R9G57Z2UUujX4JzneQ@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
To: Stanislav Fomichev <sdf@google.com>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>, 
	bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, 
	kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org, willemb@google.com, 
	dsahern@kernel.org, magnus.karlsson@intel.com, bjorn@kernel.org, 
	maciej.fijalkowski@intel.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, 17 Jun 2023 at 01:10, Stanislav Fomichev <sdf@google.com> wrote:
>
> On 06/16, Stanislav Fomichev wrote:
> > On Fri, Jun 16, 2023 at 1:13=E2=80=AFAM Magnus Karlsson
> > <magnus.karlsson@gmail.com> wrote:
> > >
> > > On Fri, 16 Jun 2023 at 02:09, Stanislav Fomichev <sdf@google.com> wro=
te:
> > > >
> > > > On Mon, Jun 12, 2023 at 2:01=E2=80=AFPM Toke H=C3=B8iland-J=C3=B8rg=
ensen <toke@kernel.org> wrote:
> > > > >
> > > > > Some immediate thoughts after glancing through this:
> > > > >
> > > > > > --- Use cases ---
> > > > > >
> > > > > > The goal of this series is to add two new standard-ish places
> > > > > > in the transmit path:
> > > > > >
> > > > > > 1. Right before the packet is transmitted (with access to TX
> > > > > >    descriptors)
> > > > > > 2. Right after the packet is actually transmitted and we've rec=
eived the
> > > > > >    completion (again, with access to TX completion descriptors)
> > > > > >
> > > > > > Accessing TX descriptors unlocks the following use-cases:
> > > > > >
> > > > > > - Setting device hints at TX: XDP/AF_XDP might use these new ho=
oks to
> > > > > > use device offloads. The existing case implements TX timestamp.
> > > > > > - Observability: global per-netdev hooks can be used for tracin=
g
> > > > > > the packets and exploring completion descriptors for all sorts =
of
> > > > > > device errors.
> > > > > >
> > > > > > Accessing TX descriptors also means that the hooks have to be c=
alled
> > > > > > from the drivers.
> > > > > >
> > > > > > The hooks are a light-weight alternative to XDP at egress and c=
urrently
> > > > > > don't provide any packet modification abilities. However, event=
ually,
> > > > > > can expose new kfuncs to operate on the packet (or, rather, the=
 actual
> > > > > > descriptors; for performance sake).
> > > > >
> > > > > dynptr?
> > > > >
> > > > > > --- UAPI ---
> > > > > >
> > > > > > The hooks are implemented in a HID-BPF style. Meaning they don'=
t
> > > > > > expose any UAPI and are implemented as tracing programs that ca=
ll
> > > > > > a bunch of kfuncs. The attach/detach operation happen via BPF s=
yscall
> > > > > > programs. The series expands device-bound infrastructure to tra=
cing
> > > > > > programs.
> > > > >
> > > > > Not a fan of the "attach from BPF syscall program" thing. These a=
re part
> > > > > of the XDP data path API, and I think we should expose them as pr=
oper
> > > > > bpf_link attachments from userspace with introspection etc. But I=
 guess
> > > > > the bpf_mprog thing will give us that?
> > > > >
> > > > > > --- skb vs xdp ---
> > > > > >
> > > > > > The hooks operate on a new light-weight devtx_frame which conta=
ins:
> > > > > > - data
> > > > > > - len
> > > > > > - sinfo
> > > > > >
> > > > > > This should allow us to have a unified (from BPF POW) place at =
TX
> > > > > > and not be super-taxing (we need to copy 2 pointers + len to th=
e stack
> > > > > > for each invocation).
> > > > >
> > > > > Not sure what I think about this one. At the very least I think w=
e
> > > > > should expose xdp->data_meta as well. I'm not sure what the use c=
ase for
> > > > > accessing skbs is? If that *is* indeed useful, probably there wil=
l also
> > > > > end up being a use case for accessing the full skb?
> > > >
> > > > I spent some time looking at data_meta story on AF_XDP TX and it
> > > > doesn't look like it's supported (at least in a general way).
> > > > You obviously get some data_meta when you do XDP_TX, but if you wan=
t
> > > > to pass something to the bpf prog when doing TX via the AF_XDP ring=
,
> > > > it gets complicated.
> > >
> > > When we designed this some 5 - 6 years ago, we thought that there
> > > would be an XDP for egress action in the "nearish" future that could
> > > be used to interpret the metadata field in front of the packet.
> > > Basically, the user would load an XDP egress program that would defin=
e
> > > the metadata layout by the operations it would perform on the metadat=
a
> > > area. But since XDP on egress has not happened, you are right, there
> > > is definitely something missing to be able to use metadata on Tx. Or
> > > could your proposed hook points be used for something like this?
> >
> > Thanks for the context!
> > Yes, the proposal is to use these new tx hooks to read out af_xdp
> > metadata and apply it to the packet via a bunch of tbd kfuncs.
> > AF_XDP and BPF programs would have to have a contract about the
> > metadata layout (same as we have on rx).
> >
> > > > In zerocopy mode, we can probably use XDP_UMEM_UNALIGNED_CHUNK_FLAG
> > > > and pass something in the headroom.
> > >
> > > This feature is mainly used to allow for multiple packets on the same
> > > chunk (to save space) and also to be able to have packets spanning tw=
o
> > > chunks. Even in aligned mode, you can start a packet at an arbitrary
> > > address in the chunk as long as the whole packet fits into the chunk.
> > > So no problem having headroom in any of the modes.
> >
> > But if I put it into the headroom it will only be passed down to the
> > driver in zero-copy mode, right?
> > If I do tx_desc->addr =3D packet_start, no medata (that goes prior to
> > packet_start) gets copied into skb in the copy mode (it seems).
> > Or do you suggest that the interface should be tx_desc->addr =3D
> > metadata_start and the bpf program should call the equivalent of
> > bpf_xdp_adjust_head to consume this metadata?
>
> For copy-mode, here is what I've prototyped. That seems to work.
> For zero-copy, I don't think we need anything extra (besides exposing
> xsk->tx_meta_len at the hook point, tbd). Does the patch below make
> sense?

Was just going to suggest adding a setsockopt, so this makes perfect
sense to me. Thanks!

> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index e96a1151ec75..30018b3b862d 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -51,6 +51,7 @@ struct xdp_sock {
>         struct list_head flush_node;
>         struct xsk_buff_pool *pool;
>         u16 queue_id;
> +       u8 tx_metadata_len;
>         bool zc;
>         enum {
>                 XSK_READY =3D 0,
> diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> index a78a8096f4ce..2374eafff7db 100644
> --- a/include/uapi/linux/if_xdp.h
> +++ b/include/uapi/linux/if_xdp.h
> @@ -63,6 +63,7 @@ struct xdp_mmap_offsets {
>  #define XDP_UMEM_COMPLETION_RING       6
>  #define XDP_STATISTICS                 7
>  #define XDP_OPTIONS                    8
> +#define XDP_TX_METADATA_LEN            9
>
>  struct xdp_umem_reg {
>         __u64 addr; /* Start of packet data area */
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index cc1e7f15fa73..a95872712547 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -493,14 +493,21 @@ static struct sk_buff *xsk_build_skb(struct xdp_soc=
k *xs,
>                         return ERR_PTR(err);
>
>                 skb_reserve(skb, hr);
> -               skb_put(skb, len);
> +               skb_put(skb, len + xs->tx_metadata_len);
>
>                 buffer =3D xsk_buff_raw_get_data(xs->pool, desc->addr);
> +               buffer -=3D xs->tx_metadata_len;
> +
>                 err =3D skb_store_bits(skb, 0, buffer, len);
>                 if (unlikely(err)) {
>                         kfree_skb(skb);
>                         return ERR_PTR(err);
>                 }
> +
> +               if (xs->tx_metadata_len) {
> +                       skb_metadata_set(skb, xs->tx_metadata_len);
> +                       __skb_pull(skb, xs->tx_metadata_len);
> +               }
>         }
>
>         skb->dev =3D dev;
> @@ -1137,6 +1144,27 @@ static int xsk_setsockopt(struct socket *sock, int=
 level, int optname,
>                 mutex_unlock(&xs->mutex);
>                 return err;
>         }
> +       case XDP_TX_METADATA_LEN:
> +       {
> +               int val;
> +
> +               if (optlen < sizeof(val))
> +                       return -EINVAL;
> +               if (copy_from_sockptr(&val, optval, sizeof(val)))
> +                       return -EFAULT;
> +
> +               if (val >=3D 256)
> +                       return -EINVAL;
> +
> +               mutex_lock(&xs->mutex);
> +               if (xs->state !=3D XSK_READY) {
> +                       mutex_unlock(&xs->mutex);
> +                       return -EBUSY;
> +               }
> +               xs->tx_metadata_len =3D val;
> +               mutex_unlock(&xs->mutex);
> +               return err;
> +       }
>         default:
>                 break;
>         }

