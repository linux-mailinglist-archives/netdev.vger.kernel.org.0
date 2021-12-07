Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A63146B1BF
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 05:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbhLGEQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 23:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhLGEQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 23:16:04 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115FBC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 20:12:35 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso16426717otj.11
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 20:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rcYcVIAVKU7s2pRadPqnQu1dTYSXxdzVcLZvqzF6IuY=;
        b=Nw/qGzp39wAxAvZ4jxMYqQM+uM/nCdqkP57woESzTkfbQhjLbEVlV6gLva3MQyTwhL
         kKgdOnWeTDuh+iZFGC19G3PsLF+IEhqPKgB+OXhqJxa3Lokq4E9mmD+nIhJuZth7sBJp
         wc3mktoTo0uyOe3xPF/R+MrFRDIMjg/VGXeTtYmHTFCIqxbYCr6apzxfGJyaRFPdSGFc
         h2HFA6XzeEgTx6YwI0sMD6sTd1Ki8ark+C9ya8EJP4OwcMg2klo4p3QqogkF0IjKoo9l
         vw7uAcQSWQ54bxgZ8rB4/BZTqnNQo3AwD6HsquD4MqhvP/5PILcBwo2qreBeHLGjJL6A
         7NNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rcYcVIAVKU7s2pRadPqnQu1dTYSXxdzVcLZvqzF6IuY=;
        b=lhDsTuvYgXy0zpgJ7ucjlhBJqBNUX0nGjvoi6brCd9cf7eiYB08bmZoQ3rph0TP2fQ
         ZtB9XUYpsJt1rN3ergOd0OpTHj9JFQMgF5Nk3kwWszT6IW1w7g2OpZXzTYGZTdEUgFPz
         ALlHqpHbzhIKuiSFXf1ijrcKyJLTyu+LlSgYfxGut5YTKoFgK3c9uueWMQKnN4azmhcB
         yDzaUFNO/w5I5jF8/oXlUtti69q4U3ht8dT/6QO7/0coRT/JnyjN5HdsokwsoSPVwujO
         jbNzF5ou1TDDr/k7dnOabfP1zNYFxb+QLwfWUlO/10QNynXC3RqVLO4mOlDmNgasJC6k
         rpWg==
X-Gm-Message-State: AOAM5336JHQXL+aM9li8J6n85sq5Vm5NddkvGXx8TyziY5A6fMfycy4a
        FWyUxVlPNDMih6KaZmWGOWA=
X-Google-Smtp-Source: ABdhPJw4BZYQWAhGBOuKZ0trwbucxCeMsg8Mi4OZ+VqAjWwCaDUP+3uYULvLOBj78tsG8C/+indYUQ==
X-Received: by 2002:a9d:433:: with SMTP id 48mr33450678otc.360.1638850354397;
        Mon, 06 Dec 2021 20:12:34 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id l23sm2642560oti.16.2021.12.06.20.12.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 20:12:34 -0800 (PST)
Message-ID: <e5d8a127-fc98-4b3d-7887-a5398951a9a0@gmail.com>
Date:   Mon, 6 Dec 2021 21:12:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice
 bulk deletion
Content-Language: en-US
To:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org
Cc:     kuba@kernel.org, nikolay@nvidia.com
References: <20211205093658.37107-1-lschlesinger@drivenets.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211205093658.37107-1-lschlesinger@drivenets.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/5/21 2:36 AM, Lahav Schlesinger wrote:
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index fd030e02f16d..5165cc699d97 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -37,6 +37,7 @@
>  #include <linux/pci.h>
>  #include <linux/etherdevice.h>
>  #include <linux/bpf.h>
> +#include <linux/sort.h>
>  
>  #include <linux/uaccess.h>
>  
> @@ -1880,6 +1881,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
>  	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
>  	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
>  	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
> +	[IFLA_IFINDEX]		= { .type = NLA_S32 },

you need to make sure this new attribute can not be used in setlink
requests or getlink.

>  };
>  
>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
> @@ -3050,6 +3052,78 @@ static int rtnl_group_dellink(const struct net *net, int group)
>  	return 0;
>  }
>  
> +static int dev_ifindex_cmp(const void *a, const void *b)
> +{
> +	struct net_device * const *dev1 = a, * const *dev2 = b;

const struct net_device *dev1 = 1, *dev2 = b;

> +
> +	return (*dev1)->ifindex - (*dev2)->ifindex;
> +}
> +
> +static int rtnl_ifindex_dellink(struct net *net, struct nlattr *head, int len,
> +				struct netlink_ext_ack *extack)
> +{
> +	int i = 0, num_devices = 0, rem;
> +	struct net_device **dev_list;
> +	const struct nlattr *nla;
> +	LIST_HEAD(list_kill);
> +	int ret;
> +
> +	nla_for_each_attr(nla, head, len, rem) {
> +		if (nla_type(nla) == IFLA_IFINDEX)
> +			num_devices++;
> +	}


The need to walk the list twice (3 really with the sort) to means the
array solution is better.

> +
> +	dev_list = kmalloc_array(num_devices, sizeof(*dev_list), GFP_KERNEL);
> +	if (!dev_list)
> +		return -ENOMEM;
> +
> +	nla_for_each_attr(nla, head, len, rem) {
> +		const struct rtnl_link_ops *ops;
> +		struct net_device *dev;
> +		int ifindex;
> +
> +		if (nla_type(nla) != IFLA_IFINDEX)
> +			continue;

and this business too. We have arrays in other places
(net/ipv4/nexthop.c), so this is not the first.


> +
> +		ifindex = nla_get_s32(nla);
> +		ret = -ENODEV;
> +		dev = __dev_get_by_index(net, ifindex);
> +		if (!dev) {
> +			NL_SET_ERR_MSG_ATTR(extack, nla, "Unknown ifindex");
> +			goto out_free;
> +		}
> +
> +		ret = -EOPNOTSUPP;
> +		ops = dev->rtnl_link_ops;
> +		if (!ops || !ops->dellink) {
> +			NL_SET_ERR_MSG_ATTR(extack, nla, "Device cannot be deleted");
> +			goto out_free;
> +		}
> +
> +		dev_list[i++] = dev;
> +	}
> +
> +	/* Sort devices, so we could skip duplicates */
> +	sort(dev_list, num_devices, sizeof(*dev_list), dev_ifindex_cmp, NULL);

how did this sort change the results? 10k compares and re-order has to
add some overhead.

> +
> +	for (i = 0; i < num_devices; i++) {
> +		struct net_device *dev = dev_list[i];
> +
> +		if (i != 0 && dev_list[i - 1]->ifindex == dev->ifindex)

		if (i && ...)


I liked the array variant better. Jakub?
