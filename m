Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A34DEAB228
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 07:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbfIFFyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 01:54:44 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:37017 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727970AbfIFFyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 01:54:44 -0400
Received: by mail-wm1-f48.google.com with SMTP id r195so5569808wme.2
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 22:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vSCRz7FXh21cgqx8uYjCWiiojJiYntnq7jIe+esj3PU=;
        b=CXkIwLunHjc7WdtpBGrWSeHbkberbMdPh95KWi6YH+321mc5amCKnb/kL6lbzEzS1Q
         n5AYd3cn5INtWsNhcu7qputgZRyHUfFvWhpzFYUdIrn4mkp2TIVushrcH0fizR8rvlFx
         xLAH9KMkd53K+ZcetxIt+cmzJNfjkOakahx2Xqs/C2wtos2HVhsbAHSir+Zd4BcyOwxk
         YhDwtgrGG1vVl7UnPsL3JygMSsp8kGmNYXFQTL9PrLdJoomro8Cpu9J7VF55WK/FsBXn
         R/WYZIqgcaFPiMaFLrfIiuy0Hje/bbV+31jgS4ZFXJWa2Ye7vw6QfVMU2xZZXNtGo0s/
         ccvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vSCRz7FXh21cgqx8uYjCWiiojJiYntnq7jIe+esj3PU=;
        b=Uq21pXdyOWsOn5//ZV+MkngQfkYFCx9x8hQ5J2MdjBTndtzU7L3oDmZE2VtSZzM3DI
         qmp6YPFj1EJROz3SXH2bDKBwu+eWfMsLv6tK7J9snM7Fbwfodvxi8xM94mE1krP/JHk+
         FKGfhhCWFT2eZWAOGl/tELGPFLQl5v7264icJuvfKZLLpdWrK6rdClJzPO2PDCufdc2M
         U3gXsZYNQnxDLu1ELiGugKLnJA1hhcaIw6ctb2eqBtOeTSpItW9T4NFK5JaRcS3DFLBV
         okC5KaArXkqH9mENXmZd1WdmoR8vkmIN/jcyWqxiGArfZXpEc6dOkZ2zgqae/in/ne5m
         wePQ==
X-Gm-Message-State: APjAAAUGp7/zm7CS2gXpIHGEUItjW6s4gMI+29FUS37I5eEtf1SoO7aL
        HEkhOZj3EU4fSAmRqN0voCU=
X-Google-Smtp-Source: APXvYqzntCZHuchj7X38aEfzCOIG0mavOHOux+nTiLUexILaHR8/velhKM4rCoctg0KqEIdm6AfwcA==
X-Received: by 2002:a1c:1981:: with SMTP id 123mr5563061wmz.88.1567749282339;
        Thu, 05 Sep 2019 22:54:42 -0700 (PDT)
Received: from [192.168.8.147] (147.175.185.81.rev.sfr.net. [81.185.175.147])
        by smtp.gmail.com with ESMTPSA id b15sm4371646wmb.28.2019.09.05.22.54.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Sep 2019 22:54:41 -0700 (PDT)
Subject: Re: [patch net-next] net: fib_notifier: move fib_notifier_ops from
 struct net into per-net struct
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        mlxsw@mellanox.com
References: <20190905180656.4756-1-jiri@resnulli.us>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bb24e9d5-24c6-d590-e490-be2226016288@gmail.com>
Date:   Fri, 6 Sep 2019 07:54:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190905180656.4756-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/5/19 8:06 PM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> No need for fib_notifier_ops to be in struct net. It is used only by
> fib_notifier as a private data. Use net_generic to introduce per-net
> fib_notifier struct and move fib_notifier_ops there.
> 
>

...

>  static struct pernet_operations fib_notifier_net_ops = {
>  	.init = fib_notifier_net_init,
>  	.exit = fib_notifier_net_exit,
> +	.id = &fib_notifier_net_id,
> +	.size = sizeof(struct fib_notifier_net),
>  };
>  
>  static int __init fib_notifier_init(void)
> 

Note that this will allocate a block of memory (in ops_init()) to hold this,
plus a second one to hold the pointer to this block.

Due to kmalloc() constraints, this block will use more memory.

Not sure your patch is a win, since it makes things a bit more complex.

Is it a preparation patch so that you can add later other fields in struct fib_notifier_net ?

