Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D59EB03B3
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 20:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbfIKSe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 14:34:29 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39728 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729781AbfIKSe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 14:34:28 -0400
Received: by mail-pl1-f196.google.com with SMTP id bd8so10534326plb.6;
        Wed, 11 Sep 2019 11:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=shT5MkebT4Dlpu4DCIiZ81Jds3NV7ibwq7Wi0xUM5fY=;
        b=BkEgy5MNg2x6r0dQSw8pFiWdDSSt29gTAUb5JXA3/rOM07IpntAPNWdhAqQ713VCxq
         0/bIPa+KSIBqPxnVCbPuyWFhrxY5TPfHFuQbiFI3nD3uohgu6trm6uufxbw7pOeM74aN
         f0+Jg3C3NwawxQMO+F/JMc620D57TeR14n+qQO+2tcvwnjKc/hpyhKy4jXqS+Nu9qR7c
         WuuGg68ssQYuTvZmWhZkaQuS6ui9rBDU/b86qxn1ASYV43YLa3oapgFxgxCRa9SuDzdt
         4s9qmUJE4l3K3trnDeKeWin7vclH5ZW3VOgl+EHt9K44EGZR2ozVwknZyzYcUpRqM4l2
         hahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=shT5MkebT4Dlpu4DCIiZ81Jds3NV7ibwq7Wi0xUM5fY=;
        b=BlUrpBr4Ca+rPhJNbV6A1lk8eVMxURUKpMii0pyTIRJlB5is6J+QYM8RY09I5PbezF
         oD6vOSWoR93jNGbxdDUdhTQ6Cid63Q7MM8pAbAF4JIGt3LxlhVKThkkNDdexsFbjlsjk
         PwLoKGaCP9oE2o+XvSKIhIAh6HZZmxht9VK7uTsIbtMDOT2k+E4j5mYHkBwgg4nhTyG/
         96uXzrDkYxAHlCKw8LCmN+cYlr0C5O2xCixYE+JkXm4Gf/XhqVc8f2t1pvDhxEI4H3YR
         bmNm+rzHPecffrNCe8WCj6ZQj+gIDzUsXTuZL8Lom+pa2uh75MjmHojbmGFzzjfB3duq
         3vng==
X-Gm-Message-State: APjAAAX7E+2U5h3lQJeSBbqEbB/fwWnVjLYnxRKuYpYpvBCahdZRkIAL
        DNW6H+fniGGxXTmor1lL/7Q=
X-Google-Smtp-Source: APXvYqyDldHIvAPwDq2HvdqTyKDbrcKznOsbf5H1P2CSENAH768Bvmt2HyP3TxgfBN1K8ZxjzTciWA==
X-Received: by 2002:a17:902:8e84:: with SMTP id bg4mr26437049plb.43.1568226867789;
        Wed, 11 Sep 2019 11:34:27 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s73sm3265114pjb.15.2019.09.11.11.34.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 11:34:27 -0700 (PDT)
Subject: Re: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
To:     Vijay Khemka <vijaykhemka@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>
References: <20190910213734.3112330-1-vijaykhemka@fb.com>
 <bd5eab2e-6ba6-9e27-54d4-d9534da9d5f7@gmail.com>
 <0797B1F1-883D-4129-AC16-794957ACCF1B@fb.com>
 <D79D04CC-4A02-4E51-8FDF-48B7C7EB6CC2@fb.com>
 <8A8392C8-5E5E-444D-AB1B-E0FAD3C29425@fb.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <c9876340-c8d0-ba8b-2ae1-9900958f1834@gmail.com>
Date:   Wed, 11 Sep 2019 11:34:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8A8392C8-5E5E-444D-AB1B-E0FAD3C29425@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/11/19 11:30 AM, Vijay Khemka wrote:
> 
> 
> ﻿On 9/10/19, 4:08 PM, "Linux-aspeed on behalf of Vijay Khemka" <linux-aspeed-bounces+vijaykhemka=fb.com@lists.ozlabs.org on behalf of vijaykhemka@fb.com> wrote:
> 
>     
>     
>     On 9/10/19, 3:50 PM, "Linux-aspeed on behalf of Vijay Khemka" <linux-aspeed-bounces+vijaykhemka=fb.com@lists.ozlabs.org on behalf of vijaykhemka@fb.com> wrote:
>     
>         
>         
>         On 9/10/19, 3:05 PM, "Florian Fainelli" <f.fainelli@gmail.com> wrote:
>         
>             On 9/10/19 2:37 PM, Vijay Khemka wrote:
>             > HW checksum generation is not working for AST2500, specially with IPV6
>             > over NCSI. All TCP packets with IPv6 get dropped. By disabling this
>             > it works perfectly fine with IPV6.
>             > 
>             > Verified with IPV6 enabled and can do ssh.
>             
>             How about IPv4, do these packets have problem? If not, can you continue
>             advertising NETIF_F_IP_CSUM but take out NETIF_F_IPV6_CSUM?
>         
>         I changed code from (netdev->hw_features &= ~NETIF_F_HW_CSUM) to 
>         (netdev->hw_features &= ~NETIF_F_ IPV6_CSUM). And it is not working. 
>         Don't know why. IPV4 works without any change but IPv6 needs HW_CSUM
>         Disabled.
>     
>     Now I changed to
>     netdev->hw_features &= (~NETIF_F_HW_CSUM) | NETIF_F_IP_CSUM;
>     And it works.
> 
> I investigated more on these features and found that we cannot set NETIF_F_IP_CSUM 
> While NETIF_F_HW_CSUM is set. So I disabled NETIF_F_HW_CSUM first and enabled
> NETIF_F_IP_CSUM in next statement. And it works fine.
> 
> But as per line 166 in include/linux/skbuff.h,  
> *   NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM are being deprecated in favor of
>  *   NETIF_F_HW_CSUM. New devices should use NETIF_F_HW_CSUM to indicate
>  *   checksum offload capability.
> 
> Please suggest which of below 2 I should do. As both works for me.
> 1. Disable completely NETIF_F_HW_CSUM and do nothing. This is original patch.
> 2. Enable NETIF_F_IP_CSUM in addition to 1. I can have v2 if this is accepted.

Sounds like 2 would leave the option of offloading IPv4 checksum
offload, so that would be a better middle group than flat out disable
checksum offload for both IPv4 and IPv6, no?
-- 
Florian
