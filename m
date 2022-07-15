Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CB4576240
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbiGOMwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiGOMwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:52:04 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98253ED7A
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:52:03 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o31-20020a17090a0a2200b001ef7bd037bbso6032117pjo.0
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=OLgwXckZIOU+UHXp3G6osS/EMxRttfviek1ryXAfJm8=;
        b=B1+Hrqq9bjbneBxFXIeBw5EoAi+6OhTXuSN3a1N/pwRskQRgGhcqpHhy+kgQLWc7ar
         9L99nlgVrhJoRIfadqNoSNEEAaOrJnxN76sZ1awrCApppXKxK7bvN6cXuJASEJMNC1Fr
         XIC1BtjzkRH/lWaDQXNLHk+fdwKNckhiiFdfC2AJCkObC/IfXs/HgacduXKW1Zi6/nLS
         yeJ4HgBVQ38ozHJ+gs9BMXKNbIaK32cbPHAFC2AYglY2VqgWsHl239aIJnFfqiMX+OOb
         P6nzh/H+3kzz8P38FJVV7q1Vced+ZCwSYPQZHz/YUZ/zWUw4EPWZpGlLwf6rK5mTx+Jt
         l7cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OLgwXckZIOU+UHXp3G6osS/EMxRttfviek1ryXAfJm8=;
        b=CBgqZzPseXhFiI17uMfKc2A5fHTYz0LibXZhvN1xtn0ibmi2EkBsTD9zuIb+s95Y3a
         yR/MJLWrweefv+V9Td/xrvvEdPbafgNP6BhyKBpthYU5kCd6nHcqa7T8A+g1EDQ8AFmt
         ChCo2k9aUq3oXnyhWoRJ21AnlSCV/aMr4DArQptbSd5Pjg7wwD7eXDh3n19cqUfetf7h
         la51BszixndGUT96nw329+05HLuGetxAopKWuC5NDQd6ecAOnObb1KWzcyhieaOoxp4K
         +QmLX7tcupj4Vbj1c8Msx/3psLJtgDbx4/1RsUNCXu1kg6rM74naRB+ARwXszqesaAEP
         koiQ==
X-Gm-Message-State: AJIora9j4Pa7NsE2x4DKPxEhMft893dqO4KagqFTZC34pK7UxvJaZIWk
        nuJ6iqcNyFZ27RwCKKF6EEA=
X-Google-Smtp-Source: AGRyM1vR4jDzHXiPOwwBmDaKk5TJg91ahDvBraxp5pZLSQ2S8owZ7t4NWdl1mN9XoEQipK53V/Vf2g==
X-Received: by 2002:a17:902:bc45:b0:16b:d5bf:c465 with SMTP id t5-20020a170902bc4500b0016bd5bfc465mr13740072plz.128.1657889521677;
        Fri, 15 Jul 2022 05:52:01 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id p13-20020a63e64d000000b0040c9df2b060sm3164389pgj.30.2022.07.15.05.51.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 05:52:01 -0700 (PDT)
Message-ID: <4a50e1ad-a8b3-ffaa-b6b3-a209a77d0a9c@gmail.com>
Date:   Fri, 15 Jul 2022 21:51:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net 1/8] amt: use workqueue for gateway side message
 handling
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, netdev@vger.kernel.org
References: <20220712105714.12282-1-ap420073@gmail.com>
 <20220712105714.12282-2-ap420073@gmail.com>
 <bdea7caaaa84adb7c75c19438a7cea43b2391ffc.camel@redhat.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <bdea7caaaa84adb7c75c19438a7cea43b2391ffc.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,
Thank you so much for your review!

On 7/14/22 17:09, Paolo Abeni wrote:
 > On Tue, 2022-07-12 at 10:57 +0000, Taehee Yoo wrote:
 >> There are some synchronization issues(amt->status, amt->req_cnt, etc)
 >> if the interface is in gateway mode because gateway message handlers
 >> are processed concurrently.
 >> This applies a work queue for processing these messages instead of
 >> expanding the locking context.
 >>
 >> So, the purposes of this patch are to fix exist race conditions and 
