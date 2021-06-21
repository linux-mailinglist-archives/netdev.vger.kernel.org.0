Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C133AE39A
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 09:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhFUHDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 03:03:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229583AbhFUHDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 03:03:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624258858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HQFRq3mpghTE6F5mipIBX+93ihd5txbY1/8rGs2ilY8=;
        b=beYAllaJ7TAj+kKTObkQEJ3Mdi6jhejmX19NfWV62U1Z8ptu4gNvioc6PkeIyfsoXpqHBu
        QAffmRds9hTM/JRe59GClUNnJxp3zDAAEOWnmhwnburQyMQawSbP41NJ9QN55FWEacjTNR
        DhV4Roktz416oJ+GNCaLJxHD0MzQprk=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-uyhXQ2mhM4ayghLA35UIkQ-1; Mon, 21 Jun 2021 03:00:54 -0400
X-MC-Unique: uyhXQ2mhM4ayghLA35UIkQ-1
Received: by mail-pl1-f197.google.com with SMTP id o16-20020a170902d4d0b029012534a63229so599317plg.2
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 00:00:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=HQFRq3mpghTE6F5mipIBX+93ihd5txbY1/8rGs2ilY8=;
        b=amd37L8FuwNHCYTJbHeoCTrloRiBaD0AP765SCYPIN495gU/uBTUylcd4bcEvNBZQc
         imiv9L0HxJAuognC3Vz0u9tzPUsP8Kj1Nbaa/BJ1EPaa4LPKyKrSRxBt+GHs6DnCYqyk
         YIr1e7bI+sOhti0Xf2gKMH45CNwSkriOT9mWLy7HrcQlxLEtBwQX2lLx7I5MdAOV6VVI
         Ln+YS9+0+f6mNm5roH5/iEOluvikWC9pS+9OmkJjM046LbVlMjszio84kxbY+EHQfdHw
         SUWyFLRAtnvXz3q0h5/YxJY1W9Ce/oyIwiAfMAv0x5ChpyGbpp4UG1zIT92LdXQjIBuK
         DxMw==
X-Gm-Message-State: AOAM5327o1QxIfyQh25DPw9xkfC07kSkrl5PBqIu77ZhrABsoPAtsc3L
        M3AjeCecyKXrg7M+rBtkEL0cRXwqb1QCaacLskj9gal0QZSdZ/+mAh1rV0nZWXukIJ7+wG2BzJg
        LnDiQpfo60gzfrnsqQjtjOimOEXxzkrQAjJlpVQkbUc2YgJCAT3hAfWYrVrRebbaWf+4I
X-Received: by 2002:a63:c058:: with SMTP id z24mr1972330pgi.264.1624258853573;
        Mon, 21 Jun 2021 00:00:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx124WnrWwO4301vtwjsrWt0ubMK7cnHdJ8/jeTqZtolXqXqAxuuMHd0HMW8cuLn+WG9SKscg==
X-Received: by 2002:a63:c058:: with SMTP id z24mr1972307pgi.264.1624258853292;
        Mon, 21 Jun 2021 00:00:53 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id oc10sm13604246pjb.44.2021.06.21.00.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 00:00:52 -0700 (PDT)
Subject: Re: [PATCH] net: tun: fix tun_xdp_one() for IFF_TUN mode
To:     David Woodhouse <dwmw2@infradead.org>,
        netdev <netdev@vger.kernel.org>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e832b356-ffc2-8bca-f5d9-75e8b98cfcf2@redhat.com>
Date:   Mon, 21 Jun 2021 15:00:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/19 下午9:33, David Woodhouse 写道:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> In tun_get_user(), skb->protocol is either taken from the tun_pi header
> or inferred from the first byte of the packet in IFF_TUN mode, while
> eth_type_trans() is called only in the IFF_TAP mode where the payload
> is expected to be an Ethernet frame.
>
> The alternative path in tun_xdp_one() was unconditionally using
> eth_type_trans(), which corrupts packets in IFF_TUN mode. Fix it to
> do the correct thing for IFF_TUN mode, as tun_get_user() does.
>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Fixes: 043d222f93ab ("tuntap: accept an array of XDP buffs through sendmsg()")
> ---
> How is my userspace application going to know that the kernel has this
> fix? Should we add a flag to TUN_FEATURES to show that vhost-net in
> *IFF_TUN* mode is supported?


I think it's probably too late to fix? Since it should work before 
043d222f93ab.

The only way is to backport this fix to stable.


>
>   drivers/net/tun.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 43 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 4cf38be26dc9..f812dcdc640e 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2394,8 +2394,50 @@ static int tun_xdp_one(struct tun_struct *tun,
>   		err = -EINVAL;
>   		goto out;
>   	}
> +	switch (tun->flags & TUN_TYPE_MASK) {
> +	case IFF_TUN:
> +		if (tun->flags & IFF_NO_PI) {
> +			u8 ip_version = skb->len ? (skb->data[0] >> 4) : 0;
> +
> +			switch (ip_version) {
> +			case 4:
> +				skb->protocol = htons(ETH_P_IP);
> +				break;
> +			case 6:
> +				skb->protocol = htons(ETH_P_IPV6);
> +				break;
> +			default:
> +				atomic_long_inc(&tun->dev->rx_dropped);
> +				kfree_skb(skb);
> +				err = -EINVAL;
> +				goto out;
> +			}
> +		} else {
> +			struct tun_pi *pi = (struct tun_pi *)skb->data;
> +			if (!pskb_may_pull(skb, sizeof(*pi))) {
> +				atomic_long_inc(&tun->dev->rx_dropped);
> +				kfree_skb(skb);
> +				err = -ENOMEM;
> +				goto out;
> +			}
> +			skb_pull_inline(skb, sizeof(*pi));
> +			skb->protocol = pi->proto;
> +		}
> +
> +		skb_reset_mac_header(skb);
> +		skb->dev = tun->dev;
> +		break;
> +	case IFF_TAP:
> +		if (!pskb_may_pull(skb, ETH_HLEN)) {
> +			atomic_long_inc(&tun->dev->rx_dropped);
> +			kfree_skb(skb);
> +			err = -ENOMEM;
> +			goto out;
> +		}
> +		skb->protocol = eth_type_trans(skb, tun->dev);
> +		break;


I wonder whether we can have some codes unification with tun_get_user().

Thanks


> +	}
>   
> -	skb->protocol = eth_type_trans(skb, tun->dev);
>   	skb_reset_network_header(skb);
>   	skb_probe_transport_header(skb);
>   	skb_record_rx_queue(skb, tfile->queue_index);

