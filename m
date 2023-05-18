Return-Path: <netdev+bounces-3528-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7787C707B11
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 09:35:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 684DD1C2107D
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 07:35:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AECCA2A9E0;
	Thu, 18 May 2023 07:35:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B7517FC
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:35:49 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7485ED;
	Thu, 18 May 2023 00:35:47 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-965b8a969b3so180997766b.1;
        Thu, 18 May 2023 00:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684395346; x=1686987346;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+t2VM5zSrIQmysdgkkAy+ULw5MznW9V1z5XE0eBmT34=;
        b=DBzJKzxxc13E0fYFC3UXiDHm7xQuc3n82bFrzJNj+CZMEB37KcgBMg22dWLEq+wfKh
         1IkvdtBBBZwnmkZWCsrsLjA74mgjruU+qds41JUvNSdCvyfw6RCWjzmdk03oj+nssKq8
         MrObgSZTPnLb/V2cb8l6sJdqZXWTPUUgBTJa0fwDGZZ/jnGwK5HrHtJyTaeDfcMhtloS
         IK+d6m81liM0bI/ifCjoCFQcSciF6Q1UkaywMyWmgeW/1NBvU8AVXNif1N0L49/AhdLM
         BB+WLhxwDzT8HKdoY/Lz4ElQBx17Gs3JcYgqSdVXMsJq2Xka6OjEoFfOwSC1g0rXl8g7
         TQ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684395346; x=1686987346;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+t2VM5zSrIQmysdgkkAy+ULw5MznW9V1z5XE0eBmT34=;
        b=OsOB2Sexh/5rThp97IQKoJdqJeuVG+JyNbHfVLVtzVFVhVdG6z2FC9ETMQUQ0Iq/ir
         b3EoBUUjzhS/Vr7Z+VvzwOqL48wrN06++TnBLyOg+pME6Utd2nHjf8lNvYo1SuTmPe+i
         kC9xR5WnFdi3q8Pm6TMHMUwLBysahJKo101hysm0Iti2cyvaxTUiDxV7nGoIlwzGnVlt
         jr9WkxQ5LS6h/xH2e0ZGcAikB/VzXR74UIZG7o896PqivCxnomRKT3UV0inSteyGOgeL
         TpucreGhG04xIr+X8ememSG042GCT5NCGLWbHZQM+ir8T47BijylMvuKXLNxfyyBNFsH
         C47g==
X-Gm-Message-State: AC+VfDwVGWhGN0NverWRzy7K7vUq7GsggdxREK6lUz18fhzPi1HtH2H1
	n76DYUmu9T139gz8W32J/bU=
X-Google-Smtp-Source: ACHHUZ5B+7Rew0gB/k8L8jpidVWAv1LCRthNAXkLTPvn7liH9ZTrtPAZgWI1rj61oaufhgZYj2miTw==
X-Received: by 2002:a17:907:7212:b0:966:2aab:ae51 with SMTP id dr18-20020a170907721200b009662aabae51mr4354845ejc.11.1684395346046;
        Thu, 18 May 2023 00:35:46 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id j25-20020a170906095900b009584c5bcbc7sm595053ejd.49.2023.05.18.00.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 00:35:45 -0700 (PDT)
Date: Thu, 18 May 2023 08:35:43 +0100
From: Martin Habets <habetsm.xilinx@gmail.com>
To: alejandro.lucero-palau@amd.com
Cc: netdev@vger.kernel.org, linux-net-drivers@amd.com, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
	martin.habets@amd.com, edward.cree@amd.com,
	linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
Subject: Re: [PATCH net] sfc: fix devlink info error handling
Message-ID: <ZGXVT5p3SJdYQ48z@gmail.com>
Mail-Followup-To: alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
	linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, martin.habets@amd.com,
	edward.cree@amd.com, linux-doc@vger.kernel.org, corbet@lwn.net,
	jiri@nvidia.com
