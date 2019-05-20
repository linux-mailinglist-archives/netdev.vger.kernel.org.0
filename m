Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0540123E2A
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 19:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392765AbfETRQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 13:16:51 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38444 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392756AbfETRQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 13:16:50 -0400
Received: by mail-pl1-f194.google.com with SMTP id f97so7004562plb.5
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 10:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iwBrfv8lZFcLQJuxEQw4ryA9Pff87UGYkKvp+WEgsEM=;
        b=lpTOQ2YJyCoLaJJB1b8QOSENRFwkKM327cgj2dBLR9wrw8omPdmlro1U9lE+oIi6P7
         yPmIzEDmxXpRE6Oaq/E5tzP/l9NlxSLr+46FQxLum+ADFyzOIG7KZ3zjBOv86Ob+FItx
         8Xlz0OotmjSrOjY6KfRKZNtlL4QD8cbU/Ate7u2lR9fBPSE+3m4BN0J2pUGQYf0kbmN5
         98dzhl4mSfgJJMlq1t4qKNwHPB+8c0eEJRsw7Z+/2adDIX41xYKui6sB5gK62meYgh4H
         gsUwPwPTvicMjZmivGRy5Udcz896i9ESJNmmg/+zyhHErJ5KL6xqBCHVXEMc9mUcrPH3
         uz+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iwBrfv8lZFcLQJuxEQw4ryA9Pff87UGYkKvp+WEgsEM=;
        b=RQoV5Y8JPIIMnMFyLcnRPU/kXVVkCm0aCF+5t2J9XEOphMsWB1OFbGgcqUXLjCvhp5
         Tkk/dkU9ZxRNiXAJr9PBVYUFhrMeh3Io3uuKtqhgMudJSlyJD26HF8NmXOzgmCIe/Y/7
         LoPAi/UuvZp5+G1AoC5+KXmxydTXTpNXhOrRtszUUGsCWUU/YppkIhQ7XLlsgMzUABnF
         1QfpydY3jegk7tJUU6pHFp53OY+9ucDUKVLDqyTe95IsL8SZUV2MDSedu88RtOdh9Ouy
         7XS0kMDEXBQElK+TVJo1f9Vl7bae+7HmMgVNPsSndfUUKubrnxY54fPz6KBHGMMdrbE0
         6DGg==
X-Gm-Message-State: APjAAAVoMnXdhkS5QYVP6EtnKeHeBfd6MsLvrptpZVEnP6wZPwNnkusp
        pSaYe0nCq9EooAW0TVwZCtBbcg==
X-Google-Smtp-Source: APXvYqyslm8OFC6kUCHeQjqmxsMsjLor8sCUEgRqtD7u5g54KFiDZBgk+XcT4LC673o+vHPybVpW+w==
X-Received: by 2002:a17:902:b495:: with SMTP id y21mr12215537plr.243.1558372609685;
        Mon, 20 May 2019 10:16:49 -0700 (PDT)
Received: from tuxbook-pro (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id y25sm27453653pfp.182.2019.05.20.10.16.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 May 2019 10:16:48 -0700 (PDT)
Date:   Mon, 20 May 2019 10:17:15 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     arnd@arndb.de, subashab@codeaurora.org, david.brown@linaro.org,
        agross@kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, cpratapa@codeaurora.org,
        syadagir@codeaurora.org, evgreen@chromium.org, benchan@google.com,
        ejcaruso@google.com, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] net: qualcomm: rmnet: don't use C bit-fields in
 rmnet checksum trailer
Message-ID: <20190520171715.GT2085@tuxbook-pro>
References: <20190520135354.18628-1-elder@linaro.org>
 <20190520135354.18628-6-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520135354.18628-6-elder@linaro.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 20 May 06:53 PDT 2019, Alex Elder wrote:

> Replace the use of C bit-fields in the rmnet_map_dl_csum_trailer
> structure with a single integral field, using field masks to
> encode or get at sub-field values.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h      | 6 ++++--
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 2 +-
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> index f3231c26badd..fb1cdb4ec41f 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> @@ -51,13 +51,15 @@ struct rmnet_map_header {
>  
>  struct rmnet_map_dl_csum_trailer {
>  	u8  reserved1;
> -	u8  valid:1;
> -	u8  reserved2:7;
> +	u8  flags;		/* RMNET_MAP_DL_* */
>  	u16 csum_start_offset;
>  	u16 csum_length;
>  	__be16 csum_value;
>  } __aligned(1);
>  
> +#define RMNET_MAP_DL_CSUM_VALID_FMASK	GENMASK(0, 0)
> +#define RMNET_MAP_DL_RESERVED_FMASK	GENMASK(7, 1)

I presume that the reserved define won't ever be referenced, but it's
good to have it "documented".

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> +
>  struct rmnet_map_ul_csum_header {
>  	__be16 csum_start_offset;
>  	__be16 csum_info;	/* RMNET_MAP_UL_* */
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> index 72b64114505a..a95111cdcd29 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> @@ -362,7 +362,7 @@ int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len)
>  
>  	csum_trailer = (struct rmnet_map_dl_csum_trailer *)(skb->data + len);
>  
> -	if (!csum_trailer->valid) {
> +	if (!u8_get_bits(csum_trailer->flags, RMNET_MAP_DL_CSUM_VALID_FMASK)) {
>  		priv->stats.csum_valid_unset++;
>  		return -EINVAL;
>  	}
> -- 
> 2.20.1
> 
