Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE06F2D16F0
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgLGQ4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:56:25 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:62007 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgLGQ4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:56:25 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607360165; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=VJAXM+Oeu7491cqbnrZxYWK6ucFYOKCdR/LCWfgCzyU=; b=oauuoSsEbWAMFnxee69016xF1Cr9QmWEo7JumgMm5VwCCO7OlSDPQQ1k+mpa0n2wLf+LVCvV
 cpzmou6nRxEaSrZ02nQ4tnMy6mu9y2ME9c53MSdvGv45btUr4P0sTg0PC8tHLKNekD6szuo3
 cD/s31pM7xU9x7eptc6mRrGP74Y=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fce5e88f06acf11ab3a40d1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 07 Dec 2020 16:55:36
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4A824C43462; Mon,  7 Dec 2020 16:55:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 36998C433CA;
        Mon,  7 Dec 2020 16:55:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 36998C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Amit Pundir <amit.pundir@linaro.org>,
        Rob Herring <robh@kernel.org>, dt <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Konrad Dybcio <konradybcio@gmail.com>,
        ath10k <ath10k@lists.infradead.org>,
        David S Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH] ath10k: Introduce a devicetree quirk to skip host cap QMI requests
References: <1601058581-19461-1-git-send-email-amit.pundir@linaro.org>
        <20200929190817.GA968845@bogus> <20201029134017.GA807@yoga>
        <CAMi1Hd20UpNhZm6z5t5Kcy8eTABiAj7X_Gm66QnJspZWSio0Ew@mail.gmail.com>
        <20201124175146.GG185852@builder.lan>
Date:   Mon, 07 Dec 2020 18:55:29 +0200
In-Reply-To: <20201124175146.GG185852@builder.lan> (Bjorn Andersson's message
        of "Tue, 24 Nov 2020 11:51:46 -0600")
Message-ID: <87sg8heeta.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Andersson <bjorn.andersson@linaro.org> writes:

> On Tue 03 Nov 01:48 CST 2020, Amit Pundir wrote:
>
>> Hi Rob, Bjorn, Kalle,
>> 
>> On Thu, 29 Oct 2020 at 19:10, Bjorn Andersson
>> <bjorn.andersson@linaro.org> wrote:
>> >
>> > On Tue 29 Sep 14:08 CDT 2020, Rob Herring wrote:
>> >
>> > > On Fri, Sep 25, 2020 at 11:59:41PM +0530, Amit Pundir wrote:
>> > > > There are firmware versions which do not support host capability
>> > > > QMI request. We suspect either the host cap is not implemented or
>> > > > there may be firmware specific issues, but apparently there seem
>> > > > to be a generation of firmware that has this particular behavior.
>> > > >
>> > > > For example, firmware build on Xiaomi Poco F1 (sdm845) phone:
>> > > > "QC_IMAGE_VERSION_STRING=WLAN.HL.2.0.c3-00257-QCAHLSWMTPLZ-1"
>> > > >
>> > > > If we do not skip the host cap QMI request on Poco F1, then we
>> > > > get a QMI_ERR_MALFORMED_MSG_V01 error message in the
>> > > > ath10k_qmi_host_cap_send_sync(). But this error message is not
>> > > > fatal to the firmware nor to the ath10k driver and we can still
>> > > > bring up the WiFi services successfully if we just ignore it.
>> > > >
>> > > > Hence introducing this DeviceTree quirk to skip host capability
>> > > > QMI request for the firmware versions which do not support this
>> > > > feature.
>> > >
>> > > So if you change the WiFi firmware, you may force a DT change too. Those
>> > > are pretty independent things otherwise.
>> > >
>> >
>> > Yes and that's not good. But I looked at somehow derive this from
>> > firmware version numbers etc and it's not working out, so I'm out of
>> > ideas for alternatives.
>> >
>> > > Why can't you just always ignore this error? If you can't deal with this
>> > > entirely in the driver, then it should be part of the WiFi firmware so
>> > > it's always in sync.
>> > >
>> >
>> > Unfortunately the firmware versions I've hit this problem on has gone
>> > belly up when receiving this request, that's why I asked Amit to add a
>> > flag to skip it.
>> 
>> So what is next for this DT quirk?
>> 
>
> Rob, we still have this problem and we've not come up with any way to
> determine in runtime that we need to skip this part of the
> initialization.

This is firmware version specific, right? There's also enum
ath10k_fw_features which is embedded within firmware-N.bin, we could add
a new flag there. But that means that a correct firmware-N.bin is needed
for each firmware version, not sure if that would work out. Just
throwing out ideas here.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
