Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5369E68F355
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjBHQje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjBHQjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:39:32 -0500
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699294DE1F;
        Wed,  8 Feb 2023 08:39:23 -0800 (PST)
Received: by mail-vk1-xa2c.google.com with SMTP id v189so4567127vkf.6;
        Wed, 08 Feb 2023 08:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cXy361jf8SUUyGd/0xFQMxCwUMwyU0X9mQUrtvfWoSw=;
        b=Z7MO/7p3I/IsqPS5Xl1/cLlvCaTV7UEMz0rVLO2ouAExTa0k/JTqau9WkO4kdSBK6E
         dmNaCxtkSPCxWVQfNXAOL2QFFv8AckQIwqI546n5MVbI08kQ9ibH8dXmykYB1tNDSGHX
         YqmXWNYmbpIxYOG65ZN9HvRThycr5YLv3cY3DvXY4i5BpdGH2jCWFuId1tJ1MKgh288b
         fLLSntR09KdJL6IRK2fnY332QRPCqR0rthZb4ojFqpJVKdibJRSlxG/pHA1p2cN4sCYM
         Woam8WZVL8NprXpCQDurWzaURORCbdSEexFd9vZH2SlOSrNUoEW9mECYNV0fI4bxJZOY
         QSCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXy361jf8SUUyGd/0xFQMxCwUMwyU0X9mQUrtvfWoSw=;
        b=ILxXvM0PBChjjxbDbGhFxSYdoYTM0Nhem7pFZA6pENhEriQa4DN1lYuYm63dFVwYq/
         Acg8djIvLF7E9LW72EvsdEPaRPzDzUuGM2LKG2p/j3FrONcHgH8Ev09EVRHXQHlu1Neq
         Y8ylLbvvwaRtfNN0jbtdjaSBG3Sg4KVBEebYJKpBEcBvvzASi9/ggVZg9VppGu7eU4FK
         NcWzTB5IOaPaSI460RgMTiN9v4yhrGjN/XeWBcjV44naSZKmEiv5D45d94MhGVmeNcI0
         tFFBP9rnp4t+bIMMnHuzEDuw9k3DgCTJAydkXAGNeP8LJ3cCYA5hdym+KCZXdDD9hvZq
         1hFA==
X-Gm-Message-State: AO0yUKVvgM6QcJ8eTS+yb9bAKq2iuPI7dfwo9+xV1eVvhgK/zYqIjG3T
        tKLgpQ7+00VERDeKkheuOsI=
X-Google-Smtp-Source: AK7set8916InMJzQpNA6CjxV4GVlAwIK8Cq7j9ZzRo1McpHSEby9B5j5GUyfb+abdghS0yAdCkGUfw==
X-Received: by 2002:a05:6122:912:b0:3e1:ae3a:1b82 with SMTP id j18-20020a056122091200b003e1ae3a1b82mr6428495vka.15.1675874362376;
        Wed, 08 Feb 2023 08:39:22 -0800 (PST)
Received: from localhost ([50.193.167.209])
        by smtp.gmail.com with ESMTPSA id m19-20020ac5c213000000b003e89155ef67sm1276723vkk.24.2023.02.08.08.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 08:39:21 -0800 (PST)
Date:   Wed, 8 Feb 2023 08:39:20 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Pawel Chmielewski <pawel.chmielewski@intel.com>
Cc:     Jonathan.Cameron@huawei.com, andriy.shevchenko@linux.intel.com,
        baohua@kernel.org, bristot@redhat.com, bsegall@google.com,
        davem@davemloft.net, dietmar.eggemann@arm.com, gal@nvidia.com,
        gregkh@linuxfoundation.org, hca@linux.ibm.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        jgg@nvidia.com, juri.lelli@redhat.com, kuba@kernel.org,
        leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@redhat.com,
        netdev@vger.kernel.org, peter@n8pjl.ca, peterz@infradead.org,
        rostedt@goodmis.org, saeedm@nvidia.com, tariqt@nvidia.com,
        tony.luck@intel.com, torvalds@linux-foundation.org,
        ttoukan.linux@gmail.com, vincent.guittot@linaro.org,
        vschneid@redhat.com
Subject: Re: [PATCH 1/1] ice: Change assigning method of the CPU affinity
 masks
Message-ID: <Y+PQOCHCh78aAcAm@yury-laptop>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
 <20230208153905.109912-1-pawel.chmielewski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208153905.109912-1-pawel.chmielewski@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 04:39:05PM +0100, Pawel Chmielewski wrote:
> With the introduction of sched_numa_hop_mask() and
> for_each_numa_hop_mask(), the affinity masks for queue vectors can be
> conveniently set by preferring the CPUs that are closest to the NUMA node
> of the parent PCI device.
> 
> Signed-off-by: Pawel Chmielewski <pawel.chmielewski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_base.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
> index e864634d66bc..fd3550d15c9e 100644
> --- a/drivers/net/ethernet/intel/ice/ice_base.c
> +++ b/drivers/net/ethernet/intel/ice/ice_base.c
> @@ -122,8 +122,6 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
>  	if (vsi->type == ICE_VSI_VF)
>  		goto out;
>  	/* only set affinity_mask if the CPU is online */
> -	if (cpu_online(v_idx))
> -		cpumask_set_cpu(v_idx, &q_vector->affinity_mask);
>  
>  	/* This will not be called in the driver load path because the netdev
>  	 * will not be created yet. All other cases with register the NAPI
> @@ -659,8 +657,10 @@ int ice_vsi_wait_one_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx)
>   */
>  int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
>  {
> +	cpumask_t *aff_mask, *last_aff_mask = cpu_none_mask;
>  	struct device *dev = ice_pf_to_dev(vsi->back);
> -	u16 v_idx;
> +	int numa_node = dev->numa_node;
> +	u16 v_idx, cpu = 0;
>  	int err;
>  
>  	if (vsi->q_vectors[0]) {
> @@ -674,6 +674,17 @@ int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
>  			goto err_out;
>  	}
>  
> +	v_idx = 0;
> +	for_each_numa_hop_mask(aff_mask, numa_node) {
> +		for_each_cpu_andnot(cpu, aff_mask, last_aff_mask)
> +			if (v_idx < vsi->num_q_vectors) {
> +				if (cpu_online(cpu))
> +					cpumask_set_cpu(cpu, &vsi->q_vectors[v_idx]->affinity_mask);
> +				v_idx++;
> +			}
                        
                        else
                                goto out;

> +		last_aff_mask = aff_mask;
> +	}
> +
        out:

>  	return 0;
>  
>  err_out:
> -- 
> 2.37.3

Would it make sense to increment v_idx only if matched CPU is online?
It will create a less sparse array of vectors...

Thanks,
Yury
