Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF447535931
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 08:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241586AbiE0GR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 02:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiE0GR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 02:17:26 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02E466C9E
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 23:17:24 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id k30so4564052wrd.5
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 23:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=q2KeCuIGcsxk/+Ng3HBNJ/oPbL39upRVX8ldKgyy+3c=;
        b=d/mwa+psxF6e4ZGiYVpCCUfoKFGrVBnSJZQ3tUVACNqewlTKNstQjUMUI7IgYUz5WY
         /57jf2EEiQLONdcQl1tRitzFcoZWgZ1DLGcLWENCsfOTueeBamBx1ogbnr/c0kYfqgse
         Z4m8BOXX5kFO0tUoRNcGjB9v5nyLlZTbhvcXtvapZEcJvmBO9nkQFzia9hLz3ncc3vfb
         Idd11UIYizwrFovD86qjQbly4SpmL+2EdijdhnRflz6nmINdA22SBASfOCf4OdBq+bSn
         Fd+Oypz0/b6+GVwpG8dAnMDIzdauhlFvtZwMhi1CnBBaHfsdCvSFM3w0APvVkzJnNUba
         UJIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=q2KeCuIGcsxk/+Ng3HBNJ/oPbL39upRVX8ldKgyy+3c=;
        b=oFPN0KAmc/lN/0Or062iwK+Agtkg7ozBM8LILUFNfxv3f5UMkeARrOz6mObNmtsJM/
         wCwYnTpsqKT+/u/AU9Ig7X55BJXBZVtncNRIP01mnolhS6p4Ds4kIJ0nz9CeZ5di0Vee
         7Attpp766O4Nke1te+aoyyYpVJrsMkZofOwoKjU+kM3dv7LR6T5dNDYntZjrdNKCOGY9
         S4WjqFxjuLS9qZkq45eaO3PSvoG8TYXeFUneYNp8alzWbBZ2jiRH/On5wjvrvdlRuCar
         fLY65STJlFatbsEDVSfLSKfBqtJkFULMqZueUmJdUAV7INKGD0bvQGCMrQjBGAdPGPLa
         3zpg==
X-Gm-Message-State: AOAM532J5g7YhoJIxDc+gHoT2KulQdpmN9FOp1/U9orCRn1xObCeI+Wp
        Dg7EEWH5wQreFwvimg67OKByOzDs4Ck=
X-Google-Smtp-Source: ABdhPJwU8j++dmxGvyGnV1yqdTpo9jPQfJDLouRNoUKwDQlPApaPJ5g9iRpfOJYlHMcd5qARq0R56g==
X-Received: by 2002:a05:6000:1f17:b0:20e:6626:5ac7 with SMTP id bv23-20020a0560001f1700b0020e66265ac7mr33506563wrb.489.1653632243276;
        Thu, 26 May 2022 23:17:23 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id o12-20020a05600c4fcc00b003942a244f2esm1273627wmq.7.2022.05.26.23.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 23:17:22 -0700 (PDT)
Date:   Fri, 27 May 2022 07:17:20 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] sfc: simplify mtd partitions list
 handling
Message-ID: <YpBs8GBY2zGLNsTW@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
References: <20220524062243.9206-1-ihuguet@redhat.com>
 <20220524062243.9206-2-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220524062243.9206-2-ihuguet@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 08:22:42AM +0200, Íñigo Huguet wrote:
