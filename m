Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30742CEDB3
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgLDMJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:09:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728162AbgLDMJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:09:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607083677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YSihSOsWFmLzIa7KPfAOw3HjE0N1/4AahcgnwcmoJog=;
        b=Nu+lutG9JLRLOyTY3As+oYFoV48OF3us6EWFWhnTlcFphhSB8E3ggJkyORCb7XK1zw5zpm
        SZyfADkhqqBbW469WPTRVXO4wvLGJP5J18YQfgaz2M3VN2aNbF1OCZYOC9qW+L0VFUBQyw
        w3nRkD5D/yHowap/53/zvuiL9cQJ75I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-GNRffqxnO026qXfrPzNb7A-1; Fri, 04 Dec 2020 07:07:53 -0500
X-MC-Unique: GNRffqxnO026qXfrPzNb7A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43FC6190B2A2;
        Fri,  4 Dec 2020 12:07:52 +0000 (UTC)
Received: from [10.36.112.238] (ovpn-112-238.ams2.redhat.com [10.36.112.238])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B6A8027C55;
        Fri,  4 Dec 2020 12:07:50 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Wang Hai" <wanghai38@huawei.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] openvswitch: fix error return code in
 validate_and_copy_dec_ttl()
Date:   Fri, 04 Dec 2020 13:07:48 +0100
Message-ID: <40A832BA-4065-4FB2-9C33-D41CF4B336CF@redhat.com>
In-Reply-To: <20201204114314.1596-1-wanghai38@huawei.com>
References: <20201204114314.1596-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4 Dec 2020, at 12:43, Wang Hai wrote:

> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>
> Changing 'return start' to 'return action_start' can fix this bug.
>
> Fixes: 69929d4c49e1 ("net: openvswitch: fix TTL decrement action 
> netlink message format")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Thanks for fixing!

Reviewed-by: Eelco Chaudron <echaudro@redhat.com>

> ---
>  net/openvswitch/flow_netlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/flow_netlink.c 
> b/net/openvswitch/flow_netlink.c
> index ec0689ddc635..4c5c2331e764 100644
> --- a/net/openvswitch/flow_netlink.c
> +++ b/net/openvswitch/flow_netlink.c
> @@ -2531,7 +2531,7 @@ static int validate_and_copy_dec_ttl(struct net 
> *net,
>
>  	action_start = add_nested_action_start(sfa, OVS_DEC_TTL_ATTR_ACTION, 
> log);
>  	if (action_start < 0)
> -		return start;
> +		return action_start;
>
>  	err = __ovs_nla_copy_actions(net, actions, key, sfa, eth_type,
>  				     vlan_tci, mpls_label_count, log);
> -- 
> 2.17.1