References: <20230518054822.20242-1-alejandro.lucero-palau@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518054822.20242-1-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 06:48:22AM +0100, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Avoid early devlink info return if errors arise with MCDI commands
> executed for getting the required info from the device. The rationale
> is some commands can fail but later ones could still give useful data.
> Moreover, some nvram partitions could not be present which needs to be
> handled as a non error.
> 
> The specific errors are reported through system messages and if any
> error appears, it will be reported generically through extack.
> 
> Fixes 14743ddd2495 (sfc: add devlink info support for ef100)
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/efx_devlink.c | 95 ++++++++++++--------------
>  1 file changed, 45 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
> index 381b805659d3..ef9971cbb695 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.c
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -171,9 +171,14 @@ static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
>  
>  	rc = efx_mcdi_nvram_metadata(efx, partition_type, NULL, version, NULL,
>  				     0);
> +
> +	/* If the partition does not exist, that is not an error. */
> +	if (rc == -ENOENT)
> +		return 0;
> +
>  	if (rc) {
> -		netif_err(efx, drv, efx->net_dev, "mcdi nvram %s: failed\n",
> -			  version_name);
> +		netif_err(efx, drv, efx->net_dev, "mcdi nvram %s: failed (rc=%d)\n",
> +			  version_name, rc);
>  		return rc;
>  	}
>  
> @@ -187,36 +192,33 @@ static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
>  static int efx_devlink_info_stored_versions(struct efx_nic *efx,
>  					    struct devlink_info_req *req)
>  {
> -	int rc;
> -
> -	rc = efx_devlink_info_nvram_partition(efx, req,
> -					      NVRAM_PARTITION_TYPE_BUNDLE,
> -					      DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID);
> -	if (rc)
> -		return rc;
> -
> -	rc = efx_devlink_info_nvram_partition(efx, req,
> -					      NVRAM_PARTITION_TYPE_MC_FIRMWARE,
> -					      DEVLINK_INFO_VERSION_GENERIC_FW_MGMT);
> -	if (rc)
> -		return rc;
> -
> -	rc = efx_devlink_info_nvram_partition(efx, req,
> -					      NVRAM_PARTITION_TYPE_SUC_FIRMWARE,
> -					      EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC);
> -	if (rc)
> -		return rc;
> -
> -	rc = efx_devlink_info_nvram_partition(efx, req,
> -					      NVRAM_PARTITION_TYPE_EXPANSION_ROM,
> -					      EFX_DEVLINK_INFO_VERSION_FW_EXPROM);
> -	if (rc)
> -		return rc;
> +	int err;
>  
> -	rc = efx_devlink_info_nvram_partition(efx, req,
> -					      NVRAM_PARTITION_TYPE_EXPANSION_UEFI,
> -					      EFX_DEVLINK_INFO_VERSION_FW_UEFI);
> -	return rc;
> +	/* We do not care here about the specific error but just if an error
> +	 * happened. The specific error will be reported inside the call
> +	 * through system messages, and if any error happened in any call
> +	 * below, we report it through extack.
> +	 */
> +	err = efx_devlink_info_nvram_partition(efx, req,
> +					       NVRAM_PARTITION_TYPE_BUNDLE,
> +					       DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID);
> +
> +	err |= efx_devlink_info_nvram_partition(efx, req,
> +						NVRAM_PARTITION_TYPE_MC_FIRMWARE,
> +						DEVLINK_INFO_VERSION_GENERIC_FW_MGMT);
> +
> +	err |= efx_devlink_info_nvram_partition(efx, req,
> +						NVRAM_PARTITION_TYPE_SUC_FIRMWARE,
> +						EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC);
> +
> +	err |= efx_devlink_info_nvram_partition(efx, req,
> +						NVRAM_PARTITION_TYPE_EXPANSION_ROM,
> +						EFX_DEVLINK_INFO_VERSION_FW_EXPROM);
> +
> +	err |= efx_devlink_info_nvram_partition(efx, req,
> +						NVRAM_PARTITION_TYPE_EXPANSION_UEFI,
> +						EFX_DEVLINK_INFO_VERSION_FW_UEFI);
> +	return err;
>  }
>  
>  #define EFX_VER_FLAG(_f)	\
> @@ -587,27 +589,20 @@ static int efx_devlink_info_get(struct devlink *devlink,
>  {
>  	struct efx_devlink *devlink_private = devlink_priv(devlink);
>  	struct efx_nic *efx = devlink_private->efx;
> -	int rc;
> +	int err;
>  
> -	/* Several different MCDI commands are used. We report first error
> -	 * through extack returning at that point. Specific error
> -	 * information via system messages.
> +	/* Several different MCDI commands are used. We report if errors
> +	 * happened through extack. Specific error information via system
> +	 * messages inside the calls.
>  	 */
> -	rc = efx_devlink_info_board_cfg(efx, req);
> -	if (rc) {
> -		NL_SET_ERR_MSG_MOD(extack, "Getting board info failed");
> -		return rc;
> -	}
> -	rc = efx_devlink_info_stored_versions(efx, req);
> -	if (rc) {
> -		NL_SET_ERR_MSG_MOD(extack, "Getting stored versions failed");
> -		return rc;
> -	}
> -	rc = efx_devlink_info_running_versions(efx, req);
> -	if (rc) {
> -		NL_SET_ERR_MSG_MOD(extack, "Getting running versions failed");
> -		return rc;
> -	}
> +	err = efx_devlink_info_board_cfg(efx, req);
> +
> +	err |= efx_devlink_info_stored_versions(efx, req);
> +
> +	err |= efx_devlink_info_running_versions(efx, req);
> +
> +	if (err)
> +		NL_SET_ERR_MSG_MOD(extack, "Errors when getting device info. Check system messages");
>  
>  	return 0;
>  }
> -- 
> 2.17.1
> 

