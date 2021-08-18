Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44803EF848
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 04:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbhHRC5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 22:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbhHRC5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 22:57:53 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495C9C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 19:57:19 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id a126so2372330ybg.6
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 19:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E8J1M8TLojn9lNRFCWALG+xqr0khqK2ghlCL+ZC08FY=;
        b=MabUach2AGIkoGUn1LDVwxrSHsqBJSDF/BKO0y7/EcAkJ9sCwtzJbIwJdTHbx3GN7p
         8kIG/jVLcxrsWOXJlwXRmuCn3I41YUAjzBndeTLst7n+SKYrv4KmTosi8OVRgFVQIKSr
         aPUPFoqw50AH0kDfWlxiAz9mfQkvmL2uRr1qNsIo38a09+dLbqQCofKYqG9LFEKFMOWr
         94+dJ8H/ujR1vnip5z38VTVdVIuMI63l9Gscml9Oth2gr+tMnx8K9Au7x7YrgKVcEU34
         +sdTQkTDLimsebm9Z6BzIdNx8sE51k+1JCpGC1a3Rwv4NYybgOSyqpSjpunh5KUgz8bz
         +rpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E8J1M8TLojn9lNRFCWALG+xqr0khqK2ghlCL+ZC08FY=;
        b=cvDPFhyaMvbctebA1Xh0Pciz2uMCRKW+Y/Qif8K3FSczbLZfzoBJCi5raG7VziJGrP
         2TPZVpuIWsaRkg7Fo8efCg+mE2C4wwF3q9YuAn9cQjOtBQg2KGFgGNefKNVNE0jDbcdU
         OIE/KoxIK09RHV5ORmKYOhEDjCnnCkqAO4WaGs/N1Hbp6HbZ/wW/iHbfGaQhR3B1Wloz
         fXvFAOvu2TZa7yW8egFOj7aYLi5itO+OCiCEEKaBRRIO5f8pspVM4IfD7DiC3PpFHdNu
         B3e042dR+IqJQmtrQQo0HQsXbceDlsG9cE+9xqrz3Mls1wZduNijaEVMP6RXYFZ6Da8z
         0vgw==
X-Gm-Message-State: AOAM5334XM8xJLVXZo7Vnqnu5AycXAswEewLg15kG3kxFaoB0T5Hnttg
        iQZUD0eowpiL8Dv66stJKmMjXv8JpQygn3O/u5KN5Q==
X-Google-Smtp-Source: ABdhPJxI6FTcE3c47Wn0i+htLO57WaK/N9r5UacnETGWbX71+m63BkfRB2kVMW33iIPN/Rimw1sywjsUf/wkZujNgKk=
X-Received: by 2002:a25:81ce:: with SMTP id n14mr8943857ybm.32.1629255438297;
 Tue, 17 Aug 2021 19:57:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210817180841.3210484-1-saravanak@google.com>
 <20210817180841.3210484-2-saravanak@google.com> <YRwlyH0cjazjsSwe@lunn.ch>
In-Reply-To: <YRwlyH0cjazjsSwe@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 17 Aug 2021 19:56:42 -0700
Message-ID: <CAGETcx-B=oxqGP-iz4qf2YrLVw3_Q-oTc_3m+dgP1P17FmLs=g@mail.gmail.com>
Subject: Re: [PATCH net v2 1/3] net: mdio-mux: Delete unnecessary devm_kfree
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>, kernel-team@android.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 2:10 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Aug 17, 2021 at 11:08:39AM -0700, Saravana Kannan wrote:
> > The whole point of devm_* APIs is that you don't have to undo them if you
> > are returning an error that's going to get propagated out of a probe()
> > function. So delete unnecessary devm_kfree() call in the error return path.
> >
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > Acked-by: Marc Zyngier <maz@kernel.org>
> > Tested-by: Marc Zyngier <maz@kernel.org>
> > Acked-by: Kevin Hilman <khilman@baylibre.com>
> > Tested-by: Kevin Hilman <khilman@baylibre.com>
>
> Please add a Fixes: tag, since you want this in stable.
>
> All three patches need fixes tags, possibly different for each patch?

I generally ask for patches to be picked up by stable only if it fixes
a bug that puts the kernel in a bad state or if it fixes an issue
someone actually reported on the stable kernel. In this case, it's
just failing device probes in some cases and I didn't think that met
the bar for stable. But if you think they should, then that's fine by
me.

I'll send out v3 patches with Fixes. I'm fairly sure these issues were
present since the time mdio-mux was added. Hopefully v3 will be the
last version I have to send out :)

-Saravana
