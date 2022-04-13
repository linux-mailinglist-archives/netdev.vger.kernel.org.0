Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF3A4FF9CE
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbiDMPOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbiDMPOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:14:44 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DCC36B55;
        Wed, 13 Apr 2022 08:12:22 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id bo5so2281483pfb.4;
        Wed, 13 Apr 2022 08:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=H4kLRlYqh+cEHp4UJl7kYw3CvvezFl15lGEnEXK57R8=;
        b=N2huUH5eIDpVkRyzaClYWfn9bGkxCuGSN5BYKFAEcnmyGgOLFnU2fOhLIG7rC5XBjb
         G888EkvHm6t4zn9sTRDFQeN2JsLHMj3QJw9uvATEoJvlMLQ3RsHhpjYwYN3HQP5OXAmf
         kdRON/mr7yaEnFeu/DgWHukOkDrEo+pcltTn664c5V6dFE3kQmHS/pMxWP+pezJHlHev
         5UGQvAQWhLj/sepMoxNF3c2ZvyTAa8EQISzIK6P7C5XTXEJpbZkEKwapmB36yRAaTRE6
         E4QnXaAXov5pbLYaLQp+clNmw76Q1Uld8WiTdYtyA/Ill1YVhYOFnHEiSyPSbMXLlWT8
         MBZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H4kLRlYqh+cEHp4UJl7kYw3CvvezFl15lGEnEXK57R8=;
        b=lfR/U3nLLlZ3uhCLWnFGugMrJSSoLHqe+HrcBjUoFJPidxbAnvWag0pWF7yXg/uFqq
         +fFoeA0PcEF3p23YOe29Fb8ebYA2jzJtVpEGTBiWMmjxSrE4MZIs8Cik6GbJjYE6H1kj
         y6SatpLVmWW5mxBvOo8ybdEcbLzI0pCaVhuDtrFRa8VxMagjVvutPeVOCdwJfU7krzgE
         0v8O/OudTj9IunkIxMQdbmEaxRxgISPv3aj856Kv4KlbwUVKxCwp7TKx4foK/hYREcI4
         uY2cqzjoGhJx/1UYMSWplvJbnRJcYdxrgj2JJMwvlVbimCelYRjO8s7SCRWnEfM/Er0e
         wCaQ==
X-Gm-Message-State: AOAM533wuy002/IQLMG9+jRUb9vAdhsHN0NiJl3249inan+bv0CZC6K/
        rQqJgACJiwo7y8lyO5cbOZqX5N5Wie4yu8loqzs=
X-Google-Smtp-Source: ABdhPJyr3ajINb55TTQEM6Dz9lrXCT7bzF+Zntnn+WHMroEc8e13trtF5STxXUix83KHaF93XOHJKhkVjGnQ1pihUHY=
X-Received: by 2002:a05:6a00:1a0a:b0:4fc:d6c5:f3f1 with SMTP id
 g10-20020a056a001a0a00b004fcd6c5f3f1mr44177451pfv.45.1649862741409; Wed, 13
 Apr 2022 08:12:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
 <8a81791e-342e-be8b-fc96-312f30b44be6@nvidia.com> <Yk/7mkNi52hLKyr6@boxer>
 <82a1e9c1-6039-7ead-e663-2b0298f31ada@nvidia.com> <YlRKxh0xKDfOHvgn@boxer> <5864171b-1e08-1b51-026e-5f09b8945076@nvidia.com>
In-Reply-To: <5864171b-1e08-1b51-026e-5f09b8945076@nvidia.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 13 Apr 2022 17:12:09 +0200
Message-ID: <CAJ8uoz3Qwa7M1NtN0x376gsejSd6eVZ0sHYjQbBZtNaG0tOJcg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 00/10] xsk: stop softirq processing on full XSK
 Rx queue
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        netdev@vger.kernel.org, brouer@redhat.com,
        alexandr.lobakin@intel.com, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
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

