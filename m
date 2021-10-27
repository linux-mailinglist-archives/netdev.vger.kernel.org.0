Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351A143CCE6
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242676AbhJ0PD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242672AbhJ0PDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 11:03:25 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56988C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 08:01:00 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id q39-20020a4a962a000000b002b8bb100791so1036131ooi.0
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 08:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OJJoA6pZCsx8fFvRMaTicyEHFwkDGctp64u6paD/koU=;
        b=GZ1N5VjrPkCvN/J3oFTJEpoU3IDVXUU/b0/xoiMzT30SMQKgrI7X4s1QU8y7o1nVWW
         S0wVx2Vz4Y/LdiSsMKg0ia9I9ATmKJJ2v7LV4vA4LD9zUUw3uys9nGeGXJ8VttdMazIZ
         BS6umiWRvppsyxViwQIvoaWVyrdoa1aKft4ZFGX6o3WYk2o8KqhEKycOLcUJK8KPYF8w
         rLujk8dDk+Dmnh9xxNzY5snU8LAliXhYuRrelc7REnYdAcEysI80Ic31+rPacHiRtwM0
         kvcDrxY81qCCqA/yiL5PCzLUz02Pax7R50v1P+0YWVXsc9p8/oDMAG8/evTO4hRRhSb4
         AL9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OJJoA6pZCsx8fFvRMaTicyEHFwkDGctp64u6paD/koU=;
        b=5pWTNtxCHS/xSYs7Wb1E5okTBzHDSMJXgE6GSWeJ3xUO3vyCvGbOP+z21OgvfuJ5P/
         hasIcdw1mOUXoAbI6pc4L9acdhlEfD5+/j9PRZuQ+yFUnbUuFSl4gRiHIzBFEXJd/y2O
         iKpW6FXhIJqPbv6xT8UpYuo73BbLrVga+POWr5Oao3QAhdIwe1dYT3mxwOvE+7++YHsU
         XJWs1f6slm9hgsRsS9YYyJQVMDHU4TM5JqgDvikOaYSSJ6GtVLxwLHwHHr7+puAO7z6J
         1v6XLLzi6zjEg7Jm00zDCnUPiRj6kkT2/LV5VWnENK32PT3Yf0lsujE7r6OeVFBovTiD
         0JIA==
X-Gm-Message-State: AOAM531Szxnd/Iv602eM5p7NO16vfu/0E0WVBsdSJ4iZKMZx0aU1FO/H
        WcIALjAyZ59ItyKQTyIuqrhDTx4pWTU=
X-Google-Smtp-Source: ABdhPJz1WU49fPvxWCds6hu8youRqY6MsrSu24zn2HMTyHrrgLngR0iv9Cz3LTow4kxnCnBB49vSyw==
X-Received: by 2002:a4a:9bc2:: with SMTP id b2mr14593507ook.11.1635346859669;
        Wed, 27 Oct 2021 08:00:59 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id ay42sm49541oib.22.2021.10.27.08.00.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 08:00:58 -0700 (PDT)
Message-ID: <ac69dddd-0346-d663-bacf-bb03f01b0b96@gmail.com>
Date:   Wed, 27 Oct 2021 09:00:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH net-next 2/4 v4] amt: add data plane of amt interface
Content-Language: en-US
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, dsahern@kernel.org, netdev@vger.kernel.org
Cc:     dkirjanov@suse.de
References: <20211026151016.25997-1-ap420073@gmail.com>
 <20211026151016.25997-3-ap420073@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211026151016.25997-3-ap420073@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/21 9:10 AM, Taehee Yoo wrote:
