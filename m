Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2D1325587
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 19:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhBYSci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 13:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbhBYSak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 13:30:40 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95087C061756
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 10:29:59 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id p186so6386614ybg.2
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 10:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AqF408g6MIDAsETeQgfjcLCXziMt/ml1xjpYexVqQBE=;
        b=HdA10okeBoL0j8mIMkYaDltt4UwU321mQhWojyym3qnUCtbZhMEMNnXokSvudY1HX5
         vWIYp/lzXqVCndjAOzXUCGhHFAPnBWV8/jTfvzCJlWtQ9JPzFchWt26dR9F3jqq16vxn
         xWMFPwKfZ15u/lwh6/uGYWwPKLGiBVYskMo0VfLY2JlycA7xdii/irqqeMd6EVmm9bSS
         iv83GCJFN9o2nshGCVUQUKIFcoLSRofv1P1U2P+oe4IyE6dQ8jVXqOlQtEQ1hAio9NBe
         07ZYEabhPIL+EvqxHrKxkGizihAJ75E+v7HY0CoiBLwg27uTp9WGYiKMp4LOqpdybpOi
         z34g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AqF408g6MIDAsETeQgfjcLCXziMt/ml1xjpYexVqQBE=;
        b=oWcqmULBTF1kmxWb5BuRu8yY5lDASMYucmIiRWPS1rUzo2CNwJRDual+Wf8mo40TVy
         mhA+7XCAlxY0AFV+wreWmhfxNyQrHhSDhqCUpTzPiVlvHxwpAoTjwYnOzJgS0JLJCmYI
         wYxLCKCCCkRDHaPZD0tz3HEaCz2+HHaKr0t2tKdzSgeOKJUshXg6S8rb7KcnBSad1Lgw
         bhB7BRqbwlVBl94WmpW71BpKxdP+WQlEoXVFxLROG7/pDtt/0Tad6uCxhYh9OdMJYmMK
         YBLz5Y2KdsI/2Lp+yhaW237MGC8Ebk/Wj3pnlxQhrmhEHcuFMuvVf9O57MhC4yXHarI8
         tp9A==
X-Gm-Message-State: AOAM532W/8XwH2GZANBJcNoGx6b3HpWyKgFXHfqwWoVUO8WCvtlpZxAZ
        vvf8VsgK++946ogZpO4lCV5jxgZwf6Howcy/q2c/Aw==
X-Google-Smtp-Source: ABdhPJxIugORhEL+GYXNH6TBS9tzsB2ddrzDQmVhiuKeLVBBgQXnjUFuWk8HSZ4qkJygBaIY2W7yFwNIAc1FTeqG8iA=
X-Received: by 2002:a25:3b92:: with SMTP id i140mr6293080yba.187.1614277798651;
 Thu, 25 Feb 2021 10:29:58 -0800 (PST)
MIME-Version: 1.0
References: <20210223234130.437831-1-weiwan@google.com> <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
 <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
 <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
 <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
 <20210224162059.7949b4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR15MB27873FF52B109480173366B8BD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
 <20210224180329.306b2207@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_CEz-CaK_rCyGzRA8=WNspu2Uia5UasJ266f=p5uiqYkw@mail.gmail.com> <20210225002115.5f6215d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210225002115.5f6215d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Thu, 25 Feb 2021 10:29:47 -0800
