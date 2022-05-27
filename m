Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A66C535935
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 08:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241461AbiE0GSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 02:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238227AbiE0GSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 02:18:49 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5115466F88
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 23:18:47 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id t6so4571781wra.4
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 23:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Epx0vPMBUNe6EmGD6VH0wMiaKYKXuXFOcLUdNnH5/fA=;
        b=oLZpqQSLNWMkjLvxDVGMi87+AvOpABWmQoiFiuR5x3liWz+JXRzDv/ymOM8uFqSlz5
         O+/ycjUmRobEsin4lJWy36itSMVlmWXDItbSX4Z6BL/G950eQ3xbDmEjfSn/7KYfvNvK
         Ne8IH+MKe2ohqZVv//c46IFn3/NKGk9OnhgUw6iJJQxdcVDJb3Av3f2181o2RbddaTzC
         1LV805R3WooLDTDqZyA7QqA1s38zHGg8ThHHxWpMNrLAkvTSaGNSif2KtO6phOHWVlM5
         QPn0UB1XRrs1Vvz2uo1zdqENlPQpAjcgX5MF/WoOTEIu5kdLDbgfgE2MwmQB1jG9eaBa
         Tn8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=Epx0vPMBUNe6EmGD6VH0wMiaKYKXuXFOcLUdNnH5/fA=;
        b=mJimZVNRD3umunv5Zfp3DK0rjYjh1+Im9OXUmjeum2MfRokuaDwyFS22GAAYhTzetn
         u9jsTTuiIQMdwnK6rKrTbUA4gk8dpSrHPHmyj7Tx3K3hVKvjjmBAWt9zZlIrCf2Ldatn
         y+H9ktqgCoBvc4bSejaeA5GmdymTvuq+ZfoDJ5i1a3nQ6E29EuCJl+bOvYMwoB3xRN8T
         wyitdoSjUKpoR7GVPbz2fKT5IFOrmftRpR6lMUMjKUpO6gMpRQJ+7Zyll278PU9NHKMy
         zFT5EmT/hOTjTQAr5Bi/TXGLhQFzRGy+OUBeA9x0sZrPJhNURuT8hZqenvzgfvmfFIT2
         JmDg==
X-Gm-Message-State: AOAM533bZsUb1aGdjJVN9Ys938Oe1SoiNugbpNvY/M8GqNUslHSz9UPe
        3aLvMSTyqXsCANF2GP2HIyGrcM2sod8=
X-Google-Smtp-Source: ABdhPJyeRyD6YGI1Xs0ZcmUlSAwMGbx19Gzsi02YjLwcIkaXPp+x8gdoCM+bZR6HeMWmmcBuLIjzQg==
X-Received: by 2002:a5d:64ad:0:b0:20e:5947:7cbf with SMTP id m13-20020a5d64ad000000b0020e59477cbfmr34245717wrp.278.1653632325770;
        Thu, 26 May 2022 23:18:45 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id i2-20020a1c5402000000b003972dcfb614sm1173099wmb.14.2022.05.26.23.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 23:18:45 -0700 (PDT)
Date:   Fri, 27 May 2022 07:18:43 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] sfc/siena: simplify mtd partitions list
 handling
Message-ID: <YpBtQ2w+ckozpaEL@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
References: <20220524062243.9206-1-ihuguet@redhat.com>
 <20220524062243.9206-3-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220524062243.9206-3-ihuguet@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 08:22:43AM +0200, Íñigo Huguet wrote:
