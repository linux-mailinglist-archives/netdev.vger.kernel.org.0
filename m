Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFC312B5C6
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 17:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfL0QHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 11:07:32 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38730 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfL0QHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 11:07:32 -0500
Received: by mail-ot1-f65.google.com with SMTP id d7so32420380otf.5
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 08:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d57aeGztFkcbBHYV8hz2MRIY7RJ+WugJJ0gcXv1Gns0=;
        b=IXfnuW+1HzaFv+OfPm22FORI8JATgyExaj/oztF8OwIUuRUL+C/CxSuIwQpBUKgRTV
         +sgAd+zWFLMvuFAYgq0HIXhdKHll2S2mmBwl58dvJdU0krPjGhajc90T/+w/s2PWXtF+
         HeI7f9DJKdcm6e2ULJiMqyY/WfTbJu2Uz36BpHCsh8XJJZHE9mXojfl7066WOdUzrfvS
         9wcSXV4MzATl+2sO3Y49pFLHJER3V7Cv2U0wFMPdAa9Yks4YJ9M4IKbl5MWkEfClNQXz
         ezvIghAa1g2vXiUYpMajs5zZgaDPflhuIJI2Pg4uQuJtGTXx76SP3f/pTostMy9Y8koy
         /5ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d57aeGztFkcbBHYV8hz2MRIY7RJ+WugJJ0gcXv1Gns0=;
        b=diGcsQzrflXLpd8/opAj1P80yinuzWHQUdBWR5iAYcdPLRrUHDR6iXycQ5KfDEQ1Gn
         Na01Ilw+ojETbdVLycn5DBaZxjP3SeMNMFm+snMVtTcSY4GcsYFO2AtTKSh6zb/Xpg0X
         xU02KMs0jVL7goXKKCRG1YTxTDfnmcQiPaQc4Y6DaGqeh4NyIzV4sPvbZo6VqXYtZieH
         kt+eAuNtAm8w2OPxNoJKU6EKnAb5/BgPoRqn84AsrDMp2il39U0s6TQbta6355NC3BOG
         uhsMWEz5cnCq5qHum9AmRIc8nvvsb7e4DWSM71lgC9nnL+cWRpFK3eX3yASM2oOK+anR
         4WOA==
X-Gm-Message-State: APjAAAWOmczZcaKKjmdIaMb6+TbZC+QI1Is/WXXXmsKk1xvW8qlo7B+I
        NqLzBYbDozxM9KVWNHOTkOKVS5KC9jjXUeIShmQvvdxX
X-Google-Smtp-Source: APXvYqw/k/R7VG1gw6vuN1p7Kra7T5dUW+lxAli5Ti1XU9bgOQyMcHjdQpg35jWhKFTE8O722DZCijXjyyzmZWiTfRs=
X-Received: by 2002:a9d:7852:: with SMTP id c18mr49874259otm.247.1577462851253;
 Fri, 27 Dec 2019 08:07:31 -0800 (PST)
MIME-Version: 1.0
References: <20191223202754.127546-1-edumazet@google.com> <20191223202754.127546-4-edumazet@google.com>
 <CADVnQynXwSoG4mjAnpy_LrLpR0RGur2ZjayNMM-TX7vGo6BxuA@mail.gmail.com> <CANn89iKF8+sjonkgvw25V6or2huUffn9F7nNjiQDAsymLm-P0g@mail.gmail.com>
In-Reply-To: <CANn89iKF8+sjonkgvw25V6or2huUffn9F7nNjiQDAsymLm-P0g@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 27 Dec 2019 11:07:15 -0500
Message-ID: <CADVnQy=TpVa4_fn=RptPWk+UMjQNV7ROQ9dz-csOX8ZdAcTt4w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/5] tcp_cubic: switch bictcp_clock() to usec resolution
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 10:24 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Dec 27, 2019 at 6:46 AM Neal Cardwell <ncardwell@google.com> wrote:
> >
> > On Mon, Dec 23, 2019 at 3:28 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > Current 1ms clock feeds ca->round_start, ca->delay_min,
> > > ca->last_ack.
> > >
> > > This is quite problematic for data-center flows, where delay_min
> > > is way below 1 ms.
> > >
> > > This means Hystart Train detection triggers every time jiffies value
> > > is updated, since "((s32)(now - ca->round_start) > ca->delay_min >> 4)"
> > > expression becomes true.
> > >
> > > This kind of random behavior can be solved by reusing the existing
> > > usec timestamp that TCP keeps in tp->tcp_mstamp
> > ...
> > > @@ -438,7 +431,7 @@ static void bictcp_acked(struct sock *sk, const struct ack_sample *sample)
> > >         if (ca->epoch_start && (s32)(tcp_jiffies32 - ca->epoch_start) < HZ)
> > >                 return;
> > >
> > > -       delay = (sample->rtt_us << 3) / USEC_PER_MSEC;
> > > +       delay = sample->rtt_us;
> >
> > It seems there is a bug in this patch: it changes the code to not
> > shift the RTT samples left by 3 bits, and adjusts the
> > HYSTART_ACK_TRAIN code path to expect the new behavior, but does not
> > change the HYSTART_DELAY code path to expect the new behavior, so the
> > HYSTART_DELAY code path is still shifting right by 3 bits, when it
> > should not... the HYSTART_DELAY remains like this at the end of the
> > patch series:
> >
> >         if (hystart_detect & HYSTART_DELAY) {
> > ...
> >                         if (ca->curr_rtt > ca->delay_min +
> >                             HYSTART_DELAY_THRESH(ca->delay_min >> 3)) {
> >
> > AFAICT the patch also should have:
> >
> > -                            HYSTART_DELAY_THRESH(ca->delay_min >> 3)) {
> > +                           HYSTART_DELAY_THRESH(ca->delay_min)) {
> >
>
>
> I do not think so Neal.
>
> The HYSTART_DELAY_THRESH(ca->delay_min >> 3) thing really means we
> want to apply a 12.5 % factor.
>
> See commit 42eef7a0bb09 "tcp_cubic: refine Hystart delay threshold"
> for some context.
>
> After this patch, ca->delay_min is in usec unit, and ca->cur_rtt is
> also in usec unit.

Oops, of course you are right. So sorry, I forgot this >>3 was for the
12.5% factor, and was reading the code too fast, and with too little
caffeine... :-)

Sorry for the noise!

neal
