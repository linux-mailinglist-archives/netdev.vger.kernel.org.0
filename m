Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77799314A0B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 09:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhBIIMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 03:12:03 -0500
Received: from so15.mailgun.net ([198.61.254.15]:39246 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229671AbhBIILr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 03:11:47 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612858281; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=5WGte9xt2dXjRFbMOx/ZKB9MKO7A9fu4SSLGKPnadEw=; b=VOb0S9dgBTd6p5tpYKzPfBtyzF1RScwD2typkqfpfBaDJxeNvGXLTXwGsYkZP4Dqce9MN4gW
 3iVq8xGHYiqRMYnxWi/xbAKDIc5TyrpynsYdKFjiFMt/wmTXgX/KvsNWVSQt/AopZeCYzjzy
 8WiZPbcADKqlqchIvD4nIaE40lA=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 6022438b81f6c45dced25bd6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 09 Feb 2021 08:10:51
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E438CC43462; Tue,  9 Feb 2021 08:10:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B1227C433CA;
        Tue,  9 Feb 2021 08:10:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B1227C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Amit Pundir <amit.pundir@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        Konrad Dybcio <konradybcio@gmail.com>,
        dt <devicetree@vger.kernel.org>,
        David S Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH] ath10k: Introduce a devicetree quirk to skip host cap QMI requests
References: <1601058581-19461-1-git-send-email-amit.pundir@linaro.org>
        <20200929190817.GA968845@bogus> <20201029134017.GA807@yoga>
        <CAMi1Hd20UpNhZm6z5t5Kcy8eTABiAj7X_Gm66QnJspZWSio0Ew@mail.gmail.com>
        <20201124175146.GG185852@builder.lan> <87sg8heeta.fsf@codeaurora.org>
        <CAMi1Hd2FN6QQzbKHooVyqQfH1NFTNLt4RwxyVXRf+5DwTc9ojg@mail.gmail.com>
        <87czxa4grv.fsf@codeaurora.org> <YCF5ZC/WMRefTRcQ@builder.lan>
Date:   Tue, 09 Feb 2021 10:10:44 +0200
In-Reply-To: <YCF5ZC/WMRefTRcQ@builder.lan> (Bjorn Andersson's message of
        "Mon, 8 Feb 2021 11:48:20 -0600")
Message-ID: <87blctveyj.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Andersson <bjorn.andersson@linaro.org> writes:

> On Mon 08 Feb 11:21 CST 2021, Kalle Valo wrote:
>
>> Amit Pundir <amit.pundir@linaro.org> writes:
>> 
>> > Hi Kalle,
>> >
>> > On Mon, 7 Dec 2020 at 22:25, Kalle Valo <kvalo@codeaurora.org> wrote:
>> >>
>> >> This is firmware version specific, right? There's also enum
>> >> ath10k_fw_features which is embedded within firmware-N.bin, we could add
>> >> a new flag there. But that means that a correct firmware-N.bin is needed
>> >> for each firmware version, not sure if that would work out. Just
>> >> throwing out ideas here.
>> >
>> > Apologies for this late reply. I was out for a while.
>> 
>> No worries.
>> 
>> > If by that (the firmware version) you mean "QC_IMAGE_VERSION_STRING",
>> > then that may be a bit tricky. Pocophone F1 use the same firmware
>> > family version (WLAN.HL.2.0.XXX), used by Dragonboard 845c (which has
>> > Wi-Fi working upstream).
>> 
>> I'm meaning the ath10k firmware meta data we have in firmware-N.bin
>> (N=2,3,4...) file. A quick summary:
>> 
>> Every ath10k firmware release should have firmware-N.bin. The file is
>> created with this tool:
>> 
>> https://github.com/qca/qca-swiss-army-knife/blob/master/tools/scripts/ath10k/ath10k-fwencoder
>> 
>> firmware-N.bin contains various metadata, one of those being firmware
>> feature flags:
>> 
>> enum ath10k_fw_features {
>> 	/* wmi_mgmt_rx_hdr contains extra RSSI information */
>> 	ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX = 0,
>> 
>> 	/* Firmware from 10X branch. Deprecated, don't use in new code. */
>> 	ATH10K_FW_FEATURE_WMI_10X = 1,
>> 
>>         [...]
>> 
>> So what you could is add a new flag enum ath10k_fw_features, create a
>> new firmware-N.bin for your device and enable the flag on the firmware
>> releases for your device only.
>> 
>> I don't know if this is usable, but one solution which came to my mind.
>
> It sounds quite reasonable to pass this using firmawre-N.bin instead of
> DT, however that would imply that we need to find firmware-N.bin in the
> device-specific directory, where we keep the wlanmdsp.mbn as well - and
> not under /lib/firmware/ath10k
>
> For other devices (e.g. ADSP, modem or wlanmdsp.mbn) we're putting these
> in e.g. /lib/firmware/qcom/LENOVO/81JL/ and specifies the location using
> a firmware-name property in DT.

Ah, I didn't realise that.

Actually I would like to have ath10k in control[1] of QMI/rproc firmware
loading as the firmware releases have different constraints, like the
issue we are now discussing. Ideally firmware-N.bin would contain all
firmware files, for example wlanmdsp.mbn, and from the meta data
ath10k/ath11k would know what version of the firmware interface should
be used.

I remember we discussed this briefly a year or two ago and there was no
easy solution, but I really wish we could find one. More these kind of
firmware interface incompatibilities will most likely pop up, also in
ath11k, so it would be great to find a clean and easily maneagable
solution.

[1] With control I mean that ath10k/ath11k can choose which firmware
should be loaded

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
