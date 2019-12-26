Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B372A12AB61
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 10:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfLZJrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 04:47:25 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37927 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZJrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 04:47:24 -0500
Received: by mail-wm1-f67.google.com with SMTP id u2so5696507wmc.3
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 01:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:date:message-id:in-reply-to:references:user-agent
         :subject:mime-version:content-transfer-encoding;
        bh=fes1e17DjoybcHkZ3ppriXwbGN3pvc12W7QvoiRRzVg=;
        b=T49Hwalmr/bx7Mup/eAfMwH7e+v3fLjLMmlU1pyvn8yuLfBoCvz4ja2Vynu23NVorU
         L4vnwr+FmuwKarExYkms1yh4mRUBT1M09SVJgtiDCxOuuVC/h8a/T/ESNa09oo03e4vi
         1oJaGadD1zadC7UsOTyTkznFyj+Vu7bsTrUK4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:subject:mime-version
         :content-transfer-encoding;
        bh=fes1e17DjoybcHkZ3ppriXwbGN3pvc12W7QvoiRRzVg=;
        b=isAZAtGHLMvKpSA+hv3y5h6wGOI3AajRejqfNhGhEN4hEFPzUn9AQQljOQ/agLX/r0
         LqMMm6zW2xZEYk9kKEm6SDZ7i5W8CKVFrmFDt384ytJnOuTVWYRvIgK/h986WA0zXxDr
         uNPdUuNb7iYrhy38T5VRIExpXoJBtgIUYSSxnI8SI4KwrLaD9Z6C3FseICOP61MdHMYT
         WMTebavtWdIY8UrCLKjz0Rzk8mfqqIBGrzxxFKsRfNZ7x9EZgiQ5s9pjvuTgHZncqT/R
         mu5kVq7dy1x2uPZdnz+f5Tq0Ci0yBCllT3ACJt/hS9VkMfwcILlvyv8dvEFnZssGfB6P
         Xrgw==
X-Gm-Message-State: APjAAAVjeoqUVd5fvczEoak0/s0Br6kxC0PptPo62d0KVBB3LSAd2n5V
        0+ZH6TkFHZy2lfuswg04DXwyQA==
X-Google-Smtp-Source: APXvYqyc7OhIVZzeNAMoAEb/5fAFhzjgh+m1mZdckHnOmlU+mWH/dr+prELI2ptTmuJrzKZR8soZbg==
X-Received: by 2002:a7b:c957:: with SMTP id i23mr13388410wml.49.1577353642157;
        Thu, 26 Dec 2019 01:47:22 -0800 (PST)
Received: from [192.168.178.38] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id a14sm32456308wrx.81.2019.12.26.01.47.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Dec 2019 01:47:21 -0800 (PST)
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <hdegoede@redhat.com>
CC:     <franky.lin@broadcom.com>, <hante.meuleman@broadcom.com>,
        <chi-hsien.lin@cypress.com>, <wright.feng@cypress.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>, <digetx@gmail.com>,
        <hdegoede@redhat.com>
Date:   Thu, 26 Dec 2019 10:47:18 +0100
Message-ID: <16f419a7070.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <20191226092033.12600-1-jean-philippe@linaro.org>
References: <20191226092033.12600-1-jean-philippe@linaro.org>
User-Agent: AquaMail/1.22.0-1511 (build: 102200004)
Subject: Re: [PATCH] brcmfmac: sdio: Fix OOB interrupt initialization on brcm43362
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On December 26, 2019 10:23:41 AM Jean-Philippe Brucker 
<jean-philippe@linaro.org> wrote:

> Commit 262f2b53f679 ("brcmfmac: call brcmf_attach() just before calling
> brcmf_bus_started()") changed the initialization order of the brcmfmac
> SDIO driver. Unfortunately since brcmf_sdiod_intr_register() is now
> called before the sdiodev->bus_if initialization, it reads the wrong
> chip ID and fails to initialize the GPIO on brcm43362. Thus the chip
> cannot send interrupts and fails to probe:
>
> [   12.517023] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> [   12.531214] ieee80211 phy0: brcmf_bus_started: failed: -110
> [   12.536976] ieee80211 phy0: brcmf_attach: dongle is not responding: err=-110
> [   12.566467] brcmfmac: brcmf_sdio_firmware_callback: brcmf_attach failed
>
> Initialize the bus interface earlier to ensure that
> brcmf_sdiod_intr_register() properly sets up the OOB interrupt.
>
> BugLink: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=908438
> Fixes: 262f2b53f679 ("brcmfmac: call brcmf_attach() just before calling 
> brcmf_bus_started()")

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
> A workaround [1] disabling the OOB interrupt is being discussed. It
> works for me, but this patch fixes the wifi problem on my cubietruck.

I missed that one. Too bad it was not sent to linux-wireless as well. Good 
find here. I did see another patch dealing with the OOB interrupt on Nvidia 
Tegra. Now I wonder if this is the same issue.

Regards,
Arend

> [1] 
> https://lore.kernel.org/linux-arm-kernel/20180930150927.12076-1-hdegoede@redhat.com/
> ---
> .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c  | 12 ++++++------
> 1 file changed, 6 insertions(+), 6 deletions(-)



