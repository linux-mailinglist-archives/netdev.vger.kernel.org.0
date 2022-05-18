Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903FA52AF1C
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiERAVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiERAVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:21:41 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D763DD87
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 17:21:39 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id i24so605660pfa.7
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 17:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2L/9yY+E/tECqY6ZyiErUrd1ZtGuYQazkW2KDwKSzII=;
        b=k++rLTGEkqkz69uNyD7RLxGDtSNPlPevmyftsjHnYWU3ai+gK8AofYWl+sUvuvsUVC
         fQhpUYLVXiCO9x9hdm3DuxfVsxJAdpGiJ90LXgyWMwrETEGCgzCHjqpsJ/o2Rklkg87g
         rCatA2aWz1Jl24a+k0u/SxTjn8lf7e6PA/YeM6sB8d2HchFyT/7A3cQ6eH1mt+IYGzCe
         JEQy66u2EnA/dbgwF4TKxHhI8j+EWLz7x1mcp3e2t8MU7flHqd5iMgjVZ9SWTnmLlMPM
         uzNjf0DBpcAdcKGUjJUHnDJsohx7RVysX1pd6SCpYW81JeRYZzBDuDO/JpjfCZhXdzjK
         o3uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2L/9yY+E/tECqY6ZyiErUrd1ZtGuYQazkW2KDwKSzII=;
        b=LWEFhZYYNVnEb5soj4V5uSl4+ueiEBNpydExsdx1vHW0zAt4tLsUicAKy8UV9iQS6y
         ypPygnWyn42qJkwGLM9vVBFsrI4YQ2bRAuuY82mCNxgbPcUn4NK0MCV2jLZ0ID3JcKaw
         UPbf922Puo1WVmZI1bg0OF2qpOCR03JvUALoPy5hIbys4zVNluS3utaJcoymeDjxC1Hs
         seCitgTD1wC1isZmWTUhI763nesXQyM7Gt6ryDYjGSz3vsHBMAiG/jELNiXmkgGFq1QF
         PIa31ws2aSucJ9VJYXtOkGPTsbKKkF0OlzZl6PpxxXt2SOpXu/pZCEz6TshCsb/AWh4N
         gbtA==
X-Gm-Message-State: AOAM530siMlpYzl9ttmJ2My8QSpb9hAaTjUrvDxgCLrF764dGwPZ4Yjz
        uCoPrIn0HIBKe7Eo1C/0I10=
X-Google-Smtp-Source: ABdhPJztzb3yZ4EBr1rB5YDQoaBAOOM6CFyN/annnkBW7V42Y6qT2At5X3D2Zx0fBBOgh1TU1E92sA==
X-Received: by 2002:a62:1687:0:b0:50d:3364:46d4 with SMTP id 129-20020a621687000000b0050d336446d4mr24903488pfw.74.1652833299287;
        Tue, 17 May 2022 17:21:39 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id n9-20020a629709000000b005180df18990sm312488pfe.168.2022.05.17.17.21.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 17:21:38 -0700 (PDT)
Message-ID: <3b837f52-580e-5ce2-5aa3-60c9d03a7520@gmail.com>
Date:   Wed, 18 May 2022 09:21:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net v2 2/2] amt: do not skip remaining handling of
 advertisement message
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
References: <20220517070527.10591-1-ap420073@gmail.com>
 <20220517070527.10591-3-ap420073@gmail.com>
 <20220517152409.5545f6e8@kernel.org>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20220517152409.5545f6e8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/22 07:24, Jakub Kicinski wrote:

Hi Jakub,

Thank s a lot for your review!

 > On Tue, 17 May 2022 07:05:27 +0000 Taehee Yoo wrote:
 >> When a gateway receives an advertisement message, it extracts relay
 >> information and then it should be deleted.
 >> But the advertisement handler doesn't do that.
 >> So, after amt_advertisement_handler(), that message should not be 
