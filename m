Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7BD1281BE
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 18:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfLTR7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 12:59:53 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37301 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbfLTR7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 12:59:53 -0500
Received: by mail-qk1-f195.google.com with SMTP id 21so8355732qky.4
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 09:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AKuatM0y3ooR37SXFCTdVACrZiBimSZ339fk0focLFE=;
        b=Bd/3FNn5CwlogigosRNb+/qMVP7x7yjsRwKs/T4pV1HvFYXiVGokBoq+IfzG4C75DF
         ZRLq9ljUWggvR3a4WB49tuJbwmYiboNNC5LCILjjKr7IbRQ9QGC/QKYquVL/qszHnbUl
         dlx6j4bv2eK9oCWEssU+NYaWSjwuCfrSQ1NPElYHAZQ+jnLomiNYV4YNySp6f5ELMBqv
         4MFkFeNjdIEUWbeKFa6OVvslXMrXAAmB3Oj74uGRgBI6nYdva6TEqpwnDIbsNAa3c32o
         qOlfFxM19BEZY0u6XwPr4hk/Ltv6rBQNCNizN9t6IBsRb+PhigE1qU/KS4a5nQoFd6yZ
         nEXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AKuatM0y3ooR37SXFCTdVACrZiBimSZ339fk0focLFE=;
        b=r6LynmI4PE81+8XxR21ShLluziFdda4QMjwzwejVKkn8EjAjF2cKJUUyoIlXUPDAHH
         VzbtTFvar0Vj94+9CSBabyLfVRlpRW7VxcKmdEJqbLozeVVy5y7HKqswgf+fo4V4Qfyd
         Kj/bvEu2jBSLgAIQwl7AzhDJjfc6Hk4nUXZ/lqfg5XS56Z0s+b46WgLB8gNjY4AuC7qv
         iMdGyfKCbjHuVyfQQSDRqYGRakwAHBo1ElxDEJf3jbr6GfNP5TmszuxybpbI9eSrMeVm
         DJRhNeQf89BHc5ZnGb8asmF/g+72ZmZ4CKhayFp+89REWtf0HyM8+geLXb5Hutnmda9b
         vtRw==
X-Gm-Message-State: APjAAAU8MlmWTKQaF9X7NnzKh+bbmNcZ5itf5NR3Y0Fz7iEX10b9q5an
        ZNCiKfD4FsRaSbjbhVw2XQE=
X-Google-Smtp-Source: APXvYqxkXeA7XcEOqB3m5W4tD56A0lPBfZhxoKIYtC5LFGr8jm1HuHc+6Fy5o5NH1MkD+ESy5WUmfg==
X-Received: by 2002:a37:89c7:: with SMTP id l190mr14621416qkd.498.1576864792626;
        Fri, 20 Dec 2019 09:59:52 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:d462:ea64:486f:4002? ([2601:282:800:fd80:d462:ea64:486f:4002])
        by smtp.googlemail.com with ESMTPSA id v5sm3330389qtc.64.2019.12.20.09.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 09:59:51 -0800 (PST)
Subject: Re: [patch net-next 1/4] net: call
 call_netdevice_unregister_net_notifiers from unregister
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, leon@kernel.org, tariqt@mellanox.com,
        ayal@mellanox.com, vladbu@mellanox.com, michaelgur@mellanox.com,
        moshe@mellanox.com, mlxsw@mellanox.com
References: <20191220123542.26315-1-jiri@resnulli.us>
 <20191220123542.26315-2-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <029e89ea-6ca8-bdd0-92bd-17025f5f1973@gmail.com>
Date:   Fri, 20 Dec 2019 10:59:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191220123542.26315-2-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/19 5:35 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> The function does the same thing as the existing code, so rather call
> call_netdevice_unregister_net_notifiers() instead of code duplication.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  net/core/dev.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


