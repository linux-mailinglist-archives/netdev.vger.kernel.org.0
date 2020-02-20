Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD63416590D
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 09:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgBTIWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 03:22:19 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36358 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbgBTIWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 03:22:19 -0500
Received: by mail-lj1-f193.google.com with SMTP id r19so3272603ljg.3
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 00:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HGtyV5J9ruOtcfU5A+kW7E+dp9EcXtO6OxVWzrON5mo=;
        b=KcpXMy/YQL9CKVmMy70aGqfhW53SnPuqt9shONCZK7RTxa4FoKIsIy6k2Fv/gk8+Dc
         CrungVV2ZqwTYKJ8/WEd3EqbyIDO3TKAuYV5h0aX4HgshL1HDHYw11eWJUpz9MXD9mZk
         URyj4ErGTfGb4BIfOuYxkXYamULHiS0JkhhhU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HGtyV5J9ruOtcfU5A+kW7E+dp9EcXtO6OxVWzrON5mo=;
        b=DF05e3GkA2DD52WflVP4CqkWS0n+mc+/u/jt7hSXUR9klV111Z46nnyFvW5T06h8bf
         FCilXfHcETYrQU9J0IzmdTZAuhJvhZeK8VR6q3TGfk4bAR6UTjWqVmXnFu4bhj+hzR8Q
         aoxE6S7PD081jKHd3KNRHXKFyG7RMC1A9YmWgjSQs4g+rQZ6Vo1MOpZTrzF1q5qSYptQ
         h6R1frxx7ckqVPuHojdnyir5vVDafXrER2SELdv5J9z7I7cLR1B7d9/bAINcTThHbd7V
         HSJxSHJoayqLfE0HgsO0BbhntGbrwEPj3HDylxlaK5fvaT/LnaVVH9RSgWrh6nt0xuaV
         XvQQ==
X-Gm-Message-State: APjAAAVZjJCa+7a0dQlS7bVfe5bCIns0kCfu7zcdM0mAdINnncgSr8CX
        7Jqg1XWSjG51tA/uu7+EappflQ==
X-Google-Smtp-Source: APXvYqy0wvfdk95wlM41XfmNBWru2ZL5/yZFyBr8yyNOVO0/VS0pBhe11pczVKyqjKojMpa/inekVg==
X-Received: by 2002:a05:651c:20f:: with SMTP id y15mr18917319ljn.7.1582186935776;
        Thu, 20 Feb 2020 00:22:15 -0800 (PST)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s18sm1400102ljj.36.2020.02.20.00.22.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 00:22:14 -0800 (PST)
Subject: Re: [PATCH net-next] net: use netif_is_bridge_port() to check for
 IFF_BRIDGE_PORT
To:     Julian Wiedmann <jwi@linux.ibm.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
References: <20200220080007.51862-1-jwi@linux.ibm.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <aa933e80-d724-ab1f-1666-0cc136253d66@cumulusnetworks.com>
Date:   Thu, 20 Feb 2020 10:22:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200220080007.51862-1-jwi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/02/2020 10:00, Julian Wiedmann wrote:
> Trivial cleanup, so that all bridge port-specific code can be found in
> one go.
> 
> CC: Johannes Berg <johannes@sipsolutions.net>
> CC: Roopa Prabhu <roopa@cumulusnetworks.com>
> CC: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
> ---
>  drivers/net/bonding/bond_main.c       |  2 +-
>  drivers/net/ethernet/micrel/ksz884x.c |  2 +-
>  net/core/rtnetlink.c                  | 12 ++++++------
>  net/wireless/nl80211.c                |  2 +-
>  net/wireless/util.c                   |  2 +-
>  5 files changed, 10 insertions(+), 10 deletions(-)
> 

