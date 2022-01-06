Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384C74861C3
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237169AbiAFJC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236715AbiAFJC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 04:02:26 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA66C061245;
        Thu,  6 Jan 2022 01:02:26 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id h23so3488376wrc.1;
        Thu, 06 Jan 2022 01:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1U4NWLNw6loRYINOoYaOJrgBMNRCXi8c1uaneowkkyM=;
        b=DVNC7xy3HgBwZub9F0uqPgsOH4Bl+fd4+Up3YuzSdLzxT2+/j2hC3PUQjBvJ6KU9ec
         rK8oWDVrHQ58N3sa6NzXVCQWPhutHW9xjheUzScoB83CeconuROWMiMh3MsTg6rO909V
         zOxLHyzhERuaB5u/0eooUAwJKNRvdQeT2URemmG/W4NjI6zAlgEkR2M6p2UBKEMavLoJ
         SbCliWPHCnFygbeNlplYOwvl3BFQl7OuQUH5xEo7WY7iuG4OQBvCUfzmK1Rn+m8vITQR
         6VxMsU0qjpLgniWTOb1BXGtZWAlRgTwo3XeUfU+6W2KNQWPkh8UyvwxYixyStDx4iDvx
         +TQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=1U4NWLNw6loRYINOoYaOJrgBMNRCXi8c1uaneowkkyM=;
        b=t3FwtaekywieKZUk6SplJ5vUVClv3AT7/ySZLVNqalKo8dm7547wo/8wjq+MXxf8kj
         tVKti7JqqUYmRalRl2Z9HP++1kGGMHAi/9nPc0kCKz17tQLswPTqdwRqxWYMeNMB1frE
         1eKYEATvy/yUr/+3eQ9oIbyfUEjXCxoQHI/x0DX5DWVJhfUV6r55PJQ/+ekp6lS4wwgl
         LSuvyXg9AiF7cOmeiQ86NFLMJFLaa0vxHl+jata7tdq8o2bhDT0mX++C6XvL4NtSpPXE
         DYXGSdoFZQgbogRAQAMU84Attfb1E+/x1u9h7jbIN7QK/sYrn94fp04NMTqePkWZm+VH
         gCSA==
X-Gm-Message-State: AOAM533LyhDWapKFQP9D/hdA1WywX//VhOnG2228ZLuUPNL3WYcRdJBW
        0nFxS3/pk6D/QT8IzAHLvgV968a8D4I=
X-Google-Smtp-Source: ABdhPJxAt03KsiKP5A5YtrODkSW/XT6NqwjWsSsFj86xX714IoiLZQtZsYxlh0h9rtDZO208KTaWEw==
X-Received: by 2002:a5d:48c2:: with SMTP id p2mr43326425wrs.543.1641459744879;
        Thu, 06 Jan 2022 01:02:24 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id o3sm1188505wmr.15.2022.01.06.01.02.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Jan 2022 01:02:24 -0800 (PST)
Date:   Thu, 6 Jan 2022 09:02:21 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] sfc: Use swap() instead of open coding it
Message-ID: <20220106090221.4gj6cevh2sb7hrfb@gmail.com>
Mail-Followup-To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
References: <20220105152237.45991-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105152237.45991-1-jiapeng.chong@linux.alibaba.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 11:22:37PM +0800, Jiapeng Chong wrote:
> Clean the following coccicheck warning:
> 
> ./drivers/net/ethernet/sfc/efx_channels.c:870:36-37: WARNING opportunity
> for swap().
> 
> ./drivers/net/ethernet/sfc/efx_channels.c:824:36-37: WARNING opportunity
> for swap().
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/efx_channels.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> index b015d1f2e204..ead550ae2709 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -819,11 +819,8 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
>  	old_txq_entries = efx->txq_entries;
>  	efx->rxq_entries = rxq_entries;
>  	efx->txq_entries = txq_entries;
> -	for (i = 0; i < efx->n_channels; i++) {
> -		channel = efx->channel[i];
> -		efx->channel[i] = other_channel[i];
> -		other_channel[i] = channel;
> -	}
> +	for (i = 0; i < efx->n_channels; i++)
> +		swap(efx->channel[i], other_channel[i]);
>  
>  	/* Restart buffer table allocation */
>  	efx->next_buffer_table = next_buffer_table;
> @@ -865,11 +862,8 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
>  	/* Swap back */
>  	efx->rxq_entries = old_rxq_entries;
>  	efx->txq_entries = old_txq_entries;
> -	for (i = 0; i < efx->n_channels; i++) {
> -		channel = efx->channel[i];
> -		efx->channel[i] = other_channel[i];
> -		other_channel[i] = channel;
> -	}
> +	for (i = 0; i < efx->n_channels; i++)
> +		swap(efx->channel[i], other_channel[i]);
>  	goto out;
>  }
>  
> -- 
> 2.20.1.7.g153144c