> diff --git a/drivers/net/amt.c b/drivers/net/amt.c
> index 8d4782c66cde..c3ac94b6d3e8 100644
> --- a/drivers/net/amt.c
> +++ b/drivers/net/amt.c
> @@ -31,6 +31,1220 @@
>  
>  static struct workqueue_struct *amt_wq;
>  
> +static char *status_str[] = {
> +	"AMT_STATUS_INIT",
> +	"AMT_STATUS_SENT_DISCOVERY",
> +	"AMT_STATUS_RECEIVED_DISCOVERY",
> +	"AMT_STATUS_SENT_ADVERTISEMENT",
> +	"AMT_STATUS_RECEIVED_ADVERTISEMENT",
> +	"AMT_STATUS_SENT_REQUEST",
> +	"AMT_STATUS_RECEIVED_REQUEST",
> +	"AMT_STATUS_SENT_QUERY",
> +	"AMT_STATUS_RECEIVED_QUERY",
> +	"AMT_STATUS_SENT_UPDATE",
> +	"AMT_STATUS_RECEIVED_UPDATE",
> +};
> +
> +static char *type_str[] = {
> +	"AMT_MSG_DISCOVERY",
> +	"AMT_MSG_ADVERTISEMENT",
> +	"AMT_MSG_REQUEST",
> +	"AMT_MSG_MEMBERSHIP_QUERY",
> +	"AMT_MSG_MEMBERSHIP_UPDATE",
> +	"AMT_MSG_MULTICAST_DATA",
> +	"AMT_MSG_TEATDOWM",

TEARDOWN is misspelled.

> +};
> +
> +static struct amt_skb_cb *amt_skb_cb(struct sk_buff *skb)
> +{
> +	return (struct amt_skb_cb *)((void *)skb->cb +
> +		sizeof(struct qdisc_skb_cb));

how will you know of sizeof(struct qdisc_skb_cb) + sizeof(struct
amt_skb_cb) exceeds the cb space? You should add a BUILD_BUG_ON.


> +}
> +
> +static struct sk_buff *amt_build_igmp_gq(struct amt_dev *amt)
> +{
> +	int hlen = LL_RESERVED_SPACE(amt->dev);
> +	int tlen = amt->dev->needed_tailroom;
> +	struct igmpv3_query *ihv3;
> +	void *csum_start = NULL;
> +	__sum16 *csum = NULL;
> +	struct sk_buff *skb;
> +	struct ethhdr *eth;
> +	struct iphdr *iph;
> +	unsigned int len;
> +	int offset;
> +
> +	len = hlen + tlen + sizeof(*iph) + 4 + sizeof(*ihv3);
> +	skb = netdev_alloc_skb_ip_align(amt->dev, len);
> +	if (!skb)
> +		return NULL;
> +
> +	skb_reserve(skb, hlen);
> +	skb_push(skb, sizeof(*eth));
> +	skb->protocol = htons(ETH_P_IP);
> +	skb_reset_mac_header(skb);
> +	skb->priority = TC_PRIO_CONTROL;
> +	skb_put(skb, sizeof(*iph) + 4 + sizeof(*ihv3));
> +	skb_pull(skb, sizeof(*eth));
> +	skb_reset_network_header(skb);
> +
> +	iph		= ip_hdr(skb);
> +	iph->version	= 4;
> +	iph->ihl	= (sizeof(struct iphdr) + 4) >> 2;
> +	iph->tos	= 0xc0;
> +	iph->tot_len	= htons(sizeof(*iph) + 4 + sizeof(*ihv3));
> +	iph->frag_off	= htons(IP_DF);
> +	iph->ttl	= 1;
> +	iph->id		= 0;
> +	iph->protocol	= IPPROTO_IGMP;
> +	iph->daddr	= htonl(INADDR_ALLHOSTS_GROUP);
> +	iph->saddr	= htonl(INADDR_ANY);
> +	((u8 *)&iph[1])[0] = IPOPT_RA;
> +	((u8 *)&iph[1])[1] = 4;
> +	((u8 *)&iph[1])[2] = 0;
> +	((u8 *)&iph[1])[3] = 0;

This reads weird to me. Why not use a local variable like:
#define AMT_IPHDR_OPTS 4
	u8 buf[AMT_IPHDR_OPTS] = (u8 *)(iph + 1);

and then use AMT_IPHDR_OPTS in place of the magic '4' in the skb
manipulations.

> +	ip_send_check(iph);
> +
> +	eth = eth_hdr(skb);
> +	ether_addr_copy(eth->h_source, amt->dev->dev_addr);
> +	ip_eth_mc_map(htonl(INADDR_ALLHOSTS_GROUP), eth->h_dest);
> +	eth->h_proto = htons(ETH_P_IP);
> +
> +	ihv3		= skb_pull(skb, sizeof(*iph) + 4);
> +	skb_reset_transport_header(skb);
> +	ihv3->type	= IGMP_HOST_MEMBERSHIP_QUERY;
> +	ihv3->code	= 1;
> +	ihv3->group	= 0;
> +	ihv3->qqic	= amt->qi;
> +	ihv3->nsrcs	= 0;
> +	ihv3->resv	= 0;
> +	ihv3->suppress	= false;
> +	ihv3->qrv	= amt->net->ipv4.sysctl_igmp_qrv;
> +	ihv3->csum	= 0;
> +	csum		= &ihv3->csum;
> +	csum_start	= (void *)ihv3;
> +	*csum		= ip_compute_csum(csum_start, sizeof(*ihv3));
> +	offset		= skb_transport_offset(skb);
> +	skb->csum	= skb_checksum(skb, offset, skb->len - offset, 0);
> +	skb->ip_summed	= CHECKSUM_NONE;
> +
> +	skb_push(skb, sizeof(*eth) + sizeof(*iph) + 4);
> +
> +	return skb;
> +}
> +



