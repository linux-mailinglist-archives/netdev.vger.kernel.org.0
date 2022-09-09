Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552065B2F37
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 08:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiIIGnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 02:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiIIGnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 02:43:39 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75756DABA4;
        Thu,  8 Sep 2022 23:43:36 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id z187so764186pfb.12;
        Thu, 08 Sep 2022 23:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=9nVJLUJ2SiWLWMJ0Bvx+obm2EZ7aQohvbWl7+sg/CKY=;
        b=n+T6675/krIJ6A3E8YoYenWU2EydjlwLs8xFH/pkUYFhL/GiZUgIBYFkdCIN/rCXBs
         eVQ4+drmRt13fZwiLN5UvzA2VbtLdYpRPQZZryPYe88GuDOhDKLN9U9jh3FiqcTezbfo
         U5ITE60hPa6YNqFuVRNqnUy1UnmmsxlL7NkeAzg9IPcNnWboy0P5wQgzkYXaL+XvhUfL
         1ssAX+v0YikRhiIO4RjWpyIMPl/Ptl/QutI9tV0TK/Yc5lorAh+wyxx5NhQxdoB8Kpbq
         BQJA2QoGDvecV/GGKg+68rDHKoOHnxi3yNcV6OY5HuUDzDdLnpBqrHA0iiNwU7onJjZm
         5wNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=9nVJLUJ2SiWLWMJ0Bvx+obm2EZ7aQohvbWl7+sg/CKY=;
        b=bO0b4m5SNac5I7Wj24OxOV3JM00ikLLbpWK5QXvm34p1iQ4qyjxsLzvFdnPBGsR6be
         eInt2ArgnwEVnxY1ll3cNeSQeRjzTGgNPnRL8l80fhuKlh+bdAUvi9dP3/LQM23I4z9X
         PoGXcp4j4tIHyLnnakUgGuKpjztSya3Q+mpIdjTPm9LNcFeeqo65qVnTHWNFSXIZJkLy
         gsiGh3MPoHSrkl+slAaidt5yOc5Km1CD1T+uxg2Yj8H5BHDyadjjO/ts1UhoQXbWj9wo
         mF9fXV0Q1z/PNZt8LzMBRsyIBtfKVqhGT8UVFCZh/W9uAIgFJiFG2VMjr0NQQBgwKv60
         HW0Q==
X-Gm-Message-State: ACgBeo00BpDCxLybTUIH56pIhpqkkLDn32b+xzO42RMlmvXB8LPWXby4
        Qw7Ij528CcFqTGFIVuDy9SpeEoSwoO0uQlaI5AQ=
X-Google-Smtp-Source: AA6agR6sdwzvjtz1vi39G9Zp1CLQhRx+f5IijWX3sEgkW+lbNB04MPIm9scVlgE5MQawGupiVGCfhcCHl0Q+VK+jGcY=
X-Received: by 2002:a05:6a00:801:b0:53e:5e35:336c with SMTP id
 m1-20020a056a00080100b0053e5e35336cmr12915088pfk.62.1662705815849; Thu, 08
 Sep 2022 23:43:35 -0700 (PDT)
MIME-Version: 1.0
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <166256558657.1434226.7390735974413846384.stgit@firesoul> <CAJ8uoz3UcC2tnMtG8W6a3HpCKgaYSzSCqowLFQVwCcsr+NKBOQ@mail.gmail.com>
 <b5f0d10d-2d4e-34d6-1e45-c206cb6f5d26@redhat.com> <9aab9ef1-446d-57ab-5789-afffe27801f4@redhat.com>
