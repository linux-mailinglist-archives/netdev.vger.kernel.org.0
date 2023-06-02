Return-Path: <netdev+bounces-7520-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C22BA720897
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:50:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 791E1281A2E
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 912B0156D2;
	Fri,  2 Jun 2023 17:50:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C194332EE
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 17:50:42 +0000 (UTC)
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A02123;
	Fri,  2 Jun 2023 10:50:40 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-2567b589d3bso1113563a91.0;
        Fri, 02 Jun 2023 10:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685728240; x=1688320240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z91DLnpoPlNz6AamPO/8RlSZuuiyPUDzdRzPymj+jt4=;
        b=Z8ELG4fdU8EkmBq51XsCLxMwQdIgMYeDZOgaV1ZsIxKIMejSMpd49X0/0uUYP4mgwd
         /KJXeq83dSJrqPMnkNEGo1J06NwPwUz5d6DSwyfOtNMT9Nr/5TgwTrX3FwkC1EYFlMdO
         FJWSIMseFUnr7xZiQQ7Gj8esyrkiTrmJNwpFg/NEGSOyS9iROde/N6W+2+ISj6uZteYH
         831M1EQxGPnVzRmDbcNr46P6puKVLbK1j2lok5Gub2YL2DD9s94l+xw8VJk9xJcCY9Nc
         9keXzTxBqxFmhFj2WOu6IbWXLnqdgXhvD39+dCFWiad1oxQ2Z/7emH/dx6bwCI/VvHG8
         iMDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685728240; x=1688320240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z91DLnpoPlNz6AamPO/8RlSZuuiyPUDzdRzPymj+jt4=;
        b=WEKnqkEDeZjs0kI0ESIg6MvzaJOWT8paSJQRvHTp4fL5NMNXXpRZQfMOqInnKJV45k
         9JK+LoP2iyurQXtqWOa/S13LDsCBOJ7mLS9DeGTYLhXdEJ4+APiP85UZ93jJVGrwahMh
         qwYTrtNV7lWRTqUUXtGDuDPARVTM5iP7R9I2kMjkpZCrdoPoEy8bJ40nBTx57KRU3r6s
         2ShuxkFor8pcjk7RTM898jZZTXY3Z30rnJExeBV3kHrhKoNzkSBaRn4AUax5tAw0bShU
         hdqgKA+UMp/zCf1Xo1kg4wVmrkyTVnVg8FrSrKWpO63uzvKa3poOK9Z/u9Gdya38VamB
         S/lQ==
X-Gm-Message-State: AC+VfDxpCGSwDWKjqz6jsYo5PwsqOvp3+kAZP0936mDuKKeQTZgF6zdW
	wwvF04eXgPt+8UBsCUnrefBhzoX/KGj5wokMU8I=
X-Google-Smtp-Source: ACHHUZ41Puoke7rDAyqfBaCXf/hZJ4YHB+JtqWVbz1qa+XyyE/1KsTXNJTHdtYT3KRjdR4k4BjZ3F0TxUClVv1ZYtLw=
X-Received: by 2002:a17:90a:ea01:b0:253:61f3:d675 with SMTP id
 w1-20020a17090aea0100b0025361f3d675mr527338pjy.30.1685728239377; Fri, 02 Jun
 2023 10:50:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230525125746.553874-1-aleksander.lobakin@intel.com>
 <20230525125746.553874-4-aleksander.lobakin@intel.com> <8828262f1c238ab28be9ec87a7701acd791af926.camel@gmail.com>
 <cb7d3479-63a5-31b4-355d-b12a7e1b2878@intel.com> <CAKgT0Ud204CiJeB-5zcTKdrv7ODrfP09t73CqRhps7g3qhWU5w@mail.gmail.com>
 <d375fef9-43c4-9f2a-41c9-5247fcb3aa1e@intel.com> <CAKgT0Uc4UQ=PpVtjUAP=hjTDrWWkc79PeSwp39T6MSpo1ZyOag@mail.gmail.com>
 <cd88ac7e-fe82-fdc0-3410-0decf57d3c43@intel.com>
