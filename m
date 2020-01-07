Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08C0313205A
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 08:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgAGHYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 02:24:02 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52530 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgAGHYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 02:24:01 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so17756302wmc.2
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 23:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=hS02mr1KQqtn1L2M7x0gAEGGeyTPnAaCI8Fi6777qXo=;
        b=D8vO8J+/UrejXMFUPsaq0tPZKX0tESDcJxgdJ2cb+CbxRcCzmGheBCePqfbpr6SnYe
         Q+BuCue2Mv2ov46zAJYD9jma1KeFdKTFwZhySxi8srMr13pgOZ9ia8SBjeg+wERlJQYL
         ezciRb1LIYhvCENNd+dPcqutvpk1xglYs5trMvLMoqDm4fJCGrWktZDnKzSapy0aPAtU
         HzADB2JHivrYH6JiAsDuXvTRTo9cqU1FntFWapIyplE25jvbsuPiYglgV5H1VtKNud6B
         8gYIG990t/m+Krbhp1rH+5hJF8Kv5UaxUZXL7FBsad/a97UjJNR2b5zfM2tnGzAYIF1B
         h2DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hS02mr1KQqtn1L2M7x0gAEGGeyTPnAaCI8Fi6777qXo=;
        b=CXWMPZI78ntYLyljEny2DTNQmS2LJCl4of4xPamO3Ia/NwleIVdmr1gsN+mtOl5Z8Y
         Nt5uUWItcUcPfx0UJ2huCC/XM5v4FociqbsZEuk2ifCdnRP+2qYeR/E3ZXvZJGTG2lRc
         gq5qnO99+bQSDqZW0Wz8bTCQm8R2MMi0d1conxe4cMkOdKFO62+NEK4mjLaBmZ1pyIKx
         PmL/p/EXz8z5zT0qjpm7qDscyavGTR0+JpPmmC6xRKX4NFsj4FWDAsDKJGw3m2AY7DfC
         0JrcgE7lQnNuv946/vHELRI4YmB5SwYRff06Wv32M4sZ3gF+pAtb7SOCgGBBBfPp0Yyi
         3VSA==
X-Gm-Message-State: APjAAAUZGu/z88vVpUna5JDAhFlDK/+zMP50nmrC/NMMlsYvGXyrKY6G
        Xmq+aZAg3VGtTMLl0d9SxzsDDQ==
X-Google-Smtp-Source: APXvYqzEngBqpWpVaXaQWBumdzr7GXAcqIEKqq2Y9SOJoJLMyJ8aakL563yhaKn+90EQlOQu375csg==
X-Received: by 2002:a05:600c:2c06:: with SMTP id q6mr36778338wmg.154.1578381839342;
        Mon, 06 Jan 2020 23:23:59 -0800 (PST)
Received: from myrica (adsl-84-227-176-239.adslplus.ch. [84.227.176.239])
        by smtp.gmail.com with ESMTPSA id q3sm25675275wmc.47.2020.01.06.23.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 23:23:58 -0800 (PST)
Date:   Tue, 7 Jan 2020 08:23:54 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Dmitry Osipenko <digetx@gmail.com>
Cc:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        hdegoede@redhat.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, kvalo@codeaurora.org, davem@davemloft.net
Subject: Re: [PATCH] brcmfmac: sdio: Fix OOB interrupt initialization on
 brcm43362
Message-ID: <20200107072354.GA832497@myrica>
References: <20191226092033.12600-1-jean-philippe@linaro.org>
 <16f419a7070.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <141f055a-cd1d-66cb-7052-007cda629d3a@gmail.com>
 <20200106191919.GA826263@myrica>
 <c2bb1067-9b9c-3be1-b87e-e733a668a056@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c2bb1067-9b9c-3be1-b87e-e733a668a056@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 02:15:18AM +0300, Dmitry Osipenko wrote:
> 06.01.2020 22:19, Jean-Philippe Brucker пишет:
> > Hi Dmitry,
> > 
> > On Thu, Dec 26, 2019 at 05:37:58PM +0300, Dmitry Osipenko wrote:
> >> I haven't seen any driver probe failures due to OOB on NVIDIA Tegra,
> >> only suspend-resume was problematic due to the unbalanced OOB
> >> interrupt-wake enabling.
> >>
> >> But maybe checking whether OOB interrupt-wake works by invoking
> >> enable_irq_wake() during brcmf_sdiod_intr_register() causes trouble for
> >> the cubietruck board.
> >>
> >> @Jean-Philippe, could you please try this change (on top of recent
> >> linux-next):
> > 
> > Sorry for the delay, linux-next doesn't boot for me at the moment and I
> > have little time to investigate why, so I might retry closer to the merge
> > window.
> > 
> > However, isn't the interrupt-wake issue independent from the problem
> > (introduced in v4.17) that my patch fixes? I applied "brcmfmac: Keep OOB
> > wake-interrupt disabled when it shouldn't be enabled" on v5.5-rc5 and it
> > doesn't seem to cause a regression, but the wifi only works if I apply my
> > patch as well.
> > 
> > Thanks,
> > Jean
> > 
> >>
> >> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> >> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> >> index b684a5b6d904..80d7106b10a9 100644
> >> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> >> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> >> @@ -115,13 +115,6 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev
> >> *sdiodev)
> >>                 }
> >>                 sdiodev->oob_irq_requested = true;
> >>
> >> -               ret = enable_irq_wake(pdata->oob_irq_nr);
> >> -               if (ret != 0) {
> >> -                       brcmf_err("enable_irq_wake failed %d\n", ret);
> >> -                       return ret;
> >> -               }
> >> -               disable_irq_wake(pdata->oob_irq_nr);
> >> -
> >>                 sdio_claim_host(sdiodev->func1);
> >>
> >>                 if (sdiodev->bus_if->chip == BRCM_CC_43362_CHIP_ID) {
> 
> Hello Jean,
> 
> Could you please clarify whether you applied [1] and then the above
> snippet on top of it or you only applied [1] without the snippet?

I applied [1] without the snippet

Thanks,
Jean

> 
> [1] brcmfmac: Keep OOB wake-interrupt disabled when it shouldn't be enabled
