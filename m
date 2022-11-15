Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1817D6297D2
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 12:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiKOL5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 06:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiKOL5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 06:57:37 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EA317E29
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 03:57:35 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id v17so21512957edc.8
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 03:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5DmhFDazyUzrb9m31UPQqw+p6xW5I/lIFmvqcHXx144=;
        b=Mg9wLpKO71meH4LOpjlHIoqiSVDzba1mA1aRwUAfTH5sy6rT0mLMgBhwyAyaQqrZG6
         pRxaPG7WUyajrZN9VMVPtJSP9n/JzHy2254IAFzZo8edxe7sFZaqpL+HBV3ymn8U/X5o
         Tl0SorhUWTXgQsJ0mIqUyPVhmYmmhOSRdTpBqFKYCHUFMkEecPzdx8UD7SYPfIvXewKD
         /yGvrn7LPFL1MwNcypSbtMu7qtlmmQpYqtlCGP8SXGL23QdGToXNAODTdTKsIkQWJmI8
         Ox6CcEkkO3gsw18RjzbC3wwJPto3G5ECcnQ9k+FYjeSulqasUW/w+FofdtCAum3XK3Lp
         0B5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5DmhFDazyUzrb9m31UPQqw+p6xW5I/lIFmvqcHXx144=;
        b=jklBSQ3EwMexcC43Tcr8Dn5rfLGgo5vOtBjKjbR/8eMOvmjG7U+vhZzQNJ9cOZbrrY
         mUSJjEk/4KPlcIf7hHN0l0CqUC0ToU+seo6V2WhiUAvAKEDwxvRxSB0iIhoC8mINnxRO
         qocrYRpcfffedgDPrwa1iBdo0reOCftVKDDRhJoN/qa3SQ8t0NR4p5bcCTF2Jpso63tc
         KNYuQsAQ/DUWF6y0/2NyQglVM52NsHBcshVsQV7LCG+zU1vadb0Vjn3xF00dRnM+r6of
         M4M5u6rQ9mZKlCak2hl5siOVZEQYjTcRpbE/ZxaTfj0gonm0XXU1KWf+Z8E53mX6aAnl
         KVrA==
X-Gm-Message-State: ANoB5pkF8x1ej+mx9mG77Hmlgq25x48yRHRaWmOCQwgTApOpEeYM0TZI
        orr75UzPFNqsmPRvKYxzzqknPp/OSc0EDzSr4I8=
X-Google-Smtp-Source: AA0mqf5bDXmfKjKRjORU+O6rvewEGPx4qkLlE1EaSh7/Oug+eO5fE6JAaGbEaJ1S0TxJAUURx7Q0BNK4hptgjUmKQQ8=
X-Received: by 2002:aa7:cdc1:0:b0:459:41fa:8e07 with SMTP id
 h1-20020aa7cdc1000000b0045941fa8e07mr14463352edw.140.1668513453382; Tue, 15
 Nov 2022 03:57:33 -0800 (PST)
MIME-Version: 1.0
References: <20221109180249.4721-1-dnlplm@gmail.com> <20221109180249.4721-2-dnlplm@gmail.com>
 <20221111090720.278326d1@kernel.org> <8b0aba42-627a-f5f5-a9ec-237b69b3b03f@nvidia.com>
 <CAGRyCJF49NMTt9aqPhF_Yp5T3cof_GtL7+v8PeowsBQWG0bkJQ@mail.gmail.com> <CAA93jw4OAWRAg+BxftuMgFaHex+BAeV3bS5JUYU7_+pM8ZOaEA@mail.gmail.com>
In-Reply-To: <CAA93jw4OAWRAg+BxftuMgFaHex+BAeV3bS5JUYU7_+pM8ZOaEA@mail.gmail.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Tue, 15 Nov 2022 12:51:13 +0100
Message-ID: <CAGRyCJFG0kybDzwYrdj2-Y868KbePCVBxFXsOo5TTJ_4PwrQDQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] ethtool: add tx aggregation parameters
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave,

Il giorno lun 14 nov 2022 alle ore 11:46 Dave Taht
<dave.taht@gmail.com> ha scritto:
> > Tx packets aggregation allows to overcome this issue, so that a single
> > URB holds N qmap packets, reducing URBs frequency.
>
> While I understand the use case... it's generally been my hope we got
> to a BQL-like mechanism for
> 4G and 5G that keeps the latency under control. Right now, that can be
> really, really, really miserable -
> measured in *seconds* - and adding in packet aggregation naively is
> what messed up Wifi for the
> past decade. Please lose 8 minutes of your life to this (hilarious)
> explanation of why aggregation can be bad.
>
> https://www.youtube.com/watch?v=3DRb-UnHDw02o&t=3D1560s
>

Nice video and really instructive :-)

> So given a choice between being able to drive the modem at the maximum
> rate in a testbed...
> or having it behave well at all possible (and highly variable) egress
> rates, I would so love for more to focus on the latter problem than
> the former, at whatever levels and layers in the stack it takes.
>

I get your point, but here it's not just a testbed issue, since I
think that the huge tx drop due to a concurrent rx can happen also in
real life scenarios.

Additionally, it seems that Qualcomm modems are meant to be used in
this way: as far as I know all QC downstream kernel versions have this
kind of feature in the rmnet code.

I think that this can be seen as adding one more choice for the user:
by default tx aggregation in rmnet would be disabled, so no one should
notice this change and suffer from latencies different than the ones
the current rmnet driver already has.

But for those that are affected by the same bug I'm facing or are
interested in a different use-case in which tx aggregation makes
sense, this feature can help.

Hope that this makes sense.

> As a test, what happens on the flent "rrul" test, before and after
> this patch? Under good wireless conditions, and bad?
>
> flent -H server -t my-test-conditions -x --socket-stats rrul
> flent -H server -t my-test-conditions -x --socket-stats
> --test-parameter=3Dupload_streams=3D4 tcp_nup
>
> I have servers for that all over the world
> {de,london,fremont,dallas,singapore,toronto,}.starlink.taht.net
>

I've uploaded some results at
https://drive.google.com/drive/folders/1-HjhyJaN4oWRNv8P8C__KD9-V-IoBwbL?us=
p=3Dsharing

The good network condition has been simulated through a callbox
connected to LAN (there are also a few pictures of the throughput on
the callbox side while performing the tests with tx aggregation
enabled/disabled).

Thanks,
Daniele

> > The maximum number of allowed packets in a single URB and the maximum
> > size of the URB are dictated by the modem through the qmi control
> > protocol: the values returned by the modem are then configured in the
> > driver with the new ethtool parameters.
> >
> > > Isn't this the same as TX copybreak? TX
> > > copybreak for multiple packets?
> >
> > I tried looking at how tx copybreak works to understand your comment,
> > but I could not find any useful document. Probably my fault, but can
> > you please point me to something I can read?
> >
> > Thanks,
> > Daniele
>
>
>
> --
> This song goes out to all the folk that thought Stadia would work:
> https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-698136666=
5607352320-FXtz
> Dave T=C3=A4ht CEO, TekLibre, LLC
