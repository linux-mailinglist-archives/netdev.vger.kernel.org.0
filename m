Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555E6219643
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 04:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgGIC3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 22:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgGIC3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 22:29:12 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E8DC061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:29:12 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id md7so418455pjb.1
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 19:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NTkdOiysFgTH6sENKaOKEwudQbnSkUJEQUfEOZ3XvaM=;
        b=UzmfH13HnEo3aQWBz6OC6kJ+byBGp7pkFjhlprFUMNDrNaYajq891hENpMDKRX7GJP
         X+pz5+IJAZcdtvilemvEIN/1U7r75edZpHqsrjcKAt8FZR5cJhZcLHCbvxaVilhlhesi
         WKZOLHfflaNFiqix483CjqX7aqsv0K4G/fBQIhqPDrfzR9E7a0YrtPv+rXNe9nk3KMJ2
         wwKwk9LKEwfIfWoJADqQ9Z2eTlOXe9hdtG0vd3MAAPqd5ITkm+cCBEFEvLFU88bHLF9H
         E6Oa82eClXrGFwr+Q4sLTcJ+sp3oaoIgPsjCyYT4S8cxR0GrqNxPtYVz1eTxjmCA+HJ+
         j2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NTkdOiysFgTH6sENKaOKEwudQbnSkUJEQUfEOZ3XvaM=;
        b=cpCLkvawiCFaTZfU3S5np6mg2DAUReOjN/q61cXhvxLU+WeBmvauRuztR20aJtcrbw
         DFa9+H6epj/mcy1td2AVEj2s3LBmJOuHgFT8NccG+D3zJaIJiEs3w/NWBxMWrF9Lj1QI
         bXyZ4deBRekYO9f6jHKC7P0o7Htp2NAZXYBgkYWh5b3LcaSdb6ZNsUVQ94g8xMvo09OU
         PIzGh1BDzEh9B4vQDNDWsvjKDONLdL15GMTH/zf9tEXMFaikrg7yqysvgbXSxKuKnQOV
         H0XcpKekB+0WDf79cSEup7Wq/JrV6D0YOGVabrRAXYaeDbbeSjbfH2RSAkvG4xijz6cA
         iG3Q==
X-Gm-Message-State: AOAM530HuTIgQFMMVL26+Qj4MVfYJXPSTdtPmRZTLqj5/kvd1MIBVKAq
        t2VWS0QwsTZM48mzoEFcGsk=
X-Google-Smtp-Source: ABdhPJwKFW8izJwyBQqtbLkAXWsgoLjEP2zQLDiFqHemptnwGbqsZNAIZ6kZCqrojUlFgGWDo2FbjQ==
X-Received: by 2002:a17:90b:1106:: with SMTP id gi6mr13216761pjb.2.1594261752075;
        Wed, 08 Jul 2020 19:29:12 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id p12sm964331pgk.40.2020.07.08.19.29.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 19:29:11 -0700 (PDT)
Subject: Re: [net-next PATCH 3/3 v1] net: dsa: rtl8366: Use DSA core to set up
 VLAN
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20200708204456.1365855-1-linus.walleij@linaro.org>
 <20200708204456.1365855-4-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <164d3477-df6d-103c-b9ed-55f5d7705e7a@gmail.com>
Date:   Wed, 8 Jul 2020 19:29:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200708204456.1365855-4-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/2020 1:44 PM, Linus Walleij wrote:
> The current code in the RTL8366 VLAN handling code
> initializes the default VLANs like this:
> 
> Ingress packets:
> 
>  port 0   ---> VLAN 1 ---> CPU port (5)
>  port 1   ---> VLAN 2 ---> CPU port (5)
>  port 2   ---> VLAN 3 ---> CPU port (5)
>  port 3   ---> VLAN 4 ---> CPU port (5)
>  port 4   ---> VLAN 5 ---> CPU port (5)
> 
> Egress packets:
>  port 5 (CPU) ---> VLAN 6 ---> port 0, 1, 2, 3, 4
> 
> So 5 VLANs for ingress packets and one VLAN for
> egress packets. Further it sets the PVID
> for each port to further restrict the packets to
> this VLAN only, and sets them as untagged.
> 
> This is a neat set-up in a way and a leftover
> from the OpenWrt driver and the vendor code drop.
> 
> However the DSA core can be instructed to assign
> all ports to a default VLAN, which will be
> VLAN 1. This patch will change the above picture to
> this:
> 
> Ingress packets:
> 
>  port 0   ---> VLAN 1 ---> CPU port (5)
>  port 1   ---> VLAN 1 ---> CPU port (5)
>  port 2   ---> VLAN 1 ---> CPU port (5)
>  port 3   ---> VLAN 1 ---> CPU port (5)
>  port 4   ---> VLAN 1 ---> CPU port (5)
> 
> Egress packets:
>  port 5 (CPU) ---> VLAN 1 ---> port 0, 1, 2, 3, 4
> 
> So all traffic in the switch will by default pass
> on VLAN 1. No PVID is set for ports by the DSA
> core in this case.
> 
> This might have performance impact since the switch
> hardware probably can sort packets into VLANs as
> they pass through the fabric, but it is better
> to fix the above set-up using generic code in that
> case so that it can be reused by other switches.
> 
> The tested scenarios sure work fine with this
> set-up including video streaming from a NAS device.

Does this maintain the requirement that by default, all DSA ports must
be isolated from one another? For instance, if you have broadcast
traffic on port 2, by virtue of having port 1 and port 2 now in VLAN ID
1, do you see that broadcast traffic from port 1?

If you do, then you need to find a way to maintain isolation between ports.

It looks like the FID is used for implementing VLAN filtering so maybe
you need to dedicate a FID per port number here, and add them all to VLAN 1?
-- 
Florian
