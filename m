Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB9E136F8
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 04:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfEDCEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 22:04:39 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35163 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfEDCEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 22:04:39 -0400
Received: by mail-pf1-f196.google.com with SMTP id t87so3212596pfa.2;
        Fri, 03 May 2019 19:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Uw22xLadvKWXNQUAXPMDh5jiWbcGTNqS6pYJ+BnzO64=;
        b=KCFWWhafeKnthP7IvqOYKzPOQVKIs82+fCfGk8HUktXPheJV9PQtrGE6Ekl6kU2mTe
         2vcP0ivTWijv7vygbZSGnUB5kVoWP4p44BrOtZtTqBrTq/3Orpkc/8mgeNxcYO0Eh7tv
         vFLAwMTq2NPstn5IBqXMavyPfLWbCCa79ghly58PmA1obK4fA36Vla4f77lEEEZNg/5g
         6+Yu05b4bQT4GtA7rLY7EPYYcE2SI7Z7nbc/ZYdqI97uZnYEKNczeYDiiVoQVQZH3JvR
         7vqZUJjDvjLv7yyEoZOUS+YN9LCQ+5JfAUBHzJ0A/N/l40jdVIFZdWzpQQyrg5niVqRm
         zPow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uw22xLadvKWXNQUAXPMDh5jiWbcGTNqS6pYJ+BnzO64=;
        b=mYu+PUx3xplpj76S9iVVD0oKu/a8fpwUcKzXJpF+kOnQ9atNIG2Px6WnCt4svtI27R
         j38y0fPUV95zNag+zSeRDMOAv70sQ8ijkBKOQJ2QAsj9XXezNqxe+IZ8YGrw9eHdn1sb
         OtdtCDQnVJphFGM+iSDB4i9WnamjrNDuUxpmFY07Kq53HdUhGN6zey+Xu31K/v4HoxXo
         VkXKnUhd186un+OA4tWJbVREC6nuaqi/D7DhIbY4ZQTj6lEpSK8lH+ppgvhxOV0pc6HC
         JpA2IGgiCX7V4O0JCN4u6Vc4akBC4NZeKtppbtHDmnUFz+5ssMqi5PHghAAH3x4qIY/6
         zKIA==
X-Gm-Message-State: APjAAAU04+QFIdUFqUTTF7pDdcU06c2MG2ysvgHXmA8rsyOPFaMGZvaB
        7kQAtKfUjSKa8wvpBx7/VeCmfUlX
X-Google-Smtp-Source: APXvYqzPG0C2rKIkQrXLZrsDk/XU6PNT+updqdLk4bsscri5nUKovnxby95crqaRsFI6OEaU4rqc7w==
X-Received: by 2002:a62:ed16:: with SMTP id u22mr15415888pfh.47.1556935477963;
        Fri, 03 May 2019 19:04:37 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id z66sm7750073pfz.83.2019.05.03.19.04.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 19:04:37 -0700 (PDT)
Subject: Re: [PATCH net-next 4/9] net: dsa: Keep private info in the skb->cb
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190504011826.30477-1-olteanv@gmail.com>
 <20190504011826.30477-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <4d3ea715-676c-c550-cff6-18c94a9d93e6@gmail.com>
Date:   Fri, 3 May 2019 19:04:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190504011826.30477-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2019 6:18 PM, Vladimir Oltean wrote:
> Map a DSA structure over the 48-byte control block that will hold
> persistent skb info on transmit and receive.
> 

On receive you cannot quite do that because you don't know if the DSA
master network device calls netif_receive_skb() or napi_gro_receive().
The latter arguably may not be able to aggregate flows at all because it
does not know how to parse the SKB, but the point remains that skb->cb[]
on receive may already be used, up to 48 bytes already. I tried to make
use of it for storing the HW extracted Broadcom tag, but it blew the
budge on 64-bit hosts:

https://www.spinics.net/lists/netdev/msg337777.html

Not asking you to change anything here, just to be aware of it.

> Also add a DSA_SKB_CB_PRIV() macro which retrieves a pointer to the
> space up to 48 bytes that the DSA structure does not use. This space can
> be used for drivers to add their own private info.
> 
> One use is for the PTP timestamping code path. When cloning a skb,
> annotate the original with a pointer to the clone, which the driver can
> then find easily and place the timestamp to. This avoids the need of a
> separate queue to hold clones and a way to match an original to a cloned
> skb.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