In-Reply-To: <9aab9ef1-446d-57ab-5789-afffe27801f4@redhat.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 9 Sep 2022 08:43:24 +0200
Message-ID: <CAJ8uoz0CD18RUYU4SMsubB8fhv3uOwp6wi_uKsZSu_aOV5piaA@mail.gmail.com>
Subject: Re: [PATCH RFCv2 bpf-next 17/18] xsk: AF_XDP xdp-hints support in
 desc options
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Maryam Tahhan <mtahhan@redhat.com>, brouer@redhat.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 8, 2022 at 5:04 PM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 08/09/2022 12.10, Maryam Tahhan wrote:
> > On 08/09/2022 09:06, Magnus Karlsson wrote:
> >> On Wed, Sep 7, 2022 at 5:48 PM Jesper Dangaard Brouer
> >> <brouer@redhat.com> wrote:
> >>>
> >>> From: Maryam Tahhan <mtahhan@redhat.com>
> >>>
> >>> Simply set AF_XDP descriptor options to XDP flags.
> >>>
> >>> Jesper: Will this really be acceptable by AF_XDP maintainers?
> >>
> >> Maryam, you guessed correctly that dedicating all these options bits
> >> for a single feature will not be ok :-). E.g., I want one bit for the
> >> AF_XDP multi-buffer support and who knows what other uses there might
> >> be for this options field in the future. Let us try to solve this in
> >> some other way. Here are some suggestions, all with their pros and
> >> cons.
> >>
> >
> > TBH it was Jespers question :)
>
> True. I'm generally questioning this patch...
> ... and indirectly asking Magnus.  (If you noticed, I didn't add my SoB)
>
> >> * Put this feature flag at a known place in the metadata area, for
> >> example just before the BTF ID. No need to fill this in if you are not
> >> redirecting to AF_XDP, but at a redirect to AF_XDP, the XDP flags are
> >> copied into this u32 in the metadata area so that user-space can
> >> consume it. Will cost 4 bytes of the metadata area though.
> >
> > If Jesper agrees I think this approach would make sense. Trying to
> > translate encodings into some other flags for AF_XDP I think will lead
> > to a growing set of translations as more options come along.
> > The other thing to be aware of is just making sure to clear/zero the
> > metadata space in the buffers at some point (ideally when the descriptor
> > is returned from the application) so when the buffers are used again
> > they are already in a "reset" state.
>
> I don't like this option ;-)
>
> First of all because this can give false positives, if "XDP flags copied
> into metadata area" is used for something else.  This can easily happen
> as XDP BPF-progs are free to metadata for something else.

Are XDP programs not free to overwrite the BTF id that you have last
in the md section too and you can get false positives for that as
well? Or do you protect it in some way? Sorry, but I do not understand
why a flags field would be different from a BTF id stored in the
metadata section.

> Second reason, because it would require AF_XDP to always read the
> metadata cache-line (and write, if clearing on "return").  Not a good
> optioon, given how performance sensitive AF_XDP workloads (at least
> benchmarks).

On its own, you are right, but when combined with the "bit in the
descriptor" proposal below, you would not get this performance
penalty. If the bit is zero, you do not have to read the MD cache
line. If the bit is one, you want to read the MD line to get your
metadata anyway, so one more read on the same cache line to get the
flags would not hurt performance. (There is of course a case where the
4 extra bytes of the flags could push the metadata you are interested
in to a new cache line, but this should be rare.)

But it all depends on if you need the resolution of a u32 flags field.
If not, forget this idea. If you do, then the metadata section is the
only place for it.

> >>
> >> * Instead encode this information into each metadata entry in the
> >> metadata area, in some way so that a flags field is not needed (-1
> >> signifies not valid, or whatever happens to make sense). This has the
> >> drawback that the user might have to look at a large number of entries
> >> just to find out there is nothing valid to read. To alleviate this, it
> >> could be combined with the next suggestion.
> >>
> >> * Dedicate one bit in the options field to indicate that there is at
> >> least one valid metadata entry in the metadata area. This could be
> >> combined with the two approaches above. However, depending on what
> >> metadata you have enabled, this bit might be pointless. If some
> >> metadata is always valid, then it serves no purpose. But it might if
> >> all enabled metadata is rarely valid, e.g., if you get an Rx timestamp
> >> on one packet out of one thousand.
> >>
>
> I like this option better! Except that I have hoped to get 2 bits ;-)

