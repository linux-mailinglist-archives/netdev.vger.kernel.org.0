Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33256EAA59
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 14:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbjDUM1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 08:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDUM1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 08:27:22 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10331A5E4;
        Fri, 21 Apr 2023 05:27:21 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 3f1490d57ef6-b9941f4a652so3864276.0;
        Fri, 21 Apr 2023 05:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682080040; x=1684672040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQV0FUHVgTyr3sKGhtOpetQjh4FYMTAof8GhJk2jFzo=;
        b=DOYBnsZ3Ca1fTcTjwnJpiKRKP+0seId83JMiXybBYOkYX6s22WKaqA2/pFO0hFjGkG
         c5j+2GyaLyJIXVsQYWVfCjdS5Z/Gh+9QORCu6Lh3gGe9bpOSYt52d+NbmSIy9oaWlkz5
         nOpRp47Cba4YCaLgAVUdZQIunKyNYuXFqSqi7ip1mukEXxmtFLLajuuLUrZ6yWU3ODx6
         hnG/5kLYX/DHExgOF7dJUHcmy4hwNB3pU75eL3UggpVNXP2VL5lCjtiykwZlNae4IlSh
         pe/T0fPWWVuZTYD3yiP1iAo+Vj7xokm+B2bFl/kNXq7+PFMWDlPk5znStfgBBrHr5SSW
         eF7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682080040; x=1684672040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DQV0FUHVgTyr3sKGhtOpetQjh4FYMTAof8GhJk2jFzo=;
        b=OLMIWRYs42MBnXe4SkZNx9RUaePZb1eN1xNehe2K5Uo7FWLZ+PdL3WdS9OnPd0GohE
         hO9WKmaXjh6oTyRwcadSD2qOLc/lj9EJB9qJ37DwfLtT54RqdCcDdVxdQm2ddZRvzoju
         gre/haKli4KG6s+DjlsIhyMr7bleMsYKfUappkFQOIgjj062y3xGEGLTLMjkejxMSt+g
         BSWbeMr8uLlKMCK5bNMte29qVyv/ZUlEdZiO8hcGwvXS5hjIxtL3gEjxSzVnrBQ8zAmJ
         9w2EjbBWHa2uZXpYVVd0bHcoIo4BTpHcZxuItYRK2OlQOB4hxs1xp02ORlwZxc33uHYL
         qrqw==
X-Gm-Message-State: AAQBX9cFqSju7LaAnaIrCgtKUe+/ZGn1b2PSLh8eM18fN7o5OgPCicJX
        n0gq+1bUp4CXdXLTby3vCx8V3x7OZU3YB9dhr7w=
X-Google-Smtp-Source: AKy350ZoWJQiG1Y6sTZgVbEjMaUShUqiByyAL19aUrMuFWuJVKNYrgeKYH/X5MY56flB1H8dU3jAtgpD1omjKMpzrN4=
X-Received: by 2002:a81:1a0b:0:b0:54f:a9e4:e79 with SMTP id
 a11-20020a811a0b000000b0054fa9e40e79mr2819066ywa.2.1682080040176; Fri, 21 Apr
 2023 05:27:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230406130205.49996-2-kal.conley@dectris.com>
 <87sfdckgaa.fsf@toke.dk> <ZDBEng1KEEG5lOA6@boxer> <CAHApi-nuD7iSY7fGPeMYiNf8YX3dG27tJx1=n8b_i=ZQdZGZbw@mail.gmail.com>
 <875ya12phx.fsf@toke.dk> <CAHApi-=rMHt7uR8Sw1Vw+MHDrtkyt=jSvTvwz8XKV7SEb01CmQ@mail.gmail.com>
 <87ile011kz.fsf@toke.dk> <CAHApi-=ODe-WtJ=m6bycQhKoQxb+kk2Yk9Fx5SgBsWUuWT_u-A@mail.gmail.com>
 <874jpdwl45.fsf@toke.dk> <CAHApi-kcaMRPj4mEPs87_4Z6iO5qEpzOOcbVza7vxURqCtpz=Q@mail.gmail.com>
 <ZEJZYa8WT6A9VpOJ@boxer> <87r0sdsgpf.fsf@toke.dk>
