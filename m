Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE8F421A37
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 00:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbhJDWnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 18:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236524AbhJDWne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 18:43:34 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFA0C061749
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 15:41:44 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id e15so78053958lfr.10
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 15:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BVplZDWCP2Cmo9kXIU0kj43Mzd2m24zYah/Ddctflio=;
        b=WDXi2C1MpnHW3vX/GR9Y79OxWmL+mY9wvILiWsCHXnbiorLx6ESoAUAVV0vxfWXfbI
         n5n0cO1D+LPUOQJbJ1br9JR4ntXhpLrnjL2K4VNjPJgi/d4KzLKswa/fJ5UU/QHMnuby
         m6Pl88ZFeMXkD4PLNFHiPv+t4TovDbNQHh+yEhnYdnG5C5YDiCjnRNnjtm6Cbl7gXozi
         SJsKwTemSuegj850YmM1D50fKaY/5kQF/VF/HtQUL0NI4H5KsIheHDdPf07DbegK6vzj
         EJHS5UHuukol/e8+d4Yr9xnnVXiK+5orkRQe4ODPIOy/wJoHYtgvZemkv3tRWrRgHfrw
         L2Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BVplZDWCP2Cmo9kXIU0kj43Mzd2m24zYah/Ddctflio=;
        b=zFJEpIpph8nfRWyM8YCTpj8R8/PnEpvwqnNd24iOkjZWJ/YSmJvDxUv/kwwqSiLhLc
         QB71fCRdoplu913mSyer257XPgV4GpYlqCqf/qteXhWyuGzaxBh2xU7N1sVV7k7es4vE
         sNpaoH54kiOhfJoJJxeM76PvkUqZ1JEZItaJxZ9P22fI/hsNCftd22slpSmBTdNTV1VS
         hjLNADApMF55Msj/tpOLLwfhh4LrI1oh/82hOaOtgF/C6UT79wJxbW1OWjXPPznN+2wR
         2PdG1qrAR/0dz33PJPc8D3wCC+VpuYhvSLcDD9rxsrCc0qXxUcPDHFZsxo1MMbrZkLEU
         aVsw==
X-Gm-Message-State: AOAM531OJORHXuZiWdh9VfzF0HGGMDGsk23LY42HfkaoxQkYGMJQI1bw
        U73CGjIChQ1M9mwau1PEhyNonHIvTDCbx/ovzfBC7B+J0uM=
X-Google-Smtp-Source: ABdhPJzE7X5+IaKlaGj/GKQrEgjvbMmUMzm4cxK+2cy9JiQZIQqaG7XZ1JqaD5NJBSmatyG2adSM/e7c0JhnazvoYI0=
X-Received: by 2002:a19:c10d:: with SMTP id r13mr17057213lff.339.1633387303289;
 Mon, 04 Oct 2021 15:41:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210929210349.130099-1-linus.walleij@linaro.org>
 <20210929210349.130099-4-linus.walleij@linaro.org> <20210929214504.gvrcx7lpl5apouwc@skbuf>
In-Reply-To: <20210929214504.gvrcx7lpl5apouwc@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 5 Oct 2021 00:41:32 +0200
Message-ID: <CACRpkdaZ7tUwv8OjBaHJ-Da9mBrBy5AuK+p3m4J=hZyyKHTx4w@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4 v4] net: dsa: rtl8366rb: Support fast aging
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 11:45 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Sep 29, 2021 at 11:03:48PM +0200, Linus Walleij wrote:

> > +     /* This will age out any learned L2 entries */
> > +     regmap_update_bits(smi->map, RTL8366RB_SECURITY_CTRL,
> > +                        BIT(port), BIT(port));
>
> Is there any delay that needs to be added between these two operations?
>
> > +     /* Restore the normal state of things */
> > +     regmap_update_bits(smi->map, RTL8366RB_SECURITY_CTRL,
> > +                        BIT(port), 0);

Absolutely no idea. The API from the vendor essentially just set/clear
this bit with no comments on use.

Yours,
Linus Walleij