skipped
 >> remaining handling.
 >>
 >> Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
 >> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
 >
 >> diff --git a/drivers/net/amt.c b/drivers/net/amt.c
 >> index 2b4ce3869f08..6ce2ecd07640 100644
 >> --- a/drivers/net/amt.c
 >> +++ b/drivers/net/amt.c
 >> @@ -2698,9 +2698,10 @@ static int amt_rcv(struct sock *sk, struct 
sk_buff *skb)
 >>   				err = true;
 >>   				goto drop;
 >>   			}
 >> -			if (amt_advertisement_handler(amt, skb))
 >> +			err = amt_advertisement_handler(amt, skb);
 >> +			if (err)
 >>   				amt->dev->stats.rx_dropped++;
 >> -			goto out;
 >> +			break;
 >>   		case AMT_MSG_MULTICAST_DATA:
 >>   			if (iph->saddr != amt->remote_ip) {
 >>   				netdev_dbg(amt->dev, "Invalid Relay IP\n");
 >
 > I guess I'll have to spell it out for you more cause either you didn't
 > understand me or I don't understand your reply on v1. Here's the full
 > function:
 >
 >    2669	static int amt_rcv(struct sock *sk, struct sk_buff *skb)
 >    2670	{
 >    2671		struct amt_dev *amt;
 >    2672		struct iphdr *iph;
 >    2673		int type;
 >    2674		bool err;
 >    2675	
 >    2676		rcu_read_lock_bh();
 >    2677		amt = rcu_dereference_sk_user_data(sk);
 >    2678		if (!amt) {
 >    2679			err = true;
 >    2680			goto out;
 >    2681		}
 >    2682	
 >    2683		skb->dev = amt->dev;
 >    2684		iph = ip_hdr(skb);
 >    2685		type = amt_parse_type(skb);
 >    2686		if (type == -1) {
 >    2687			err = true;
 >    2688			goto drop;
 >    2689		}
 >    2690	
 >    2691		if (amt->mode == AMT_MODE_GATEWAY) {
 >    2692			switch (type) {
 >    2693			case AMT_MSG_ADVERTISEMENT:
 >    2694				if (iph->saddr != amt->discovery_ip) {
 >    2695					netdev_dbg(amt->dev, "Invalid Relay IP\n");
 >    2696					err = true;
 >    2697					goto drop;
 >    2698				}
 >    2699				if (amt_advertisement_handler(amt, skb))
 >    2700					amt->dev->stats.rx_dropped++;
 >    2701				goto out;
 >    2702			case AMT_MSG_MULTICAST_DATA:
 >    2703				if (iph->saddr != amt->remote_ip) {
 >    2704					netdev_dbg(amt->dev, "Invalid Relay IP\n");
 >    2705					err = true;
 >    2706					goto drop;
 >    2707				}
 >    2708				err = amt_multicast_data_handler(amt, skb);
 >    2709				if (err)
 >    2710					goto drop;
 >    2711				else
 >    2712					goto out;
 >    2713			case AMT_MSG_MEMBERSHIP_QUERY:
 >    2714				if (iph->saddr != amt->remote_ip) {
 >    2715					netdev_dbg(amt->dev, "Invalid Relay IP\n");
 >    2716					err = true;
 >    2717					goto drop;
 >    2718				}
 >    2719				err = amt_membership_query_handler(amt, skb);
 >    2720				if (err)
 >    2721					goto drop;
 >    2722				else
 >    2723					goto out;
 >    2724			default:
 >    2725				err = true;
 >    2726				netdev_dbg(amt->dev, "Invalid type of Gateway\n");
 >    2727				break;
 >    2728			}
 >    2729		} else {
 >    2730			switch (type) {
 >    2731			case AMT_MSG_DISCOVERY:
 >    2732				err = amt_discovery_handler(amt, skb);
 >    2733				break;
 >    2734			case AMT_MSG_REQUEST:
 >    2735				err = amt_request_handler(amt, skb);
 >    2736				break;
 >    2737			case AMT_MSG_MEMBERSHIP_UPDATE:
 >    2738				err = amt_update_handler(amt, skb);
 >    2739				if (err)
 >    2740					goto drop;
 >    2741				else
 >    2742					goto out;
 >    2743			default:
 >    2744				err = true;
 >    2745				netdev_dbg(amt->dev, "Invalid type of relay\n");
 >    2746				break;
 >    2747			}
 >    2748		}
 >    2749	drop:
 >    2750		if (err) {
 >    2751			amt->dev->stats.rx_dropped++;
 >    2752			kfree_skb(skb);
 >    2753		} else {
 >    2754			consume_skb(skb);
 >    2755		}
 >    2756	out:
 >    2757		rcu_read_unlock_bh();
 >    2758		return 0;
 >    2759	}
 >
 > You're changing line 2699, we used to bump the rx_dropped on line 2700
 > and then the goto on line 2701 takes us to line 2756 - unlock, return.
 >
 > Now since you have replaced the goto on line 2701 with a "break" the
 > code will go from line 2701 to line 2749/2750. If err is set we'll
 > increase rx_dropped again on line 2751.
 >
 > In other words rx_dropped will be increased both on line 2700 and
 > line 2751.
 >
 > What am I missing?
 >
 > Also I don't quite understand your commit message. The only thing we
 > used to skip is the freeing of the skb. Or do you mean we need to
 > return an error from amt_rcv() ?

I'm so sorry that I fully misunderstood your review and I found my 
mistakes...
The rx_dropped was disappeared in my sight even though you pointed.
I think I tried to check only skb, not rx_dropped.
Now I fully understand your review and my mistake.
