Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27AE5D5236
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 21:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbfJLTe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 15:34:56 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35137 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729280AbfJLTe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 15:34:56 -0400
Received: by mail-lj1-f194.google.com with SMTP id m7so12934708lji.2
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 12:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wgrBphK2ZKLKLKQJBxJ+04hzcg40mP5P57Sgt0XI3AI=;
        b=F4fTfDBgS2eid7oSFip/FDEDfPXrx4FrxGQxqvEl6QMaNqZR+i+EZqafXAthP5P9+x
         yHDghCUdv3wc8EPxs/921ZARMAob8jyZMCrTSv0zK99uzKHDGI8lw/wBsKCd17vOs5fB
         rUJsYkHvgyQ4O+KQlKvYeWoUVRTtnYMV1MlGJD97zCMfaEMG9XKwULB/glNYZpP06Wnv
         JjMCb4X+FZWgQRRmLr3t4MvFWuS0hGzksJJ8e9Ubv7NGr8M4YDefwzP6AcY0TZ2fj5Io
         0GjbMofkS1RYHQNwGyRtHqTtYj9UuTHx+IUHTuF1vjhdUF74ZGYN6abZhYWqg/cwvttF
         nt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wgrBphK2ZKLKLKQJBxJ+04hzcg40mP5P57Sgt0XI3AI=;
        b=iXjL3xAuhiTz6X6QZZGa9D0x5kcn4Q30BWLyMcBD/Xr5hLyFNtrbA+Auei3EI0MYZs
         R7sItYRL2aFEoxPYZz2GWRnI0oWWcSRUZMxXQNr/xXmvLZpETjsDShuztL/Jzd/EvNbz
         uRViQKLQN3qSJu3AyFjKlTlTFmUTXtgAXTqBW7fOpFxexzULG15+mPiOr+kwGFFdVv6/
         EFRZobbzs0joMqVUr8jtoZmN4WGKQ2BpDXP3u6FmB5Z2hhpJ4anbnuQOzgjykvrP1fJM
         2HDsyLB/1flSqLfPUsrdIylJyW6Lc0VMuz957DGjn0v3eBBBEZbpnFjYseLo6s2H6wYB
         USnw==
X-Gm-Message-State: APjAAAU4JYXkJlxkZwenIZ529zQMNHrDLKUm/CIIYIkOyTEGGp1OQ5ME
        zhQmyiZNIysFQ0eLfb9XdaGycQ==
X-Google-Smtp-Source: APXvYqwpJi0zA6Rs0Ts729eEXfP/zzoIHE+HxlK5BMebEI/QXwfiMx4thmdG6MDW+kQBR7LX7eF+hw==
X-Received: by 2002:a05:651c:1213:: with SMTP id i19mr6593579lja.19.1570908892385;
        Sat, 12 Oct 2019 12:34:52 -0700 (PDT)
Received: from wasted.cogentembedded.com ([2a00:1fa0:42ce:cb54:d810:b267:5380:ba01])
        by smtp.gmail.com with ESMTPSA id g21sm2991604lje.67.2019.10.12.12.34.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Oct 2019 12:34:51 -0700 (PDT)
Subject: Re: [PATCH net] net: sched: act_mirred: drop skb's dst_entry in
 ingress redirection
To:     Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191012071620.8595-1-zhiyuan2048@linux.alibaba.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <2ad15b96-156d-7b71-0e37-74ceeacade35@cogentembedded.com>
Date:   Sat, 12 Oct 2019 22:34:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20191012071620.8595-1-zhiyuan2048@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 10/12/2019 10:16 AM, Zhiyuan Hou wrote:

> In act_mirred's ingress redirection, if the skb's dst_entry is valid
> when call function netif_receive_skb, the fllowing l3 stack process

  Following or flowing?

> (ip_rcv_finish_core) will check dst_entry and skip the routing
> decision. Using the old dst_entry is unexpected and may discard the
> skb in some case. For example dst->dst_input points to dst_discard.
> 
> This patch drops the skb's dst_entry before calling netif_receive_skb
> so that the skb can be made routing decision like a normal ingress
> skb.
> 
> Signed-off-by: Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>
> ---
>  net/sched/act_mirred.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> index 9ce073a05414..6108a64c0cd5 100644
> --- a/net/sched/act_mirred.c
> +++ b/net/sched/act_mirred.c
[...]
> @@ -298,8 +299,10 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
>  
>  	if (!want_ingress)
>  		err = dev_queue_xmit(skb2);
> -	else
> +	else {
> +		skb_dst_drop(skb2);
>  		err = netif_receive_skb(skb2);
> +	}

   If you introduce {} in one *if* branch, {} should be added to the other branches as well,
says CodingStyle.

[...]

MBR, Sergei
