Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76DAB6732B
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 18:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfGLQSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 12:18:42 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41835 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfGLQSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 12:18:42 -0400
Received: by mail-pg1-f195.google.com with SMTP id q4so4746002pgj.8
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 09:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=UWG5L9Wiu2q6IqND0GG+R7HdKguiNCJ8GX1kcsSamcU=;
        b=UWT74TLUDrqkZ8mGV5MuVJSzEF7Jb0eBNjAPVDWgKKaBMgx5CauymWFpE7xkZOKOEQ
         PrXLoTT5XTalmGwYra9E1pUi6U8CPLLbyzo1lk//rUIPPEokLpnlmbI6Yxissk+Ulxjt
         CFNe9wnknnIu8fUNAuclppEN05juzml5gPw0mNtdl8OC3JuGYGyY+JY/k21pIV0hql8W
         Sfgk0v7pF23o8Xyz3VyKVuZobLzAz9uRjJHQeJ0yynN1Q3r9oyxLDO+Rll7Mco6Iz2Y+
         QNri5Rc9Ab6nNd+iyQQi+XlDQNKyUNQ3SC84wZuftfKVzyWN6SVijMCNQ+y9aeiWU20l
         o6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=UWG5L9Wiu2q6IqND0GG+R7HdKguiNCJ8GX1kcsSamcU=;
        b=ggeDU2JmdNrxhnWDPM7peWmlxCa1fR58mNDdKTNKpxvnzcYAZ0HFOtr/8RVH0z8YaE
         5dKW1LOXVPbWR2dcmvl52/MMpA45SoJZU3X8+U8dBspxpc0OPmGsTKHUQjL+7LH1/RDY
         0oabefDSVMaWMrKpM/oA7qmGCvqshTPaFJlKHtDEHX0fLf3xI4m18DC8GL6XssWcx8/k
         gHMrb2YXfevB438/22nzASBI62kAQGFxDH++l3gaXQTir5LXASuYIdl3JFh0Xv3Tn59Q
         LuvZCeXTCIoBlKfSd9B5vGl82QV4X0l2cgYJq3CrOiihZov1mayPAdzz2DMSffUACGn7
         /vXQ==
X-Gm-Message-State: APjAAAURYRf1QXtNg9K8dlS26+/Entj2RgPueYovD9N5L0O7ZZ0nSD3+
        qglhEE9ioWm/aBVSb08ixL0x/EDW
X-Google-Smtp-Source: APXvYqzLQpE/Xheulg0wqCXaE8TjEBjrs80wldmlunIGhe5UsM+Webt+VRUyyqHO8EqoKGOCmj8CrQ==
X-Received: by 2002:a17:90a:374a:: with SMTP id u68mr12700715pjb.4.1562948321416;
        Fri, 12 Jul 2019 09:18:41 -0700 (PDT)
Received: from [192.168.0.16] ([97.115.142.179])
        by smtp.gmail.com with ESMTPSA id k22sm15023774pfg.77.2019.07.12.09.18.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 09:18:40 -0700 (PDT)