In-Reply-To: <87r0sdsgpf.fsf@toke.dk>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 21 Apr 2023 14:27:09 +0200
Message-ID: <CAJ8uoz3WTCtqtU+EwHqDaKZfBrn=bVbNDhYYqNWahCo24ZHYZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Kal Cutter Conley <kal.conley@dectris.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Apr 2023 at 12:01, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
>
> > On Tue, Apr 18, 2023 at 01:12:00PM +0200, Kal Cutter Conley wrote:
> >
> > Hi there,
> >
> >> > >> In addition, presumably when using this mode, the other XDP actio=
ns
> >> > >> (XDP_PASS, XDP_REDIRECT to other targets) would stop working unle=
ss we
> >> > >> add special handling for that in the kernel? We'll definitely nee=
d to
> >> > >> handle that somehow...
> >> > >
> >> > > I am not familiar with all the details here. Do you know a reason =
why
> >> > > these cases would stop working / why special handling would be nee=
ded?
> >> > > For example, if I have a UMEM that uses hugepages and XDP_PASS is
> >> > > returned, then the data is just copied into an SKB right? SKBs can
> >> > > also be created directly from hugepages AFAIK. So I don't understa=
nd
> >> > > what the issue would be. Can someone explain this concern?
> >> >
> >> > Well, I was asking :) It may well be that the SKB path just works; d=
id
> >> > you test this? Pretty sure XDP_REDIRECT to another device won't, tho=
ugh?
> >
> > for XDP_PASS we have to allocate a new buffer and copy the contents fro=
m
> > current xdp_buff that was backed by xsk_buff_pool and give the current =
one
> > back to pool. I am not sure if __napi_alloc_skb() is always capable of
> > handling len > PAGE_SIZE - i believe there might a particular combinati=
on
> > of settings that allows it, but if not we should have a fallback path t=
hat
> > would iterate over data and copy this to a certain (linear + frags) par=
ts.
> > This implies non-zero effort that is needed for jumbo frames ZC support=
.
> >
> > I can certainly test this out and play with it - maybe this just works,=
 I
> > didn't check yet. Even if it does, then we need some kind of temporary
> > mechanism that will forbid loading ZC jumbo frames due to what Toke
> > brought up.
>
> Yeah, this was exactly the kind of thing I was worried about (same for
> XDP_REDIRECT). Thanks for fleshing it out a bit :)
>
> >> >
> >>
> >> I was also asking :-)
> >>
> >> I tested that the SKB path is usable today with this patch.
> >> Specifically, sending and receiving large jumbo packets with AF_XDP
> >> and that a non-multi-buffer XDP program could access the whole packet.
> >> I have not specifically tested XDP_REDIRECT to another device or
> >> anything with ZC since that is not possible without driver support.
> >>
> >> My feeling is, there wouldn't be non-trivial issues here since this
> >> patchset changes nothing except allowing the maximum chunk size to be
> >> larger. The driver either supports larger MTUs with XDP enabled or it
> >> doesn't. If it doesn't, the frames are dropped anyway. Also, chunk
> >> size mismatches between two XSKs (e.g. with XDP_REDIRECT) would be
> >> something supported or not supported irrespective of this patchset.
> >
> > Here is the comparison between multi-buffer and jumbo frames that I did
> > for ZC ice driver. Configured MTU was 8192 as this is the frame size fo=
r
> > aligned mode when working with huge pages. I am presenting plain number=
s
> > over here from xdpsock.
> >
> > Mbuf, packet size =3D 8192 - XDP_PACKET_HEADROOM
> > 885,705pps - rxdrop frame_size=3D4096
> > 806,307pps - l2fwd frame_size=3D4096
> > 877,989pps - rxdrop frame_size=3D2048
> > 773,331pps - l2fwd frame_size=3D2048
> >
> > Jumbo, packet size =3D 8192 - XDP_PACKET_HEADROOM
> > 893,530pps - rxdrop frame_size=3D8192
> > 841,860pps - l2fwd frame_size=3D8192
> >
> > Kal might say that multi-buffer numbers are imaginary as these patches
> > were never shown to the public ;) but now that we have extensive test
> > suite I am fixing some last issues that stand out, so we are asking for
> > some more patience over here... overall i was expecting that they will =
be
> > much worse when compared to jumbo frames, but then again i believe this
> > implementation is not ideal and can be improved. Nevertheless, jumbo
> > frames support has its value.
>
> Thank you for doing these! Okay, so that's between 1-4% improvement (vs
> the 4k frags). I dunno, I wouldn't consider that a slam dunk; would
> depend on the additional complexity if it is worth it to do both, IMO...

If we are using 4K frags, the worst case is that we have to use 3
frags to cover a 9K packet. Interpolating between the results above
would mean somewhere in the 1 - 6% range of improvement with jumbo
frames. Something that is not covered by these tests at all is the
overhead of an abstraction layer for dealing with multiple buffers. I
believe many applications would choose to have one to hide the fact
that there are multiple buffers. So I think these improvement numbers
are on the lower side.

But agree that we should factor in the complexity of covering the
cases you have brought up and see if it is worth it.

> -Toke
>
