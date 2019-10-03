Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41187C95F3
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 02:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfJCAgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 20:36:40 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43962 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfJCAgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 20:36:40 -0400
Received: by mail-pl1-f196.google.com with SMTP id f21so629483plj.10
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 17:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s6OzXjMFKg9y/QQfVLwOpyQmJbQGAU2RbVv760dPC2E=;
        b=hvb0Ns6Bh0GXfl5RLt8BRCQgCghGYHgG4foELHfwANihqOVwKRJEvjx/YkLC4jMze9
         n8tTswOsSOYco0SRmNTGji2m88gzvUqK7rBiY5/mCb4QLYtOWZ2Y8WaMq6rd3UQ9jqHX
         oRYQuyB783YzcAeENPeLbSgotGpES6qSPL5xDugBzRmEy8GeY0ry5HcC9LtdbXh1XoZ+
         OOc3fZ2iSCwi7afPHt4yLOEewTxg3+hES/C4Ja8CaZsqIrnXFrsoJiKJSlGrzcVgqnal
         Sq3C8GUCseaYPIqfAyddSIaMA5jGq90wxD/rzdyWItM1id1ugcM/duazCH6GotABTYng
         Lg2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s6OzXjMFKg9y/QQfVLwOpyQmJbQGAU2RbVv760dPC2E=;
        b=Kk18cwjv9I9wplcQUIBPxdM8We3sZihYhMf2qLwN8MPcdqFjvYZd7WppujDL2Aipi7
         4yCjbymFvxFfyahU1vnQJRXs6qe7UuzL20Fer2UYBL11mGV9K8+g1CUEuhgSWft6pcCY
         x2pHYrV+/WQBrgivzeDKrfFEnARyuLZbUfHHfgX8aQ5rQhrvARTJNIulf0OqMJJ3p3Ph
         pg2vBOHGrrBx8XDmbmHJ1A+UHKpO/XRY6k7KuCdM9V6KQyQD8YDMwrCkCaLhFf4WsxS4
         S0RJ4JW+vIXzVLa0GxWabRIaVjjQ6k8qdTCWzGaMTDFUMuveBkfqTtiQ2c9kyuprV1Gy
         zKGQ==
X-Gm-Message-State: APjAAAXDf1X/m9+pMcQMrEcFGnpZ8Ft+8ltOpjSvqQUcZIWDaYwCi4ek
        JznqYrzKX62V9Ry+yw633B4=
X-Google-Smtp-Source: APXvYqyZS8j4zw1HEkD417lTgEE07BgE/h3kSD85Q8VOksRgqdidOC3q3FoE+Mm2JtH9eLEDcn283A==
X-Received: by 2002:a17:902:a618:: with SMTP id u24mr6486260plq.76.1570062999333;
        Wed, 02 Oct 2019 17:36:39 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id f14sm616796pfq.187.2019.10.02.17.36.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 17:36:38 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
To:     David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com
References: <20191001032834.5330-1-dsahern@kernel.org>
 <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
 <18c18892-3f1c-6eb8-abbb-00fd6c9c64d3@gmail.com>
 <146a2f8a-8ee9-65f3-1013-ef60a96aa27b@gmail.com>
 <8d13d82c-6a91-1434-f1af-a2f39ecadbfb@gmail.com>
 <3dc05826-4661-8a8e-0c15-1a711ec84d07@gmail.com>
 <45e62fee-1580-4c5d-7cac-5f0db935fa9e@gmail.com>
 <7bd928cb-1abf-bbae-e1db-505788254e5b@gmail.com>
 <6b74af81-d12d-6abd-fd4f-5c1e758fdde7@gmail.com>
From:   Eric Dumazet <erdnetdev@gmail.com>
Message-ID: <f896d905-9f69-465f-23c0-7e9a6014d990@gmail.com>
Date:   Wed, 2 Oct 2019 17:36:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6b74af81-d12d-6abd-fd4f-5c1e758fdde7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/19 5:10 PM, David Ahern wrote:
> On 10/2/19 4:36 PM, Eric Dumazet wrote:
>> This might be related to a use of a bonding device, with a mlx4 slave.
>>
> 
> does it only happen with bonds?

All my hosts have bonds, some are just fine with your patch, but others are not.

> 
> bond shows IF_READY even though the underlying device is carrier down
> which seems wrong; if a lower device is not carrier up then DAD does not
> really happen.
> 
> A quick test with a VM (and setting carrier off on the tap) shows that
> with the current patch in place the bond address stays in tentative
> state. Reverting this patch and the tentative flag is removed. DAD never
> happens since carrier is off on the one link in the bond, so the
> tentative flag getting cleared is wrong.
> 
> I need to step out; come back to this later.
> 

Note that in my setup nodad flag is requested.
