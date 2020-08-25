Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E015E2514EB
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgHYJCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgHYJCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 05:02:05 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED8BC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 02:02:05 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id o4so7871044wrn.0
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 02:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intinor-se.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W8pA2ifKvmS7Kz+eJefzxo1Hg47OftIXwh7RwBS9u9M=;
        b=wnb34B70xRvugcxvP8gxiC7cprltRJkKbpTen39LNM7dR7ZaqS99sZ2+sYY1mBxX5h
         eGgrbxSGvXcylnKGjZra5wAYKoIo4xwkZMtCGbFWZ8Cynzio9gWjU8vbNamktiA/rhGE
         3FrcPrCaWhCiSPJL0pw1AjwmOOm90XN5zLj1kfGuh8vc9I8NeTYETdTRSrgf3SN0TdkB
         GXEuY1153bCQ6mgg8TCj35pK+Z72ZP3ibWi/B4RKdwQdKac92cb5YFg1aXNWLSvzLMJ2
         gigRBxbPrAYo52h+bDmoXK21O73N1llWHErVGp01uboyzjP29Ui9lScNCbkifIwnNZrH
         gxUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W8pA2ifKvmS7Kz+eJefzxo1Hg47OftIXwh7RwBS9u9M=;
        b=AlvybLm+YrkrHW4PtlCWuUTA7NwNL9hqiTPAmSCpBXzP8Wp5B6kbepveNW+fbJ8VMC
         Hl3Ogt8jj2Y+uZ0UylKgVmd415FlPBa2cwaQ6wKrbQQqWtyJ1+MiSK/2RCXCvLJ8uZ9T
         sAe1dXrOSjR2b0+6ufVu//azDTBThobtemUJuQ6M3YI2iQUfxRuEj6X4nelS4JnYlTEJ
         iXlmzF2gU6WGegrBIq/JywztTkz+9I7JmJisgV8eb9VYZC1VF7Psyd/1Vm5Xkq2qoUZf
         8a27oOEAi7KCCiBWbEfgcTeWIRpnkCXgWb5vmOxQdXcVngkIQa+rJYVgESgflSZffVrX
         wcSw==
X-Gm-Message-State: AOAM533PmoNS07gDyg5gJJVEZ+3xKW0445tBpifCSfjTtyXN37NO43F+
        wSgYKQciiJs/RfA0p+wQEuNdJnbgBEDU7D8VaPXB3Q==
X-Google-Smtp-Source: ABdhPJyixPz8WeHjWsTnHHhsIOhOs8rZpG68UaI4+brFXB61jWg6YLOlA77TGx8UBnr7b65ShzD1oC7Oe8FPxToEIjs=
X-Received: by 2002:a5d:52c1:: with SMTP id r1mr2741983wrv.224.1598346123928;
 Tue, 25 Aug 2020 02:02:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAM7CaVQf-xymnx8y-nn7E3N6P5=-HF2i_1XhFgp1MZB1==WZiA@mail.gmail.com>
 <6be0e30c-e9ec-17ea-968b-6ec5a9559dac@gmail.com> <CAAkXG4f5YvZKxQ+2SgcOTwJ1ToGUQnCuSnOBZsXTke+fLcE_WA@mail.gmail.com>
In-Reply-To: <CAAkXG4f5YvZKxQ+2SgcOTwJ1ToGUQnCuSnOBZsXTke+fLcE_WA@mail.gmail.com>
From:   =?UTF-8?Q?Robert_Bengtsson=2D=C3=96lund?= 
        <robert.bengtsson-olund@intinor.se>
Date:   Tue, 25 Aug 2020 11:01:52 +0200
Message-ID: <CAM7CaVSCNO1MWNfzQhVwU0=hP_LYP9k1fzxyWTUfn2c9M-c8Ng@mail.gmail.com>
Subject: Re: Request for backport of 78dc70ebaa38aa303274e333be6c98eef87619e2
 to 4.19.y
To:     Priyaranjan Jha <priyarjha@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Much appreciated.

Thank you everyone.
/Robert


On Mon, 24 Aug 2020 at 20:39, Priyaranjan Jha <priyarjha@google.com> wrote:
>
> Thank you, Eric, Robert.
> We will try to provide the backport for the patch soon.
>
> Thanks,
> Priyaranjan
>
> (resending since previous reply bounced back)
> On Mon, Aug 24, 2020 at 9:14 AM Eric Dumazet <eric.dumazet@gmail.com> wro=
te:
> >
> >
> >
> > On 8/24/20 7:35 AM, Robert Bengtsson-=C3=96lund wrote:
> > > Hi everyone
> > >
> > > We stumbled upon a TCP BBR throughput issue that the following change=
 fixes.