On Wed, Apr 13, 2022 at 1:40 PM Maxim Mikityanskiy <maximmi@nvidia.com> wro=
te:
>
> On 2022-04-11 18:35, Maciej Fijalkowski wrote:
> > On Fri, Apr 08, 2022 at 03:48:44PM +0300, Maxim Mikityanskiy wrote:
> >> On 2022-04-08 12:08, Maciej Fijalkowski wrote:
> >>> On Thu, Apr 07, 2022 at 01:49:02PM +0300, Maxim Mikityanskiy wrote:
> >>>> On 2022-04-05 14:06, Maciej Fijalkowski wrote:
> >>>>> Hi!
> >>>>>
> >>>>> This is a revival of Bjorn's idea [0] to break NAPI loop when XSK R=
x
> >>>>> queue gets full which in turn makes it impossible to keep on
> >>>>> successfully producing descriptors to XSK Rx ring. By breaking out =
of
> >>>>> the driver side immediately we will give the user space opportunity=
 for
> >>>>> consuming descriptors from XSK Rx ring and therefore provide room i=
n the
> >>>>> ring so that HW Rx -> XSK Rx redirection can be done.
> >>>>>
> >>>>> Maxim asked and Jesper agreed on simplifying Bjorn's original API u=
sed
> >>>>> for detecting the event of interest, so let's just simply check for
> >>>>> -ENOBUFS within Intel's ZC drivers after an attempt to redirect a b=
uffer
> >>>>> to XSK Rx. No real need for redirect API extension.
> >>>>
> >>>
> >>> Hey Maxim!
> >>>
> >>>> I believe some of the other comments under the old series [0] might =
be still
> >>>> relevant:
> >>>>
> >>>> 1. need_wakeup behavior. If need_wakeup is disabled, the expected be=
havior
> >>>> is busy-looping in NAPI, you shouldn't break out early, as the appli=
cation
> >>>> does not restart NAPI, and the driver restarts it itself, leading to=
 a less
> >>>> efficient loop. If need_wakeup is enabled, it should be set on ENOBU=
FS - I
> >>>> believe this is the case here, right?
> >>>
> >>> Good point. We currently set need_wakeup flag for -ENOBUFS case as it=
 is
> >>> being done for failure =3D=3D true. You are right that we shouldn't b=
e
> >>> breaking the loop on -ENOBUFS if need_wakeup flag is not set on xsk_p=
ool,
> >>> will fix!
> >>>
> >>>>
> >>>> 2. 50/50 AF_XDP and XDP_TX mix usecase. By breaking out early, you p=
revent
> >>>> further packets from being XDP_TXed, leading to unnecessary latency
> >>>> increase. The new feature should be opt-in, otherwise such usecases =
suffer.
> >>>
> >>> Anyone performing a lot of XDP_TX (or XDP_PASS, etc) should be using =
the
> >>> regular copy-mode driver, while the zero-copy driver should be used w=
hen most
> >>> packets are sent up to user-space.
> >>
> >> You generalized that easily, but how can you be so sure that all mixed=
 use
> >> cases can live with the much slower copy mode? Also, how do you apply =
your
> >> rule of thumb to the 75/25 AF_XDP/XDP_TX use case? It's both "a lot of
> >> XDP_TX" and "most packets are sent up to user-space" at the same time.
> >
> > We are not aware of a single user that has this use case.
>
> Doesn't mean there aren't any ;)
>
> Back in the original series, Bj=C3=B6rn said it was a valid use case:
>
>  > I'm leaning towards a more explicit opt-in like Max suggested. As Max
>  > pointed out, AF_XDP/XDP_TX is actually a non-insane(!) way of using
>  > AF_XDP zero-copy, which will suffer from the early exit.
>
> https://lore.kernel.org/bpf/75146564-2774-47ac-cc75-40d74bea50d8@intel.co=
m/
>
> What has changed since then?

We now have real use cases and have become wiser ;-).

> In any case, it's a significant behavior change that breaks backward
> compatibility and affects the mentioned use case. Such changes should go
> as opt-in: we have need_wakeup and unaligned chunks as opt-in features,
> so I don't see any reason to introduce a breaking change this time.

