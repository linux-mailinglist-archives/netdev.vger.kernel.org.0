Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 265437643A
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 13:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfGZLPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 07:15:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33359 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfGZLPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 07:15:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so54124618wru.0
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 04:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E7BasOFtlQFe4XW94Jqld+ckhXHp1SQC8I6+9qrklUE=;
        b=C4TZ9EfHkoWGJWuZe6ayE8JaaFIZNeL9+UD1H3fhSDiJm0066aDQZ20qupKny6cyzz
         4A8NSI2rFyQfHNyKdxYslD/g8ZkOZqruxwjXNsU4aGe9iIC70Q+eNojLnw79hHRVOhXf
         vtukS7lb0wAzY59+oYpj62qMuKn1hpp/lxesI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E7BasOFtlQFe4XW94Jqld+ckhXHp1SQC8I6+9qrklUE=;
        b=BY4X+I+HTa4n+IBUEcZ6FNNNhck/N0BFjid94x9nDDA9LhcdRqNHYRf9CuRd99QwtF
         b1n/0Rktc7BmRkRjAVPk8gPzkng4eRA0lZfkU7zgcM7ZtYQW8MIesBTnTUi3RmDJk+1R
         stzHiv6zUMXGTRDdbnYPDVHSkp7eCb3TZYG+AlK9OUxr7jesvMlkxfqBLY0RpSj9DcXI
         Ks01PATKFTyV46Jv+zG+P69UCPBeJzj3saWwwX+4dNKxXdQP+lYwZbdLftROeYpY8dpP
         7fhEPzh77wb27pM/hAsSvZzJ/XJg9n8XVuSC6qH/mIBDOqMN5msUlGHd027HGe9Hd6k8
         LcoA==
X-Gm-Message-State: APjAAAXYN4mz3m2032i6/fuMMaaFVR3m8nvrgPobZ+Gzvzp3MDOC+/hv
        ApduApA9j8bJWU36ZkIU5v/T/A==
X-Google-Smtp-Source: APXvYqzcKpOmbNbutKT36OrxXTcQ/eiCgrUI+llMm0RJpP1au9/nkPjo7SKfJ6wef4NUKEptJo6hZA==
X-Received: by 2002:adf:de90:: with SMTP id w16mr4681653wrl.217.1564139731493;
        Fri, 26 Jul 2019 04:15:31 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id z25sm56120034wmf.38.2019.07.26.04.15.30
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 04:15:30 -0700 (PDT)
Subject: Re: [PATCH 1/2] ipmr: Make cache queue length configurable
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Brodie Greenfield <brodie.greenfield@alliedtelesis.co.nz>,
        davem@davemloft.net, stephen@networkplumber.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, chris.packham@alliedtelesis.co.nz,
        luuk.paulussen@alliedtelesis.co.nz
References: <20190725204230.12229-1-brodie.greenfield@alliedtelesis.co.nz>
 <20190725204230.12229-2-brodie.greenfield@alliedtelesis.co.nz>
 <e5606cf7-6848-1109-6cbe-63d94868ed65@cumulusnetworks.com>
Message-ID: <6e8c51a0-cd34-e14a-7661-6fa5945f278b@cumulusnetworks.com>
Date:   Fri, 26 Jul 2019 14:15:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <e5606cf7-6848-1109-6cbe-63d94868ed65@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/07/2019 14:05, Nikolay Aleksandrov wrote:
> On 25/07/2019 23:42, Brodie Greenfield wrote:
>> We want to be able to keep more spaces available in our queue for
>> processing incoming multicast traffic (adding (S,G) entries) - this lets
>> us learn more groups faster, rather than dropping them at this stage.
>>
>> Signed-off-by: Brodie Greenfield <brodie.greenfield@alliedtelesis.co.nz>
>> ---
>>  Documentation/networking/ip-sysctl.txt | 8 ++++++++
>>  include/net/netns/ipv4.h               | 1 +
>>  net/ipv4/af_inet.c                     | 1 +
>>  net/ipv4/ipmr.c                        | 4 +++-
>>  net/ipv4/sysctl_net_ipv4.c             | 7 +++++++
>>  5 files changed, 20 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
>> index acdfb5d2bcaa..02f77e932adf 100644
>> --- a/Documentation/networking/ip-sysctl.txt
>> +++ b/Documentation/networking/ip-sysctl.txt
>> @@ -887,6 +887,14 @@ ip_local_reserved_ports - list of comma separated ranges
>>  
>>  	Default: Empty
>>  
>> +ip_mr_cache_queue_length - INTEGER
>> +	Limit the number of multicast packets we can have in the queue to be
>> +	resolved.
>> +	Bear in mind that when an unresolved multicast packet is received,
>> +	there is an O(n) traversal of the queue. This should be considered
>> +	if increasing.
>> +	Default: 10
>> +
> 
> Hi,
> You've said it yourself - it has linear traversal time, but doesn't this patch allow any netns on the
> system to increase its limit to any value, thus possibly affecting others ?
> Though the socket limit will kick in at some point. I think that's where David
> was going with his suggestion back in 2018:
> https://www.spinics.net/lists/netdev/msg514543.html
> 
> If we add this sysctl now, we'll be stuck with it. I'd prefer David's suggestion
> so we can rely only on the receive queue queue limit which is already configurable. 
> We still need to be careful with the defaults though, the NOCACHE entry is 128 bytes
> and with the skb overhead currently on my setup we end up at about 277 entries default limit.

