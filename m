Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13E25A8106
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbiHaPRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiHaPRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:17:16 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBAFD7409
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 08:17:15 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id n17so18718465wrm.4
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 08:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=AMVZpKY4RWOqaikk0K1AVQZ/JqJKk9TuWZdzzdS42fg=;
        b=d2Tt+y3KHhiD39H9vgktmb1e4vghORVx7/PYq/XTnr4irjFv62WFOG1o2StWu10N+L
         HDqx0l/xQnhJoiVvbkYyKqpmvoP3zgcVwykjBiT1f5AqKBCXZTZINYV9x+iiY9qS8+xu
         OdV42G4Rr7nPMUfA2S6vwkrt9x3Z9hkh8lkV8b2Uym2sRAtwPCjN2KBX6StmjAQHT43H
         QGBLv9QDpol8sTZnIbm1mPHWUJvfz0tIrn1NvStso5PCFin3iv9QO4UGS88XA7J42Euj
         WgXBB1Zahdwb1wQ1/jQ16zL/iQIoy2LvIOh8nbZ21w+MhrV0dVv64hkoiA/AKRat0m/v
         +9zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=AMVZpKY4RWOqaikk0K1AVQZ/JqJKk9TuWZdzzdS42fg=;
        b=r10H7EmBW0j3gCQGGkLxtZxtPijReNkZSikSpMi2W9cdApw7sWGNztN+LVtrOdwFzM
         gBFrnFzqRL45OCfmTjTAOccw9RI7cvg3LXfKZqVRLptTKoFOBgOys19qEMKtcTD/BnaL
         L/CpjabfUm1uZlQmqm15I6hCwU5ofWf15OqOCnTVPELBBp6LR3GtvU7Q32idvKob4o1h
         EjLzcsDE0x/lCZe8jXPS15b0TMbtxgqWoYN0zun/UVR9lTe3EZl3TaKLgXILt53fMTru
         2Xjes8e3+TWGHDVwaydQslye096fLnwoFg83Fd8OZ1MjK6SkzWPS1OMVcYAQievVQKBC
         8s3g==
X-Gm-Message-State: ACgBeo2Y4AMZARiwh1efKqEzqe1Navjm/YWUr7Q5NhS1igFY/EttH/qM
        PJjB0n/H0ZK3suWSzq6j+mU=
X-Google-Smtp-Source: AA6agR5MWUEXEcLxpjYlBfAHZwErOwalcJWcOC1JptuHRMWJv5A/o1+AKmkUJ+LU+S7K0jIF8/ctBw==
X-Received: by 2002:a5d:6202:0:b0:226:d797:6e29 with SMTP id y2-20020a5d6202000000b00226d7976e29mr9792685wru.696.1661959034070;
        Wed, 31 Aug 2022 08:17:14 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id p30-20020a05600c1d9e00b003a3561d4f3fsm2499112wms.43.2022.08.31.08.17.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 08:17:13 -0700 (PDT)
Subject: Re: [PATCH net-next v4 1/3] sfc: allow more flexible way of adding
 filters for PTP
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, richardcochran@gmail.com
References: <20220825090242.12848-1-ihuguet@redhat.com>
 <20220831101631.13585-1-ihuguet@redhat.com>
 <20220831101631.13585-2-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <1f3ccb3d-cb69-1d07-570e-8ba043e6a989@gmail.com>
