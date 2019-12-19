Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 581CD1263B4
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 14:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfLSNiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 08:38:25 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:21377 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726744AbfLSNiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 08:38:25 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576762705; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=RPQGFB5PyYkICsCq/dy0eg390UyfcUdXx5VEiXg0zF4=; b=YaaTnEL/Paik9aukL5qtVKu/pQvy3pbamBE86aYgLsVbxlhHFUssCh503s+lS2JAsRabdlgP
 4iVmk38lc/FSHw5leu6kWAT/2puN5Kpughzj+gBMVbA9dqvwphHz0GEKQ7onWCWuVQxd6JgG
 w3qOofwF1cUAtLNAUNay3Mf+Gc8=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfb7d50.7f3b38c24960-smtp-out-n03;
 Thu, 19 Dec 2019 13:38:24 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F300DC447A4; Thu, 19 Dec 2019 13:38:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 44ECBC4479F;
        Thu, 19 Dec 2019 13:38:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 44ECBC4479F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     <davem@davemloft.net>, <msinada@codeaurora.org>,
        <periyasa@codeaurora.org>, <mpubbise@codeaurora.org>,
        <julia.lawall@lip6.fr>, <milehu@codeaurora.org>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] ath11k: add dependency for struct ath11k member debug
References: <20191213012417.130719-1-maowenan@huawei.com>
Date:   Thu, 19 Dec 2019 15:38:18 +0200
In-Reply-To: <20191213012417.130719-1-maowenan@huawei.com> (Mao Wenan's
        message of "Fri, 13 Dec 2019 09:24:17 +0800")
Message-ID: <875zic77w5.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mao Wenan <maowenan@huawei.com> writes:

> If CONFIG_ATH11K, CONFIG_MAC80211_DEBUGFS are set,
> and CONFIG_ATH11K_DEBUGFS is not set, below error can be found,
> drivers/net/wireless/ath/ath11k/debugfs_sta.c: In function ath11k_dbg_sta_open_htt_peer_stats:
> drivers/net/wireless/ath/ath11k/debugfs_sta.c:411:4: error: struct ath11k has no member named debug
>   ar->debug.htt_stats.stats_req = stats_req;
>
> It is to add the dependency for the member of struct ath11k.
>
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  drivers/net/wireless/ath/ath11k/debugfs_sta.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath11k/debugfs_sta.c b/drivers/net/wireless/ath/ath11k/debugfs_sta.c
> index 3c5f931..bcc51d7 100644
> --- a/drivers/net/wireless/ath/ath11k/debugfs_sta.c
> +++ b/drivers/net/wireless/ath/ath11k/debugfs_sta.c
> @@ -408,7 +408,9 @@ ath11k_dbg_sta_open_htt_peer_stats(struct inode *inode, struct file *file)
>  		return -ENOMEM;
>  
>  	mutex_lock(&ar->conf_mutex);
> +#ifdef CONFIG_ATH11K_DEBUGFS
>  	ar->debug.htt_stats.stats_req = stats_req;
> +#endif

ifdefs are ugly and I don't think this is the root cause for the
problem. I suspect (but not sure!) that ATH11K_DEBUGFS should depend on
MAC80211_DEBUGFS, not DEBUG_FS like it does now. Or would there be a
valid reason to have ATH11K_DEBUGFS enabled but not MAC80211_DEBUGFS?

Then we could also change Makefile to this:

ath11k-$(CONFIG_ATH11K_DEBUGFS) += debugfs_sta.o

And hopefully get rid of an ifdef:

drivers/net/wireless/ath/ath11k/debug.h:#ifdef CONFIG_MAC80211_DEBUGFS
drivers/net/wireless/ath/ath11k/debug.h:#else /* !CONFIG_MAC80211_DEBUGFS */
drivers/net/wireless/ath/ath11k/debug.h:#endif /* CONFIG_MAC80211_DEBUGFS*/

Care to try this out?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