In-Reply-To: <cd88ac7e-fe82-fdc0-3410-0decf57d3c43@intel.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 2 Jun 2023 10:50:02 -0700
Message-ID: <CAKgT0UeEz2Gqb62sn0pP3_yBMc-LpR0Twmv5_HTREvHBLpCsNw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 03/12] iavf: optimize Rx
 buffer allocation a bunch
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Larysa Zaremba <larysa.zaremba@intel.com>, netdev@vger.kernel.org, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-kernel@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Michal Kubiak <michal.kubiak@intel.com>, intel-wired-lan@lists.osuosl.org, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Christoph Hellwig <hch@lst.de>, 
	Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 9:16=E2=80=AFAM Alexander Lobakin
<aleksander.lobakin@intel.com> wrote:
>
> From: Alexander Duyck <alexander.duyck@gmail.com>
> Date: Fri, 2 Jun 2023 08:04:53 -0700
>
> > On Fri, Jun 2, 2023 at 7:00=E2=80=AFAM Alexander Lobakin
> > <aleksander.lobakin@intel.com> wrote:
>
> [...]
>
> >> That's for Rx path, but don't forget that the initial allocation on if=
up
> >> is done in the process context. That's what the maintainers and
> >> reviewers usually warn about: to not allocate with %GFP_ATOMIC on ifup=
s.
> >
> > I can see that for the static values like the queue vectors and rings,
> > however for the buffers themselves, but I don't see the point in doing
> > that for the regular buffer allocations. Basically it is adding
> > overhead for something that should have minimal impact as it usually
> > happens early on during boot when the memory should be free anyway so
> > GFP_ATOMIC vs GFP_KERNEL wouldn't have much impact in either case
>
> Queue vectors and rings get allocated earlier than buffers, on device
> probing :D ifup happens later and it depends on the networking scripts
> etc. -- now every init system enables all the interfaces when booting up
> like systemd does. Plus, ifdowns-ifups can occur during the normal
> system functioning -- resets, XDP setup/remove, Ethtool configuration,
> and so on. I wouldn't say Rx buffer allocation happens only on early boot=
.

I agree it isn't only on early boot, but that is the most common case.
The rings and such tend to get allocated early and unless there is a
need for some unforeseen change the rings typically are not modified.

I just don't see the point of special casing the allocations since if
they fail we will be turning around and just immediately calling the
GFP_ATOMIC version within 2 seconds anyway to try and fill out the
empty rings.

> >> Oh, I feel like I'm starting to agree :D OK, then the following doesn'=
t
> >> really get out of my head: why do we store skb pointer on the ring the=
n,
> >> if we count 1 skb as 1 unit, so that we won't leave the loop until the
> >> EOP? Only to handle allocation failures? But skb is already allocated =
at
> >> this point... <confused>
> >
> > The skb is there to essentially hold the frags. Keep in mind that when
> > ixgbe was coded up XDP didn't exist yet.
>
> Ok, maybe I phrased it badly.
> If we don't stop the loop until skb is passed up the stack, how we can
> go out of the loop with an unfinished skb? Previously, I thought lots of
> drivers do that, as you may exhaust your budget prior to reaching the
> last fragment, so you'll get back to the skb on the next poll.
> But if we count 1 skb as budget unit, not descriptor, how we can end up
> breaking the loop prior to finishing the skb? I can imagine only one
> situation: HW gave us some buffers, but still processes the EOP buffer,
> so we don't have any more descriptors to process, but the skb is still
> unfinished. But sounds weird TBH, I thought HW processes frames
> "atomically", i.e. it doesn't give you buffers until they hold the whole
> frame :D

The problem is the frames aren't necessarily written back atomically.
One big issue is descriptor write back. The hardware will try to cache
line optimize things in order to improve performance. It is possible
for a single frame to straddle either side of a cache line. As a
result the first half may be written back, the driver then processes
that cache line, and finds the next one isn't populated while the
hardware is collecting enough descriptors to write back the next one.

It is also one of the reasons why I went to so much effort to prevent
us from writing to the descriptor ring in the cleanup paths. You never
know when you might be processing an earlier frame and accidently
wander into a section that is in the process of being written. I think
that is addressed now mostly through the use of completion queues
instead of the single ring that used to process both work and
completions.

