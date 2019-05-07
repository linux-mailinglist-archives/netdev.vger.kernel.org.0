Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78FC716502
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 15:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbfEGNvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 09:51:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56120 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfEGNvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 09:51:36 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AFDCC60E3E; Tue,  7 May 2019 13:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557237095;
        bh=VRC3o28GRsYmFCcZSYL/tdVa0+t/wmCKtg6bTuKqrqM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YPjyy3liXUottUe4VeWZWzMLmQtgG9H3gVWo1pd8WoRGiORJOjkW5Y17R0oCP6O8i
         8P9SmzvATCQx+ybN+iGFghtff+t/05+/hmDcd+lgIK4yyxNY2hLo4bqvXU2ccrBDb1
         df5a1XxYmHD7OddKUg7n+fbRl8hCjSgcZzvYOwZA=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5352560350;
        Tue,  7 May 2019 13:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557237094;
        bh=VRC3o28GRsYmFCcZSYL/tdVa0+t/wmCKtg6bTuKqrqM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=KjR+7FM1BokmxLrADzBIQsJPC2mLWq1u9iRPvlGHpVnBpuwFxCu2gPJBfVc7XzP9R
         x5VBR9UZV2/i/938akRtnlg7zOdSYtEZi7xFJ8mv11rGGtXNc8xeEPge5F4PNtZw34
         vSUXze4oRVrOH5vSVgLdJ/NvRkEJcC6ekFe4zPsE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5352560350
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath10k: Use struct_size() helper
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190403172029.GA302@embeddedor>
References: <20190403172029.GA302@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190507135135.AFDCC60E3E@smtp.codeaurora.org>
Date:   Tue,  7 May 2019 13:51:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes, in particular in the
> context in which this code is being used.
> 
> So, change the following form:
> 
> sizeof(*rx) + (sizeof(struct htt_rx_indication_mpdu_range) * num_mpdu_ranges)
> 
>  to :
> 
> struct_size(rx, mpdu_ranges, num_mpdu_ranges)
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

35b50e70df27 ath10k: Use struct_size() helper

-- 
https://patchwork.kernel.org/patch/10884271/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

