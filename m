Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936EB27D463
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgI2RZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgI2RZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 13:25:40 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29F1C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 10:25:38 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z4so6341435wrr.4
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 10:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MYpTYuu4agKjMQXHj+TweRWZXHCnrKqyeZiIcROpSB8=;
        b=Zv7K3jnTV/GPvlksQhFWBoVK3FaT5nKErMQ/6QCWW3odEE435QnthvtF3mmAEqRcCx
         la1uj4tRPSmSxWBOQ3vY7WB4BMHBXlM/bqtyC8AfdW1VRYDNKfIcQUOxLEGB3aykP3jH
         SQObOStjNswUxA9fAUi6ZmFhywTpNSFgGy7hRbT2f5b6wh6CJHPMnRVkXNLlrAYgmRMQ
         Rqd+G28J6AAQNAaIUl2sk1GpFnRPFXZCZjzXD7ZdsQ0C2Bc/S6RW+vfG3j39K8wCqJj6
         ER2cHPqJAC4+0dFf1y9+K7jb0sYHwxbc4D70TbTcYwPMZSLgUeNtJkZqe8gGcC6bmOH9
         rfdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MYpTYuu4agKjMQXHj+TweRWZXHCnrKqyeZiIcROpSB8=;
        b=BwktxTI80eWffiE/6cmDfjSpfWvuEZ128C5fEy6Z0PxoQ/AdvQj/v/czcb1kr2Cl9X
         nmkwpjAfPL3X92bziOjvAhDb91TfrrSZ31iAztA4FOgxSEFe2ZcMKPLrCbwKFJhvMgd7
         Ks1oJLsrJ9Ylc6XLrGdLjwfRzh3wcu29nJOePrgs1fqgKxAM9A4J3aZVCNK9nZB3MnoZ
         ceI2vpsO9arETIUed3+o4HSWSauTeeojyhNEzICtcX1PPsdSmaxsDG9MkzglM+/8SPF2
         IjM9c8dmvtbCAh6/Bo/kpgLhFP0ZGlv1QlGUwooSFluAoxJNkpmHdV0RxqDheQzoLHxQ
         gyFg==
X-Gm-Message-State: AOAM530/7mYk5uQFXqTZ6io3yAQqwT4L64cM0hd0sbKSXRr4vjSPuJsN
        4MTyooQqEGEzVWF+jx3YtR1ejroQkI4PalDYzt0gjw==
X-Google-Smtp-Source: ABdhPJxH5zxNZd1yVJ3A1sS9duo2Ap3YcB2HEgwFbk3W9g28mbIMZ+oOqjzqPrv6Se1RVxivSPbZ/kWyih/G5L+vQh0=
X-Received: by 2002:adf:ed12:: with SMTP id a18mr5870649wro.178.1601400336965;
 Tue, 29 Sep 2020 10:25:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAM7CaVQf-xymnx8y-nn7E3N6P5=-HF2i_1XhFgp1MZB1==WZiA@mail.gmail.com>
 <6be0e30c-e9ec-17ea-968b-6ec5a9559dac@gmail.com> <CAAkXG4f5YvZKxQ+2SgcOTwJ1ToGUQnCuSnOBZsXTke+fLcE_WA@mail.gmail.com>
 <CAM7CaVSCNO1MWNfzQhVwU0=hP_LYP9k1fzxyWTUfn2c9M-c8Ng@mail.gmail.com>
In-Reply-To: <CAM7CaVSCNO1MWNfzQhVwU0=hP_LYP9k1fzxyWTUfn2c9M-c8Ng@mail.gmail.com>
From:   Priyaranjan Jha <priyarjha@google.com>
Date:   Tue, 29 Sep 2020 10:25:25 -0700
Message-ID: <CAAkXG4dm69Z_mLnhuCu0EBwBcrqbxv=Z5+cfO2YJMWmmNy=L-w@mail.gmail.com>
Subject: Re: Request for backport of 78dc70ebaa38aa303274e333be6c98eef87619e2
 to 4.19.y
To:     =?UTF-8?Q?Robert_Bengtsson=2D=C3=96lund?= 
        <robert.bengtsson-olund@intinor.se>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 The BBR ACK aggregation patches have been packported to 4.19 kernel,
and are part of v4.19.148 stable release:
  https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=
=3Dv4.19.148

Thanks,
Priyaranjan


