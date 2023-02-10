Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A7C691A43
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbjBJIrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjBJIrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:47:35 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4C711E89;
        Fri, 10 Feb 2023 00:47:33 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id o15so987427wrc.9;
        Fri, 10 Feb 2023 00:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ON3JpFvEQpZrDPh9ogUPzVcRK1qP2zBrAZtHUBonalY=;
        b=b4nHFjiv+QGgXxVX80p/ss2bG6SLazZwBkLJLcovTOzkWR2xVgTf0vBJEmIqk/+7Ih
         P2EnG7buhG0EjKBfK1P7ljMEqwOib6pPJXFkvmsnXgWM7rTJ8jr1owWnjPn2JEddx7N+
         Ez7xqnLLkIRa20HiXBwUU1YXxNxdOKLFZYYuaqvxEt4WENnqZuQJ9GbLG6C9Wac/sOLG
         uZnnKP9xz9UlZdEkqno9PQGjx+ULmQBTweY//LpRMSPlGFrDtQs6xso34clL5Volo5au
         P1/ki1I+9AoDMekIVoJb7yeBjaVaDR0pj0XiYQtCgIX7cZxveqWNXBVigy80gJhzA3Ee
         hrgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ON3JpFvEQpZrDPh9ogUPzVcRK1qP2zBrAZtHUBonalY=;
        b=yZDvPoaX9pw037/RASUkw/EYeFKLITMCmGy2MaOrQINV9GHYTJzCnTWAjHShIuRwbT
         /DwvfDVmJYlVL1dBQYPoQMvR13+Jrfn2MK9mdFZvMlrs4GRHYiuIzEVkH0zvJgh3M+vi
         EfOvkYUb+pzXNxSuKQM6bew8QpPnQYSKdA4vkkB/KOsh44x8MdEa7J0SGxXzb30zHN24
         VhcmQfzPnQnC+nZOIzxWrIarH4aVpdQgwFBuU5YwHzkftX5CUEUGQad0ecG96+eAil/G
         jurKnZUHA8ahCxReu4gqYfSNXwBVv+XjIscwG0KPw+B838K/+mFL+rZaHmGGEfxdwLWc
         /myg==
X-Gm-Message-State: AO0yUKUM0CvLkjGpFOHyn2mApGrvVpLUMCGozCNyWUa+F69CegJXhjwG
        JuL+lrJnmGkzXpoordVUwNs=
X-Google-Smtp-Source: AK7set9rusmvDWc7AEz5wJB1LTPXJvyQNmLP4+C5TccK4V8b2ClK52GIews/QN02ByB5R9x6ptznfg==
X-Received: by 2002:adf:f24d:0:b0:2bf:c31d:e477 with SMTP id b13-20020adff24d000000b002bfc31de477mr4573977wrp.33.1676018852016;
        Fri, 10 Feb 2023 00:47:32 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id j7-20020a5d4487000000b002c3de83be0csm3214059wrq.87.2023.02.10.00.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 00:47:31 -0800 (PST)
Date:   Fri, 10 Feb 2023 08:47:29 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
Subject: Re: [PATCH v6 net-next 4/8] sfc: add mport lookup based on driver's
 mport data
Message-ID: <Y+YEoaSDGUeKKysD@gmail.com>
Mail-Followup-To: alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
 <20230208142519.31192-5-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208142519.31192-5-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 02:25:15PM +0000, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Obtaining mport id is based on asking the firmware about it. This is