to make
 >> gateway to be able to validate a gateway status more correctly.
 >>
 >> When the AMT gateway interface is created, it tries to establish to 
relay.
 >> The establishment step looks stateless, but it should be managed well.
 >> In order to handle messages in the gateway, it saves the current
 >> status(i.e. AMT_STATUS_XXX).
 >> This patch makes gateway code to be worked with a single thread.
 >>
 >> Now, all messages except the multicast are triggered(received or
 >> delay expired), and these messages will be stored in the event
 >> queue(amt->events).
 >> Then, the single worker processes stored messages asynchronously one
 >> by one.
 >> The multicast data message type will be still processed immediately.
 >>
 >> Now, amt->lock is only needed to access the event queue(amt->events)
 >> if an interface is the gateway mode.
 >>
 >> Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
 >> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
 >> ---
 >>   drivers/net/amt.c | 158 +++++++++++++++++++++++++++++++++++++++++-----
 >>   include/net/amt.h |  20 ++++++
 >>   2 files changed, 163 insertions(+), 15 deletions(-)
 >>
 >> diff --git a/drivers/net/amt.c b/drivers/net/amt.c
 >> index be2719a3ba70..032c2934e466 100644
 >> --- a/drivers/net/amt.c
 >> +++ b/drivers/net/amt.c
 >> @@ -900,6 +900,28 @@ static void amt_send_mld_gq(struct amt_dev 
*amt, struct amt_tunnel_list *tunnel)
 >>   }
 >>   #endif
 >>
 >> +static bool amt_queue_events(struct amt_dev *amt, enum amt_event event,
 >> +			     struct sk_buff *skb)
 >> +{
 >> +	int index;
 >> +
 >> +	spin_lock_bh(&amt->lock);
 >> +	if (amt->nr_events >= AMT_MAX_EVENTS) {
 >> +		spin_unlock_bh(&amt->lock);
 >> +		return 1;
 >> +	}
 >> +
 >> +	index = (amt->event_idx + amt->nr_events) % AMT_MAX_EVENTS;
 >> +	amt->events[index].event = event;
 >> +	amt->events[index].skb = skb;
 >> +	amt->nr_events++;
 >> +	amt->event_idx %= AMT_MAX_EVENTS;
 >> +	queue_work(amt_wq, &amt->event_wq);
 >> +	spin_unlock_bh(&amt->lock);
 >> +
 >> +	return 0;
 >> +}
 >> +
 >>   static void amt_secret_work(struct work_struct *work)
 >>   {
 >>   	struct amt_dev *amt = container_of(to_delayed_work(work),
 >> @@ -913,12 +935,8 @@ static void amt_secret_work(struct work_struct 
*work)
 >>   			 msecs_to_jiffies(AMT_SECRET_TIMEOUT));
 >>   }
 >>
 >> -static void amt_discovery_work(struct work_struct *work)
 >> +static void amt_event_send_discovery(struct amt_dev *amt)
 >>   {
 >> -	struct amt_dev *amt = container_of(to_delayed_work(work),
 >> -					   struct amt_dev,
 >> -					   discovery_wq);
 >> -
 >>   	spin_lock_bh(&amt->lock);
 >>   	if (amt->status > AMT_STATUS_SENT_DISCOVERY)
 >>   		goto out;
 >> @@ -933,11 +951,19 @@ static void amt_discovery_work(struct 
work_struct *work)
 >>   	spin_unlock_bh(&amt->lock);
 >>   }
 >>
 >> -static void amt_req_work(struct work_struct *work)
 >> +static void amt_discovery_work(struct work_struct *work)
 >>   {
 >>   	struct amt_dev *amt = container_of(to_delayed_work(work),
 >>   					   struct amt_dev,
 >> -					   req_wq);
 >> +					   discovery_wq);
 >> +
 >> +	if (amt_queue_events(amt, AMT_EVENT_SEND_DISCOVERY, NULL))
 >> +		mod_delayed_work(amt_wq, &amt->discovery_wq,
 >> +				 msecs_to_jiffies(AMT_DISCOVERY_TIMEOUT));
 >> +}
 >> +
 >> +static void amt_event_send_request(struct amt_dev *amt)
 >> +{
 >>   	u32 exp;
 >>
 >>   	spin_lock_bh(&amt->lock);
 >> @@ -967,6 +993,17 @@ static void amt_req_work(struct work_struct *work)
 >>   	spin_unlock_bh(&amt->lock);
 >>   }
 >>
 >> +static void amt_req_work(struct work_struct *work)
 >> +{
 >> +	struct amt_dev *amt = container_of(to_delayed_work(work),
 >> +					   struct amt_dev,
 >> +					   req_wq);
 >> +
 >> +	if (amt_queue_events(amt, AMT_EVENT_SEND_REQUEST, NULL))
 >> +		mod_delayed_work(amt_wq, &amt->req_wq,
 >> +				 msecs_to_jiffies(100));
 >> +}
 >> +
 >>   static bool amt_send_membership_update(struct amt_dev *amt,
 >>   				       struct sk_buff *skb,
 >>   				       bool v6)
 >> @@ -2392,12 +2429,14 @@ static bool 
