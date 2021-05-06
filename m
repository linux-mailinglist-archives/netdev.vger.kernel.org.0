Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C180D375B23
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 21:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbhEFTBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 15:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbhEFTBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 15:01:18 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19DEC061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 12:00:19 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id t4so3897754plc.6
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 12:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JsOjnDfezBWYeptetJNw+HQRcTLAZwE3C5IwDogphzY=;
        b=D1PVYfsFbwEFnkC8v5yR1C9nGij5U+h21StVSpMEelX0N6nq2vDsCj6AKYKb6mkdDd
         F8OWiAhohBpd/ppexJzq45Q0BMwGwVwQmoTEtdaZw7GBRQjDpm8FUj5nMIl/CA5Wwsbp
         X22jECPlLJMqRHshtn6/w/z14EihMo8lyPLiqTClALg7TdS0aDrsWbYd/dOg8KRnzqVy
         rlFLMKRD2qcGaY92s4X/UsB+fO286jN3VNTFuZrIRFy50VOtYzdOeG3FvS8VECjtODv0
         47Y5k7AjHeZmUEFZVwMGOo2SrR92eRDSwNQEwPCnkTNa6rHlx129uJ0EoGgjsjE2jlek
         N1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JsOjnDfezBWYeptetJNw+HQRcTLAZwE3C5IwDogphzY=;
        b=bOAJimTb95/U9bflHGqS1+HqY6/BSvfwyFrPQOwFx6vp6kZXBI9kYkCvJJiYbYZX3k
         9V30Btr2Vduun1YARo+Zi1d220E2PKWUluHWIT94Mn+BBJIHQChkU4PyOFDMBBXYQtgb
         ouLE6HJySkQgXINLqvEKvXeh7O6WTXSKNwGGKwwwEstB9nOcbqJybb10/goY1ZZlOLEY
         KznWW5k6fUlv13UAbvvScexsj6LQCrCkQlNJo8F442D77E9FefCvgRWmEl9bSP9yQ1YS
         sG13vG59hUYuAeICw12Z1GohkbYdOplcxjaq/Xlra82Ix8qVqZ6RFPRidnZYLoN1USIb
         kOUA==
X-Gm-Message-State: AOAM530WURGVHOOTExsF3Pi9RMrug0KESirt6g39TGNzi8eDkNiBnHO8
        hmGaoyk7VPkSPImfTBJHmOZCc+nwHoughLdmeGWHlA==
X-Google-Smtp-Source: ABdhPJxKxBtxgOuK7iGf9MD/pWBkEzgdWNsggk4lmJXvGSdgTlPG/J3vqRLih8mK7le2/1mTMdE71FsK2I34uaNKuAo=
X-Received: by 2002:a17:902:a987:b029:ef:117:fae3 with SMTP id
 bh7-20020a170902a987b02900ef0117fae3mr2359157plb.69.1620327619294; Thu, 06
 May 2021 12:00:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210506184300.2241623-1-arjunroy.kdev@gmail.com> <CANn89iJD92njqrpzb+uC5-YL8XaLB5jeDmDAwkdMmKK=fvKRmA@mail.gmail.com>
In-Reply-To: <CANn89iJD92njqrpzb+uC5-YL8XaLB5jeDmDAwkdMmKK=fvKRmA@mail.gmail.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Thu, 6 May 2021 12:00:08 -0700
Message-ID: <CAOFY-A2UKY3SD_TYbuWXudPSHRCDOKSXu1GYCUYEQBYiUAqvGg@mail.gmail.com>
Subject: Re: [net] tcp: Specify cmsgbuf is user pointer for receive zerocopy.
To:     Eric Dumazet <edumazet@google.com>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 6, 2021 at 11:56 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, May 6, 2021 at 8:43 PM Arjun Roy <arjunroy.kdev@gmail.com> wrote:
> >
> > From: Arjun Roy <arjunroy@google.com>
> >
> > A prior change introduces separate handling for ->msg_control
> > depending on whether the pointer is a kernel or user pointer. However,
> > it does not update tcp receive zerocopy (which uses a user pointer),
> > which can cause faults when the improper mechanism is used.
> >
> > This patch simply annotates tcp receive zerocopy's use as explicitly
> > being a user pointer.
> >
> > Fixes: 1f466e1f15cf ("net: cleanly handle kernel vs user buffers for ->msg_control")
>
> This Fixes: tag is wrong.
>
> When this commit was merged, tcp_zc_finalize_rx_tstamp() was not yet there.
>

Makes sense - I'll send out an amended v2 patch that tags
'7eeba1706eba' instead.

-Arjun

> > Signed-off-by: Arjun Roy <arjunroy@google.com>
> > ---
> >  net/ipv4/tcp.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index e14fd0c50c10..f1c1f9e3de72 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -2039,6 +2039,7 @@ static void tcp_zc_finalize_rx_tstamp(struct sock *sk,
> >                 (__kernel_size_t)zc->msg_controllen;
> >         cmsg_dummy.msg_flags = in_compat_syscall()
> >                 ? MSG_CMSG_COMPAT : 0;
> > +       cmsg_dummy.msg_control_is_user = true;
> >         zc->msg_flags = 0;
> >         if (zc->msg_control == msg_control_addr &&
> >             zc->msg_controllen == cmsg_dummy.msg_controllen) {
> > --
> > 2.31.1.607.g51e8a6a459-goog
> >
