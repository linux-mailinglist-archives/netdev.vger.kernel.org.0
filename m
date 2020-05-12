Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6481CEE1B
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 09:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgELHdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 03:33:50 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:28824 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729040AbgELHdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 03:33:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589268826; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=/qP6S8+xrEXaQmMPK80tKynj9uy70EBGXOIBLdpDKLU=;
 b=ILcH7UHCLmT+MM11Qfs4gXb9sa1/W3NFUZ3rf9pKDkCWMNHhtfMiyi6hHQDlDkPrwqfU16BV
 UmcogmVvY09tXKdylHim+doKR+j85P1OpgSYH/kPYfS7VQaCuojElKY7DxKBwi3dtpTaBVAA
 0hifwCd91x68WV/sRQsBLtbqXQA=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eba5158.7f3531b7c618-smtp-out-n01;
 Tue, 12 May 2020 07:33:44 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BE5A0C44793; Tue, 12 May 2020 07:33:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6106AC4478F;
        Tue, 12 May 2020 07:33:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6106AC4478F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next 1/2] ath10k: fix gcc-10 zero-length-bounds
 warnings
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200509120707.188595-1-arnd@arndb.de>
References: <20200509120707.188595-1-arnd@arndb.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Michal Kazior <michal.kazior@tieto.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wen Gong <wgong@codeaurora.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200512073342.BE5A0C44793@smtp.codeaurora.org>
Date:   Tue, 12 May 2020 07:33:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> gcc-10 started warning about out-of-bounds access for zero-length
> arrays:
> 
> In file included from drivers/net/wireless/ath/ath10k/core.h:18,
>                  from drivers/net/wireless/ath/ath10k/htt_rx.c:8:
> drivers/net/wireless/ath/ath10k/htt_rx.c: In function 'ath10k_htt_rx_tx_fetch_ind':
> drivers/net/wireless/ath/ath10k/htt.h:1683:17: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'struct htt_tx_fetch_record[0]' [-Wzero-length-bounds]
>  1683 |  return (void *)&ind->records[le16_to_cpu(ind->num_records)];
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath10k/htt.h:1676:29: note: while referencing 'records'
>  1676 |  struct htt_tx_fetch_record records[0];
>       |                             ^~~~~~~
> 
> Make records[] a flexible array member to allow this, moving it behind
> the other zero-length member that is not accessed in a way that gcc
> warns about.
> 
> Fixes: 22e6b3bc5d96 ("ath10k: add new htt definitions")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

9f12bebd512c ath10k: fix gcc-10 zero-length-bounds warnings
32221df6765b ath10k: fix ath10k_pci struct layout

-- 
https://patchwork.kernel.org/patch/11538233/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
