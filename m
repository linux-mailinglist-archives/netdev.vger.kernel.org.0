Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46931359056
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 01:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhDHXbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 19:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbhDHXbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 19:31:08 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C534CC061760;
        Thu,  8 Apr 2021 16:30:56 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id p8so3227228ilm.13;
        Thu, 08 Apr 2021 16:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=WeGvI3R9SdgcM6wF5Ki+UP+pYa2aJmS+hQ8AwdTFp5I=;
        b=kOvlnOIz7uWex9biXejsl1zEVbpNQQRVaWITBtRRVAY73MYPY1k5bhah3jnB3wrBqI
         CrEMx1HwCT8EYSvdDwjI7rNE+a6nQ61esLLhpxXuxhdqyHzE7tXl3HODU5p2k077MEkQ
         cgK6KexqYdRG2OaS5LO8UhPDq+4TV1Za//wja3R9CVUWeCcuU3Gm4WARygO8X1CRld9x
         YL15gm3Djti6ZXGF4NqXLO9sL3V1k1PBBC2gUmf4cna0LzKiIDJWMhQxx/uKsAGZcJa5
         k7dXgwzQJrDyswzJa7HXG8+GZtcVejCsI3d1y0zQG/qX/jsTYTMJ4cqe1oVgv3RFoatF
         cR8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=WeGvI3R9SdgcM6wF5Ki+UP+pYa2aJmS+hQ8AwdTFp5I=;
        b=sAKMZwkdU+E7n9h1+sNQagEWtJbSKYLqFJPwwYRdMGJXNNszsibIFNsVT8myiIPdTH
         YfiFbYcxCmheY8vWQHOo+pZJMRwuThbGfT64025/J9weQz/XTmbWpYib2BFnkF500P+F
         Gn+fvXyxcBngMAQkC3bF3DseC6sFM5r2KzgHk3xRHSf3kPrQvEBaNSrRLEiRJEniZ8d7
         oFoWoCzBtzyKMRAuUCi6qb8MXq7YUU7Zo9X6LzDHKGbogTcvnOSS0dqoZA0fyd2fJNL5
         6e5FWUTGMNe2SmTUxmNo3WWS0DMVbNn5ROBkWTu0I/VZm9qujO9yK5j+++37LhUzqzl9
         TPvA==
X-Gm-Message-State: AOAM530iqjGbKGMwpjKUwKeEYCCu+EeZJc7RiQFC8Utn80upN2HpuIia
        FuUmhpWdmRDbneEqOMTk0f0=
X-Google-Smtp-Source: ABdhPJyvLitg0H8zkokxcASRCTOGL5l4Q827K+V/MJmLiogDnbBMtp1aoQaBppkEW8C+4oFa+e3oAA==
X-Received: by 2002:a05:6e02:1a65:: with SMTP id w5mr9011592ilv.5.1617924656284;
        Thu, 08 Apr 2021 16:30:56 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id j1sm35057ioa.19.2021.04.08.16.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 16:30:55 -0700 (PDT)
Date:   Thu, 08 Apr 2021 16:30:45 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Message-ID: <606f922584d89_c8b92089a@john-XPS-13-9370.notmuch>
In-Reply-To: <87h7kj2enn.fsf@toke.dk>
References: <20210402121954.3568992-1-liuhangbin@gmail.com>
 <20210402121954.3568992-3-liuhangbin@gmail.com>
 <606baa5025735_d46462085b@john-XPS-13-9370.notmuch>
 <20210406063819.GF2900@Leo-laptop-t470s>
 <878s5v4swp.fsf@toke.dk>
 <606cd787d64da_22ba520855@john-XPS-13-9370.notmuch>
 <87k0pf2gz6.fsf@toke.dk>
 <606ce0db7cd40_2865920845@john-XPS-13-9370.notmuch>
 <87h7kj2enn.fsf@toke.dk>
Subject: Re: [PATCHv4 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> John Fastabend <john.fastabend@gmail.com> writes:
> =

> > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> John Fastabend <john.fastabend@gmail.com> writes:
> >> =

> >> > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> >> Hangbin Liu <liuhangbin@gmail.com> writes:
> >> >> =

> >> >> > On Mon, Apr 05, 2021 at 05:24:48PM -0700, John Fastabend wrote:=

> >> >> >> Hangbin Liu wrote:
> >> >> >> > This patch add two flags BPF_F_BROADCAST and BPF_F_EXCLUDE_I=
NGRESS to extend
> >> >> >> > xdp_redirect_map for broadcast support.

[...]

> >> > Have we consider doing something like the batch lookup ops over ha=
shtab?
> >> > I don't mind "missing" values so if we just walk the list?
> >> >
> >> >      head =3D dev_map_index_hash(dtab, i)
> >> >      // collect all my devs and get ready to send multicast
> >> >      hlist_nulls_for_each_entry_safe(dev, next, head, index_hlist)=
 {
> >> > 		enqueue(dev, skb)
> >> >      }
> >> >      // submit the queue of entries and do all the work to actuall=
y xmit
> >> >      submit_enqueued();
> >> >
> >> > We don't have to care about keys just walk the hash list?
> >> =

> >> So you'd wrap that in a loop like:
> >> =

> >> for (i =3D 0; i < dtab->n_buckets; i++) {
> >> 	head =3D dev_map_index_hash(dtab, i);
> >> 	hlist_nulls_for_each_entry_safe(dev, next, head, index_hlist) {
> >> 		bq_enqueue(dev, xdpf, dev_rx, obj->xdp_prog);
> >> 	}
> >> }
> >> =

> >> or? Yeah, I guess that would work!
> >
> > Nice. Thanks for sticking with this Hangbin its taking us a bit, but
> > I think above works on my side at least.
> >
> >> =

> >> It would mean that dev_map_enqueue_multi() would need more in-depth
> >> knowledge into the map type, so would likely need to be two differen=
t
> >> functions for the two different map types, living in devmap.c - but
> >> that's probably acceptable.
> >
> > Yeah, I think thats fine.
> >
> >> =

> >> And while we're doing that, the array-map version can also loop over=
 all
> >> indexes up to max_entries, instead of stopping at the first index th=
at
> >> doesn't have an entry like it does now (right now, it looks like if =
you
> >> populate entries 0 and 2 in an array-map only one copy of the packet=

> >> will be sent, to index 0).
> >
> > Right, this is likely needed anyways. At least when I was doing proto=
types
> > of using array maps I often ended up with holes in the map. Just imag=
ine
> > adding a set of devs and then removing one, its not likely to be the
> > last one you insert.
> =

> Yeah, totally. Would have pointed it out if I'd noticed before, but I
> was too trusting in the abstraction of get_next_key() etc :)
 =

Hangbin,

If possible please try to capture some of the design discussion in
the commit message on the next rev along with the tradeoffs we are making=

so we don't lose these important details. Some of these points are fairly=

subtle calling them out will surely save (for me at least) some thinking
when I pick this up when it lands in a released kernel.

Thanks!=