Date:   Wed, 31 Aug 2022 16:17:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220831101631.13585-2-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/08/2022 11:16, Íñigo Huguet wrote:
> In preparation for the support of PTP over IPv6/UDP and Ethernet in next
> patches, allow a more flexible way of adding and removing RX filters for
> PTP. Right now, only 2 filters are allowed, which are the ones needed
> for PTP over IPv4/UDP.
> 
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
>  drivers/net/ethernet/sfc/ptp.c | 67 ++++++++++++++++------------------
>  1 file changed, 31 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
> index 10ad0b93d283..719005d79943 100644
> --- a/drivers/net/ethernet/sfc/ptp.c
> +++ b/drivers/net/ethernet/sfc/ptp.c
> @@ -118,6 +118,8 @@
>  
>  #define	PTP_MIN_LENGTH		63
>  
> +#define PTP_RXFILTERS_LEN	2
> +
>  #define PTP_ADDRESS		0xe0000181	/* 224.0.1.129 */
>  #define PTP_EVENT_PORT		319
>  #define PTP_GENERAL_PORT	320
> @@ -224,9 +226,8 @@ struct efx_ptp_timeset {
>   * @work: Work task
>   * @reset_required: A serious error has occurred and the PTP task needs to be
>   *                  reset (disable, enable).
> - * @rxfilter_event: Receive filter when operating
> - * @rxfilter_general: Receive filter when operating
> - * @rxfilter_installed: Receive filter installed
> + * @rxfilters: Receive filters when operating
> + * @rxfilters_count: Num of installed rxfilters, should be == PTP_RXFILTERS_LEN
>   * @config: Current timestamp configuration
>   * @enabled: PTP operation enabled
>   * @mode: Mode in which PTP operating (PTP version)
> @@ -295,9 +296,8 @@ struct efx_ptp_data {
>  	struct workqueue_struct *workwq;
>  	struct work_struct work;
>  	bool reset_required;
> -	u32 rxfilter_event;
> -	u32 rxfilter_general;
> -	bool rxfilter_installed;
> +	u32 rxfilters[PTP_RXFILTERS_LEN];
> +	size_t rxfilters_count;
>  	struct hwtstamp_config config;
>  	bool enabled;
>  	unsigned int mode;
> @@ -1290,61 +1290,56 @@ static void efx_ptp_remove_multicast_filters(struct efx_nic *efx)
>  {
>  	struct efx_ptp_data *ptp = efx->ptp_data;
>  
> -	if (ptp->rxfilter_installed) {
> -		efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
> -					  ptp->rxfilter_general);
> +	while (ptp->rxfilters_count) {
> +		ptp->rxfilters_count--;
>  		efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
> -					  ptp->rxfilter_event);
> -		ptp->rxfilter_installed = false;
> +					  ptp->rxfilters[ptp->rxfilters_count]);
>  	}
>  }
>  
> -static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
> +static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx, u16 port)
>  {
>  	struct efx_ptp_data *ptp = efx->ptp_data;
>  	struct efx_filter_spec rxfilter;
>  	int rc;
>  
> -	if (!ptp->channel || ptp->rxfilter_installed)
> -		return 0;
> -
> -	/* Must filter on both event and general ports to ensure
> -	 * that there is no packet re-ordering.
> -	 */

Rather than losing this comment...

>  	efx_filter_init_rx(&rxfilter, EFX_FILTER_PRI_REQUIRED, 0,
>  			   efx_rx_queue_index(
>  				   efx_channel_get_rx_queue(ptp->channel)));
> -	rc = efx_filter_set_ipv4_local(&rxfilter, IPPROTO_UDP,
> -				       htonl(PTP_ADDRESS),
> -				       htons(PTP_EVENT_PORT));
> -	if (rc != 0)
> -		return rc;
> +
> +	efx_filter_set_ipv4_local(&rxfilter, IPPROTO_UDP, htonl(PTP_ADDRESS),
> +				  htons(port));
>  
>  	rc = efx_filter_insert_filter(efx, &rxfilter, true);
>  	if (rc < 0)
>  		return rc;
> -	ptp->rxfilter_event = rc;
>  
> -	efx_filter_init_rx(&rxfilter, EFX_FILTER_PRI_REQUIRED, 0,
> -			   efx_rx_queue_index(
> -				   efx_channel_get_rx_queue(ptp->channel)));
> -	rc = efx_filter_set_ipv4_local(&rxfilter, IPPROTO_UDP,
> -				       htonl(PTP_ADDRESS),
> -				       htons(PTP_GENERAL_PORT));
> -	if (rc != 0)
> +	ptp->rxfilters[ptp->rxfilters_count] = rc;
> +	ptp->rxfilters_count++;
> +
> +	return 0;
> +}
> +
> +static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
> +{
> +	struct efx_ptp_data *ptp = efx->ptp_data;
> +	int rc;
> +
> +	if (!ptp->channel || ptp->rxfilters_count)
> +		return 0;
> +

... could it not migrate to here?
Otherwise looks good.
-ed

> +	rc = efx_ptp_insert_ipv4_filter(efx, PTP_EVENT_PORT);
> +	if (rc < 0)
>  		goto fail;
>  
> -	rc = efx_filter_insert_filter(efx, &rxfilter, true);
> +	rc = efx_ptp_insert_ipv4_filter(efx, PTP_GENERAL_PORT);
>  	if (rc < 0)
>  		goto fail;
> -	ptp->rxfilter_general = rc;
>  
> -	ptp->rxfilter_installed = true;
>  	return 0;
>  
>  fail:
> -	efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
> -				  ptp->rxfilter_event);
> +	efx_ptp_remove_multicast_filters(efx);
>  	return rc;
>  }
>  
> 