> +static void amt_send_request(struct amt_dev *amt, bool v6)
> +{
> +	struct amt_header_request *amtrh;
> +	int hlen, tlen, offset;
> +	struct socket *sock;
> +	struct udphdr *udph;
> +	struct sk_buff *skb;
> +	struct iphdr *iph;
> +	struct rtable *rt;
> +	struct flowi4 fl4;
> +	u32 len;
> +	int err;
> +
> +	rcu_read_lock();
> +	sock = rcu_dereference(amt->sock);
> +	if (!sock)
> +		goto out;
> +
> +	if (!netif_running(amt->stream_dev) || !netif_running(amt->dev))
> +		goto out;
> +
> +	rt = ip_route_output_ports(amt->net, &fl4, sock->sk,
> +				   amt->remote_ip, amt->local_ip,
> +				   amt->gw_port, amt->relay_port,
> +				   IPPROTO_UDP, 0,
> +				   amt->stream_dev->ifindex);
> +	if (IS_ERR(rt)) {
> +		amt->dev->stats.tx_errors++;
> +		goto out;
> +	}
> +
> +	hlen = LL_RESERVED_SPACE(amt->dev);
> +	tlen = amt->dev->needed_tailroom;
> +	len = hlen + tlen + sizeof(*iph) + sizeof(*udph) + sizeof(*amtrh);
> +	skb = netdev_alloc_skb_ip_align(amt->dev, len);
> +	if (!skb) {
> +		ip_rt_put(rt);
> +		amt->dev->stats.tx_errors++;
> +		goto out;
> +	}
> +
> +	skb->priority = TC_PRIO_CONTROL;
> +	skb_dst_set(skb, &rt->dst);
> +
> +	len = sizeof(*iph) + sizeof(*udph) + sizeof(*amtrh);
> +	skb_reset_network_header(skb);
> +	skb_put(skb, len);
> +	amtrh = skb_pull(skb, sizeof(*iph) + sizeof(*udph));
> +	amtrh->version	 = 0;
> +	amtrh->type	 = AMT_MSG_REQUEST;
> +	amtrh->reserved1 = 0;
> +	amtrh->p	 = v6;
> +	amtrh->reserved2 = 0;
> +	amtrh->nonce	 = amt->nonce;
> +	skb_push(skb, sizeof(*udph));
> +	skb_reset_transport_header(skb);
> +	udph		= udp_hdr(skb);
> +	udph->source	= amt->gw_port;
> +	udph->dest	= amt->relay_port;
> +	udph->len	= htons(sizeof(*amtrh) + sizeof(*udph));
> +	udph->check	= 0;
> +	offset = skb_transport_offset(skb);
> +	skb->csum = skb_checksum(skb, offset, skb->len - offset, 0);
> +	udph->check = csum_tcpudp_magic(amt->local_ip, amt->remote_ip,
> +					sizeof(*udph) + sizeof(*amtrh),
> +					IPPROTO_UDP, skb->csum);
> +
> +	skb_push(skb, sizeof(*iph));
> +	iph		= ip_hdr(skb);
> +	iph->version	= 4;
> +	iph->ihl	= (sizeof(struct iphdr)) >> 2;
> +	iph->tos	= 0xc0;

why c0? Use a macro with a proper name.

> +	iph->frag_off	= 0;
> +	iph->ttl	= ip4_dst_hoplimit(&rt->dst);
> +	iph->daddr	= amt->remote_ip;
> +	iph->saddr	= amt->local_ip;
> +	iph->protocol	= IPPROTO_UDP;
> +	iph->tot_len	= htons(len);
> +
> +	skb->ip_summed = CHECKSUM_NONE;
> +	ip_select_ident(amt->net, skb, NULL);
> +	ip_send_check(iph);
> +	err = ip_local_out(amt->net, sock->sk, skb);
> +	if (unlikely(net_xmit_eval(err)))
> +		amt->dev->stats.tx_errors++;
> +
> +out:
> +	rcu_read_unlock();
> +}
> +
> +static void amt_send_igmp_gq(struct amt_dev *amt,
> +			     struct amt_tunnel_list *tunnel)
> +{
> +	struct sk_buff *skb;
> +
> +	skb = amt_build_igmp_gq(amt);
> +	if (!skb)
> +		return;
> +
> +	amt_skb_cb(skb)->tunnel = tunnel;
> +	dev_queue_xmit(skb);
> +}
> +

