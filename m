Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7388416844
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 00:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243532AbhIWW7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 18:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243528AbhIWW7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 18:59:45 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE07CC061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 15:58:12 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id i25so32778089lfg.6
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 15:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pr/gwJqX8klbM6aGTx4kkC64u0tgRf43anQjHu/+yF4=;
        b=L2EkZ1bXynul49lCBI1u99dRnCuH+QYmELTcu4v5y3XrppZ+aEMDzh+ras5/VSdjyD
         rNza1lcQ8Lp+RDFq7PpyXAxo2C/rVuX5eMQdAJJIW2vVKvYj9X4PLPPUrkWrshsvE5fp
         7BZcsuGBj240MTqvzRpMVOkBrvqX/wu2BSA9iqFy3XFwXT6ByDQrow9ZWjVGwvK2a2av
         frToC1YQoz4s4DmxInfXFN4DcvTGzOJUdP/z2GnIsEJivUo/qKgRI+6DrjAxZcPfFb/D
         PeoLIhMh/GF2M0T9lvHnZSMgyQ7mhXCKEEWXF4ePqamrAQQ0EgztmcD3rDSdMABggRw6
         WC4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pr/gwJqX8klbM6aGTx4kkC64u0tgRf43anQjHu/+yF4=;
        b=5FLcwhX0k/oUSMqTRgtOIyjUm8Irj7rkS30JmUAstLYZ2YxJbDeuxwo85eH+/sdY8P
         ctyQB9aUNyLP4HMwwEbAfpdNpLBM5E2xK37CLAA9WZYQwxi+iHK7kl/xW5gJNvAgxMuO
         5n3nIuzaMQFpyG75aY9Bh0Hfy9/EcFfLmd43mkbYAyspQmCU6Z47mEAlAddsL37atoEd
         CO715JPgvJSJVAWeBJRnIMvBHAhobuhR/ZHr2gaMD2ZPdKXMKotgovNUy4uQPYBrb0/t
         4ShFxPNrpzEppbc4NriLccygzAUKxgZCxhtSFDOsQmZvNwTD7SWZfEODuP2G0ANArfYv
         wfhg==
X-Gm-Message-State: AOAM5324+9xFxuQSoyNDsQ8yAq0DyjN2a/iGvOG5y4xucNUuyYKrGTXb
        j9XtVkKEEAH7R02S5wsCv+5G2IEEkeaT/mrbRxuNSw==
X-Google-Smtp-Source: ABdhPJzlPyV97zK4RLzVVRDg0bm7TDTSxUU84Hq7The8e9U/zhnTjN4eKvZKQ3wr5anYdVnl+k2HEsG5ysxVWocVEQI=
X-Received: by 2002:a05:651c:4d2:: with SMTP id e18mr7940837lji.432.1632437891350;
 Thu, 23 Sep 2021 15:58:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210913143156.1264570-1-linus.walleij@linaro.org>
 <20210915071901.1315-1-dqfext@gmail.com> <CACRpkdYu7Q5Y88YmBzcBBGycmW92dd0jVhJNUpDFyd65bBq52A@mail.gmail.com>
 <20210923221200.xygcmxujwqtxajqd@skbuf> <CACRpkdZJzHqmdfvR5kRgw1mWPQ68=-ky1xJ+VWX8v6hD_6bx6A@mail.gmail.com>
 <20210923222549.byri6ch2kcvowtv4@skbuf>
In-Reply-To: <20210923222549.byri6ch2kcvowtv4@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 24 Sep 2021 00:58:00 +0200
Message-ID: <CACRpkdYGy+tKUGudFLKL_U6DYpdJLnDxz1gh2gH=drOw9YdB6w@mail.gmail.com>
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

On Fri, Sep 24, 2021 at 12:25 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> On Fri, Sep 24, 2021 at 12:21:39AM +0200, Linus Walleij wrote:

> > > > Do we have some use for that feature in DSA taggers?
> > >
> > > Yes.
> >
> > OK I'll add it to my TODO, right now trying to fix up the base
> > of the RTL8366RB patch set to handle VLANs the right way.
>
> But you didn't ask what that use is...

Allright spill the beans :D I might not be the most clever at times...

Yours,
Linus Walleij
