Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5E33FA9D9
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 09:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbhH2HMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 03:12:20 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:26068 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234786AbhH2HMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 03:12:17 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630221084; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=GC6e2n/NXwo6S5mQY/R3X6Vs5DlKo2BD30jx+kOMJDw=;
 b=OVSdds/YJtYUJAIoQ++iDpzOvKKYc2Ka69iZUjmBCkSKatVutMmy9A80BPIFA0Pi3weOE20O
 WVbUDDmFiVZYmUN+tTRP+H9OPV9q4PsEKYwMQn41/LQXcY3P1k+K3CvG5Jj8CZ+FdAJ/dCk5
 LA2YrW5cd/Z/3ua8R9m43uoA4P4=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 612b331c825e13c54ab7de58 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 29 Aug 2021 07:11:24
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 45FA9C4360C; Sun, 29 Aug 2021 07:11:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 48DDDC43617;
        Sun, 29 Aug 2021 07:11:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 48DDDC43617
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH] wcn36xx: Allow firmware name to be overridden by
 DT
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210824171225.686683-1-bjorn.andersson@linaro.org>
References: <20210824171225.686683-1-bjorn.andersson@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephan Gerhold <stephan@gerhold.net>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        =?utf-8?b?QW7DrWJhbCBMaW0=?= =?utf-8?b?w7Nu?= 
        <anibal.limon@linaro.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210829071123.45FA9C4360C@smtp.codeaurora.org>
Date:   Sun, 29 Aug 2021 07:11:23 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Andersson <bjorn.andersson@linaro.org> wrote:

> The WLAN NV firmware blob differs between platforms, and possibly
> devices, so add support in the wcn36xx driver for reading the path of
> this file from DT in order to allow these files to live in a generic
> file system (or linux-firmware).
> 
> For some reason the parent (wcnss_ctrl) also needs to upload this blob,
> so rather than specifying the same information in both nodes wcn36xx
> reads the string from the parent's of_node.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
> Tested-by: Aníbal Limón <anibal.limon@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

b7f96d5c79cd wcn36xx: Allow firmware name to be overridden by DT

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210824171225.686683-1-bjorn.andersson@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

