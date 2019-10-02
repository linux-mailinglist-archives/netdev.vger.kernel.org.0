Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1F04C9465
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 00:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfJBWgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 18:36:49 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45398 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfJBWgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 18:36:49 -0400
Received: by mail-pl1-f196.google.com with SMTP id u12so507123pls.12
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 15:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rqMlx/qkwuOcoyzH9cUhrGA427PGTQG7iAtyzC9L+F0=;
        b=VBe/RqWjD/IswAlHGPOnLh70Cc6+H2XRSaxI7seB+UwfxtjcBi5Z8i2DkbfDNSsNlz
         K+BiaX6wOZVsVRHaeS2jqImUTRcz0wxgn3Ddl7pINjnXIG5TWn+ef43DCEh1yytZ1mc8
         5ItryvPOomj73X0aaXJTsIBG4DgUHIsQRV6TdiepAIMc2zpF2GKgGF8UP/8cia764ta4
         DjVuEP0Yed8uaS23nAfWCWyYF3DWpR+W9KSEj092x0RKaMtRUYnzFigLysB0I8+nySL3
         qz6v6gEIlzxIB3etdXa4nAmQ6lL6ZhV7eOVkqhx0gWF7GqjwHXdkszOaAok/DsEI/NEN
         FGbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rqMlx/qkwuOcoyzH9cUhrGA427PGTQG7iAtyzC9L+F0=;
        b=H75uPIZk3+88i/n9SqreiHcugHn2ZIuorzKnykrnfdCUdFAtImbuC2SNibpbhHvl7X
         mjiO6rfOBSh4sItzNkycqRtN/oaBoVzsYVVX3SAw8x6oKapAe9icX5BhMwAuKcXwYTJm
         tfRf8Fphqtp4NmgQRFh+5LDGeyha8Kb2xJBkmy02B9IZWjfkWfFixF+hN9DZwUR4Hd2C
         /uDhtrgeHlXYIffSskxFq8hH/f214t2qBGZPHT6LAuzret3UOmti97bRe87r9clpPqQ0
         Gd22YQYFhU8Bmb274y47y2hngH8UozquMwaGSo8kan1PLFmmqbwtIKayY/Hpdkf/l4G2
         UPwA==
X-Gm-Message-State: APjAAAXLf7q1UaL9sbg+ozv9sIRr7Pu2+8sFnFxgZgNBRDEGbIcfkzHH
        s90c3cI99JMRNVPVxVnlaas=
X-Google-Smtp-Source: APXvYqyg19hAsAIcwNIdZM+ExQmJdNIj2yXMNq4rv4C2S2B3K9Rm0fj60Ln/YXyYjDCmBO+YsFe4dQ==
X-Received: by 2002:a17:902:a413:: with SMTP id p19mr6393682plq.210.1570055808814;
        Wed, 02 Oct 2019 15:36:48 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id c8sm464028pfi.117.2019.10.02.15.36.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 15:36:48 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com
References: <20191001032834.5330-1-dsahern@kernel.org>
 <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
 <18c18892-3f1c-6eb8-abbb-00fd6c9c64d3@gmail.com>
 <146a2f8a-8ee9-65f3-1013-ef60a96aa27b@gmail.com>
 <8d13d82c-6a91-1434-f1af-a2f39ecadbfb@gmail.com>
 <3dc05826-4661-8a8e-0c15-1a711ec84d07@gmail.com>
 <45e62fee-1580-4c5d-7cac-5f0db935fa9e@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7bd928cb-1abf-bbae-e1db-505788254e5b@gmail.com>
Date:   Wed, 2 Oct 2019 15:36:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <45e62fee-1580-4c5d-7cac-5f0db935fa9e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/19 3:33 PM, David Ahern wrote:
> On 10/2/19 4:21 PM, Eric Dumazet wrote:
>> o syzbot this time, but complete lack of connectivity on some of my test hosts.
>>
>> Incoming IPv6 packets go to ip6_forward() (!!!) and are dropped there.
> 
> what does 'ip -6 addr sh' show when it is in this state? Any idea of the
> order of events?

This might be related to a use of a bonding device, with a mlx4 slave.

"ip -6 addr sh" shows the same output before/after the patch.

lpaa23:~# ip -6 addr sh dev eth0
2: eth0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 5102 state UP 
    inet6 2607:f8b0:8099:e17::/128 scope global nodad 
       valid_lft forever preferred_lft forever
    inet6 fe80::21a:11ff:fec3:d7f/64 scope link 
       valid_lft forever preferred_lft forever

> 
> I flipped to IF_READY based on addrconf_ifdown and idev checks seeming
> more appropriate.
> 

