Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E2D38BAE
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 15:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfFGNca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 09:32:30 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34699 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728430AbfFGNc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 09:32:29 -0400
Received: by mail-ed1-f65.google.com with SMTP id c26so3085982edt.1
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 06:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:date:message-id:in-reply-to:references:user-agent
         :subject:mime-version:content-transfer-encoding;
        bh=JFFl0hGcf6iXTgGWhmFXyXBsFiYNsrS1BSNNsA7L3uk=;
        b=J8BWELCflWlt9mhbRHhPeEUuozGyv2cRoexw/Djro8OZPtu/YgdzZaM7bjR9wlVEtQ
         EF9RPfC+QQFEqGrzKbEw2AWVO2K76+ctKE9dd8oPwClR6/PSrywuUPUSEQ+S1NKSPJS0
         0Q18WLRMHQRoigeE4Deob/gwfSx6wi3dBGts4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:subject:mime-version
         :content-transfer-encoding;
        bh=JFFl0hGcf6iXTgGWhmFXyXBsFiYNsrS1BSNNsA7L3uk=;
        b=GT2vxmUgTswg2oJ1vSzkQrg2xHUMVriV2Q5wp/Cmp/Ku9z8e4uisNNydnm3GAKxGhQ
         kaddxTjHvOoXzwSfHAkOHNoXclpPRJcD7yYWw92Qjb2HCkGyP/St0svFkPLXUJb8hKwx
         7OTHZjJTRP3Zd1KX9OR03kW6e6h9zQH1qvE2MB1KiuRckGGhz96gGRE5X45M2Jfy3hpw
         Ufs7jF4gH4kOBjaLJyptmSNwGQuBzNnVaFmdJfK3Qav91SAXVaNjjYEnAXUZ/tq534x4
         eEkMbEZebldaKKPcD/sdDapHOrY+LO860P+tSy4WKNmjKMWWmoVMXtgc+UZFXD1aIMYG
         /CTA==
X-Gm-Message-State: APjAAAV/vrotC+Rh7UEhkpEmVLKkr1IUC07nrgnoXy+VNQDq0a+H4Nda
        260dz+DU0Sv7c3AmwbL3QkQ3HA==
X-Google-Smtp-Source: APXvYqzb/6yVC5RrnRvUzD09ZH/2vf9pPWOsfx1+agyAhSxgyz9uMxv9L0pZhmieVY2c6iivXH+tbQ==
X-Received: by 2002:a50:cdd0:: with SMTP id h16mr56291052edj.249.1559914346683;
        Fri, 07 Jun 2019 06:32:26 -0700 (PDT)
Received: from [192.168.178.17] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id y2sm554410edc.26.2019.06.07.06.32.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 07 Jun 2019 06:32:25 -0700 (PDT)
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Doug Anderson <dianders@chromium.org>
CC:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Double Lo <double.lo@cypress.com>,
        Brian Norris <briannorris@chromium.org>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Wright Feng <wright.feng@cypress.com>,
        "Chi-Hsien Lin" <chi-hsien.lin@cypress.com>,
        netdev <netdev@vger.kernel.org>,
        "brcm80211-dev-list" <brcm80211-dev-list@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Franky Lin <franky.lin@broadcom.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Michael Trimarchi <michael@amarulasolutions.com>
Date:   Fri, 07 Jun 2019 15:32:20 +0200
Message-ID: <16b3223dea0.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <ff0e7b7a-6a58-8bec-b182-944a8b64236d@intel.com>
References: <20190603183740.239031-1-dianders@chromium.org>
 <20190603183740.239031-4-dianders@chromium.org>
 <42fc30b1-adab-7fa8-104c-cbb7855f2032@intel.com>
 <CAD=FV=UPfCOr-syAbVZ-FjHQy7bgQf5BS5pdV-Bwd3hquRqEGg@mail.gmail.com>
 <16b305a7110.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <ff0e7b7a-6a58-8bec-b182-944a8b64236d@intel.com>
User-Agent: AquaMail/1.20.0-1451 (build: 102000001)
Subject: Re: [PATCH v2 3/3] brcmfmac: sdio: Disable auto-tuning around commands expected to fail
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On June 7, 2019 2:40:04 PM Adrian Hunter <adrian.hunter@intel.com> wrote:

> On 7/06/19 8:12 AM, Arend Van Spriel wrote:
>> On June 6, 2019 11:37:22 PM Doug Anderson <dianders@chromium.org> wrote:
>>>
>>> In the case of dw_mmc, which I'm most familiar with, we don't have any
>>> sort of automated or timed-based retuning.  ...so we'll only re-tune
>>> when we see the CRC error.  If I'm understanding things correctly then
>>> that for dw_mmc my solution and yours behave the same.  That means the
>>> difference is how we deal with other retuning requests, either ones
>>> that come about because of an interrupt that the host controller
>>> provided or because of a timer.  Did I get that right?
>> 
>> Right.
>> 
>>> ...and I guess the reason we have to deal specially with these cases
>>> is because any time that SDIO card is "sleeping" we don't want to
>>> retune because it won't work.  Right?  NOTE: the solution that would
>>> come to my mind first to solve this would be to hold the retuning for
>>> the whole time that the card was sleeping and then release it once the
>>> card was awake again.  ...but I guess we don't truly need to do that
>>> because tuning only happens as a side effect of sending a command to
>>> the card and the only command we send to the card is the "wake up"
>>> command.  That's why your solution to hold tuning while sending the
>>> "wake up" command works, right?
>> 
>> Yup.
>> 
>>> ---
>>>
>>> OK, so assuming all the above is correct, I feel like we're actually
>>> solving two problems and in fact I believe we actually need both our
>>> approaches to solve everything correctly.  With just your patch in
>>> place there's a problem because we will clobber any external retuning
>>> requests that happened while we were waking up the card.  AKA, imagine
>>> this:
>>>
>>> A) brcmf_sdio_kso_control(on=True) gets called; need_retune starts as 0
>>>
>>> B) We call sdio_retune_hold_now()
>>>
>>> C) A retuning timer goes off or the SD Host controller tells us to retune
>>>
>>> D) We get to the end of brcmf_sdio_kso_control() and clear the "retune
>>> needed" since need_retune was 0 at the start.
>>>
>>> ...so we dropped the retuning request from C), right?
>>>
>>>
>>> What we truly need is:
>>>
>>> 1. CRC errors shouldn't trigger a retuning request when we're in
>>> brcmf_sdio_kso_control()
>>>
>>> 2. A separate patch that holds any retuning requests while the SDIO
>>> card is off.  This patch _shouldn't_ do any clearing of retuning
>>> requests, just defer them.
>>>
>>>
>>> Does that make sense to you?  If so, I can try to code it up...
>> 
>> FWIW it does make sense to me. However, I am still not sure if our sdio
>> hardware supports retuning. Have to track down an asic designer who can tell
>> or dive into vhdl myself.
>
> The card supports re-tuning if is handles CMD19, which it does.  It is not
> the card that does any tuning, only the host.  The card just helps by
> providing a known data pattern in response to CMD19.  It can be that a card
> provides good enough signals that the host should not need to re-tune.  I
> don't know if that can be affected by the board design though.

Right. I know it supports initial tuning, but I'm not sure about subsequent 
retuning initiated by the host controller.

Regards,
Arend


