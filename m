Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED58687FA1
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjBBOMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbjBBOMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:12:47 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28D78DAC9
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 06:12:30 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id a2so1549733wrd.6
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 06:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jwowi8FKJxAAwaZbt8o2ehJGCHYcX6B4AliRqU4jld4=;
        b=f2LNhNeGVGeSt1E2ecgFF6qm98b/s9NOo9qDW+fNmUrEk9vs61Mq6w3IBU5jJZ1EZx
         1JvhxgnUnwz+XrA0mi1KxQQBLXLWiiDrHYTEDZcUNbiY1+nvLXchmKAhrHp+aNiX5duP
         HWAcYqdPqgweJn2+A4qJz/w0VqlhHHxQHGWJsIFaeUYEouiZA9ZgAzbEzmWtr0nqAJFt
         MLiz09pHwu9GhuxQfNF7WhGc5DWoMHzitLtBnJGO4nou0+fHcozl+H6hEEuqKRAdA7i+
         e2IWJPUV06PiKgB8n9LkLqFpmo8fPJmiG0PLcldB4LbKiXf4uxWrJlRZ144UtYRUCR2P
         O58g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jwowi8FKJxAAwaZbt8o2ehJGCHYcX6B4AliRqU4jld4=;
        b=Si/Szcbyi+s/vP+XinP1SVLi4hWd+Ouch8ZJE6arIVfarP87F8SeNHmCzgWEh/h6Xt
         QA+3R0lwBBbj3961KHbyvrroFpstuOiBAghkZ400AG/ujceh3XSJl2nR5hzL6/KKxek/
         WY2PQr7GcejCBia1TJ2QWQDdEX8SS7KZSbp1kunnkcULoqpF9PvIXnoBHhIfkqgKGNe7
         VNAoqFvDaY3Ky/V7Imkwy1vIH+BiiXUUtlXSvjeciJ8A1vHrZXvKEYN4FeScot32QfWo
         ehV4NKO7j9e8uptC0FU4F/bA/AZf7Z+BZ2GCFKVojJK7bJo64TT+NAG5aAihzl70EuG+
         PnAg==
X-Gm-Message-State: AO0yUKXAsYliyRrMtKfIST9pyV+nGr16luY1QonH8JWq+2/iUlbqlF7F
        BbQRxJpR/scWcM1zF0WqQDw=
X-Google-Smtp-Source: AK7set/x0ItdGm2uirunMXxAPE2u0jEjF8ElwcRPatENRj9VFsT0oAPN9i7sP5arKBICTKQv2DXv9A==
X-Received: by 2002:a05:6000:38e:b0:2bc:7fdd:9245 with SMTP id u14-20020a056000038e00b002bc7fdd9245mr6502016wrf.5.1675347149066;
        Thu, 02 Feb 2023 06:12:29 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id t8-20020a5d6908000000b002bc7e5a1171sm20357580wru.116.2023.02.02.06.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 06:12:28 -0800 (PST)
Date:   Thu, 2 Feb 2023 14:12:26 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, richardcochran@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
Subject: Re: [PATCH net-next v2 4/4] sfc: remove expired unicast PTP filters
Message-ID: <Y9vEyh8QfDf/6i0i@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, richardcochran@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
References: <20230131160506.47552-1-ihuguet@redhat.com>
 <20230201080849.10482-1-ihuguet@redhat.com>
 <20230201080849.10482-5-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230201080849.10482-5-ihuguet@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 09:08:49AM +0100, Íñigo Huguet wrote:
> Filters inserted to support unicast PTP mode might become unused after
> some time, so we need to remove them to avoid accumulating many of them.
> 
> Actually, it would be a very unusual situation that many different
> addresses are used, normally only a small set of predefined
> addresses are tried. Anyway, some cleanup is necessary because
> maintaining old filters forever makes very little sense.
> 
> Reported-by: Yalin Li <yalli@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
>  drivers/net/ethernet/sfc/ptp.c | 121 +++++++++++++++++++++------------
>  1 file changed, 77 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
> index a3e827cd84a8..dd46ca6c070e 100644
> --- a/drivers/net/ethernet/sfc/ptp.c
> +++ b/drivers/net/ethernet/sfc/ptp.c
> @@ -75,6 +75,9 @@
>  /* How long an unmatched event or packet can be held */
>  #define PKT_EVENT_LIFETIME_MS		10
>  
> +/* How long unused unicast filters can be held */
> +#define UCAST_FILTER_EXPIRY_JIFFIES	msecs_to_jiffies(30000)

