Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5D01BBD92
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 14:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgD1M1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 08:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726763AbgD1M1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 08:27:39 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7944C03C1A9;
        Tue, 28 Apr 2020 05:27:37 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id f82so19963815ilh.8;
        Tue, 28 Apr 2020 05:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fco1XW6pLNbNH1bTQSneNHaMTNqKruW1B0uX8/WhHVs=;
        b=AmFEmsyfIOpZAYZ0R0mb8Fcj7dtyg5nxj3iXNZn1m2v+dixLWn9hUDhajNZ7RPVjdf
         8AfdWsFyqdTXQF8a5MPRbZbhOsR5Cn5H2yaOJ9qENP0ilH+vJhYB1hoiNBYBrQlpOd9Q
         79r6+fgwERu8xXYiqLZFrvGJ5WkIc6zv6/CqhwEVYXLDZNheBcac3hHam/VUTkoOQu8j
         tq1iSKFjbZnwxmDP5m871VTBl+0ycQgvN8Pv+b/It2PTwLEjOvtOTS2CLcUV8KWidvgR
         vRB2WnDpXiYU93I3Q5oOIPyNoaL97if4axW9n+RCJC/B4DGF//9nDM2xiTNjKXOLrsFR
         wdGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fco1XW6pLNbNH1bTQSneNHaMTNqKruW1B0uX8/WhHVs=;
        b=lQfEGwrxqYCxmXUejkSZneLJpcU1zSlGmg3czHAGqLqM6k3jZRP7Dg2fm27k2lpyNE
         nbIT2H73whcuscwB1x1VvXxcRsSM6Hc3RCjc16cz7FRn/pQhUpzuLHibBMEILIKr+Gm3
         bfvnc+ag0kyyggZ73On6Vsa9BuOm4lQddz8uH3cvJojKmp6vATraGycZE6qT4fDsxWoV
         6hKsrLomfl1ddE2zaM6o7uTSJ7uAi357R29ywa7KpoWmTOISDrkpyvKfVl1mRiUCqkCY
         NG+fhaBw3FUntJ/cFBy/3CTcym71x5RZKlmxVtkvzaS2o8uItMLc4f/Tg6hHSaQRvqt1
         B/uw==
X-Gm-Message-State: AGi0PubLKFo1SCrUH5aOYzpP6BRhN1MFgeEBqEXXrq4JobKi/xS40ZRk
        ri5onyFC0CFHlV1vmSH1s/2N/7mE31fPdUf+vRw=
X-Google-Smtp-Source: APiQypLp18CNKCYUQrhm+QbwkYcDgQiNWW/A63FEGHkY8gWBCgF6SzUnHY0ZhCS04zxHYOUex7NTURTaCKDJwuhREqs=
X-Received: by 2002:a92:c7a9:: with SMTP id f9mr27216527ilk.0.1588076857153;
 Tue, 28 Apr 2020 05:27:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200205191043.21913-1-linus.luessing@c0d3.blue>
 <3300912.TRQvxCK2vZ@bentobox> <3097447.aZuNXRJysd@sven-edge> <87blnblsyv.fsf@codeaurora.org>
In-Reply-To: <87blnblsyv.fsf@codeaurora.org>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Tue, 28 Apr 2020 05:27:25 -0700
Message-ID: <CAA93jw6xoh=Nu3-OcfU5cnO5rct+QGqRf_Tnwx7-BpO8Fhrakw@mail.gmail.com>
Subject: Re: [PATCH] ath10k: increase rx buffer size to 2048
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Sven Eckelmann <sven@narfation.org>,
        ath10k <ath10k@lists.infradead.org>,
        =?UTF-8?Q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Linus_L=C3=BCssing?= <ll@simonwunderlich.de>,
        mail@adrianschmutzler.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 5:06 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Sven Eckelmann <sven@narfation.org> writes:
>
> > On Wednesday, 1 April 2020 09:00:49 CEST Sven Eckelmann wrote:
> >> On Wednesday, 5 February 2020 20:10:43 CEST Linus L=C3=BCssing wrote:
> >> > From: Linus L=C3=BCssing <ll@simonwunderlich.de>
> >> >
> >> > Before, only frames with a maximum size of 1528 bytes could be
> >> > transmitted between two 802.11s nodes.
> >> >
> >> > For batman-adv for instance, which adds its own header to each frame=
,
> >> > we typically need an MTU of at least 1532 bytes to be able to transm=
it
> >> > without fragmentation.
> >> >
> >> > This patch now increases the maxmimum frame size from 1528 to 1656
> >> > bytes.
> >> [...]
> >>
> >> @Kalle, I saw that this patch was marked as deferred [1] but I couldn'=
t find
> >> any mail why it was done so. It seems like this currently creates real=
 world
> >> problems - so would be nice if you could explain shortly what is curre=
ntly
> >> blocking its acceptance.
> >
> > Ping?
>
> Sorry for the delay, my plan was to first write some documentation about
> different hardware families but haven't managed to do that yet.
>
> My problem with this patch is that I don't know what hardware and
> firmware versions were tested, so it needs analysis before I feel safe
> to apply it. The ath10k hardware families are very different that even
> if a patch works perfectly on one ath10k hardware it could still break
> badly on another one.
>
> What makes me faster to apply ath10k patches is to have comprehensive
> analysis in the commit log. This shows me the patch author has
> considered about all hardware families, not just the one he is testing
> on, and that I don't need to do the analysis myself.

I have been struggling to get the ath10k to sing and dance using
various variants
of the firmware, on this bug over here:

https://forum.openwrt.org/t/aql-and-the-ath10k-is-lovely/

The puzzling thing is the loss of bidirectional throughput at codel target =
20,
and getting WAY more (but less than I expected) at codel target 5.

This doesn't quite have bearing the size of the rx ring, except that in my
experiments the rx ring is rather small!! and yet I get way more performanc=
e
out of it....

(still,  as you'll see from the bug, it's WAY better than it used to be)

is NAPI in this driver? I'm afraid to look.
> --
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches



--=20
Make Music, Not War

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-435-0729
