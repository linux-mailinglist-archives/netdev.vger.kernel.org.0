Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C338B21A4E6
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 18:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgGIQdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 12:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbgGIQdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 12:33:43 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8A6C08C5CE;
        Thu,  9 Jul 2020 09:33:42 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id u12so2099449qth.12;
        Thu, 09 Jul 2020 09:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MQBjIaBYMqlIdAwvlJg1lqSvZHONUPxfvX8//B1P8MM=;
        b=NTGk1Bnhiicl+ed43Sf94aPx/79agj0Vb5olpcvutljTkdsrYhwvLY0ItOmpXjZvov
         vIu2jy9wDnwuE9dsxnggmrG/QHoxOoleQOV+iiyD1lw9iqg/WcjLqRdNYDAsFfP8BMwL
         robYPbxpepm+sPavoklYuacK5oOxE9Wr+Pm+IE66a+NDo4d7IL/TCBKynGdltA0/7Oy1
         pL5z/Fgu5zJZWzt3I5UsMs7oRz2zbeqkCZNl2X+uzuWVqOpfyKwY9f6lFQdNLecInLSf
         PGya5G9mU6aQjEKMgIbmPLi6592ezhpUYylp/RBY6D2rHiu1HUIygk65Qwot+E/nvPR7
         8Plw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MQBjIaBYMqlIdAwvlJg1lqSvZHONUPxfvX8//B1P8MM=;
        b=oU+JO3kRCKwFRqGS68TDEiWnNpDZ0S78ap68oHGGDylw5o6qiNTui84gnP6KtNE/Fs
         kiZ916K0z+1b6XPiwyqplJItI3blR5F85QF1AJo4xsdWOzxElPK8WEkq/il4FvngBwpx
         urUmbM/My3rm/BEoUiFISbQmHs8a44oIE2RR03r2Qdjptzvxqf/LVYyyvMszuGhf3Brn
         sRqMwV80qaVqOmwhQwk/iV5415WBnhB8scncnHGa9vm33tqeolKYz7QBLAidcHCDPoQo
         cDOi8V1KHFhMNGWZgcN40MBAoE6NHiKmKOv+Xrb37IAbP2XPL7qu9KIV+3MyVpLIPnsG
         gktA==
X-Gm-Message-State: AOAM531grNVlXq7HZY+wsVYHyKQSXZxJckPcUxfD61Vn4Zt4nxY6zuBf
        /PRSve7O+3MoIRg9SkevVXI=
X-Google-Smtp-Source: ABdhPJwhGj4BDaA07Oqf0koAbn+YLaHKw71sFevVTzfkl9kOy8EWffM8nVNk3L84B6PDlIt7CNquCw==
X-Received: by 2002:ac8:40cd:: with SMTP id f13mr64388940qtm.373.1594312421997;
        Thu, 09 Jul 2020 09:33:41 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:94b4:214e:fabf:bc82? ([2601:282:803:7700:94b4:214e:fabf:bc82])
        by smtp.googlemail.com with ESMTPSA id b22sm4077699qka.43.2020.07.09.09.33.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 09:33:41 -0700 (PDT)
Subject: Re: [PATCHv6 bpf-next 1/3] xdp: add a new helper for dev map
 multicast support
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
References: <20200701041938.862200-1-liuhangbin@gmail.com>
 <20200709013008.3900892-1-liuhangbin@gmail.com>
 <20200709013008.3900892-2-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <efcdf373-7add-cce1-17a3-03ddf38e0749@gmail.com>
Date:   Thu, 9 Jul 2020 10:33:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200709013008.3900892-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/20 7:30 PM, Hangbin Liu wrote:
> This patch is for xdp multicast support. In this implementation we
> add a new helper to accept two maps: forward map and exclude map.
> We will redirect the packet to all the interfaces in *forward map*, but
> exclude the interfaces that in *exclude map*.
> 

good feature. I bet we could use this to create a simpler xdp dumper -
redirect to an xdpmon device which converts to an skb and passes to any
attached sockets.


> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 10abb06065bb..617a51391971 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -512,6 +512,160 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>  	return __xdp_enqueue(dev, xdp, dev_rx);
>  }
>  
> +/* Use direct call in fast path instead of map->ops->map_get_next_key() */
> +static int devmap_get_next_key(struct bpf_map *map, void *key, void *next_key)
> +{
> +
> +	switch (map->map_type) {
> +	case BPF_MAP_TYPE_DEVMAP:
> +		return dev_map_get_next_key(map, key, next_key);
> +	case BPF_MAP_TYPE_DEVMAP_HASH:
> +		return dev_map_hash_get_next_key(map, key, next_key);
> +	default:
> +		break;
> +	}
> +
> +	return -ENOENT;
> +}
> +
> +bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map,
> +			int exclude_ifindex)
> +{
> +	struct bpf_dtab_netdev *ex_obj = NULL;
> +	u32 key, next_key;
> +	int err;
> +
> +	if (obj->dev->ifindex == exclude_ifindex)
> +		return true;
> +
> +	if (!map)
> +		return false;
> +
> +	err = devmap_get_next_key(map, NULL, &key);
> +	if (err)
> +		return false;
> +
> +	for (;;) {
> +		switch (map->map_type) {
> +		case BPF_MAP_TYPE_DEVMAP:
> +			ex_obj = __dev_map_lookup_elem(map, key);
> +			break;
> +		case BPF_MAP_TYPE_DEVMAP_HASH:
> +			ex_obj = __dev_map_hash_lookup_elem(map, key);
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		if (ex_obj && ex_obj->dev->ifindex == obj->dev->ifindex)

I'm probably missing something fundamental, but why do you need to walk
the keys? Why not just do a lookup on the device index?

> +			return true;
> +
> +		err = devmap_get_next_key(map, &key, &next_key);
> +		if (err)
> +			break;
> +
> +		key = next_key;
> +	}
> +
> +	return false;
> +}
> +




> @@ -3741,6 +3810,34 @@ static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
>  	.arg3_type      = ARG_ANYTHING,
>  };
>  
> +BPF_CALL_3(bpf_xdp_redirect_map_multi, struct bpf_map *, map,
> +	   struct bpf_map *, ex_map, u64, flags)
> +{
> +	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
> +
> +	if (unlikely(!map || flags > BPF_F_EXCLUDE_INGRESS))

If flags is a bitfield, the check should be:
    flags & ~BPF_F_EXCLUDE_INGRESS
