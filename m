Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6351B4844
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgDVPJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 11:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgDVPJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:09:42 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8C4C03C1AC;
        Wed, 22 Apr 2020 08:09:42 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id 71so1872616qtc.12;
        Wed, 22 Apr 2020 08:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8c7hTySQReHi882ORjYoI2k/+/cgd95b2HG6MquGzOY=;
        b=M5N0FrsLlhirypGtKqTqIeHxTCQcQmd55VNkgey763C1wygubwK0x4n0Ly95j2+HRC
         g3hHOV08biMMIGndYVsy0aJEx4ZMEOnc5AO3lvgOWHZdoY4ls5nq7hUw1GPq484T04DU
         PSmnWXBQPEK1BX7vZlnxkPxCSOBHtYv5gPp4egqpm6qUpC/8gJ5tZesgsFk0wdaoNy5R
         1nL4c/n/Eu+onQAnlsqbwbXVBEu3udzIS1NmRpXRNzOn/l7tfthbuHQ7JdoOOheQE4Yl
         ZEJFMy5168oyi+PucxKRu/Basg4BX/tfx+fROpCnVGl6APJjc5R0Qc9g5HcOYUWhEzDI
         cFBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8c7hTySQReHi882ORjYoI2k/+/cgd95b2HG6MquGzOY=;
        b=h+A8TaZY44hzUt8V8egHyH9dtOtbjuDGpr8Rctl+fYEtfaddK7Q42B4nU2JjX2Z3eZ
         3aBYFtmbmpF959VNWvRFCB/siRPhW/zL/egniXqDSScFfokV3X0sfuowXEOEKKjX7oua
         4ZZnAYlTgsUMpD6lUzhCzyFQWViUGkhqNzV/tNHc8q4hBovZIY+W/Hk18mVlS9e8VfgX
         ipyPgYEcCQnJYFJj4J4n3fT+s+y3PFR8bQ+raCwFjFDTDo4QQFxdyZaMwUv+6RTurmYj
         Zvehz1Pflz85eecW0z4EBp/XvnuvDVBFHAF/Fctahrr8U2e3GSvXHR4R1D0nd6n52lRN
         kRDA==
X-Gm-Message-State: AGi0PuZWsajxCt6Pa6qDgb93POsbUeqyRJ0pdEEPaqMv49MyvA64EVVY
        bjSzdMYmWPuCWCIbtEzjpycEp3M6
X-Google-Smtp-Source: APiQypKLX+sXZA2f9KfpbnC4fWWYtobntcPpsJsZ6STaDKPVa+TLkkAPP2yfWrpBVORN9ux1gmUMcQ==
X-Received: by 2002:aed:3bda:: with SMTP id s26mr26982652qte.261.1587568181450;
        Wed, 22 Apr 2020 08:09:41 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c19e:4650:3a73:fee4? ([2601:282:803:7700:c19e:4650:3a73:fee4])
        by smtp.googlemail.com with ESMTPSA id p47sm4268828qta.44.2020.04.22.08.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 08:09:40 -0700 (PDT)
Subject: Re: [PATCH V4 mlx5-next 01/15] net/core: Introduce
 netdev_get_xmit_slave
To:     Maor Gottlieb <maorg@mellanox.com>, davem@davemloft.net,
        jgg@mellanox.com, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
References: <20200422083951.17424-1-maorg@mellanox.com>
 <20200422083951.17424-2-maorg@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <93110507-2ffe-c9f1-f53c-41c6968751ac@gmail.com>
Date:   Wed, 22 Apr 2020 09:09:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422083951.17424-2-maorg@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/20 2:39 AM, Maor Gottlieb wrote:
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 9c9e763bfe0e..294553551ba5 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -7785,6 +7785,36 @@ void netdev_bonding_info_change(struct net_device *dev,
>  }
>  EXPORT_SYMBOL(netdev_bonding_info_change);
>  
> +/**
> + * netdev_get_xmit_slave - Get the xmit slave of master device
> + * @skb: The packet
> + * @all_slaves: assume all the slaves are active
> + *
> + * This can be called from any context and does its own locking.
> + * The returned handle has the usage count incremented and the caller must
> + * use dev_put() to release it when it is no longer needed.
> + * %NULL is returned if no slave is found.
> + */
> +
> +struct net_device *netdev_get_xmit_slave(struct net_device *dev,
> +					 struct sk_buff *skb,
> +					 bool all_slaves)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	struct net_device *slave_dev;
> +
> +	if (!ops->ndo_get_xmit_slave)
> +		return NULL;
> +
> +	rcu_read_lock();
> +	slave_dev = ops->ndo_get_xmit_slave(dev, skb, all_slaves);
> +	if (slave_dev)
> +		dev_hold(slave_dev);
> +	rcu_read_unlock();
> +	return slave_dev;
> +}
> +EXPORT_SYMBOL(netdev_get_xmit_slave);
> +
>  static void netdev_adjacent_add_links(struct net_device *dev)
>  {
>  	struct netdev_adjacent *iter;
> 

The rcu_read_lock and reference seem overkill for a general purpose
helper. When this set goes in I want to make modifications for use with
XDP and that does not need either.

Looking at the mlx5 changes, you could easily handle that in the driver.