This seems like something that should be tunable, with this as a
default value.

> +
>  /* Offsets into PTP packet for identification.  These offsets are from the
>   * start of the IP header, not the MAC header.  Note that neither PTP V1 nor
>   * PTP V2 permit the use of IPV4 options.
> @@ -220,6 +223,7 @@ struct efx_ptp_timeset {
>   * @ether_type: Network protocol of the filter (ETHER_P_IP / ETHER_P_IPV6)
>   * @loc_port: UDP port of the filter (PTP_EVENT_PORT / PTP_GENERAL_PORT)
>   * @loc_host: IPv4/v6 address of the filter
> + * @expiry: time when the filter expires, in jiffies
>   * @handle: Handle ID for the MCDI filters table
>   */
>  struct efx_ptp_rxfilter {
> @@ -227,6 +231,7 @@ struct efx_ptp_rxfilter {
>  	__be16 ether_type;
>  	__be16 loc_port;
>  	__be32 loc_host[4];
> +	unsigned long expiry;
>  	int handle;
>  };
>  
> @@ -1320,8 +1325,8 @@ static inline void efx_ptp_process_rx(struct efx_nic *efx, struct sk_buff *skb)
>  	local_bh_enable();
>  }
>  
> -static bool efx_ptp_filter_exists(struct list_head *ptp_list,
> -				  struct efx_filter_spec *spec)
> +static struct efx_ptp_rxfilter *
> +efx_ptp_find_filter(struct list_head *ptp_list, struct efx_filter_spec *spec)
>  {
>  	struct efx_ptp_rxfilter *rxfilter;
>  
> @@ -1329,10 +1334,19 @@ static bool efx_ptp_filter_exists(struct list_head *ptp_list,
>  		if (rxfilter->ether_type == spec->ether_type &&
>  		    rxfilter->loc_port == spec->loc_port &&
>  		    !memcmp(rxfilter->loc_host, spec->loc_host, sizeof(spec->loc_host)))
> -			return true;
> +			return rxfilter;
>  	}
>  
> -	return false;
> +	return NULL;
> +}
> +
> +static inline void efx_ptp_remove_one_filter(struct efx_nic *efx,
> +					     struct efx_ptp_rxfilter *rxfilter)

As others noted, don't use inline in .c files.

> +{
> +	efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
> +				  rxfilter->handle);
> +	list_del(&rxfilter->list);
> +	kfree(rxfilter);
>  }
>  
>  static void efx_ptp_remove_filters(struct efx_nic *efx,
> @@ -1341,10 +1355,7 @@ static void efx_ptp_remove_filters(struct efx_nic *efx,
>  	struct efx_ptp_rxfilter *rxfilter, *tmp;
>  
>  	list_for_each_entry_safe(rxfilter, tmp, ptp_list, list) {
> -		efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
> -					  rxfilter->handle);
> -		list_del(&rxfilter->list);
> -		kfree(rxfilter);
> +		efx_ptp_remove_one_filter(efx, rxfilter);
>  	}
>  }
>  
> @@ -1358,23 +1369,24 @@ static void efx_ptp_init_filter(struct efx_nic *efx,
>  			   efx_rx_queue_index(queue));
>  }
>  
> -static int efx_ptp_insert_filter(struct efx_nic *efx,
> -				 struct list_head *ptp_list,
> -				 struct efx_filter_spec *spec)
> +static struct efx_ptp_rxfilter *
> +efx_ptp_insert_filter(struct efx_nic *efx, struct list_head *ptp_list,
> +		      struct efx_filter_spec *spec)

This API change and the following ones are all for very little gain,
they are just do set the new expiry attribute. And in the end the
pointers all get converted back to an integer return code.
In stead, just pass expiry as a new argument to efx_ptp_insert_ipv4_filter()
and efx_ptp_insert_ipv6_filter().

