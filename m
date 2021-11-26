Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0589B45EFE1
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 15:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353586AbhKZObY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 09:31:24 -0500
Received: from mout.gmx.net ([212.227.15.19]:50027 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377680AbhKZO3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 09:29:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1637936761;
        bh=RORlYk3nCRBTNpL3jgHcU3QrBA0W44b6IbvLH9lXNQA=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=hICtennXYLiECVSfC+rWTnPKZWhXA3V3kvXM4bP/WlO3JIchIhwr06zVfVmfys/Qd
         epuuKyIYnWB6RJCxrAvKRZVTqmYGdqXbJHb7YnHC5FtXyVKmPfit7tbtbXJyOpY/vD
         BYCU0NdXcnslqS9uEX5GxxOMeJrr6K9LXr9WXLgY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost ([62.216.209.164]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MXGvM-1n7Yut2gG6-00Ygws; Fri, 26
 Nov 2021 15:26:01 +0100
Date:   Fri, 26 Nov 2021 15:25:58 +0100
From:   Peter Seiderer <ps.report@gmx.net>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC v2] mac80211: minstrel_ht: do not set RTS/CTS flag for
 fallback rates
Message-ID: <20211126152558.4d9fbce3@gmx.net>
In-Reply-To: <e098a58a-8ec0-f90d-dbc9-7b621e31d051@nbd.name>
References: <20211116212828.27613-1-ps.report@gmx.net>
        <e098a58a-8ec0-f90d-dbc9-7b621e31d051@nbd.name>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0wYbdN4fhkxA4iepLxNMYjwuxCqluactjjNyhttz1I5sOv0NkEY
 iYWF5PU1uhapP4Z6CDymiVDkD7xIuCf+6p//d6yfXIMjm8INQLyykUubjIh9ofnQr/r+WRX
 Ulao9sRBulcIBIaOxvFOaxghSRrycsbAhKTGWHR1X11l9Stcor6np9PB4LpLh0BdgV1jkny
 PaT9Ty8WuJolZKb0QmHaw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:kawEkXoYq94=:4WlTbTEqyqne8UDa1lQP1j
 vHHHEt53IUvgOu+OILFiG77UeO4aMTLnuxF8GvTUWOpRZSkJO1816wxV4kDGxuOJKrIo4uFjM
 3b1D84asCHQnvBigs27wgYnMJ+2aSu5hxLXMSRw77UWbxMW+qI1Kve4vGjtifu63ZM8NrQN0r
 GyqCzYT+8UOrRtMaq0HOIr7z0dsL/cK4r+/IZcgAEI+T+pQgq0aph0qvH0OiPEHZR148hHGbu
 S8ZWLgB6XNpb0NZooYrSyh1VsX/5V1mV2PrPghEP1R6DKrPI5ImKtp8kJJ7lONPCkUNwd5Rk2
 lWU74MGxxWTSEjeBf6BRXEoamIglUUwzN5BWr7u89Csv7BCYx6MPWDPeB76LCk0xrawVgXLzd
 Llhk0NcKoe5l6Ri3NJR2DuryQ/+LnY+qbc5X5Bmy4zrbXGSHR1X1MBKt95x11wNMxTCtLUokD
 cmxQvw8cuxOAbiB6h1ZZLpSf29PytcYfL+aInoqVB1psOMXW8VkJkD93IlbWUtbOd8WJLzEyQ
 ziRe+4fbNb4EFhgQ42jFqJho7GRezWciASuQTCSg/3GB6EB3sejeRh6AvHHFo8AfQ91ZwSkqG
 ZWveXxZj2qRgdrXNAg/rfqbGe3uiCLVUH+mXM3BOO70hOncVUANpilu1apWyexkWsr3JzLZcA
 TkxV4sLuXPWPWmWONHWqdhWeoDzxCLXKBk8hjJvF1CTOau2mBrwUPc8YF395GECZPH4ohytS4
 mL0D7RKwQAKkybZXrOQ4wQdytQkvdJRr/H88EYt1SBOfsWrmfZpyJM3B189tfzhiWkH9EQmS4
 DTZ1M2rEz1OXUNUs6+EqXyT8K6/ctSQDiEjBk1bLHL1AX48deIKpePBQGBZxiCRAka6B3Zx/e
 QFvT/krcCjCwMIddcbsA/ygTgLa8Wr/CmvDFaS/1VFRak78tSiLCzcBU2AB9OZII2ozRjFb27
 O3qDGsioVoBDh7VjhsoaiR9+FcjijKwEFvXcIG2ff6aJ6XJ/5XXQ/UpBeKzR/qRzrf8BzJsiV
 wfsPP5DW8M0C+4FTppaHfkLDiZTRCFmBkKELuxX7SSw7yScSR3gGIvqHcexw4KmUz9830+//b
 cYnZUcMSQhripo=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Felix,

On Fri, 26 Nov 2021 13:47:07 +0100, Felix Fietkau <nbd@nbd.name> wrote:

> On 2021-11-16 22:28, Peter Seiderer wrote:
> > Despite the 'RTS thr:off' setting a wireshark trace of IBSS
> > traffic with HT40 mode enabled between two ath9k cards revealed
> > some RTS/CTS traffic.
> >
> > Debug and code analysis showed that most places setting
> > IEEE80211_TX_RC_USE_RTS_CTS respect the RTS strategy by
> > evaluating rts_threshold, e.g. net/mac80211/tx.c:
> >
> >   698         /* set up RTS protection if desired */
> >   699         if (len > tx->local->hw.wiphy->rts_threshold) {
> >   700                 txrc.rts =3D true;
> >   701         }
> >   702
> >   703         info->control.use_rts =3D txrc.rts;
> >
> > or drivers/net/wireless/ath/ath9k/xmit.c
> >
> > 1238                 /*
> > 1239                  * Handle RTS threshold for unaggregated HT frame=
s.
> > 1240                  */
> > 1241                 if (bf_isampdu(bf) && !bf_isaggr(bf) &&
> > 1242                     (rates[i].flags & IEEE80211_TX_RC_MCS) &&
> > 1243                     unlikely(rts_thresh !=3D (u32) -1)) {
> > 1244                         if (!rts_thresh || (len > rts_thresh))
> > 1245                                 rts =3D true;
> > 1246                 }
> >
> > The only place setting IEEE80211_TX_RC_USE_RTS_CTS unconditionally
> > was found in net/mac80211/rc80211_minstrel_ht.c.
> >
> > As the use_rts value is only calculated after hitting the minstrel_ht =
code
> > preferre to not set IEEE80211_TX_RC_USE_RTS_CTS (and overruling the
> > RTS threshold setting) for the fallback rates case.
> The idea behind the this part of minstrel_ht code is to avoid the
> overhead of RTS/CTS for transmissions using the primary rate and to
> increase the reliability of retransmissions by adding it for fallback
> rates. This is completely unrelated to the RTS threshold.

How does it avoid RTS/CTS (if it is set independent by RTS threshold
evaluation mac80211 and/or hardware driver)?

>
> If you don't want this behavior, I'm fine with adding a way to
> explicitly disable it. However, I do think leaving it on by default
> makes sense.

I expected this (as otherwise the flag setting would not be there) ;-)

Any hint how to implement an additional RTS/CTS on/off feature despite
the RTS threshold one for use explicit by minstrel_ht? Configure option,
module option, ...?

Regards,
Peter

>
> - Felix

