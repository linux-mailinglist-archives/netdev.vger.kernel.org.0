Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C451645560
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 09:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiLGIXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 03:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiLGIXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 03:23:38 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9FF25EA5;
        Wed,  7 Dec 2022 00:23:36 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id n21so12119799ejb.9;
        Wed, 07 Dec 2022 00:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1WGjEJwm3dqx8XsjIfiElv6H7t2zrb2ZfkTtnHZN3Ic=;
        b=WB35YW7+zReBscyKvhxPvnkde2WZ0r40O4cYUkRcLaDHb/WzmDOejw9PbQubSt/IAs
         7IYdIqebi/Q775bY81uKA31RLYQIJ3po0DLhN3BCfOgtLKPP+f+bfSw8G+82IXfCI+rV
         Ak56sZkoMwDz8A8VhiL8gA9YvJx6lfR+481ckqRW+PiDnxooK4Zp1CqtvwkAg/bLMTu2
         So/pw7ErajGqL593rEoOBZ4+HeLY3Sr5YIXjNY/FeKSdLlKSaSCt53FCSEhfu36kQtBw
         2SrJ4Pt1Zh5tPHExOniA/xWojdfunTl4XAhT9qaB1GKnPX9fOPujQEk2QRmsvef1Swui
         wtTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1WGjEJwm3dqx8XsjIfiElv6H7t2zrb2ZfkTtnHZN3Ic=;
        b=EihWpVWE0nGkumqV7u38TrQAn5uFeKTejZdEZIuAorBJvs6KfGBqdphUwMkp8CVdg8
         5rUo8sCyJ9KQWfiwUoSv/NsYSqkxwHEbBlAMLFfHxmy1oM60ZdF7nUocjVY/rNLhVepc
         Emn2p25Q9sShZRJ/yElms1uEOOR/Y84zSdjDHD6RiwtYU42pm7v0+QqjYsGgEfxotBLh
         Pb4vSnhMWpbGMWRpY9spxJqQHOLVYiJbs36xGM9591AAnIPMYmIt+BNAFiKLfs+EKWZv
         oNO3A+9WWFfH1LSGP6GjrE8buVKqPo5292vnZfvuUu5m2Lq9aBFZ3jfiCWDhClcsm++7
         Wa5g==
X-Gm-Message-State: ANoB5pkOLh27WTq0FJLsWR4D1E0+n88uv7qzJgqV2Vyioj4MCKJw4Wio
        qn46c69kNgqxfiBsVfhQthhdYng58recDaThOco=
X-Google-Smtp-Source: AA0mqf78s91SIU3ZOFCaTqNG5YIgu6ZyJRasY5vtX8X1yjWD4TcUsy5pIkjAEuPvwpqu27O7YBeoMUyQlGBJoVS1GTM=
X-Received: by 2002:a17:907:9d04:b0:7c1:1342:61b7 with SMTP id
 kt4-20020a1709079d0400b007c1134261b7mr3903917ejc.524.1670401414979; Wed, 07
 Dec 2022 00:23:34 -0800 (PST)
MIME-Version: 1.0
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
 <20221206090826.2957-8-magnus.karlsson@gmail.com> <3489505c-3e33-880e-6f19-1796ca897553@iogearbox.net>
In-Reply-To: <3489505c-3e33-880e-6f19-1796ca897553@iogearbox.net>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 7 Dec 2022 09:23:22 +0100
Message-ID: <CAJ8uoz0=nbs+rgU5kNi161=D5QU+oH383kieZOguBuTsivJYXQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 07/15] selftests/xsk: get rid of asm
 store/release implementations
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 12:48 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 12/6/22 10:08 AM, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Get rid of our own homegrown assembly store/release and load/acquire
> > implementations. Use the HW agnositic APIs the compiler offers
> > instead.
>
> The description is a bit terse. Could you add a bit more context, discussion
> or reference on why it's safe to replace them with C11 atomics?

Will do, though I will hold off on a v2 in case there are further comments.

> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >   tools/testing/selftests/bpf/xsk.h | 80 ++-----------------------------
> >   1 file changed, 4 insertions(+), 76 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/xsk.h b/tools/testing/selftests/bpf/xsk.h
> > index 997723b0bfb2..24ee765aded3 100644
> > --- a/tools/testing/selftests/bpf/xsk.h
> > +++ b/tools/testing/selftests/bpf/xsk.h
> > @@ -23,77 +23,6 @@
> >   extern "C" {
> >   #endif
> >
> > -/* This whole API has been deprecated and moved to libxdp that can be found at
> > - * https://github.com/xdp-project/xdp-tools. The APIs are exactly the same so
> > - * it should just be linking with libxdp instead of libbpf for this set of
> > - * functionality. If not, please submit a bug report on the aforementioned page.
> > - */
> > -
> > -/* Load-Acquire Store-Release barriers used by the XDP socket
> > - * library. The following macros should *NOT* be considered part of
> > - * the xsk.h API, and is subject to change anytime.
> > - *
> > - * LIBRARY INTERNAL
> > - */
> > -
> > -#define __XSK_READ_ONCE(x) (*(volatile typeof(x) *)&x)
> > -#define __XSK_WRITE_ONCE(x, v) (*(volatile typeof(x) *)&x) = (v)
> > -
> > -#if defined(__i386__) || defined(__x86_64__)
> > -# define libbpf_smp_store_release(p, v)                                      \
> > -     do {                                                            \
> > -             asm volatile("" : : : "memory");                        \
> > -             __XSK_WRITE_ONCE(*p, v);                                \
> > -     } while (0)
> > -# define libbpf_smp_load_acquire(p)                                  \
> > -     ({                                                              \
> > -             typeof(*p) ___p1 = __XSK_READ_ONCE(*p);                 \
> > -             asm volatile("" : : : "memory");                        \
> > -             ___p1;                                                  \
> > -     })
> > -#elif defined(__aarch64__)
> > -# define libbpf_smp_store_release(p, v)                                      \
> > -             asm volatile ("stlr %w1, %0" : "=Q" (*p) : "r" (v) : "memory")
> > -# define libbpf_smp_load_acquire(p)                                  \
> > -     ({                                                              \
> > -             typeof(*p) ___p1;                                       \
> > -             asm volatile ("ldar %w0, %1"                            \
> > -                           : "=r" (___p1) : "Q" (*p) : "memory");    \
> > -             ___p1;                                                  \
> > -     })
> > -#elif defined(__riscv)
> > -# define libbpf_smp_store_release(p, v)                                      \
> > -     do {                                                            \
> > -             asm volatile ("fence rw,w" : : : "memory");             \
> > -             __XSK_WRITE_ONCE(*p, v);                                \
> > -     } while (0)
> > -# define libbpf_smp_load_acquire(p)                                  \
> > -     ({                                                              \
> > -             typeof(*p) ___p1 = __XSK_READ_ONCE(*p);                 \
> > -             asm volatile ("fence r,rw" : : : "memory");             \
> > -             ___p1;                                                  \
> > -     })
> > -#endif
> > -
> > -#ifndef libbpf_smp_store_release
> > -#define libbpf_smp_store_release(p, v)                                       \
> > -     do {                                                            \
> > -             __sync_synchronize();                                   \
> > -             __XSK_WRITE_ONCE(*p, v);                                \
> > -     } while (0)
> > -#endif
> > -
> > -#ifndef libbpf_smp_load_acquire
> > -#define libbpf_smp_load_acquire(p)                                   \
> > -     ({                                                              \
> > -             typeof(*p) ___p1 = __XSK_READ_ONCE(*p);                 \
> > -             __sync_synchronize();                                   \
> > -             ___p1;                                                  \
> > -     })
> > -#endif
> > -
> > -/* LIBRARY INTERNAL -- END */
> > -
> >   /* Do not access these members directly. Use the functions below. */
> >   #define DEFINE_XSK_RING(name) \
> >   struct name { \
> > @@ -168,7 +97,7 @@ static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
> >        * this function. Without this optimization it whould have been
> >        * free_entries = r->cached_prod - r->cached_cons + r->size.
> >        */
> > -     r->cached_cons = libbpf_smp_load_acquire(r->consumer);
> > +     r->cached_cons = __atomic_load_n(r->consumer, __ATOMIC_ACQUIRE);
> >       r->cached_cons += r->size;
> >
> >       return r->cached_cons - r->cached_prod;
> > @@ -179,7 +108,7 @@ static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
> >       __u32 entries = r->cached_prod - r->cached_cons;
> >
> >       if (entries == 0) {
> > -             r->cached_prod = libbpf_smp_load_acquire(r->producer);
> > +             r->cached_prod = __atomic_load_n(r->producer, __ATOMIC_ACQUIRE);
> >               entries = r->cached_prod - r->cached_cons;
> >       }
> >
> > @@ -202,7 +131,7 @@ static inline void xsk_ring_prod__submit(struct xsk_ring_prod *prod, __u32 nb)
> >       /* Make sure everything has been written to the ring before indicating
> >        * this to the kernel by writing the producer pointer.
> >        */
> > -     libbpf_smp_store_release(prod->producer, *prod->producer + nb);
> > +     __atomic_store_n(prod->producer, *prod->producer + nb, __ATOMIC_RELEASE);
> >   }
> >
> >   static inline __u32 xsk_ring_cons__peek(struct xsk_ring_cons *cons, __u32 nb, __u32 *idx)
> > @@ -227,8 +156,7 @@ static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, __u32 nb)
> >       /* Make sure data has been read before indicating we are done
> >        * with the entries by updating the consumer pointer.
> >        */
> > -     libbpf_smp_store_release(cons->consumer, *cons->consumer + nb);
> > -
> > +     __atomic_store_n(cons->consumer, *cons->consumer + nb, __ATOMIC_RELEASE);
> >   }
> >
> >   static inline void *xsk_umem__get_data(void *umem_area, __u64 addr)
> >
>
