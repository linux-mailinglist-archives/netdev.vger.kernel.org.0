Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886594BC8BE
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 14:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242357AbiBSNwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 08:52:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242348AbiBSNwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 08:52:09 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBA526570
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 05:51:48 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id q198-20020a1ca7cf000000b0037bb52545c6so10554886wme.1
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 05:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=D31wVyCjpSrSc8cuTaWTq1LYvGaNDuDar+aTo7wQwzU=;
        b=lYBT7FwGVlrkuw4OIr8OPfUiBiEqiyORQJ+QEc0bC2WNHeodBoixBVKkdQGLruxVh2
         yBa8sFwyazPIZNqZmnbDWaGtW4GGcAX3RoH/+mqdSKcIsdRlf5ltBSkIsigmkBqkkxI8
         ndwKTJR/aEq2LmzLfqcTqLY+3+PWlM1Jn0JAFxu5j1i/3TPqeKcqCB2KIJISmL6aJIdc
         8q+N1WpdRgZtdreLxWk6n9VsphNm2eci1vdMaIYkNEBmebmkmj+stJ9/KhbukDitgyQD
         5Nc7zkhRuZAIZqiQelGqK+R0tVGTLdmeOEXombO00WCvfKDY3qB02et2QW/TBvlVza5J
         PF9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=D31wVyCjpSrSc8cuTaWTq1LYvGaNDuDar+aTo7wQwzU=;
        b=eHe4W/Ek8t0qmXMDnTyMn9hDJaq0b804JwlilSuRtWZop8FqGH/dcVeoDRhL4MxQBs
         ue4ehi9ZlqyhjYwbci2BPL0dVR6cp76IFhh5ZIwl7du9E6wsZIdTRKPiloBBr7XtK/cY
         yP/5WGJk3DAZ09jZXT0X8Ofxo0aZxnrmTnntQdRs8XdheAFB3RuygpFYTuVdZ+6L+LFj
         Zz/RE75inCtVSQ91THy6ZAqXDVb+YYsCfLTbdpy1any9oM71oL5e+PYCWm3PHQSqIaFI
         3xQeh547tBi6PWlT9gGt/Lh5Hzsjt8C9drBsJvXhI+G7AmTEeM364jD7idm/jSTgYw7g
         j70w==
X-Gm-Message-State: AOAM5301RCc0oS5VO/43SkTZsuId4wKqBP3yf8lsEaCQWnWb/Akp+fy8
        P7cZ5t3N0C/dJe9yRi0M/b8=
X-Google-Smtp-Source: ABdhPJynzUS1KxRkJy9NOHJK2D+Zs65FI8f6HF/CTcfwJ1LS2Esj68KR1BhfTucK3Qu4B05oC/Ax8Q==
X-Received: by 2002:a05:600c:3b25:b0:37b:c6f3:74b4 with SMTP id m37-20020a05600c3b2500b0037bc6f374b4mr15105478wms.56.1645278707270;
        Sat, 19 Feb 2022 05:51:47 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id f10-20020a05600c154a00b0037bbbc15ca7sm3429914wmg.36.2022.02.19.05.51.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 19 Feb 2022 05:51:46 -0800 (PST)
Date:   Sat, 19 Feb 2022 13:51:44 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next resend 2/2] sfc: set affinity hints in local
 NUMA node only
Message-ID: <20220219135144.7pxbdrglbfx52mem@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
References: <20220128151922.1016841-1-ihuguet@redhat.com>
 <20220216094139.15989-1-ihuguet@redhat.com>
 <20220216094139.15989-3-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220216094139.15989-3-ihuguet@redhat.com>
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

