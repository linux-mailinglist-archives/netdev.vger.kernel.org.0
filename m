Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A41358DA2
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfF0WIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:08:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41029 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfF0WIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:08:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id q4so144693pgj.8;
        Thu, 27 Jun 2019 15:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/h3ULTjXDzRWUsUxCT1KF9AIRl7JQviKgO6mJP3zRGY=;
        b=bqsuDWfbWt4udbXjfHjiH+jK5MPShPoVN2Ng0aieW8+X6bzlBLwTj9uRPKrhyUDscJ
         ZnsjnwPhla0DDGsR87Tz7jfstBv9hw+2gTYiwLL1iihk0+omLFKfawCEjkMh+mZ+vswl
         0XGNglSF5EaOyeN6/ic3h4BXb38BWMH1NF/iwN7t+Ep3Yyqbdh9RSE5MciKOuwelSASh
         hlUdH1U81eE/NsCHVhcAcJB01+Ee6z2Ub3wPzGfj3QWcBVpyEJqdgTMzf+Ij9NBYZjlD
         14aLZlNI+p+H6kSByQBmvykRZaywo/xBTI7cHy5p6GE88k4uVd3UwLQCkIvsVe9q8nvr
         xH/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/h3ULTjXDzRWUsUxCT1KF9AIRl7JQviKgO6mJP3zRGY=;
        b=Hu3gNiLL7sC8bI6hTlj/g14BF41Cajnw5u8/fWt75WuFE43rqF+856+5tt9fm+xfQY
         yRyAyNOqWXjTuHD66XquA/RxLXaIuieYPMp9rBU+JkqTiC0YN9YXkm/dBB+fwgtsYdjh
         KbDNLtxVt3HePV2s+S72zeuYtMdHlQZT574VCMULqPIySdLweHfMAQIXA9PvkwsfKdk+
         bEo2tMzyeainWLxgx2Qwzt3wbBlb9PJwamlpGrYQ9hUurbTUS7oz96Tb+Cgshg/vKETt
         57v73x0/rKqNKay2zHYOSJjhF9Au6m9nLKo6sTW1vxDyg4sssOCFO8R6YIdVm2UlhW1P
         C8RQ==
X-Gm-Message-State: APjAAAXh1M/az/id0UX+P5sPkGKius7XnT8f5KXLpXONcIBkxOIll4JE
        QxrJxi0AZH4GF9OH8VtoAPk=
X-Google-Smtp-Source: APXvYqxMNHeH0nKiRHBn2Mmbu0zzCIAgk2uN8HnwwNRPT+HGpIbgpHYumjjT3yUNS5MallVY2O2XSw==
X-Received: by 2002:a17:90a:c596:: with SMTP id l22mr8928895pjt.46.1561673279609;
        Thu, 27 Jun 2019 15:07:59 -0700 (PDT)
Received: from [172.20.53.102] ([2620:10d:c090:200::6693])
        by smtp.gmail.com with ESMTPSA id a21sm128620pgd.45.2019.06.27.15.07.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 15:07:58 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     "Willem de Bruijn" <willemdebruijn.kernel@gmail.com>,
        "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>, davem@davemloft.net,
        netdev@vger.kernel.org, "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Daniel Borkmann" <borkmann@iogearbox.net>,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        "Alexei Starovoitov" <alexei.starovoitov@gmail.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        xdp-newbies@vger.kernel.org
Subject: Re: XDP multi-buffer incl. jumbo-frames (Was: [RFC V1 net-next 1/1]
 net: ena: implement XDP drop support)
Date:   Thu, 27 Jun 2019 15:07:56 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <0D1286E7-02CD-4252-823C-4D1CBB8F2807@gmail.com>
In-Reply-To: <20190626220028.2bb12196@carbon>
References: <20190623070649.18447-1-sameehj@amazon.com>
 <20190623070649.18447-2-sameehj@amazon.com> <20190623162133.6b7f24e1@carbon>
 <A658E65E-93D2-4F10-823D-CC25B081C1B7@amazon.com>
 <20190626103829.5360ef2d@carbon> <87a7e4d0nj.fsf@toke.dk>
 <20190626164059.4a9511cf@carbon> <87h88cbdbe.fsf@toke.dk>
 <CA+FuTSfKnhv9rr=cDa_4m7Dd9qkEm_oabDfyvH0T0sM+fQTU=w@mail.gmail.com>
 <99AFC1EE-E27E-4D4D-B9B8-CA2215E68E1B@gmail.com>
 <20190626220028.2bb12196@carbon>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26 Jun 2019, at 13:00, Jesper Dangaard Brouer wrote:

> On Wed, 26 Jun 2019 09:42:07 -0700 "Jonathan Lemon" =

