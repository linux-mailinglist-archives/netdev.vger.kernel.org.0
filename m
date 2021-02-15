Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADDE31B909
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 13:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhBOMUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 07:20:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:37146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhBOMUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 07:20:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA33E64DAF;
        Mon, 15 Feb 2021 12:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613391575;
        bh=j4+qHpzxfQVCPvLlgnEKk88hXfHOqWs3cPLcjDCIWTY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Sb94YUQ1YJ4uhfz1veFgsop4HGoC3Rn5p8G9gSsEVB/GH/Kz46j7HJQwhZiDFGI85
         l/U5ECuLcoW5elOOH8JvvdEg542mGdlBBj45tnRkkedll5G9yzICS4qrV+gHpKXz/G
         TOCOc2Gre9LlY4qXI/Aa0wb7//BhinJSpyIJDycyRtN/RPyQQWdOIM9O3dhlFjcCHr
         6i6uySiOXPC0oGMtEpELymuqUGYWmfwqEQAsZwAICRFWgyff+xxheWQx13coMG5HTQ
         x2Ko/reM1JO67GyTwoVFVHCOH8U/T61C3GP1SfMeLFcsGfYN75kObUmxpWKr4AJHyK
         tNquZFxB82zsQ==
Received: by mail-ot1-f54.google.com with SMTP id d7so5858106otq.6;
        Mon, 15 Feb 2021 04:19:35 -0800 (PST)
X-Gm-Message-State: AOAM531KWhzBwVjpRUMQd/CKVH+wBP6flwiSkG7XESWiYCLsgqmnJBck
        +lAAEgfI6PmBIH0/LLz0BUJ/3ZahR4tYEqn1VZo=
X-Google-Smtp-Source: ABdhPJxuyiL/8nGRH3dyNyB0gtDY++9QyKg4dKnSds6MwewtsSMksWyunCksV3BGpgTO0qxlzOXwpnp+VkidxtKsY/g=
X-Received: by 2002:a9d:6c11:: with SMTP id f17mr11168000otq.210.1613391574856;
 Mon, 15 Feb 2021 04:19:34 -0800 (PST)
MIME-Version: 1.0
References: <20210215050655.2532-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <20210215050655.2532-3-nobuhiro1.iwamatsu@toshiba.co.jp> <YCoPmfunGmu0E8IT@unreal>
 <20210215072809.n3r5rdswookzri6j@toshiba.co.jp> <YCo9WVvtAeozE42k@unreal>
In-Reply-To: <YCo9WVvtAeozE42k@unreal>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 15 Feb 2021 13:19:18 +0100
X-Gmail-Original-Message-ID: <CAK8P3a391547zH=bYXbLzttP9ehFK=OzcM_XkSJs92dA1z4DGQ@mail.gmail.com>
Message-ID: <CAK8P3a391547zH=bYXbLzttP9ehFK=OzcM_XkSJs92dA1z4DGQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] net: stmmac: Add Toshiba Visconti SoCs glue driver
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        DTML <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        punit1.agrawal@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 10:23 AM Leon Romanovsky <leon@kernel.org> wrote:
> On Mon, Feb 15, 2021 at 04:28:09PM +0900, Nobuhiro Iwamatsu wrote:
> >
> > Sorry, I sent the wrong patchset that didn't fix this point out.
> >
> > > I asked it before, but never received an answer.
> >
> > I have received your point out and have sent an email with the content
> > to remove this line. But it may not have arrived yet...
> >
> > > Why did you use "def_bool y" and not "default y"? Isn't it supposed to be
> > > "depends on STMMAC_ETH"? And probably it shouldn't be set as a default as "y".
> > >
> >
> > The reason why "def_bool y" was set is that the wrong fix was left when
> > debugging. Also, I don't think it is necessary to set "default y".
> > This is also incorrect because it says "bool" Toshiba Visconti DWMAC
> > support "". I change it to trustate in the new patch.
> >
> > And this driver is enabled when STMMAC_PLATFORM was Y. And STMMAC_PLATFORM
> > depends on STMMAC_ETH.
> > So I understand that STMMAC_ETH does not need to be dependents. Is this
> > understanding wrong?
>
> This is correct understanding, just need to clean other entries in that
> Kconfig that depends on STMMAC_ETH.

'tristate' with no default sounds right. I see that some platforms have a
default according to the platform, which also makes sense but isn't
required. What I would suggest though is a dependency on the platform,
to make it easier to disable the front-end based on which platforms
are enabled. This would end up as

config DWMAC_VISCONTI
        tristate "Toshiba Visconti DWMAC support"
        depends on ARCH_VISCONTI || COMPILE_TEST
        depends on OF && COMMON_CLK # only add this line if it's
required for compilation
        default ARCH_VISCONTI

      Arnd
