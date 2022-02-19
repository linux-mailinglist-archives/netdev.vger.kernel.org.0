Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCD14BC8BD
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 14:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241855AbiBSNuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 08:50:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiBSNuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 08:50:39 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F2E1ADA6
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 05:50:20 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id o24so19172924wro.3
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 05:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=vOcw8vTX8u6yJ3UCIoAsM9Ua7JDOaic0XWawreOhs6g=;
        b=Rhw1KBaMmO6xdD+EZlarzq3USLlZ1ZLU5DT6414wZe6im0L05XgYn+4/nu6ekB8GG6
         lQe3VkM8iOGfi2uRrxD8EpIW6EKBYBOk1TQIOokBgV25snI+cadHl7aAg25+72+i/sHZ
         6AJFuvuRW+qJ/VMwSNfh3kJv+yFEns6JttY9pfIkF0lPjjZzcpGRMBSeWiLQ2HKDqhJ1
         LgSaE+b+kKctzUXr70wtZWRW8pUgYA7OyXqqhFoUuC7RO0fiHIWDyuSb1rxroG+/nCL+
         1kVUECKmVxHxTyX6Nsteqxl/7ZFFeDnTAaWxWGHsJcb+1XbUIUi2vR7SYgxOBJXPfQm2
         1vrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=vOcw8vTX8u6yJ3UCIoAsM9Ua7JDOaic0XWawreOhs6g=;
        b=Ly9BNd69dagHZm1/GyvAfllYO3YBN/SBLXt8ArPqkuxTPsoM6CPKot46YYK2TYrTE5
         NqzkOMtCElSJwTPZV0/Z2yX7TTZNt3haIsOVvX/Epv1nP9nCQxy7QMfJN3TRsg0JTV2Q
         sG3TQOTaCqxvbb/UpomuEEf9yHc4C97shocZqs0JSV4dS0be5RUXFRkOLh3hvDZGkdt2
         GJJaZolpVjhz+9WxmagJ4uo8MDvZC+TimcKxgQnRvIc6Id94paQ0nXLjo/tKYqiosYXs
         u7/hl0UlThelYd6hQcHrJ7kG1M2sZf9z0Sx0HQBHiQbVVWjA8XEPMu96dhQwy4sq6LvK
         PATA==
X-Gm-Message-State: AOAM533FKx3oew0Gou2KzT0ZOATcFgCYThMBx53q1qj7DpjFhLzWPF0e
        GQOj+3dCUja3GXjMYvPLw9k=
X-Google-Smtp-Source: ABdhPJxbGS478z60EJ9QAoRtwFewZ9CbC8Djk6ThgZXVX155Jm6ZTuvtNcleMQJh2x9+v2bETQ6lVg==
X-Received: by 2002:adf:ef92:0:b0:1e3:3f68:feb7 with SMTP id d18-20020adfef92000000b001e33f68feb7mr9479203wro.443.1645278619015;
        Sat, 19 Feb 2022 05:50:19 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id p8sm37899896wro.106.2022.02.19.05.50.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 19 Feb 2022 05:50:18 -0800 (PST)
Date:   Sat, 19 Feb 2022 13:50:16 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next resend 1/2] sfc: default config to 1
 channel/core in local NUMA node only
Message-ID: <20220219135016.qa6fv3pfnrrokw2q@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
References: <20220128151922.1016841-1-ihuguet@redhat.com>
 <20220216094139.15989-1-ihuguet@redhat.com>
 <20220216094139.15989-2-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220216094139.15989-2-ihuguet@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 10:41:38AM +0100, Íñigo Huguet wrote:
> Handling channels from CPUs in different NUMA node can penalize
> performance, so better configure only one channel per core in the same
> NUMA node than the NIC, and not per each core in the system.
> 
> Fallback to all other online cores if there are not online CPUs in local
> NUMA node.
> 
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/efx_channels.c | 50 ++++++++++++++++---------
>  1 file changed, 33 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> index ead550ae2709..ec6c2f231e73 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -78,31 +78,48 @@ static const struct efx_channel_type efx_default_channel_type = {
>   * INTERRUPTS
>   *************/
>  
> -static unsigned int efx_wanted_parallelism(struct efx_nic *efx)
> +static unsigned int count_online_cores(struct efx_nic *efx, bool local_node)
>  {
> -	cpumask_var_t thread_mask;
> +	cpumask_var_t filter_mask;
>  	unsigned int count;
>  	int cpu;
> +
> +	if (unlikely(!zalloc_cpumask_var(&filter_mask, GFP_KERNEL))) {
> +		netif_warn(efx, probe, efx->net_dev,
> +			   "RSS disabled due to allocation failure\n");
> +		return 1;
> +	}
> +
> +	cpumask_copy(filter_mask, cpu_online_mask);
> +	if (local_node) {
> +		int numa_node = pcibus_to_node(efx->pci_dev->bus);
> +
> +		cpumask_and(filter_mask, filter_mask, cpumask_of_node(numa_node));
> +	}
> +
> +	count = 0;
> +	for_each_cpu(cpu, filter_mask) {
> +		++count;
> +		cpumask_andnot(filter_mask, filter_mask, topology_sibling_cpumask(cpu));
> +	}
> +
> +	free_cpumask_var(filter_mask);
> +
> +	return count;
> +}
> +
> +static unsigned int efx_wanted_parallelism(struct efx_nic *efx)
> +{
> +	unsigned int count;
>  
>  	if (rss_cpus) {
>  		count = rss_cpus;
>  	} else {
> -		if (unlikely(!zalloc_cpumask_var(&thread_mask, GFP_KERNEL))) {
> -			netif_warn(efx, probe, efx->net_dev,
> -				   "RSS disabled due to allocation failure\n");
> -			return 1;
> -		}
> -
> -		count = 0;
> -		for_each_online_cpu(cpu) {
> -			if (!cpumask_test_cpu(cpu, thread_mask)) {
> -				++count;
> -				cpumask_or(thread_mask, thread_mask,
> -					   topology_sibling_cpumask(cpu));
> -			}
> -		}
> +		count = count_online_cores(efx, true);
>  
> -		free_cpumask_var(thread_mask);
> +		/* If no online CPUs in local node, fallback to any online CPUs */
> +		if (count == 0)
> +			count = count_online_cores(efx, false);
>  	}
>  
>  	if (count > EFX_MAX_RX_QUEUES) {
> -- 
> 2.31.1

-- 
Martin Habets <habetsm.xilinx@gmail.com>