In my opinion, the existing flags you mentioned are different. The
unaligned flag changes the format of the descriptor and the
need_wakeup flag can stop the driver so user space needs to explicitly
wake it up. These options really change the uapi and not refactoring
the application for this would really break it, so an opt-in was a
must. What Maciej is suggesting is about changing the performance for
a case that I have never seen (does not mean it does not exist though
because I do not know all users of course, but it is at least
uncommon). Do we want to put an opt-in for every performance change we
commit. I say no. But at some point a performance change might of
course be so large that it is warranted. It should also be for a use
case that exists, or at least we believe exists. I do not think that
is the case for this one. But if someone out there really has this use
case, please let me know and I will be happy to change my opinion.

> > What we do know
> > is that we have a lot of users that care about zero packet loss
> > performance when redirecting to an AF_XDP socket when using the zero-co=
py
> > driver. And this work addresses one of the corner cases and therefore
> > makes ZC driver better overall. So we say, focus on the cases people ca=
re
> > about. BTW, we do have users using mainly XDP_TX, XDP_PASS and
> > XDP_REDIRECT, but they are all using the regular driver for a good reas=
on.
> > So we should not destroy those latencies as you mention.
> >
> >>
> >> At the moment, the application is free to decide whether it wants zero=
copy
> >> XDP_TX or zerocopy AF_XDP, depending on its needs. After your patchset=
 the
> >> only valid XDP verdict on zerocopy AF_XDP basically becomes "XDP_REDIR=
ECT to
> >> XSKMAP". I don't think it's valid to break an entire feature to speed =
up
> >> some very specific use case.
> >
> > We disagree that it 'breaks an entire feature' - it is about hardening =
the
> > driver when user did not come up with an optimal combo of ring sizes vs
> > busy poll budget. Driver needs to be able to handle such cases in a
> > reasonable way.
>
> XDP_TX is a valid verdict on an XSK RX queue, and stopping XDP_TX
> processing for an indefinite time sounds to me as breaking the feature.
>   Improving performance doesn't justify breaking other stuff. It's OK to
> do so if the application explicitly acks that it doesn't care about
> XDP_TX, or (arguably) if it was the behavior from day one.
>
> > What is more, (at least Intel) zero-copy drivers are
> > written in a way that XDP_REDIRECT to XSKMAP is the most probable verdi=
ct
> > that can come out of XDP program. However, other actions are of course
> > supported, so with your arguments, you could even say that we currently
> > treat redir as 'only valid' action, which is not true.
>
> I did not say that, please don't attribute your speculations to me. One
> thing is optimizing for the most likely use case, the other is breaking
> unlikely use cases to improve the likely ones.
>
> > Just note that
> > Intel's regular drivers (copy-mode AF_XDP socket) are optimized for
> > XDP_PASS (as that is the default without an XDP program in place) as th=
at
> > is the most probable verdict for that driver.
> >
> >>
> >> Moreover, in early days of AF_XDP there was an attempt to implement ze=
rocopy
> >> XDP_TX on AF_XDP queues, meaning both XDP_TX and AF_XDP could be zeroc=
opy.
> >> The implementation suffered from possible overflows in driver queues, =
thus
> >> wasn't upstreamed, but it's still a valid idea that potentially could =
be
> >> done if overflows are worked around somehow.
> >>
> >
> > That feature would be good to have, but it has not been worked on and
> > might never be worked on since there seems to be little interest in XDP=
_TX
> > for the zero-copy driver. This also makes your argument about disregard=
ing
> > XDP_TX a bit exaggerated. As we stated before, we have not seen a use c=
ase
> > from a real user for this.
> >
> >>> For the zero-copy driver, this opt in is not
> >>> necessary. But it sounds like a valid option for copy mode, though co=
uld we
> >>> think about the proper way as a follow up to this work?
> >>
> >> My opinion is that the knob has to be part of initial submission, and =
the
> >> new feature should be disabled by default, otherwise we have huge issu=
es
> >> with backward compatibility (if we delay it, the next update changes t=
he
> >> behavior, breaking some existing use cases, and there is no way to wor=
k
> >> around it).
> >>
> >
> > We would not like to introduce knobs for every
> > feature/optimization/trade-off we could think of unless we really have =
to.
> > Let us keep it simple. Zero-copy is optimized for XDP_REDIRECT to an
> > AF_XDP socket. The regular, copy-mode driver is optimized for the case
> > when the packet is consumed by the kernel stack or XDP. That means that=
 we
