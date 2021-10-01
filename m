Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472BB41ED84
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 14:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354393AbhJAMdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 08:33:45 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:44755 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354383AbhJAMdo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 08:33:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633091520; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=LxFT6+tXElMzzp7TNF5EckiX/nUtD1va2LinP/kg8SE=; b=vcQQ+95XNdDRfcbVCGt8TnPOiZ0OhGDpHbwr8DjtdktA5+kMvkeMhGjcnDfOxnDqC/jzdas8
 +UYuJsiPbbd5/4jPBZyDyNSQrZDE1zluKw6AoH2z7IKT/GFfjylrtOfZI6Ed+6gcxsU3TN0M
 3qZLJ3P2W4fynX94i9T8v4lQlfE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 6156ffbefc6e34f8cde8390b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 01 Oct 2021 12:31:58
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 88B79C43619; Fri,  1 Oct 2021 12:31:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7484DC43616;
        Fri,  1 Oct 2021 12:31:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 7484DC43616
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
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
        <87pmz6mhim.fsf@codeaurora.org>
        <CAPDyKFrgrSAz-B7wqNNPKk3kB8UqhGs=+bZ8RRhmqh8HuvhcEQ@mail.gmail.com>
Date:   Fri, 01 Oct 2021 15:31:49 +0300
In-Reply-To: <CAPDyKFrgrSAz-B7wqNNPKk3kB8UqhGs=+bZ8RRhmqh8HuvhcEQ@mail.gmail.com>
        (Ulf Hansson's message of "Mon, 12 Apr 2021 10:22:47 +0200")
Message-ID: <87fstlj58q.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ulf,

sorry for the late reply, my Gnus tells me it took me 24 weeks to reply :)

Ulf Hansson <ulf.hansson@linaro.org> writes:

> On Wed, 7 Apr 2021 at 14:00, Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Ulf Hansson <ulf.hansson@linaro.org> writes:
>>
>> >> If I follow what has been done in other drivers I would write something
>> >> like:
>> >>
>> >>   static int wfx_sdio_suspend(struct device *dev)
>> >>   {
>> >>           struct sdio_func *func = dev_to_sdio_func(dev);
>> >>           struct wfx_sdio_priv *bus = sdio_get_drvdata(func);
>> >>
>> >>           config_reg_write_bits(bus->core, CFG_IRQ_ENABLE_DATA, 0);
>> >>           // Necessary to keep device firmware in RAM
>> >>           return sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
>> >
>> > This will tell the mmc/sdio core to keep the SDIO card powered on
>> > during system suspend. Thus, it doesn't need to re-initialize it at
>> > system resume - and the firmware should not need to be re-programmed.
>> >
>> > On the other hand, if you don't plan to support system wakeups, it
>> > would probably be better to power off the card, to avoid wasting
>> > energy while the system is suspended. I assume that means you need to
>> > re-program the firmware as well. Normally, it's these kinds of things
>> > that need to be managed from a ->resume() callback.
>>
>> Many mac80211 drivers do so that the device is powered off during
>> interface down (ifconfig wlan0 down), and as mac80211 does interface
>> down automatically during suspend, suspend then works without extra
>> handlers.
>
> That sounds simple. :-)

Indeed, I was omitting a lot of details :) My comment was more like a
general remark to all different bus techonologies, not just about SDIO.
And I'm not saying that all wireless drivers do that, but some of them
do. Though I don't have any numbers how many.

> Would you mind elaborating on what is actually being powered off at
> interface down - and thus also I am curious what happens at a typical
> interface up?

In general in the drivers that do we this the firmware is completely
turned off and all memory is reset during interface down. And firmware
is started from the scratch during interface up. Also one benefit from
this is that firmware state is reset, the wireless firmwares are
notarious being buggy.

> Even if we don't want to use system wakeups (wake-on-lan), the SDIO
> core and the SDIO func driver still need to somewhat agree on how to
> manage the power for the card during system suspend, I think.
>
> For example, for a non-removable SDIO card, the SDIO/MMC core may
> decide to power off the card in system suspend. Then it needs to
> restore power to the card and re-initialize it at system resume, of
> course. This doesn't mean that the actual corresponding struct device
> for it, gets removed/re-added, thus the SDIO func driver isn't being
> re-probed after the system has resumed. Although, since the SDIO card
> was re-initialized, it's likely that the FW may need to be
> re-programmed after the system has been resumed.
>
> Are you saying that re-programming the FW is always happening at
> interface up, when there are none system suspend/resume callbacks
> assigned for the SDIO func driver?

Yes, that's what I was trying to say. But take all this with grain of
salt, I'm not very familiar with SDIO! And funnily enough, I checked
what we do in ath10k_sdio driver during suspend has conflicting code and
documentation:

/* Empty handlers so that mmc subsystem doesn't remove us entirely during
 * suspend. We instead follow cfg80211 suspend/resume handlers.
 */
static int ath10k_sdio_pm_suspend(struct device *device)
{
	struct sdio_func *func = dev_to_sdio_func(device);
	struct ath10k_sdio *ar_sdio = sdio_get_drvdata(func);
	struct ath10k *ar = ar_sdio->ar;
	mmc_pm_flag_t pm_flag, pm_caps;
	int ret;

	if (!device_may_wakeup(ar->dev))
		return 0;

	ath10k_sdio_set_mbox_sleep(ar, true);

	pm_flag = MMC_PM_KEEP_POWER;

	ret = sdio_set_host_pm_flags(func, pm_flag);
	if (ret) {
		pm_caps = sdio_get_host_pm_caps(func);
		ath10k_warn(ar, "failed to set sdio host pm flags (0x%x, 0x%x): %d\n",
			    pm_flag, pm_caps, ret);
		return ret;
	}

	return ret;
}

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