> +
> +static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +	struct amt_dev *amt = netdev_priv(dev);
> +	struct amt_tunnel_list *tunnel;
> +	bool report = false;
> +	struct igmphdr *ih;
> +	bool query = false;
> +	struct iphdr *iph;
> +	bool data = false;
> +	bool v6 = false;
> +
> +	rcu_read_lock();

As I recall ndo_start_xmit functions are called inside of
rcu_read_lock_bh().


> +	iph = ip_hdr(skb);> +	if (iph->version == 4) {
> +		if (!ipv4_is_multicast(iph->daddr))
> +			goto free;
> +
> +		if (!ip_mc_check_igmp(skb)) {
> +			ih = igmp_hdr(skb);
> +			switch (ih->type) {
> +			case IGMPV3_HOST_MEMBERSHIP_REPORT:
> +			case IGMP_HOST_MEMBERSHIP_REPORT:
> +				report = true;
> +				break;
> +			case IGMP_HOST_MEMBERSHIP_QUERY:
> +				query = true;
> +				break;
> +			default:
> +				goto free;
> +			}
> +		} else {
> +			data = true;
> +		}
> +		v6 = false;
> +	} else {
> +		dev->stats.tx_errors++;
> +		goto free;
> +	}
> +
> +	if (!pskb_may_pull(skb, sizeof(struct ethhdr)))
> +		goto free;
> +
> +	skb_pull(skb, sizeof(struct ethhdr));
> +
> +	if (amt->mode == AMT_MODE_GATEWAY) {
> +		/* Gateway only passes IGMP/MLD packets */
> +		if (!report)
> +			goto free;
> +		if ((!v6 && !amt->ready4) || (v6 && !amt->ready6))
> +			goto free;
> +		if (amt_send_membership_update(amt, skb,  v6))
> +			goto free;
> +		goto unlock;
> +	} else if (amt->mode == AMT_MODE_RELAY) {
> +		if (query) {
> +			tunnel = amt_skb_cb(skb)->tunnel;
> +			if (!tunnel) {
> +				WARN_ON(1);
> +				goto free;
> +			}
> +
> +			/* Do not forward unexpected query */
> +			if (amt_send_membership_query(amt, skb, tunnel, v6))
> +				goto free;
> +			goto unlock;
> +		}
> +
> +		if (!data)
> +			goto free;
> +		list_for_each_entry_rcu(tunnel, &amt->tunnel_list, list)
> +			amt_send_multicast_data(amt, skb, tunnel, v6);
> +	}
> +
> +	dev_kfree_skb(skb);
> +	rcu_read_unlock();
> +	return NETDEV_TX_OK;
> +free:
> +	dev_kfree_skb(skb);
> +unlock:
> +	rcu_read_unlock();
> +	dev->stats.tx_dropped++;
> +	return NETDEV_TX_OK;
> +}
> +




