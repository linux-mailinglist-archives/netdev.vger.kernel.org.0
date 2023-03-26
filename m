Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBEC6C9802
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 23:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjCZVXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 17:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCZVXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 17:23:21 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335051701
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 14:23:20 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id y19so4009461pgk.5
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 14:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679865799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=389jz7AIDmNzyKbIOO0NZm5fjKmloXHOgtPsRxrNPwk=;
        b=OeaUdpmdZLPZYis+uxV3odsEm0QmYv0T082K0m/TYHHi1thYdUfyGqR5sOj1nFA9pZ
         ZyfNdseigwg03lEIBFssBObnrGADlD/LM9u+lrszOLclmD1H4P0+C0cAEBOziHkLBV+E
         N2k5136gwNX3faXSwJHK2K8X7iFj6xho3MJ1y08qc7ajL1jjWyn9NR0hK988JVjKF9xC
         0UeLg4EqSM9e0QZabqvDQCh9maKhgVG8JkEaScvXB+sbi01SeBLABZJfCJiGAJqHnCcd
         KIVT0cpXzR6IbVdVPfKsQH8RxL8B60T/jxCRq8yt3sH6mIjB4G2Pim/wITlZHxZmC6V1
         Mk5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679865799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=389jz7AIDmNzyKbIOO0NZm5fjKmloXHOgtPsRxrNPwk=;
        b=nlv8/932DxWHJ6D3aRq8c7PiRwXoI/XgOJZRxDOKchpid/v20nteutpzYqrxupemhE
         9CQpTm8Ta7JHWcbIl9PuVmFRqwtvi5guHQhh30xAUaI/lxNwhQZJObJ3fHhj87jBnGcg
         Jk4N8pYrshd8otL+coomQ+tHb6wSZHMlwb2kSdWqkWFzGwTDSAib/zK43PE3LwmjcMRJ
         3PHkVbsNk1YAPD2dpPo4ZihWcwiSkg4YA45hlO7WOAJVxw//ckRGroR0xYLfjfM/eees
         ol5Hs2KAmnn2cMmRzxhQDM9UY+cYDXbOLnjHdvhg5SckKRGnJeBeJLelwHVExfvOw55V
         931A==
X-Gm-Message-State: AAQBX9fk5NOH/Ga3lMddqomfwt2berU6FvCEpTgjysMXKu/A4zNzkuOy
        EIJde+gKaJRe4/61REu6gORtFxvGrvgNPjy0fRI=
X-Google-Smtp-Source: AKy350bshpUHrj+o+PhktnW6EomTdohUACXrD4fnQNoTz6taTW6M3A+RT0wXu8nFYBYnOAX5nZ3LnaEh/rXHBfabnXo=
X-Received: by 2002:a05:6a00:1344:b0:625:a545:3292 with SMTP id
 k4-20020a056a00134400b00625a5453292mr4874509pfu.0.1679865799329; Sun, 26 Mar
 2023 14:23:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230322233028.269410-1-kuba@kernel.org> <5060c11df10c66f56b5ca7ec2ec92333252b084b.camel@gmail.com>
 <20230323200932.7cf30af5@kernel.org> <CAKgT0Ufv5Te668Y_tszQfuH0g_Zsn=oErQ8gAfX6FwHRUm+H3A@mail.gmail.com>
 <20230324142820.61e4f0b6@kernel.org>
In-Reply-To: <20230324142820.61e4f0b6@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sun, 26 Mar 2023 14:23:07 -0700
Message-ID: <CAKgT0Ufoy2WM3=aMNOdq2PFYL8AH9QSs=QrP_Xx59uouTnKLJg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, willemb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 2:28=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Fri, 24 Mar 2023 08:45:23 -0700 Alexander Duyck wrote:
> > On Thu, Mar 23, 2023 at 8:09=E2=80=AFPM Jakub Kicinski <kuba@kernel.org=
> wrote:
> > > > We may want to change the values here. The most likely case is "lef=
t
> > > > enabled" with that being the case we probably want to make that the=
 0
> > > > case. I would then probably make 1 the re-enabled case and -1 the
> > > > stopped case.
> > >
> > > I chose the return values this way because the important information =
is
> > > whether the queue was in fact stopped (in case the macro is used at t=
he
> > > start of .xmit as a safety check). If stopped is zero caller can chec=
k
> > > !ret vs !!ret.
> > >
> > > Seems pretty normal for the kernel function called stop() to return 0
> > > if it did stop.
> >
> > Except this isn't "stop", this is "maybe stop".
>
> So the return value from try_stop and maybe_stop would be different?
> try_stop needs to return 0 if it stopped - the same semantics as
> trylock(), AFAIR. Not that I love those semantics, but it's a fairly
> strong precedent.

