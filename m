Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2590D76417
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 13:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfGZLFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 07:05:19 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40952 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfGZLFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 07:05:19 -0400
Received: by mail-wr1-f66.google.com with SMTP id r1so53988259wrl.7
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 04:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0aZgBfd2LjEg8oChGrxbHcMK3BcpqzePLziZP6z8Hvs=;
        b=O58DCo6GLQwFgzb4D3v5Im4nW+eUrJyCZCicx9PO8liOLG5aT3wh4gjNsypIVzba1Q
         9EOeVyd/6OiMDapj2C1EKPVfo53xAw6O7DkDWwgvbZcZyWOp4djdFLJSIxXxp4o+OrAS
         mVxaRaAv8qyaZOb4UoteXiISp0gcLZzkFyrB8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0aZgBfd2LjEg8oChGrxbHcMK3BcpqzePLziZP6z8Hvs=;
        b=B6XFn1wnh3nq7omcm1lh/GVoH4obzaks2bpwBH5ym4z2CGulFtxCFKShhGhKbQATKT
         +T+DcPowR/gKorronpZOPbG04v0hP7PRnfv0gZgYtAC7uIYB82qfmTOLKOnv3elxi5l+
         oshUH0cHQxfaqlIHPGO+c5o5xMmPKl6vyWH/LaWcxexPuYMpgcJ15LdrLvfVIvGaFhEO
         g0+6O+kVzqY12DrnkeJfMwoBqrMbKBevNVmaZ7Mp1jyHRkLB9Jhgu8buLS2yGblssxbf
         xo2Mpysp6yJpi/D92J3usOPSS5D4vO/e89RJ9WDcCfb9ffJX3eCKZNuMS+gkK9U9GV6Q
         aeYg==
X-Gm-Message-State: APjAAAVowwvS0KKjJvft7qby7MRcASFgEAvXNZHj51DUIA6cfP+d2D3X
        qXsiPZii8r+68MWxTs3ylMLxhw==
X-Google-Smtp-Source: APXvYqzrm1AHD4PvDzyKZ1iEbjkCxUx0KkVvGNwNktXxm4Qjms4A6OgnzHQtVKXP6Oa+QcPHfudKpg==
X-Received: by 2002:adf:fe09:: with SMTP id n9mr106020057wrr.41.1564139116664;
        Fri, 26 Jul 2019 04:05:16 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q18sm62425469wrw.36.2019.07.26.04.05.15
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 04:05:16 -0700 (PDT)
Subject: Re: [PATCH 1/2] ipmr: Make cache queue length configurable
To:     Brodie Greenfield <brodie.greenfield@alliedtelesis.co.nz>,
        davem@davemloft.net, stephen@networkplumber.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, chris.packham@alliedtelesis.co.nz,
        luuk.paulussen@alliedtelesis.co.nz
References: <20190725204230.12229-1-brodie.greenfield@alliedtelesis.co.nz>
 <20190725204230.12229-2-brodie.greenfield@alliedtelesis.co.nz>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <e5606cf7-6848-1109-6cbe-63d94868ed65@cumulusnetworks.com>
Date:   Fri, 26 Jul 2019 14:05:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190725204230.12229-2-brodie.greenfield@alliedtelesis.co.nz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/07/2019 23:42, Brodie Greenfield wrote:
> We want to be able to keep more spaces available in our queue for
> processing incoming multicast traffic (adding (S,G) entries) - this lets
> us learn more groups faster, rather than dropping them at this stage.
> 
> Signed-off-by: Brodie Greenfield <brodie.greenfield@alliedtelesis.co.nz>
> ---
>  Documentation/networking/ip-sysctl.txt | 8 ++++++++
>  include/net/netns/ipv4.h               | 1 +
>  net/ipv4/af_inet.c                     | 1 +
>  net/ipv4/ipmr.c                        | 4 +++-
>  net/ipv4/sysctl_net_ipv4.c             | 7 +++++++
>  5 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> index acdfb5d2bcaa..02f77e932adf 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -887,6 +887,14 @@ ip_local_reserved_ports - list of comma separated ranges
>  
>  	Default: Empty
>  
> +ip_mr_cache_queue_length - INTEGER
> +	Limit the number of multicast packets we can have in the queue to be
> +	resolved.
> +	Bear in mind that when an unresolved multicast packet is received,
> +	there is an O(n) traversal of the queue. This should be considered
> +	if increasing.
> +	Default: 10
> +

Hi,
You've said it yourself - it has linear traversal time, but doesn't this patch allow any netns on the
system to increase its limit to any value, thus possibly affecting others ?
Though the socket limit will kick in at some point. I think that's where David
was going with his suggestion back in 2018:
https://www.spinics.net/lists/netdev/msg514543.html

If we add this sysctl now, we'll be stuck with it. I'd prefer David's suggestion
so we can rely only on the receive queue queue limit which is already configurable. 
We still need to be careful with the defaults though, the NOCACHE entry is 128 bytes
and with the skb overhead currently on my setup we end up at about 277 entries default limit.

Cheers,
 Nik

>  ip_unprivileged_port_start - INTEGER
>  	This is a per-namespace sysctl.  It defines the first
>  	unprivileged port in the network namespace.  Privileged ports
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index 104a6669e344..3411d3f18d51 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -187,6 +187,7 @@ struct netns_ipv4 {
>  	int sysctl_igmp_max_msf;
>  	int sysctl_igmp_llm_reports;
>  	int sysctl_igmp_qrv;
> +	unsigned int sysctl_ip_mr_cache_queue_length;
>  
>  	struct ping_group_range ping_group_range;
>  
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 0dfb72c46671..8e25538bdb1e 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1827,6 +1827,7 @@ static __net_init int inet_init_net(struct net *net)
>  	net->ipv4.sysctl_igmp_llm_reports = 1;
>  	net->ipv4.sysctl_igmp_qrv = 2;
>  
> +	net->ipv4.sysctl_ip_mr_cache_queue_length = 10;
>  	return 0;
>  }
>  
> diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> index ddbf8c9a1abb..c6a6c3e453a9 100644
> --- a/net/ipv4/ipmr.c
> +++ b/net/ipv4/ipmr.c
> @@ -1127,6 +1127,7 @@ static int ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi,
>  				 struct sk_buff *skb, struct net_device *dev)
>  {
>  	const struct iphdr *iph = ip_hdr(skb);
> +	struct net *net = dev_net(dev);
>  	struct mfc_cache *c;
>  	bool found = false;
>  	int err;
> @@ -1142,7 +1143,8 @@ static int ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi,
>  
>  	if (!found) {
>  		/* Create a new entry if allowable */
> -		if (atomic_read(&mrt->cache_resolve_queue_len) >= 10 ||
> +		if (atomic_read(&mrt->cache_resolve_queue_len) >=
> +		    net->ipv4.sysctl_ip_mr_cache_queue_length ||
>  		    (c = ipmr_cache_alloc_unres()) == NULL) {
>  			spin_unlock_bh(&mfc_unres_lock);
>  
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index ba0fc4b18465..78ae86e8c6cb 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -784,6 +784,13 @@ static struct ctl_table ipv4_net_table[] = {
>  		.proc_handler	= proc_dointvec
>  	},
>  #ifdef CONFIG_IP_MULTICAST
> +	{
> +		.procname	= "ip_mr_cache_queue_length",
> +		.data		= &init_net.ipv4.sysctl_ip_mr_cache_queue_length,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec
> +	},
>  	{
>  		.procname	= "igmp_qrv",
>  		.data		= &init_net.ipv4.sysctl_igmp_qrv,
> 

