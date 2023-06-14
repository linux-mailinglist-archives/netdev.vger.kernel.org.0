Return-Path: <netdev+bounces-10635-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8833E72F7E3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA1301C20CBD
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 08:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBA78369;
	Wed, 14 Jun 2023 08:31:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A736E568A
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 08:31:39 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4364D1FD2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 01:31:20 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-51496f57e59so8941011a12.2
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 01:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686731479; x=1689323479;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C4Dwzpmu97rB4KGedpolZ2PzKDT8YYymn8b5lJF/SX4=;
        b=gBzww61T0ywzKRsyVhVVetgCEOorYCnpSpcgfkv1EjanKif3e347h79AUCNTT3ex/O
         FR358bVOdkyNPXxeuHUREyRFGXwDHDXu213mxD0SPo1MEQspSwk61zE/KnB9mG3VL7kz
         cqqD2K4kHb2kx2rRhw0zjDe551J8sdIzi/BJNC7yxPSi4SJSTk3pbw3b6fVPnZv1hbvt
         4ewjirCPH2UG0mbSkGjD8lkfdKoL2hkYJ5WRgY6tgY7R7xPAHVZpkO3WLypmQc86SA9R
         O1pvfjkc3qAk4pDwi4A5B407lQFS9WZpJ1uIuDRDUz+YhUjJdcyY7QjWE1v1p04QwLgd
         zXag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686731479; x=1689323479;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C4Dwzpmu97rB4KGedpolZ2PzKDT8YYymn8b5lJF/SX4=;
        b=FZoZe+tZQbFLlkuPiIfdXtEiXQ4EBx5Dsi6azg/CtRvuMCvZxIw4utIBzlPorVmpqr
         Usk57+3TVFE+Y8v7jpJkyoEQ8f40OaK88ledpmKx2JFuWrdXMxAwR2RbbsUsTSGYHE0w
         2unDQZRXPg+N0oc9NV4a5PYac0+UEP1f1lYNFyfHkOzmXA5oua6OsfSOY2KaCDc9eMoX
         9sK4kqVOTTYNYPMWHt9ol5lPSrX3SZ+8Zul38GSoEhsTJhhnqJznuMHOiqHuraLV2PX4
         aflKpOqsdHHEcxwkVLbxyc60akR1Vdgc433LvvVxrC50TIZQ+vJC6ok+/uJXoBYlsUB2
         1I1Q==
X-Gm-Message-State: AC+VfDyEfRac2W41wqm3uZZBWyRfEXphm+rnQK4S5rHxWuuGFMEkfStN
	0DAlL0Vc6z6rIw3bdJYNOvc=
X-Google-Smtp-Source: ACHHUZ6DcSpPFTbStVYnSzS6jXiaHrNTaQlPE8PsvR9Xlww/NYGllA2HBOudCqtuw+SjzpCp5GKsaA==
X-Received: by 2002:a50:ed84:0:b0:518:e7fc:33d1 with SMTP id h4-20020a50ed84000000b00518e7fc33d1mr320418edr.41.1686731478635;
        Wed, 14 Jun 2023 01:31:18 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id v11-20020aa7d80b000000b005187bc1e2c8sm931896edq.72.2023.06.14.01.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 01:31:18 -0700 (PDT)
Date: Wed, 14 Jun 2023 09:31:15 +0100
From: Martin Habets <habetsm.xilinx@gmail.com>
To: edward.cree@amd.com
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com,
	Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev, simon.horman@corigine.com,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next] sfc: do not try to call tc functions when
 CONFIG_SFC_SRIOV=n
Message-ID: <ZIl608QjU0HoX5l7@gmail.com>
Mail-Followup-To: edward.cree@amd.com, linux-net-drivers@amd.com,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, Edward Cree <ecree.xilinx@gmail.com>,
	netdev@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
	simon.horman@corigine.com, kernel test robot <lkp@intel.com>
