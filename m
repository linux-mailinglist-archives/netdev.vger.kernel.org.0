Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD802A90AF
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 08:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgKFHs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 02:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgKFHs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 02:48:56 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F42C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 23:48:55 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id s13so420113wmh.4
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 23:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WH3QuXQlKWhEUj+bRBQ/dSMtZW/vy09YGu3j1KAb8H0=;
        b=kLQY3sFya+HBpxhe0gsHfL5sBjNFKlxX2HGeCw8FO6pMddNkbyktGUsVuqLJr/btGR
         buJc7MNcBXMxqkOC/wZnhXSAouoSv4w/mG/sU/1d42KMzwihxal65tPBDM5ST+zj9FgG
         N5up7KyBDm1jTgro3/qBmKUNs5trHC/snirkILQAaP5IAzqx0Ssqs9JaAtTf3C+ydACz
         fekCtGUKxoUKGqI7hKbLgvsGMxzujDp5gusWzhV7VD3Tf1bpxYLGBMhy9g1kNltOwYq7
         ASUdmztnRnK1MY+MD8QYi3AxOwo8ToAKB7QQ56oK6DwM+oH9Njg1srf7N0PPraxQgY1M
         7lGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WH3QuXQlKWhEUj+bRBQ/dSMtZW/vy09YGu3j1KAb8H0=;
        b=WFzldxKzjxDwSKlcerVBag51e5wzSEI9Av/zWIEZH2I3UE4RuOkjg6QOMsIm5uV/nA
         V6c4gBAegPVN305dizoY7mceDM9XN1MciEgTko0gpRpiethF/VhnfifvZnU4Q9XES7dK
         72nvhGXPr9kGTwInXNdg3RPTp6UOq6xDOKnW9J9BkMgdEgmql/Li9X65yYwtn2DTr5mb
         /yPW8jPYYmWHKcb7GIeJUlpdZkR7J/YSuMpGDNbBi9MOmpAIDkJC9vlddnaR/rKCXSi8
         Oy7ncdu4YBkJ2sUAJZ7Jvjok55RdJyoA0ytWr9WkvkzsMlElOJ9vz6/zP71QmEqQSVCP
         773g==
X-Gm-Message-State: AOAM530pdRomdtEusywXICGm11k+4Sqv7UIlS9IiOqgdsVGoYMl6H2D7
        FIMpXRlvFSTyGAcU0gHpubc=
X-Google-Smtp-Source: ABdhPJx6q/68xSPg7yNNuimz3lvIELcLSvTiiBQ2W/8hZWSBUHN+fOnaVRJxEYQUrCk0aCiPJOSwBg==
X-Received: by 2002:a1c:7dc8:: with SMTP id y191mr1004454wmc.118.1604648934466;
        Thu, 05 Nov 2020 23:48:54 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:8d7e:efd:393d:7a36? (p200300ea8f2328008d7e0efd393d7a36.dip0.t-ipconnect.de. [2003:ea:8f23:2800:8d7e:efd:393d:7a36])
        by smtp.googlemail.com with ESMTPSA id v12sm752195wro.72.2020.11.05.23.48.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 23:48:53 -0800 (PST)
Subject: Re: [PATCH net-next v2 03/10] tun: switch to net core provided
 statistics counters
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <dcb51de1-5e11-7c07-9784-bf3546a1246a@gmail.com>
Date:   Fri, 6 Nov 2020 08:48:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201105171446.5f78f1a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.11.2020 02:14, Jakub Kicinski wrote:
> On Wed, 4 Nov 2020 15:25:24 +0100 Heiner Kallweit wrote:
>> @@ -1066,7 +1054,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>  	return NETDEV_TX_OK;
>>  
>>  drop:
>> -	this_cpu_inc(tun->pcpu_stats->tx_dropped);
>> +	dev->stats.tx_dropped++;
>>  	skb_tx_error(skb);
>>  	kfree_skb(skb);
>>  	rcu_read_unlock();
> 
> This is no longer atomic. Multiple CPUs may try to update it at the
> same time.
> 
> Do you know what the story on dev->rx_dropped is? The kdoc says drivers
> are not supposed to use it but:
> 
> drivers/net/ipvlan/ipvlan_core.c:               atomic_long_inc(&skb->dev->rx_dropped);
> drivers/net/macvlan.c:  atomic_long_inc(&skb->dev->rx_dropped);
> drivers/net/vxlan.c:            atomic_long_inc(&vxlan->dev->rx_dropped);
> 
> Maybe tun can use it, too?
> 
Thanks, yes that should be possible. Here we speak about tx_dropped,
but AFAICS the same applies as for rx_dropped. Will change it accordingly
in a v3.
