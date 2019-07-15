Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7364C685FF
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 11:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbfGOJIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 05:08:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60972 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729245AbfGOJIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 05:08:04 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F35D561637; Mon, 15 Jul 2019 09:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563181684;
        bh=XXEx2SGPd/y29oJqiw72fYVS8bt6+WZwLgNdQS4oaJc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ERzgIDqxXRNtiVZsLTwfK5oRrCoBlXrBPfxQQzeBCZc3ZWYu6LA4B6ZDS35k6ZfrW
         6m6IaTaj/DZoBzwQIcIlmYjV3e6D+ZC0UKK0jEFb2WrBw3+LHv+1wamo8mlVbcWUoy
         fls3VOEXCtlz4ivvVwCM6uPidA6YzUFc5A/Cnv5c=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C79D060FEA;
        Mon, 15 Jul 2019 09:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563181682;
        bh=XXEx2SGPd/y29oJqiw72fYVS8bt6+WZwLgNdQS4oaJc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZrbtEsoelGyAUKYhXwV8pbR1UMZr9f+YcSRzYhDpG5I6nZsksMURJhJcApQf+EXy8
         taakRvgWkUNijeUlUFyDsqOIqVTI0S+iXaIzOX7N1pbT1TqRFjCrtFi0HaG4dIqMd3
         VPMkMWJmLysJHP6KIAEic89GMjQImtFRMeI8hj9I=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C79D060FEA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH v3 20/24] wireless: Remove call to memset after dma_alloc_coherent
References: <20190715031941.7120-1-huangfq.daxian@gmail.com>
Date:   Mon, 15 Jul 2019 12:07:56 +0300
In-Reply-To: <20190715031941.7120-1-huangfq.daxian@gmail.com> (Fuqian Huang's
        message of "Mon, 15 Jul 2019 11:19:41 +0800")
Message-ID: <87v9w38y37.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fuqian Huang <huangfq.daxian@gmail.com> writes:

> In commit 518a2f1925c3
> ("dma-mapping: zero memory returned from dma_alloc_*"),
> dma_alloc_coherent has already zeroed the memory.
> So memset is not needed.
>
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
> ---
> Changes in v3:
>   - Use actual commit rather than the merge commit in the commit message
>
>  drivers/net/wireless/ath/ath10k/ce.c                     | 5 -----
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c  | 2 --
>  drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c | 2 --
>  drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c | 2 --
>  4 files changed, 11 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
> index eca87f7c5b6c..294fbc1e89ab 100644
> --- a/drivers/net/wireless/ath/ath10k/ce.c
> +++ b/drivers/net/wireless/ath/ath10k/ce.c
> @@ -1704,9 +1704,6 @@ ath10k_ce_alloc_dest_ring_64(struct ath10k *ar, unsigned int ce_id,
>  	/* Correctly initialize memory to 0 to prevent garbage
>  	 * data crashing system when download firmware
>  	 */
> -	memset(dest_ring->base_addr_owner_space_unaligned, 0,
> -	       nentries * sizeof(struct ce_desc_64) + CE_DESC_RING_ALIGN);

Shouldn't you also remove the comment?

-- 
Kalle Valo