> >
> > I think there are drivers that are already getting away from this,
> > such as mvneta, by storing an xdp_buff instead of an skb. In theory we
> > could do away with most of this and just use a shared_info structure,
> > but since that exists in the first frag we still need a pointer to the
> > first frag as well.
>
> ice has xdp_buff on the ring for XDP multi-buffer. It's more lightweight
> than skb, but also carries the frags, since frags is a part of shinfo,
> not skb.
> It's totally fine and we'll end up doing the same here, my question was
> as I explained below.

Okay. I haven't looked at ice that closely so I wasn't aware of that.

> >
> > Also multi-frag frames are typically not that likely on a normal
> > network as most of the frames are less than 1514B in length. In
> > addition as I mentioned before a jumbo frame workload will be less
> > demanding since the frame rates are so much lower. So when I coded
> > this up I had optimized for the non-fragged case with the fragmented
> > case being more of an afterthought needed mostly as exception
> > handling.
>
> [...]
>
> > That is kind of what I figured. So one thing to watch out for is
> > stating performance improvements without providing context on what
> > exactly it is you are doing to see that gain. So essentially what we
> > have is a microbenchmark that is seeing the gain.
> >
> > Admittedly my goto used to be IPv4 routing since that exercised both
> > the Tx and Rx path for much the same reason. However one thing you
> > need to keep in mind is that if you cannot see a gain in the
> > full-stack test odds are most users may not notice much of an impact.
>
> Yeah sure. I think more than a half of optimizations in such drivers
> nowadays is unnoticeable to end users :D
>
> [...]
>
> > Either that or they were already worn down by the time you started
> > adding this type of stuff.. :)
> >
> > The one I used to do that would really drive people nuts was:
> >     for (i =3D loop_count; i--;)
>
> Oh, nice one! Never thought of something like that hehe.
>
> >
> > It is more efficient since I don't have to do the comparison to the
> > loop counter, but it is definitely counterintuitive to run loops
> > backwards like that. I tried to break myself of the habit of using
> > those sort of loops anywhere that wasn't performance critical such as
> > driver init.
>
> [...]
>
> > Yep, now the question is how many drivers can be pulled into using
> > this library. The issue is going to be all the extra features and
> > workarounds outside of your basic Tx/Rx will complicate the code since
> > all the drivers implement them a bit differently. One of the reasons
> > for not consolidating them was to allow for performance optimizing for
> > each driver. By combining them you are going to likely need to add a
> > number of new conditional paths to the fast path.
>
> When I was counting the number of spots in the Rx polling function that
> need to have switch-cases/ifs in order to be able to merge the code
> (e.g. parsing the descriptors), it was something around 4-5 (per
> packet). So it can only be figured out during the testing whether adding
> new branches actually hurts there.

The other thing is you may want to double check CPU(s) you are
expected to support as last I knew switch statements were still
expensive due to all the old spectre/meltdown workarounds.

> XDP is relatively easy to unify in one place, most of code is
> software-only. Ring structures are also easy to merge, wrapping a couple
> driver-specific pointers into static inline accessors. Hotpath in
> general is the easiest part, that's why I started from it.
>
> But anyway, I'd say if one day I'd have to choice whether to remove 400
> locs per driver with having -1% in synthetic tests or not do that at
> all, I'd go for the former. As discussed above, it's very unlikely for
> such changes to hurt real workloads, esp. with usercopy.

+1 assuming no serious regressions.

> >
> >
> >>>
> >>>> [...]
> >>>>
> >>>> Thanks for the detailed reviews, stuff that Intel often lacks :s :D
> >>>
> >>> No problem, it was the least I could do since I am responsible for so
> >>> much of this code in the earlier drivers anyway. If nothing else I
> >>> figured I could provide a bit of history on why some of this was the
> >>> way it was.
> >> These history bits are nice and interesting to read actually! And also
> >> useful since they give some context and understanding of what is
> >> obsolete and can be removed/changed.
> >
> > Yeah, it is easiest to do these sort of refactors when you have
> > somebody to answer the "why" of most of this. I recall going through
> > this when I was refactoring the igb/ixgbe drivers back in the day and
> > having to purge the dead e1000 code throughout. Of course, after this
> > refactor it will be all yours right?.. :D
>
> Nope, maybe from the git-blame PoV only :p
>
> Thanks,
> Olek

