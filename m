Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E76B2E1BB1
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 12:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgLWLJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 06:09:32 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:43295 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728413AbgLWLJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 06:09:28 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608721742; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=sS6gB7NQorNHJ1fvmwVd8pHeIbjE7GGfwVzQmbtlg/E=; b=lJTOiRv6OzT57aT0JpC8BzAO2Smt2q94uBL7lHhIN1wdisn42YcD6UL2LbFfaE1GaYwtQRwR
 IdsGsEt0cXlwHINRXGiI3zcyXYAwAfRUCnDBx6kgdVuNd5N3ZqA9P7XNCscIs4MObjGMEeoq
 6YVRBXfUMRW8PcQ7bgQwqJLqxvI=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-west-2.postgun.com with SMTP id
 5fe325331d5c1fa42751c66d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 23 Dec 2020 11:08:35
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 47494C433C6; Wed, 23 Dec 2020 11:08:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0BDF2C433ED;
        Wed, 23 Dec 2020 11:08:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0BDF2C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     Youghandhar Chintala <youghand@codeaurora.org>,
        netdev <netdev@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        Douglas Anderson <dianders@chromium.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/3] ath10k: Set wiphy flag to trigger sta disconnect on hardware restart
References: <20201215172435.5388-1-youghand@codeaurora.org>
        <CACTWRwsM_RJnssBpxDpRSbex4_1T9QDv3+ZT7eLnYsgOgtGFQw@mail.gmail.com>
Date:   Wed, 23 Dec 2020 13:08:29 +0200
In-Reply-To: <CACTWRwsM_RJnssBpxDpRSbex4_1T9QDv3+ZT7eLnYsgOgtGFQw@mail.gmail.com>
        (Abhishek Kumar's message of "Tue, 22 Dec 2020 14:36:58 -0800")
Message-ID: <878s9o6aqa.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abhishek Kumar <kuabhs@chromium.org> writes:

> On Tue, Dec 15, 2020 at 9:24 AM Youghandhar Chintala
> <youghand@codeaurora.org> wrote:
>>
>> From: Rakesh Pillai <pillair@codeaurora.org>
>>
>> Currently after the hardware restart triggered from the driver,
>> the station interface connection remains intact, since a disconnect
>> trigger is not sent to userspace. This can lead to a problem in
>> hardwares where the wifi mac sequence is added by the firmware.
>>
>> After the firmware restart, during subsytem recovery, the firmware
>> restarts its wifi mac sequence number. Hence AP to which our device
>> is connected will receive frames with a  wifi mac sequence number jump
>> to the past, thereby resulting in the AP dropping all these frames,
>> until the frame arrives with a wifi mac sequence number which AP was
>> expecting.
>>
>> To avoid such frame drops, its better to trigger a station disconnect
>> upon the  hardware restart. Indicate this support via a WIPHY flag
>> to mac80211, if the hardware params flag mentions the support to
>> add wifi mac sequence numbers for TX frames in the firmware.
>>
>> All the other hardwares, except WCN3990, are not affected by this
>> change, since the hardware params flag is not set for any hardware
>> except for WCN3990
>>
>> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1
>> Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00110-QCARMSWP-1
>> Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00048
>>
>> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
>> Signed-off-by: Youghandhar Chintala <youghand@codeaurora.org>
>> ---
>>  drivers/net/wireless/ath/ath10k/core.c | 15 +++++++++++++++
>>  drivers/net/wireless/ath/ath10k/hw.h   |  3 +++
>>  drivers/net/wireless/ath/ath10k/mac.c  |  3 +++
>>  3 files changed, 21 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
>> index 796107b..4155f94 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.c
>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>> @@ -90,6 +90,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>>                 .hw_filter_reset_required = true,
>>                 .fw_diag_ce_download = false,
>>                 .tx_stats_over_pktlog = true,
>> +               .tx_mac_seq_by_fw = false,
>
> Probably orthogonal to this patch, there is a static array maintained
> for different hardware configs and the structure members like
> "tx_mac_seq_by_fw" are initialized. This does not seem to be scalable
> and probably these parameters can be auto populated based on FW
> capabilities and so we don't have to maintain the static array.
> Thoughts?

I'm not sure what you mean. But if you are saying that we should move
ath10k_hw_params_list entirely to firmware then that is a huge task as
we would need to make changes in every firmware branch, and there are so
many different branches that I have lost count. And due to backwards
compatibility we still need to have ath10k_hw_params_list in ath10k for
few years.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
