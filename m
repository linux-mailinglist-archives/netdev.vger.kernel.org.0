Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46CD86D8A7E
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 00:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbjDEWRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 18:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjDEWRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 18:17:46 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DAA5FFB;
        Wed,  5 Apr 2023 15:17:45 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-502234a1f08so738461a12.3;
        Wed, 05 Apr 2023 15:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680733064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hEqIXUH9r3N7RlJaWcTaXBh5Rq77VEZamzqIxseklB4=;
        b=pmsiCnEQWWLWi/RWqC3RyJX0o62CeS8Z4fd/L+0yznB4p6bf5jzdc0q68BM6tEr8hZ
         3DC9FudqGexE2bxpU4U1d2i7r4P3vOjHlFzz9Ee3cKjZqENKgm5/nCpUl5Jn3n9isu3/
         wJYzG56ZnWGQk9zM47BdN29nL4oVczqMlLigDTT8VsJJjQYNkZy5Alb82F903roLy1Uf
         m39nLwErJdr+dNSK88w88IHH56g9BLF4VniO/3Xq88qgKajzWFhXXN1U32u8+NK/Nr4m
         7+OgdOTa4lKVaveRtu8hh3wa75d6fd9iz486ZxTof0MAzkGQ6TifbSarDzDUGqRRgS/L
         zuMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680733064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hEqIXUH9r3N7RlJaWcTaXBh5Rq77VEZamzqIxseklB4=;
        b=oLtdhAwpK4xccyKXBteesNhr0J+N1pDJNOG5byb8Jn/7hA/RF2UxtFF2bRs4gsDAkO
         EJg9aZ/Wrc5XQgiauRWPafnDCWIDQa8J4Fjbp/TYHt2mtI9dQAqvtiGe+y/IOwmF5Fr1
         F6cBRzNbH3QXLD85dUtYH3Ck3FiuN6O88Yio0E0AgG3yy2wFs6fhwu9tdvLj35yqyju5
         xeLzk8ZRUj3awbrg+2mdlIiZB+dyPE/RMfjIFwgD21q6pPYqhZMlTDevfXvM+35MI/J2
         qcCM1sPDS0XjTGMUGz5bNDy/uYGEmvFQ1TPuDRB48Ns3IOyxffu1TAE+AxBkf0DPVO1c
         KQpg==
X-Gm-Message-State: AAQBX9dcc4byrpbk2kmIM+/52doBQOr0yFvbhdsyh1TLuut6lDuLPR0H
        teknMfhsic5i1l3pdrGmEGRViyFM8DUcr94H34nVcuZP2wQ=
X-Google-Smtp-Source: AKy350bFshQZR6uFfnwgwVCvKoEOQ6UmaakkklRkKHeXhsOGp/5U0PRrShz5olbrGXznCNnIcmcPWyxT34bF0xLe2fU=
X-Received: by 2002:a05:6402:b33:b0:500:2e94:26aa with SMTP id
 bo19-20020a0564020b3300b005002e9426aamr3744876edb.20.1680733063621; Wed, 05
 Apr 2023 15:17:43 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iKn4rpqj_8fYt0UMMgAq5L_2PNoY0Ev70ck8u4t4FC_=g@mail.gmail.com>
 <20230405194143.15708-1-kuniyu@amazon.com> <CANn89iJeHFb8VnFPUq4-d+jzAO6XKiSQhaPsPFY98wjH0Yx1Lw@mail.gmail.com>
In-Reply-To: <CANn89iJeHFb8VnFPUq4-d+jzAO6XKiSQhaPsPFY98wjH0Yx1Lw@mail.gmail.com>
From:   "Dae R. Jeong" <threeearcat@gmail.com>
Date:   Thu, 6 Apr 2023 07:17:30 +0900
Message-ID: <CACsK=jf=nO-2N5HhqKd80m6RYpAFEd8rfUBrog6sKgnLuUnd9w@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in tcp_write_timer_handler
To:     Eric Dumazet <edumazet@google.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>, bpf@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org
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

On Thu, Apr 6, 2023 at 4:48=E2=80=AFAM Eric Dumazet <edumazet@google.com> w=
rote:
>
> On Wed, Apr 5, 2023 at 9:42=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.c=
om> wrote:
> >
> > From:   Eric Dumazet <edumazet@google.com>
> > Date:   Wed, 5 Apr 2023 13:28:16 +0200
> > > On Wed, Apr 5, 2023 at 12:41=E2=80=AFPM Dae R. Jeong <threeearcat@gma=
il.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > We observed an issue "KASAN: use-after-free Read in tcp_write_timer=
_handler" during fuzzing.
> > > >
> > > > Unfortunately, we have not found a reproducer for the crash yet. We
> > > > will inform you if we have any update on this crash.  Detailed cras=
h
> > > > information is attached below.
> > > >
> > >
> > > Thanks for the report.
> > >
> > > I have dozens of similar syzbot reports, with no repro.
> > >
> > > I usually hold them, because otherwise it is just noise to mailing li=
sts.
> > >
> > > Normally, all user TCP sockets hold a reference on the netns
> > >
> > > In all these cases, we see a netns being dismantled while there is at
> > > least one socket with a live timer.
> > >
> > > This is therefore a kernel TCP socket, for which we do not have yet
> > > debugging infra ( REF_TRACKER )
> > >
> > > CONFIG_NET_DEV_REFCNT_TRACKER=3Dy is helping to detect too many dev_p=
ut(),
> > > we need something tracking the "kernel sockets" as well.
> >
> > Maybe I missed something, but we track kernel sockets with netns
> > by notrefcnt_tracker ?
>
> Oh right, I forgot I did this already :)
>
> commit 0cafd77dcd032d1687efaba5598cf07bce85997f
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Thu Oct 20 23:20:18 2022 +0000
>
>     net: add a refcount tracker for kernel sockets
>
> Dae, make sure to not send reports based on old kernels.
>
> Using 6.0-rc7 is a waste of your time, and everyone else reading this thr=
ead.
>
> I confess I did not check this, and I really should do that all the time.

I'm sorry and I understand your time is valuable.
I will let you know when I observe this issue again.

>
> >
> > I thought now CONFIG_NET_NS_REFCNT_TRACKER can catch the case.
> >
> >
> > >
> > > Otherwise bugs in subsystems not properly dismantling their kernel
> > > socket at netns dismantle are next to impossible to track and fix.
> > >
> > > If anyone has time to implement this, feel free to submit patches.
> > >
> > > Thanks.

Best regards,
Dae R. Jeong.
