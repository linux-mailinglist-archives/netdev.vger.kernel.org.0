Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B98C66B3E1
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 21:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbjAOUfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 15:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjAOUfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 15:35:11 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFFE12F2C;
        Sun, 15 Jan 2023 12:35:09 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id y8so18444944qvn.11;
        Sun, 15 Jan 2023 12:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YsO2LsRKgK20s4o7iDJGIbwEqRob1KRtlORzs1GZn9Y=;
        b=cJ7CkpaYEy1CX51VQAht4bwOyTMWHAFV5pbq17NYUDnUDmOVPeDZe46oE/uXPxln1A
         FETGmutcmVcUYqeVQOgDtKdWRxhqr2jBMyQgFaiFqQbFcXKSU21jTaT3zobeW3bq6uPz
         G+7lweSH7jetI64CxbUSivNMTVXEm4tW43Ceh7ANFldQR+XMksWc4lSm8TMI1T2vXbSN
         tyi/BTGtFneyfa0JQQUW3DA3JLzzgw0Kszu+g+/XnS1r2Bu4zw3xx0vHVbFD/3Twgt5V
         3iHYjQyQDEmF70snRx4+TvBzJx7pvg94lhalY8YoSLe7fUUoBqnCp94pwfkFc6jdIg4D
         94cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YsO2LsRKgK20s4o7iDJGIbwEqRob1KRtlORzs1GZn9Y=;
        b=00jITPn2CH7R/+6AhzPTXSZmfoxvV8+DTzIQFhBaPm3iiSCdLQTYqPU1aHwvJwgXL9
         NsS3GOUdn0/WtCtF5BEiK7htPHiRskgY8ftwxGuZVZHmkCwYYnfeMfETPFuAh56FcrH1
         irtwm9cRI6sIak54LQp2LeKR+2ZjKEPf1gvO+r7BDCfqhIUtOVRtLhA/pzPt5IhPsp04
         dLcFyWdFriiZKih+eKeu6QfR3+9jGrvQpNnRgz42/O8p/r0Igjh81p/GVGtIgAx0K0rb
         TqWfInm3SqKXflVsShowM0XYpTbwbeMjlyfZvJN6v5LGWOEO3QzKr5GZEC9BF5qWvhWc
         wR7w==
X-Gm-Message-State: AFqh2kp6rgYZ11PQGsB+JrhI8eL/ri4KQNVoJov1ZcFc4zvUPsyYYduJ
        rDcrk/n6dY0ho/omyPgYqGWsmpkaEONq+GoPTZU=
X-Google-Smtp-Source: AMrXdXuAuOQMpz/K5yvYyTHZJ6TqRNFT1Z5mX5LUcj+XjLD7BkXLVkcXEUFa3hCYIzHUUIiqHlL/5xSayYht2VhgWaE=
X-Received: by 2002:a05:6214:184f:b0:534:1fe5:6060 with SMTP id
 d15-20020a056214184f00b005341fe56060mr1117452qvy.71.1673814908543; Sun, 15
 Jan 2023 12:35:08 -0800 (PST)
MIME-Version: 1.0
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch> <CAJ=UCjX0YzVgedO1hDu_NsFAGhxe8HouUmHmbO6AXZqT=OUYLg@mail.gmail.com>
 <Y8RNzIuiNdAi0dnV@lunn.ch>
In-Reply-To: <Y8RNzIuiNdAi0dnV@lunn.ch>
From:   Pierluigi Passaro <pierluigi.passaro@gmail.com>
Date:   Sun, 15 Jan 2023 21:34:57 +0100
Message-ID: <CAJ=UCjXr=GBieTvUE7O2LqEg4Q_UpmOEAxUVwy2wuitfHT+2ow@mail.gmail.com>
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.p@variscite.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 15, 2023 at 8:02 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > This behaviour is generally not visible, but easily reproducible with all NXP
> > platforms with dual fec (iMX28, iMX6UL, iMX7, iMX8QM, iMX8QXP)
> > where the MDIO bus is owned by the 1st interface but shared with the 2nd.
> > When the 1st interface is probed, this causes the probe of the MDIO bus
> > when the 2nd interface is not yet set up.
>
> This sounds like a different issue.
>
> We need to split the problem up into two.
>
> 1) Does probing the MDIO bus find both PHYs?
>
> 2) Do the MACs get linked to the PHYs.
>
> If the reset is asserted at the point the MDIO bus is probed, you
> probably don't find the PHY because it does not respond to register
> reads. Your patch probably ensures it is out of reset so it is
> enumerated.
>
You are perfectly right: this patch fixes only the 1st problem.
For the 2nd problem, I've already sent a dedicated patch:
https://lore.kernel.org/all/20230115174910.18353-1-pierluigi.p@variscite.com/
>
> For fec1, if the PHY is found during probe, connecting to the PHY will
> work without issues. However, fec2 can potentially have ordering
> issues. Has the MDIO bus finished being probed by the time fec2 looks
> for it? If it is not there you want to return -EPROBE_DEFERED so that
> the driver code will try again later.
>
> There have been patches to do with ordering recently, but they have
> been more to do with suspend/resume. So please make sure you are
> testing net-next, if ordering is your real problem. You also appear to
> be missing a lot of stable patches, so please bring you kernel up to
> date on the 5.15 branch, you are way out of date.
>
>      Andrew
