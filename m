Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774B51A3136
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 10:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgDIIuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 04:50:37 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:34207 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726654AbgDIIuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 04:50:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586422235; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=OU4Jaga5I6b7zdc3pesHpsRuwkhLu184VpmHgFHKPks=; b=jS6pKmxxL9C2GIMHkzIF+QmVYeNPC4UidlhZ9UiqNCo4jylDbTPCkqECs31NXZPRIqG1OOwW
 NlcWydY7+S/EHACisq4j4nknX0ReI4quGnqAErVZvPQFbbfeXUN6Pdj/ic+bMfMJ636tkc3E
 XqPPqauNJ8zk3FASVEbVqHkmfeA=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e8ee1d9.7f2b7239cdc0-smtp-out-n03;
 Thu, 09 Apr 2020 08:50:33 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4EDC5C433CB; Thu,  9 Apr 2020 08:50:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1235EC433D2;
        Thu,  9 Apr 2020 08:50:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1235EC433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ath11k: fix ath11k_thermal_unregister() prototype
References: <20200408190606.870098-1-arnd@arndb.de>
        <20200408190606.870098-2-arnd@arndb.de>
Date:   Thu, 09 Apr 2020 11:50:29 +0300
In-Reply-To: <20200408190606.870098-2-arnd@arndb.de> (Arnd Bergmann's message
        of "Wed, 8 Apr 2020 21:05:58 +0200")
Message-ID: <87d08hujoq.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> The stub function has the wrong prototype, causing a warning:
>
> drivers/net/wireless/ath/ath11k/core.c: In function 'ath11k_core_pdev_destroy':
> drivers/net/wireless/ath/ath11k/core.c:416:28: error: passing argument 1 of 'ath11k_thermal_unregister' from incompatible pointer type [-Werror=incompatible-pointer-types]
>
> Change it to take the same arguments as the normal implementation.
>
> Fixes: 2a63bbca06b2 ("ath11k: add thermal cooling device support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/ath/ath11k/thermal.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath11k/thermal.h b/drivers/net/wireless/ath/ath11k/thermal.h
> index f1395a14748c..ea9a58bf6a93 100644
> --- a/drivers/net/wireless/ath/ath11k/thermal.h
> +++ b/drivers/net/wireless/ath/ath11k/thermal.h
> @@ -36,7 +36,7 @@ static inline int ath11k_thermal_register(struct ath11k_base *sc)
>  	return 0;
>  }
>  
> -static inline void ath11k_thermal_unregister(struct ath11k *ar)
> +static inline void ath11k_thermal_unregister(struct ath11k_base *ar)
>  {
>  }

Already fixed by this commit:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=c9be1a642a7b9ec021e3f32e084dc781b3e5216d

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
