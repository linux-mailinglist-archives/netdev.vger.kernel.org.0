Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071944C879C
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 10:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbiCAJRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 04:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiCAJRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 04:17:05 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDC1593BB
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 01:16:23 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id r10so19404540wrp.3
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 01:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=M64AHVBykIj5cwPxk3iPCORUsWk8LTcdV+DGF5MrXSY=;
        b=Hf9aWOWOgfPuqL0Wez4BicCDlO2ElM6QBcCAmXmzJRfoTCwR3C1A3D0/934PVy15Wl
         23nmGskhYJrZzRH/uTNFJXpHN1qXbER9fo7hqO2ucMg1ftLF9qvmav3wxdO9jf3XgObs
         26bI4wWlTcYGvLNNzqqhCkRi6XxHEX6Q+y2zSDDDy8aWAJyP2aeZA6yeHV5TPx3+X0Xc
         3LOFlNQyL2FPW42HIT2+CyuPZiizkgCT+bR+TEm72msPowvxSRLz0ZSAJftDxofbUMJ+
         W13wIi+BPCna1DJIRmYVv2aR3TWt5wRWBoztEq6wEihYDPP0nXQwUgaoesTZ4PMekchg
         Ri/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=M64AHVBykIj5cwPxk3iPCORUsWk8LTcdV+DGF5MrXSY=;
        b=kUaVcWZrZktmpbWTBjHrzz+nPBlNZOLRv4PVQN3Wi1S1uOnGVHQqELnRkm3TBDKi7Q
         RrI4GaMiKzX32vGsfHff2VYzJTnM74GikYAYby402fUac8nOAmnxjVlCigg2yV6ib7kj
         ucgpmJ76U+RtV7+PQA6aTURUGV7ZVJxPkvMmuXNnT7wyUdmw7GA8H/bEbvfH7xTjbBEF
         s0r4o2VIqNs+ZyPJP3Sp3gbK8b/uI9vnDf/nsxCx9tXV0CVMRHzXGYShDZAcZ1dNWGpH
         kkCD9YM9lOEYJNaWFeIOGcWGf1Qv8RMH3s5QjEJUkzCOL/bgnuGeWwoikVf8vs6lhmbp
         JBSA==
X-Gm-Message-State: AOAM531CqOv7VLScrEMcRKnvXX9m0Mt3C+9djAE3uGWIiKt5ztQTiyak
        fCPjQboHFrKbhLZHD9P0JlM=
X-Google-Smtp-Source: ABdhPJy7oySx6Nj4WVEfNjF8PdI7lkVVxnUATTnrugZXU8mA7lwB1VOawNi6l0kt6ly/i+cwTMnQVA==
X-Received: by 2002:a5d:4d0e:0:b0:1ed:bbed:fbe4 with SMTP id z14-20020a5d4d0e000000b001edbbedfbe4mr18852558wrt.198.1646126181833;
        Tue, 01 Mar 2022 01:16:21 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id w26-20020a7bc11a000000b0037bf8fa8c02sm1851512wmi.13.2022.03.01.01.16.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 01 Mar 2022 01:16:21 -0800 (PST)
Date:   Tue, 1 Mar 2022 09:16:19 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/2] sfc: default config to 1 channel/core in
 local NUMA node only
Message-ID: <20220301091619.6g6yqfbbxnow4hkq@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
References: <20220228132254.25787-1-ihuguet@redhat.com>
 <20220228132254.25787-2-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220228132254.25787-2-ihuguet@redhat.com>
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

On Mon, Feb 28, 2022 at 02:22:53PM +0100, Íñigo Huguet wrote:
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
> 2.34.1

-- 
Martin Habets <habetsm.xilinx@gmail.com>
