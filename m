Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E803687E83
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 14:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbjBBNWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 08:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbjBBNWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 08:22:32 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC018F262
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 05:22:24 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id hn2-20020a05600ca38200b003dc5cb96d46so3702773wmb.4
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 05:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g3/db7loTmFCrh0IP5FgBlXUDoDrOeSTQafYa76dEHg=;
        b=q2e2jv+rVuLP6qfytXEnqgPus2lfds57pzbvdqhIvVaXwK2F6SI0ZAxlLyvmIJ5hu+
         OTJN8y7nrG9+w4kcyAJhLMAQDn+JzGKe7zoIZvdA0pCkRbgWhkPNzppB4jDbqligiuna
         f+RmDL4GpssEcoOlP86IlwLJ48ekqSwbitPQ/xZNLxZYFGv8sK2O1cZjcYoJ1ZKqJpD6
         N2gKIxw6pe354EUU1nPKM7dQME9MEN1V/5W3y0h3RtcDzP3seCmjXKy7tqBy0paihhJs
         Bu7q3PpelyH+QuLwPN3REz9Oi734WjUmwBoCQ8h1KRGS4HLFf6l1fpDOIoB62/XFS3JB
         eKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g3/db7loTmFCrh0IP5FgBlXUDoDrOeSTQafYa76dEHg=;
        b=ddN17mtqtpUp+vqjuHTqaiGNBKxlO8aS/VlLEN0G7PKU43zo44mvFygIWUZC5ZYTc9
         lVZ3Y2KFTjzRlD2/VXh39JNCbtdzRPr+b3YDmmV6RyI4l0Jcz5Et1A4aUvUD2YHgg5Lw
         j0cK0KahSAZOjTvwCtDvITj8qptJeihB1GJQuNi7qSXimY8QG1OC62vT6i1FMbSB2f4y
         NmZWZXaoTnNwTHLgY5EjfHeU0AqYRzY7kujX7eBa1dU5Yn6GeDR77V+bcbghx76PoG+f
         GCvYm/LoYMPm6tLgZFd2YmyJb8aLU3+9AIWWGcWjz/gJYG/4OjqJvsPCkaOiiirJBlhj
         LOqQ==
X-Gm-Message-State: AO0yUKVitMgJ662l6wqV8uHiEfLSFRBDh1xbYu4VnZHPHYT9bOPymTul
        jNrjwnqg32Oy7EM9f+tPegODQz6kdbE=
X-Google-Smtp-Source: AK7set/uSFBzC3wlAdtL49/D4eA7VN0q2qGWjpa6QhNqswqxJ+xiCnrYEoLb2tLGP6DKaN8rlba2GQ==
X-Received: by 2002:a05:600c:4f94:b0:3df:9858:c039 with SMTP id n20-20020a05600c4f9400b003df9858c039mr1826221wmq.14.1675344142840;
        Thu, 02 Feb 2023 05:22:22 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id bg21-20020a05600c3c9500b003db06493ee7sm5465754wmb.47.2023.02.02.05.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 05:22:22 -0800 (PST)
Date:   Thu, 2 Feb 2023 13:22:20 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, richardcochran@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
Subject: Re: [PATCH net-next v2 3/4] sfc: support unicast PTP
Message-ID: <Y9u5DL4NzP/OQVed@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, richardcochran@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
References: <20230131160506.47552-1-ihuguet@redhat.com>
 <20230201080849.10482-1-ihuguet@redhat.com>
 <20230201080849.10482-4-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230201080849.10482-4-ihuguet@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 09:08:48AM +0100, Íñigo Huguet wrote:
