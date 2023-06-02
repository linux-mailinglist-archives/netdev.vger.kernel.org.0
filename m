Return-Path: <netdev+bounces-7445-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9277772054B
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:05:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 414A9281998
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A8FE19BDD;
	Fri,  2 Jun 2023 15:05:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57ACD258F
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:05:35 +0000 (UTC)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F331B7;
	Fri,  2 Jun 2023 08:05:30 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b02d0942caso10957255ad.1;
        Fri, 02 Jun 2023 08:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685718330; x=1688310330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AVYp+0xRrABpA+nW/UL0wQT78NsGeWK/bJt+odq48Kw=;
        b=SWtj/RivdDdkfH7W4UOFjyATb5ZvO+gXvdjEMUq2seQQ2xynVC2zodDPFqHrZnMmyA
         kd4F2kJfKxmEhe05gfyFz71s/AftNNFk2jVlC9xVvnDG4+m1qirwtdgmnl9dZtVf/O/x
         f4MErBuHDem0CQZo/3wUp1vgqyUOdDQxSFcJWhvshUhmO8dRa115KmSkMxt1xhTXy5Ou
         3xKRl2Mw0qBgwFVipSfHgqLj/m9KZpUBNa6ARZz5gPf6sPapuNq1i31L8RJsqwdqj6fQ
         PBE/aRyl16QS/yORG6eQWFez7HOaeASp0VWZ6tpp/lFBzV0NO5/JM1Go6eItan0VX01D
         jVoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685718330; x=1688310330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AVYp+0xRrABpA+nW/UL0wQT78NsGeWK/bJt+odq48Kw=;
        b=D2W3vLmAQ/YS2zdSvcYAlQYoxQOriFmJ9VnQFhlw2U/KKWFBsf42BSU17+wR3BK9cE
         tbJxCQ6xD5mNd071eTG+MtNxfxiMyBjDKWfAR/QT+4gAiy6NeCWEMG+1GmL8WPHz5I+9
         droao9m95pduQ8HXUIuin64vEsrRfVmbsBCDIFTrXX0zt1z2bOUYSdKBhydC1WAxFIqv
         koIXjOyPoHLxgEqflWGF3hfOv32MpK81gfpQJWIzBcsaik4OPL6l1TzsfB3Dh+ZYq3OW
         kUulUqVwHUABYCKfKG2CfTDdIpBIlFRm4G1fC59LZ8AmPxzoHh9Mn+3YfJvUR+CEA8VG
         OTWw==
X-Gm-Message-State: AC+VfDzWHSjCNFCVncSYUmNs/Hd2E9BrnYr+qogteWblxuEAROk192Ee
	bJT0dCATP18D3N/zPFDVBUzzPTDC9LD8VrkJcdU=
X-Google-Smtp-Source: ACHHUZ6hu3WaEIY/KGqCiqpllvClinnYMo4yqXbSBKsWFgY7OWcRmf8HOHpvyi1bSZIESaNssHBa4XOvHA8dj15DqWY=
X-Received: by 2002:a17:903:2284:b0:1ae:dadc:ca2a with SMTP id
 b4-20020a170903228400b001aedadcca2amr198815plh.57.1685718329571; Fri, 02 Jun
 2023 08:05:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230525125746.553874-1-aleksander.lobakin@intel.com>
 <20230525125746.553874-4-aleksander.lobakin@intel.com> <8828262f1c238ab28be9ec87a7701acd791af926.camel@gmail.com>
 <cb7d3479-63a5-31b4-355d-b12a7e1b2878@intel.com> <CAKgT0Ud204CiJeB-5zcTKdrv7ODrfP09t73CqRhps7g3qhWU5w@mail.gmail.com>
 <d375fef9-43c4-9f2a-41c9-5247fcb3aa1e@intel.com>
In-Reply-To: <d375fef9-43c4-9f2a-41c9-5247fcb3aa1e@intel.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 2 Jun 2023 08:04:53 -0700
Message-ID: <CAKgT0Uc4UQ=PpVtjUAP=hjTDrWWkc79PeSwp39T6MSpo1ZyOag@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 03/12] iavf: optimize Rx
 buffer allocation a bunch
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Larysa Zaremba <larysa.zaremba@intel.com>, netdev@vger.kernel.org, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-kernel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, Eric Dumazet <edumazet@google.com>, 
	Michal Kubiak <michal.kubiak@intel.com>, intel-wired-lan@lists.osuosl.org, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 7:00=E2=80=AFAM Alexander Lobakin
