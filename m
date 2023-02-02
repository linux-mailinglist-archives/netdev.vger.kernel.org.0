Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759EB687D02
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjBBMNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbjBBMNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:13:38 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729468D40D
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 04:13:33 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id k8-20020a05600c1c8800b003dc57ea0dfeso3593584wms.0
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 04:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m2AmtdvJNlnIb4UMb13zl3sDm4QH7tDW/jvENutXwAU=;
        b=Gmq72fQ/GgGaVKIoJ7+AkJP/bB9jkUdIkroa7s8r+HnkHhhKDJz5G5io5+bjLEdlVY
         0/kCztUhtq7VKG53yYT1mw/d6yhIOkeTtxrshGw722sAJ/Or1zHSNi5UjHSgo/cu1Kll
         NSaH1kXU++HtJJIl0id7UN5MktF1rM6+8MAlTsqxYvqYdXEZzfazkGT/1ifMqtLQ9zC1
         027rP7R6dhECKty5HwRKdOSkw47Rs71IBA6LGRMC392VfAOdCAavaa7n7atqv9NE8WKT
         P7sUs1Q9nDiGrvM+WlNME/Hvc4EjaKFvWkwFbnCNEIQDE6fWPHn8em6eKjXhf9CeDVpn
         xJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m2AmtdvJNlnIb4UMb13zl3sDm4QH7tDW/jvENutXwAU=;
        b=1N6nAhV1AnDk2WgR4mIuNB6LySk/fUArcJjJXpkm6Z6dHeVLxr5bizFMr8e1lhCAaV
         awwUVisGLG3TSLsVkLAe5sTRgBVaspDHYEvoDIJG+ny6DVabw4WlELNFawJoezwiw3HO
         aEusHWhvYy8CiTdynUbhISyQ4inNbDdY2EGpRZtHNtIYD7KHV7RbbzYUh9C3gq95p/gu
         CyrmxgMrFqYfPybghrHcqctYaykHNQACL5uRIFnS8Ya5+s1jXtdFSD7XoIlLdh4NHfK/
         fXkf2qcBHNtrZmvFvS3Qtb/zT5VAHImfmThvqmD7XWLeR/UoUAyluAKY/CZOCGZkPVTQ
         lEkw==
X-Gm-Message-State: AO0yUKVcdq0b2cP2sAQx31e0F17hM9T+aIyT8//40AT/eXztjJ498Car
        mzMgsWrSByKUNTCkHTNGkZQ=
X-Google-Smtp-Source: AK7set9MOxH75WMBtqPLkJkNIzqfRMjpWog0P1bf1IQPzWxdIbfaVa35EiCW7Qw4jzd7Be85BHgsXg==
X-Received: by 2002:a05:600c:204e:b0:3db:66e:cfdd with SMTP id p14-20020a05600c204e00b003db066ecfddmr5766692wmg.9.1675340012164;
        Thu, 02 Feb 2023 04:13:32 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id x7-20020a5d6b47000000b002bbed1388a5sm19957529wrw.15.2023.02.02.04.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 04:13:31 -0800 (PST)
Date:   Thu, 2 Feb 2023 12:13:29 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, richardcochran@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
Subject: Re: [PATCH net-next v2 1/4] sfc: store PTP filters in a list
Message-ID: <Y9uo6Yh5tqqFny8a@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, richardcochran@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
References: <20230131160506.47552-1-ihuguet@redhat.com>
 <20230201080849.10482-1-ihuguet@redhat.com>
 <20230201080849.10482-2-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230201080849.10482-2-ihuguet@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 09:08:46AM +0100, Íñigo Huguet wrote:
