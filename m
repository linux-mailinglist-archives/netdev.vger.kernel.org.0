Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED56313AE8
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhBHR2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:28:05 -0500
Received: from so15.mailgun.net ([198.61.254.15]:44314 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234801AbhBHRW1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 12:22:27 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612804928; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=VvrhI2uHyem0TWcE3hoIWIu/Lz0TWdmIj8+lLm4p6+c=; b=Pd9Nlg7liiOxM24L/l5st/LnMbooGF5+SWnNdAv6tpkgtiQSQUR/mVFgfuK4Xlg8dxVmZwGq
 uN4kztGdmyeIfAdsq2csnC2/YPMXXiCvlCjq2MxGzpsa2arewDaGqvaY33KZWiowaohp1CxA
 cMevu3D1mVsasSD9NLU8XzuFxUE=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 6021731be4842e9128addea6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Feb 2021 17:21:31
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 46757C43465; Mon,  8 Feb 2021 17:21:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3C6D8C433CA;
        Mon,  8 Feb 2021 17:21:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3C6D8C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Amit Pundir <amit.pundir@linaro.org>
Cc:     Rob Herring <robh@kernel.org>, dt <devicetree@vger.kernel.org>,
        netdev@vger.kernel.org, Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        linux-wireless@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Konrad Dybcio <konradybcio@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        David S Miller <davem@davemloft.net>
Subject: Re: [PATCH] ath10k: Introduce a devicetree quirk to skip host cap QMI requests
References: <1601058581-19461-1-git-send-email-amit.pundir@linaro.org>
        <20200929190817.GA968845@bogus> <20201029134017.GA807@yoga>
        <CAMi1Hd20UpNhZm6z5t5Kcy8eTABiAj7X_Gm66QnJspZWSio0Ew@mail.gmail.com>
        <20201124175146.GG185852@builder.lan> <87sg8heeta.fsf@codeaurora.org>
        <CAMi1Hd2FN6QQzbKHooVyqQfH1NFTNLt4RwxyVXRf+5DwTc9ojg@mail.gmail.com>
Date:   Mon, 08 Feb 2021 19:21:24 +0200
In-Reply-To: <CAMi1Hd2FN6QQzbKHooVyqQfH1NFTNLt4RwxyVXRf+5DwTc9ojg@mail.gmail.com>
        (Amit Pundir's message of "Tue, 2 Feb 2021 16:41:19 +0530")
Message-ID: <87czxa4grv.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amit Pundir <amit.pundir@linaro.org> writes:

> Hi Kalle,
>
> On Mon, 7 Dec 2020 at 22:25, Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> This is firmware version specific, right? There's also enum
>> ath10k_fw_features which is embedded within firmware-N.bin, we could add
>> a new flag there. But that means that a correct firmware-N.bin is needed
>> for each firmware version, not sure if that would work out. Just
>> throwing out ideas here.
>
> Apologies for this late reply. I was out for a while.

No worries.

> If by that (the firmware version) you mean "QC_IMAGE_VERSION_STRING",
> then that may be a bit tricky. Pocophone F1 use the same firmware
> family version (WLAN.HL.2.0.XXX), used by Dragonboard 845c (which has
> Wi-Fi working upstream).

I'm meaning the ath10k firmware meta data we have in firmware-N.bin
(N=2,3,4...) file. A quick summary:

Every ath10k firmware release should have firmware-N.bin. The file is
created with this tool:

https://github.com/qca/qca-swiss-army-knife/blob/master/tools/scripts/ath10k/ath10k-fwencoder

firmware-N.bin contains various metadata, one of those being firmware
feature flags:

enum ath10k_fw_features {
	/* wmi_mgmt_rx_hdr contains extra RSSI information */
	ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX = 0,

	/* Firmware from 10X branch. Deprecated, don't use in new code. */
	ATH10K_FW_FEATURE_WMI_10X = 1,

        [...]

So what you could is add a new flag enum ath10k_fw_features, create a
new firmware-N.bin for your device and enable the flag on the firmware
releases for your device only.

I don't know if this is usable, but one solution which came to my mind.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
