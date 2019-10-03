Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87ABEC963B
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 03:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfJCBej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 21:34:39 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33618 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfJCBej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 21:34:39 -0400
Received: by mail-pg1-f194.google.com with SMTP id q1so737835pgb.0
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 18:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wTBi/WGvWr+yPKlCjekySaNYX1DdK5ws+t/6UDsCIaM=;
        b=f+nGo2291SMl0tb0V/vS6JKTv4wjWbylAk49IBtjick2gDJ1cYe7MUjOznE3NQYl9A
         PAEq2dvwXelcwJ7wAyZv5uf+HIqo1K/HXskQp6/3UJgasy03RdwmSFrlyLTiI2Q+V2GT
         KvyoAM8R0Uc7niH6CBdvxrvunYdcyksGMGOzPOIEPlnk1H7D1T2fEBvIIBIim8vwNMBL
         U7X885haIQaSmzglxzGuWnn0tYOKduoY5NmyPk8GLVUiO5SEsGB6uVaSOAgHLLloUCHb
         h0UUck5qWIotjxCSkadDHrq1hwlZVAn9DyIgHftrDiUXgU0CEMu7EOmr4oOFNUvNnWa8
         MIUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wTBi/WGvWr+yPKlCjekySaNYX1DdK5ws+t/6UDsCIaM=;
        b=nMzXOqXgTCne9ObWBnPRuHifz966RrxppOCW4dbVpnTyOaDbQLs5l0oNUgAqTDp1eB
         bH8MN3n8W3/RVk6esO6mXSyfvSWTkl6Au7c5OanhPsF1dVy7+UkqgJW2z0wO9S8/w6On
         D1bkOIsvpAqh0MQK3KVO94dpacPZOO1ZtMpexmAaoGc8vvcQMS1lXUDDNV2MJLIP6aaN
         mgNRpiiqW6LijfEvaFgDrNNHcGvdEiiENI+Q8gkPHi0Qfx+T17sFMMpXBUhyg0xTQWzx
         mQR7pxQJDKayYLSz4c4qLUnHi2vDjh2HAH7vnZrWO+MsolT295hU0DcmPM1c31n8tBuR
         LNKw==
X-Gm-Message-State: APjAAAUKlD0gs6Esx4CPPFrAuF9XskYKK0JYkbcOeE95cGSffrVx5+eL
        6VsBl2ESGG/akpubx3RFtmw=
X-Google-Smtp-Source: APXvYqyLXe4NTByrTtPeJjwR3hJkGJEvBJkINgRCtM7yyjdY2D71YQq7lDlBZ4R4WX8VOq8ueqG09Q==
X-Received: by 2002:a63:cb07:: with SMTP id p7mr6880234pgg.232.1570066478745;
        Wed, 02 Oct 2019 18:34:38 -0700 (PDT)
Received: from [172.27.227.234] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id x10sm782365pfr.44.2019.10.02.18.34.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 18:34:37 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 02/15] ipv4: Notify route after insertion to
 the routing table
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-3-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <576d658d-6aab-558c-0a20-13133217d3b6@gmail.com>
Date:   Wed, 2 Oct 2019 19:34:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20191002084103.12138-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/19 2:40 AM, Ido Schimmel wrote:
> @@ -1269,14 +1269,19 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
>  	new_fa->tb_id = tb->tb_id;
>  	new_fa->fa_default = -1;
>  
> -	err = call_fib_entry_notifiers(net, event, key, plen, new_fa, extack);
> +	/* Insert new entry to the list. */
> +	err = fib_insert_alias(t, tp, l, new_fa, fa, key);
>  	if (err)
>  		goto out_free_new_fa;
>  
> -	/* Insert new entry to the list. */
> -	err = fib_insert_alias(t, tp, l, new_fa, fa, key);
> +	/* The alias was already inserted, so the node must exist. */
> +	l = fib_find_node(t, &tp, key);
> +	if (WARN_ON_ONCE(!l))
> +		goto out_free_new_fa;

Maybe I am missing something but, the 'l' is only needed for the error
path, so optimize for the success case and only lookup the node if the
notifier fails.

> +
> +	err = call_fib_entry_notifiers(net, event, key, plen, new_fa, extack);
>  	if (err)
> -		goto out_fib_notif;
> +		goto out_remove_new_fa;
>  
>  	if (!plen)
>  		tb->tb_num_default++;
> @@ -1287,14 +1292,8 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
>  succeeded:
>  	return 0;
>  
> -out_fib_notif:
> -	/* notifier was sent that entry would be added to trie, but
> -	 * the add failed and need to recover. Only failure for
> -	 * fib_insert_alias is ENOMEM.
> -	 */
> -	NL_SET_ERR_MSG(extack, "Failed to insert route into trie");
> -	call_fib_entry_notifiers(net, FIB_EVENT_ENTRY_DEL, key,
> -				 plen, new_fa, NULL);
> +out_remove_new_fa:
> +	fib_remove_alias(t, tp, l, new_fa);
>  out_free_new_fa:
>  	kmem_cache_free(fn_alias_kmem, new_fa);
>  out:
> 