> Instead of using a fixed sized array for the PTP filters, use a list.
> 
> This is not actually necessary at this point because the filters for
> multicast PTP are a fixed number, but this is a preparation for the
> following patches adding support for unicast PTP.
> 
> To avoid confusion with the new struct type efx_ptp_rxfilter, change the
> name of some local variables from rxfilter to spec, given they're of the
> type efx_filter_spec.
> 
> Reported-by: Yalin Li <yalli@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
>  drivers/net/ethernet/sfc/ptp.c | 72 ++++++++++++++++++++++------------
>  1 file changed, 46 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
> index 9f07e1ba7780..53817b4350a5 100644
> --- a/drivers/net/ethernet/sfc/ptp.c
> +++ b/drivers/net/ethernet/sfc/ptp.c
> @@ -33,6 +33,7 @@
>  #include <linux/ip.h>
>  #include <linux/udp.h>
>  #include <linux/time.h>
> +#include <linux/errno.h>
>  #include <linux/ktime.h>
>  #include <linux/module.h>
>  #include <linux/pps_kernel.h>
> @@ -213,6 +214,16 @@ struct efx_ptp_timeset {
>  	u32 window;	/* Derived: end - start, allowing for wrap */
>  };
>  
> +/**
> + * struct efx_ptp_rxfilter - Filter for PTP packets
> + * @list: Node of the list where the filter is added
> + * @handle: Handle ID for the MCDI filters table
> + */
> +struct efx_ptp_rxfilter {
> +	struct list_head list;
> +	int handle;
> +};
> +
>  /**
>   * struct efx_ptp_data - Precision Time Protocol (PTP) state
>   * @efx: The NIC context
> @@ -229,8 +240,7 @@ struct efx_ptp_timeset {
>   * @work: Work task
>   * @reset_required: A serious error has occurred and the PTP task needs to be
>   *                  reset (disable, enable).
> - * @rxfilters: Receive filters when operating
> - * @rxfilters_count: Num of installed rxfilters, should be == PTP_RXFILTERS_LEN
> + * @rxfilters_mcast: Receive filters for multicast PTP packets
>   * @config: Current timestamp configuration
>   * @enabled: PTP operation enabled
>   * @mode: Mode in which PTP operating (PTP version)
> @@ -299,8 +309,7 @@ struct efx_ptp_data {
>  	struct workqueue_struct *workwq;
>  	struct work_struct work;
>  	bool reset_required;
> -	u32 rxfilters[PTP_RXFILTERS_LEN];

This is the onlu place PTP_RXFILTERS_LEN is used, so remove that
define in this patch.

Martin

> -	size_t rxfilters_count;
> +	struct list_head rxfilters_mcast;
>  	struct hwtstamp_config config;
>  	bool enabled;
>  	unsigned int mode;
> @@ -1292,11 +1301,13 @@ static inline void efx_ptp_process_rx(struct efx_nic *efx, struct sk_buff *skb)
>  static void efx_ptp_remove_multicast_filters(struct efx_nic *efx)
>  {
>  	struct efx_ptp_data *ptp = efx->ptp_data;
> +	struct efx_ptp_rxfilter *rxfilter, *tmp;
>  
> -	while (ptp->rxfilters_count) {
> -		ptp->rxfilters_count--;
> +	list_for_each_entry_safe(rxfilter, tmp, &ptp->rxfilters_mcast, list) {
>  		efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
> -					  ptp->rxfilters[ptp->rxfilters_count]);
> +					  rxfilter->handle);
> +		list_del(&rxfilter->list);
> +		kfree(rxfilter);
>  	}
>  }
>  
> @@ -1311,48 +1322,55 @@ static void efx_ptp_init_filter(struct efx_nic *efx,
>  }
>  
>  static int efx_ptp_insert_filter(struct efx_nic *efx,
> -				 struct efx_filter_spec *rxfilter)
> +				 struct efx_filter_spec *spec)
>  {
>  	struct efx_ptp_data *ptp = efx->ptp_data;
> +	struct efx_ptp_rxfilter *rxfilter;
>  
> -	int rc = efx_filter_insert_filter(efx, rxfilter, true);
> +	int rc = efx_filter_insert_filter(efx, spec, true);
>  	if (rc < 0)
>  		return rc;
> -	ptp->rxfilters[ptp->rxfilters_count] = rc;
> -	ptp->rxfilters_count++;
> +
> +	rxfilter = kzalloc(sizeof(*rxfilter), GFP_KERNEL);
> +	if (!rxfilter)
> +		return -ENOMEM;
> +
> +	rxfilter->handle = rc;
> +	list_add(&rxfilter->list, &ptp->rxfilters_mcast);
> +
>  	return 0;
>  }
>  
>  static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx, u16 port)
>  {
> -	struct efx_filter_spec rxfilter;
> +	struct efx_filter_spec spec;
>  
> -	efx_ptp_init_filter(efx, &rxfilter);
> -	efx_filter_set_ipv4_local(&rxfilter, IPPROTO_UDP, htonl(PTP_ADDR_IPV4),
> +	efx_ptp_init_filter(efx, &spec);
> +	efx_filter_set_ipv4_local(&spec, IPPROTO_UDP, htonl(PTP_ADDR_IPV4),
>  				  htons(port));
> -	return efx_ptp_insert_filter(efx, &rxfilter);
> +	return efx_ptp_insert_filter(efx, &spec);
>  }
>  
>  static int efx_ptp_insert_ipv6_filter(struct efx_nic *efx, u16 port)
>  {
>  	const struct in6_addr addr = {{PTP_ADDR_IPV6}};
> -	struct efx_filter_spec rxfilter;
> +	struct efx_filter_spec spec;
>  
> -	efx_ptp_init_filter(efx, &rxfilter);
> -	efx_filter_set_ipv6_local(&rxfilter, IPPROTO_UDP, &addr, htons(port));
> -	return efx_ptp_insert_filter(efx, &rxfilter);
> +	efx_ptp_init_filter(efx, &spec);
> +	efx_filter_set_ipv6_local(&spec, IPPROTO_UDP, &addr, htons(port));
> +	return efx_ptp_insert_filter(efx, &spec);
>  }
>  
>  static int efx_ptp_insert_eth_filter(struct efx_nic *efx)
>  {
>  	const u8 addr[ETH_ALEN] = PTP_ADDR_ETHER;
> -	struct efx_filter_spec rxfilter;
> +	struct efx_filter_spec spec;
>  
> -	efx_ptp_init_filter(efx, &rxfilter);
> -	efx_filter_set_eth_local(&rxfilter, EFX_FILTER_VID_UNSPEC, addr);
> -	rxfilter.match_flags |= EFX_FILTER_MATCH_ETHER_TYPE;
> -	rxfilter.ether_type = htons(ETH_P_1588);
> -	return efx_ptp_insert_filter(efx, &rxfilter);
> +	efx_ptp_init_filter(efx, &spec);
> +	efx_filter_set_eth_local(&spec, EFX_FILTER_VID_UNSPEC, addr);
> +	spec.match_flags |= EFX_FILTER_MATCH_ETHER_TYPE;
> +	spec.ether_type = htons(ETH_P_1588);
> +	return efx_ptp_insert_filter(efx, &spec);
>  }
>  
>  static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
> @@ -1360,7 +1378,7 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
>  	struct efx_ptp_data *ptp = efx->ptp_data;
>  	int rc;
>  
> -	if (!ptp->channel || ptp->rxfilters_count)
> +	if (!ptp->channel || !list_empty(&ptp->rxfilters_mcast))
>  		return 0;
>  
>  	/* Must filter on both event and general ports to ensure
> @@ -1566,6 +1584,8 @@ int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
>  	for (pos = 0; pos < MAX_RECEIVE_EVENTS; pos++)
>  		list_add(&ptp->rx_evts[pos].link, &ptp->evt_free_list);
>  
> +	INIT_LIST_HEAD(&ptp->rxfilters_mcast);
> +
>  	/* Get the NIC PTP attributes and set up time conversions */
>  	rc = efx_ptp_get_attributes(efx);
>  	if (rc < 0)
> -- 
> 2.34.3