> > > git: 78dc70ebaa38aa303274e333be6c98eef87619e2
> > >
> > > Our issue:
> > > We have a transmission that is application limited to 20Mbps on an
> > > ethernet connection that has ~1Gbps capacity.
> > > Without this change our transmission seems to settle at ~3.5Mbps.
> > >
> > > We have seen the issue on a slightly different network setup as well
> > > between two fiber internet connections.
> > >
> > > Due to what the mentioned commit changes we suspect some middlebox
> > > plays with the ACK frequency in both of our cases.
> > >
> > > Our transmission is basically an RTMP feed through ffmpeg to MistServ=
er.
> > >
> > > Best regards
> > > /Robert
> > >
> >
> > Please always CC patch authors in this kind of requests.
> >
> > Thanks.
> >
> > Patch was :
> >
> > commit 78dc70ebaa38aa303274e333be6c98eef87619e2
> > Author: Priyaranjan Jha <priyarjha@google.com>
> > Date:   Wed Jan 23 12:04:54 2019 -0800
> >
> >     tcp_bbr: adapt cwnd based on ack aggregation estimation
> >
> >     Aggregation effects are extremely common with wifi, cellular, and c=
able
> >     modem link technologies, ACK decimation in middleboxes, and LRO and=
 GRO
> >     in receiving hosts. The aggregation can happen in either direction,
> >     data or ACKs, but in either case the aggregation effect is visible
> >     to the sender in the ACK stream.
> >
> >     Previously BBR's sending was often limited by cwnd under severe ACK
> >     aggregation/decimation because BBR sized the cwnd at 2*BDP. If pack=
ets
> >     were acked in bursts after long delays (e.g. one ACK acking 5*BDP a=
fter
> >     5*RTT), BBR's sending was halted after sending 2*BDP over 2*RTT, le=
aving
> >     the bottleneck idle for potentially long periods. Note that loss-ba=
sed
> >     congestion control does not have this issue because when facing
> >     aggregation it continues increasing cwnd after bursts of ACKs, grow=
ing
> >     cwnd until the buffer is full.
> >
> >     To achieve good throughput in the presence of aggregation effects, =
this
> >     algorithm allows the BBR sender to put extra data in flight to keep=
 the
> >     bottleneck utilized during silences in the ACK stream that it has e=
vidence
> >     to suggest were caused by aggregation.
> >
> >     A summary of the algorithm: when a burst of packets are acked by a
> >     stretched ACK or a burst of ACKs or both, BBR first estimates the e=
xpected
> >     amount of data that should have been acked, based on its estimated
> >     bandwidth. Then the surplus ("extra_acked") is recorded in a window=
ed-max
> >     filter to estimate the recent level of observed ACK aggregation. Th=
en cwnd
> >     is increased by the ACK aggregation estimate. The larger cwnd avoid=
s BBR
> >     being cwnd-limited in the face of ACK silences that recent history =
suggests
> >     were caused by aggregation. As a sanity check, the ACK aggregation =
degree
> >     is upper-bounded by the cwnd (at the time of measurement) and a glo=
bal max
> >     of BW * 100ms. The algorithm is further described by the following
> >     presentation:
> >     https://datatracker.ietf.org/meeting/101/materials/slides-101-iccrg=
-an-update-on-bbr-work-at-google-00
> >
> >     In our internal testing, we observed a significant increase in BBR
> >     throughput (measured using netperf), in a basic wifi setup.
> >     - Host1 (sender on ethernet) -> AP -> Host2 (receiver on wifi)
> >     - 2.4 GHz -> BBR before: ~73 Mbps; BBR after: ~102 Mbps; CUBIC: ~10=
0 Mbps
> >     - 5.0 GHz -> BBR before: ~362 Mbps; BBR after: ~593 Mbps; CUBIC: ~6=
01 Mbps
> >
> >     Also, this code is running globally on YouTube TCP connections and =
produced
> >     significant bandwidth increases for YouTube traffic.
> >
> >     This is based on Ian Swett's max_ack_height_ algorithm from the
> >     QUIC BBR implementation.
> >
> >     Signed-off-by: Priyaranjan Jha <priyarjha@google.com>
> >     Signed-off-by: Neal Cardwell <ncardwell@google.com>
> >     Signed-off-by: Yuchung Cheng <ycheng@google.com>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> >



--=20
Robert Bengtsson-=C3=96lund, System Developer
Software Development
+46(0)90-349 39 00

www.intinor.com

-- INTINOR --
WE ARE DIREKT