<aleksander.lobakin@intel.com> wrote:
>
> From: Alexander Duyck <alexander.duyck@gmail.com>
> Date: Wed, 31 May 2023 10:22:18 -0700
>
> > On Wed, May 31, 2023 at 8:14=E2=80=AFAM Alexander Lobakin
> > <aleksander.lobakin@intel.com> wrote:
>
> [...]
>
> >> But not all of these variables are read-only. E.g. NTC is often
> >> modified. Page size was calculated per descriptor, but could be once a
> >> poll cycle starts, and so on.
> >
> > Yeah, the ntc should be carried in the stack. The only reason for
> > using the ring variable was because in the case of ixgbe we had to do
> > some tricks with it to deal with RSC as we were either accessing ntc
> > or the buffer pointed to by the descriptor. I think most of that code
> > has been removed for i40e though.
>
> IAVF was forked off ixgbe as per Jesse's statement :D

Yes, but point is they are forked off the same driver and this code
has fallen a bit behind i40e. Really both should probably have been
updated at the same time.

The fact is everything since igb is more or less based on the same
design. I just kept tweaking it as I moved from one driver to the
next. So in terms of refactoring to use a common library you could
probably go back that far without too much trouble. The only
exceptions to all that are fm10k and igbvf which while being similar
also have some significant design differences that might make it a bit
more difficult.

> [...]
>
> >>> Any specific reason for this? Just wondering if this is meant to
> >>> address some sort of memory pressure issue since it basically just
> >>> means the allocation can go out and try to free other memory.
> >>
> >> Yes, I'm no MM expert, but I've seen plenty of times messages from the
> >> MM folks that ATOMIC shouldn't be used in non-atomic contexts. Atomic
> >> allocation is able to grab memory from some sort of critical reservs a=
nd
> >> all that, and the less we touch them, the better. Outside of atomic
> >> contexts they should not be touched.
> >
> > For our purposes though the Rx path is more-or-less always in
> > interrupt context. That is why it had defaulted to just always using
> > GFP_ATOMIC. For your purposes you could probably leave it that way
> > since you are going to be pulling out most of this code anyway.
>
> That's for Rx path, but don't forget that the initial allocation on ifup
> is done in the process context. That's what the maintainers and
> reviewers usually warn about: to not allocate with %GFP_ATOMIC on ifups.

I can see that for the static values like the queue vectors and rings,
however for the buffers themselves, but I don't see the point in doing
that for the regular buffer allocations. Basically it is adding
overhead for something that should have minimal impact as it usually
happens early on during boot when the memory should be free anyway so
GFP_ATOMIC vs GFP_KERNEL wouldn't have much impact in either case

> [...]
>
> >> The point of budget is to limit the amount of time drivers can spend o=
n
> >> cleaning their rings. Making skb the unit makes the unit very logical
> >> and flexible, but I'd say it should always be solid. Imagine you get a
> >> frame which got spanned across 5 buffers. You spend x5 time (roughly) =
to
> >> build an skb and pass it up the stack vs when you get a linear frame i=
n
> >> one buffer, but according to your logics both of these cases count as =
1
> >> unit, while the amount of time spent differs significantly. I can't sa=
y
> >> that's fair enough.
> >
> > I would say it is. Like I said most of the overhead is the stack, not
> > the driver. So if we are cleaning 5 descriptors but only processing
> > one skb then I would say it is only one unit in terms of budget. This
> > is one of the reasons why we don't charge Tx to the NAPI budget. Tx
> > clean up is extremely lightweight as it is only freeing memory, and in
> > cases of Tx and Rx being mixed can essentially be folded in as Tx
> > buffers could be reused for Rx.
> >
> > If we are wanting to increase the work being done per poll it would
> > make more sense to stick to interrupts and force it to backlog more
> > packets per interrupt so that it is processing 64 skbs per call.
>
> Oh, I feel like I'm starting to agree :D OK, then the following doesn't
> really get out of my head: why do we store skb pointer on the ring then,
> if we count 1 skb as 1 unit, so that we won't leave the loop until the
> EOP? Only to handle allocation failures? But skb is already allocated at
> this point... <confused>

The skb is there to essentially hold the frags. Keep in mind that when
ixgbe was coded up XDP didn't exist yet.

I think there are drivers that are already getting away from this,
such as mvneta, by storing an xdp_buff instead of an skb. In theory we
could do away with most of this and just use a shared_info structure,
but since that exists in the first frag we still need a pointer to the
first frag as well.

Also multi-frag frames are typically not that likely on a normal
network as most of the frames are less than 1514B in length. In
addition as I mentioned before a jumbo frame workload will be less
demanding since the frame rates are so much lower. So when I coded
this up I had optimized for the non-fragged case with the fragmented
case being more of an afterthought needed mostly as exception
handling.