> efx_mtd_partitions are embedded inside efx_mcdi_mtd_partition structs.
> They contain a list entry that is appended to efx->mtd_list, which is
> traversed to perform add/remove/rename/etc operations over all
> efx_mtd_partitions.
> 
> However, almost all operations done on a efx_mtd_partition asume that it
> is actually embedded inside an efx_mcdi_mtd_partition, and the
> deallocation asume that the first member of the list is located at the
> beginning of the allocated memory.
> 
> Given all that asumptions, the possibility of having an
> efx_mtd_partition not embedded in an efx_mcdi_efx_partition doesn't
> exist. Neither it does the possibility of being in a memory position
> other the one allocated for the efx_mcdi_mtd_partition array. Also, they
> never need to be reordered.
> 
> Given all that, it is better to get rid of the list and use directly the
> efx_mcdi_mtd_partition array. This shows more clearly how they lay
> in memory, list traversal is more obvious and it save a small amount
> of memory on the list nodes.
> 
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/ef10.c       | 12 ++++++--
>  drivers/net/ethernet/sfc/efx.h        |  4 +--
>  drivers/net/ethernet/sfc/efx_common.c |  3 --
>  drivers/net/ethernet/sfc/mtd.c        | 42 ++++++++++-----------------
>  drivers/net/ethernet/sfc/net_driver.h |  9 ++++--
>  5 files changed, 33 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> index 186cb28c03bd..89f8c1e63ec0 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -3584,10 +3584,16 @@ static int efx_ef10_mtd_probe(struct efx_nic *efx)
>  		return 0;
>  	}
>  
> -	rc = efx_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts));
> -fail:
> +	rc = efx_mtd_add(efx, parts, n_parts);
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
> diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
> index c05a83da9e44..2ab9ba691b0d 100644
> --- a/drivers/net/ethernet/sfc/efx.h
> +++ b/drivers/net/ethernet/sfc/efx.h
> @@ -181,8 +181,8 @@ void efx_update_sw_stats(struct efx_nic *efx, u64 *stats);
>  
>  /* MTD */
>  #ifdef CONFIG_SFC_MTD
> -int efx_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
> -		size_t n_parts, size_t sizeof_part);
> +int efx_mtd_add(struct efx_nic *efx, struct efx_mcdi_mtd_partition *parts,
> +		size_t n_parts);
>  static inline int efx_mtd_probe(struct efx_nic *efx)
>  {
>  	return efx->type->mtd_probe(efx);
> diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
> index f6577e74d6e6..8802790403e9 100644
> --- a/drivers/net/ethernet/sfc/efx_common.c
> +++ b/drivers/net/ethernet/sfc/efx_common.c
> @@ -987,9 +987,6 @@ int efx_init_struct(struct efx_nic *efx,
>  	INIT_LIST_HEAD(&efx->node);
>  	INIT_LIST_HEAD(&efx->secondary_list);
>  	spin_lock_init(&efx->biu_lock);
> -#ifdef CONFIG_SFC_MTD
> -	INIT_LIST_HEAD(&efx->mtd_list);
> -#endif
>  	INIT_WORK(&efx->reset_work, efx_reset_work);
>  	INIT_DELAYED_WORK(&efx->monitor_work, efx_monitor);
>  	efx_selftest_async_init(efx);
> diff --git a/drivers/net/ethernet/sfc/mtd.c b/drivers/net/ethernet/sfc/mtd.c
> index 273c08e5455f..4d06e8a9a729 100644
> --- a/drivers/net/ethernet/sfc/mtd.c
> +++ b/drivers/net/ethernet/sfc/mtd.c
> @@ -12,6 +12,7 @@
>  
>  #include "net_driver.h"
>  #include "efx.h"
> +#include "mcdi.h"
>  
>  #define to_efx_mtd_partition(mtd)				\
>  	container_of(mtd, struct efx_mtd_partition, mtd)
> @@ -48,18 +49,16 @@ static void efx_mtd_remove_partition(struct efx_mtd_partition *part)
>  		ssleep(1);
>  	}
>  	WARN_ON(rc);
> -	list_del(&part->node);
>  }
>  
> -int efx_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
> -		size_t n_parts, size_t sizeof_part)
> +int efx_mtd_add(struct efx_nic *efx, struct efx_mcdi_mtd_partition *parts,
> +		size_t n_parts)
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
> @@ -78,47 +77,38 @@ int efx_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
>  
>  		if (mtd_device_register(&part->mtd, NULL, 0))
>  			goto fail;
> -
> -		/* Add to list in order - efx_mtd_remove() depends on this */
> -		list_add_tail(&part->node, &efx->mtd_list);
>  	}
>  
>  	return 0;
>  
>  fail:
> -	while (i--) {
> -		part = (struct efx_mtd_partition *)((char *)parts +
> -						    i * sizeof_part);
> -		efx_mtd_remove_partition(part);
> -	}
> +	while (i--)
> +		efx_mtd_remove_partition(&parts[i].common);
> +
>  	/* Failure is unlikely here, but probably means we're out of memory */
>  	return -ENOMEM;
>  }
>  
>  void efx_mtd_remove(struct efx_nic *efx)
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
> +		efx_mtd_remove_partition(&efx->mcdi_mtd_parts[i].common);
>  
> -	list_for_each_entry_safe(part, next, &efx->mtd_list, node)
> -		efx_mtd_remove_partition(part);
> -
> -	kfree(parts);
> +	kfree(efx->mcdi_mtd_parts);
> +	efx->mcdi_mtd_parts = NULL;
> +	efx->n_mcdi_mtd_parts = 0;
>  }
>  
>  void efx_mtd_rename(struct efx_nic *efx)
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
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> index 318db906a154..5d20b25b0e82 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -107,6 +107,8 @@ struct hwtstamp_config;
>  
>  struct efx_self_tests;
>  
> +struct efx_mcdi_mtd_partition;
> +
>  /**
>   * struct efx_buffer - A general-purpose DMA buffer
>   * @addr: host base address of the buffer
> @@ -865,7 +867,8 @@ enum efx_xdp_tx_queues_mode {
>   * @irq_zero_count: Number of legacy IRQs seen with queue flags == 0
>   * @irq_level: IRQ level/index for IRQs not triggered by an event queue
>   * @selftest_work: Work item for asynchronous self-test
> - * @mtd_list: List of MTDs attached to the NIC
> + * @mcdi_mtd_parts: Array of MTDs attached to the NIC
> + * @n_mcdi_mtd_parts: Number of MTDs attached to the NIC
>   * @nic_data: Hardware dependent state
>   * @mcdi: Management-Controller-to-Driver Interface state
>   * @mac_lock: MAC access lock. Protects @port_enabled, @phy_mode,
> @@ -1033,7 +1036,8 @@ struct efx_nic {
>  	struct delayed_work selftest_work;
>  
>  #ifdef CONFIG_SFC_MTD
> -	struct list_head mtd_list;
> +	struct efx_mcdi_mtd_partition *mcdi_mtd_parts;
> +	unsigned int n_mcdi_mtd_parts;
>  #endif
>  
>  	void *nic_data;
> @@ -1134,7 +1138,6 @@ static inline unsigned int efx_port_num(struct efx_nic *efx)
>  }
>  
>  struct efx_mtd_partition {
> -	struct list_head node;
>  	struct mtd_info mtd;
>  	const char *dev_type_name;
>  	const char *type_name;
> -- 
> 2.34.1
