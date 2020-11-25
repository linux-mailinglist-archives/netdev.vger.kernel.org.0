Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4732C4752
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 19:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732993AbgKYSMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 13:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731561AbgKYSMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 13:12:32 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4992C0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 10:12:31 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id t4so2797583wrr.12
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 10:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FZOEhscyBj1ACdZ6guFE/oaD3Q40uSkZlhGPtR+OapI=;
        b=ucHcCjLW7GO0EZbAtwD0Bo+uNd1LIXrlUJ/ykqQa79DyWunUmZLT3tkrciGMAgu5Ve
         Fxa/SH4KKoYmGt0NaC1NSVn/oiN8se0Tme6WHdyRkglZRCP75uHU4nmYWd315a03Gytj
         IrbfuVV830fJAKtVo22mQQ5ZSCx9ia5QFyV3mI5K8En9CxLSU0WD7i+DVBcvFKIcIsWV
         EVL9Tz6otFu5TlAGmfYeu+3VROkuhPFZl8gn5iKfqPdtBkmNKzhv4MW5H7bI2oDZP3CN
         Ui+pksvevnzTD6p5HDrXHvziAx0DI5u6RxataXQjRnedRUJmXGvZ865SJFRjjPxN9QgT
         DZWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FZOEhscyBj1ACdZ6guFE/oaD3Q40uSkZlhGPtR+OapI=;
        b=NsejZDkvxSs2hQcCGMY8NWST2rgkoEfyDVSzgo+xE4XslR1pNMcQ/8Dmr/zb14qMan
         Iox2YkbaB8novEPYr4WinNTk78GHIczC70szJW4qAFzo1+U3Odjo/2hL+KObZx5Sylnp
         F0mdvjCCTLKcMZAc0GyFRRzqk5bLS0Oy/zA+lxLvt4XdxUYFBSSipaZ1mxf2RJhxz4wF
         VBqdtWfOOYG8YkmKya5NF4Y6qZ2w54utmACIcofCThQmrCT8Ri2/7h9LSS5g++8tW4Su
         /8ZcRD+EDS5uhq4RwJM8hJpKRN6KAg/8HNiCtf6ytpW1ynxGzE31dQBCvPvvwaJePfml
         m5Fw==
X-Gm-Message-State: AOAM530r0Ct1mSbLCYAsvp6ScSA7ntkAwKY3ddS/tAqWqNQwDhhCs6T6
        PFpcgbUUhR04pqKdwrWNrLg=
X-Google-Smtp-Source: ABdhPJzwnfVtLk+O+fQ967pCE3AhYvhDvfNAT7IHShiINc8TXXmTxDCyKzIJ5RRSrS2uhVFKbnnv/g==
X-Received: by 2002:adf:82ca:: with SMTP id 68mr5446632wrc.332.1606327950627;
        Wed, 25 Nov 2020 10:12:30 -0800 (PST)
Received: from [192.168.8.114] ([37.165.192.132])
        by smtp.gmail.com with ESMTPSA id f19sm5273653wml.21.2020.11.25.10.12.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 10:12:29 -0800 (PST)
Subject: Re: [PATCH net-next v8 4/4] gve: Add support for raw addressing in
 the tx path
To:     David Awogbemila <awogbemila@google.com>, netdev@vger.kernel.org
Cc:     alexander.duyck@gmail.com, saeed@kernel.org,
        Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
References: <20201125173846.3033449-1-awogbemila@google.com>
 <20201125173846.3033449-5-awogbemila@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8ebc0d23-c513-2667-c59f-f42538c770f1@gmail.com>
Date:   Wed, 25 Nov 2020 19:12:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201125173846.3033449-5-awogbemila@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/25/20 6:38 PM, David Awogbemila wrote:
> From: Catherine Sullivan <csully@google.com>
> 



> +	if (tx->raw_addressing)
> +		nsegs = gve_tx_add_skb_no_copy(priv, tx, skb);
> +	else
> +		nsegs = gve_tx_add_skb_copy(priv, tx, skb);
> +
> +	/* If the packet is getting sent, we need to update the skb */
> +	if (nsegs) {
> +		netdev_tx_sent_queue(tx->netdev_txq, skb->len);
> +		skb_tx_timestamp(skb);
> +
> +		/* Give packets to NIC. Even if this packet failed to send the doorbell
> +		 * might need to be rung because of xmit_more.
> +		 */
> +		tx->req += nsegs;
>  
> -	if (!netif_xmit_stopped(tx->netdev_txq) && netdev_xmit_more())
> -		return NETDEV_TX_OK;
> +		if (!netif_xmit_stopped(tx->netdev_txq) && netdev_xmit_more())
> +			return NETDEV_TX_OK;
>  
> -	gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
> +		gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
> +	}
>  	return NETDEV_TX_OK;
>  }
>

Code does not match the comment (Give packets to NIC.
    Even if this packet failed to send the doorbell
    might need to be rung because of xmit_more.)

You probably meant :

    if (nsegs) {
        netdev_tx_sent_queue(tx->netdev_txq, skb->len);
        skb_tx_timestamp(skb);
        tx->req += nsegs;
        if (!netif_xmit_stopped(tx->netdev_txq) && netdev_xmit_more())
            return NETDEV_TX_OK;
    }
    gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
    return NETDEV_TX_OK;


Or

    if (nsegs) {
        netdev_tx_sent_queue(tx->netdev_txq, skb->len);
        skb_tx_timestamp(skb);
        tx->req += nsegs;
    }
    if (!netif_xmit_stopped(tx->netdev_txq) && netdev_xmit_more())
        return NETDEV_TX_OK;

    gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
    return NETDEV_TX_OK;

Also you forgot to free the skb if it was not sent (in case of mapping error in gve_tx_add_skb_no_copy())

So you probably need to call dev_kfree_skb_any(), or risk leaking memory and freeze sockets.

    if (nsegs) {
        netdev_tx_sent_queue(tx->netdev_txq, skb->len);
        skb_tx_timestamp(skb);
        tx->req += nsegs;
    } else {
        dev_kfree_skb_any(skb);
    }
    if (!netif_xmit_stopped(tx->netdev_txq) && netdev_xmit_more())
        return NETDEV_TX_OK;

    gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
    return NETDEV_TX_OK;
