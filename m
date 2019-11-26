Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A014510A18B
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 16:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbfKZPxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 10:53:15 -0500
Received: from a27-11.smtp-out.us-west-2.amazonses.com ([54.240.27.11]:44568
        "EHLO a27-11.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727191AbfKZPxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 10:53:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574783594;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=YoDxwdiX+/IIitr2cA1dXXofO95RcDisor5LI9W5Y+I=;
        b=cEWGVoADnqlpmg65ZkFRYgxQ1oWSY6SNIlCzYCwQaHt4ITwuKENDlpea+romVKzg
        ELrLRviKjNmHlLwi505+wgipnANfqmcfmB07MeewGBmba4jIg2a12G+FSPV/HadO60i
        KXq8iBJ+KQ/2GXpmOxx4pEcpfBnYIUVBuQPOHPkY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574783594;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=YoDxwdiX+/IIitr2cA1dXXofO95RcDisor5LI9W5Y+I=;
        b=Hsi/pdz5ePMVRy8dNn0FxMQNzxFIO5zqZChpu+abtXLgg26rOPRjxDQMct2SE5Xe
        Mw8rJfQq2iK/AJ9t83G4v5B4EzyRjYJM778o7ydJxSA7lewhrqolexoDsnok5ob91tq
        cskWkjTkcp3Ps5IPqanOxZxYcQWGnmTF34WUYFwg=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        TVD_SUBJ_WIPE_DEBT,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 365B2C433A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Subject: Re: [PATCH 2/2] net: wireless: ti: wl1251: sdio: remove ti,power-gpio
References: <cover.1574591746.git.hns@goldelico.com>
        <e1f18e0f1401a0d8b07ccb176732a2e3f3a5732a.1574591746.git.hns@goldelico.com>
Date:   Tue, 26 Nov 2019 15:53:14 +0000
In-Reply-To: <e1f18e0f1401a0d8b07ccb176732a2e3f3a5732a.1574591746.git.hns@goldelico.com>
        (H. Nikolaus Schaller's message of "Sun, 24 Nov 2019 11:35:46 +0100")
Message-ID: <0101016ea86aafc7-7f36235e-f486-4e71-bf28-87bffe60a179-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.11.26-54.240.27.11
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"H. Nikolaus Schaller" <hns@goldelico.com> writes:

> Remove handling of this property from code.
> Note that wl->power_gpio is still needed in
> the header file for SPI mode (N900).
>
> Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> ---
>  drivers/net/wireless/ti/wl1251/sdio.c | 30 ---------------------------
>  1 file changed, 30 deletions(-)

Please use "wl1251: " as title prefix, no need to have the full
directory structure there.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