I mean that people might be surprised if they increased that limit by default, that's the
only problem I'm not sure how to handle. Maybe we need some hard limit anyway.
Have you done any tests what value works for your setup ?

In the end we might have to go with this patch, but perhaps limit the per-netns sysctl
to the init_ns value as maximum (similar to what we did for frags) or don't make it per-netns
at all.

> 
> Cheers,
>  Nik
> 
>>  ip_unprivileged_port_start - INTEGER
>>  	This is a per-namespace sysctl.  It defines the first
>>  	unprivileged port in the network namespace.  Privileged ports
>> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
>> index 104a6669e344..3411d3f18d51 100644
>> --- a/include/net/netns/ipv4.h
>> +++ b/include/net/netns/ipv4.h
>> @@ -187,6 +187,7 @@ struct netns_ipv4 {
>>  	int sysctl_igmp_max_msf;
>>  	int sysctl_igmp_llm_reports;
>>  	int sysctl_igmp_qrv;
>> +	unsigned int sysctl_ip_mr_cache_queue_length;
>>  
>>  	struct ping_group_range ping_group_range;
>>  
>> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
>> index 0dfb72c46671..8e25538bdb1e 100644
>> --- a/net/ipv4/af_inet.c
>> +++ b/net/ipv4/af_inet.c
>> @@ -1827,6 +1827,7 @@ static __net_init int inet_init_net(struct net *net)
>>  	net->ipv4.sysctl_igmp_llm_reports = 1;
>>  	net->ipv4.sysctl_igmp_qrv = 2;
>>  
>> +	net->ipv4.sysctl_ip_mr_cache_queue_length = 10;
>>  	return 0;
>>  }
>>  
>> diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
>> index ddbf8c9a1abb..c6a6c3e453a9 100644
>> --- a/net/ipv4/ipmr.c
>> +++ b/net/ipv4/ipmr.c
>> @@ -1127,6 +1127,7 @@ static int ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi,
>>  				 struct sk_buff *skb, struct net_device *dev)
>>  {
>>  	const struct iphdr *iph = ip_hdr(skb);
>> +	struct net *net = dev_net(dev);
>>  	struct mfc_cache *c;
>>  	bool found = false;
>>  	int err;
>> @@ -1142,7 +1143,8 @@ static int ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi,
>>  
>>  	if (!found) {
>>  		/* Create a new entry if allowable */
>> -		if (atomic_read(&mrt->cache_resolve_queue_len) >= 10 ||
>> +		if (atomic_read(&mrt->cache_resolve_queue_len) >=
>> +		    net->ipv4.sysctl_ip_mr_cache_queue_length ||
>>  		    (c = ipmr_cache_alloc_unres()) == NULL) {
>>  			spin_unlock_bh(&mfc_unres_lock);
>>  
>> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
>> index ba0fc4b18465..78ae86e8c6cb 100644
>> --- a/net/ipv4/sysctl_net_ipv4.c
>> +++ b/net/ipv4/sysctl_net_ipv4.c
>> @@ -784,6 +784,13 @@ static struct ctl_table ipv4_net_table[] = {
>>  		.proc_handler	= proc_dointvec
>>  	},
>>  #ifdef CONFIG_IP_MULTICAST
>> +	{
>> +		.procname	= "ip_mr_cache_queue_length",
>> +		.data		= &init_net.ipv4.sysctl_ip_mr_cache_queue_length,
>> +		.maxlen		= sizeof(int),
>> +		.mode		= 0644,
>> +		.proc_handler	= proc_dointvec
>> +	},
>>  	{
>>  		.procname	= "igmp_qrv",
>>  		.data		= &init_net.ipv4.sysctl_igmp_qrv,
>>
> 