Message-ID: <CAEA6p_DdccvmymRWEtggHgqb9dQ6NjK8rsrA03HH+r7mzt=5uw@mail.gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 12:21 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 24 Feb 2021 18:31:55 -0800 Wei Wang wrote:
> > On Wed, Feb 24, 2021 at 6:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Thu, 25 Feb 2021 01:22:08 +0000 Alexander Duyck wrote:
> > > > Yeah, that was the patch Wei had done earlier. Eric complained abou=
t the extra set_bit atomic operation in the threaded path. That is when I c=
ame up with the idea of just adding a bit to the busy poll logic so that th=
e only extra cost in the threaded path was having to check 2 bits instead o=
f 1.
> > >
> > > Maybe we can set the bit only if the thread is running? When thread
> > > comes out of schedule() it can be sure that it has an NAPI to service=
.
> > > But when it enters napi_thread_wait() and before it hits schedule()
> > > it must be careful to make sure the NAPI is still (or already in the
> > > very first run after creation) owned by it.
> >
> > Are you suggesting setting the SCHED_THREAD bit in napi_thread_wait()
> > somewhere instead of in ____napi_schedule() as you previously plotted?
> > What does it help? I think if we have to do an extra set_bit(), it
> > seems cleaner to set it in ____napi_schedule(). This would solve the
> > warning issue as well.
>
> I was thinking of something roughly like this:
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index ddf4cfc12615..3bce94e8c110 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -360,6 +360,7 @@ enum {
>         NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() owns this NAPI =
*/
>         NAPI_STATE_PREFER_BUSY_POLL,    /* prefer busy-polling over softi=
rq processing*/
>         NAPI_STATE_THREADED,            /* The poll is performed inside i=
ts own thread*/
> +       NAPI_STATE_SCHED_THREAD,        /* Thread owns the NAPI and will =
poll */
>  };
>
>  enum {
> @@ -372,6 +373,7 @@ enum {
>         NAPIF_STATE_IN_BUSY_POLL        =3D BIT(NAPI_STATE_IN_BUSY_POLL),
>         NAPIF_STATE_PREFER_BUSY_POLL    =3D BIT(NAPI_STATE_PREFER_BUSY_PO=
LL),
>         NAPIF_STATE_THREADED            =3D BIT(NAPI_STATE_THREADED),
> +       NAPIF_STATE_SCHED_THREAD        =3D BIT(NAPI_STATE_SCHED_THREAD),
>  };
>
>  enum gro_result {
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 6c5967e80132..852b992d0ebb 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4294,6 +4294,8 @@ static inline void ____napi_schedule(struct softnet=
_data *sd,
>                  */
>                 thread =3D READ_ONCE(napi->thread);
>                 if (thread) {
> +                       if (thread->state =3D=3D TASK_RUNNING)
> +                               set_bit(NAPIF_STATE_SCHED_THREAD, &napi->=
state);
>                         wake_up_process(thread);
>                         return;
>                 }
> @@ -6486,7 +6488,8 @@ bool napi_complete_done(struct napi_struct *n, int =
work_done)
>                 WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
>
>                 new =3D val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
> -                             NAPIF_STATE_PREFER_BUSY_POLL);
> +                             NAPIF_STATE_PREFER_BUSY_POLL |
> +                             NAPIF_STATE_SCHED_THREAD);
>
>                 /* If STATE_MISSED was set, leave STATE_SCHED set,
>                  * because we will call napi->poll() one more time.
> @@ -6968,16 +6971,24 @@ static int napi_poll(struct napi_struct *n, struc=
t list_head *repoll)
>
>  static int napi_thread_wait(struct napi_struct *napi)
>  {
> +       bool woken =3D false;
> +
>         set_current_state(TASK_INTERRUPTIBLE);
>
>         while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> -               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> +               unsigned long state =3D READ_ONCE(napi->state);
> +
> +               if ((state & NAPIF_STATE_SCHED) &&
> +                   ((state & NAPIF_STATE_SCHED_THREAD) || woken)) {
>                         WARN_ON(!list_empty(&napi->poll_list));
>                         __set_current_state(TASK_RUNNING);
>                         return 0;
> +               } else {
> +                       WARN_ON(woken);
>                 }
>
>                 schedule();
> +               woken =3D true;
>                 set_current_state(TASK_INTERRUPTIBLE);
>         }
>         __set_current_state(TASK_RUNNING);
>
>
> Extra set_bit() is only done if napi_schedule() comes early enough to
> see the thread still running. When the thread is woken we continue to
> assume ownership.
>
> It's just an idea (but it may solve the first run and the disable case).

Hmm... I don't think the above patch would work. Consider a situation that:
1. At first, the kthread is in sleep mode.
2. Then someone calls napi_schedule() to schedule work on this napi.
So ____napi_schedule() is called. But at this moment, the kthread is
not yet in RUNNING state. So this function does not set SCHED_THREAD
bit.
3. Then wake_up_process() is called to wake up the thread.
4. Then napi_threaded_poll() calls napi_thread_wait(). woken is false
and SCHED_THREAD bit is not set. So the kthread will go to sleep again
(in INTERRUPTIBLE mode) when schedule() is called, and waits to be
woken up by the next napi_schedule().
That will introduce arbitrary delay for the napi->poll() to be called.
Isn't it? Please enlighten me if I did not understand it correctly.

I personally prefer to directly set SCHED_THREAD bit in ____napi_schedule()=
.
Or stick with SCHED_BUSY_POLL solution and replace kthread_run() with
kthread_create().