Subject: Re: [ovs-dev] [PATCH net-next] net: openvswitch: do not update
 max_headroom if new headroom is equal to old headroom
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        pshelar@ovn.org, netdev@vger.kernel.org, dev@openvswitch.org
References: <20190705160809.5202-1-ap420073@gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <61e34406-74af-e9a4-0309-a31ee1f819a4@gmail.com>
Date:   Fri, 12 Jul 2019 09:18:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190705160809.5202-1-ap420073@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/5/2019 9:08 AM, Taehee Yoo wrote:
> When a vport is deleted, the maximum headroom size would be changed.
> If the vport which has the largest headroom is deleted,
> the new max_headroom would be set.
> But, if the new headroom size is equal to the old headroom size,
> updating routine is unnecessary.
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>   net/openvswitch/datapath.c | 39 +++++++++++++++++++++++++++-----------
>   1 file changed, 28 insertions(+), 11 deletions(-)
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 33b388103741..892287d06c17 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -1958,10 +1958,9 @@ static struct vport *lookup_vport(struct net *net,
>   
>   }
>   
> -/* Called with ovs_mutex */
> -static void update_headroom(struct datapath *dp)
> +static unsigned int ovs_get_max_headroom(struct datapath *dp)
>   {
> -	unsigned dev_headroom, max_headroom = 0;
> +	unsigned int dev_headroom, max_headroom = 0;
>   	struct net_device *dev;
>   	struct vport *vport;
>   	int i;
> @@ -1975,10 +1974,19 @@ static void update_headroom(struct datapath *dp)
>   		}
>   	}
>   
> -	dp->max_headroom = max_headroom;
> +	return max_headroom;
> +}
> +
> +/* Called with ovs_mutex */
> +static void ovs_update_headroom(struct datapath *dp, unsigned int new_headroom)
> +{
> +	struct vport *vport;
> +	int i;
> +
> +	dp->max_headroom = new_headroom;
>   	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++)
>   		hlist_for_each_entry_rcu(vport, &dp->ports[i], dp_hash_node)
> -			netdev_set_rx_headroom(vport->dev, max_headroom);
> +			netdev_set_rx_headroom(vport->dev, new_headroom);
>   }
>   
>   static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
> @@ -1989,6 +1997,7 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
>   	struct sk_buff *reply;
>   	struct vport *vport;
>   	struct datapath *dp;
> +	unsigned int new_headroom;
>   	u32 port_no;
>   	int err;
>   
> @@ -2050,8 +2059,10 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
>   				      info->snd_portid, info->snd_seq, 0,
>   				      OVS_VPORT_CMD_NEW);
>   
> -	if (netdev_get_fwd_headroom(vport->dev) > dp->max_headroom)
> -		update_headroom(dp);
> +	new_headroom = netdev_get_fwd_headroom(vport->dev);
> +
> +	if (new_headroom > dp->max_headroom)
> +		ovs_update_headroom(dp, new_headroom);
>   	else
>   		netdev_set_rx_headroom(vport->dev, dp->max_headroom);
>   
> @@ -2122,11 +2133,12 @@ static int ovs_vport_cmd_set(struct sk_buff *skb, struct genl_info *info)
>   
>   static int ovs_vport_cmd_del(struct sk_buff *skb, struct genl_info *info)
>   {
> -	bool must_update_headroom = false;
> +	bool update_headroom = false;
>   	struct nlattr **a = info->attrs;
>   	struct sk_buff *reply;
>   	struct datapath *dp;
>   	struct vport *vport;
> +	unsigned int new_headroom;
>   	int err;
>   
>   	reply = ovs_vport_cmd_alloc_info();
> @@ -2152,12 +2164,17 @@ static int ovs_vport_cmd_del(struct sk_buff *skb, struct genl_info *info)
>   	/* the vport deletion may trigger dp headroom update */
>   	dp = vport->dp;
>   	if (netdev_get_fwd_headroom(vport->dev) == dp->max_headroom)
> -		must_update_headroom = true;
> +		update_headroom = true;
> +
>   	netdev_reset_rx_headroom(vport->dev);
>   	ovs_dp_detach_port(vport);
>   
> -	if (must_update_headroom)
> -		update_headroom(dp);
> +	if (update_headroom) {
> +		new_headroom = ovs_get_max_headroom(dp);
> +
> +		if (new_headroom < dp->max_headroom)
> +			ovs_update_headroom(dp, new_headroom);
> +	}
>   	ovs_unlock();
>   
>   	ovs_notify(&dp_vport_genl_family, reply, info);

I did a compile test and ran the OVS kernel self-test suite.  Looks OK 
to me.
Tested-by: Greg Rose <gvrose8192@gmail.com>
Reviewed-by: Greg Rose <gvrose8192@gmail.com>

