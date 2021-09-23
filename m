Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2197D4167E8
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 00:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243426AbhIWWXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 18:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235578AbhIWWXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 18:23:25 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAE6C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 15:21:52 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id b15so31258607lfe.7
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 15:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EWRTMhaeIAEcBZ5uWS/6zoY54jx6AYC2Z7eIbpFRiLo=;
        b=qFGHbt9m11pgPASiazkF0Icw0DsQGvonxK3XDZDLvWhOmMEWA87Hg6SE0cgam2CpaA
         lni27mXcX2QO/hYIhtl8lv0Dh+haAwOeI0SDogYQzmVP5l9y2C2dV01O41R6pTjWnSyW
         wRAursdtRETIPYcnIQ4Mq6RZEa72PyhxsJmAfQf74P4tvqQJdl3VhKybeiGhL21ilOZu
         A0/JE3eM2g3bctgEREmeBGLF4n3oECWtgsUywm9bJpYZIi+efXSc9Q/8cHvHn30eu4ba
         YIaY5jMjbIH+0Zj6zQUk4tJvAN9kJzc3vp76d2ECFq7CuirslmKy2NEGm1YzD6yO0Nt5
         333g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EWRTMhaeIAEcBZ5uWS/6zoY54jx6AYC2Z7eIbpFRiLo=;
        b=YFg6g/lCTTOCssebvWJkDejsoVk8SlQAhdzyV9vOCzMXnUvro13eNSXStkX45XdSQM
         Gt7WrG3FPqtUz3S2/3BFsx4MND1kTkm0YTtS4dhzo+oHCLSfcI+2cCQ4vtc+C4HuOSl4
         SxUHdk6++6WCAkxC4JKeGz6Wo9+TshnUqJ7yVgxGfvmuU4W922j3WbWhv8Ce+rLfQLGl
         Qw46STrdy2Z/Za4aGEst7muub+B9Exju4jhAsTT8yrugGUevtC2p671XWpvDYfeoTXJq
         dBKIdys/U/RvYXXmxrs+8cMJSlmxy27WY7D+MeB49HUv3sdXMPfDEgVVkqk0+tsjIH0P
         zcng==
X-Gm-Message-State: AOAM531ZeLoVRo633SWxES9yD+fTaUUQQ6VHHAgr/2h4TWd2RQ8nnGyT
        rcSaPtlc7LsEFxFqJqn24gE1vll6XCU8GXySjaHklg==
X-Google-Smtp-Source: ABdhPJyh3Ag3rN49itvKL1p6ocgSG8q5w/9P+xkOA4y7PYIKSX8iRz0aMujpS6fXEmsWnBZoP24/Yb2zmKfo660YRT8=
X-Received: by 2002:a05:6512:3c92:: with SMTP id h18mr6311381lfv.656.1632435711130;
 Thu, 23 Sep 2021 15:21:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210913143156.1264570-1-linus.walleij@linaro.org>
 <20210915071901.1315-1-dqfext@gmail.com> <CACRpkdYu7Q5Y88YmBzcBBGycmW92dd0jVhJNUpDFyd65bBq52A@mail.gmail.com>
 <20210923221200.xygcmxujwqtxajqd@skbuf>
In-Reply-To: <20210923221200.xygcmxujwqtxajqd@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 24 Sep 2021 00:21:39 +0200
Message-ID: <CACRpkdZJzHqmdfvR5kRgw1mWPQ68=-ky1xJ+VWX8v6hD_6bx6A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: tag_rtl4_a: Drop bit 9 from egress frames
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 12:12 AM Vladimir Oltean <olteanv@gmail.com> wrote:

> > Hm I suspect it disable learning on RTL8366RB as well.
>
> Suspicion based on what?

I have a not yet finished patch that dumps the FDB :)

The contents change around a bit under the patch
sets I have floating, but can certainly be determined
when I have time to test things properly.

> > Do we have some use for that feature in DSA taggers?
>
> Yes.

OK I'll add it to my TODO, right now trying to fix up the base
of the RTL8366RB patch set to handle VLANs the right way.

Yours,
Linus Walleij