> still needed for mport initialization itself, but once the mport data is
> now kept by the driver, further mport id request can be satisfied
> internally without firmware interaction.
> 
> Previous function is just modified in name making clear the firmware
> interaction. The new function uses the old name and looks for the data
> in the mport data structure.
> 
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/ef100_nic.c |  4 ++--
>  drivers/net/ethernet/sfc/ef100_rep.c |  5 +----
>  drivers/net/ethernet/sfc/mae.c       | 27 ++++++++++++++++++++++++++-
>  drivers/net/ethernet/sfc/mae.h       |  2 ++
>  4 files changed, 31 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> index 07e7dca0e4f2..aa11f0925e27 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -736,7 +736,7 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
>  	/* Construct mport selector for "physical network port" */
>  	efx_mae_mport_wire(efx, &selector);
>  	/* Look up actual mport ID */
> -	rc = efx_mae_lookup_mport(efx, selector, &id);
> +	rc = efx_mae_fw_lookup_mport(efx, selector, &id);
>  	if (rc)
>  		return rc;
>  	/* The ID should always fit in 16 bits, because that's how wide the
> @@ -751,7 +751,7 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
>  	/* Construct mport selector for "calling PF" */
>  	efx_mae_mport_uplink(efx, &selector);
>  	/* Look up actual mport ID */
> -	rc = efx_mae_lookup_mport(efx, selector, &id);
> +	rc = efx_mae_fw_lookup_mport(efx, selector, &id);
>  	if (rc)
>  		return rc;
>  	if (id >> 16)
> diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
> index ebe7b1275713..9cd1a3ac67e0 100644
> --- a/drivers/net/ethernet/sfc/ef100_rep.c
> +++ b/drivers/net/ethernet/sfc/ef100_rep.c
> @@ -243,14 +243,11 @@ static struct efx_rep *efx_ef100_rep_create_netdev(struct efx_nic *efx,
>  static int efx_ef100_configure_rep(struct efx_rep *efv)
>  {
>  	struct efx_nic *efx = efv->parent;
> -	u32 selector;
>  	int rc;
>  
>  	efv->rx_pring_size = EFX_REP_DEFAULT_PSEUDO_RING_SIZE;
> -	/* Construct mport selector for corresponding VF */
> -	efx_mae_mport_vf(efx, efv->idx, &selector);
>  	/* Look up actual mport ID */
> -	rc = efx_mae_lookup_mport(efx, selector, &efv->mport);
> +	rc = efx_mae_lookup_mport(efx, efv->idx, &efv->mport);
>  	if (rc)
>  		return rc;
>  	pci_dbg(efx->pci_dev, "VF %u has mport ID %#x\n", efv->idx, efv->mport);
> diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
> index 725a3ab31087..6321fd393fc3 100644
> --- a/drivers/net/ethernet/sfc/mae.c
> +++ b/drivers/net/ethernet/sfc/mae.c
> @@ -97,7 +97,7 @@ void efx_mae_mport_mport(struct efx_nic *efx __always_unused, u32 mport_id, u32
>  }
>  
>  /* id is really only 24 bits wide */
> -int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id)
> +int efx_mae_fw_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id)
>  {
>  	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_MPORT_LOOKUP_OUT_LEN);
>  	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_MPORT_LOOKUP_IN_LEN);
> @@ -488,6 +488,31 @@ int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
>  	return 0;
>  }
>  
> +int efx_mae_lookup_mport(struct efx_nic *efx, u32 vf_idx, u32 *id)
> +{
> +	struct ef100_nic_data *nic_data = efx->nic_data;
> +	struct efx_mae *mae = efx->mae;
> +	struct rhashtable_iter walk;
> +	struct mae_mport_desc *m;
> +	int rc = -ENOENT;
> +
> +	rhashtable_walk_enter(&mae->mports_ht, &walk);
> +	rhashtable_walk_start(&walk);
> +	while ((m = rhashtable_walk_next(&walk)) != NULL) {
> +		if (m->mport_type == MAE_MPORT_DESC_MPORT_TYPE_VNIC &&
> +		    m->interface_idx == nic_data->local_mae_intf &&
> +		    m->pf_idx == 0 &&
> +		    m->vf_idx == vf_idx) {
> +			*id = m->mport_id;
> +			rc = 0;
> +			break;
> +		}
> +	}
> +	rhashtable_walk_stop(&walk);
> +	rhashtable_walk_exit(&walk);
> +	return rc;
> +}
> +
>  static bool efx_mae_asl_id(u32 id)
>  {
>  	return !!(id & BIT(31));
> diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
> index daa29d2cde96..b9bf86c47cda 100644
> --- a/drivers/net/ethernet/sfc/mae.h
> +++ b/drivers/net/ethernet/sfc/mae.h
> @@ -96,4 +96,6 @@ int efx_mae_delete_rule(struct efx_nic *efx, u32 id);
>  int efx_init_mae(struct efx_nic *efx);
>  void efx_fini_mae(struct efx_nic *efx);
>  void efx_mae_remove_mport(void *desc, void *arg);
> +int efx_mae_fw_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id);
> +int efx_mae_lookup_mport(struct efx_nic *efx, u32 vf, u32 *id);
>  #endif /* EF100_MAE_H */
> -- 
> 2.17.1
