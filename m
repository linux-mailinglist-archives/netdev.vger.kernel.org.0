Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986961B484E
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgDVPMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 11:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbgDVPMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:12:32 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9F1C03C1A9;
        Wed, 22 Apr 2020 08:12:20 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id p13so993719qvt.12;
        Wed, 22 Apr 2020 08:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JTzdhB0FYtmDGjYGqKEWMftcPVV+yp0ptGTyaITEGgw=;
        b=Ew7MRsn73POUDhyKPWT5OB1gyAMLa1VJZVhvQ4z40K+2jnaFYj52YQtRya2I3tq8AZ
         cRwQp/61gl5x6Pu5ppk7TV5ojwsEze8fqve/uphr7rmsfRPrmJDTY3rjMwK6BeVnnRUi
         /5FQFGsgun0CEN8hnHrO30cDpkfrdCAxmkfRGRk5K6Yb1QrEGQHdoYkP3Xro30sNDchR
         CBCs8g9bogEh02+g+OrxqIWyt6T/Vl80VsmXrHBlrn7AWFJdeoI/J7X1hlluakb/Omm0
         +9qrHZR8E6C2uFAeEg1Ip0+di/vSS/MMho09H6uDsSHBDNRLWmRu9YclGKx3WlSvoeWp
         4QNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JTzdhB0FYtmDGjYGqKEWMftcPVV+yp0ptGTyaITEGgw=;
        b=EGkcvfKNtiMGPQwf7IOVCwFelHDoUjxDxsXtNH/tyD2w4qI9I/89vvlcWcn/yANclQ
         ActGuQaoCgfV/dHLACt20NTGTH3C2BvhSLRoMD0ozi7WHn1dL8HsbOAwta0r/mC8kEUv
         ewlI+G7JuGx2bzEHQg7I+x6uRToTDuyT7ex2yWseXSe1ArVyN4dxpU2YQUTIoXdxyTNl
         ugAxyUC3uCtVPBEEBczqFdb/sIkLhb3ln2KzPTDMvSrG790anUAXmk3zAPjzjvYP0knI
         4pzzwWj6Ph/Gb7htuNY7YFq6K0gjAiVECy22X3k/gYMp/jLiekQJgJNz7CNkaOQ1hjLD
         nN8A==
X-Gm-Message-State: AGi0PuZeBaC9EGq7cqShPLKt3C3p1COsWtWdcr5iFOyMal0mM6MmsdYS
        qVttMYeYXBS0szj4SHYSPXg=
X-Google-Smtp-Source: APiQypIpon7py0HWdgPdIPLMoTXPF2g6GOap8Xeda0mJuLr7jLs9bhAl7pTZqjpO5ZusWvh1Jlrnyw==
X-Received: by 2002:ad4:4f14:: with SMTP id fb20mr5294394qvb.46.1587568339921;
        Wed, 22 Apr 2020 08:12:19 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c19e:4650:3a73:fee4? ([2601:282:803:7700:c19e:4650:3a73:fee4])
        by smtp.googlemail.com with ESMTPSA id 70sm4104743qkh.67.2020.04.22.08.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 08:12:19 -0700 (PDT)
Subject: Re: [PATCH V4 mlx5-next 10/15] RDMA/core: Add LAG functionality
To:     Maor Gottlieb <maorg@mellanox.com>, davem@davemloft.net,
        jgg@mellanox.com, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
References: <20200422083951.17424-1-maorg@mellanox.com>
 <20200422083951.17424-11-maorg@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bb659995-ede0-72a3-7b43-582c18cffc5e@gmail.com>
Date:   Wed, 22 Apr 2020 09:12:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422083951.17424-11-maorg@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/20 2:39 AM, Maor Gottlieb wrote:
> Add support to get the RoCE LAG xmit slave by building skb
> of the RoCE packet and call to master_get_xmit_slave.

update the ndo name

...

> +static struct net_device *rdma_get_xmit_slave_udp(struct ib_device *device,
> +						  struct net_device *master,
> +						  struct rdma_ah_attr *ah_attr)
> +{
> +	struct net_device *slave;
> +	struct sk_buff *skb;
> +
> +	skb = rdma_build_skb(device, master, ah_attr);
> +	if (!skb)
> +		return NULL;
> +
> +	slave = netdev_get_xmit_slave(master, skb,
> +				      !!(device->lag_flags &
> +					 RDMA_LAG_FLAGS_HASH_ALL_SLAVES));
> +	kfree_skb(skb);
> +	return slave;
> +}
> +
> +void rdma_lag_put_ah_roce_slave(struct rdma_ah_attr *ah_attr)
> +{
> +	if (ah_attr->roce.xmit_slave)
> +		dev_put(ah_attr->roce.xmit_slave);
> +}
> +
> +int rdma_lag_get_ah_roce_slave(struct ib_device *device,
> +			       struct rdma_ah_attr *ah_attr)
> +{
> +	struct net_device *master;
> +	struct net_device *slave;
> +
> +	if (!(ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE &&
> +	      ah_attr->grh.sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP))
> +		return 0;
> +
> +	rcu_read_lock();
> +	master = rdma_read_gid_attr_ndev_rcu(ah_attr->grh.sgid_attr);
> +	if (IS_ERR(master)) {
> +		rcu_read_unlock();
> +		return PTR_ERR(master);
> +	}
> +	dev_hold(master);
> +	rcu_read_unlock();
> +
> +	if (!netif_is_bond_master(master)) {
> +		dev_put(master);
> +		return 0;
> +	}
> +
> +	slave = rdma_get_xmit_slave_udp(device, master, ah_attr);
> +
> +	dev_put(master);

you will simplify this a bit by moving the rdma_get_xmit_slave_udp up to
the rcu_read section above.


> +	if (!slave) {
> +		ibdev_warn(device, "Failed to get lag xmit slave\n");
> +		return -EINVAL;
> +	}
> +
> +	ah_attr->roce.xmit_slave = slave;
> +
> +	return 0;
> +}
