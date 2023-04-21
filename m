Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715116EA78A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbjDUJsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbjDUJsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:48:16 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380A7BB8E;
        Fri, 21 Apr 2023 02:47:36 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-94f3df30043so199997566b.2;
        Fri, 21 Apr 2023 02:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682070454; x=1684662454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rU5p1zdFMqZLS41bYP5l22CkO5wCPiORJGO73i7qeyY=;
        b=nxZdoXWBFsDTkdaf3cAvWhJCG/a8ZJj/Iq25a4Qg/PwEhh/4+5i45pmSn+p4dCi1lm
         1indztO/EIuyVY++u8AfiO9iYpppZ7Wo/VabLQVSGA4ld0hLiZw4qqnZ4V/FNWTfVeD7
         Pi4l5f0UeQcpUUlwflNZDaN396ft54C24Au9EXUOv5dVxwhclAoj7vkPw76DcGCtAvCe
         qfEg9/6inR1w99wPL6Zkq2J9Hxh9X/g0T5O6yG6nMKUAZI07aIWVyysFZMwNmCtOdnbj
         2YtICbfh/808DnbdniOdOelRQOaMI2SILPxiGFsJ7Fqq0zPD/cfUTLI5KEDFJMq3chAX
         YXNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682070454; x=1684662454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rU5p1zdFMqZLS41bYP5l22CkO5wCPiORJGO73i7qeyY=;
        b=bmZsW/i8rTy7CklX4j09YEP5jfblZdeSrwJxAuB4lBCzXCxXoIdg32DWq0/u1NJNdm
         EZivlhlnX+f246IPB/bzF2fj82p/Z3BnnPkBuLzP8BprAS3b9QbuXUKXCq/y9/LN8FYp
         6jIh6B6PnXHGV2M0dFRaU9WWpHmte2PX4wwOGoviKTcvZeqngf4t5/lvtDZlx4rnHKVN
         ekSprYD3Sz/7ydUS99S7w25NWioWgprRuqkTNytYkCn6WI0webKohdSTpyVEtIDiwZZ3
         S2vqEyaqF9LprWg6Z6UUAI0BxhRpPmDpInOl6DaWF5tsQ2jLbXf7gWTGWkjq+wWMCrPV
         p/NA==
X-Gm-Message-State: AAQBX9d9hZRib5QYAJ2y4wq4sxUqjt0HSEu0UfEPdWpKn6cF+gfl1oyD
        5OPWFGjeXrYtVaq0FQH3340aP82A/6mmbuwyKUc=
X-Google-Smtp-Source: AKy350ZTt3rp6V5n3+1YCtgNwmgh4Y8lWaZgSxb9sAk7cAZZZAUdHylhj0fRtPP1V197166ZwpCVJ8ij+ytAeQEMy1E=
X-Received: by 2002:a17:906:a1d8:b0:950:1e0e:2037 with SMTP id
 bx24-20020a170906a1d800b009501e0e2037mr1963767ejb.17.1682070454433; Fri, 21
 Apr 2023 02:47:34 -0700 (PDT)
MIME-Version: 1.0
References: <20221222221244.1290833-1-kuba@kernel.org> <305d7742212cbe98621b16be782b0562f1012cb6.camel@redhat.com>
 <CAL+tcoBU+UD_8aXkJy95zNzFeOBMQvQE6jj9syiKvOh_wcLrcw@mail.gmail.com> <140f61e2e1fcb8cf53619709046e312e343b53ca.camel@redhat.com>
In-Reply-To: <140f61e2e1fcb8cf53619709046e312e343b53ca.camel@redhat.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Fri, 21 Apr 2023 17:46:58 +0800
Message-ID: <CAL+tcoDZxssH-s08_LO2_=HqYJ77w_N-avOmEWQ4AiiprHFmXw@mail.gmail.com>
Subject: Re: [PATCH 0/3] softirq: uncontroversial change
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, peterz@infradead.org,
        tglx@linutronix.de, jstultz@google.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Fri, Apr 21, 2023 at 5:33=E2=80=AFPM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On Fri, 2023-04-21 at 10:48 +0800, Jason Xing wrote:
> >
> > > My understanding is that we want to avoid adding more heuristics here=
,
> > > preferring a consistent refactor.
> > >
> > > I would like to propose a revert of:
> > >
> > > 4cd13c21b207 softirq: Let ksoftirqd do its job
> > >
> > > the its follow-ups:
> > >
> > > 3c53776e29f8 Mark HI and TASKLET softirq synchronous
> > > 0f50524789fc softirq: Don't skip softirq execution when softirq threa=
d is parking
> >
> > More than this, I list some related patches mentioned in the above
> > commit 3c53776e29f8:
> > 1ff688209e2e ("watchdog: core: make sure the watchdog_worker is not def=
erred")
> > 8d5755b3f77b ("watchdog: softdog: fire watchdog even if softirqs do
> > not get to run")
> > 217f69743681 ("net: busy-poll: allow preemption in sk_busy_loop()")
>
[...]
> The first 2 changes replace plain timers with HR ones, could possibly
> be reverted, too, but it should not be a big deal either way.
>
> I think instead we want to keep the third commit above, as it should be
> useful when napi threaded is enabled.
>
> Generally speaking I would keep the initial revert to the bare minimum.

I agree with you :)

>
> > > The problem originally addressed by 4cd13c21b207 can now be tackled
> > > with the threaded napi, available since:
> > >
> > > 29863d41bb6e net: implement threaded-able napi poll loop support
> > >
> > > Reverting the mentioned commit should address the latency issues
> > > mentioned by Jakub - I verified it solves a somewhat related problem =
in
> > > my setup - and reduces the layering of heuristics in this area.
> >
> > Sure, it is. I also can verify its usefulness in the real workload.
> > Some days ago I also sent a heuristics patch [1] that can bypass the
> > ksoftirqd if the user chooses to mask some type of softirq. Let the
> > user decide it.
> >
> > But I observed that if we mask some softirqs, or we can say,
> > completely revert the commit 4cd13c21b207, the load would go higher
> > and the kernel itself may occupy/consume more time than before. They
> > were tested under the similar workload launched by our applications.
> >
> > [1]: https://lore.kernel.org/all/20230410023041.49857-1-kerneljasonxing=
@gmail.com/
>
> Thanks for the reference, I would have missed that patch otherwise.
>
> My understanding is that adding more knobs here is in the opposite
> direction of what Thomas is suggesting, and IMHO the 'now mask' should
> not be exposed to user-space.

Could you please share the link about what Thomas is suggesting? I
missed it. At the beginning, I didn't have the guts to revert the
commit directly. Instead I wrote a compromised patch that is not that
elegant as you said. Anyway, the idea is common, but reverting the
whole commit may involve more work. I will spend some time digging
into this part.

More suggestions are also welcome :)

Thanks,
Jason

>
> >
> Thanks for the feedback,
>
> Paolo
>
