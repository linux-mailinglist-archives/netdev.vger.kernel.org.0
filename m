Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFDC31F0DF
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 21:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhBRUR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 15:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhBRURP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 15:17:15 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CCBC061574
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 12:16:34 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id a62so1556383vsa.10
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 12:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l9mJwaul5p1EQ6Us+oRpOptq8AjUJBbTNRTSMMEQUis=;
        b=aYkjfYbERY8KrppDW5zh0nYux5dyqArt16V4nARafovJC+xIJU4cpm8C4qNQxn/AgQ
         cB4+87EO4JWbwOOui2O3oALd9ZsWPvE0Law4o5UerfBQNYg06YJFo+jBCfyJrUkZoMv7
         gY+iQOBDEySLMC5bTd1SrWtuNijkTqNEYzYa5LPzXj57x6ncVDWrrWH88Ou4MflVqkPt
         qZbdxTiPpCkloVo6yTVfZhAMzTXXvCeP1U0b3g/b3CUxfaZ/fcQ3R/AEOHriC8qlHabc
         xOSpHXWzWFxzRyLPxn/K4daP13w/IPQp6XPd2nB6e4dAh4PHw2Xi0W9EZ9ZfsTeO3UJH
         RnCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l9mJwaul5p1EQ6Us+oRpOptq8AjUJBbTNRTSMMEQUis=;
        b=pIJChAp4bMAhfKb37B8SQSqr00aV+Z8fEg9gL3FyuoQ3hlPwHPXwbfo7t2ekpXwnUF
         jqYWSIgG2JO8ZuALDaYvECw+PmNaI0nlnkphvC0TbGp5v/uUHCJdyyO+OitcrZHZavEO
         vT04d93sIxDwPY3tzzY0rJoQuj26v1X2fJse7o+Pp3pGu5Sp+cKaUMVPlGR9tUyUf6YP
         LcSL988YKJNQUR5BYqni1zb9i7pxMzRHmmf2VB9KUON1ZvKniWePtmPB1kp+hPkDAs8u
         C+KcMP8GOqHMvx7itCKkEWiTgn7adtgYvOwZkirKxzPBpNurt0WWQDkjFuWWIHIB+CIu
         IM8g==
X-Gm-Message-State: AOAM531isM+xUL2l/i8HJWtgaWPK8mdl1hBcexSMmyd5Gt2CZuj5JBpe
        0McBL124pzmWSBGxebOZnDlXZfy+a/U=
X-Google-Smtp-Source: ABdhPJznD3bSOF5BdtbZAwM+beQhMf88i6ZTNpIiY4UFrhj2lW7PXU6Zof5jRbtE6pn8ZhgP7GircA==
X-Received: by 2002:a67:c599:: with SMTP id h25mr4259233vsk.31.1613679393478;
        Thu, 18 Feb 2021 12:16:33 -0800 (PST)
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com. [209.85.217.45])
        by smtp.gmail.com with ESMTPSA id y9sm409609vky.47.2021.02.18.12.16.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 12:16:32 -0800 (PST)
Received: by mail-vs1-f45.google.com with SMTP id q23so1575699vsg.4
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 12:16:32 -0800 (PST)
X-Received: by 2002:a67:d103:: with SMTP id u3mr4406749vsi.39.1613679391597;
 Thu, 18 Feb 2021 12:16:31 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9o-N5wamS0YbQCHUfFwo3tPD8D3UH=AZpU61oohEtvOKg@mail.gmail.com>
 <20210218160745.2343501-1-Jason@zx2c4.com> <CA+FuTSeyYti3TMUd2EgQqTAjHjV=EXVZtmY9HUdOP0=U8WRyJA@mail.gmail.com>
 <CAHmME9rVuw5tAHUpnsXrLh-WAMXmvqSNFdOUh1XaKZ8bLOow9g@mail.gmail.com>
In-Reply-To: <CAHmME9rVuw5tAHUpnsXrLh-WAMXmvqSNFdOUh1XaKZ8bLOow9g@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 18 Feb 2021 15:15:54 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdiuPK-V5oJOMC7fQsjQKRLt95oP7OAOtR3S5mfUJreKg@mail.gmail.com>
Message-ID: <CA+FuTSdiuPK-V5oJOMC7fQsjQKRLt95oP7OAOtR3S5mfUJreKg@mail.gmail.com>
Subject: Re: [PATCH net v2] net: icmp: pass zeroed opts from
 icmp{,v6}_ndo_send before sending
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        SinYu <liuxyon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 12:58 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Thu, Feb 18, 2021 at 5:34 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> > Thanks for respinning.
> >
> > Making ipv4 and ipv6 more aligned is a good goal, but more for
> > net-next than bug fixes that need to be backported to many stable
> > branches.
> >
> > Beyond that, I'm not sure this fixes additional cases vs the previous
> > patch? It uses new on-stack variables instead of skb->cb, which again
> > is probably good in general, but adds more change than is needed for
> > the stable fix.
>
> It doesn't appear to be problematic for applying to stable. I think
> this v2 is the "right way" to handle it. Zeroing out skb->cb is
> unexpected and weird anyway. What if the caller was expecting to use
> their skb->cb after calling icmp_ndo_send? Did they think it'd get
> wiped out like that? This v2 prevents that weird behavior from
> happening.
>
> > My comment on fixing all callers of  icmp{,v6}_send was wrong, in
> > hindsight. In most cases IPCB is set correctly before calling those,
> > so we cannot just zero inside those. If we can only address the case
> > for icmp{,v6}_ndo_send I think the previous patch introduced less
> > churn, so is preferable. Unless I'm missing something.
>
> As mentioned above it's weird and unexpected.
>
> > Reminder of two main comments: sufficient to zero sizeof(IPCB..) and
> > if respinning, please explicitly mention the path that leads to a
> > stack overflow, as it is not immediately obvious (even from reading
> > the fix code?).
>
> I don't intend to respin v1, as I think v2 is more correct, and I
> don't think only zeroing IPCB is a smart idea, as in the future that
> code is bound to break when somebody forgets to update it. This v2
> does away with the zeroing all together, though, so that the right
> bytes to be zeroed are properly enforced all the time by the type
> system.

I'm afraid this latest version seems to have build issues, as per the
patchwork bot.
