Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C746C56BEC5
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238631AbiGHQLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 12:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238042AbiGHQLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 12:11:04 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A2276E80
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 09:11:01 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id z12so21574526wrq.7
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 09:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bpeviNdMJSeaonZjOsrJbUqWDupIi94NpwfR84MLGy4=;
        b=U/4wYapldmAc1Tb4Y9HXfvkWBRYf386Plmkz2URaFEEwRsmTUAmT3bgkuQa0iaxL/8
         d9cdIgnn2St7+8fxrPYxk1hsHvq3C/a6CTUApIze6+yMv6ZCqTeAfm/a1MuX5ccPD5bH
         tUCMsOmQWnEaWDKgEffIiXnqKR53TK9CK4v5vUacZlPnXzMTCoXl0948Dq2ifl9qwHLM
         uuwHYgxKCZMGIoS6pSBZ7hW31gSNK0/QvxmUMnIvXUj2SAp3ftBGQdaCiuQoKb2NA3mF
         3U0M2z/6bDnSB9iAOy849W6Uq3kAMxz3arhRGTXKcAEbGhN2Lg5K2lhF0ccPbu59MIcT
         VRbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bpeviNdMJSeaonZjOsrJbUqWDupIi94NpwfR84MLGy4=;
        b=354bXJWEfUQDwfBpZO3ElDLsI2Tl7B5zgsMXUorHccKkMoMCu89nxAIn55VQh13WOw
         u8aQ8M0Z85ZlwaWeBZa3Z9RxCJbfkZ40F6DE/ZiR7Dw91m406fsQx3J5DkvXOp+Vaa5n
         PCHZLukIJgKEAnlayRHqxmWfGT+1PXmKQmc6W7QOIj9nea+1rUwjO3UhI1pNXr3C6jRQ
         OuERFriVfrCwR5MjXNpbse2IZAJqmZvnGZCwC/lGgwGY0U1bztYPPyrzjJEFGH00P6Ji
         XgdG+8XXJTYtimVElXauMKBcFhk0DMgjWHgihALEgPCSBjHoW9oyVEm0tJhjj0/zUBSH
         pWOA==
X-Gm-Message-State: AJIora8JWv+d2z+y+lgu1dEqWu4mNvq4E75WnTBfXtZPq0AOMrqydAat
        oc7tAYbT2io9hTC62yWnNeo=
X-Google-Smtp-Source: AGRyM1tx1BwTY7vTaguk0owmyko7Boe6WIsCJKFQzKflVGL/eJeS7n0YqskNO9V7J4c61Jt6FUJPTA==
X-Received: by 2002:a5d:5985:0:b0:21b:c6dd:3470 with SMTP id n5-20020a5d5985000000b0021bc6dd3470mr4255361wri.436.1657296660131;
        Fri, 08 Jul 2022 09:11:00 -0700 (PDT)
Received: from [10.0.0.10] ([37.166.13.195])
        by smtp.gmail.com with ESMTPSA id c189-20020a1c35c6000000b003a046549a85sm2554737wma.37.2022.07.08.09.10.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 09:10:59 -0700 (PDT)
Message-ID: <9c2f78e4-6bf3-9eb1-9dc2-67371a6d68e1@gmail.com>
Date:   Fri, 8 Jul 2022 18:10:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 net] af_unix: Do not call kmemdup() for init_net's
 sysctl table.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
References: <20220627233627.51646-1-kuniyu@amazon.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220627233627.51646-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/28/22 01:36, Kuniyuki Iwashima wrote:
> While setting up init_net's sysctl table, we need not duplicate the
> global table and can use it directly as ipv4_sysctl_init_net() does.
>
> Unlike IPv4, AF_UNIX does not have a huge sysctl table for now, so it
> cannot be a problem, but this patch makes code consistent.
>
> Fixes: 1597fbc0faf8 ("[UNIX]: Make the unix sysctl tables per-namespace")
> Acked-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> v3:
>    * Update changelog
>    * Fix a bug when we unload unix.ko
>
> v2: https://lore.kernel.org/all/20220626082331.36119-1-kuniyu@amazon.com/
>    * Fix NULL comparison style by checkpatch.pl
>
> v1: https://lore.kernel.org/all/20220626074454.28944-1-kuniyu@amazon.com/
> ---
>   net/unix/sysctl_net_unix.c | 19 +++++++++++++------
>   1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
> index 01d44e2598e2..3f1fdffd6092 100644
> --- a/net/unix/sysctl_net_unix.c
> +++ b/net/unix/sysctl_net_unix.c
> @@ -26,11 +26,16 @@ int __net_init unix_sysctl_register(struct net *net)
>   {
>   	struct ctl_table *table;
>   
> -	table = kmemdup(unix_table, sizeof(unix_table), GFP_KERNEL);
> -	if (table == NULL)
> -		goto err_alloc;
> +	if (net_eq(net, &init_net)) {
> +		table = unix_table;
> +	} else {
> +		table = kmemdup(unix_table, sizeof(unix_table), GFP_KERNEL);
> +		if (!table)
> +			goto err_alloc;
> +
> +		table[0].data = &net->unx.sysctl_max_dgram_qlen;
> +	}
>   
> -	table[0].data = &net->unx.sysctl_max_dgram_qlen;
>   	net->unx.ctl = register_net_sysctl(net, "net/unix", table);
>   	if (net->unx.ctl == NULL)
>   		goto err_reg;
> @@ -38,7 +43,8 @@ int __net_init unix_sysctl_register(struct net *net)
>   	return 0;
>   
>   err_reg:
> -	kfree(table);
> +	if (net_eq(net, &init_net))
> +		kfree(table);

Inverted test, I guess :/

I will send a fix.


>   err_alloc:
>   	return -ENOMEM;
>   }
> @@ -49,5 +55,6 @@ void unix_sysctl_unregister(struct net *net)
>   
>   	table = net->unx.ctl->ctl_table_arg;
>   	unregister_net_sysctl_table(net->unx.ctl);
> -	kfree(table);
> +	if (!net_eq(net, &init_net))
> +		kfree(table);
>   }
