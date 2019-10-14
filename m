Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB4BD5DBB
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 10:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbfJNInU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 04:43:20 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38982 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730281AbfJNInU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 04:43:20 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3FB846063F; Mon, 14 Oct 2019 08:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571042599;
        bh=b+v/Z3xKQCNgI8FA2qhwpItPU/4+EoZa5vdBKXJu7Fc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=DIOh1YqZL42SO4XPqRufgwtC9kT/TNHxpdzF/SGiTotnFhjp4CtyaiU2zSON5wZsc
         P1Pi3CwZ3DmAe/xUxdWJ/gwPFOkwMTjitWic0pMN/h+/8k20LP9FyVukmUrOUvk6v6
         LLd7u3h4r5W7DgOsNnzRz8HaaiRj4MDzOoC34HB0=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EEC2E605FE;
        Mon, 14 Oct 2019 08:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571042598;
        bh=b+v/Z3xKQCNgI8FA2qhwpItPU/4+EoZa5vdBKXJu7Fc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=QF0UpIBB3/JJsFHOi/EQclyKEcz2xc996vNvl8g0AF/kONPZd0/3Ww37oiG/V3BWw
         4V6YCPR5Vwc5tZekm0fk1nHb89itprdowO7kmf7hbfOXuhTjlTvarIjHWpfoxt3Oxa
         9x+dXl1ViK44AOPbAuFsChC9Ue5FOya6leZMMtO8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EEC2E605FE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: Correct error handling of dma_map_single()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191011182817.194565-1-bjorn.andersson@linaro.org>
References: <20191011182817.194565-1-bjorn.andersson@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Niklas Cassel <niklas.cassel@linaro.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191014084319.3FB846063F@smtp.codeaurora.org>
Date:   Mon, 14 Oct 2019 08:43:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Andersson <bjorn.andersson@linaro.org> wrote:

> The return value of dma_map_single() should be checked for errors using
> dma_mapping_error() and the skb has been dequeued so it needs to be
> freed.
> 
> This was found when enabling CONFIG_DMA_API_DEBUG and it warned about the
> missing dma_mapping_error() call.
> 
> Fixes: 1807da49733e ("ath10k: wmi: add management tx by reference support over wmi")
> Reported-by: Niklas Cassel <niklas.cassel@linaro.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

d43810b2c180 ath10k: Correct error handling of dma_map_single()

-- 
https://patchwork.kernel.org/patch/11186173/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

