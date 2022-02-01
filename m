Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A824A5C16
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237874AbiBAMUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236263AbiBAMUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 07:20:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5456CC061714;
        Tue,  1 Feb 2022 04:20:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8D84CE1854;
        Tue,  1 Feb 2022 12:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B17C340ED;
        Tue,  1 Feb 2022 12:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643718001;
        bh=hRvqAaJafSB7JM7vkxQW5UN6K4O0gDJkhTpA26IZPwE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DgD9gHF4dbe5av/ULrVQc7az4gwaMXHibzLukCPxYdgq6Yv9l/uG+ubulAUmPtd3g
         cB5cpQePFCGYiTn38QO4fKBYGX/wRvudP3llwz4IeuoRhsfbereF/VsVGDW3mljesc
         iXGV5P6HSp/NwXSa5pMEwkhghe00S08HBjA8Y9PHF2hJcsnjUym6OPgs/eUqh/O+BV
         NqTnoQzPRi961xotMsevar0wVZsLy8bk50biiC1M+3b/QnUwBraERIDhi3rZiYFMKE
         /lAd819+mYQZNozd1a1BHj/DiECRcnKLt3V84IMUDEnvlTJ2D1tByt1cz+yTNb3qT3
         7ZBJZPRcvAFxg==
From:   Kalle Valo <kvalo@kernel.org>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] drivers/net/wireless: remove redundant ret variable
References: <20220112080715.667254-1-chi.minghao@zte.com.cn>
Date:   Tue, 01 Feb 2022 14:19:57 +0200
In-Reply-To: <20220112080715.667254-1-chi.minghao@zte.com.cn> (cgel zte's
        message of "Wed, 12 Jan 2022 08:07:15 +0000")
Message-ID: <87tudidbiq.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com writes:

> From: Minghao Chi <chi.minghao@zte.com.cn>
>
> Return value directly instead of taking this in another redundant
> variable.
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
> ---
>  drivers/net/wireless/marvell/libertas/cfg.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
> index 4e3de684928b..f160c258805e 100644
> --- a/drivers/net/wireless/marvell/libertas/cfg.c
> +++ b/drivers/net/wireless/marvell/libertas/cfg.c
> @@ -854,16 +854,13 @@ void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event)
>  static int lbs_remove_wep_keys(struct lbs_private *priv)
>  {
>  	struct cmd_ds_802_11_set_wep cmd;
> -	int ret;
>  
>  	memset(&cmd, 0, sizeof(cmd));
>  	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
>  	cmd.keyindex = cpu_to_le16(priv->wep_tx_key);
>  	cmd.action = cpu_to_le16(CMD_ACT_REMOVE);
>  
> -	ret = lbs_cmd_with_response(priv, CMD_802_11_SET_WEP, &cmd);
> -
> -	return ret;
> +	return lbs_cmd_with_response(priv, CMD_802_11_SET_WEP, &cmd);
>  }
>  
>  /*
> @@ -949,9 +946,7 @@ static int lbs_enable_rsn(struct lbs_private *priv, int enable)
>  	cmd.action = cpu_to_le16(CMD_ACT_SET);
>  	cmd.enable = cpu_to_le16(enable);
>  
> -	ret = lbs_cmd_with_response(priv, CMD_802_11_ENABLE_RSN, &cmd);
> -
> -	return ret;
> +	return lbs_cmd_with_response(priv, CMD_802_11_ENABLE_RSN, &cmd);
>  }

In lbs_enable_rsn() ret variable is now unused.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
