Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E5C5781CB
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbiGRMMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbiGRMMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:12:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8099A24F26
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 05:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658146333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wAYQQbHQO7oQPzR7CI+0jC3+vkqv9xnoYvkFQj8b6Lw=;
        b=h9rhsmOTgnxwfELdEdtgi5oHNUF3YbODYnsVp7r8UYCYho54wiw0RKBGp+WQbztvWODkbM
        /ibHU67PQZUQ6PDsotx+O1ab+NRl2J2watj6UUysmnJn3PuOFSJSPh7YmsA3wGVQXKYYXe
        duPFSIo0XydEMgzfWI2IvlU/v/qIq3I=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-nolcqihsN2acEgeFESnYzA-1; Mon, 18 Jul 2022 08:12:12 -0400
X-MC-Unique: nolcqihsN2acEgeFESnYzA-1
Received: by mail-ej1-f72.google.com with SMTP id hq20-20020a1709073f1400b0072b9824f0a2so2257519ejc.23
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 05:12:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=wAYQQbHQO7oQPzR7CI+0jC3+vkqv9xnoYvkFQj8b6Lw=;
        b=WIP58XXtSk5WKgtUGAcFfSumb8Wfu5MJXaq+INdC15TftAKbDhcJ1jsqhTZchX/Jwz
         j+bDep3AntGfORykaMhxTPnZEER89IXA+GwEnDF+7VP43LZrbk+WusF2v/46N1XKvCNf
         rYdW/zIQGdejvfSO4Y1wPSaf5nemgme3deyKFm+XAUag+FJK51pJVMjHsMNW2jmtkkC/
         6+Z+MlkvXQCUBw0btEWn2isjiHq9L+pFEFD/kIaaVDCX+UzZ6gMQR8+99lRoYK1/aeGW
         SQ3gHXgqwkhiekPvaZWbuYyLG7kAUoI6ApjcwKP44P+Ma2aJyfCfm++jPxeyjfk0JGDP
         Z2Wg==
X-Gm-Message-State: AJIora+RLf/to04AAKD6bSMx0DYf6wX2EfJzV9CRACegwWlAEWYpL1Jk
        tw4VwMjRrxvNQKLEchuK0yshV/OBHz6NnnpToj2RC7oigKJk1/m2IiVphc2UyydddCxIglTxIv9
        tkA1Hu/6wng9NWgAQ
X-Received: by 2002:a05:6402:414b:b0:43b:6b1a:c230 with SMTP id x11-20020a056402414b00b0043b6b1ac230mr3953375eda.42.1658146328779;
        Mon, 18 Jul 2022 05:12:08 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s/MYdSKQdNwxXX7yoBKWYXaN6D6LMs9kxszmnpEGxo8SlLPXw6hvv+oH3o0kqPWH1weCseMQ==
X-Received: by 2002:a05:6402:414b:b0:43b:6b1a:c230 with SMTP id x11-20020a056402414b00b0043b6b1ac230mr3953254eda.42.1658146327654;
        Mon, 18 Jul 2022 05:12:07 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d2-20020a056402000200b0043a61f6c389sm8539895edu.4.2022.07.18.05.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 05:12:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7A4464D9EE6; Mon, 18 Jul 2022 14:12:05 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>
Subject: Re: [RFC PATCH 00/17] xdp: Add packet queueing and scheduling
 capabilities
In-Reply-To: <YtRSOaCtujBfzHUS@pop-os.localdomain>
References: <20220713111430.134810-1-toke@redhat.com>
 <CAKH8qBtdnku7StcQ-SamadvAF==DRuLLZO94yOR1WJ9Bg=uX1w@mail.gmail.com>
 <877d4gpto8.fsf@toke.dk> <YtRSOaCtujBfzHUS@pop-os.localdomain>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 18 Jul 2022 14:12:05 +0200
Message-ID: <87y1wqliwa.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Wed, Jul 13, 2022 at 11:52:07PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Stanislav Fomichev <sdf@google.com> writes:
>>=20
>> > On Wed, Jul 13, 2022 at 4:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> Packet forwarding is an important use case for XDP, which offers
>> >> significant performance improvements compared to forwarding using the
>> >> regular networking stack. However, XDP currently offers no mechanism =
to
>> >> delay, queue or schedule packets, which limits the practical uses for
>> >> XDP-based forwarding to those where the capacity of input and output =
links
>> >> always match each other (i.e., no rate transitions or many-to-one
>> >> forwarding). It also prevents an XDP-based router from doing any kind=
 of
>> >> traffic shaping or reordering to enforce policy.
>> >>
>> >> This series represents a first RFC of our attempt to remedy this lack=
. The
>> >> code in these patches is functional, but needs additional testing and
>> >> polishing before being considered for merging. I'm posting it here as=
 an
>> >> RFC to get some early feedback on the API and overall design of the
>> >> feature.
>> >>
>> >> DESIGN
>> >>
>> >> The design consists of three components: A new map type for storing X=
DP
>> >> frames, a new 'dequeue' program type that will run in the TX softirq =
to
>> >> provide the stack with packets to transmit, and a set of helpers to d=
equeue
>> >> packets from the map, optionally drop them, and to schedule an interf=
ace
>> >> for transmission.
>> >>
>> >> The new map type is modelled on the PIFO data structure proposed in t=
he
>> >> literature[0][1]. It represents a priority queue where packets can be
>> >> enqueued in any priority, but is always dequeued from the head. From =
the
>> >> XDP side, the map is simply used as a target for the bpf_redirect_map=
()
>> >> helper, where the target index is the desired priority.
>> >
>> > I have the same question I asked on the series from Cong:
>> > Any considerations for existing carousel/edt-like models?
>>=20
>> Well, the reason for the addition in patch 5 (continuously increasing
>> priorities) is exactly to be able to implement EDT-like behaviour, where
>> the priority is used as time units to clock out packets.
>
> Are you sure? I seriouly doubt your patch can do this at all...
>
> Since your patch relies on bpf_map_push_elem(), which has no room for
> 'key' hence you reuse 'flags' but you also reserve 4 bits there... How
> could tstamp be packed with 4 reserved bits??

Well, my point was that the *data structure* itself supports 64-bit
priorities, and that's what we use from bpf_map_redirect() in XDP. The
choice of reserving four bits was a bit of an arbitrary choice on my
part. I actually figured 60 bits would be plenty to represent timestamps
in themselves, but I guess I miscalculated a bit for nanosecond
timestamps (60 bits only gets you 36 years of range there).

We could lower that to 2 reserved bits, which gets you a range of 146
years using 62 bits; or users could just right-shift the value by a
couple of bits before putting them in the map (scheduling with
single-nanosecond precision is not possible anyway, so losing a few bits
of precision is no big deal); or we could add a new helper instead of
reusing the existing one.

> Actually, if we look into the in-kernel EDT implementation
> (net/sched/sch_etf.c), it is also based on rbtree rather than PIFO.

The main reason I eschewed the existing rbtree code is that I don't
believe it's sufficiently performant, mainly due to the rebalancing.
This is a hunch, though, and as I mentioned in a different reply I'm
planning to go back and revisit the data structure, including
benchmarking different implementations against each other.

-Toke

