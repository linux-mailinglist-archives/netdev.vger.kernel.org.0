Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5080F370860
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 20:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbhEASXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 14:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbhEASXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 14:23:46 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41428C06174A;
        Sat,  1 May 2021 11:22:55 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id n2so1406393wrm.0;
        Sat, 01 May 2021 11:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LyP7j7BeqHqV3e5Os7Cv9MEG1DfDqN3z/0Bjuphu5pw=;
        b=MzX5WM1bQPYVNox0FQ57acFUP3N2JynsX7JbwvuOpbe+zqDbQpy1t2G29jTRjswVJn
         9f8UFe21zHg8V+krZ6jttKGkZ7nEUyTKDnl7Xq1zWcvcnADP0dpq44R+p1aQsSsyclzg
         fGnADaTzL3ToNcAea9Vwnw34XrRAvYF700Jkfz2fCHoE/D9R6jTpynro8Vm7vpG1UsC7
         bqNIF3BRRvLZAIFWRxVNJsXN7owFopUlMZOosvXttRHe366dIQ+Y7Z4swhwzYxFxCfad
         0MgM85KwD342G5od0wuuIyfshQtl4ia6BCO8/Bj2XHq/lk/4XFUJ/qv5+37K7Kx/nv3g
         clFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LyP7j7BeqHqV3e5Os7Cv9MEG1DfDqN3z/0Bjuphu5pw=;
        b=tcdMFX+ThvKUTIwNm0DJanTfoJFeMJQJvOA3JlYDBu6l829RcLqDyfOet/7U6tPz1G
         3ouHyJ6P163fZnVICGfo0yLrWZIEEU9H70do2B6ntBIdoNHLCE7jaND+sHEdrQpxoa6I
         FPZ0R9LrrBsiRtgbNHyxrokz5qSJ+RC/MjBPM1MsN9dTacgywsPTgDbZgiAPKqiFepfe
         M+ENm/KQf8N3l5z6axL/kXblTJM3XABAqYs/DAQUJKdlOMXse9xmzyT4C6RRQJEZ6IBM
         P3womAHEl0bQ49CBFYwQv/QfTR4T6kJGgrGnD+TKK1UVS06vPhA9XQDEf3u/ZJdAc2Be
         bUqw==
X-Gm-Message-State: AOAM531gsNxVhoUWJ4ohMFHSfSxK0SVJz4oj5Fz7leEjU0JgBDF+K4O6
        a/yTnrNAEbd5Xp6qnjJBC8uLwVwabkbC980YTEk=
X-Google-Smtp-Source: ABdhPJz8xaT7hQdI2RgHbTaw7ZfZD+/Exa/6p0yWkQR4q0kfYXTlogPv+ZLe2rJxLtTJsS+MEe/TM7KyLrh8oZtsaCk=
X-Received: by 2002:a05:6000:1786:: with SMTP id e6mr15178583wrg.243.1619893372186;
 Sat, 01 May 2021 11:22:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1619812899.git.lucien.xin@gmail.com> <HE1PR0702MB38188BD50D8091BC350114EFEC5D9@HE1PR0702MB3818.eurprd07.prod.outlook.com>
In-Reply-To: <HE1PR0702MB38188BD50D8091BC350114EFEC5D9@HE1PR0702MB3818.eurprd07.prod.outlook.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 1 May 2021 14:22:40 -0400
Message-ID: <CADvbK_eBGFU1dGX+T73HidNT44KZR_Cqd=16YjUfKwcS7AK4sQ@mail.gmail.com>
Subject: Re: [PATCHv2 net 0/3] sctp: always send a chunk with the asoc that it
 belongs to
To:     "Leppanen, Jere (Nokia - FI/Espoo)" <jere.leppanen@nokia.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 1, 2021 at 12:54 PM Leppanen, Jere (Nokia - FI/Espoo)
<jere.leppanen@nokia.com> wrote:
>
> On Fri, 30 Apr 2021, Xin Long wrote:
>
> > Currently when processing a duplicate COOKIE-ECHO chunk, a new temp
> > asoc would be created, then it creates the chunks with the new asoc.
> > However, later on it uses the old asoc to send these chunks, which
> > has caused quite a few issues.
> >
> > This patchset is to fix this and make sure that the COOKIE-ACK and
> > SHUTDOWN chunks are created with the same asoc that will be used to
> > send them out.
>
> Again, much thanks for looking into this. Patches 1 and 3 are
> almost the same as my patch, which as I mentioned I've been
> testing on and off for the past couple of weeks, and haven't
> found any problems. (Then again, I didn't find any problems last
> time either.)
>
> I think 145cb2f7177d ("sctp: Fix bundling of SHUTDOWN with
> COOKIE-ACK") should not be reverted (I'll reply to the patch).
>
> 12dfd78e3a74 ("sctp: Fix SHUTDOWN CTSN Ack in the peer restart
> case") should be reverted. With association update no longer a
> side effect, we can get CTSN normally from current assoc, since
> it has been updated before sctp_make_shutdown().
Good catch, didn't notice this one.
Will do it. Thanks.

>
> >
> > v1->v2:
> >  - see Patch 3/3.
> >
> > Xin Long (3):
> >  sctp: do asoc update earlier in sctp_sf_do_dupcook_a
> >  Revert "sctp: Fix bundling of SHUTDOWN with COOKIE-ACK"
> >  sctp: do asoc update earlier in sctp_sf_do_dupcook_b
> >
> > include/net/sctp/command.h |  1 -
> > net/sctp/sm_sideeffect.c   | 26 ------------------------
> > net/sctp/sm_statefuns.c    | 50 ++++++++++++++++++++++++++++++++++++----------
> > 3 files changed, 39 insertions(+), 38 deletions(-)
> >
> > --
> > 2.1.0