On Tue, Aug 25, 2020 at 2:02 AM Robert Bengtsson-=C3=96lund
<robert.bengtsson-olund@intinor.se> wrote:
>
> Much appreciated.
>
> Thank you everyone.
> /Robert
>
>
> On Mon, 24 Aug 2020 at 20:39, Priyaranjan Jha <priyarjha@google.com> wrot=
e:
> >
> > Thank you, Eric, Robert.
> > We will try to provide the backport for the patch soon.
> >
> > Thanks,
> > Priyaranjan
> >
> > (resending since previous reply bounced back)
> > On Mon, Aug 24, 2020 at 9:14 AM Eric Dumazet <eric.dumazet@gmail.com> w=
rote:
> > >
> > >
> > >
> > > On 8/24/20 7:35 AM, Robert Bengtsson-=C3=96lund wrote:
> > > > Hi everyone
> > > >
> > > > We stumbled upon a TCP BBR throughput issue that the following chan=
ge fixes.
> > > > git: 78dc70ebaa38aa303274e333be6c98eef87619e2
> > > >
> > > > Our issue:
> > > > We have a transmission that is application limited to 20Mbps on an
> > > > ethernet connection that has ~1Gbps capacity.
> > > > Without this change our transmission seems to settle at ~3.5Mbps.
> > > >
> > > > We have seen the issue on a slightly different network setup as wel=
l
> > > > between two fiber internet connections.
> > > >
> > > > Due to what the mentioned commit changes we suspect some middlebox
> > > > plays with the ACK frequency in both of our cases.
> > > >
> > > > Our transmission is basically an RTMP feed through ffmpeg to MistSe=
rver.
> > > >
> > > > Best regards
> > > > /Robert
> > > >
> > >
> > > Please always CC patch authors in this kind of requests.
> > >
> > > Thanks.
> > >
> > > Patch was :
> > >
> > > commit 78dc70ebaa38aa303274e333be6c98eef87619e2
> > > Author: Priyaranjan Jha <priyarjha@google.com>
> > > Date:   Wed Jan 23 12:04:54 2019 -0800
> > >
> > >     tcp_bbr: adapt cwnd based on ack aggregation estimation
> > >
> > >     Aggregation effects are extremely common with wifi, cellular, and=
 cable
> > >     modem link technologies, ACK decimation in middleboxes, and LRO a=
nd GRO
> > >     in receiving hosts. The aggregation can happen in either directio=
n,
> > >     data or ACKs, but in either case the aggregation effect is visibl=
e
> > >     to the sender in the ACK stream.
> > >
> > >     Previously BBR's sending was often limited by cwnd under severe A=
CK
> > >     aggregation/decimation because BBR sized the cwnd at 2*BDP. If pa=
ckets
> > >     were acked in bursts after long delays (e.g. one ACK acking 5*BDP=
 after
> > >     5*RTT), BBR's sending was halted after sending 2*BDP over 2*RTT, =
leaving
> > >     the bottleneck idle for potentially long periods. Note that loss-=
based
> > >     congestion control does not have this issue because when facing
> > >     aggregation it continues increasing cwnd after bursts of ACKs, gr=
owing
> > >     cwnd until the buffer is full.
> > >
> > >     To achieve good throughput in the presence of aggregation effects=
, this
> > >     algorithm allows the BBR sender to put extra data in flight to ke=
ep the
> > >     bottleneck utilized during silences in the ACK stream that it has=
 evidence
> > >     to suggest were caused by aggregation.
> > >
> > >     A summary of the algorithm: when a burst of packets are acked by =
a
> > >     stretched ACK or a burst of ACKs or both, BBR first estimates the=
 expected
> > >     amount of data that should have been acked, based on its estimate=
d
> > >     bandwidth. Then the surplus ("extra_acked") is recorded in a wind=
owed-max
> > >     filter to estimate the recent level of observed ACK aggregation. =
Then cwnd
> > >     is increased by the ACK aggregation estimate. The larger cwnd avo=
ids BBR
> > >     being cwnd-limited in the face of ACK silences that recent histor=
y suggests
> > >     were caused by aggregation. As a sanity check, the ACK aggregatio=
n degree
> > >     is upper-bounded by the cwnd (at the time of measurement) and a g=
lobal max
> > >     of BW * 100ms. The algorithm is further described by the followin=
g
> > >     presentation:
> > >     https://datatracker.ietf.org/meeting/101/materials/slides-101-icc=
rg-an-update-on-bbr-work-at-google-00
> > >
> > >     In our internal testing, we observed a significant increase in BB=
R
> > >     throughput (measured using netperf), in a basic wifi setup.
> > >     - Host1 (sender on ethernet) -> AP -> Host2 (receiver on wifi)
> > >     - 2.4 GHz -> BBR before: ~73 Mbps; BBR after: ~102 Mbps; CUBIC: ~=
100 Mbps
> > >     - 5.0 GHz -> BBR before: ~362 Mbps; BBR after: ~593 Mbps; CUBIC: =
~601 Mbps
> > >
> > >     Also, this code is running globally on YouTube TCP connections an=
d produced
> > >     significant bandwidth increases for YouTube traffic.
> > >
> > >     This is based on Ian Swett's max_ack_height_ algorithm from the
> > >     QUIC BBR implementation.
> > >
> > >     Signed-off-by: Priyaranjan Jha <priyarjha@google.com>
> > >     Signed-off-by: Neal Cardwell <ncardwell@google.com>
> > >     Signed-off-by: Yuchung Cheng <ycheng@google.com>
> > >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > >
>
>
>
> --
> Robert Bengtsson-=C3=96lund, System Developer
> Software Development
> +46(0)90-349 39 00
>
> www.intinor.com
>
> -- INTINOR --
> WE ARE DIREKT
