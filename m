Return-Path: <netdev+bounces-11312-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16C47732918
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:44:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5A1B2815E0
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AD3E63C4;
	Fri, 16 Jun 2023 07:44:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD806118
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 07:44:25 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EECA270C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 00:44:24 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-51a2c60c529so452494a12.3
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 00:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686901463; x=1689493463;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rN2REcXZLHkDizaZLroN/v4ItN0FexKCG0VYqab5Qpo=;
        b=e+P657IrlvSrpoL7qseymil4uYLY3fWtssRdWghpjjylzurjp8itex3eKktEv8zNUv
         N/r0+zeETe9+Y9h7FQAD7shzA4UWumHESbtgGBJZWmmOE9oikhGl4yxcaEmtZkE8LZ7c
         6UOJPRdNWmkv6N6iRJczKPz6TxeG4ZsjCgx7oU9wKZUbDtLEIoyCvJe0LxU6bqTatHAS
         GgAYTy42I7E8rwzgbnssUPVgcY20+TKla6wmSkBYkFc8cOeswv4Fxi1kDrMJfcn7g3NC
         aN8yOfaU9FzEaw7C6HENZ1VLgBfqJQXr2tNEJDZOBblDKvkL/puAod2fuudVlGBBbZfr
         E2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686901463; x=1689493463;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rN2REcXZLHkDizaZLroN/v4ItN0FexKCG0VYqab5Qpo=;
        b=aCFQap8P/l+geBf4j+oREyf17FB7miYIsIeMi//23ni/bziYnQkXTvf1NFy91aVJEt
         bgOVwlY12p57lA2C9K58zTXID+kjALvVjBMpyB5taIQSuvyRrNMikHEQRG+EgPMbB86r
         9HYuacThhBOCfOPgQms5bkbs29PIMm1BPpsmR7B2YOuu6a4FX7+QGLpO4ZzDddtzHjP/
         6H+T13x29QmEfU5PhlWylVktmnXeHD0Ijq27jYhK9i2jDCepuV78zsqqAdTf1wun63dS
         5Z9XQxydB8WYPtRDb3KMl3ZVk2Z7jMGrV8DC0oqNSU49dbT0tG3zls55xTtV9HWzfsNE
         mkcQ==
X-Gm-Message-State: AC+VfDyPKONjt7wf7L+IWjlhbjw3HMcpGA9d/cSpnWvRzWjaJYXMQ0OI
	cL8m+iIAhAeRGL0DG1S/OhC4CqycyOc=
X-Google-Smtp-Source: ACHHUZ7pPA3/BW059I6C5lJNbbB9g4Y/afesR/awu8piiBoE2S4p+R5WzdtpRiPhImzmHkMXKV+2JA==
X-Received: by 2002:a17:907:803:b0:973:e79c:3da8 with SMTP id wv3-20020a170907080300b00973e79c3da8mr1062125ejb.17.1686901462673;
        Fri, 16 Jun 2023 00:44:22 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id g18-20020a1709061c9200b00965a4350411sm3035012ejh.9.2023.06.16.00.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 00:44:22 -0700 (PDT)
Date: Fri, 16 Jun 2023 08:44:19 +0100
From: Martin Habets <habetsm.xilinx@gmail.com>
To: edward.cree@amd.com
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com,
	Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev, simon.horman@corigine.com,
	pieter.jansen-van-vuuren@amd.com, naresh.kamboju@linaro.org,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 net-next] sfc: do not try to call tc functions when
 CONFIG_SFC_SRIOV=n
Message-ID: <ZIwS03v672Qc+PJb@gmail.com>
Mail-Followup-To: edward.cree@amd.com, linux-net-drivers@amd.com,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, Edward Cree <ecree.xilinx@gmail.com>,
	netdev@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
	simon.horman@corigine.com, pieter.jansen-van-vuuren@amd.com,
	naresh.kamboju@linaro.org, kernel test robot <lkp@intel.com>
References: <20230615215243.34942-1-edward.cree@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615215243.34942-1-edward.cree@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FSL_HELO_FAKE,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 10:52:43PM +0100, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Functions efx_tc_netdev_event and efx_tc_netevent_event do not exist
>  in that case as object files tc_bindings.o and tc_encap_actions.o
>  are not built, so the calls to them from ef100_netdev_event and
>  ef100_netevent_event cause link errors.
> Wrap the corresponding header files (tc_bindings.h, tc_encap_actions.h)
>  with #if IS_ENABLED(CONFIG_SFC_SRIOV), and add an #else with static
>  inline stubs for these two functions.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202306102026.ISK5JfUQ-lkp@intel.com/
> Fixes: 7e5e7d800011 ("sfc: neighbour lookup for TC encap action offload")
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/tc_bindings.h      | 12 ++++++++++++
>  drivers/net/ethernet/sfc/tc_encap_actions.h | 11 +++++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/tc_bindings.h b/drivers/net/ethernet/sfc/tc_bindings.h
> index 095ddeb59eb3..a326d23d322b 100644
> --- a/drivers/net/ethernet/sfc/tc_bindings.h
> +++ b/drivers/net/ethernet/sfc/tc_bindings.h
> @@ -12,6 +12,7 @@
>  #define EFX_TC_BINDINGS_H
>  #include "net_driver.h"
>  
> +#if IS_ENABLED(CONFIG_SFC_SRIOV)
>  #include <net/sch_generic.h>
>  
>  struct efx_rep;
> @@ -28,4 +29,15 @@ int efx_tc_indr_setup_cb(struct net_device *net_dev, struct Qdisc *sch,
>  			 void (*cleanup)(struct flow_block_cb *block_cb));
>  int efx_tc_netdev_event(struct efx_nic *efx, unsigned long event,
>  			struct net_device *net_dev);
> +
> +#else /* CONFIG_SFC_SRIOV */
> +
> +static inline int efx_tc_netdev_event(struct efx_nic *efx, unsigned long event,
> +				      struct net_device *net_dev)
> +{
> +	return NOTIFY_DONE;
> +}
> +
> +#endif /* CONFIG_SFC_SRIOV */
> +
>  #endif /* EFX_TC_BINDINGS_H */
> diff --git a/drivers/net/ethernet/sfc/tc_encap_actions.h b/drivers/net/ethernet/sfc/tc_encap_actions.h
> index 4d755fb92daf..c3c7904ad7ff 100644
> --- a/drivers/net/ethernet/sfc/tc_encap_actions.h
> +++ b/drivers/net/ethernet/sfc/tc_encap_actions.h
> @@ -12,6 +12,7 @@
>  #define EFX_TC_ENCAP_ACTIONS_H
>  #include "net_driver.h"
>  
> +#if IS_ENABLED(CONFIG_SFC_SRIOV)
>  #include <linux/refcount.h>
>  #include <net/tc_act/tc_tunnel_key.h>
>  
> @@ -100,4 +101,14 @@ void efx_tc_unregister_egdev(struct efx_nic *efx, struct net_device *net_dev);
>  int efx_tc_netevent_event(struct efx_nic *efx, unsigned long event,
>  			  void *ptr);
>  
> +#else /* CONFIG_SFC_SRIOV */
> +
> +static inline int efx_tc_netevent_event(struct efx_nic *efx,
> +					unsigned long event, void *ptr)
> +{
> +	return NOTIFY_DONE;
> +}
> +
> +#endif /* CONFIG_SFC_SRIOV */
> +
>  #endif /* EFX_TC_ENCAP_ACTIONS_H */

