Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4549A2216D3
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 23:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgGOVMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 17:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgGOVMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 17:12:36 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482D2C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 14:12:36 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id i3so2972866qtq.13
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 14:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ugnd0TD/Wl8NWEtJPlvFS8k7ARKLAYTngfNEZV+I5ag=;
        b=e3md1I053z8dnwg5KFnxqhvQ1WiUUnbJdwyDyZIkB2AgxHabMHn9dj0iSMqQg56+P2
         mV1ri6BWkqC2e4y2J5NPsaVGqrDXgj6Aeu2xB9FfOHqI5+yQqydngRTc2Q6pB6GyvvpE
         yeQQsT05Rhpkb01fGLIANje8GJRc+QqxqQ4efrCDCXMj5+iq5azSyrje59WfAUxqJ9UV
         4dIM27bq6SU7UCXFlaE5pGYz5MwrxdT2tU17y0Jxemwgc3n18SLyX5Tcke7fjGbJw4xb
         tHSobEE92h7ttBbDSd8phFYTr1QPJFPHpNHCbibHIH8laQEFUj+VZTAn+aOCdi7jXC/G
         hwnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ugnd0TD/Wl8NWEtJPlvFS8k7ARKLAYTngfNEZV+I5ag=;
        b=ELARvN2tyAl2ZXbf5+aynzlOmHEPsysy0gooULC0/7t6aPch/ri5skIbGULixx5I0q
         PjV7ZWDBtFfbKMwE1hi4jAsc9HrtT4yvep2R/5o4JA12TRShLNxnHPCaWGFD+JjFSm8Z
         LDMOm8wyuLlbz/Szr7lmiPQsgtE1NZnqc0xjhJlQ7ljUSpsW8JrhKwaXmnZ+2V8szJn0
         1CJUv+ascCxqcPjfGVGbCSZwNq6HA2CKSgcU+zvrQ10mP1O/r4aa2I9A+Ma+CBfaRYjD
         fPCaCTUpb+88OXx5MhX4Z1DfSlzNzUqDQ7IsCeOU6c8L3AZHTk47zEZprAF2oqJhkT60
         r82g==
X-Gm-Message-State: AOAM531w49PrRJN7y2eke+yriKMx+tmoe6Q4opfb3NxADjD1vtoVTG4I
        701JkimsCjuLM0gXZ3KKcRGsKi5HvN8JsLHLgXc=
X-Google-Smtp-Source: ABdhPJzaG2j3u5HOq/5VT7IEEeRrfIHhN5avB0/42NLmHg5ZXy/jW2SUd+/bfNiLVKPX9lyEfrDq0boR0FEuzfQdY3Y=
X-Received: by 2002:ac8:346c:: with SMTP id v41mr1917214qtb.262.1594847555211;
 Wed, 15 Jul 2020 14:12:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAA85sZvKNXCo5bB5a6kKmsOUAiw+_daAVaSYqNW6QbSBJ0TcyQ@mail.gmail.com>
 <CAA85sZua6Q8UR7TfCGO0bV=VU0gKtqj-8o_mqH38RpKrwYZGtg@mail.gmail.com>
 <20200715133136.5f63360c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAA85sZu09Z4gydJ8rAO_Ey0zqx-8Lg28=fBJ=FxFnp6cetNd3g@mail.gmail.com>
In-Reply-To: <CAA85sZu09Z4gydJ8rAO_Ey0zqx-8Lg28=fBJ=FxFnp6cetNd3g@mail.gmail.com>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Wed, 15 Jul 2020 23:12:23 +0200
Message-ID: <CAA85sZtjCW2Yg+tXPgYyoFA5BKAVZC8kVKG=6SiR64c8ur8UcQ@mail.gmail.com>
Subject: Re: NAT performance issue 944mbit -> ~40mbit
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 11:02 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
> On Wed, Jul 15, 2020 at 10:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 15 Jul 2020 22:05:58 +0200 Ian Kumlien wrote:
> > > After a  lot of debugging it turns out that the bug is in igb...
> > >
> > > driver: igb
> > > version: 5.6.0-k
> > > firmware-version:  0. 6-1
> > >
> > > 03:00.0 Ethernet controller: Intel Corporation I211 Gigabit Network
> > > Connection (rev 03)
> >
> > Unclear to me what you're actually reporting. Is this a regression
> > after a kernel upgrade? Compared to no NAT?
>
> It only happens on "internet links"
>
> Lets say that A is client with ibg driver, B is a firewall running NAT
> with ixgbe drivers, C is another local node with igb and
> D is a remote node with a bridge backed by a bnx2 interface.
>
> A -> B -> C is ok (B and C is on the same switch)
>
> A -> B -> D -- 32-40mbit
>
> B -> D 944 mbit
> C -> D 944 mbit
>
> A' -> D ~933 mbit (A with realtek nic -- also link is not idle atm)

This should of course be A' -> B -> D

Sorry, I've been scratching my head for about a week...

> Can it be a timing issue? this is on a AMD Ryzen 9 system - I have
> tcpdumps but i doubt that they'll help...
>
> > > It's interesting that it only seems to happen on longer links... Any clues?
> >
> > Links as in with longer cables?
>
> Longer links, as in more hops and unknown (in this case Juniper) switches/boxes
