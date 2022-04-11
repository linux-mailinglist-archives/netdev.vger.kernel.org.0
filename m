Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5A44FC240
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 18:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348460AbiDKQ3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 12:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244728AbiDKQ3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 12:29:19 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F372CF2E;
        Mon, 11 Apr 2022 09:27:04 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id k22so5281454wrd.2;
        Mon, 11 Apr 2022 09:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ITFeuhIISg+UteX7JWYJlJzAHiy1YXAVNDcS4HitlFk=;
        b=CAknTVts7FZNNCh/mOgu+gKhOEu2Y/aqwVxaNM0kHSWyY/glJTkWs+t1hBDlOYMwO0
         vOsyAg3ZWt9rKSAYirIRS9YT7GKTIfpwgmj5Hix7tNeNxE5B0sr0C7kyaVIDuiswO/of
         zvBfzsRABDC/kZAqs7mvbcGUVODaUwnvPUpGan18XlyFAk8QPfIcDjfIw8IX5o1PVYVy
         NslaqRGIMKHic8ecpxpeEOtp04GwzBPfFbNBtcqWbLMjbaasnYYpRIHG15hGH0Za+K+P
         hXSyvoeoRbwPciFOiPEojsJL+/Ym8Bq5E5fvF47Dy0DuJsUn0kJ6p+VixB6iykcjd18x
         wKXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ITFeuhIISg+UteX7JWYJlJzAHiy1YXAVNDcS4HitlFk=;
        b=XxcNZUfgBSi70q+8npK8/PQ7gS18J/OmYe3ze+4cZ3PYpvrlOcafVizCfq39GpsPuY
         z2UcirEcqSPisfh71l3abE7PCDHSZ9PNbUrv1stgDuPNErOg8B4jdTwlKboO6TeoK23k
         2hKI2cJqXAzECuEibo1ydsiK9unQkk3ONgtY7dQB41NIektY0bCQOCjxy/9tffw0UyP6
         Qqj1bHXzrhhEPiCQUcbkWORFsIkn3IRTX0BSBm78lv3FLMswvj6azanHDoqz6fXIB30x
         Zk0IM3CF66wXNpC7Wsd72Q9qWePB3PYAtbTEmYR1rtiyAmhWrHB3RRlaJadT0+UsGOv7
         z50Q==
X-Gm-Message-State: AOAM532dP1ibiBfxY9my1bKs/w3XY3ayRTd3oGmVzw3M2pcldcxMvLgs
        fQe02uZ+WNFWVjgpSu38i5zOFhRq722Ufw==
X-Google-Smtp-Source: ABdhPJyn/l/yymgrincqx9jqS6snjtWym7mz9/5OBTtPWM1cOAUYev+ht24Ox443KlRM9ef/kyV1Kw==
X-Received: by 2002:a5d:64aa:0:b0:206:d0e:14a5 with SMTP id m10-20020a5d64aa000000b002060d0e14a5mr25308152wrp.705.1649694423153;
        Mon, 11 Apr 2022 09:27:03 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id n65-20020a1c2744000000b003862bfb509bsm18065887wmn.46.2022.04.11.09.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 09:27:02 -0700 (PDT)
Subject: Re: [PATCH V2] sfc: ef10: Fix assigning negative value to unsigned
 variable
To:     Haowen Bai <baihaowen@meizu.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1649640757-30041-1-git-send-email-baihaowen@meizu.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <1912936d-14b5-f6af-c927-c46fabc72da5@gmail.com>
Date:   Mon, 11 Apr 2022 17:27:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1649640757-30041-1-git-send-email-baihaowen@meizu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/04/2022 02:32, Haowen Bai wrote:
> fix warning reported by smatch:
> 251 drivers/net/ethernet/sfc/ef10.c:2259 efx_ef10_tx_tso_desc()
> warn: assigning (-208) to unsigned variable 'ip_tot_len'
> 
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
Acked-by: Edward Cree <ecree.xilinx@gmail.com>

> V1->V2: to assign "0x10000 - EFX_TSO2_MAX_HDRLEN" is the actual 
> semantics of the value.
> 
>  drivers/net/ethernet/sfc/ef10.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> index 50d535981a35..c9ee5011803f 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -2256,7 +2256,7 @@ int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
>  	 * guaranteed to satisfy the second as we only attempt TSO if
>  	 * inner_network_header <= 208.
>  	 */
> -	ip_tot_len = -EFX_TSO2_MAX_HDRLEN;
> +	ip_tot_len = 0x10000 - EFX_TSO2_MAX_HDRLEN;
>  	EFX_WARN_ON_ONCE_PARANOID(mss + EFX_TSO2_MAX_HDRLEN +
>  				  (tcp->doff << 2u) > ip_tot_len);
>  
> 

