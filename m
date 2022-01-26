Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102FD49C22B
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbiAZDe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiAZDey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:34:54 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C610C06173B;
        Tue, 25 Jan 2022 19:34:54 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id k17so3713937plk.0;
        Tue, 25 Jan 2022 19:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ov9OGHY82q9euRbCDxFngRVc4SYGjlQJ03V4ACD/UVQ=;
        b=KVxVTYqzn88rX/bJ8qTdJ4CrJTYcz7XTgBu68PJ9ywJ3C43jWiF1pnmNAxgxdGI81M
         I4TdCBpJGKrb80HMWO3svtHyHP+P4Y/bWnPMMRWRoGYhQDSxlZUlCB9F17cdyGzsfedG
         bQOp1BftFiTGERILt4bjA2+fy7YxzOW+YkbY8rab9FTU1a8RUFhtaFw++a12IHAayGK5
         zZnT/Ne9Jjwukr/9nantF2azTUKSXzPBbq6dYRdLIaSg12XbJtrasJtwvqmqe6s8BN7Y
         +9HbPOvCctnK24vr7WdfQv1FCnFrGmFK8fvVlPNTGONL2+fR2RO4CfPbLISjcMNMpESt
         OvAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ov9OGHY82q9euRbCDxFngRVc4SYGjlQJ03V4ACD/UVQ=;
        b=rCk4f4i+PWCMjGfUGaiiTit/M6GiBwAZNU6P50auFuTTFBhfwu87wtmdIt3fIOFRMR
         iNaRweu0s2RFJZDkDxU5FaWXPASlkgp/54/83Ldn9swW/da4Y9FD9BIj26ep9Q+tmsb5
         NUp6pP1U7Qe5XUiHjAcmIiWX9S/cH5U8UO4I1Hj/nVsYPtLxRY9bfhF6NO6Ip1TXdS5W
         pUkFSkGS1z7mEufpccBUgLLEwkK9X8Si9RRkTE+zzeYn7ayhD52+rkGwMbEkcY+Ky5N4
         Y0BK3N47dwD8X7+2MCuPz9pDsXb5pJaErHDT0vnArSypzAxCDOnxTIeBhBpxpWMGf6yq
         3B9Q==
X-Gm-Message-State: AOAM531sZKFnVFh7G8iTcsnT1SuvIQHPZOHQ6XOhis8b3b3viUomszyk
        ySPFgGaFeAIc718an1A4GsI=
X-Google-Smtp-Source: ABdhPJwewhqOhGT0zeZnC1LHq5V1AV+DMXZVC9xLTwky6g3lfW2BwDHOux4zwhY883eszSTU+6/Njg==
X-Received: by 2002:a17:902:8f8a:b0:149:8d21:9f44 with SMTP id z10-20020a1709028f8a00b001498d219f44mr21394197plo.15.1643168093835;
        Tue, 25 Jan 2022 19:34:53 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id q21sm419792pfj.94.2022.01.25.19.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 19:34:53 -0800 (PST)
Message-ID: <4a4f8880-9ea9-1aca-a202-18d5c50abd82@gmail.com>
Date:   Tue, 25 Jan 2022 19:34:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v7 08/16] net: dsa: tag_qca: add support for handling
 mgmt and MIB Ethernet packet
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-9-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220123013337.20945-9-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> Add connect/disconnect helper to assign private struct to the dsa switch.
> Add support for Ethernet mgm and MIB if the dsa driver provide an handler
> to correctly parse and elaborate the data.

s/mgm/mgmt/
s/dsa/DSA/


> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>   include/linux/dsa/tag_qca.h |  7 +++++++
>   net/dsa/tag_qca.c           | 39 ++++++++++++++++++++++++++++++++++---
>   2 files changed, 43 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
> index 87dd84e31304..de5a45f5b398 100644
> --- a/include/linux/dsa/tag_qca.h
> +++ b/include/linux/dsa/tag_qca.h
> @@ -72,4 +72,11 @@ struct mib_ethhdr {
>   	__be16 hdr;		/* qca hdr */
>   } __packed;
>   
> +struct qca_tagger_data {
> +	void (*rw_reg_ack_handler)(struct dsa_switch *ds,
> +				   struct sk_buff *skb);
> +	void (*mib_autocast_handler)(struct dsa_switch *ds,
> +				     struct sk_buff *skb);
> +};
> +
>   #endif /* __TAG_QCA_H */
> diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
> index fdaa1b322d25..dc81c72133eb 100644
> --- a/net/dsa/tag_qca.c
> +++ b/net/dsa/tag_qca.c
> @@ -5,6 +5,7 @@
>   
>   #include <linux/etherdevice.h>
>   #include <linux/bitfield.h>
> +#include <net/dsa.h>
>   #include <linux/dsa/tag_qca.h>
>   
>   #include "dsa_priv.h"
> @@ -32,11 +33,16 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
>   
>   static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
>   {
> +	struct qca_tagger_data *tagger_data;
> +	struct dsa_port *dp = dev->dsa_ptr;
> +	struct dsa_switch *ds = dp->ds;
>   	u16 hdr, pk_type;
>   	__be16 *phdr;
>   	int port;
>   	u8 ver;
>   
> +	tagger_data = ds->tagger_data;
> +
>   	if (unlikely(!pskb_may_pull(skb, QCA_HDR_LEN)))
>   		return NULL;
>   
> @@ -51,13 +57,19 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
>   	/* Get pk type */
>   	pk_type = FIELD_GET(QCA_HDR_RECV_TYPE, hdr);
>   
> -	/* Ethernet MDIO read/write packet */
> -	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK)
> +	/* Ethernet mgmt read/write packet */
> +	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK) {
> +		if (tagger_data->rw_reg_ack_handler)

if (likely()) in case that happens to make a difference?

> +			tagger_data->rw_reg_ack_handler(ds, skb);
>   		return NULL;
> +	}
>   
>   	/* Ethernet MIB counter packet */
> -	if (pk_type == QCA_HDR_RECV_TYPE_MIB)
> +	if (pk_type == QCA_HDR_RECV_TYPE_MIB) {
> +		if (tagger_data->mib_autocast_handler)

Likewise

In any case, this looks good to me:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