> [...]
>
> >>> What is the test you saw the 2% performance improvement in? Is it
> >>> something XDP related or a full stack test?
> >>
> >> Not XDP, it's not present in this driver at this point :D
> >> Stack test, but without usercopy overhead. Trafgen bombs the NIC, the
> >> driver builds skbs and passes it up the stack, the stack does GRO etc,
> >> and then the frames get dropped on IP input because there's no socket.
> >
> > So one thing you might want to look at would be a full stack test w/
> > something such as netperf versus optimizing for a drop only test.
> > Otherwise that can lead to optimizations that will actually hurt
> > driver performance in the long run.
>
> I was doing some netperf (or that Microsoft's tool, don't remember the
> name) tests, but the problem is that usercopy is such a bottleneck, so
> that you don't notice any optimizations or regressions most of time.
> Also, userspace tools usually just pass huge payload chunks and then the
> drivers GSO them into MTU-sized frames, so you always get line rate and
> that's it. Short frames or interleave/imix (randomly-mix-sized) are the
> most stressful from my experience and are able to show actual outcome.

That is kind of what I figured. So one thing to watch out for is
stating performance improvements without providing context on what
exactly it is you are doing to see that gain. So essentially what we
have is a microbenchmark that is seeing the gain.

Admittedly my goto used to be IPv4 routing since that exercised both
the Tx and Rx path for much the same reason. However one thing you
need to keep in mind is that if you cannot see a gain in the
full-stack test odds are most users may not notice much of an impact.

> >
> >>>
> >>>> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> >>>
> >>> Also one thing I am not a huge fan of is a patch that is really a
> >>> patchset onto itself. With all 6 items called out here I would have
> >>> preferred to see this as 6 patches as it would have been easier to
> >>> review.
> >>
> >> Agree BTW, I'm not a fan of this patch either. I wasn't sure what to d=
o
> >> with it, as splitting it into 6 explodes the series into a monster, bu=
t
> >> proceeding without it increases diffstat and complicates things later
> >> on. I'll try the latter, but will see. 17 patches is not the End of Da=
ys
> >> after all.
> >
> > One thing you may want to consider to condense some of these patches
> > would be to look at possibly combining patches 4 and 5 which disable
> > recycling and use a full 4K page. It seems like of those patches one
> > ends up redoing the other since so many of the dma_sync calls are
> > updated in both.
>
> Or maybe I'll move this one into the subsequent series, since it's only
> pt. 1 of Rx optimizations. There's also the second commit, but it's
> probably as messy as this one and these two could be just converted into
> a series.
>
> [...]
>
> >>> Just a nit. You might want to break this up into two statements like =
I
> >>> had before. I know some people within Intel weren't a huge fan of whe=
n
> >>> I used to do that kind of thing all the time in loops where I would d=
o
> >>> the decrement and test in one line.. :)
> >>
> >> Should I please them or do it as I want to? :D I realize from the
> >> compiler's PoV it's most likely the same, but dunno, why not.
> >
> > If nobody internally is bugging you about it then I am fine with it. I
> > just know back during my era people would complain about that from a
> > maintainability perspective. I guess I got trained to catch those kind
> > of things as a result.
>
> Haha understand. I usually say: "please some good arguments or I didn't
> hear this", maybe that's why nobody complained on `--var` yet :D

Either that or they were already worn down by the time you started
adding this type of stuff.. :)

The one I used to do that would really drive people nuts was:
    for (i =3D loop_count; i--;)

It is more efficient since I don't have to do the comparison to the
loop counter, but it is definitely counterintuitive to run loops
backwards like that. I tried to break myself of the habit of using
those sort of loops anywhere that wasn't performance critical such as
driver init.

> [...]
>
> >> Yes, I'm optimizing all this out later in the series. I was surprised
> >> just as much as you when I saw skb getting passed to do nothing ._.
> >
> > The funny part for me is that it is like reviewing code written via a
> > game of telephone. I recognize the code but have to think about it
> > since there are all the bits of changes and such from the original
> > ixgbe.
>
> Lots of things are still recognizable even in IDPF. That's how this
> series was born... :D

Yep, now the question is how many drivers can be pulled into using
this library. The issue is going to be all the extra features and
workarounds outside of your basic Tx/Rx will complicate the code since
all the drivers implement them a bit differently. One of the reasons
for not consolidating them was to allow for performance optimizing for
each driver. By combining them you are going to likely need to add a
number of new conditional paths to the fast path.


> >
> >> [...]
> >>
> >> Thanks for the detailed reviews, stuff that Intel often lacks :s :D
> >
> > No problem, it was the least I could do since I am responsible for so
> > much of this code in the earlier drivers anyway. If nothing else I
> > figured I could provide a bit of history on why some of this was the
> > way it was.
> These history bits are nice and interesting to read actually! And also
> useful since they give some context and understanding of what is
> obsolete and can be removed/changed.

Yeah, it is easiest to do these sort of refactors when you have
somebody to answer the "why" of most of this. I recall going through
this when I was refactoring the igb/ixgbe drivers back in the day and
having to purge the dead e1000 code throughout. Of course, after this
refactor it will be all yours right?.. :D