> +static bool amt_request_handler(struct amt_dev *amt, struct sk_buff *skb)
> +{
> +	struct amt_header_request *amtrh;
> +	struct amt_tunnel_list *tunnel;
> +	unsigned long long key;
> +	struct udphdr *udph;
> +	struct iphdr *iph;
> +	u64 mac;
> +	int i;
> +
> +	if (!pskb_may_pull(skb, sizeof(*udph) + sizeof(*amtrh)))
> +		return true;
> +
> +	iph = ip_hdr(skb);
> +	udph = udp_hdr(skb);
> +	amtrh = (struct amt_header_request *)(udp_hdr(skb) + 1);
> +
> +	if (amtrh->reserved1 || amtrh->reserved2 || amtrh->version)
> +		return true;
> +
> +	list_for_each_entry_rcu(tunnel, &amt->tunnel_list, list)
> +		if (tunnel->ip4 == iph->saddr)
> +			goto send;
> +
> +	if (amt->nr_tunnels >= amt->max_tunnels) {
> +		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0);
> +		return true;
> +	}
> +
> +	tunnel = kmalloc(sizeof(*tunnel) +

kzalloc and then you do not need the '= 0' below.

> +			 (sizeof(struct hlist_head) * amt->hash_buckets),
> +			 GFP_ATOMIC);
> +	if (!tunnel)
> +		return true;
> +
> +	tunnel->source_port = udph->source;
> +	tunnel->ip4 = iph->saddr;
> +	tunnel->nr_groups = 0;
> +	tunnel->nr_sources = 0;
> +
> +	memcpy(&key, &tunnel->key, sizeof(unsigned long long));
> +	tunnel->reserved = 0;
> +	tunnel->amt = amt;
> +	spin_lock_init(&tunnel->lock);
> +	for (i = 0; i < amt->hash_buckets; i++)
> +		INIT_HLIST_HEAD(&tunnel->groups[i]);
> +
> +	INIT_DELAYED_WORK(&tunnel->gc_wq, amt_tunnel_expire);
> +
> +	spin_lock_bh(&amt->lock);
> +	list_add_tail_rcu(&tunnel->list, &amt->tunnel_list);
> +	tunnel->key = amt->key;
> +	amt_update_relay_status(tunnel, AMT_STATUS_RECEIVED_REQUEST, true);
> +	amt->nr_tunnels++;
> +	mod_delayed_work(amt_wq, &tunnel->gc_wq,
> +			 msecs_to_jiffies(amt_gmi(amt)));
> +	spin_unlock_bh(&amt->lock);
> +
> +send:
> +	tunnel->nonce = amtrh->nonce;
> +	mac = siphash_3u32((__force u32)tunnel->ip4,
> +			   (__force u32)tunnel->source_port,
> +			   (__force u32)tunnel->nonce,
> +			   &tunnel->key);
> +	tunnel->mac = mac >> 16;
> +
> +	if (!netif_running(amt->dev) || !netif_running(amt->stream_dev))
> +		return true;
> +
> +	if (!amtrh->p)
> +		amt_send_igmp_gq(amt, tunnel);
> +
> +	return false;
> +}
> +

you create some selftests and include some torture cases around cleanup
of all the work activity.