> <jonathan.lemon@gmail.com> wrote:
>
>> If all packets are collected together (like the bulk queue does), and
>> then passed to XDP, this could easily be made backwards compatible.
>> If the XDP program isn't 'multi-frag' aware, then each packet is just
>> passed in individually.
>
> My proposal#1 is XDP only access first-buffer[1], as this simplifies =

> things.
>
> (AFAIK) What you are proposing is that all the buffers are passed to
> the XDP prog (in form of a iovec).  I need some more details about =

> your
> suggestion.

I was thinking this over yesterday - and was probably conflating packets
and buffers a bit.  Suppose that for the purposes of this discussion, =

we're
talking about a single packet that is split over multiple buffer areas.

Say, on RX, with header split:
    buf[0] =3D header
    buf[1] =3D data

For LRO (hw recv) and jumbo frames (and TSO):
    buf[0] =3D hdr + data
    buf[1] =3D data
    buf[n] =3D data

GRO cases, where individual packets are reassembled by software, aren't
handled here.


> Specifically:
>
> - What is the semantic when a 3 buffer packet is input and XDP prog
> choose to return XDP_DROP for packet #2 ?
>
> - Same situation of packet #2 wants a XDP_TX or redirect?

The collection of buffers represents a single packet, so this isn't
applicable here, right?

However, just thinking about incomplete data words (aka: pullup) gives
me a headache - seems this would complicate the BPF/verifier quite a =

bit.

So perhaps just restricting things to the first entry would do for now?

As far as the exact data structure used to hold the buffers, it would
be nice if it had the same layout as a bio_vec, in case someone wanted
to get clever and start transferring things over directly.
-- =

Jonathan


>> Of course, passing in the equivalent of a iovec requires some form of
>> loop support on the BPF side, doesn't it?
>
> The data structure used for holding these packet buffers/segments also
> needs to be discussed.  I would either use an array of bio_vec[2] or
> skb_frag_t (aka skb_frag_struct).  The skb_frag_t would be most
> obvious, as we already have to write this when creating an SKB, in
> skb_shared_info area. (Structs listed below signature).
>
> The problem is also that size of these structs (16 bytes) per
> buffer/segment, and we likely need to support 17 segments, as this =

> need
> to be compatible with SKBs (size 272 bytes).
>
> My idea here is that we simply use the same memory area, that we have =

> to
> store skb_shared_info into.  As this allow us to get the SKB setup for
> free, when doing XDP_PASS or when doing SKB alloc after XDP_REDIRECT.
>
>
> [1] =

> https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-m=
ulti-buffer01-design.org#proposal1-xdp-only-access-first-buffer
>
> [2] =

> https://lore.kernel.org/netdev/20190501041757.8647-1-willy@infradead.or=
g/
> -- =

> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
>
> $ pahole -C skb_frag_struct vmlinux
> struct skb_frag_struct {
> 	struct {
> 		struct page * p;                         /*     0     8 */
> 	} page;                                          /*     0     8 */
> 	__u32                      page_offset;          /*     8     4 */
> 	__u32                      size;                 /*    12     4 */
>
> 	/* size: 16, cachelines: 1, members: 3 */
> 	/* last cacheline: 16 bytes */
> };
>
> $ pahole -C bio_vec vmlinux
> struct bio_vec {
> 	struct page        * bv_page;                    /*     0     8 */
> 	unsigned int               bv_len;               /*     8     4 */
> 	unsigned int               bv_offset;            /*    12     4 */
>
> 	/* size: 16, cachelines: 1, members: 3 */
> 	/* last cacheline: 16 bytes */
> };
>
> $ pahole -C skb_shared_info vmlinux
> struct skb_shared_info {
> 	__u8                       __unused;             /*     0     1 */
> 	__u8                       meta_len;             /*     1     1 */
> 	__u8                       nr_frags;             /*     2     1 */
> 	__u8                       tx_flags;             /*     3     1 */
> 	short unsigned int         gso_size;             /*     4     2 */
> 	short unsigned int         gso_segs;             /*     6     2 */
> 	struct sk_buff     * frag_list;                  /*     8     8 */
> 	struct skb_shared_hwtstamps hwtstamps;           /*    16     8 */
> 	unsigned int               gso_type;             /*    24     4 */
> 	u32                        tskey;                /*    28     4 */
> 	atomic_t                   dataref;              /*    32     0 */
>
> 	/* XXX 8 bytes hole, try to pack */
>
> 	void *                     destructor_arg;       /*    40     8 */
> 	skb_frag_t                 frags[17];            /*    48   272 */
>
> 	/* size: 320, cachelines: 5, members: 13 */
> 	/* sum members: 312, holes: 1, sum holes: 8 */
> };
