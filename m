Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8471F36DC29
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 17:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241030AbhD1PnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 11:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240363AbhD1Pli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 11:41:38 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF018C0613ED
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 08:38:52 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id j84so4788768ybj.9
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 08:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xp3xoi9pLNv6e5VQArWfXrpO9SOH3U/nLYXSBNSB/Oo=;
        b=fU3h2xtEh1FFm/AVeXh1fo8W2HX4lvuofk0ZNcyCur4vxDSvZPCP+BrQk3KnJ4H6Gx
         BwblfWQ1oq1j/h5ZaYnnZX1LlklhxMYEqx3IbBQfMBYavrgoXU17ZBRxKfxdhhJNYaqo
         +D5bNHdAiD74uu78wmBucvm+CEfCrkwA/GWZ88/jE83LcH+Nj5oxi3D5yhKQfoi04tH1
         gOp0SGs1vLvAVhegKJInQbstbkjvX46SPSjd/cA7zgvRfyIdI0xHPTgvfRHa3YlwSdOg
         0VqkblDZEBUjlW1G7S6goiYnMJgWDFjJrtmKEINkzlmWCf2PIpu6GlkZsIX43uDi9NIB
         dDYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xp3xoi9pLNv6e5VQArWfXrpO9SOH3U/nLYXSBNSB/Oo=;
        b=Yu/oYYmZ3XbGUzsXnN892nhieHmbW7hC1IQEXYC2C1G75Fl9ywwfCd6WotGDLhdcPC
         xmcaqlRoFp65rN13xwnwCXhVbzS+rJ4vJMi189eS/Iuo+N6SGe9oq+V355Brj1pnnFAT
         8MSYy24HFV7KlzP5mRtpcFBJVZbhsLrDQwrnuYYyZFtwjPvqlLVuw0+o/87nNBvZBd7z
         ihvXHh4NicLyodEmpmRiLlEC36HgnDBeNBglOYOF7Lfvd9zw/OhXEtCNhqWaVSJ7/KX4
         rg/KmfBSuGLgzKHyUgJ9viiw0z9tLLLv4of0veJNVrwB0ZxbxUiKuPkr+DoVb9HtOYfm
         PjjQ==
X-Gm-Message-State: AOAM531a0EGMEBRaDXwJlF6g+Vdi6DJgC0oppVNMPhy9VoZfNfcmo/2I
        3IDtaO2gE5HBSgseMRrCmHvU2xJIG+M3jvByx9ZM+w==
X-Google-Smtp-Source: ABdhPJzUvZ2yP8PwyrrdQ2jtG8FkoUNc1P2o18OT7Ef849CltHd9OWO8pX8nvIs0XY8p7JoaZCxT6HOlhyF363pouQk=
X-Received: by 2002:a5b:2cf:: with SMTP id h15mr4276389ybp.132.1619624331872;
 Wed, 28 Apr 2021 08:38:51 -0700 (PDT)
MIME-Version: 1.0
References: <d840ddcf-07a6-a838-abf8-b1d85446138e@bluematt.me>
 <CANn89i+L2DuD2+EMHzwZ=qYYKo1A9gw=nTTmh20GV_o9ADxe2Q@mail.gmail.com>
 <0cb19f7e-a9b3-58f8-6119-0736010f1326@bluematt.me> <20210428141319.GA7645@1wt.eu>
 <055d0512-216c-9661-9dd4-007c46049265@bluematt.me>
In-Reply-To: <055d0512-216c-9661-9dd4-007c46049265@bluematt.me>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 28 Apr 2021 17:38:40 +0200
Message-ID: <CANn89iKfGhNYJVpj4T2MLkomkwPsYWyOof+COVvNFsfVfb7CRQ@mail.gmail.com>
Subject: Re: [PATCH net-next] Reduce IP_FRAG_TIME fragment-reassembly timeout
 to 1s, from 30s
To:     Matt Corallo <netdev-list@mattcorallo.com>
Cc:     Willy Tarreau <w@1wt.eu>, "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Keyu Man <kman001@ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 4:28 PM Matt Corallo
<netdev-list@mattcorallo.com> wrote:
>
>
>
> On 4/28/21 10:13, Willy Tarreau wrote:
> > On Wed, Apr 28, 2021 at 10:09:00AM -0400, Matt Corallo wrote:
> > Regardless of retransmits, large RTTs are often an indication of buffer bloat
> > on the path, and this can take some fragments apart, even worse when you mix
> > this with multi-path routing where some fragments may take a short path and
> > others can take a congested one. In this case you'll note that the excessive
> > buffer time can become a non-negligible part of the observed RTT, hence the
> > indirect relation between the two.
>
> Right, buffer bloat is definitely a concern. Would it make more sense to reduce the default to somewhere closer to 3s?
>
> More generally, I find this a rather interesting case - obviously breaking *deployed* use-cases of Linux is Really Bad,
> but at the same time, the internet has changed around us and suddenly other reasonable use-cases of Linux (ie as a
> router processing real-world consumer flows - in my case a stupid DOCSIS modem dropping 1Mbps from its measly 20Mbps
> limit) have slowly broken instead.
>
> Matt

I have been working in wifi environments (linux conferences) where RTT
could reach 20 sec, and even 30 seconds, and this was in some very
rich cities in the USA.

Obviously, when a network is under provisioned by 50x factor, you
_need_ more time to complete fragments.

For some reason, the crazy IP reassembly stuff comes every couple of
years, and it is now a FAQ.

The Internet has changed for the  lucky ones, but some deployments are
using 4Mbps satellite connectivity, shared by hundreds of people.
I urge application designers to _not_ rely on doomed frags, even in
controlled networks.