amt_membership_query_handler(struct amt_dev *amt,
 >>   	skb->pkt_type = PACKET_MULTICAST;
 >>   	skb->ip_summed = CHECKSUM_NONE;
 >>   	len = skb->len;
 >> +	rcu_read_lock_bh();
 >
 > Here you only need local_bh_disable(), the RCU part is confusing as
 > Jakub noted, and not needed.

Thanks for suggesting, I will use local_bh_disabled() instead of 
rcu_read_lock_bh().

 >
 >>   	if (__netif_rx(skb) == NET_RX_SUCCESS) {
 >>   		amt_update_gw_status(amt, AMT_STATUS_RECEIVED_QUERY, true);
 >>   		dev_sw_netstats_rx_add(amt->dev, len);
 >>   	} else {
 >>   		amt->dev->stats.rx_dropped++;
 >>   	}
 >> +	rcu_read_unlock_bh();
 >>
 >>   	return false;
 >>   }
 >> @@ -2688,6 +2727,38 @@ static bool amt_request_handler(struct 
amt_dev *amt, struct sk_buff *skb)
 >>   	return false;
 >>   }
 >>
 >> +static void amt_gw_rcv(struct amt_dev *amt, struct sk_buff *skb)
 >> +{
 >> +	int type = amt_parse_type(skb);
 >> +	int err = 1;
 >> +
 >> +	if (type == -1)
 >> +		goto drop;
 >> +
 >> +	if (amt->mode == AMT_MODE_GATEWAY) {
 >> +		switch (type) {
 >> +		case AMT_MSG_ADVERTISEMENT:
 >> +			err = amt_advertisement_handler(amt, skb);
 >> +			break;
 >> +		case AMT_MSG_MEMBERSHIP_QUERY:
 >> +			err = amt_membership_query_handler(amt, skb);
 >> +			if (!err)
 >> +				return;
 >> +			break;
 >> +		default:
 >> +			netdev_dbg(amt->dev, "Invalid type of Gateway\n");
 >> +			break;
 >> +		}
 >> +	}
 >> +drop:
 >> +	if (err) {
 >> +		amt->dev->stats.rx_dropped++;
 >> +		kfree_skb(skb);
 >> +	} else {
 >> +		consume_skb(skb);
 >> +	}
 >> +}
 >> +
 >>   static int amt_rcv(struct sock *sk, struct sk_buff *skb)
 >>   {
 >>   	struct amt_dev *amt;
 >> @@ -2719,8 +2790,12 @@ static int amt_rcv(struct sock *sk, struct 
sk_buff *skb)
 >>   				err = true;
 >>   				goto drop;
 >>   			}
 >> -			err = amt_advertisement_handler(amt, skb);
 >> -			break;
 >> +			if (amt_queue_events(amt, AMT_EVENT_RECEIVE, skb)) {
 >> +				netdev_dbg(amt->dev, "AMT Event queue full\n");
 >> +				err = true;
 >> +				goto drop;
 >> +			}
 >> +			goto out;
 >>   		case AMT_MSG_MULTICAST_DATA:
 >>   			if (iph->saddr != amt->remote_ip) {
 >>   				netdev_dbg(amt->dev, "Invalid Relay IP\n");
 >> @@ -2738,11 +2813,12 @@ static int amt_rcv(struct sock *sk, struct 
sk_buff *skb)
 >>   				err = true;
 >>   				goto drop;
 >>   			}
 >> -			err = amt_membership_query_handler(amt, skb);
 >> -			if (err)
 >> +			if (amt_queue_events(amt, AMT_EVENT_RECEIVE, skb)) {
 >> +				netdev_dbg(amt->dev, "AMT Event queue full\n");
 >> +				err = true;
 >>   				goto drop;
 >> -			else
 >> -				goto out;
 >> +			}
 >> +			goto out;
 >>   		default:
 >>   			err = true;
 >>   			netdev_dbg(amt->dev, "Invalid type of Gateway\n");
 >> @@ -2780,6 +2856,45 @@ static int amt_rcv(struct sock *sk, struct 
sk_buff *skb)
 >>   	return 0;
 >>   }
 >>
 >> +static void amt_event_work(struct work_struct *work)
 >> +{
 >> +	struct amt_dev *amt = container_of(work, struct amt_dev, event_wq);
 >> +	struct sk_buff *skb;
 >> +	u8 event;
 >> +
 >> +	while (1) {
 >> +		spin_lock(&amt->lock);
 >
 > This is called in process context, amd amt->lock can be acquired from
 > BH context, you need spin_lock_bh() here.
 >
 > Lockdep should help finding this kind of issue.
 >

Ah, I found that lockdep is disabled in boot time due to other bugs.
I will use spin_lock_bh() and test with the lockdep!

 >> +		if (amt->nr_events == 0) {
 >> +			spin_unlock(&amt->lock);
 >> +			return;
 >> +		}
 >> +		event = amt->events[amt->event_idx].event;
 >> +		skb = amt->events[amt->event_idx].skb;
 >> +		amt->events[amt->event_idx].event = AMT_EVENT_NONE;
 >> +		amt->events[amt->event_idx].skb = NULL;
 >> +		amt->nr_events--;
 >> +		amt->event_idx++;
 >> +		amt->event_idx %= AMT_MAX_EVENTS;
 >> +		spin_unlock(&amt->lock);
 >> +
 >> +		switch (event) {
 >> +		case AMT_EVENT_RECEIVE:
 >> +			amt_gw_rcv(amt, skb);
 >> +			break;
 >> +		case AMT_EVENT_SEND_DISCOVERY:
 >> +			amt_event_send_discovery(amt);
 >> +			break;
 >> +		case AMT_EVENT_SEND_REQUEST:
 >> +			amt_event_send_request(amt);
 >> +			break;
 >> +		default:
 >> +			if (skb)
 >> +				kfree_skb(skb);
 >> +			break;
 >> +		}
 >
 > This loops is unbound. If the socket keep adding events, it can keep
 > running forever. You need either to add cond_schedule() or even better
 > break it after a low max number of iterations - pending event will be
 > served when the work struct is dequeued next
 >

Thanks, I will use a limit variable.


 >> +	}
 >> +}
 >> +
 >>   static int amt_err_lookup(struct sock *sk, struct sk_buff *skb)
 >>   {
 >>   	struct amt_dev *amt;
 >> @@ -2892,10 +3007,21 @@ static int amt_dev_stop(struct net_device *dev)
 >>   	struct amt_dev *amt = netdev_priv(dev);
 >>   	struct amt_tunnel_list *tunnel, *tmp;
 >>   	struct socket *sock;
 >> +	struct sk_buff *skb;
 >> +	int i;
 >>
 >>   	cancel_delayed_work_sync(&amt->req_wq);
 >>   	cancel_delayed_work_sync(&amt->discovery_wq);
 >>   	cancel_delayed_work_sync(&amt->secret_wq);
 >> +	cancel_work_sync(&amt->event_wq);
 >> +
 >> +	for (i = 0; i < AMT_MAX_EVENTS; i++) {
 >> +		skb = amt->events[i].skb;
 >> +		if (skb)
 >> +			kfree_skb(skb);
 >> +		amt->events[i].event = AMT_EVENT_NONE;
 >> +		amt->events[i].skb = NULL;
 >> +	}
 >>
 >>   	/* shutdown */
 >>   	sock = rtnl_dereference(amt->sock);
 >> @@ -3051,6 +3177,8 @@ static int amt_newlink(struct net *net, struct 
net_device *dev,
 >>   		amt->max_tunnels = AMT_MAX_TUNNELS;
 >>
 >>   	spin_lock_init(&amt->lock);
 >> +	amt->event_idx = 0;
 >> +	amt->nr_events = 0;
 >>   	amt->max_groups = AMT_MAX_GROUP;
 >>   	amt->max_sources = AMT_MAX_SOURCE;
 >>   	amt->hash_buckets = AMT_HSIZE;
 >> @@ -3146,8 +3274,8 @@ static int amt_newlink(struct net *net, struct 
net_device *dev,
 >>   	INIT_DELAYED_WORK(&amt->discovery_wq, amt_discovery_work);
 >>   	INIT_DELAYED_WORK(&amt->req_wq, amt_req_work);
 >>   	INIT_DELAYED_WORK(&amt->secret_wq, amt_secret_work);
 >> +	INIT_WORK(&amt->event_wq, amt_event_work);
 >>   	INIT_LIST_HEAD(&amt->tunnel_list);
 >> -
 >>   	return 0;
 >>   err:
 >>   	dev_put(amt->stream_dev);
 >> @@ -3280,7 +3408,7 @@ static int __init amt_init(void)
 >>   	if (err < 0)
 >>   		goto unregister_notifier;
 >>
 >> -	amt_wq = alloc_workqueue("amt", WQ_UNBOUND, 1);
 >> +	amt_wq = alloc_workqueue("amt", WQ_UNBOUND, 0);
 >>   	if (!amt_wq) {
 >>   		err = -ENOMEM;
 >>   		goto rtnl_unregister;
 >> diff --git a/include/net/amt.h b/include/net/amt.h
 >> index 0e40c3d64fcf..08fc30cf2f34 100644
 >> --- a/include/net/amt.h
 >> +++ b/include/net/amt.h
 >> @@ -78,6 +78,15 @@ enum amt_status {
 >>
 >>   #define AMT_STATUS_MAX (__AMT_STATUS_MAX - 1)
 >>
 >> +/* Gateway events only */
 >> +enum amt_event {
 >> +	AMT_EVENT_NONE,
 >> +	AMT_EVENT_RECEIVE,
 >> +	AMT_EVENT_SEND_DISCOVERY,
 >> +	AMT_EVENT_SEND_REQUEST,
 >> +	__AMT_EVENT_MAX,
 >> +};
 >> +
 >>   struct amt_header {
 >>   #if defined(__LITTLE_ENDIAN_BITFIELD)
 >>   	u8 type:4,
 >> @@ -292,6 +301,12 @@ struct amt_group_node {
 >>   	struct hlist_head	sources[];
 >>   };
 >>
 >> +#define AMT_MAX_EVENTS	16
 >> +struct amt_events {
 >> +	enum amt_event event;
 >> +	struct sk_buff *skb;
 >> +};
 >> +
 >>   struct amt_dev {
 >>   	struct net_device       *dev;
 >>   	struct net_device       *stream_dev;
 >> @@ -308,6 +323,7 @@ struct amt_dev {
 >>   	struct delayed_work     req_wq;
 >>   	/* Protected by RTNL */
 >>   	struct delayed_work     secret_wq;
 >> +	struct work_struct	event_wq;
 >>   	/* AMT status */
 >>   	enum amt_status		status;
 >>   	/* Generated key */
 >> @@ -345,6 +361,10 @@ struct amt_dev {
 >>   	/* Used only in gateway mode */
 >>   	u64			mac:48,
 >>   				reserved:16;
 >> +	/* AMT gateway side message handler queue */
 >> +	struct amt_events	events[AMT_MAX_EVENTS];
 >> +	u8			event_idx;
 >> +	u8			nr_events;
 >>   };
 >>
 >>   #define AMT_TOS			0xc0
 >

I will send the v2 patch after some tests with lockdep.

Thanks a lot!
Taehee Yoo
