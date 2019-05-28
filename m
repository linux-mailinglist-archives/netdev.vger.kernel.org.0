Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 196652C64F
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfE1MSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:18:35 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56124 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfE1MSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:18:34 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B45F06087F; Tue, 28 May 2019 12:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559045913;
        bh=P/xJPgEaFpoP31E3fqQphLr7ltwMwL8lDre1PA+osY4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Rkv7vB+aIjsGcyZ1qv5RydDbPoTcnUSowtTa/dLBn9+JzJzw33tAIvMQitbspoB0G
         xwj63pT70FPYhXuKo/df95dlOK3EC63O4G3zXEi9XyCAj2peQgINKKc/jczRorGzjd
         bu84dxsmryLjh8YrwFASAWoB2FKJ+GoNdfrfg38Q=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2B9A6601D4;
        Tue, 28 May 2019 12:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559045912;
        bh=P/xJPgEaFpoP31E3fqQphLr7ltwMwL8lDre1PA+osY4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Dm7mPJKpTsMbO9PbWdABRBzre4eVfMccKtNNceUaRX4rYi7Ri3Cg21sBewXc0xTas
         GMK+s5+0l9hsRUg9GtpSsR9rzKTn8YQK0DEj3rpiue8vMjBW9JIqjVd/WIMKLRo46Q
         5WYrIU2mhucPnTTC2+1oBRhzvxCxCUB8F+4T4ATk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2B9A6601D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] brcmfmac: re-enable command decode in sdio_aos for
 BRCM 4354
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190517225420.176893-2-dianders@chromium.org>
References: <20190517225420.176893-2-dianders@chromium.org>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-rockchip@lists.infradead.org,
        Double Lo <double.lo@cypress.com>, briannorris@chromium.org,
        Madhan Mohan R <madhanmohan.r@cypress.com>, mka@chromium.org,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Douglas Anderson <dianders@chromium.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        Franky Lin <franky.lin@broadcom.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        brcm80211-dev-list@cypress.com, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190528121833.B45F06087F@smtp.codeaurora.org>
Date:   Tue, 28 May 2019 12:18:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Douglas Anderson <dianders@chromium.org> wrote:

> In commit 29f6589140a1 ("brcmfmac: disable command decode in
> sdio_aos") we disabled something called "command decode in sdio_aos"
> for a whole bunch of Broadcom SDIO WiFi parts.
> 
> After that patch landed I find that my kernel log on
> rk3288-veyron-minnie and rk3288-veyron-speedy is filled with:
>   brcmfmac: brcmf_sdio_bus_sleep: error while changing bus sleep state -110
> 
> This seems to happen every time the Broadcom WiFi transitions out of
> sleep mode.  Reverting the part of the commit that affects the WiFi on
> my boards fixes the problem for me, so that's what this patch does.
> 
> Note that, in general, the justification in the original commit seemed
> a little weak.  It looked like someone was testing on a SD card
> controller that would sometimes die if there were CRC errors on the
> bus.  This used to happen back in early days of dw_mmc (the controller
> on my boards), but we fixed it.  Disabling a feature on all boards
> just because one SD card controller is broken seems bad.  ...so
> instead of just this patch possibly the right thing to do is to fully
> revert the original commit.
> 
> Fixes: 29f6589140a1 ("brcmfmac: disable command decode in sdio_aos")
> Signed-off-by: Douglas Anderson <dianders@chromium.org>

I don't see patch 2 in patchwork and I assume discussion continues.
Please resend if/when I need to apply something.

2 patches set to Changes Requested.

10948785 [1/3] brcmfmac: re-enable command decode in sdio_aos for BRCM 4354
10948777 [3/3] brcmfmac: sdio: Disable auto-tuning around commands expected to fail

-- 
https://patchwork.kernel.org/patch/10948785/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

