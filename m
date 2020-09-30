Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2965D27E426
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 10:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbgI3It6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 04:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgI3It6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 04:49:58 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F672C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 01:49:57 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id q9so801898wmj.2
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 01:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intinor-se.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1/Xz/I+TvbpFgsEd8PbtMiC5GAx0+IjSML0Ly7vVaSw=;
        b=gPK2YMHvKKjuYTcOVO/V2RKcqXoBDPzYv5XRGCwfXpR02sVEvrC26bJ3TvBeYE2QLw
         edgtoczQQiS7txK1f1J046lHVJE7iOP5K9bne82g3X+JvdqeSJAUPV+KW3n0BMCGWxVA
         4b+4AUzCcm3cCyWAV7WYV/pNM/zATYA1BGmzKmEQeHyL+Rlt+n0/Lpji4zbWoccGpjGP
         7VzVxVs4Fl745cr1M1DV1M392FX9fbbxwCcb4IG/GyG029hzU4Np01w03He7A9NIiAaY
         xgWKmSG7p0NUteea0JLN1TXfKnyhhLNliDg7wnaXCamwiNA8Dq219cLFOEfgQHbMSaiO
         XmqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1/Xz/I+TvbpFgsEd8PbtMiC5GAx0+IjSML0Ly7vVaSw=;
        b=eQuZN7fN1MB78dETpBENLZnClzn7qcAXzhingo3/CYSlmOwMvo2XhygdrwaY6C706R
         gP9XpmvJaLTS4lmLzr5ttV12F+d8c05ekwHz9Evz7CLE3byd7Mse6voovzwgQnPbQruO
         y6RRSOrJrTfH2iFyleSGxu9r09wH051qiDiN0BDSKZ6HUDVsKXnnfHdGro2pjCpjkzq2
         MhY360IHKC38+N65gcN7xkf09Pa4GdiaPE/3MYgqNJ6QGKaDxxHi+xiTTwAXsJ8Ln1/3
         nhn2TYOD93Qu9tNmH6mcTCAMBEbiTocrrHneweyfN8hXdbGXgbiPr9N2Xk9FdCxHPvdV
         Iexw==
X-Gm-Message-State: AOAM531KwmQoiNL29vMvXJp4gOp653qN0BbjK2ztfXkRTVHZF/lBc2Uj
        V6ypgW9n37KAyJZV/VagFaEn434RYYgGAm51NyYDTg==
X-Google-Smtp-Source: ABdhPJxej6fNcoxhITuS+97FrwyBWU3rakfQPurDlRk0A7BI/IV4O1du9dPsbvH4X/CD3K8ZtlEG28VOufJ8ofHjYg8=
X-Received: by 2002:a05:600c:216:: with SMTP id 22mr1692564wmi.149.1601455796073;
 Wed, 30 Sep 2020 01:49:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAM7CaVQf-xymnx8y-nn7E3N6P5=-HF2i_1XhFgp1MZB1==WZiA@mail.gmail.com>
 <6be0e30c-e9ec-17ea-968b-6ec5a9559dac@gmail.com> <CAAkXG4f5YvZKxQ+2SgcOTwJ1ToGUQnCuSnOBZsXTke+fLcE_WA@mail.gmail.com>
 <CAM7CaVSCNO1MWNfzQhVwU0=hP_LYP9k1fzxyWTUfn2c9M-c8Ng@mail.gmail.com> <CAAkXG4dm69Z_mLnhuCu0EBwBcrqbxv=Z5+cfO2YJMWmmNy=L-w@mail.gmail.com>
In-Reply-To: <CAAkXG4dm69Z_mLnhuCu0EBwBcrqbxv=Z5+cfO2YJMWmmNy=L-w@mail.gmail.com>
From:   =?UTF-8?Q?Robert_Bengtsson=2D=C3=96lund?= 
        <robert.bengtsson-olund@intinor.se>
Date:   Wed, 30 Sep 2020 10:49:44 +0200
Message-ID: <CAM7CaVRUfix0-wfh8Z8SLOwxUSgDAzoFQPivq4iBi3j7kTaqXg@mail.gmail.com>
Subject: Re: Request for backport of 78dc70ebaa38aa303274e333be6c98eef87619e2
 to 4.19.y
To:     Priyaranjan Jha <priyarjha@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks.
/Robert

On Tue, 29 Sep 2020 at 19:25, Priyaranjan Jha <priyarjha@google.com> wrote:
>
>  The BBR ACK aggregation patches have been packported to 4.19 kernel,
> and are part of v4.19.148 stable release:
>   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=
=3Dv4.19.148
>
> Thanks,
> Priyaranjan
>
>
> On Tue, Aug 25, 2020 at 2:02 AM Robert Bengtsson-=C3=96lund
> <robert.bengtsson-olund@intinor.se> wrote:
> >
> > Much appreciated.
> >
> > Thank you everyone.
> > /Robert
> >
> >
> > On Mon, 24 Aug 2020 at 20:39, Priyaranjan Jha <priyarjha@google.com> wr=
ote:
> > >
> > > Thank you, Eric, Robert.
> > > We will try to provide the backport for the patch soon.
> > >
> > > Thanks,
> > > Priyaranjan
> > >
> > > (resending since previous reply bounced back)
> > > On Mon, Aug 24, 2020 at 9:14 AM Eric Dumazet <eric.dumazet@gmail.com>=
 wrote:
