Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9106424B7F
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 11:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfEUJ20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 05:28:26 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:54120 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfEUJ20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 05:28:26 -0400
Received: by mail-wm1-f49.google.com with SMTP id 198so2178426wme.3
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 02:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d+kw+Zgv9X6U3FHbk/80KUOxiu1uSs6wcAVULVqpV1M=;
        b=jjfWEb/EpOmeAvqO0bez5UV3ywqg0yRaAAxqZcV7Qk7H4YAAUion92ZDw77j1qKLjU
         KX43jxD29gvGjoFbAa9QOLbJoRkEP7lalqD6ctIJ8h3JpeAN2ALh458XIBxE+8chP6gY
         mckslfj/FhobJarkRcgOvE9euor1gkVK1txoOkRQrWwmwmvcGQOqE9+acdcMOPr5dEF+
         woJp+ZtzJ7A9ouZQXWTZ2z+bWTxh1MvCrgUZHtqnKA7Hli2gmIbC6wkj4tl0muuUDNG3
         2THmpOD6Trp1udDsZf1qjuO/lntrRcrgANZX2jrTA2wvhMcs9qfC9jjt3hczCRCIl3oC
         8org==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=d+kw+Zgv9X6U3FHbk/80KUOxiu1uSs6wcAVULVqpV1M=;
        b=KTKjF8mxCi54C6jWHBPQFiLm8IWBJQkT8l/P6/0xUE+Jn4CMT/C6cS831+neR0Oa3M
         uB6ZL+YtOSuU2qTTikCtIITYtorGauEyKxCRjr5GIagCJ/OhHrKIxr+4qwkZjtIPCv9t
         DpkVYG8MEqSuMN79KTFcYtjo9OYR5KjN0bmUfMQH8DV9jQ/hF8wEhOyLnzO2fyDqGBqo
         Y4FEpcw31We8h61ihE8T90y5jJ0uDg+3p8ko+bDMRR7nhD7KvzGWvB/S2RDcbP6lb91h
         /yhulPujQwxJo9ZisT341TTN56ikM/7kOVfPrK7f54+snbmrr8AbQ3IkzUDsHnXJqjQ8
         BnJA==
X-Gm-Message-State: APjAAAWngmq5Dd5hnar9xrH4CYDyTQVmpHjsrEFaK6IMRq/S7cEGVdCu
        qzHVOYDwa8/t6zftP3LTMI0Enh/q63Q=
X-Google-Smtp-Source: APXvYqzbR8CUTDbJF4bv5oc6soLSoUuwjVfMGRseTJOP1pEcdOouLfe0U71kROHoHegYKAu3WGFDtA==
X-Received: by 2002:a1c:f111:: with SMTP id p17mr2544458wmh.62.1558430903601;
        Tue, 21 May 2019 02:28:23 -0700 (PDT)
Received: from [10.16.0.69] (host.78.145.23.62.rev.coltfrance.com. [62.23.145.78])
        by smtp.gmail.com with ESMTPSA id u15sm34884587wru.16.2019.05.21.02.28.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 02:28:22 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] net: vxlan: disallow removing to other namespace
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <1558147343-93724-1-git-send-email-xiangxia.m.yue@gmail.com>
 <20190520.195319.201742803310676769.davem@davemloft.net>
 <CAMDZJNWpv89beaNvVvycJ5YqwcKYiFNuP_gYKz_QmsQ2roiRGw@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <2dc1646c-ac58-f633-0c28-0c3197574cf3@6wind.com>
Date:   Tue, 21 May 2019 11:28:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAMDZJNWpv89beaNvVvycJ5YqwcKYiFNuP_gYKz_QmsQ2roiRGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 21/05/2019 à 07:53, Tonghao Zhang a écrit :
[snip]
> The problem is that we create one vxlan netdevice(e.g dstport 4789 and
> external), and move it to
> one net-namespace, and then we hope create one again(dstport 4789 and
> external) and move it to other net-namespace, but we can't create it.
> 
> $ ip netns add ns100
> $ ip link add vxlan100 type vxlan dstport 4789 external
> $ ip link set dev vxlan100 netns ns100
> $ ip link add vxlan200 type vxlan dstport 4789 external
> RTNETLINK answers: File exists
Why is this a problem? This error is correct, the interface already exists.

> 
> The better way is that we should create directly it in the
> net-namespace. To avoid confuse user, disallow moving it to other
> net-namespace.
There is no confusion, this is a feature. This link part of the vxlan is in
another namespace:

$ ip -d -n ns100 link ls vxlan100
15: vxlan100: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT
group default qlen 1000
    link/ether d6:54:ea:b4:46:a5 brd ff:ff:ff:ff:ff:ff link-netnsid 0
promiscuity 0 minmtu 68 maxmtu 65535
    vxlan externaladdrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size
65536 gso_max_segs 65535

=> "link-netnsid 0" means that the link part is in the nsid 0, ie init_net in my
case.


Regards,
Nicolas
