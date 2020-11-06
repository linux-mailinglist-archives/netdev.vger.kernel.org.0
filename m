Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432992A9141
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgKFI1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgKFI1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:27:53 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA69C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 00:27:53 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id dk16so709775ejb.12
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 00:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dxxdg5vykW5t09YvbbZDwBqARbOva9lwcwb08iLB/24=;
        b=KL1dCFOzK5EkGlCiUJnvY/OmmVeFNBiDP7tzgPW/LZ3z+wUJY2h074oY28KKJk9G8O
         LvLkrB/Y7ey5xNEaI+H/n05rdS4HohO+wxxFY5RQJQR+XCPlUCtGKq0sAulgj6oFi1qN
         3W3tJBIie9jBB3xUvgfjY3/ykwtQZcnXN8kd+pSG2047sR4E96znrx9oJLnrUX+Ht8Nm
         T+KC+xNDPC4lHwBFWGQZTUoTGmAZCWQUYyGB5+C0ccEcgedgf+NDrfETmXIFUD9zBjxE
         noSREBDBVHEI5IIxkR8/IVALmcJpk1AbgvnKS8mLw650bP3bEk44RyYRUuqh/Yxm15Nz
         jUeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dxxdg5vykW5t09YvbbZDwBqARbOva9lwcwb08iLB/24=;
        b=iMfV/nrRFNcpodlnhaMpcuK+kWCZ54t/SKcuRlxNblGGNQiWTLyRpl3QBHZg6LdIBB
         spjYGfL/sfxTsdTUMnCOjlPTgzNH7IfgWvUNhmAZ4KL6ujzZg9n+aMxUrtbA/2ABpKL5
         CdnW9OlOaL+ZPm2bCYUizSciyDrybsNoWvlXY8J5BErVGXwnsMOnVHt37pIoP8L+ZYhK
         jySXCYvykohYhJkj2RdKZIvbsc6AFm1b2tr900FmgaeEC2of2QXqs8hhRrThpLmJET/t
         NZA9ENPPoGoiW6PK7IAW8hP8hUxI5ORGkbBnnv6e3mmaHAXEQ9qLHoAjZ4QgOoMa3o54
         TUKQ==
X-Gm-Message-State: AOAM533j/518ETOyT31OcYtxVcy09nM+2cEb8EPFE9icLHsLwTIVtYJ4
        vEWlIUM5CQCT+MZbAgLxFqU=
X-Google-Smtp-Source: ABdhPJyA57t3TXgYGGKSt0xMLLx0kO1yOoiQcMXncLpqzjt1ZvxZolqzWQ96PQ5gIMyJg0GVjqp+IQ==
X-Received: by 2002:a17:906:1989:: with SMTP id g9mr918597ejd.62.1604651272250;
        Fri, 06 Nov 2020 00:27:52 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:8d7e:efd:393d:7a36? (p200300ea8f2328008d7e0efd393d7a36.dip0.t-ipconnect.de. [2003:ea:8f23:2800:8d7e:efd:393d:7a36])
        by smtp.googlemail.com with ESMTPSA id o20sm383127eja.34.2020.11.06.00.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 00:27:51 -0800 (PST)
Subject: Re: [PATCH net-next v2 03/10] tun: switch to net core provided
 statistics counters
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        osmocom-net-gprs@lists.osmocom.org, wireguard@lists.zx2c4.com,
        Steffen Klassert <steffen.klassert@secunet.com>
References: <059fcb95-fba8-673e-0cd6-fb26e8ed4861@gmail.com>
 <30fd49be-f467-95f5-9586-fec9fbde8e48@gmail.com>
 <20201105171446.5f78f1a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <dcb51de1-5e11-7c07-9784-bf3546a1246a@gmail.com>
Message-ID: <aea7d78e-2d77-1f8a-70f0-73d46c96b44e@gmail.com>
Date:   Fri, 6 Nov 2020 09:27:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <dcb51de1-5e11-7c07-9784-bf3546a1246a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.11.2020 08:48, Heiner Kallweit wrote:
> On 06.11.2020 02:14, Jakub Kicinski wrote:
>> On Wed, 4 Nov 2020 15:25:24 +0100 Heiner Kallweit wrote:
>>> @@ -1066,7 +1054,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>>  	return NETDEV_TX_OK;
>>>  
>>>  drop:
>>> -	this_cpu_inc(tun->pcpu_stats->tx_dropped);
>>> +	dev->stats.tx_dropped++;
>>>  	skb_tx_error(skb);
>>>  	kfree_skb(skb);
>>>  	rcu_read_unlock();
>>
>> This is no longer atomic. Multiple CPUs may try to update it at the
>> same time.
>>
>> Do you know what the story on dev->rx_dropped is? The kdoc says drivers
>> are not supposed to use it but:
>>
>> drivers/net/ipvlan/ipvlan_core.c:               atomic_long_inc(&skb->dev->rx_dropped);
>> drivers/net/macvlan.c:  atomic_long_inc(&skb->dev->rx_dropped);
>> drivers/net/vxlan.c:            atomic_long_inc(&vxlan->dev->rx_dropped);
>>
>> Maybe tun can use it, too?
>>
> Thanks, yes that should be possible. Here we speak about tx_dropped,
> but AFAICS the same applies as for rx_dropped. Will change it accordingly
> in a v3.
> 
For rx_dropped and tx_dropped it's easy, however tun also has a per-cpu
counter for rx_frame_errors that is incremented if virtio_net_hdr_to_skb()
fails. Not sure how to deal best with this one.
