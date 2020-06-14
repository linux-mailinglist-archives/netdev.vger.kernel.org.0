Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FEA1F860C
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 02:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgFNAhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 20:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgFNAhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 20:37:13 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1205C03E96F;
        Sat, 13 Jun 2020 17:37:12 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id k22so10006543qtm.6;
        Sat, 13 Jun 2020 17:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fBpKEfy4giOAG9C72IJdyKSRU7EpIZAFk0p2BQu+9Qg=;
        b=OupMvk/lI9cd4FtCCslCajVbN7GjhzhG/2PVqUv7B/w/ief9G43e17dR1YkE1P7A4E
         jFN6QnMGxnkIZYYwCkw0uap9SapozU611SKhuYxCzokBpx4CN9ysXAvRgIlvsgIS5zfu
         6AZIz/sbu4Cb78vtH7Tl8/raES1wh6zPqOa2xMQehyUxJhi9HH/mzVtSBmrSNGYHmrC3
         CrnVA8E79fVWruiLU4u5FZETAnFn8Bm+I/LmHm9mLfHifPUvgqbIvmZcPsHv+wWmB8bh
         XnPdPJyKHdLCk+/Jtl7YKVXJmOv4qgxiUhmvSmv67qmsOEr3U3SkDQ+59NvDE+hJ9ikP
         RVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fBpKEfy4giOAG9C72IJdyKSRU7EpIZAFk0p2BQu+9Qg=;
        b=eWnoPRnxjlJX1VFrzCWRSdbIslz9PIjJYhWgiW6E5dZFa4wYElUWSlbPtceg5W81bI
         /LOPyMQ7o2fEC28hCKQgXnYnZD38vH9xcmdGGSTUfRmvN0wv8LAZg6KquX+qAqwvS/SM
         BNkdJgr6mPV6xHdcBPO/dIW2QIpoVnETCYFbp/XYwgk+XdDqMubbw+ryWMCISSf8eUSm
         QsMfcejs4I5GARbtnDvzXAu5MiAYJIXMLf4bO1mYYrG/uyQW4wkXOp0VoatqyFdDUpbZ
         6gQJuzrrmK9V/+Za3y6JzuJb10AVb2iiIwNLZFSCi9u83Ff2Aalf8m/xlPoP24PnIdwE
         Jp6Q==
X-Gm-Message-State: AOAM533mnEFmX/6bWvH0lZ+ykTEL2PnRlpue2q0XvecVtwuZXPAHUNXU
        FtuoUaU09E9GxqwKEiDHme4=
X-Google-Smtp-Source: ABdhPJyqdOkG5IMCgkOFeooC8CrEiCjtrPE+uMEeldGj4jVJMd9peYSvNEhRRbgwHyvgY+Zcc9CYIA==
X-Received: by 2002:ac8:464a:: with SMTP id f10mr9535087qto.391.1592095031955;
        Sat, 13 Jun 2020 17:37:11 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:c0a6:d168:a4bb:a408? ([2601:284:8202:10b0:c0a6:d168:a4bb:a408])
        by smtp.googlemail.com with ESMTPSA id y54sm8542457qtj.28.2020.06.13.17.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jun 2020 17:37:11 -0700 (PDT)
Subject: Re: [RFC,net-next, 1/5] l3mdev: add infrastructure for table to VRF
 mapping
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Dinesh Dutt <didutt@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>
References: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
 <20200612164937.5468-2-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <983c5d6b-5366-dfd3-eab2-2727e056d5c5@gmail.com>
Date:   Sat, 13 Jun 2020 18:37:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200612164937.5468-2-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/12/20 10:49 AM, Andrea Mayer wrote:
> @@ -37,6 +45,15 @@ struct l3mdev_ops {
>  
>  #ifdef CONFIG_NET_L3_MASTER_DEV
>  
> +int l3mdev_table_lookup_register(enum l3mdev_type l3type,
> +				 int (*fn)(struct net *net, u32 table_id));
> +
> +void l3mdev_table_lookup_unregister(enum l3mdev_type l3type,
> +				    int (*fn)(struct net *net, u32 table_id));
> +
> +int l3mdev_ifindex_lookup_by_table_id(enum l3mdev_type l3type, struct net *net,
> +				      u32 table_id);
> +
>  int l3mdev_fib_rule_match(struct net *net, struct flowi *fl,
>  			  struct fib_lookup_arg *arg);
>  
> @@ -280,6 +297,26 @@ struct sk_buff *l3mdev_ip6_out(struct sock *sk, struct sk_buff *skb)
>  	return skb;
>  }
>  
> +static inline
> +int l3mdev_table_lookup_register(enum l3mdev_type l3type,
> +				 int (*fn)(struct net *net, u32 table_id))
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline
> +void l3mdev_table_lookup_unregister(enum l3mdev_type l3type,
> +				    int (*fn)(struct net *net, u32 table_id))
> +{
> +}
> +
> +static inline
> +int l3mdev_ifindex_lookup_by_table_id(enum l3mdev_type l3type, struct net *net,
> +				      u32 table_id)
> +{
> +	return -ENODEV;
> +}
> +
>  static inline
>  int l3mdev_fib_rule_match(struct net *net, struct flowi *fl,
>  			  struct fib_lookup_arg *arg)
> diff --git a/net/l3mdev/l3mdev.c b/net/l3mdev/l3mdev.c
> index f35899d45a9a..6cc1fe7eb039 100644
> --- a/net/l3mdev/l3mdev.c
> +++ b/net/l3mdev/l3mdev.c
> @@ -9,6 +9,101 @@
>  #include <net/fib_rules.h>
>  #include <net/l3mdev.h>
>  
> +DEFINE_SPINLOCK(l3mdev_lock);
> +
> +typedef int (*lookup_by_table_id_t)(struct net *net, u32 table_d);
> +

I should have caught this earlier. Move lookup_by_table_id_t to l3mdev.h
and use above for 'fn' in l3mdev_table_lookup_{un,}register

