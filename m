Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7181D35BC09
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 10:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237311AbhDLIXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 04:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237298AbhDLIXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 04:23:45 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86247C06138E
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 01:23:24 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id h20so6234227vsu.1
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 01:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U3KvNK5Z0Y0b8uUls56fLMW/SjSCKNnm377bqkslXR8=;
        b=XV1PbJ+lqigLdhRMkPoUSk3eluxQLHpAeYhojQKjAFRLh73UBVZravfBUk/6TYQ6JZ
         Z1ga5Bk6TFjE8hY8ks7CpxDTwodN2YqGYM+WIUBjWz4NtIukPNPtuVV/sm8X/hnqXzlQ
         FLOLj9c9r7tul6Lx5HRsd57MhXsVAmFOaRXBXej2siKsZXi7n5kmY2HWP7yJb9VzjPiM
         EHV0KxKDvRELffiMpqo/+qlpoJnAkRo9mf1WC89QhOyjEM6wCQMjnXsnpvUNtlZCnmdt
         gmkl2sQoD6/XWE3LT8o+fJtdCAaomGlMqX+vOqUpGqoeKV5aK1YZyD2AcJYq0Nvrzey8
         klkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U3KvNK5Z0Y0b8uUls56fLMW/SjSCKNnm377bqkslXR8=;
        b=JTTyA+2fZ0gPNPjSRXLfqSN6wnku+nW9I/rS9aTzdJb6cxgypVs0LNND0kJW9mRyFx
         dp4LkF4HPWNKWUtcUbhmBR9dNE2h7HZDMIU9kaDkf36NvGyVy01c5IryCi4rir5IftXF
         hZO4jBbbROcNDQtRU/cnURVue3pIlrrXy0RfJNHLH2pkzTrPRVTsPQjn4KO1a5/pjizO
         4ZY4iys7L1mCiTvVSyuieXHLDgdGjGmDlhTb+ZRNuGgV0R/DAFMBdsSwGNC+ixYlW8G/
         Vz64kThBh2eYqzsi6rO1PXnBYfDHt8+0VdYh2Yi/v4mvKBVyVSu+kVKcVlLnR38s1Bj5
         u/OQ==
X-Gm-Message-State: AOAM530ZjsZ0FF29ekwRZwf3npFDbAXJ8ihl2x0U6aXUxdYfUeVqTJfN
        RuEwoDS7Hn9a/T2WXgKPYtQpL1xzSDSPePNIXsT29culYGU=
X-Google-Smtp-Source: ABdhPJyrFlHZnGVUhfAiIaP7BcJxpBhp1fb8R1xQW2iTt60VxLne7puTBy7KBNawo5+T+YMuV2eaUOPVM9+WUyAOS18=
X-Received: by 2002:a67:fd48:: with SMTP id g8mr11986932vsr.55.1618215803602;
 Mon, 12 Apr 2021 01:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
 <4503971.bAhddQ8uqO@pc-42> <CAPDyKFoXgV3m-rMKfjqRj91PNjOGaWg6odWG-EGdFKkL+dGWoA@mail.gmail.com>
 <5713463.b6Cmjs1FeV@pc-42> <CAPDyKFrONrUvbVVVF9iy4P17jZ_Fq+1pGMmsqM6C1hOXOWQnBw@mail.gmail.com>
 <87pmz6mhim.fsf@codeaurora.org>
In-Reply-To: <87pmz6mhim.fsf@codeaurora.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 12 Apr 2021 10:22:47 +0200
Message-ID: <CAPDyKFrgrSAz-B7wqNNPKk3kB8UqhGs=+bZ8RRhmqh8HuvhcEQ@mail.gmail.com>
Subject: Re: [PATCH v5 08/24] wfx: add bus_sdio.c
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Apr 2021 at 14:00, Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Ulf Hansson <ulf.hansson@linaro.org> writes:
>
> >> If I follow what has been done in other drivers I would write something
> >> like:
> >>
> >>   static int wfx_sdio_suspend(struct device *dev)
> >>   {
> >>           struct sdio_func *func = dev_to_sdio_func(dev);
> >>           struct wfx_sdio_priv *bus = sdio_get_drvdata(func);
> >>
> >>           config_reg_write_bits(bus->core, CFG_IRQ_ENABLE_DATA, 0);
> >>           // Necessary to keep device firmware in RAM
> >>           return sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
> >
> > This will tell the mmc/sdio core to keep the SDIO card powered on
> > during system suspend. Thus, it doesn't need to re-initialize it at
> > system resume - and the firmware should not need to be re-programmed.
> >
> > On the other hand, if you don't plan to support system wakeups, it
> > would probably be better to power off the card, to avoid wasting
> > energy while the system is suspended. I assume that means you need to
> > re-program the firmware as well. Normally, it's these kinds of things
> > that need to be managed from a ->resume() callback.
>
> Many mac80211 drivers do so that the device is powered off during
> interface down (ifconfig wlan0 down), and as mac80211 does interface
> down automatically during suspend, suspend then works without extra
> handlers.

That sounds simple. :-)

Would you mind elaborating on what is actually being powered off at
interface down - and thus also I am curious what happens at a typical
interface up?

Even if we don't want to use system wakeups (wake-on-lan), the SDIO
core and the SDIO func driver still need to somewhat agree on how to
manage the power for the card during system suspend, I think.

For example, for a non-removable SDIO card, the SDIO/MMC core may
decide to power off the card in system suspend. Then it needs to
restore power to the card and re-initialize it at system resume, of
course. This doesn't mean that the actual corresponding struct device
for it, gets removed/re-added, thus the SDIO func driver isn't being
re-probed after the system has resumed. Although, since the SDIO card
was re-initialized, it's likely that the FW may need to be
re-programmed after the system has been resumed.

Are you saying that re-programming the FW is always happening at
interface up, when there are none system suspend/resume callbacks
assigned for the SDIO func driver?

Kind regards
Uffe
