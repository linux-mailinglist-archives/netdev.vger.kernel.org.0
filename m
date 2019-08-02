Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4709E7FDBE
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 17:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbfHBPlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 11:41:18 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39913 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfHBPlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 11:41:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so24479911wrt.6
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 08:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xs/YFHKf9PHFCNDA8QLLkg7vQCLE7jJpoBWYpDOuQ/Y=;
        b=eZI3YKZA4tQVIbTp8h7H4gCHu061YRt4/w7RQZjwDJoRCgkouJZbM31gNWX62qmifZ
         05XdnxNMDilS6VMLwhc/7gU2ZZogQfhmo8kdCwwt/zTaJ2Yc/kBa4N10tD/+C12fBkZR
         vnFTtbFUAKAstiVu+lgXDeVtLwqKc907yTX0M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xs/YFHKf9PHFCNDA8QLLkg7vQCLE7jJpoBWYpDOuQ/Y=;
        b=dhCl1wAPFBwEb8FdGu2ekXsvGq+A3vgnL33kKIJKxx4NreiWlI5wTc+7+RQOwr80KI
         oVYj59QJENRePuQ/uH5MN8RGTw4v8h+HzNjkZGdrIjRVCBg/RVnA3757C9ZfvSvMSyu/
         dbkm3hwRMzXJOAOJjA10TTbHVHbg8RFI/mp+SCEew/as4G0nbUbi9rGDuXeWLhX9ZN+c
         j1SyntRjBldOWPzYjURycrkUq11GCU4mtXf8LWQ+7HEACGIGBC7bnKFoQLHm+W4qATKx
         RLwHZsvxzlq1XAy3SNxuw6kITVziJV4aWhu0F22k5LvNwY0sv6Li1X8+AQDWJ824Ak5H
         tkyg==
X-Gm-Message-State: APjAAAVcozUL4ta+vDzpw9gNG/1gtW/grZrQAoPYnrgnZajumF82yv0O
        xb1CtsHHYBpBP+W8psOGi7JNNO6lbtHXIA==
X-Google-Smtp-Source: APXvYqyHg18h+IOigT/kFMxhHANlBBseWIs/Rj7Wsq/ljYjhkgeEUQnEnVYtKaZ2YAxhR/6eu7C18g==
X-Received: by 2002:a5d:4284:: with SMTP id k4mr142482707wrq.194.1564760476081;
        Fri, 02 Aug 2019 08:41:16 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id g8sm77281166wme.20.2019.08.02.08.41.14
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 08:41:15 -0700 (PDT)
Subject: Re: [PATCH net v4] net: bridge: move default pvid init/deinit to
 NETDEV_REGISTER/UNREGISTER
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        michael-dev <michael-dev@fami-braun.de>
References: <0a015a21-c1ae-e275-e675-431f08bece86@cumulusnetworks.com>
 <20190802105736.26767-1-nikolay@cumulusnetworks.com>
 <20190802083519.71cb4fa2@hermes.lan>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <dfc69d03-6c90-ae62-6c23-b7de52ada422@cumulusnetworks.com>
Date:   Fri, 2 Aug 2019 18:41:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190802083519.71cb4fa2@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/08/2019 18:35, Stephen Hemminger wrote:
> On Fri,  2 Aug 2019 13:57:36 +0300
> Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
> 
>> +int br_vlan_bridge_event(struct net_device *dev, unsigned long event, void *ptr)
>>  {
>>  	struct netdev_notifier_changeupper_info *info;
>> -	struct net_bridge *br;
>> +	struct net_bridge *br = netdev_priv(dev);
>> +	bool changed;
>> +	int ret = 0;
>>  
>>  	switch (event) {
>> +	case NETDEV_REGISTER:
>> +		ret = br_vlan_add(br, br->default_pvid,
>> +				  BRIDGE_VLAN_INFO_PVID |
>> +				  BRIDGE_VLAN_INFO_UNTAGGED |
>> +				  BRIDGE_VLAN_INFO_BRENTRY, &changed, NULL);
>> +		break;
> 
> Looks good.
> 
> As minor optimization br_vlan_add could ignore changed pointer if NULL.
> This would save places where you don't care.
> 
> 
> Something like:
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 021cc9f66804..bacd3543b215 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -626,10 +626,11 @@ static int br_vlan_add_existing(struct net_bridge *br,
>  		refcount_inc(&vlan->refcnt);
>  		vlan->flags |= BRIDGE_VLAN_INFO_BRENTRY;
>  		vg->num_vlans++;
> -		*changed = true;
> +		if (changed)
> +			*changed = true;
>  	}
>  
> -	if (__vlan_add_flags(vlan, flags))
> +	if (__vlan_add_flags(vlan, flags) && changed)
>  		*changed = true;
>  
>  	return 0;
> @@ -653,7 +654,8 @@ int br_vlan_add(struct net_bridge *br, u16 vid, u16 flags, bool *changed,
>  
>  	ASSERT_RTNL();
>  
> -	*changed = false;
> +	if (changed)
> +		*changed = false;
>  	vg = br_vlan_group(br);
>  	vlan = br_vlan_find(vg, vid);
>  	if (vlan)
> @@ -679,7 +681,7 @@ int br_vlan_add(struct net_bridge *br, u16 vid, u16 flags, bool *changed,
>  	if (ret) {
>  		free_percpu(vlan->stats);
>  		kfree(vlan);
> -	} else {
> +	} else if (changed) {
>  		*changed = true;
>  	}
>  
> 

sure, this is ok for net-next