> > > >
> > > >
> > > >
> > > > On 8/24/20 7:35 AM, Robert Bengtsson-=C3=96lund wrote:
> > > > > Hi everyone
> > > > >
> > > > > We stumbled upon a TCP BBR throughput issue that the following ch=
ange fixes.
> > > > > git: 78dc70ebaa38aa303274e333be6c98eef87619e2
> > > > >
> > > > > Our issue:
> > > > > We have a transmission that is application limited to 20Mbps on a=
n
> > > > > ethernet connection that has ~1Gbps capacity.
> > > > > Without this change our transmission seems to settle at ~3.5Mbps.
> > > > >
> > > > > We have seen the issue on a slightly different network setup as w=
ell
> > > > > between two fiber internet connections.
> > > > >
> > > > > Due to what the mentioned commit changes we suspect some middlebo=
x
> > > > > plays with the ACK frequency in both of our cases.
> > > > >
> > > > > Our transmission is basically an RTMP feed through ffmpeg to Mist=
Server.
> > > > >
> > > > > Best regards
> > > > > /Robert
> > > > >
> > > >
> > > > Please always CC patch authors in this kind of requests.
> > > >
> > > > Thanks.
> > > >
> > > > Patch was :
> > > >
> > > > commit 78dc70ebaa38aa303274e333be6c98eef87619e2
> > > > Author: Priyaranjan Jha <priyarjha@google.com>
> > > > Date:   Wed Jan 23 12:04:54 2019 -0800
> > > >
> > > >     tcp_bbr: adapt cwnd based on ack aggregation estimation
> > > >
> > > >     Aggregation effects are extremely common with wifi, cellular, a=
nd cable
> > > >     modem link technologies, ACK decimation in middleboxes, and LRO=
 and GRO
> > > >     in receiving hosts. The aggregation can happen in either direct=
ion,
> > > >     data or ACKs, but in either case the aggregation effect is visi=
ble
> > > >     to the sender in the ACK stream.
> > > >
> > > >     Previously BBR's sending was often limited by cwnd under severe=
 ACK
> > > >     aggregation/decimation because BBR sized the cwnd at 2*BDP. If =
packets
> > > >     were acked in bursts after long delays (e.g. one ACK acking 5*B=
DP after
> > > >     5*RTT), BBR's sending was halted after sending 2*BDP over 2*RTT=
, leaving
> > > >     the bottleneck idle for potentially long periods. Note that los=
s-based
> > > >     congestion control does not have this issue because when facing
> > > >     aggregation it continues increasing cwnd after bursts of ACKs, =
growing
> > > >     cwnd until the buffer is full.
> > > >
> > > >     To achieve good throughput in the presence of aggregation effec=
ts, this
> > > >     algorithm allows the BBR sender to put extra data in flight to =
keep the
> > > >     bottleneck utilized during silences in the ACK stream that it h=
as evidence
> > > >     to suggest were caused by aggregation.
> > > >
> > > >     A summary of the algorithm: when a burst of packets are acked b=
y a
> > > >     stretched ACK or a burst of ACKs or both, BBR first estimates t=
he expected
> > > >     amount of data that should have been acked, based on its estima=
ted
> > > >     bandwidth. Then the surplus ("extra_acked") is recorded in a wi=
ndowed-max
> > > >     filter to estimate the recent level of observed ACK aggregation=
. Then cwnd
> > > >     is increased by the ACK aggregation estimate. The larger cwnd a=
voids BBR
> > > >     being cwnd-limited in the face of ACK silences that recent hist=
ory suggests
> > > >     were caused by aggregation. As a sanity check, the ACK aggregat=
ion degree
> > > >     is upper-bounded by the cwnd (at the time of measurement) and a=
 global max
> > > >     of BW * 100ms. The algorithm is further described by the follow=
ing
> > > >     presentation:
> > > >     https://datatracker.ietf.org/meeting/101/materials/slides-101-i=
ccrg-an-update-on-bbr-work-at-google-00
> > > >
> > > >     In our internal testing, we observed a significant increase in =
BBR
> > > >     throughput (measured using netperf), in a basic wifi setup.
> > > >     - Host1 (sender on ethernet) -> AP -> Host2 (receiver on wifi)
> > > >     - 2.4 GHz -> BBR before: ~73 Mbps; BBR after: ~102 Mbps; CUBIC:=
 ~100 Mbps
> > > >     - 5.0 GHz -> BBR before: ~362 Mbps; BBR after: ~593 Mbps; CUBIC=
: ~601 Mbps
> > > >
> > > >     Also, this code is running globally on YouTube TCP connections =
and produced
> > > >     significant bandwidth increases for YouTube traffic.
> > > >
> > > >     This is based on Ian Swett's max_ack_height_ algorithm from the
> > > >     QUIC BBR implementation.
> > > >
> > > >     Signed-off-by: Priyaranjan Jha <priyarjha@google.com>
> > > >     Signed-off-by: Neal Cardwell <ncardwell@google.com>
> > > >     Signed-off-by: Yuchung Cheng <ycheng@google.com>
> > > >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > > >
> >
> >
> >
> > --
> > Robert Bengtsson-=C3=96lund, System Developer
> > Software Development
> > +46(0)90-349 39 00
> >
> > www.intinor.com
> >
> > -- INTINOR --
> > WE ARE DIREKT



--=20
Robert Bengtsson-=C3=96lund, System Developer
Software Development
+46(0)90-349 39 00

www.intinor.com

-- INTINOR --
WE ARE DIREKT
