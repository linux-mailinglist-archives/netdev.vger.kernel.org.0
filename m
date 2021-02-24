Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C0B324254
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 17:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbhBXQof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 11:44:35 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:33615 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233117AbhBXQoc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 11:44:32 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614185052; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=47RZdZMX6h81pOYJV0C4w+7D68ydw/vNclxkO6cmVt0=; b=AEoGlMbANXAl9XdGLDQ1Fk3Ehh4uR+JgZE29D1CZ+B87K60H0us5xXu8qJkKMvHdg7Hmt8PT
 Wi4rnwGP2QYWMp4xvDKaYJhCgx3/7YG1PEwwXkbuQ70HBef0K8YJqdr/cs3IgDnRPKyomkGC
 trX9dARr/ab9bK5KUOhw9++rDvc=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 60368254095efe1816fbc6f4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 24 Feb 2021 16:44:04
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DA8DAC433C6; Wed, 24 Feb 2021 16:44:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F319FC433CA;
        Wed, 24 Feb 2021 16:44:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F319FC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Marcus Folkesson <marcus.folkesson@gmail.com>
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wilc1000: write value to WILC_INTR2_ENABLE register
References: <20210224163706.519658-1-marcus.folkesson@gmail.com>
Date:   Wed, 24 Feb 2021 18:43:59 +0200
In-Reply-To: <20210224163706.519658-1-marcus.folkesson@gmail.com> (Marcus
        Folkesson's message of "Wed, 24 Feb 2021 17:37:06 +0100")
Message-ID: <87pn0pfmb4.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marcus Folkesson <marcus.folkesson@gmail.com> writes:

> Write the value instead of reading it twice.
>
> Fixes: 5e63a598441a ("staging: wilc1000: added 'wilc_' prefix for function in wilc_sdio.c file")
>
> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
> ---
>  drivers/net/wireless/microchip/wilc1000/sdio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
> index 351ff909ab1c..e14b9fc2c67a 100644
> --- a/drivers/net/wireless/microchip/wilc1000/sdio.c
> +++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
> @@ -947,7 +947,7 @@ static int wilc_sdio_sync_ext(struct wilc *wilc, int nint)
>  			for (i = 0; (i < 3) && (nint > 0); i++, nint--)
>  				reg |= BIT(i);
>  
> -			ret = wilc_sdio_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
> +			ret = wilc_sdio_write_reg(wilc, WILC_INTR2_ENABLE, reg);

To me it looks like the bug existed before commit 5e63a598441a:

-			ret = sdio_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
+			ret = wilc_sdio_read_reg(wilc, WILC_INTR2_ENABLE, &reg);

https://git.kernel.org/linus/5e63a598441a

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
