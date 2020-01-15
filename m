Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEF213BBDB
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 10:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgAOJEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 04:04:31 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:47218 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729066AbgAOJEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 04:04:31 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579079070; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=SEmOCijvsdwGF7pEkrg8FPnYkaWi/mjXIm3JEWQ3QPA=; b=s//VdPe036U0D5R/GboAtHSmjvnKmgi85K3lL8AKpFV2mwIgROj9H8buZOLHZ6H22m+sinDZ
 01ov9iBcqtxGxfrPgTWZZF48wG6fbO/MOtan2rq6yGB625u9rPS9XL7w1aRqdfFgTuxn5w6S
 NHxJzh2RXvSCICrsr3ZAPm1xOdY=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e1ed59e.7f1f0790f6f8-smtp-out-n01;
 Wed, 15 Jan 2020 09:04:30 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EBAE0C447A2; Wed, 15 Jan 2020 09:04:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E1EFEC43383;
        Wed, 15 Jan 2020 09:04:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E1EFEC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>, ath10k@lists.infradead.org,
        linux-arm-msm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/2] ath10k: Enable QDSS clock on sm8150
References: <20191223054855.3020665-1-bjorn.andersson@linaro.org>
        <87zhevsrwk.fsf@codeaurora.org>
Date:   Wed, 15 Jan 2020 11:04:22 +0200
In-Reply-To: <87zhevsrwk.fsf@codeaurora.org> (Kalle Valo's message of "Fri, 10
        Jan 2020 09:16:11 +0200")
Message-ID: <87r201xf8p.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Bjorn Andersson <bjorn.andersson@linaro.org> writes:
>
>> On SM8150 the WiFi firmware depends on the QDSS clock ticking, or the system
>> will reset due to an NoC error. So this adds an optional clock to the ath10k
>> binding and makes sure it's enabled while the WiFi firmware needs it.
>>
>> Bjorn Andersson (2):
>>   ath10k: Add optional qdss clk
>>   arm64: dts: qcom: sm8150: Specify qdss clock for wifi
>>
>>  .../devicetree/bindings/net/wireless/qcom,ath10k.txt          | 2 +-
>>  arch/arm64/boot/dts/qcom/sm8150.dtsi                          | 4 ++--
>>  drivers/net/wireless/ath/ath10k/snoc.c                        | 2 +-
>>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> Via which tree are these supposed to go? I'll take patch 1 and arm
> mantainers take patch 2, or what?

No reply, so I'm planning to take patch 1. Please holler if I
misunderstood.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