> > should not introduce this optimization for the regular driver, as you s=
ay,
> > but it is fine to do it for the zero-copy driver without a knob. If we
> > ever introduce this for the regular driver, yes, we would need a knob.
> >
> >>>>
> >>>> 3. When the driver receives ENOBUFS, it has to drop the packet befor=
e
> >>>> returning to the application. It would be better experience if your =
feature
> >>>> saved all N packets from being dropped, not just N-1.
> >>>
> >>> Sure, I'll re-run tests and see if we can omit freeing the current
> >>> xdp_buff and ntc bump, so that we would come back later on to the sam=
e
> >>> entry.
> >>>
> >>>>
> >>>> 4. A slow or malicious AF_XDP application may easily cause an overfl=
ow of
> >>>> the hardware receive ring. Your feature introduces a mechanism to pa=
use the
> >>>> driver while the congestion is on the application side, but no symme=
tric
> >>>> mechanism to pause the application when the driver is close to an ov=
erflow.
> >>>> I don't know the behavior of Intel NICs on overflow, but in our NICs=
 it's
> >>>> considered a critical error, that is followed by a recovery procedur=
e, so
> >>>> it's not something that should happen under normal workloads.
> >>>
> >>> I'm not sure I follow on this one. Feature is about overflowing the X=
SK
> >>> receive ring, not the HW one, right?
> >>
> >> Right. So we have this pipeline of buffers:
> >>
> >> NIC--> [HW RX ring] --NAPI--> [XSK RX ring] --app--> consumes packets
> >>
> >> Currently, when the NIC puts stuff in HW RX ring, NAPI always runs and
> >> drains it either to XSK RX ring or to /dev/null if XSK RX ring is full=
. The
> >> driver fulfills its responsibility to prevent overflows of HW RX ring.=
 If
> >> the application doesn't consume quick enough, the frames will be leake=
d, but
> >> it's only the application's issue, the driver stays consistent.
> >>
> >> After the feature, it's possible to pause NAPI from the userspace
> >> application, effectively disrupting the driver's consistency. I don't =
think
> >> an XSK application should have this power.
> >
> > It already has this power when using an AF_XDP socket. Nothing new. Som=
e
> > examples, when using busy-poll together with gro_flush_timeout and
> > napi_defer_hard_irqs you already have this power. Another example is no=
t
> > feeding buffers into the fill ring from the application side in zero-co=
py
> > mode. Also, application does not have to be "slow" in order to cause th=
e
> > XSK Rx queue overflow. It can be the matter of not optimal budget choic=
e
> > when compared to ring lengths, as stated above.
>
> (*)
>
> > Besides that, you are right, in copy-mode (without busy-poll), let us n=
ot
> > introduce this as this would provide the application with this power wh=
en
> > it does not have it today.
> >
> >>
> >>> Driver picks entries from fill ring
> >>> that were produced by app, so if app is slow on producing those I bel=
ieve
> >>> this would be rather an underflow of ring, we would simply receive le=
ss
> >>> frames. For HW Rx ring actually being full, I think that HW would be
> >>> dropping the incoming frames, so I don't see the real reason to treat=
 this
> >>> as critical error that needs to go through recovery.
> >>
> >> I'll double check regarding the hardware behavior, but it is what it i=
s. If
> >> an overflow moves the queue to the fault state and requires a recovery=
,
> >> there is nothing I can do about that.
>
> I double-checked that, and it seems there is no problem I indicated in
> point 4. In the mlx5e case, if NAPI is delayed, there will be lack of RX
> WQEs, and hardware will start dropping packets, and it's an absolutely
> regular situation. Your arguments above (*) are valid.
>
> >> A few more thoughts I just had: mlx5e shares the same NAPI instance to=
 serve
