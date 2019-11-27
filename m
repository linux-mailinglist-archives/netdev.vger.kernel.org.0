Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A3E10AF74
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 13:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfK0MTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 07:19:47 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33999 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfK0MTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 07:19:47 -0500
Received: by mail-wr1-f67.google.com with SMTP id t2so26431330wrr.1
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 04:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FMimUsqn5OSdEi9VQiLPxoBdHD+6WD3aHKdIR9Mp5bI=;
        b=bd5iQk4a6QFSJtjCEQoahnV4Y0lbvvuEmEU6WG+3SUu9/3mtyHV6/yqq7TvFJePhPw
         sBSxEhTPIb+FN1IeKCNjteGS3gamgd4Rrvo+raaHDY0+hRrcdq2RfxZ6WWy80tYW4TWp
         N7+24SfJMhVE2PG5h2kg+/YpRhKBWJ25a5UTc1c+lX5fsM6RkwEpzv8ZQ9lZbCO8ntRw
         H+t2C2ncQDI05T797O3OgyhLRU9NHRpOKD/u4gFHP8C/b7PGCKEQ9YdcxniC66wgCLnD
         kvGK+mpVQ/+uNJgUbw0Mq9UHNmPErXb9B1a1lRiCnjUATIGX9GDDoi+SnS/w9ftP8Gak
         1Lvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FMimUsqn5OSdEi9VQiLPxoBdHD+6WD3aHKdIR9Mp5bI=;
        b=VOgTgWQWNzSYGYjWMDlc8v9TkvMkzTLhY2sA8FQZN4Ex40puhYxIqR0ZGdoP0Y2G9v
         TbIJpxQyh8xrD3ttF0CsNkgZicKRj1ETYe1bjMGJIVRO6SHmZD4zSixhbrif9Tbk4+3A
         QzM+b9kYVVBtBXychsL6kzjprjMK8lu99rBIcg05m2cModN374ovkLXkGBqqQGpoEp8U
         yOB20pQSGefJPceSmNCgtAaFEmfOMIOYsNtMz/n5u2JuBxw5uiWAfbd5IrX3zcJXJCTy
         Gr+OFNHXNbc676BqpI5gpCbgmJpIgBnV+NKokhPfc1AbnUBYLX8wdW277gLVw+c8YdLT
         LBZQ==
X-Gm-Message-State: APjAAAXUxYN9YGWutU6l5marTNHsAQrtt6mIxC9eAvEAeLwyxyZgRpOH
        T0KQqN2h4jZb83y7jl9bs5za+nRxuXz9BtPd
X-Google-Smtp-Source: APXvYqxffeIjEoWnIPNKSBxVN3cELS35/YNaAmPPRqbb1UVE1KXZSXfoKL70wX6wVkYsUa+94HDa0w==
X-Received: by 2002:adf:eb42:: with SMTP id u2mr24495674wrn.173.1574857185059;
        Wed, 27 Nov 2019 04:19:45 -0800 (PST)
Received: from ?IPv6:2001:1620:2777:11:cde9:57f6:17e:8aa5? ([2001:1620:2777:11:cde9:57f6:17e:8aa5])
        by smtp.gmail.com with ESMTPSA id o21sm6349665wmc.17.2019.11.27.04.19.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 04:19:43 -0800 (PST)
Subject: Re: [PATCH v2] net: ip/tnl: Set iph->id only when don't fragment is
 not set
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru,
        netdev@vger.kernel.org
References: <20191124132418.GA13864@fuckup>
 <20191125.144139.1331751213975518867.davem@davemloft.net>
 <4e964168-2c83-24bb-8e44-f5f47555e589@gmail.com>
 <10e81a17-6b38-3cfa-8bd2-04ff43a30541@gmail.com>
 <a78cf0a6-3170-bb5f-4626-11c22f438646@gmail.com>
 <edbe602e-40ae-3f1e-8abd-a6c36b306865@gmail.com>
From:   Oliver Herms <oliver.peter.herms@gmail.com>
Message-ID: <57bf0aa5-9640-bf41-41f1-005a1d5d0b62@gmail.com>
Date:   Wed, 27 Nov 2019 13:19:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <edbe602e-40ae-3f1e-8abd-a6c36b306865@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.11.19 01:28, Eric Dumazet wrote:
> 
> 
> On 11/26/19 3:32 PM, Oliver Herms wrote:
>> Using a simple incrementation here, as with sockets, would solve my problem well enough.
>>
> 
> I have to ask : Are you aware that linux is SMP OS ?
> 
> If on a mostly idle host, two packets need a different ID, using a " simple incrementation" 
> wont fit the need.
> 
> sockets are protected against concurrent increments by their lock.
> 
I know and I'm not going to mess around with TCP.
I've double checked and found that for non IP tunnel traffic (UDP, TCP, etc.) the cheap function
ip_select_ident_segs() is being used. That is absolutely fine. Nothing to optimize here.

For IP tunnels __ip_select_ident is being called.
And that one is way more expensive than ip_select_ident_segs().

ip_select_ident_segs() increments a counter (yes, I'm aware it is protected by lock).
If somehow __ip_select_ident could be refactored to work in a similar fashion that
would solve my problem.

Thanks
Oliver