>  {
>  	struct efx_ptp_rxfilter *rxfilter;
>  	int rc;
>  
> -	if (efx_ptp_filter_exists(ptp_list, spec))
> -		return 0;
> +	rxfilter = efx_ptp_find_filter(ptp_list, spec);
> +	if (rxfilter)
> +		return rxfilter;
>  
>  	rc = efx_filter_insert_filter(efx, spec, true);
>  	if (rc < 0)
> -		return rc;
> +		return ERR_PTR(rc);
>  
>  	rxfilter = kzalloc(sizeof(*rxfilter), GFP_KERNEL);
>  	if (!rxfilter)
> -		return -ENOMEM;
> +		return ERR_PTR(-ENOMEM);
>  
>  	rxfilter->handle = rc;
>  	rxfilter->ether_type = spec->ether_type;
> @@ -1382,12 +1394,12 @@ static int efx_ptp_insert_filter(struct efx_nic *efx,
>  	memcpy(rxfilter->loc_host, spec->loc_host, sizeof(spec->loc_host));
>  	list_add(&rxfilter->list, ptp_list);
>  
> -	return 0;
> +	return rxfilter;
>  }
>  
> -static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx,
> -				      struct list_head *ptp_list,
> -				      __be32 addr, u16 port)
> +static struct efx_ptp_rxfilter *
> +efx_ptp_insert_ipv4_filter(struct efx_nic *efx, struct list_head *ptp_list,
> +			   __be32 addr, u16 port)
>  {
>  	struct efx_filter_spec spec;
>  
> @@ -1396,9 +1408,9 @@ static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx,
>  	return efx_ptp_insert_filter(efx, ptp_list, &spec);
>  }
>  
> -static int efx_ptp_insert_ipv6_filter(struct efx_nic *efx,
> -				      struct list_head *ptp_list,
> -				      struct in6_addr *addr, u16 port)
> +static struct efx_ptp_rxfilter *
> +efx_ptp_insert_ipv6_filter(struct efx_nic *efx, struct list_head *ptp_list,
> +			   struct in6_addr *addr, u16 port)
>  {
>  	struct efx_filter_spec spec;
>  
> @@ -1407,7 +1419,8 @@ static int efx_ptp_insert_ipv6_filter(struct efx_nic *efx,
>  	return efx_ptp_insert_filter(efx, ptp_list, &spec);
>  }
>  
> -static int efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
> +static struct efx_ptp_rxfilter *
> +efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
>  {
>  	const u8 addr[ETH_ALEN] = PTP_ADDR_ETHER;
>  	struct efx_filter_spec spec;
> @@ -1422,7 +1435,7 @@ static int efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
>  static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
>  {
>  	struct efx_ptp_data *ptp = efx->ptp_data;
> -	int rc;
> +	struct efx_ptp_rxfilter *rc;
>  
>  	if (!ptp->channel || !list_empty(&ptp->rxfilters_mcast))
>  		return 0;
> @@ -1432,12 +1445,12 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
>  	 */
>  	rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_mcast,
>  					htonl(PTP_ADDR_IPV4), PTP_EVENT_PORT);
> -	if (rc < 0)
> +	if (IS_ERR(rc))
>  		goto fail;
>  
>  	rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_mcast,
>  					htonl(PTP_ADDR_IPV4), PTP_GENERAL_PORT);
> -	if (rc < 0)
> +	if (IS_ERR(rc))
>  		goto fail;
>  
>  	/* if the NIC supports hw timestamps by the MAC, we can support
> @@ -1448,16 +1461,16 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
>  
>  		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_mcast,
>  						&ipv6_addr, PTP_EVENT_PORT);
> -		if (rc < 0)
> +		if (IS_ERR(rc))
>  			goto fail;
>  
>  		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_mcast,
>  						&ipv6_addr, PTP_GENERAL_PORT);
> -		if (rc < 0)
> +		if (IS_ERR(rc))
>  			goto fail;
>  
>  		rc = efx_ptp_insert_eth_multicast_filter(efx);
> -		if (rc < 0)
> +		if (IS_ERR(rc))
>  			goto fail;
>  	}
>  
> @@ -1465,7 +1478,7 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
>  
>  fail:
>  	efx_ptp_remove_filters(efx, &ptp->rxfilters_mcast);
> -	return rc;
> +	return PTR_ERR(rc);
>  }
>  
>  static bool efx_ptp_valid_unicast_event_pkt(struct sk_buff *skb)
> @@ -1484,7 +1497,7 @@ static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
>  					 struct sk_buff *skb)
>  {
>  	struct efx_ptp_data *ptp = efx->ptp_data;
> -	int rc;
> +	struct efx_ptp_rxfilter *rxfilter;
>  
>  	if (!efx_ptp_valid_unicast_event_pkt(skb))
>  		return -EINVAL;
> @@ -1492,28 +1505,36 @@ static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
>  	if (skb->protocol == htons(ETH_P_IP)) {
>  		__be32 addr = ip_hdr(skb)->saddr;
>  
> -		rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
> -						addr, PTP_EVENT_PORT);
> -		if (rc < 0)
> +		rxfilter = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
> +						      addr, PTP_EVENT_PORT);
> +		if (IS_ERR(rxfilter))
>  			goto fail;
>  
> -		rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
> -						addr, PTP_GENERAL_PORT);
> -		if (rc < 0)
> +		rxfilter->expiry = jiffies + UCAST_FILTER_EXPIRY_JIFFIES;
> +
> +		rxfilter = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
> +						      addr, PTP_GENERAL_PORT);
> +		if (IS_ERR(rxfilter))
>  			goto fail;
> +
> +		rxfilter->expiry = jiffies + UCAST_FILTER_EXPIRY_JIFFIES;
>  	} else if (efx_ptp_use_mac_tx_timestamps(efx)) {
>  		/* IPv6 PTP only supported by devices with MAC hw timestamp */
>  		struct in6_addr *addr = &ipv6_hdr(skb)->saddr;
>  
> -		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
> -						addr, PTP_EVENT_PORT);
> -		if (rc < 0)
> +		rxfilter = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
> +						      addr, PTP_EVENT_PORT);
> +		if (IS_ERR(rxfilter))
>  			goto fail;
>  
> -		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
> -						addr, PTP_GENERAL_PORT);
> -		if (rc < 0)
> +		rxfilter->expiry = jiffies + UCAST_FILTER_EXPIRY_JIFFIES;
> +
> +		rxfilter = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
> +						      addr, PTP_GENERAL_PORT);
> +		if (IS_ERR(rxfilter))
>  			goto fail;
> +
> +		rxfilter->expiry = jiffies + UCAST_FILTER_EXPIRY_JIFFIES;
>  	} else {
>  		return -EOPNOTSUPP;
>  	}
> @@ -1522,7 +1543,18 @@ static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
>  
>  fail:
>  	efx_ptp_remove_filters(efx, &ptp->rxfilters_ucast);
> -	return rc;
> +	return PTR_ERR(rxfilter);
> +}
> +
> +static void efx_ptp_drop_expired_unicast_filters(struct efx_nic *efx)
> +{
> +	struct efx_ptp_data *ptp = efx->ptp_data;
> +	struct efx_ptp_rxfilter *rxfilter, *tmp;
> +
> +	list_for_each_entry_safe(rxfilter, tmp, &ptp->rxfilters_ucast, list) {
> +		if (time_is_before_jiffies(rxfilter->expiry))

Shouldn't this be time_is_after_jiffies?

> +			efx_ptp_remove_one_filter(efx, rxfilter);
> +	}
>  }
>  
>  static int efx_ptp_start(struct efx_nic *efx)
> @@ -1616,6 +1648,7 @@ static void efx_ptp_worker(struct work_struct *work)
>  	}
>  
>  	efx_ptp_drop_time_expired_events(efx);
> +	efx_ptp_drop_expired_unicast_filters(efx);

This grabs locks in efx_mcdi_filter_remove_safe(), which is bad because
that will delay processing that is done below. So do this at the end of
the function.

Martin

>  
>  	__skb_queue_head_init(&tempq);
>  	efx_ptp_process_events(efx, &tempq);
> -- 
> 2.34.3