> When sending a PTP event packet, add the correct filters that will make
> that future incoming unicast PTP event packets will be timestamped.
> The unicast address for the filter is gotten from the outgoing skb
> before sending it.
> 
> Until now they were not timestamped because only filters that match with
> the PTP multicast addressed were being configured into the NIC for the
> PTP special channel. Packets received through different channels are not
> timestamped, getting "received SYNC without timestamp" error in ptp4l.
> 
> Note that the inserted filters are never removed unless the NIC is stopped
> or reconfigured, so efx_ptp_stop is called. Removal of old filters will
> be handled by the next patch.
> 
> Reported-by: Yalin Li <yalli@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
>  drivers/net/ethernet/sfc/ptp.c | 105 ++++++++++++++++++++++++++++++++-
>  1 file changed, 102 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
> index 5d5f70c56048..a3e827cd84a8 100644
> --- a/drivers/net/ethernet/sfc/ptp.c
> +++ b/drivers/net/ethernet/sfc/ptp.c
> @@ -217,10 +217,16 @@ struct efx_ptp_timeset {
>  /**
>   * struct efx_ptp_rxfilter - Filter for PTP packets
>   * @list: Node of the list where the filter is added
> + * @ether_type: Network protocol of the filter (ETHER_P_IP / ETHER_P_IPV6)
> + * @loc_port: UDP port of the filter (PTP_EVENT_PORT / PTP_GENERAL_PORT)
> + * @loc_host: IPv4/v6 address of the filter
>   * @handle: Handle ID for the MCDI filters table
>   */
>  struct efx_ptp_rxfilter {
>  	struct list_head list;
> +	__be16 ether_type;
> +	__be16 loc_port;
> +	__be32 loc_host[4];
>  	int handle;
>  };
>  
> @@ -369,6 +375,8 @@ static int efx_phc_settime(struct ptp_clock_info *ptp,
>  			   const struct timespec64 *e_ts);
>  static int efx_phc_enable(struct ptp_clock_info *ptp,
>  			  struct ptp_clock_request *request, int on);
> +static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
> +					 struct sk_buff *skb);
>  
>  bool efx_ptp_use_mac_tx_timestamps(struct efx_nic *efx)
>  {
> @@ -1114,6 +1122,8 @@ static void efx_ptp_xmit_skb_queue(struct efx_nic *efx, struct sk_buff *skb)
>  
>  	tx_queue = efx_channel_get_tx_queue(ptp_data->channel, type);
>  	if (tx_queue && tx_queue->timestamping) {
> +		skb_get(skb);
> +
>  		/* This code invokes normal driver TX code which is always
>  		 * protected from softirqs when called from generic TX code,
>  		 * which in turn disables preemption. Look at __dev_queue_xmit
> @@ -1137,6 +1147,13 @@ static void efx_ptp_xmit_skb_queue(struct efx_nic *efx, struct sk_buff *skb)
>  		local_bh_disable();
>  		efx_enqueue_skb(tx_queue, skb);
>  		local_bh_enable();
> +
> +		/* We need to add the filters after enqueuing the packet.
> +		 * Otherwise, there's high latency in sending back the
> +		 * timestamp, causing ptp4l timeouts
> +		 */
> +		efx_ptp_insert_unicast_filter(efx, skb);
> +		dev_consume_skb_any(skb);
>  	} else {
>  		WARN_ONCE(1, "PTP channel has no timestamped tx queue\n");
>  		dev_kfree_skb_any(skb);
> @@ -1148,7 +1165,7 @@ static void efx_ptp_xmit_skb_mc(struct efx_nic *efx, struct sk_buff *skb)
>  {
>  	struct efx_ptp_data *ptp_data = efx->ptp_data;
>  	struct skb_shared_hwtstamps timestamps;
> -	int rc = -EIO;
> +	int rc;
>  	MCDI_DECLARE_BUF(txtime, MC_CMD_PTP_OUT_TRANSMIT_LEN);
>  	size_t len;

While I'm grateful for this unrelated cleanup, it exposes that our
existing code does not obey the reverse Christmas convention. And
now the line with rc is also shorter than the one for len.
Can you fix this please? For me this is ok as part of this series.

Martin

>  
> @@ -1184,7 +1201,10 @@ static void efx_ptp_xmit_skb_mc(struct efx_nic *efx, struct sk_buff *skb)
>  
>  	skb_tstamp_tx(skb, &timestamps);
>  
> -	rc = 0;
> +	/* Add the filters after sending back the timestamp to avoid delaying it
> +	 * or ptp4l may timeout.
> +	 */
> +	efx_ptp_insert_unicast_filter(efx, skb);
>  
>  fail:
>  	dev_kfree_skb_any(skb);
> @@ -1300,6 +1320,21 @@ static inline void efx_ptp_process_rx(struct efx_nic *efx, struct sk_buff *skb)
>  	local_bh_enable();
>  }
>  
> +static bool efx_ptp_filter_exists(struct list_head *ptp_list,
> +				  struct efx_filter_spec *spec)
> +{
> +	struct efx_ptp_rxfilter *rxfilter;
> +
> +	list_for_each_entry(rxfilter, ptp_list, list) {
> +		if (rxfilter->ether_type == spec->ether_type &&
> +		    rxfilter->loc_port == spec->loc_port &&
> +		    !memcmp(rxfilter->loc_host, spec->loc_host, sizeof(spec->loc_host)))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>  static void efx_ptp_remove_filters(struct efx_nic *efx,
>  				   struct list_head *ptp_list)
>  {
> @@ -1328,8 +1363,12 @@ static int efx_ptp_insert_filter(struct efx_nic *efx,
>  				 struct efx_filter_spec *spec)
>  {
>  	struct efx_ptp_rxfilter *rxfilter;
> +	int rc;
> +
> +	if (efx_ptp_filter_exists(ptp_list, spec))
> +		return 0;
>  
> -	int rc = efx_filter_insert_filter(efx, spec, true);
> +	rc = efx_filter_insert_filter(efx, spec, true);
>  	if (rc < 0)
>  		return rc;
>  
> @@ -1338,6 +1377,9 @@ static int efx_ptp_insert_filter(struct efx_nic *efx,
>  		return -ENOMEM;
>  
>  	rxfilter->handle = rc;
> +	rxfilter->ether_type = spec->ether_type;
> +	rxfilter->loc_port = spec->loc_port;
> +	memcpy(rxfilter->loc_host, spec->loc_host, sizeof(spec->loc_host));
>  	list_add(&rxfilter->list, ptp_list);
>  
>  	return 0;
> @@ -1426,6 +1468,63 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
>  	return rc;
>  }
>  
> +static bool efx_ptp_valid_unicast_event_pkt(struct sk_buff *skb)
> +{
> +	if (skb->protocol == htons(ETH_P_IP)) {
> +		return ip_hdr(skb)->protocol == IPPROTO_UDP &&
> +			udp_hdr(skb)->source == htons(PTP_EVENT_PORT);
> +	} else if (skb->protocol == htons(ETH_P_IPV6)) {
> +		return ipv6_hdr(skb)->nexthdr == IPPROTO_UDP &&
> +			udp_hdr(skb)->source == htons(PTP_EVENT_PORT);
> +	}
> +	return false;
> +}
> +
> +static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
> +					 struct sk_buff *skb)
> +{
> +	struct efx_ptp_data *ptp = efx->ptp_data;
> +	int rc;
> +
> +	if (!efx_ptp_valid_unicast_event_pkt(skb))
> +		return -EINVAL;
> +
> +	if (skb->protocol == htons(ETH_P_IP)) {
> +		__be32 addr = ip_hdr(skb)->saddr;
> +
> +		rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
> +						addr, PTP_EVENT_PORT);
> +		if (rc < 0)
> +			goto fail;
> +
> +		rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
> +						addr, PTP_GENERAL_PORT);
> +		if (rc < 0)
> +			goto fail;
> +	} else if (efx_ptp_use_mac_tx_timestamps(efx)) {
> +		/* IPv6 PTP only supported by devices with MAC hw timestamp */
> +		struct in6_addr *addr = &ipv6_hdr(skb)->saddr;
> +
> +		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
> +						addr, PTP_EVENT_PORT);
> +		if (rc < 0)
> +			goto fail;
> +
> +		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
> +						addr, PTP_GENERAL_PORT);
> +		if (rc < 0)
> +			goto fail;
> +	} else {
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +
> +fail:
> +	efx_ptp_remove_filters(efx, &ptp->rxfilters_ucast);
> +	return rc;
> +}
> +
>  static int efx_ptp_start(struct efx_nic *efx)
>  {
>  	struct efx_ptp_data *ptp = efx->ptp_data;
> -- 
> 2.34.3
