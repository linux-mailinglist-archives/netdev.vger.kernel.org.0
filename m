Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE05178980
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCDEWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:22:55 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:40268 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbgCDEWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 23:22:55 -0500
Received: by mail-pj1-f67.google.com with SMTP id k36so322306pje.5
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 20:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=nQfUGiEatJwNChq4TkI3mT8zp7mNnNmNUSDjmINJfEg=;
        b=1N8rNZveYC3zEEQ6teTiruZuThTh+aQ/T1kcmIKf/4U7KYsyjzUnI2DCoXAcDwhWS2
         Of+e0n9kyR152yiVnGBeUChg47waM/DnhTV2ovZIigVISEcxKusiRS/4/L/TbAmXcR/E
         3dTSVWDU0W02iugyT2s+2Zr223p1zZ2xAxSjzqHgRfuJ0hSBTwSiTyuTQt63ltMp0tzR
         VHbBSl62K451YRynxRVpzElL7kuMZA5o+vyUaUCK0yQel5J4ZcP0i5pAGZtoQTCBVq/H
         vTfaFaeHFnPajpW25ZAWBeFJkDA+GbMNUM7GzqF89iaYU5Q7vI8Lk9CEvRspJ0vAblio
         UElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=nQfUGiEatJwNChq4TkI3mT8zp7mNnNmNUSDjmINJfEg=;
        b=KdvLuytXNcSJyW+puE0+FqSnOASuhwKJ7phhCzxGX+pXrHGWVSukcQHAYeuc9gAXNC
         FrbibnvEkPw6BG8OvJJTzeRWFcychx2JVEqbKZOInhpztW4HjfdlK494tMPuQSELurmz
         jEc20CQtLXAzmIUeTi6CPduVW3wFCAnm2UJwiQNi7w1cMmCjoIzXJ98w3zh44SQKBPUY
         TPxr2bYYbHI6dHLvJtLOhl8aU3NEDj83wzgSHhuakoD10zmnixMZY/zd3ptw86LynhiW
         crPIK9Z/RV7wEbR5jLmXURVQnlraRrjXsZnjiBnyQhsbvV88DKhfznKpjqshwaz2Wgii
         hf5A==
X-Gm-Message-State: ANhLgQ3Occy1vNRYmjLVxNn0rceDt/SowBZbw/So2W71OslMfKRtwTUr
        yuIYfXdNVQ0QJeXhK1nxFhNNAAyiDs4=
X-Google-Smtp-Source: ADFU+vsx3gpG7SecqCiCmUAjXZa3CaK+WDl24EeiWEOPdXeqMBsO946JqV1OrE+6uof+53Cc6vbexA==
X-Received: by 2002:a17:902:8bc7:: with SMTP id r7mr1338097plo.12.1583295773954;
        Tue, 03 Mar 2020 20:22:53 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id v8sm696294pjr.10.2020.03.03.20.22.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 20:22:53 -0800 (PST)
Subject: Re: [PATCH net-next 06/12] ionic: let core reject the unsupported
 coalescing parameters
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     mkubecek@suse.cz, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org
References: <20200304035501.628139-1-kuba@kernel.org>
 <20200304035501.628139-7-kuba@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <313a02b6-cdfe-0322-2e16-67f1901b6724@pensando.io>
Date:   Tue, 3 Mar 2020 20:22:50 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200304035501.628139-7-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/20 7:54 PM, Jakub Kicinski wrote:
> Set ethtool_ops->coalesce_types to let the core reject
> unsupported coalescing parameters.
>
> This driver correctly rejects all unsupported parameters.
> No functional changes.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Thanks!

Acked-by: Shannon Nelson <snelson@pensando.io>


> ---
>   .../ethernet/pensando/ionic/ionic_ethtool.c   | 23 +------------------
>   1 file changed, 1 insertion(+), 22 deletions(-)
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> index f778fff034f5..83ea35715533 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> @@ -412,28 +412,6 @@ static int ionic_set_coalesce(struct net_device *netdev,
>   	unsigned int i;
>   	u32 coal;
>   
> -	if (coalesce->rx_max_coalesced_frames ||
> -	    coalesce->rx_coalesce_usecs_irq ||
> -	    coalesce->rx_max_coalesced_frames_irq ||
> -	    coalesce->tx_max_coalesced_frames ||
> -	    coalesce->tx_coalesce_usecs_irq ||
> -	    coalesce->tx_max_coalesced_frames_irq ||
> -	    coalesce->stats_block_coalesce_usecs ||
> -	    coalesce->use_adaptive_rx_coalesce ||
> -	    coalesce->use_adaptive_tx_coalesce ||
> -	    coalesce->pkt_rate_low ||
> -	    coalesce->rx_coalesce_usecs_low ||
> -	    coalesce->rx_max_coalesced_frames_low ||
> -	    coalesce->tx_coalesce_usecs_low ||
> -	    coalesce->tx_max_coalesced_frames_low ||
> -	    coalesce->pkt_rate_high ||
> -	    coalesce->rx_coalesce_usecs_high ||
> -	    coalesce->rx_max_coalesced_frames_high ||
> -	    coalesce->tx_coalesce_usecs_high ||
> -	    coalesce->tx_max_coalesced_frames_high ||
> -	    coalesce->rate_sample_interval)
> -		return -EINVAL;
> -
>   	ident = &lif->ionic->ident;
>   	if (ident->dev.intr_coal_div == 0) {
>   		netdev_warn(netdev, "bad HW value in dev.intr_coal_div = %d\n",
> @@ -784,6 +762,7 @@ static int ionic_nway_reset(struct net_device *netdev)
>   }
>   
>   static const struct ethtool_ops ionic_ethtool_ops = {
> +	.coalesce_types = ETHTOOL_COALESCE_USECS,
>   	.get_drvinfo		= ionic_get_drvinfo,
>   	.get_regs_len		= ionic_get_regs_len,
>   	.get_regs		= ionic_get_regs,

