Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CBC421E89
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 08:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhJEGCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 02:02:00 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:16982 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbhJEGB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 02:01:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633413609; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=iMZe94zRRSUpASq/f9N/cvuhpb9OSJlwcSXsTncDWS8=; b=PjlWHvclen+/xL5/59FkZ9/sU88jXWXjtbA0JdLC7NI2Vae9dMlUCJKs+dJhT/I2Phl/LSnU
 TIpVIlbcJbnpag+V9q1JtaHN3HG4GXv60aAiH3OwWeQUxxcY2mytqp3V6lElOvqHqvYZFpyQ
 uIQzW07/7xrbB/kllwTfuibVfZA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 615be9db5f16bce6680cdc8b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 05 Oct 2021 05:59:55
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6E040C4360D; Tue,  5 Oct 2021 05:59:54 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BAB70C4338F;
        Tue,  5 Oct 2021 05:59:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org BAB70C4338F
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
Subject: Re: [PATCH v7 08/24] wfx: add bus_sdio.c
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
        <20210920161136.2398632-9-Jerome.Pouiller@silabs.com>
        <CAPDyKFp2_41mScO=-Ev+kvYD5xjShQdLugU_2FTTmvzgCxmEWA@mail.gmail.com>
        <19731906.ZuIkq4dnIL@pc-42>
        <CAPDyKFpbZypaLVmE2J+rGzAXgdWp1koD8pRxBKo3kFK3NDTFWw@mail.gmail.com>
Date:   Tue, 05 Oct 2021 08:59:47 +0300
In-Reply-To: <CAPDyKFpbZypaLVmE2J+rGzAXgdWp1koD8pRxBKo3kFK3NDTFWw@mail.gmail.com>
        (Ulf Hansson's message of "Fri, 1 Oct 2021 17:37:38 +0200")
Message-ID: <87y278f1v0.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ulf Hansson <ulf.hansson@linaro.org> writes:

>> > > +static const struct sdio_device_id wfx_sdio_ids[] = {
>> > > +       { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF200) },
>> > > +       { },
>> > > +};
>> > > +MODULE_DEVICE_TABLE(sdio, wfx_sdio_ids);
>> > > +
>> > > +struct sdio_driver wfx_sdio_driver = {
>> > > +       .name = "wfx-sdio",
>> > > +       .id_table = wfx_sdio_ids,
>> > > +       .probe = wfx_sdio_probe,
>> > > +       .remove = wfx_sdio_remove,
>> > > +       .drv = {
>> > > +               .owner = THIS_MODULE,
>> > > +               .of_match_table = wfx_sdio_of_match,
>> >
>> > Is there no power management? Or do you intend to add that on top?
>>
>> It seems we already have had this discussion:
>>
>>   https://lore.kernel.org/netdev/CAPDyKFqJf=vUqpQg3suDCadKrFTkQWFTY_qp=+yDK=_Lu9gJGg@mail.gmail.com/#r
>>
>> In this thread, Kalle said:
>> > Many mac80211 drivers do so that the device is powered off during
>> > interface down (ifconfig wlan0 down), and as mac80211 does interface
>> > down automatically during suspend, suspend then works without extra
>> > handlers.
>
> Yeah, it's been a while since I looked at this, thanks for the pointer.

I want to emphasize that what I said above was just a generic comment
about mac80211 drivers and just trying to give some ideas how to solve
this, I did not check how wfx driver behaves in this regard.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
