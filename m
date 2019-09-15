Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC0C1B31EA
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 22:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfIOUFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 16:05:50 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34923 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfIOUFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 16:05:50 -0400
Received: by mail-io1-f65.google.com with SMTP id q10so2173789iop.2
        for <netdev@vger.kernel.org>; Sun, 15 Sep 2019 13:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jupZ8Rtv/g1xXDvHSliE5q+VyI4ZAE5dj6ha6bPwzjI=;
        b=gAw3lu+YTIOdD/m6HUnZT7AK+ya9Ff0ibv4x1+NHbyr02949Ga7ereuP28E/dR1RUx
         zU0IsVBZ+Zw+XsIbzsd8pBSI0y/YNpxVu/5sLWy85gH8HwuRueeAqcMp0AZyFbY5e42h
         M/aQhU/XL1wwOAgnzZ1Fvaxin/km61GbGYnGSIZYT8vmx8WvL7VLOlYMiNpjOKMindRA
         gQHEWpJZ6n8chAbULHgjcoxGKAtZnceNPKBZT9rsuxcUz6QdcqLS51yib1dzBcJVxcPQ
         FfdYpHRNPa4PqXxxyKCsSg/y7e4RIar5IPCsd3vIU8G7MDKOXPDluL+GmqpewpakDkyl
         dROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jupZ8Rtv/g1xXDvHSliE5q+VyI4ZAE5dj6ha6bPwzjI=;
        b=Ic8pe7Z4yyJ/XDTCx5RqgoE1WlDpNdxjSEsk+h2BpVui2DExxJvPW3VoTKqBkc+qR0
         CyOW17UmjGY9THTN3ZO59hvg3h9rhsL1mbtfigA3HbPkh4ZXWY7EYVjBIdE9c2fhgesj
         DUxMYvs2Vvtd9DcGHrSZWaI9J24Sz4Q/qgxePtgpdNJ+UD7qJ1/eQN/ZVo7wEMNEKNwo
         ayzDiKMquv65KRBIHJyXk/9BPcOl8EYgZ/2i75XkuOg6mgjSbuxYuK+55mMEa4qJSC0G
         7UQVAHKHxe+b10TYTyXsNCuC1VnpnkgEvsvfwrDfN25Rog0ogsJ/FccsBqTqWqtWJZpZ
         rkBA==
X-Gm-Message-State: APjAAAXAxQG88nufBB4UiC+wOed22mA5aWNL/xknfgzUIFdtAO8WP8zm
        iaP78KL00KDw64GAN/u6EkqUloZXReY=
X-Google-Smtp-Source: APXvYqwMzrwH3cikUDn8Tr5jCROPkkZK5NbrFNedvsL6wqes9xOq9qEAh1FlZjgoUk11Suoi/s3NSg==
X-Received: by 2002:a5d:96c6:: with SMTP id r6mr1893679iol.266.1568577949439;
        Sun, 15 Sep 2019 13:05:49 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:b012:b2bf:173a:b7c3? ([2601:282:800:fd80:b012:b2bf:173a:b7c3])
        by smtp.googlemail.com with ESMTPSA id f23sm3465440ioc.36.2019.09.15.13.05.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 13:05:48 -0700 (PDT)
Subject: Re: [patch net-next 02/15] net: fib_notifier: make FIB notifier
 per-netns
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
References: <20190914064608.26799-1-jiri@resnulli.us>
 <20190914064608.26799-3-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <87139e84-4310-6632-c5d5-64610d4cc56e@gmail.com>
Date:   Sun, 15 Sep 2019 14:05:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190914064608.26799-3-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/19 12:45 AM, Jiri Pirko wrote:
>  #define FIB_DUMP_MAX_RETRIES 5
> -int register_fib_notifier(struct notifier_block *nb,
> +int register_fib_notifier(struct net *net, struct notifier_block *nb,
>  			  void (*cb)(struct notifier_block *nb))
>  {
>  	int retries = 0;
>  	int err;
>  
>  	do {
> -		unsigned int fib_seq = fib_seq_sum();
> -		struct net *net;
> -
> -		rcu_read_lock();
> -		for_each_net_rcu(net) {
> -			err = fib_net_dump(net, nb);
> -			if (err)
> -				goto err_fib_net_dump;
> -		}
> -		rcu_read_unlock();
> -
> -		if (fib_dump_is_consistent(nb, cb, fib_seq))
> +		unsigned int fib_seq = fib_seq_sum(net);
> +
> +		err = fib_net_dump(net, nb);
> +		if (err)
> +			return err;
> +
> +		if (fib_dump_is_consistent(net, nb, cb, fib_seq))
>  			return 0;
>  	} while (++retries < FIB_DUMP_MAX_RETRIES);

This is still more complicated than it needs to be. Why lump all
fib_notifier_ops into 1 dump when they are separate databases with
separate seq numbers? Just dump them 1 at a time and retry that 1
database as needed.

ie., This:
    list_for_each_entry_rcu(ops, &net->fib_notifier_ops, list) {
should be in register_fib_notifier and not fib_net_dump.

as it stands you are potentially replaying way more than is needed when
a dump is inconsistent.


>  
>  	return -EBUSY;
> -
> -err_fib_net_dump:
> -	rcu_read_unlock();
> -	return err;
>  }
>  EXPORT_SYMBOL(register_fib_notifier);
>  
> -int unregister_fib_notifier(struct notifier_block *nb)
> +int unregister_fib_notifier(struct net *net, struct notifier_block *nb)
>  {
> -	return atomic_notifier_chain_unregister(&fib_chain, nb);
> +	struct fib_notifier_net *fn_net = net_generic(net, fib_notifier_net_id);
> +
> +	return atomic_notifier_chain_unregister(&fn_net->fib_chain, nb);
>  }
>  EXPORT_SYMBOL(unregister_fib_notifier);
>  





