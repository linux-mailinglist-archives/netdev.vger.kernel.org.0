Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725551CC6F2
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 07:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgEJFQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 01:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728332AbgEJFQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 01:16:12 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CF3C061A0C
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 22:16:12 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id f12so4964609edn.12
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 22:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9XCJEjGj8k45aDbKTDaH2X+UfRr8JtG5VUbcNVCgEAA=;
        b=afuBga4QK7FBWEXqVPU39kuo2x6qXOl5cEynkwyq6j2QrVrunwY+J99ohe3jVGev4m
         aUnItND1EK0cwYeRd9gy0kMtVcFT7Eyj76/7prdGjWaWEef9QwaXW0HFFcK+D+5tbQ7z
         QjesSIIXcYxdMmGv5KrU+l7DsJMbiPuz4AGrMnCMwO7VesEfmmFvlHFKdPzyKTBaF/jS
         n25Vc22wqMYNWTZoMvpu/dzYQaJ4z1rNI+u5We2W8q/ITkQMI+sKzHGTg1sGmM1Kw1Yv
         k8VdcHHhG6KwU2Pagw1+70npFQJB37KsoK0voyY20Mz0MEanDNt1yx5+BPS77UU5xPy+
         m/og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9XCJEjGj8k45aDbKTDaH2X+UfRr8JtG5VUbcNVCgEAA=;
        b=tHJ1fX21yy5noVkSVGP7XeLax53TLO4FCM4HefKCCu3e5Gy4oAroPi66YHNqf2JUhx
         3F14+wXACQPWXw/x5icyCRM0SdIbXeuHljIO87RRhOnniT3mkqpBn+2gA8xzIgUlua01
         QQmLsnXTKHgjLOv/w31SwY/UkIY3IXsMBFQLQuvs8XwhgtJ93l2/ajTILan6HSobONX1
         m/MWv606gxirxfky5JwHK35oowosSLDQXI/AoV0M2l14Dq3BsQi+38LPKIuDEW7/TNyP
         iBpXn9pSAMEUJ6oVOZvoym1dOL6yn7rVPuzxEwtCqiod59Raik1biBEg8n3ySNgP4JdT
         llZQ==
X-Gm-Message-State: AGi0Pub3Ox/P3YRtzc4NNm16yDA7t3uaUhrhvRorUfEaTr697pL8K3v5
        QIozlQ43jcpuHusm4m+KGrwI+A4OKlCdojQ+YejO7A==
X-Google-Smtp-Source: APiQypJOd8dbHLG5Fizu4b5OjNdOJrNr/3YclkdMFI9tyxL6kOEvfZx52SuLTPY+0YJj/+/4LYAX9sIKVavA5EcYhyA=
X-Received: by 2002:aa7:ce0f:: with SMTP id d15mr8062517edv.290.1589087770782;
 Sat, 09 May 2020 22:16:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200508234223.118254-1-zenczykowski@gmail.com>
 <20200509191536.GA370521@splinter> <a4fefa7c-8e8a-6975-aa06-b71ba1885f7b@gmail.com>
 <CANP3RGfr0ziZN9Jg175DD4OULhYtB2g2xFncCqeCnQA9vAYpdA@mail.gmail.com> <55a5f7d2-89da-0b6f-3a19-807816574858@gmail.com>
In-Reply-To: <55a5f7d2-89da-0b6f-3a19-807816574858@gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sat, 9 May 2020 22:15:59 -0700
Message-ID: <CAHo-OozVAnDhMeTfY6mD2d7CFHGnC6dVuMtXaw2qs7NFN6ZPpQ@mail.gmail.com>
Subject: Re: [PATCH] net-icmp: make icmp{,v6} (ping) sockets available to all
 by default
To:     David Ahern <dsahern@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ido's response gave introductory commands which can also be found here:
>     https://www.kernel.org/doc/Documentation/networking/vrf.txt
>
> This should answer most questions about more advanced topics:
>     http://schd.ws/hosted_files/ossna2017/fe/vrf-tutorial-oss.pdf
>
> Lately, I am putting blogs on https://people.kernel.org/dsahern for
> recurring questions.

Thanks for that - I'll give it a look.

> Rumors are ugly. If in doubt, ask. LLA with VRF is a primary requirement
> from the beginning.

LLA? Link Level Aggregation?
Not sure what that has to do with VRF though... that's just bonding/teaming??
and seems to work fine without VRF at a (at least to me conceptually)
even lower layer.

> With 5.3 and up, you can have IPv4 routes with IPv6 LLA gateways with
> and without VRFs.

Ah, see... the latest phone hardware that I still don't have access to
(mostly because of covid),
is only 4.19 based (as such doing dev work on 4.14 or VMs, but getting
wifi/cell emulation
and ipv6 working right in VMs is very very hard, though we're making
slow progress).

5.4 hardware is probably 10 months out (assuming things return to normal).
We're always ~2 years behind, and playing catchup... :-(

And I recently switched some of our servers (those were stuck on 4.3
until very recently)
to use IPv4 egress routing via IPv6 ND, that's a great improvement
(and came at just the right time),
but again I guess I don't see how VRF fits in to the picture - this
seems to be just a use NDv6 for foo
instead of ARP for bar to figure out dst mac type of thing...

Obviously I haven't read your links, so perhaps all my questions will
be answered.
(I'm rambling, mostly writing this email to thank you for the links)