References: <20230612205428.1780-1-edward.cree@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612205428.1780-1-edward.cree@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FSL_HELO_FAKE,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 09:54:28PM +0100, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Functions efx_tc_netdev_event and efx_tc_netevent_event do not exist
>  in that case as object files tc_bindings.o and tc_encap_actions.o
>  are not built, so the calls to them from ef100_netdev_event and
>  ef100_netevent_event cause link errors.
> Guard the relevant part of ef100_netdev_event with #ifdef, as well as
>  the entire function ef100_netevent_event and the code that registers
>  and unregisters the netevent notifier.
> Also guard the includes of tc_bindings.h and tc_encap_actions.h into
>  ef100_netdev.c, as the symbols from these headers are only available
>  when the corresponding object files are built.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202306102026.ISK5JfUQ-lkp@intel.com/
> Fixes: 7e5e7d800011 ("sfc: neighbour lookup for TC encap action offload")
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
>  drivers/net/ethernet/sfc/ef100_netdev.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
> index 7f7d560cb2b4..3bb0442de7ea 100644
> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
> @@ -23,8 +23,10 @@
>  #include "mcdi_filters.h"
>  #include "rx_common.h"
>  #include "ef100_sriov.h"
> +#ifdef CONFIG_SFC_SRIOV
>  #include "tc_bindings.h"
>  #include "tc_encap_actions.h"
> +#endif

Don't do this, it is old-style coding.
Put a static inline function definition inside the .h files
for !CONFIG_SFC_SRIOV. Just for the APIs you need.

>  #include "efx_devlink.h"
>  
>  static void ef100_update_name(struct efx_nic *efx)
> @@ -301,22 +303,27 @@ int ef100_netdev_event(struct notifier_block *this,
>  {
>  	struct efx_nic *efx = container_of(this, struct efx_nic, netdev_notifier);
>  	struct net_device *net_dev = netdev_notifier_info_to_dev(ptr);
> +#ifdef CONFIG_SFC_SRIOV
>  	struct ef100_nic_data *nic_data = efx->nic_data;
>  	int err;
> +#endif
>  
>  	if (efx->net_dev == net_dev &&
>  	    (event == NETDEV_CHANGENAME || event == NETDEV_REGISTER))
>  		ef100_update_name(efx);
>  
> +#ifdef CONFIG_SFC_SRIOV
>  	if (!nic_data->grp_mae)

Use IS_ENABLED(CONFIG_SFC_SRIOV) here, like was done in commit a59f832a71c9.

Martin

>  		return NOTIFY_DONE;
>  	err = efx_tc_netdev_event(efx, event, net_dev);
>  	if (err & NOTIFY_STOP_MASK)
>  		return err;
> +#endif
>  
>  	return NOTIFY_DONE;
>  }
>  
> +#ifdef CONFIG_SFC_SRIOV
>  static int ef100_netevent_event(struct notifier_block *this,
>  				unsigned long event, void *ptr)
>  {
> @@ -329,9 +336,9 @@ static int ef100_netevent_event(struct notifier_block *this,
>  	err = efx_tc_netevent_event(efx, event, ptr);
>  	if (err & NOTIFY_STOP_MASK)
>  		return err;
> -
>  	return NOTIFY_DONE;
>  };
> +#endif
>  
>  static int ef100_register_netdev(struct efx_nic *efx)
>  {
> @@ -392,8 +399,8 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
>  	rtnl_unlock();
>  
>  	unregister_netdevice_notifier(&efx->netdev_notifier);
> -	unregister_netevent_notifier(&efx->netevent_notifier);
>  #if defined(CONFIG_SFC_SRIOV)
> +	unregister_netevent_notifier(&efx->netevent_notifier);
>  	if (!efx->type->is_vf)
>  		efx_ef100_pci_sriov_disable(efx, true);
>  #endif
> @@ -513,6 +520,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
>  		goto fail;
>  	}
>  
> +#ifdef CONFIG_SFC_SRIOV
>  	efx->netevent_notifier.notifier_call = ef100_netevent_event;
>  	rc = register_netevent_notifier(&efx->netevent_notifier);
>  	if (rc) {
> @@ -520,6 +528,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
>  			  "Failed to register netevent notifier, rc=%d\n", rc);
>  		goto fail;
>  	}
> +#endif
>  
>  	efx_probe_devlink_unlock(efx);
>  	return rc;

