Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AA134D10A
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 15:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhC2NSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 09:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhC2NSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 09:18:12 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11328C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 06:18:12 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id a143so13720506ybg.7
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 06:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pwnsPSQnNfe9VUdIWeOJJ6LREk/z71gTZrwDHJ2vz1I=;
        b=WJrEdToM303IX1TW3ruhjvTLERSw441vheM9knRbmckb49NpgCE6f2kS0v57t7TrsR
         D6sTMm8BJLHHJB5nBPWowt4LQgajFd8IuwCBlvpyqo1/38UFI1cGhq0sED9N6g51dx2w
         pnDJv8f4pdnlHZayf79tle63l1xCnN51iLahv/6flsnYwhhwBnOR+casljztH+YEp5yu
         jljnEodKBDGmDtXMQNtXG3iHOeDIappAjJ2459bkEE6wWLFEp1l9V2FIGpV4Ugd4es2U
         GjxId0f01rGqrxaIlVVSnc5/+4z3fQScGFwqsgS/BqBipxqUhzAWRnQPn0tLd9Mwh0la
         +n3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pwnsPSQnNfe9VUdIWeOJJ6LREk/z71gTZrwDHJ2vz1I=;
        b=DKaG7izvaIEc6Q66rjBH/t+Zzv9qi6RFWumD4c/GLhcTe/8q9rg0knJecFOSV+JBcz
         vWlOictemwheg7ZT1bem24zZvOh7I+dTtIDT5kqQmG8UQXc11ZX1WoJWgW798poiOmob
         xNqHskz8SwjsB0MMlSdRZQ0vtpON4YrIPrYB3Q08xLEFvTnXMiMUAx5ioRS3eEvj6aVH
         xGoDBNI1G/u60aWXv5C/nAPlZRA0ylPJWf5FG5OqGw6BO6is9Wl4gjdbrzmsaCE9jmAS
         XpcDiDileoMXNfRMMbSbg2/skzLpEr48bHweIhCeDCGwi9MfAO8deSP2eD/qXMNkyA9S
         W4tg==
X-Gm-Message-State: AOAM530k7F2PD3L3IGM3PVU2nUN6oI8zpJyVdn4iQDl5wDalX2n9WVo2
        ZiTxH9CgyaFk4Hl4XMxkr2S4re5Tc6W1MRSBwRwN+g==
X-Google-Smtp-Source: ABdhPJwcRPvI0mHZjQinZPk/tknVjziDJ5geZ0jbSsYU818EJ5qWJATnMSvc0DnmHWgGv0x9vpGP9iCWOC5C06FzFSY=
X-Received: by 2002:a25:3614:: with SMTP id d20mr21588374yba.452.1617023890923;
 Mon, 29 Mar 2021 06:18:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210329071716.12235-1-kurt@linutronix.de> <CANn89iJfLQwADLMw6A9J103qM=1y3O6ki1hQMb3cDuJVrwAkrg@mail.gmail.com>
 <878s661cc2.fsf@kurt> <CANn89iL6rQ_KqxyTBDDKtU-um_w=OhBywNwMrr+fki3UWdKVLg@mail.gmail.com>
 <d949388f-6027-23be-2e2a-2f37d84e9f27@linux.ibm.com>
In-Reply-To: <d949388f-6027-23be-2e2a-2f37d84e9f27@linux.ibm.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 29 Mar 2021 15:17:59 +0200
Message-ID: <CANn89iK_f3sV+GR00+9z-FsB-9TcdoPovRrxeDZnWKSmdUZpHA@mail.gmail.com>
Subject: Re: [PATCH net v2] net: Reset MAC header for direct packet transmission
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 2:42 PM Julian Wiedmann <jwi@linux.ibm.com> wrote:
>
> On 29.03.21 14:13, Eric Dumazet wrote:
> > On Mon, Mar 29, 2021 at 12:30 PM Kurt Kanzenbach <kurt@linutronix.de> wrote:
> >>
> >> On Mon Mar 29 2021, Eric Dumazet wrote:
> >>> Note that last year, I addressed the issue differently in commit
> >>> 96cc4b69581db68efc9749ef32e9cf8e0160c509
> >>> ("macvlan: do not assume mac_header is set in macvlan_broadcast()")
> >>> (amended with commit 1712b2fff8c682d145c7889d2290696647d82dab
> >>> "macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()")
> >>>
> >>> My reasoning was that in TX path, when ndo_start_xmit() is called, MAC
> >>> header is essentially skb->data,
> >>> so I was hoping to _remove_ skb_reset_mac_header(skb) eventually from
> >>> the fast path (aka __dev_queue_xmit),
> >>> because most drivers do not care about MAC header, they just use skb->data.
> >>>
> >>> I understand it is more difficult to review drivers instead of just
> >>> adding more code in  __dev_direct_xmit()
> >>>
> >>> In hsr case, I do not really see why the existing check can not be
> >>> simply reworked ?
> >>
> >> It can be reworked, no problem. I just thought it might be better to add
> >> it to the generic code just in case there are more drivers suffering
> >> from the issue.
> >
> > Note that I have a similar issue pending in ipvlan.
> >
> > Still, I think I prefer the non easy way to not add more stuff in fast path.
> >
>
> Can we apply this fix (and propagate it to stable), and then remove the
> skb_reset_mac_header() from _both_ xmit paths through net-next?

This is the plan, but as I said a full audit is needed.

Currently ipvlan still needs a fix.
