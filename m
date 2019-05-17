Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A800021A6A
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 17:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbfEQPR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 11:17:57 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:34328 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729202AbfEQPR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 11:17:56 -0400
Received: by mail-pl1-f179.google.com with SMTP id w7so3506201plz.1
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 08:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JV8hIK+TkFXCFiYSKS40PFKlwTIcVajVKYb9eowPzps=;
        b=GMdJOvNMtbu58uKA2IuD6IaJz0ZOz00pM14OqFE/JmCsTwEit0hn0ThC55Y+/RZHuV
         CBYuHGHWYQ3DVD/eDn0Q/8C0O5Qy0UkvHH0d28qZOuHt+B/cILs285G0z/b+ExHia0p6
         bXSmQoIqC+1Y8G851qZ3AJdsnQKza5sy6AR394Ntj/qop/ZNoM/6Ykvd+pgVSnng6kEr
         yuF6oy07hdcmP2WOw1mKOemJM05e3jqVzw7SEuFDBuf3ZtbHfLeeLeAUuWtn7Vgl+Mvp
         GYG7phpaLIrqcper58QQetY+JC3Mgq+2TQ6m9B5asu9z63E26mOLQJKHcuO3gSk+7wwx
         fEZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JV8hIK+TkFXCFiYSKS40PFKlwTIcVajVKYb9eowPzps=;
        b=K7WntD8YzpPNFxXl2aIZZF0WbRf5KJ2UCu1cC9xoKG3d324esyJkGTC1VXU5KxdGVd
         0m9v7Rin9/YqgJH1JmdLtR+8NO8YVAohi8K6tvR8VQc6vWUNTIo6YZQX2gbF52Jz3Euj
         /+pw2N7gJG6iWU1snM3XBxSBffhdgsX75nt/6VGBIa8jpFTetYM5LBFEQhfi5cZcUvzv
         XSYS+K+lQnCJG/hUCbXYD4gohVUfEUD7FROtHo7gNpCPD00xEWK4K6129TydpB6yAV3J
         6lXJRnOkbQQL+RUEwVMfshV8XYZ7hkkEXYMtOjMxORxzlFHtwZa4nwOCJty72lj/3T8w
         82Wg==
X-Gm-Message-State: APjAAAXVNCSj5YddLAr0/tkFFN8iwx4n/huEqdB24eh8b6wi45BOZpxx
        MyYJzknv6eXBqBoUikMklKc=
X-Google-Smtp-Source: APXvYqzDvGeaRkmcQhKuu7z7IQqjwfDfx7KiA6o4BU9m8gtaoeT7O1wrLiEyzzVzPVLnWXJCZMgKGA==
X-Received: by 2002:a17:902:6b44:: with SMTP id g4mr57298915plt.157.1558106275913;
        Fri, 17 May 2019 08:17:55 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:743c:f418:8a94:7ec7? ([2601:282:800:fd80:743c:f418:8a94:7ec7])
        by smtp.googlemail.com with ESMTPSA id u76sm10364368pgc.84.2019.05.17.08.17.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 08:17:54 -0700 (PDT)
Subject: Re: 5.1 `ip route get addr/cidr` regression
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        emersonbernier@tutanota.com, Netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        David Miller <davem@davemloft.net>
Cc:     piraty1@inbox.ru
References: <LaeckvP--3-1@tutanota.com>
 <CAHmME9pwgfN5J=k-2-H0cLWrHSMO2+LHk=Lnfe7qcsewue2Kxw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2e6749cb-3a7a-242a-bd60-5fa7a8e724db@gmail.com>
Date:   Fri, 17 May 2019 09:17:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAHmME9pwgfN5J=k-2-H0cLWrHSMO2+LHk=Lnfe7qcsewue2Kxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/19 4:22 AM, Jason A. Donenfeld wrote:
> Hi,
> 
> I'm back now and catching up with a lot of things. A few people have
> mentioned to me that wg-quick(8), a bash script that makes a bunch of
> iproute2 invocations, appears to be broken on 5.1. I've distilled the
> behavior change down to the following.
> 
> Behavior on 5.0:
> 
> + ip link add wg0 type dummy
> + ip address add 192.168.50.2/24 dev wg0
> + ip link set mtu 1420 up dev wg0
> + ip route get 192.168.50.0/24
> broadcast 192.168.50.0 dev wg0 src 192.168.50.2 uid 0
>    cache <local,brd>
> 
> Behavior on 5.1:
> 
> + ip link add wg0 type dummy
> + ip address add 192.168.50.2/24 dev wg0
> + ip link set mtu 1420 up dev wg0
> + ip route get 192.168.50.0/24
> RTNETLINK answers: Invalid argument

This is a 5.1 change.
a00302b607770 ("net: ipv4: route: perform strict checks also for doit
handlers")

Basically, the /24 is unexpected. I'll send a patch.

> 
> Upon investigating, I'm not sure that `ip route get` was ever suitable
> for getting details on a particular route. So I'll adjust the

'ip route get <prefix> fibmatch' will show the fib entry.

