Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B6D5761C4
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbiGOMe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbiGOMe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:34:57 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1D9491C7
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:34:56 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id x21so3119795plb.3
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MEL8uMaMfc0xZ5Unr8VxlficMFLRxwNCPFY/Lu7nYQ0=;
        b=jNIIFR07gIRVCN6zUiY5o9rMv6t1Y0jNH6e4L02yy2kolfdFMCMvnPlY0ibzLt45sa
         qqg5SMbD/9Kf1CrppnzN1CS+h+/4gQMa1PDbRVdAcGDds18Eo36vyUppsf0li5m54eMP
         S3qRekEcq+ZsvZxj+uO29YP73reXZ4mGmV95FuO04ApE5ixun06xOvpgeyihxuRv2pWv
         0wO8fVjmVdqMFIu5Dl3/aKdwTOr6ASCohUN+/unGw/ZH2qYv6wTqNEi/cGBMEQ+562C3
         QWFZcA7uKT4TalJ0Ogy92JKMRv8lWyxfilC9IeNC1ztjabgdFRL+L/ylxXvxRduE/zcU
         d1mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MEL8uMaMfc0xZ5Unr8VxlficMFLRxwNCPFY/Lu7nYQ0=;
        b=dLID8GUfRuLyh8v7YfowgL1fzADxkHXEBbj626mvciFQMZy4onTshJJeLUONrKFqyT
         ssuDX4z9wfS9fb01lOgz6SqFaYJj/GAPWmfX73ivrmpiiHkVtKYzNfo3v4nW4H6i8/XU
         WC4MJvrurGck8qiXE8OIoxhDm+d60qLHHL4pf6Lj+mO93qfLL62lI5QMMZukYvm0L+fd
         IkCK31TO1OHMZyOoLWCAXU/ECV0TvBob1Xe2GDm/KRIAix53zOdBp7rjHpIWQeTg1e/T
         m2nPi7aqAk6YqETqFTfHdaoUdE4lyxsVpKG9gmElOw2AdejwFx5gt4ba3MlJzTsglLZi
         D8zA==
X-Gm-Message-State: AJIora/OKby2Om6sCTpSTYi73IuKHFS/paiB7+0yUzBCjY9wrSxr2tiR
        9O8DJiieI9dsmXXvIGi0Sfo=
X-Google-Smtp-Source: AGRyM1uKmMubPrsKkOusMzy+JUbp4vp0mFJxkhddf2RZXg9dhPiceZkab2njL2z0G3a1f+hLZRmYAw==
X-Received: by 2002:a17:903:22d0:b0:16b:f798:1cff with SMTP id y16-20020a17090322d000b0016bf7981cffmr13296609plg.23.1657888495547;
        Fri, 15 Jul 2022 05:34:55 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id k6-20020aa79986000000b00528c22038f5sm3890915pfh.14.2022.07.15.05.34.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 05:34:54 -0700 (PDT)
Message-ID: <6d75ddde-c7aa-d134-4d92-3aaa1f96f717@gmail.com>
Date:   Fri, 15 Jul 2022 21:34:51 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net 1/8] amt: use workqueue for gateway side message
 handling
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
References: <20220712105714.12282-1-ap420073@gmail.com>
 <20220712105714.12282-2-ap420073@gmail.com>
 <20220713205509.2a79563a@kernel.org>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20220713205509.2a79563a@kernel.org>
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

Hi Jakub,
Thank you so much for your review!

On 7/14/22 12:55, Jakub Kicinski wrote:
 > On Tue, 12 Jul 2022 10:57:07 +0000 Taehee Yoo wrote:
 >> @@ -2392,12 +2429,14 @@ static bool 
amt_membership_query_handler(struct amt_dev *amt,
 >>   	skb->pkt_type = PACKET_MULTICAST;
 >>   	skb->ip_summed = CHECKSUM_NONE;
 >>   	len = skb->len;
 >> +	rcu_read_lock_bh();
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
 >
 > The RCU lock addition looks potentially unrelated?
 >

I checked that RCU is not necessary here.
I tested local_bh_disable(), and it works well. no splats appeared.
So, as Paolo suggested, I will use local_bh_disable() instead of 
rcu_read_lock_bh() in the v2.

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
 >
 > Are you sure the work will not get scheduled again?
 > What has stopped packet Rx at this point?

I expected that RX was already stopped then ->ndo_stop() can be called.
But as you pointed out, it isn't.
In order to ensure that no more RX concurrently, amt_rcv() should not be 
called.
So, I think cancel_delayed_work() should be called after setting null to 
the amt socket in amt_dev_stop().
code looks like:
    RCU_INIT_POINTER(amt->sock, NULL);
    synchronize_net();
    cancel_delayed_work(&amt->event_wq).

 >
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
 >
 > no need to init member of netdev_priv() to 0, it's zalloc'ed
 >

Thanks a lot for pointing it out.
This is my mistake.
If an amt interface is down and then up again, it would have incorrect 
values of event_idx and nr_events.
Because there is no init for these values.
So, init for these variable in ->ndo_open() or ->ndo_stop() is needed.
Initilization in the ->ndo_newlink() can't fix anything.

As a test, there is a bug certainly.
So, I will move it to ->ndo_open().

 >>   	amt->max_groups = AMT_MAX_GROUP;
 >>   	amt->max_sources = AMT_MAX_SOURCE;
 >>   	amt->hash_buckets = AMT_HSIZE;

I will send the v2 patch after some tests!

Thanks a lot for your review!
Taehee Yoo