> Like in previous patch, get rid of efx->mtd_list and use the allocated
> array of efx_mcdi_mtd_partition instead, also in siena.
> 
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/siena/efx.h        |  4 +-
>  drivers/net/ethernet/sfc/siena/efx_common.c |  3 --
>  drivers/net/ethernet/sfc/siena/mtd.c        | 42 ++++++++-------------
>  drivers/net/ethernet/sfc/siena/net_driver.h |  9 +++--
>  drivers/net/ethernet/sfc/siena/siena.c      | 12 ++++--
>  5 files changed, 33 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/siena/efx.h b/drivers/net/ethernet/sfc/siena/efx.h
> index 27d1d3f19cae..30ef11dfa7a1 100644
> --- a/drivers/net/ethernet/sfc/siena/efx.h
> +++ b/drivers/net/ethernet/sfc/siena/efx.h
> @@ -163,8 +163,8 @@ void efx_siena_update_sw_stats(struct efx_nic *efx, u64 *stats);
>  
>  /* MTD */
>  #ifdef CONFIG_SFC_SIENA_MTD
> -int efx_siena_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
> -		      size_t n_parts, size_t sizeof_part);
> +int efx_siena_mtd_add(struct efx_nic *efx, struct efx_mcdi_mtd_partition *parts,
> +		      size_t n_parts);
>  static inline int efx_mtd_probe(struct efx_nic *efx)
>  {
>  	return efx->type->mtd_probe(efx);
> diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
> index 954daf464abb..dbf48d682684 100644
> --- a/drivers/net/ethernet/sfc/siena/efx_common.c
> +++ b/drivers/net/ethernet/sfc/siena/efx_common.c
> @@ -997,9 +997,6 @@ int efx_siena_init_struct(struct efx_nic *efx,
>  	INIT_LIST_HEAD(&efx->node);
>  	INIT_LIST_HEAD(&efx->secondary_list);
>  	spin_lock_init(&efx->biu_lock);
> -#ifdef CONFIG_SFC_SIENA_MTD
> -	INIT_LIST_HEAD(&efx->mtd_list);
> -#endif
>  	INIT_WORK(&efx->reset_work, efx_reset_work);
>  	INIT_DELAYED_WORK(&efx->monitor_work, efx_monitor);
>  	efx_siena_selftest_async_init(efx);
> diff --git a/drivers/net/ethernet/sfc/siena/mtd.c b/drivers/net/ethernet/sfc/siena/mtd.c
> index 12a624247f44..d6700822c6fa 100644
> --- a/drivers/net/ethernet/sfc/siena/mtd.c
> +++ b/drivers/net/ethernet/sfc/siena/mtd.c
> @@ -12,6 +12,7 @@
>  
>  #include "net_driver.h"
>  #include "efx.h"
> +#include "mcdi.h"
>  
>  #define to_efx_mtd_partition(mtd)				\
>  	container_of(mtd, struct efx_mtd_partition, mtd)
> @@ -48,18 +49,16 @@ static void efx_siena_mtd_remove_partition(struct efx_mtd_partition *part)
>  		ssleep(1);
>  	}
>  	WARN_ON(rc);
> -	list_del(&part->node);
>  }
>  
> -int efx_siena_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
> -		      size_t n_parts, size_t sizeof_part)
> +int efx_siena_mtd_add(struct efx_nic *efx, struct efx_mcdi_mtd_partition *parts,
> +		      size_t n_parts)
>  {
>  	struct efx_mtd_partition *part;
>  	size_t i;
>  
>  	for (i = 0; i < n_parts; i++) {
> -		part = (struct efx_mtd_partition *)((char *)parts +
> -						    i * sizeof_part);
> +		part = &parts[i].common;
>  
>  		part->mtd.writesize = 1;
>  
> @@ -78,47 +77,38 @@ int efx_siena_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
>  
>  		if (mtd_device_register(&part->mtd, NULL, 0))
>  			goto fail;
> -
> -		/* Add to list in order - efx_siena_mtd_remove() depends on this */
> -		list_add_tail(&part->node, &efx->mtd_list);
>  	}
>  
>  	return 0;
>  
>  fail:
> -	while (i--) {
> -		part = (struct efx_mtd_partition *)((char *)parts +
> -						    i * sizeof_part);
> -		efx_siena_mtd_remove_partition(part);
> -	}
> +	while (i--)
> +		efx_siena_mtd_remove_partition(&parts[i].common);
> +
>  	/* Failure is unlikely here, but probably means we're out of memory */
>  	return -ENOMEM;
>  }
>  
>  void efx_siena_mtd_remove(struct efx_nic *efx)
>  {
> -	struct efx_mtd_partition *parts, *part, *next;
> +	int i;
>  
>  	WARN_ON(efx_dev_registered(efx));
>  
> -	if (list_empty(&efx->mtd_list))
> -		return;
> -
> -	parts = list_first_entry(&efx->mtd_list, struct efx_mtd_partition,
> -				 node);
> +	for (i = 0; i < efx->n_mcdi_mtd_parts; i++)
> +		efx_siena_mtd_remove_partition(&efx->mcdi_mtd_parts[i].common);
>  
> -	list_for_each_entry_safe(part, next, &efx->mtd_list, node)
> -		efx_siena_mtd_remove_partition(part);
> -
> -	kfree(parts);
> +	kfree(efx->mcdi_mtd_parts);
> +	efx->mcdi_mtd_parts = NULL;
> +	efx->n_mcdi_mtd_parts = 0;
>  }
>  
>  void efx_siena_mtd_rename(struct efx_nic *efx)
>  {
> -	struct efx_mtd_partition *part;
> +	int i;
>  
>  	ASSERT_RTNL();
>  
> -	list_for_each_entry(part, &efx->mtd_list, node)
> -		efx->type->mtd_rename(part);
> +	for (i = 0; i < efx->n_mcdi_mtd_parts; i++)
> +		efx->type->mtd_rename(&efx->mcdi_mtd_parts[i].common);
>  }
> diff --git a/drivers/net/ethernet/sfc/siena/net_driver.h b/drivers/net/ethernet/sfc/siena/net_driver.h
> index a8f6c3699c8b..4c614f079359 100644
> --- a/drivers/net/ethernet/sfc/siena/net_driver.h
> +++ b/drivers/net/ethernet/sfc/siena/net_driver.h
> @@ -107,6 +107,8 @@ struct hwtstamp_config;
>  
>  struct efx_self_tests;
>  
> +struct efx_mcdi_mtd_partition;
> +
>  /**
>   * struct efx_buffer - A general-purpose DMA buffer
>   * @addr: host base address of the buffer
> @@ -864,7 +866,8 @@ enum efx_xdp_tx_queues_mode {
>   * @irq_zero_count: Number of legacy IRQs seen with queue flags == 0
>   * @irq_level: IRQ level/index for IRQs not triggered by an event queue
>   * @selftest_work: Work item for asynchronous self-test
> - * @mtd_list: List of MTDs attached to the NIC
> + * @mcdi_mtd_parts: Array of MTDs attached to the NIC
> + * @n_mcdi_mtd_parts: Number of MTDs attached to the NIC
>   * @nic_data: Hardware dependent state
>   * @mcdi: Management-Controller-to-Driver Interface state
>   * @mac_lock: MAC access lock. Protects @port_enabled, @phy_mode,
> @@ -1032,7 +1035,8 @@ struct efx_nic {
>  	struct delayed_work selftest_work;
>  
>  #ifdef CONFIG_SFC_SIENA_MTD
> -	struct list_head mtd_list;
> +	struct efx_mcdi_mtd_partition *mcdi_mtd_parts;
> +	unsigned int n_mcdi_mtd_parts;
>  #endif
>  
>  	void *nic_data;
> @@ -1133,7 +1137,6 @@ static inline unsigned int efx_port_num(struct efx_nic *efx)
>  }
>  
>  struct efx_mtd_partition {
> -	struct list_head node;
>  	struct mtd_info mtd;
>  	const char *dev_type_name;
>  	const char *type_name;
> diff --git a/drivers/net/ethernet/sfc/siena/siena.c b/drivers/net/ethernet/sfc/siena/siena.c
> index a44c8fa25748..c9431955792e 100644
> --- a/drivers/net/ethernet/sfc/siena/siena.c
> +++ b/drivers/net/ethernet/sfc/siena/siena.c
> @@ -947,10 +947,16 @@ static int siena_mtd_probe(struct efx_nic *efx)
>  	if (rc)
>  		goto fail;
>  
> -	rc = efx_siena_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts));
> -fail:
> +	rc = efx_siena_mtd_add(efx, parts, n_parts);
>  	if (rc)
> -		kfree(parts);
> +		goto fail;
> +	efx->mcdi_mtd_parts = parts;
> +	efx->n_mcdi_mtd_parts = n_parts;
> +
> +	return 0;
> +
> +fail:
> +	kfree(parts);
>  	return rc;
>  }
>  
> -- 
> 2.34.1
