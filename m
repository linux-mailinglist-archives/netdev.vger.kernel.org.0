Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E2E356BAD
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 14:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351966AbhDGMA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 08:00:58 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:21857 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351956AbhDGMAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 08:00:53 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617796844; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=dRkaKojvnawlYO3e1C9wxx79COw07pLsiCqaSEnReIk=; b=veu3quoti3INewFeTEH+d2XlX7KPy9fWyZsM8s0BRWXU4DS2itR9RnhVKCkynWAoJ5FuONMU
 5b6mp7zPV1HHgk4lJtZXePwZ4HH84/RCFjM/YugbhdbJH1AAMqe2OnQSO7xEQ5xe29sY/ceq
 ndJD7wBsJKLnnBv7/NuYbzk34JA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 606d9ed78166b7eff70a4f4e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 07 Apr 2021 12:00:23
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0381BC43464; Wed,  7 Apr 2021 12:00:22 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 53876C433CA;
        Wed,  7 Apr 2021 12:00:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 53876C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Subject: Re: [PATCH v5 08/24] wfx: add bus_sdio.c
References: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
        <4503971.bAhddQ8uqO@pc-42>
        <CAPDyKFoXgV3m-rMKfjqRj91PNjOGaWg6odWG-EGdFKkL+dGWoA@mail.gmail.com>
        <5713463.b6Cmjs1FeV@pc-42>
        <CAPDyKFrONrUvbVVVF9iy4P17jZ_Fq+1pGMmsqM6C1hOXOWQnBw@mail.gmail.com>
Date:   Wed, 07 Apr 2021 15:00:17 +0300
In-Reply-To: <CAPDyKFrONrUvbVVVF9iy4P17jZ_Fq+1pGMmsqM6C1hOXOWQnBw@mail.gmail.com>
        (Ulf Hansson's message of "Tue, 23 Mar 2021 20:12:06 +0100")
Message-ID: <87pmz6mhim.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ulf Hansson <ulf.hansson@linaro.org> writes:

>> If I follow what has been done in other drivers I would write something
>> like:
>>
>>   static int wfx_sdio_suspend(struct device *dev)
>>   {
>>           struct sdio_func *func = dev_to_sdio_func(dev);
>>           struct wfx_sdio_priv *bus = sdio_get_drvdata(func);
>>
>>           config_reg_write_bits(bus->core, CFG_IRQ_ENABLE_DATA, 0);
>>           // Necessary to keep device firmware in RAM
>>           return sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
>
> This will tell the mmc/sdio core to keep the SDIO card powered on
> during system suspend. Thus, it doesn't need to re-initialize it at
> system resume - and the firmware should not need to be re-programmed.
>
> On the other hand, if you don't plan to support system wakeups, it
> would probably be better to power off the card, to avoid wasting
> energy while the system is suspended. I assume that means you need to
> re-program the firmware as well. Normally, it's these kinds of things
> that need to be managed from a ->resume() callback.

Many mac80211 drivers do so that the device is powered off during
interface down (ifconfig wlan0 down), and as mac80211 does interface
down automatically during suspend, suspend then works without extra
handlers.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