On Wed, Feb 16, 2022 at 10:41:39AM +0100, Íñigo Huguet wrote:
> Affinity hints were being set to CPUs in local NUMA node first, and then
> in other CPUs. This was creating 2 unintended issues:
> 1. Channels created to be assigned each to a different physical core
>    were assigned to hyperthreading siblings because of being in same
>    NUMA node.
>    Since the patch previous to this one, this did not longer happen
>    with default rss_cpus modparam because less channels are created.
> 2. XDP channels could be assigned to CPUs in different NUMA nodes,
>    decreasing performance too much (to less than half in some of my
>    tests).
> 
> This patch sets the affinity hints spreading the channels only in local
> NUMA node's CPUs. A fallback for the case that no CPU in local NUMA node
> is online has been added too.
> 
> Example of CPUs being assigned in a non optimal way before this and the
> previous patch (note: in this system, xdp-8 to xdp-15 are created
> because num_possible_cpus == 64, but num_present_cpus == 32 so they're
> never used):
> 
> $ lscpu | grep -i numa
> NUMA node(s):                    2
> NUMA node0 CPU(s):               0-7,16-23
> NUMA node1 CPU(s):               8-15,24-31
> 
> $ grep -H . /proc/irq/*/0000:07:00.0*/../smp_affinity_list
> /proc/irq/141/0000:07:00.0-0/../smp_affinity_list:0
> /proc/irq/142/0000:07:00.0-1/../smp_affinity_list:1
> /proc/irq/143/0000:07:00.0-2/../smp_affinity_list:2
> /proc/irq/144/0000:07:00.0-3/../smp_affinity_list:3
> /proc/irq/145/0000:07:00.0-4/../smp_affinity_list:4
> /proc/irq/146/0000:07:00.0-5/../smp_affinity_list:5
> /proc/irq/147/0000:07:00.0-6/../smp_affinity_list:6
> /proc/irq/148/0000:07:00.0-7/../smp_affinity_list:7
> /proc/irq/149/0000:07:00.0-8/../smp_affinity_list:16
> /proc/irq/150/0000:07:00.0-9/../smp_affinity_list:17
> /proc/irq/151/0000:07:00.0-10/../smp_affinity_list:18
> /proc/irq/152/0000:07:00.0-11/../smp_affinity_list:19
> /proc/irq/153/0000:07:00.0-12/../smp_affinity_list:20
> /proc/irq/154/0000:07:00.0-13/../smp_affinity_list:21
> /proc/irq/155/0000:07:00.0-14/../smp_affinity_list:22
> /proc/irq/156/0000:07:00.0-15/../smp_affinity_list:23
> /proc/irq/157/0000:07:00.0-xdp-0/../smp_affinity_list:8
> /proc/irq/158/0000:07:00.0-xdp-1/../smp_affinity_list:9
> /proc/irq/159/0000:07:00.0-xdp-2/../smp_affinity_list:10
> /proc/irq/160/0000:07:00.0-xdp-3/../smp_affinity_list:11
> /proc/irq/161/0000:07:00.0-xdp-4/../smp_affinity_list:12
> /proc/irq/162/0000:07:00.0-xdp-5/../smp_affinity_list:13
> /proc/irq/163/0000:07:00.0-xdp-6/../smp_affinity_list:14
> /proc/irq/164/0000:07:00.0-xdp-7/../smp_affinity_list:15
> /proc/irq/165/0000:07:00.0-xdp-8/../smp_affinity_list:24
> /proc/irq/166/0000:07:00.0-xdp-9/../smp_affinity_list:25
> /proc/irq/167/0000:07:00.0-xdp-10/../smp_affinity_list:26
> /proc/irq/168/0000:07:00.0-xdp-11/../smp_affinity_list:27
> /proc/irq/169/0000:07:00.0-xdp-12/../smp_affinity_list:28
> /proc/irq/170/0000:07:00.0-xdp-13/../smp_affinity_list:29
> /proc/irq/171/0000:07:00.0-xdp-14/../smp_affinity_list:30
> /proc/irq/172/0000:07:00.0-xdp-15/../smp_affinity_list:31
> 
> CPUs assignments after this and previous patch, so normal channels
> created only one per core in NUMA node and affinities set only to local
> NUMA node:
> 
> $ grep -H . /proc/irq/*/0000:07:00.0*/../smp_affinity_list
> /proc/irq/116/0000:07:00.0-0/../smp_affinity_list:0
> /proc/irq/117/0000:07:00.0-1/../smp_affinity_list:1
> /proc/irq/118/0000:07:00.0-2/../smp_affinity_list:2
> /proc/irq/119/0000:07:00.0-3/../smp_affinity_list:3
> /proc/irq/120/0000:07:00.0-4/../smp_affinity_list:4
> /proc/irq/121/0000:07:00.0-5/../smp_affinity_list:5
> /proc/irq/122/0000:07:00.0-6/../smp_affinity_list:6
> /proc/irq/123/0000:07:00.0-7/../smp_affinity_list:7
> /proc/irq/124/0000:07:00.0-xdp-0/../smp_affinity_list:16
> /proc/irq/125/0000:07:00.0-xdp-1/../smp_affinity_list:17
> /proc/irq/126/0000:07:00.0-xdp-2/../smp_affinity_list:18
> /proc/irq/127/0000:07:00.0-xdp-3/../smp_affinity_list:19
> /proc/irq/128/0000:07:00.0-xdp-4/../smp_affinity_list:20
> /proc/irq/129/0000:07:00.0-xdp-5/../smp_affinity_list:21
> /proc/irq/130/0000:07:00.0-xdp-6/../smp_affinity_list:22
> /proc/irq/131/0000:07:00.0-xdp-7/../smp_affinity_list:23
> /proc/irq/132/0000:07:00.0-xdp-8/../smp_affinity_list:0
> /proc/irq/133/0000:07:00.0-xdp-9/../smp_affinity_list:1
> /proc/irq/134/0000:07:00.0-xdp-10/../smp_affinity_list:2
> /proc/irq/135/0000:07:00.0-xdp-11/../smp_affinity_list:3
> /proc/irq/136/0000:07:00.0-xdp-12/../smp_affinity_list:4
> /proc/irq/137/0000:07:00.0-xdp-13/../smp_affinity_list:5
> /proc/irq/138/0000:07:00.0-xdp-14/../smp_affinity_list:6
> /proc/irq/139/0000:07:00.0-xdp-15/../smp_affinity_list:7
> 
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
>  drivers/net/ethernet/sfc/efx_channels.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> index ec6c2f231e73..ef3168fbb5a6 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -387,10 +387,18 @@ void efx_set_interrupt_affinity(struct efx_nic *efx)
>  {
>  	struct efx_channel *channel;
>  	unsigned int cpu;
> +	int numa_node = pcibus_to_node(efx->pci_dev->bus);
> +	const struct cpumask *numa_mask = cpumask_of_node(numa_node);

This violates the reverse Xmas convention.
Other than that it looks good to me.

Martin

> +	/* If no online CPUs in local node, fallback to any online CPU */
> +	if (cpumask_first_and(cpu_online_mask, numa_mask) >= nr_cpu_ids)
> +		numa_mask = cpu_online_mask;
> +
> +	cpu = -1;
>  	efx_for_each_channel(channel, efx) {
> -		cpu = cpumask_local_spread(channel->channel,
> -					   pcibus_to_node(efx->pci_dev->bus));
> +		cpu = cpumask_next_and(cpu, cpu_online_mask, numa_mask);
> +		if (cpu >= nr_cpu_ids)
> +			cpu = cpumask_first_and(cpu_online_mask, numa_mask);
>  		irq_set_affinity_hint(channel->irq, cpumask_of(cpu));
>  	}
>  }
> -- 
> 2.31.1