I will give you two if you need it Jesper, no problem :-).

> The performance advantage is that the AF_XDP descriptor bits will
> already be cache-hot, and if it indicates no-metadata-hints the AF_XDP
> application can avoid reading the metadata cache-line :-).

Agreed. I prefer if we can keep it simple and fast like this.

> When metadata is valid and contains valid XDP-hints can change between
> two packets.  E.g. XDP-hints can be enabled/disabled via ethtool, and
> the content can be enabled/disabled by other ethtool commands, and even
> setsockopt calls (e.g timestamping).  An XDP prog can also choose to use
> the area for something else for a subset of the packets.
>
> It is a design choice in this patchset to avoid locking down the NIC
> driver to a fixed XDP-hints layout, and avoid locking/disabling other
> ethtool config setting to keeping XDP-hints layout stable.  Originally I
> wanted this, but I realized that it would be impossible (and annoying
> for users) if we had to control every config interface to NIC hardware
> offload hints, to keep XDP-hints "always-valid".

> --Jesper
>
> >>> Signed-off-by: Maryam Tahhan <mtahhan@redhat.com>
> >>> ---
> >>>   include/uapi/linux/if_xdp.h |    2 +-
> >>>   net/xdp/xsk.c               |    2 +-
> >>>   net/xdp/xsk_queue.h         |    3 ++-
> >>>   3 files changed, 4 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> >>> index a78a8096f4ce..9335b56474e7 100644
> >>> --- a/include/uapi/linux/if_xdp.h
> >>> +++ b/include/uapi/linux/if_xdp.h
> >>> @@ -103,7 +103,7 @@ struct xdp_options {
> >>>   struct xdp_desc {
> >>>          __u64 addr;
> >>>          __u32 len;
> >>> -       __u32 options;
> >>> +       __u32 options; /* set to the values of xdp_hints_flags*/
> >>>   };
> >>>
> >>>   /* UMEM descriptor is __u64 */
> >>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> >>> index 5b4ce6ba1bc7..32095d78f06b 100644
> >>> --- a/net/xdp/xsk.c
> >>> +++ b/net/xdp/xsk.c
> >>> @@ -141,7 +141,7 @@ static int __xsk_rcv_zc(struct xdp_sock *xs,
> >>> struct xdp_buff *xdp, u32 len)
> >>>          int err;
> >>>
> >>>          addr = xp_get_handle(xskb);
> >>> -       err = xskq_prod_reserve_desc(xs->rx, addr, len);
> >>> +       err = xskq_prod_reserve_desc(xs->rx, addr, len, xdp->flags);
> >>>          if (err) {
> >>>                  xs->rx_queue_full++;
> >>>                  return err;
> >>> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> >>> index fb20bf7207cf..7a66f082f97e 100644
> >>> --- a/net/xdp/xsk_queue.h
> >>> +++ b/net/xdp/xsk_queue.h
> >>> @@ -368,7 +368,7 @@ static inline u32
> >>> xskq_prod_reserve_addr_batch(struct xsk_queue *q, struct xdp_d
> >>>   }
> >>>
> >>>   static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
> >>> -                                        u64 addr, u32 len)
> >>> +                                        u64 addr, u32 len, u32 flags)
> >>>   {
> >>>          struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
> >>>          u32 idx;
> >>> @@ -380,6 +380,7 @@ static inline int xskq_prod_reserve_desc(struct
> >>> xsk_queue *q,
> >>>          idx = q->cached_prod++ & q->ring_mask;
> >>>          ring->desc[idx].addr = addr;
> >>>          ring->desc[idx].len = len;
> >>> +       ring->desc[idx].options = flags;
> >>>
> >>>          return 0;
> >>>   }
> >>>
> >>>
> >>
> >
>
