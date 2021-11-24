Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2182A45B7E7
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 11:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238446AbhKXKDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 05:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237447AbhKXKDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 05:03:11 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32894C061574;
        Wed, 24 Nov 2021 02:00:02 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id az34-20020a05600c602200b0033bf8662572so1596721wmb.0;
        Wed, 24 Nov 2021 02:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fDGLhfDjPWff/jphpjh1PfEIbNyQ4NbvKbsbx5VhX88=;
        b=PKN9ml0gWOiIaXGyeiOp+axDTXn416NLwErJ724mtIXPheMMggpeBGduxFgTYHU0Ov
         ONnF3amnm6fNLVnp8A2npngkVIuuyj6LvR+aFsorG9J9clu7YnFwb4lJsFYWye94K1jU
         zg2legOMMJEb+VWY3rRWKirmoInhddtRho9pMvcoJP99xjk9RGWzzULk9jWDsdvoxrQ3
         wJIyw6WwfavcBkvJJXyRGE4qliNmAO45fMM0nlH+iTVevFAZbSzcyp9ueCdzbU7i44Q6
         Wf3/RqR8O3+1JAaJ0qocfc48CChk0CE18EmKLZswQKjTZEG2aKa5/C/Jltv9+StwXXCi
         nxQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fDGLhfDjPWff/jphpjh1PfEIbNyQ4NbvKbsbx5VhX88=;
        b=eevskUXdAu8SYDOCpZro+/jhSP3o5k/IUN9mOANOZBqwWR49mf0/89rD5+jN5g+O8g
         oub5HJJw0bpfHTdQi+2oer+PZnKq+Iuecij/TNjChDlvzvyKNZKSbvwwiHkHfCurGh/W
         +gQW2zeqSvO3N90pj61VmtPeMCnF+znz0vwDfhN2O7r2w+7lkFPQQ+g0VHsYgii6KLvs
         qkOLs7FFJgEHTlCGB8EvPFxPD9gu3C8qrao9YKH/VaJZQhm/pw+elGuNHGvfPkZjfNt4
         SWyliY1ZUYPnM1/Jl1vocIvD8I6ci4/zYuXcLSysbwtchUE3NMUm7Dt4j4Swut6WOkTe
         32Lw==
X-Gm-Message-State: AOAM530j+Ndbo5+A121Hy29FrxrfeKlLrDe7AFfLJKAeRHz2UZWSaRa3
        hB7n0HzQwqo3k/FotUuc6qA=
X-Google-Smtp-Source: ABdhPJwShWfZ+RfN+bWeHfHazhCO4KTtkR/Dkk4iDYcfF0Pd4Pbhsgu9oCwZRwoCIGwJwitNMguipw==
X-Received: by 2002:a1c:f30d:: with SMTP id q13mr13130994wmq.55.1637748000734;
        Wed, 24 Nov 2021 02:00:00 -0800 (PST)
Received: from [80.5.213.92] (cpc108963-cmbg20-2-0-cust347.5-4.cable.virginm.net. [80.5.213.92])
        by smtp.gmail.com with ESMTPSA id y12sm14655857wrn.73.2021.11.24.02.00.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 02:00:00 -0800 (PST)
Subject: Re: [PATCH v2 net-next 11/26] sf100, sfx: implement generic XDP stats
 callbacks
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Martin Habets <habetsm.xilinx@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
 <20211123163955.154512-12-alexandr.lobakin@intel.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <e6e31c0e-c3a0-aecf-54f0-d7ee3bf3c7c2@gmail.com>
Date:   Wed, 24 Nov 2021 09:59:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20211123163955.154512-12-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/11/2021 16:39, Alexander Lobakin wrote:
> Export 4 per-channel XDP counters for both sf100 and sfx drivers
> using generic XDP stats infra.
> 
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
The usual Subject: prefix for these drivers is sfc:
 (or occasionally sfc_ef100: for ef100-specific stuff).

> +int efx_get_xdp_stats_nch(const struct net_device *net_dev, u32 attr_id)
> +{
> +	const struct efx_nic *efx = netdev_priv(net_dev);
> +
> +	switch (attr_id) {
> +	case IFLA_XDP_XSTATS_TYPE_XDP:
> +		return efx->n_channels;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
> +int efx_get_xdp_stats(const struct net_device *net_dev, u32 attr_id,
> +		      void *attr_data)
> +{
> +	struct ifla_xdp_stats *xdp_stats = attr_data;
> +	struct efx_nic *efx = netdev_priv(net_dev);
> +	const struct efx_channel *channel;
> +
> +	switch (attr_id) {
> +	case IFLA_XDP_XSTATS_TYPE_XDP:
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	spin_lock_bh(&efx->stats_lock);
> +
> +	efx_for_each_channel(channel, efx) {
> +		xdp_stats->drop = channel->n_rx_xdp_drops;
> +		xdp_stats->errors = channel->n_rx_xdp_bad_drops;
> +		xdp_stats->redirect = channel->n_rx_xdp_redirect;
> +		xdp_stats->tx = channel->n_rx_xdp_tx;
> +
> +		xdp_stats++;
> +	}What guarantees that efx->n_channels won't change between these two
 calls, potentially overrunning the buffer?

-ed