The problem is this isn't a lock. Ideally with this we aren't taking
the action. So if anything this functions in my mind more like the
inverse where if this does stop we have to abort more like trylock
failing.

This is why I mentioned that maybe this should be renamed. I view this
more as a check to verify we are good to proceed. In addition there is
the problem that there are 3 possible outcomes with maybe_stop versus
the two from try_stop.

> > Maybe we should just
> > do away with the stop/wake messaging and go with something such as a
> > RTS/CTS type setup. Basically this function is acting as a RTS to
> > verify that we have room on the ring to place the frame. If we don't
> > we are stopped. The "wake" function is on what is essentially the
> > receiving end on the other side of the hardware after it has DMAed the
> > frames and is providing the CTS signal back.
>
> I'm definitely open to different naming but wouldn't calling RTS _after_
> send be even more confusing than maybe_stop?

We don't call maybe_stop after the send. For that we would be calling
try_stop. The difference being in the case of maybe_stop we might have
to return busy.

> > > > With that the decision tree becomes more straightforward as we woul=
d do
> > > > something like:
> > > >       if (result) {
> > > >               if (result < 0)
> > > >                       Increment stopped stat
> > > >                       return
> > > >               else
> > > >                       Increment restarted stat
> > > >       }
> > >
> > > Do you see a driver where it matters? ixgbe and co. use
> > > netif_tx_queue_try_stop() and again they just test stopped vs not sto=
pped.
> >
> > The thing is in order to make this work for the ixgbe patch you didn't
> > use the maybe_stop instead you went with the try_stop. If you replaced
> > the ixgbe_maybe_stop_tx with your maybe stop would have to do
> > something such as the code above to make it work. That is what I am
> > getting at. From what I can tell the only real difference between
> > ixgbe_maybe_stop_tx and your maybe_stop is that you avoided having to
> > move the restart_queue stat increment out.
>
> I can convert ixgbe further, true, but I needed the try_stop, anyway,
> because bnxt does:
>
> if (/* need to stop */) {
>         if (xmit_more())
>                 flush_db_write();
>         netif_tx_queue_try_stop();
> }
>
> which seems reasonable.

I wasn't saying we didn't need try_stop. However the logic here
doesn't care about the return value. In the ixgbe case we track the
queue restarts so we would want a 0 on success and a non-zero if we
have to increment the stat. I would be okay with the 0 (success) / -1
(queue restarted) in this case.

> > The general thought is I would prefer to keep it so that 0 is the
> > default most likely case in both where the queue is enabled and is
> > still enabled. By moving the "take action" items into the 1/-1 values
> > then it becomes much easier to sort them out with 1 being a stat
> > increment and -1 being an indication to stop transmitting and prep for
> > watchdog hang if we don't clear this in the next watchdog period.
>
> Maybe worth taking a step back - the restart stat which ixgbe
> maintains made perfect sense when you pioneered this approach but
> I think we had a decade of use, and have kprobes now, so we don't
> really need to maintain a statistic for a condition with no impact
> to the user? New driver should not care 1 vs -1..

Actually the restart_queue stat is VERY useful for debugging. It tells
us we are seeing backlogs develop in the Tx queue. We track it any
time we wake up the queue, not just in the maybe_stop case.

WIthout that we are then having to break out kprobes and the like
which we could only add after-the-fact which makes things much harder
to debug when issues occur. For example, a common case to use it is to
monitor it when we see a system with slow Tx connections. With that
stat we can tell if we are building a backlog in the qdisc or if it is
something else such as a limited amount of socket memory is limiting
the transmits.

> > Also in general it makes it easier to understand if these all work
> > with the same logic.
> >
> > > > In addition for readability we may want consider adding an enum sim=
liar
> > > > to the netdev_tx enum as then we have the return types locked and
> > > > usable should we want to specifically pick out one.
> > >
> > > Hm, I thought people generally dislike the netdev_tx enum.
> > > Maybe it's just me.
> >
> > The thought I had with the enum is to more easily connect the outcomes
> > with the sources. It would also help to prevent any confusion on what
> > is what. Having the two stop/wake functions return different values is
> > a potential source for errors since 0/1 means different things in the
> > different functions. Basically since we have 3 possible outcomes using
> > the enum would make it very clear what the mapping is between the two.
>
> IMO only two outcomes matter in practice (as mentioned above).
> I really like the ability to treat the return value as a bool, if only
> we had negative zero we would have a perfect compromise :(

I think we are just thinking about two different things. I am focusing
on the "maybe" calls that have 3 outcomes whereas I think you are
mostly focused on the "try" calls. My thought is to treat it something
like the msix allocation calls where a negative indicates a failure
forcing us to stop since the ring is full, 0 is a success, and a value
indicates that there are resources but they are/were limited.
