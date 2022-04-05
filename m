Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8910E4F4105
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384343AbiDEOYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389240AbiDENd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 09:33:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C21A7DEB99
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 05:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649162205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=804HT8SjfbVYXmUKw0nZ/AD8aYvBB74vMh4fZSUu+vg=;
        b=J2aC7n2NapgAyt6Iew5spwE9QlfPiyOD3MlxCZjGjZB+TCIdbZEySs2bFp7Fu9H5OIhPp8
        faogHVr0rkU0RjHgmAiLv/g2dWXnua4ulmh/JpgJLQzbdlnPOOBO5u2nHfZGvGt5Dijl5R
        VPrAfHjQ0TgiTiNJLOcmWAkAGxdl1sc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-7AUJsgcMME2Z8_jYuOAmcw-1; Tue, 05 Apr 2022 08:36:44 -0400
X-MC-Unique: 7AUJsgcMME2Z8_jYuOAmcw-1
Received: by mail-ed1-f71.google.com with SMTP id d19-20020aa7d5d3000000b0041cd772fb03so2991227eds.9
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 05:36:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=804HT8SjfbVYXmUKw0nZ/AD8aYvBB74vMh4fZSUu+vg=;
        b=w1NQhteqeDdQUVmUhpRivgJ0I3cRWnYvJQdLbxruKCjvDsAJIhV4ybT7FS4K9PiF3y
         tDhV9alFBKNdBE/NWDnuiIN5tE17ccw1EjPRXtC9WCIJ5z2kzjDNly8CR+fAGko8Vw8s
         Slfj95QMrWOxu1PQQyeegtzsqhsYrT2LyFA6jH0Lzmn2+rFFo8qMgQ/uTg1y1atHUxGl
         W+q2XQc0YbTpwNyTutB/f0OY4/qsR6V7csMcqPS9LsY6QIiJT60ZnAqso+IjYweqO+8o
         R6pZnju2HVe7uD1S51DekzuItpaA9vyMWBoEP5PfM36T3soAN2xWluy2C7XnXCdzp5mf
         TFUg==
X-Gm-Message-State: AOAM532LRmPlDFEa6CkUeDcqndCdJSy96DonsN+8qaZph4AIr9M8QPUd
        y7Ch7pljKy9mlESVW3q5qig6+FDJD+B+0AteDFWEBSYK+m/O90HnnTqNGvZNSpf+BDigcvnr8Hx
        uQu4lzpCF7IHqno3y
X-Received: by 2002:a50:ff02:0:b0:419:2d32:44fe with SMTP id a2-20020a50ff02000000b004192d3244femr3340877edu.49.1649162203652;
        Tue, 05 Apr 2022 05:36:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9AtGEgFvSWo3lUpB+5R90p9sRKfkZxZa/BELiSIH7ehc53aV1e1HVT28J/yZ5TGPjAn8ojA==
X-Received: by 2002:a50:ff02:0:b0:419:2d32:44fe with SMTP id a2-20020a50ff02000000b004192d3244femr3340851edu.49.1649162203419;
        Tue, 05 Apr 2022 05:36:43 -0700 (PDT)
Received: from [192.168.2.20] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id a1-20020a50da41000000b0041c83587300sm6014209edk.36.2022.04.05.05.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 05:36:42 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <88cf07a2-3bb6-5eda-0d99-d9491fd18669@redhat.com>
Date:   Tue, 5 Apr 2022 14:36:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, maximmi@nvidia.com,
        alexandr.lobakin@intel.com
Subject: Re: [PATCH bpf-next 05/10] ixgbe: xsk: terminate NAPI when XSK Rx
 queue gets full
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
 <20220405110631.404427-6-maciej.fijalkowski@intel.com>
In-Reply-To: <20220405110631.404427-6-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05/04/2022 13.06, Maciej Fijalkowski wrote:
> Correlate -ENOBUFS that was returned from xdp_do_redirect() with a XSK
> Rx queue being full. In such case, terminate the softirq processing and
> let the user space to consume descriptors from XSK Rx queue so that
> there is room that driver can use later on.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>   .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  1 +
>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 23 ++++++++++++-------
>   2 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> index bba3feaf3318..f1f69ce67420 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> @@ -8,6 +8,7 @@
>   #define IXGBE_XDP_CONSUMED	BIT(0)
>   #define IXGBE_XDP_TX		BIT(1)
>   #define IXGBE_XDP_REDIR		BIT(2)
> +#define IXGBE_XDP_EXIT		BIT(3)
>   
>   #define IXGBE_TXD_CMD (IXGBE_TXD_CMD_EOP | \
>   		       IXGBE_TXD_CMD_RS)
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> index dd7ff66d422f..475244a2c6e4 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -109,9 +109,10 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
>   
>   	if (likely(act == XDP_REDIRECT)) {
>   		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
> -		if (err)
> -			goto out_failure;
> -		return IXGBE_XDP_REDIR;
> +		if (!err)
> +			return IXGBE_XDP_REDIR;
> +		result = (err == -ENOBUFS) ? IXGBE_XDP_EXIT : IXGBE_XDP_CONSUMED;
> +		goto out_failure;
>   	}
>   
>   	switch (act) {
> @@ -130,6 +131,9 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
>   		if (result == IXGBE_XDP_CONSUMED)
>   			goto out_failure;
>   		break;
> +	case XDP_DROP:
> +		result = IXGBE_XDP_CONSUMED;
> +		break;
>   	default:
>   		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
>   		fallthrough;
> @@ -137,9 +141,6 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
>   out_failure:
>   		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
>   		fallthrough; /* handle aborts by dropping packet */
> -	case XDP_DROP:
> -		result = IXGBE_XDP_CONSUMED;
> -		break;
>   	}
>   	return result;
>   }
> @@ -304,10 +305,16 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
>   		xdp_res = ixgbe_run_xdp_zc(adapter, rx_ring, bi->xdp);
>   
>   		if (xdp_res) {
> -			if (xdp_res & (IXGBE_XDP_TX | IXGBE_XDP_REDIR))
> +			if (xdp_res == IXGBE_XDP_EXIT) {

Micro optimization note: Having this as the first if()-statement
defaults the compiler to think this is the likely() case. (But compilers
can obviously be smarter and can easily choose that the IXGBE_XDP_REDIR
branch is so simple that it takes it as the likely case).
Just wanted to mention this, given this is fash-path code.

> +				failure = true;
> +				xsk_buff_free(bi->xdp);
> +				ixgbe_inc_ntc(rx_ring);
> +				break;

I was wondering if we have a situation where we should set xdp_xmit bit
to trigger the call to xdp_do_flush_map later in function, but I assume
you have this covered.

> +			} else if (xdp_res & (IXGBE_XDP_TX | IXGBE_XDP_REDIR)) {
>   				xdp_xmit |= xdp_res;
> -			else
> +			} else {
>   				xsk_buff_free(bi->xdp);
> +			}
>   
>   			bi->xdp = NULL;
>   			total_rx_packets++;

