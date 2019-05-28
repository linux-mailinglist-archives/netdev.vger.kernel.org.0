Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 000652CAD3
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 17:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfE1P7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 11:59:20 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:46417 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfE1P7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 11:59:19 -0400
Received: by mail-vk1-f193.google.com with SMTP id g194so4809188vke.13
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 08:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wS8hoqDHHdUU+aVRiUjUMRbeoVex4X+b9To5bYeyjZ8=;
        b=JQnCETd2IGwTVEqh1W9deTB9fYhcQJX6SMUGhSDGjkZYZLhB0pKmx6lNWyqBBg4T3k
         YnYqFvYU1x9cmheUMM9BwRitTXwwaV9CqogdqQxH/UUbtvQx/7yZoICE1RcfqiQFYjjc
         SM3QyVkgaOPA7sDG30y2oiu2Ruha/g0sxwzKs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wS8hoqDHHdUU+aVRiUjUMRbeoVex4X+b9To5bYeyjZ8=;
        b=T7qyxi8DTnzGSKlDXfygakb48Q1Un7L64cAxzkXCScZrAWvTtJubYXB8e88m0vIb0a
         vezVGE8a8KPdJgLRWJJoJaLLNFBFjbC4CQGpwNEgOHY7peLxEVlQy6In138DfaCBu7AT
         l9Q9eCBTi+deFTbJVzauJ1eQTF6npfYpLk6TEJwLg0CdfNO9hfmIaNOzUoQA3KXsCaKY
         vT0KaIzh43iIRoZgEyFLSJua7zM/zOUqcqRovq8joqz2bdmHXfOzepPgU61M9UdOqSO4
         T2bPlm32M1Bm2uakxe3A5ZYPhNpIB+jfnTDgxQOAHXjqtvXZKMlo3BXCeNVMvcxrPKIW
         a3pw==
X-Gm-Message-State: APjAAAUoeljseV8HiNdiH/RSBBK/PfCgZppAHlIaBMrXakqS36T+gs6W
        jW8ScyClS4cdI7k4gM0c1DXAKiAducQ=
X-Google-Smtp-Source: APXvYqy4idiO4yboM6IKmUE6UVH7hfaE/jMysA5eGXmIvZxNTWGy8/2eVVMejgBmwpuXc3OW46Qe3A==
X-Received: by 2002:a1f:1102:: with SMTP id 2mr26189854vkr.90.1559059158290;
        Tue, 28 May 2019 08:59:18 -0700 (PDT)
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com. [209.85.217.49])
        by smtp.gmail.com with ESMTPSA id j8sm16331742vsd.0.2019.05.28.08.59.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 08:59:18 -0700 (PDT)
Received: by mail-vs1-f49.google.com with SMTP id k187so454610vsk.12
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 08:59:18 -0700 (PDT)
X-Received: by 2002:a67:ebd6:: with SMTP id y22mr57926194vso.87.1559058725303;
 Tue, 28 May 2019 08:52:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190517225420.176893-2-dianders@chromium.org> <20190528121833.7D3A460A00@smtp.codeaurora.org>
In-Reply-To: <20190528121833.7D3A460A00@smtp.codeaurora.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 28 May 2019 08:51:53 -0700
X-Gmail-Original-Message-ID: <CAD=FV=VtxdEeFQsdF=U7-_7R+TXfVmA2_JMB_-WYidGHTLDgLw@mail.gmail.com>
Message-ID: <CAD=FV=VtxdEeFQsdF=U7-_7R+TXfVmA2_JMB_-WYidGHTLDgLw@mail.gmail.com>
Subject: Re: [PATCH 1/3] brcmfmac: re-enable command decode in sdio_aos for
 BRCM 4354
To:     Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        Matthias Kaehlcke <mka@chromium.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list@cypress.com, Double Lo <double.lo@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, May 28, 2019 at 5:18 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Douglas Anderson <dianders@chromium.org> wrote:
>
> > In commit 29f6589140a1 ("brcmfmac: disable command decode in
> > sdio_aos") we disabled something called "command decode in sdio_aos"
> > for a whole bunch of Broadcom SDIO WiFi parts.
> >
> > After that patch landed I find that my kernel log on
> > rk3288-veyron-minnie and rk3288-veyron-speedy is filled with:
> >   brcmfmac: brcmf_sdio_bus_sleep: error while changing bus sleep state -110
> >
> > This seems to happen every time the Broadcom WiFi transitions out of
> > sleep mode.  Reverting the part of the commit that affects the WiFi on
> > my boards fixes the problem for me, so that's what this patch does.
> >
> > Note that, in general, the justification in the original commit seemed
> > a little weak.  It looked like someone was testing on a SD card
> > controller that would sometimes die if there were CRC errors on the
> > bus.  This used to happen back in early days of dw_mmc (the controller
> > on my boards), but we fixed it.  Disabling a feature on all boards
> > just because one SD card controller is broken seems bad.  ...so
> > instead of just this patch possibly the right thing to do is to fully
> > revert the original commit.
> >
> > Fixes: 29f6589140a1 ("brcmfmac: disable command decode in sdio_aos")
> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
>
> I don't see patch 2 in patchwork and I assume discussion continues.

Apologies.  I made sure to CC you individually on all the patches but
didn't think about the fact that you use patchwork to manage and so
didn't ensure all patches made it to all lists (by default each patch
gets recipients individually from get_maintainer).  I'll make sure to
fix for patch set #2.  If you want to see all the patches, you can at
least find them on lore.kernel.org linked from the cover:

https://lore.kernel.org/patchwork/cover/1075373/


> Please resend if/when I need to apply something.
>
> 2 patches set to Changes Requested.
>
> 10948785 [1/3] brcmfmac: re-enable command decode in sdio_aos for BRCM 4354

As per Arend I'll change patch #1 to a full revert instead of a
partial revert.  Arend: please yell if you want otherwise.

-Doug
