Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F4F46F5E9
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 22:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhLIVbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 16:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhLIVbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 16:31:31 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3831AC061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 13:27:57 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i12so6591899pfd.6
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 13:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SlYwdILx1pgFYgrzXrDq23q40uURPJrzp4eiVC0Mk/k=;
        b=caSl8y1BBrdIsoOuLE8y2s7C2RbbGbd6/utl+lBm8XWaM+O4sE/xJbwecZ0aA6bbT0
         JNVajC8Ola6BEqf+X/hlMV0Ltp7HDKhY7kWCjJl4Be2Wgi+TGfxW2/asMl88Ecr6fOqS
         HIcrJ+7xbO1cdOcomoQhgTRcYX3DDDvHYauP++a43W5rHtbfysFgkJIbt0a3lhw2fqi7
         mVZ4qDGDGqvLABhepzTqZrUx13lixF6FSrDJL9EITxywHAqHkqXdhAEwHkee5cjepwbV
         KMPE/YOmfWyHTgQkWHWTxExZy3lky4yG7D1GvMy//Jlce8gWZY+U5fiCl0tM0PSR2fyb
         nrOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SlYwdILx1pgFYgrzXrDq23q40uURPJrzp4eiVC0Mk/k=;
        b=7Ztr6108Yc9E7EWmaxH2XzjpkMcn9fpYmgTBbPq/mZCSdgFMsj3bXprvjrbbx9Oiub
         NOy5+5QD0L6HbirxU2CT0v2xJwDViPjrFLB3G31zD4PlOT4Lb3cvh5k2jYT1u/DEKU8C
         9T8vovcGg0DnfQK5WJaRujcqsVN+xDkRLlX6EaTBnEYWvpOJ81AHAs0RTBm+Iry6rz2M
         ruJzPK45zU7G9lWvCiYGxaS+HJ2Nj5CpXn8w1r7TPWZ0aNG4GEY7bWYdr1G8tXueiZQm
         1NeRfyLV+x7GAiIkVYb2Non42uhmNm5AyJaQllvTxmTqG4+EP26OcSc7kCxi/L9KdaCc
         qisg==
X-Gm-Message-State: AOAM5301RDQnYfXyn38cwLbim16TfGpTF3aUwvbZFzQX08qbOMaYraN3
        BtlmudQ9+Wu/2a3uXGE7ts8=
X-Google-Smtp-Source: ABdhPJykkliK32R177o4RAdb9XX6/gJ76949q/G5nhL3mypwPTFFZtJ5mw5T+xFHPM7kThIHfaIDgA==
X-Received: by 2002:a65:58cc:: with SMTP id e12mr33498392pgu.59.1639085276804;
        Thu, 09 Dec 2021 13:27:56 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id j22sm618291pfj.130.2021.12.09.13.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 13:27:56 -0800 (PST)
Date:   Thu, 9 Dec 2021 13:27:53 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCHv2 net-next 1/2] net_tstamp: add new flag
 HWTSTAMP_FLAG_BONDED_PHC_INDEX
Message-ID: <20211209212753.GC21819@hoboy.vegasvil.org>
References: <20211209102449.2000401-1-liuhangbin@gmail.com>
 <20211209102449.2000401-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209102449.2000401-2-liuhangbin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 06:24:48PM +0800, Hangbin Liu wrote:
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index 1d309a666932..10ac5457dcbc 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -186,18 +186,27 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
>  	struct hwtstamp_config cfg;
>  	enum hwtstamp_tx_types tx_type;
>  	enum hwtstamp_rx_filters rx_filter;
> -	int tx_type_valid = 0;
> +	enum hwtstamp_flags flag;
>  	int rx_filter_valid = 0;
> +	int tx_type_valid = 0;
> +	int flag_valid = 0;
>  
>  	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
>  		return -EFAULT;
>  
> -	if (cfg.flags) /* reserved for future extensions */
> -		return -EINVAL;
> -
> +	flag = cfg.flags;
>  	tx_type = cfg.tx_type;
>  	rx_filter = cfg.rx_filter;
>  
> +	switch (flag) {
> +	case HWTSTAMP_FLAG_BONDED_PHC_INDEX:
> +		flag_valid = 1;

This isn't correct.  You need to use a bitwise test.

Thanks,
Richard


> +		break;
> +	case __HWTSTAMP_FLAGS_CNT:
> +		/* not a real value */
> +		break;
> +	}
> +
>  	switch (tx_type) {
>  	case HWTSTAMP_TX_OFF:
>  	case HWTSTAMP_TX_ON:
> @@ -234,7 +243,7 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
>  		break;
>  	}
>  
> -	if (!tx_type_valid || !rx_filter_valid)
> +	if (!flag_valid || !tx_type_valid || !rx_filter_valid)
>  		return -ERANGE;
>  
>  	return 0;
> -- 
> 2.31.1
> 
