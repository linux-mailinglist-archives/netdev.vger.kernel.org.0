Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D0612F508
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 08:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbgACHjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 02:39:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:45124 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgACHjZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 02:39:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 31502AD00;
        Fri,  3 Jan 2020 07:39:24 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 90243E0780; Fri,  3 Jan 2020 08:39:23 +0100 (CET)
Date:   Fri, 3 Jan 2020 08:39:23 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next] ethtool: remove set but not used variable
 'lsettings'
Message-ID: <20200103073923.GA4769@unicorn.suse.cz>
References: <20200103034856.177906-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103034856.177906-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 03:48:56AM +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> net/ethtool/linkmodes.c: In function 'ethnl_set_linkmodes':
> net/ethtool/linkmodes.c:326:32: warning:
>  variable 'lsettings' set but not used [-Wunused-but-set-variable]
>   struct ethtool_link_settings *lsettings;
>                                 ^
> It is never used, so remove it.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/ethtool/linkmodes.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
> index 0b99f494ad3b..96f20be64553 100644
> --- a/net/ethtool/linkmodes.c
> +++ b/net/ethtool/linkmodes.c
> @@ -323,7 +323,6 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
>  {
>  	struct nlattr *tb[ETHTOOL_A_LINKMODES_MAX + 1];
>  	struct ethtool_link_ksettings ksettings = {};
> -	struct ethtool_link_settings *lsettings;
>  	struct ethnl_req_info req_info = {};
>  	struct net_device *dev;
>  	bool mod = false;
> @@ -354,7 +353,6 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
>  			GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
>  		goto out_ops;
>  	}
> -	lsettings = &ksettings.base;
>  
>  	ret = ethnl_update_linkmodes(info, tb, &ksettings, &mod);
>  	if (ret < 0)

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

Thank you. I wonder why my compiler does not complain.

Michal
