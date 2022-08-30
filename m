Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC5D5A6D45
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 21:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbiH3TZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 15:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbiH3TZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 15:25:24 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93E47D787;
        Tue, 30 Aug 2022 12:23:41 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id bq23so16904589lfb.7;
        Tue, 30 Aug 2022 12:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=PofCDqq1/P6k1Jn4y9ZY/hH9ZV66RzTw5eiKc3y6V2I=;
        b=dPArg/S1a5fJ8tPg31l2B55zSCu+K+g5akN0VMJWu7fJIwhOcW2KYWU7wLFuLysusJ
         H1DIL1HVNbmxB9DQ9q8CCUlav5EsGYwD4/j6FzTeFVEDYOBb5JlA3PGAw3wIQFrV3U4n
         YlVjhJw7k97BFNY9IFOyPVoH8Unl/qNIKrUtePUN1Gh4p4Teg1nzGAUVK+CGBVC0MorR
         5m5XdvXnTJhK1kJ7fdUWuwpOXHm2QEh8JgWRD5XuzKv7EjLAIGeCdXi6UnK6xtUgTbZP
         9BYRpn/Bg8l8jCeD/2VeCRYSdo+OYDTMdjuB0CrE5nMxFm9gDrZG+63sVUSQ6WIg4hpF
         eq9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=PofCDqq1/P6k1Jn4y9ZY/hH9ZV66RzTw5eiKc3y6V2I=;
        b=DzI3r5M04I6I9AbjkJoAb5dgZamfgdSPVkas81AZyAab4w6ZdSnZ1eQVXouSJ/2osD
         i28pzbV3oNwJhllzO5fV+YUsqmCxXHX5cL+6TkV/IRGRmuw8V1sAtLkp1qHJKuHiMjhF
         UU+0wyvhoOniF2XkHH3pFpk9dFTg0KElcHeZntdJZCVbdgLXLNe43WiJgchiRz7sCx7X
         XcyBqOILFXO1Fw7fyv7nPClmkaJGQOz+Md8OSC4ZNcxI+a++Z/dd9tVDB1G+lPR1vAPY
         /BKYxyJtL7ZwBQwqqeyKzUSxkHv850GJFnWs6fmOzyeOA7UZYrlWUiYyo57oED3EuxAM
         w7Gw==
X-Gm-Message-State: ACgBeo2ZLpYbjYXMGI9HMxy4IU0rTYUeT/V/FCiDaWlkQ8RmVS/ZzTkz
        WC5O6psir1Qa6CXzfRRy0DoVj3YmLOTALy2Ebis=
X-Google-Smtp-Source: AA6agR4SGoPeOqG3H6+/IqX3usnWitUxXya7RJa19u8/Z8QK2EQwDD9pb/Bihiuzq6jPnFFwBhCvbRGGKdGrYQUcbok=
X-Received: by 2002:a05:6512:1ce:b0:494:81fc:e755 with SMTP id
 f14-20020a05651201ce00b0049481fce755mr815471lfp.106.1661887417943; Tue, 30
 Aug 2022 12:23:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAO4S-me4hoy0W6GASU3tOFF16+eaotxPbw+kqyc6vuxtxJyDZg@mail.gmail.com>
 <CAO4S-mfTNEKCs8ZQcT09wDzxX8MfidmbTVzaFMD3oG4i7Ytynw@mail.gmail.com>
 <f53dfd70-f8b3-8401-3f5a-d738b2f242e1@gmail.com> <CABBYNZLZv_Y6E-rFc3kKFk+PqwNkWAzneAw=cUTEY4yW-cTs1Q@mail.gmail.com>
In-Reply-To: <CABBYNZLZv_Y6E-rFc3kKFk+PqwNkWAzneAw=cUTEY4yW-cTs1Q@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 30 Aug 2022 12:23:26 -0700
Message-ID: <CABBYNZJxzA0U5bL6d0KtAkZw6yfUSNcpaH3Oh=xZFZdER8FCog@mail.gmail.com>
Subject: Re: possible deadlock in rfcomm_sk_state_change
To:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Cc:     Jiacheng Xu <578001344xu@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Desmond,

On Tue, Aug 30, 2022 at 10:41 AM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Desmond,
>
> On Mon, Aug 29, 2022 at 11:48 PM Desmond Cheong Zhi Xi
> <desmondcheongzx@gmail.com> wrote:
> >
> > +cc Bluetooth and Networking maintainers
> >
> > Hi Jiacheng,
> >
> > On 28/8/22 04:03, Jiacheng Xu wrote:
> > > Hi,
> > >
> > > I believe the deadlock is more than possible but actually real.
> > > I got a poc that could stably trigger the deadlock.
> > >
> > > poc: https://drive.google.com/file/d/1PjqvMtHsrrGM1MIRGKl_zJGR-teAMMQy/view?usp=sharing
> > >
> > > Description/Root cause:
> > > In rfcomm_sock_shutdown(), lock_sock() is called when releasing and
> > > shutting down socket.
> > > However, lock_sock() has to be called once more when the sk_state is
> > > changed because the
> > > lock is not always held when rfcomm_sk_state_change() is called. One
> > > such call stack is:
> > >
> > >    rfcomm_sock_shutdown():
> > >      lock_sock();
> > >      __rfcomm_sock_close():
> > >        rfcomm_dlc_close():
> > >          __rfcomm_dlc_close():
> > >            rfcomm_dlc_lock();
> > >            rfcomm_sk_state_change():
> > >              lock_sock();
> > >
> > > Besides the recursive deadlock, there is also an
> > > issue of a lock hierarchy inversion between rfcomm_dlc_lock() and
> > > lock_sock() if the socket is locked in rfcomm_sk_state_change().
> >
> >
> > Thanks for the poc and for following the trail all the way to the root
> > cause - this was a known issue and I didn't realize the patch wasn't
> > applied.
> >
> > >  > Reference:
> > https://lore.kernel.org/all/20211004180734.434511-1-desmondcheongzx@gmail.com/
> > >
> >
> > Fwiw, I tested the patch again with syzbot. It still applies cleanly to
> > the head of bluetooth-next and seems to address the root cause.
> >
> > Any thoughts from the maintainers on this issue and the proposed fix?
>
> We probably need to introduce a test to rfcomm-tester to reproduce
> this sort of problem, I also would like to avoid introducing a work
> just to trigger a state change since we don't have such problem on the
> likes of L2CAP socket so perhaps we need to rework the code a little
> bit to avoid the locking problems.

It looks like for L2CAP we use lock_sock_nested on teardown, we don't
have the exact same behavior in RFCOMM but I think that might be worth
a try if we can use that instead of introducing yet another work item.

> > Best,
> > Desmond
>
>
>
> --
> Luiz Augusto von Dentz



-- 
Luiz Augusto von Dentz
