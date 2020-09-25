Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0659279402
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 00:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgIYWQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 18:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727355AbgIYWQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 18:16:11 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E54C0613CE;
        Fri, 25 Sep 2020 15:16:11 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id q13so659730ejo.9;
        Fri, 25 Sep 2020 15:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pgdQ9MvcwqAc91trF3Zcub7T+CXx77/gN0+10x+Lv1g=;
        b=OclhwWH51SZRc87euLQ6jlV9LxW/ZQfRi5bXqRHHgsv3WKSphDbRJNlLRjLaFGiEW/
         u9uEulZeNvHULzZlXkYpcE9QXHtwSVOpyUb5tZ1nl5voIrEyt+W8CXwQrlGbcQwnPvXT
         3tyE6D9Ty1Gk2yuF0FBK8vYdBVa1CySV7jJxtNhXqK927Ji+aXaV4pd0+NcANy8HFbSf
         m/T2QiOb0LyGJvZQUAU2ATIqfLJ/9O6mf60wy9GXENWC4MfxF6aEBi9OKhIebGcUEODu
         jRw0xbWaxPN3OJ8jeNl/FQF0gtS3ZaXvT5HkM4cNht8mGacBV78PZlpjV2FtevuihrW7
         ziwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pgdQ9MvcwqAc91trF3Zcub7T+CXx77/gN0+10x+Lv1g=;
        b=jMDhEGXpRDAZc737iRK3FP5OG8LoRp5+sOIwbgLjaWQs+CCfsPUWQ3J0JqR1LYi0oD
         OpaU947qIRi6+ijCkM5r/xeOmihFAMWfYqcHPPVP7ndezND3t+wTpoejcHg4AAaoDARA
         WWaO78YN940ywJV4d7DgtrCg3hze07+0cjs8QXzFSxCZWm4Gm6L7RWJ+CjFGX75cJhwE
         OW8Wk+0idWx00xHDTiNFdHYlWh7Sm/UtqQAa3rCbVzuMSA9I1PqpDRjqa5/xcCLXGr85
         /FUjE6P5kGWtr7ToZlK5sKUOeZGYEnJDvsItBQamhOW7Lyo0AJyrLhvZQIwM13cIYsO/
         lU4g==
X-Gm-Message-State: AOAM531ffmfTjmd/DsdXI+H2I6qR32yCKZt21FX/y2RTbqbAGg+qjlt6
        N2TM34U+735Y+YFeFI3x8cBM4/Pka6X4BBwJU5I=
X-Google-Smtp-Source: ABdhPJxfbM6sS5VvCDOs7sEJMA5DV14kUcWgfZpu8TXOgfmW+9jqAnP2vCfhYDZzkdV3ZNtmNtCg4qWGd+UeyfvXsRQ=
X-Received: by 2002:a17:906:3791:: with SMTP id n17mr4816900ejc.216.1601072170080;
 Fri, 25 Sep 2020 15:16:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAFBinCATt4Hi9rigj52nMf3oygyFbnopZcsakGL=KyWnsjY3JA@mail.gmail.com>
 <20200925220329.wdnrqeauto55vdao@skbuf>
In-Reply-To: <20200925220329.wdnrqeauto55vdao@skbuf>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 26 Sep 2020 00:15:59 +0200
Message-ID: <CAFBinCB4woR1sZfT3tvCkHiR2eRgQfXg3jsD+KO0iMzyQRAGDQ@mail.gmail.com>
Subject: Re: RGMII timing calibration (on 12nm Amlogic SoCs) - integration
 into dwmac-meson8b
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Sat, Sep 26, 2020 at 12:03 AM Vladimir Oltean <olteanv@gmail.com> wrote:
[...]
> > Any recommendations/suggestions/ideas/hints are welcome!
> > Thank you and best regards,
> > Martin
> >
> >
> > [0] https://github.com/khadas/u-boot/blob/4752efbb90b7d048a81760c67f8c826f14baf41c/drivers/net/designware.c#L707
> > [1] https://github.com/khadas/linux/blob/khadas-vims-4.9.y/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c#L466
>
> Florian attempted something like this before, for the PHY side of things:
> https://patchwork.ozlabs.org/project/netdev/patch/20191015224953.24199-3-f.fainelli@gmail.com/
thank you for this hint!

> There are quite some assumptions to be made if the code is to be made
> generic, such as the fact that the controller should not drop frames
> with bad FCS in hardware. Or if it does, the code should be aware of
> that and check that counter.
I do not need the auto-detection of the phy-mode nor any RX/TX delay
(these are fixed values)
however, from that patch-set I would need most of
phy_rgmii_probe_interface() (and all of the helpers it's using)
also I'm wondering if the "protocol" 0x0808 is recommended over ETH_P_EDSA


Best regards,
Martin