> >> all queues in a channel, that includes the XSK RQ and the regular RQ. =
The
> >> regular and XSK traffic can be configured to be isolated to different
> >> channels, or they may co-exist on the same channel. If they co-exist, =
and
> >> XSK asks to pause NAPI, the regular traffic will still run NAPI and dr=
op 1
> >> XSK packet per NAPI cycle, unless point 3 is fixed. It can also be
> >
> > XSK does not pause the whole NAPI cycle, your HW XSK RQ just stops with
> > doing redirects to AF_XDP XSK RQ. Your regular RQ is not affected in an=
y
> > way. Finally point 3 needs to be fixed.
> >
> > FWIW we also support having a channel/queue vector carrying more than o=
ne
> > RQ that is associated with particular NAPI instance.
> >
> >> reproduced if NAPI is woken up by XSK TX. Besides, (correct me if I'm =
wrong)
> >> your current implementation introduces extra latency to XSK TX if XSK =
RX
> >> asked to pause NAPI, because NAPI will be restarted anyway (by TX wake=
up),
> >> and it could have been rescheduled by the kernel.
> >
> > Again, we don't pause NAPI. Tx and Rx processing are separate.
> >
> > As for Intel drivers, Tx is processed first. So even if we break at Rx =
due
> > to -ENOBUFS from xdp_do_redirect(), Tx work has already been done.
> >
> > To reiterate, we agreed on fixing point 1 and 3 from your original mail=
.
> > Valid and good points.
>
> Great that we agreed on 1 and 3! Point 4 can be dropped. For point 2, I
> wrote my thoughts above.
>
> >>
> >>> Am I missing something? Maybe I have just misunderstood you.
> >>>
> >>>>
> >>>>> One might ask why it is still relevant even after having proper bus=
y
> >>>>> poll support in place - here is the justification.
> >>>>>
> >>>>> For xdpsock that was:
> >>>>> - run for l2fwd scenario,
> >>>>> - app/driver processing took place on the same core in busy poll
> >>>>>      with 2048 budget,
> >>>>> - HW ring sizes Tx 256, Rx 2048,
> >>>>>
> >>>>> this work improved throughput by 78% and reduced Rx queue full stat=
istic
> >>>>> bump by 99%.
> >>>>>
> >>>>> For testing ice, make sure that you have [1] present on your side.
> >>>>>
> >>>>> This set, besides the work described above, also carries also
> >>>>> improvements around return codes in various XSK paths and lastly a =
minor
> >>>>> optimization for xskq_cons_has_entries(), a helper that might be us=
ed
> >>>>> when XSK Rx batching would make it to the kernel.
> >>>>
> >>>> Regarding error codes, I would like them to be consistent across all
> >>>> drivers, otherwise all the debuggability improvements are not useful=
 enough.
> >>>> Your series only changed Intel drivers. Here also applies the backwa=
rd
> >>>> compatibility concern: the same error codes than were in use have be=
en
> >>>> repurposed, which may confuse some of existing applications.
> >>>
> >>> I'll double check if ZC drivers are doing something unusual with retu=
rn
> >>> values from xdp_do_redirect(). Regarding backward comp, I suppose you
> >>> refer only to changes in ndo_xsk_wakeup() callbacks as others are not
> >>> exposed to user space? They're not crucial to me, but it improved my
> >>> debugging experience.
> >>
> >> Sorry if I wasn't clear enough. Yes, I meant the wakeup error codes. W=
e
> >> aren't doing anything unusual with xdp_do_redirect codes (can't say fo=
r
> >> other drivers, though).
> >>
> >> Last time I wanted to improve error codes returned from some BPF helpe=
rs
> >> (make the errors more distinguishable), my patch was blocked because o=
f
> >> backward compatibility concerns. To be on the safe side (i.e. to avoid
> >> further bug reports from someone who actually relied on specific codes=
), you
> >> might want to use a new error code, rather than repurposing the existi=
ng
> >> ones.
> >>
> >> I personally don't have objections about changing the error codes the =
way
> >> you did if you keep them consistent across all drivers, not only Intel=
 ones.
> >
> > Got your point. So I'll either drop the patches or look through
> > ndo_xsk_wakeup() implementations and try to standardize the ret codes.
> > Hope this sounds fine.
>
> Yes, either way sounds absolutely fine to me.
>
> >
> > MF
>
