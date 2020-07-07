Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2783217AB4
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 23:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgGGVuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 17:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgGGVuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 17:50:08 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56863C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 14:50:08 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f18so38795429wrs.0
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 14:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=89JB+9Rs0TDCeGYrnwMpV4jd4vT7+HU3QNFRfMsrM7o=;
        b=QKv27YZvqTzMcEeHN4b8YTB+j73gG8l1L+JbeoNXpfhqiUw+dPaypGGWAo6GnVtuNP
         r/f44AxlHzwLPK5g1BPcC/Yksmo32RGFRrlkGxViW5UwWbjw6pPf/Yzgy2Lu7728J+PL
         Ilb3C7LL8QuWvlDe0Mq4MeRlzmptYEvaIKvtFSCUMUk6ocHJqcvj828c/bNiDFSxkQFf
         SMbwbl0Nrt6vXVlqP6uGMPwe7aXFuduSVfix65eQ5hcUBSkc7ooHOQ437oBPGCJqZuP3
         7x7cWvh/KwcRVz7/sMi1aE39/4HkbvgZ2jOZDMv6aBzAuxqgWE2BIjP+BafzzRxn1iNQ
         axbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=89JB+9Rs0TDCeGYrnwMpV4jd4vT7+HU3QNFRfMsrM7o=;
        b=CkkGcjRV/+B6sdGvzPeo/h72X+rOsgl171LmsImPtR8+ySjaHpKjaFtu43oT9IMlPq
         zfFuzDj3Eatx28grLy3vyy9XCoZ9EgHiwzqs+RQE37CHONUNANZO/HJY7WLVDxJV0XHg
         6tw6O6So0jhOE1HfIhhxcIl1ambCh2vz+q2i9hJe5yXEi3J5ErobS/blHqFtdNcpPKgi
         LE7fleSoiSux7ExaRgfev6YRLwxpANjDG/L1WzRO6pTY5zOby6aaUlRH2O14nF3Zg4rk
         fJBnWKgD4MtZo6k7zF0v0uVJWRaRZvkiEGztN1okeHURyUmsA+yge/SFUXDjc8vT6zvp
         Kqtg==
X-Gm-Message-State: AOAM530e1reRn2weW4Spybltq9H3dKAtdWENA40BuUNgC6KTUvfOhzPR
        bWsAGqoNz5tRwD1FXlrA1SA=
X-Google-Smtp-Source: ABdhPJzWuaXN7kvlwonETKegfoKd3dM6F9ON/hwoSeFlHClPdrq//7N/jX/uP0z2ydsDcK78Vqq+Uw==
X-Received: by 2002:adf:ce85:: with SMTP id r5mr61518687wrn.157.1594158606980;
        Tue, 07 Jul 2020 14:50:06 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id m16sm2871901wro.0.2020.07.07.14.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 14:50:06 -0700 (PDT)
Subject: Re: [net-next PATCH 1/2 v5] net: dsa: tag_rtl4_a: Implement Realtek 4
 byte A tag
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
References: <20200707211614.1217258-1-linus.walleij@linaro.org>
 <20200707211614.1217258-2-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1bdc83c0-b8ce-81df-5df8-4114d0ec04b4@gmail.com>
Date:   Tue, 7 Jul 2020 14:50:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200707211614.1217258-2-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/2020 2:16 PM, Linus Walleij wrote:
> This implements the known parts of the Realtek 4 byte
> tag protocol version 0xA, as found in the RTL8366RB
> DSA switch.
> 
> It is designated as protocol version 0xA as a
> different Realtek 4 byte tag format with protocol
> version 0x9 is known to exist in the Realtek RTL8306
> chips.
> 
> The tag and switch chip lacks public documentation, so
> the tag format has been reverse-engineered from
> packet dumps. As only ingress traffic has been available
> for analysis an egress tag has not been possible to
> develop (even using educated guesses about bit fields)
> so this is as far as it gets. It is not known if the
> switch even supports egress tagging.
> 
> Excessive attempts to figure out the egress tag format
> was made. When nothing else worked, I just tried all bit
> combinations with 0xannp where a is protocol and p is
> port. I looped through all values several times trying
> to get a response from ping, without any positive
> result.
> 
> Using just these ingress tags however, the switch
> functionality is vastly improved and the packets find
> their way into the destination port without any
> tricky VLAN configuration. On the D-Link DIR-685 the
> LAN ports now come up and respond to ping without
> any command line configuration so this is a real
> improvement for users.
> 
> Egress packets need to be restricted to the proper
> target ports using VLAN, which the RTL8366RB DSA
> switch driver already sets up.
> 
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

[snip]

> + * -------------------------------------------------
> + * | MAC DA | MAC SA | 0x8899 | 2 bytes tag | Type |
> + * -------------------------------------------------
> + *
> + * The 2 bytes tag form a 16 bit big endian word. The exact
> + * meaning has been guess from packet dumps from ingress

s/guess/guessed/

[snip]

> +	port = protport & 0xff;
> +
> +	/* Remove RTL4 tag and recalculate checksum */
> +	skb_pull_rcsum(skb, RTL4_A_HDR_LEN);
> +
> +	/* Move ethernet DA and SA in front of the data */
> +	memmove(skb->data - ETH_HLEN,
> +		skb->data - ETH_HLEN - RTL4_A_HDR_LEN,
> +		2 * ETH_ALEN);
> +
> +	skb->dev = dsa_master_find_slave(dev, 0, port);

You would want to do this prior to doing the skb_pull_rcsum() and
memmove(), if the port is invalid, no point in pulling the SKB.

With those fixed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