LGTM,
Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 48d5ec770b94..c3c524f77fcd 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1265,7 +1265,7 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
>  	skb->dev = bond->dev;
>  
>  	if (BOND_MODE(bond) == BOND_MODE_ALB &&
> -	    bond->dev->priv_flags & IFF_BRIDGE_PORT &&
> +	    netif_is_bridge_port(bond->dev) &&
>  	    skb->pkt_type == PACKET_HOST) {
>  
>  		if (unlikely(skb_cow_head(skb,
> diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
> index d1444ba36e10..4fe6aedca22f 100644
> --- a/drivers/net/ethernet/micrel/ksz884x.c
> +++ b/drivers/net/ethernet/micrel/ksz884x.c
> @@ -5694,7 +5694,7 @@ static void dev_set_promiscuous(struct net_device *dev, struct dev_priv *priv,
>  		 * from the bridge.
>  		 */
>  		if ((hw->features & STP_SUPPORT) && !promiscuous &&
> -		    (dev->priv_flags & IFF_BRIDGE_PORT)) {
> +		    netif_is_bridge_port(dev)) {
>  			struct ksz_switch *sw = hw->ksz_switch;
>  			int port = priv->port.first_port;
>  
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 9b4f8a254a15..6e35742969e6 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -3911,7 +3911,7 @@ static int rtnl_fdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
>  
>  	/* Support fdb on master device the net/bridge default case */
>  	if ((!ndm->ndm_flags || ndm->ndm_flags & NTF_MASTER) &&
> -	    (dev->priv_flags & IFF_BRIDGE_PORT)) {
> +	    netif_is_bridge_port(dev)) {
>  		struct net_device *br_dev = netdev_master_upper_dev_get(dev);
>  		const struct net_device_ops *ops = br_dev->netdev_ops;
>  
> @@ -4022,7 +4022,7 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
>  
>  	/* Support fdb on master device the net/bridge default case */
>  	if ((!ndm->ndm_flags || ndm->ndm_flags & NTF_MASTER) &&
> -	    (dev->priv_flags & IFF_BRIDGE_PORT)) {
> +	    netif_is_bridge_port(dev)) {
>  		struct net_device *br_dev = netdev_master_upper_dev_get(dev);
>  		const struct net_device_ops *ops = br_dev->netdev_ops;
>  
> @@ -4248,13 +4248,13 @@ static int rtnl_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
>  				continue;
>  
>  			if (!br_idx) { /* user did not specify a specific bridge */
> -				if (dev->priv_flags & IFF_BRIDGE_PORT) {
> +				if (netif_is_bridge_port(dev)) {
>  					br_dev = netdev_master_upper_dev_get(dev);
>  					cops = br_dev->netdev_ops;
>  				}
>  			} else {
>  				if (dev != br_dev &&
> -				    !(dev->priv_flags & IFF_BRIDGE_PORT))
> +				    !netif_is_bridge_port(dev))
>  					continue;
>  
>  				if (br_dev != netdev_master_upper_dev_get(dev) &&
> @@ -4266,7 +4266,7 @@ static int rtnl_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
>  			if (idx < s_idx)
>  				goto cont;
>  
> -			if (dev->priv_flags & IFF_BRIDGE_PORT) {
> +			if (netif_is_bridge_port(dev)) {
>  				if (cops && cops->ndo_fdb_dump) {
>  					err = cops->ndo_fdb_dump(skb, cb,
>  								br_dev, dev,
> @@ -4416,7 +4416,7 @@ static int rtnl_fdb_get(struct sk_buff *in_skb, struct nlmsghdr *nlh,
>  
>  	if (dev) {
>  		if (!ndm_flags || (ndm_flags & NTF_MASTER)) {
> -			if (!(dev->priv_flags & IFF_BRIDGE_PORT)) {
> +			if (!netif_is_bridge_port(dev)) {
>  				NL_SET_ERR_MSG(extack, "Device is not a bridge port");
>  				return -EINVAL;
>  			}
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index f0112dabe21e..8c2a246099ef 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -3531,7 +3531,7 @@ static int nl80211_valid_4addr(struct cfg80211_registered_device *rdev,
>  			       enum nl80211_iftype iftype)
>  {
>  	if (!use_4addr) {
> -		if (netdev && (netdev->priv_flags & IFF_BRIDGE_PORT))
> +		if (netdev && netif_is_bridge_port(netdev))
>  			return -EBUSY;
>  		return 0;
>  	}
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 8481e9ac33da..80fb47c43bdd 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -934,7 +934,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
>  		return -EOPNOTSUPP;
>  
>  	/* if it's part of a bridge, reject changing type to station/ibss */
> -	if ((dev->priv_flags & IFF_BRIDGE_PORT) &&
> +	if (netif_is_bridge_port(dev) &&
>  	    (ntype == NL80211_IFTYPE_ADHOC ||
>  	     ntype == NL80211_IFTYPE_STATION ||
>  	     ntype == NL80211_IFTYPE_P2P_CLIENT))
> 

