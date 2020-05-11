Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8601CE909
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 01:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgEKXWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 19:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725828AbgEKXWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 19:22:49 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404FBC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 16:22:48 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f15so4569102plr.3
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 16:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jsaw6xmQqm9E+lhFO8x0jNPaAA4Su9biBJAVcC1dvuU=;
        b=uU6DV6xyV9Z18XJfxZkyjt279AughOhnaacEroeOi2xhm+E5j8uq9b/fKqy3N+Cim2
         l7xsX7pNrdZI5btAN8EnDoTWk8LiEB19wnhXczcw6nHtD8L0HGmnPawscyNr0BOeVIuN
         TW+C0M2SJOy8D+LbwtdD85tJwCcqy12MiNhdDAyciEeL1nmwdMDz9heiCT02FGjeMZaC
         GmgOCGY2C0DzD0BXnTGq/NanlkAn/OJUFcxOaB8JOgFQY2ibtXG/pej2hT8eJqsnipCQ
         L40jgFUe2RE5I0CFZ8lS1TTxnFPzgYl/K3EN4cIHx7WAFKQPEDVL3CogsctpOVUJfrmm
         cWyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jsaw6xmQqm9E+lhFO8x0jNPaAA4Su9biBJAVcC1dvuU=;
        b=qw/N4EZAY53u0e9c+QvqznL8urUAbWcVDgBXQxGJ8obHLVCMrG96U8u8hj8+BvpTpU
         /JgTINWAVRyJlPw4iNUdCXjPEC+MXNL1XSwuDKPHcXMk5NaGvebFGjOWgCZKs4LaM9x9
         IfeKGXsG3OGTzP7hA6ezs6a4DmVx+A7dkaMTVJz5lqmNkncy2ugzTqTmT02ymEgP0SUj
         0EMq4ha0jIINYEr0csDw5lkKdnnDeOZTz35I1/tvxjX30izpvtYUARGOkckHdfscXwlD
         bKn1K2PJ0qvQpnNYlUVjPpKQB4v0s1DJ8xc+mirIDVMKU7JWp2kc+8icQXDXLVfzj/wh
         ku7Q==
X-Gm-Message-State: AGi0PuaaauJ7yFQl7rrx2IlKI8SQZXKw5scjFT44sN8uXFCCfJcCBcpl
        6U1TD255HNU9FT1rh1/u0zF0ykxy
X-Google-Smtp-Source: APiQypLFmP9tEoujxbssRd283SJ/pPJwQsnCuhR0uzgRlud+AkDdAv+rQveFFRjjNH3nKteiMMrjww==
X-Received: by 2002:a17:902:108:: with SMTP id 8mr17701749plb.200.1589239367302;
        Mon, 11 May 2020 16:22:47 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d12sm10605159pfq.36.2020.05.11.16.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 16:22:46 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4] net: dsa: tag_ocelot: use a short prefix on
 both ingress and egress
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
References: <20200511202046.20515-1-olteanv@gmail.com>
 <20200511202046.20515-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a024c544-a5ec-ccd7-bfff-b240c16fb304@gmail.com>
Date:   Mon, 11 May 2020 16:22:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511202046.20515-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 1:20 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There are 2 goals that we follow:
> 
> - Reduce the header size
> - Make the header size equal between RX and TX
> 
> The issue that required long prefix on RX was the fact that the ocelot
> DSA tag, being put before Ethernet as it is, would overlap with the area
> that a DSA master uses for RX filtering (destination MAC address
> mainly).
> 
> Now that we can ask DSA to put the master in promiscuous mode, in theory
> we could remove the prefix altogether and call it a day, but it looks
> like we can't. Using no prefix on ingress, some packets (such as ICMP)
> would be received, while others (such as PTP) would not be received.
> This is because the DSA master we use (enetc) triggers parse errors
> ("MAC rx frame errors") presumably because it sees Ethernet frames with
> a bad length. And indeed, when using no prefix, the EtherType (bytes
> 12-13 of the frame, bits 96-111) falls over the REW_VAL field from the
> extraction header, aka the PTP timestamp.
> 
> When turning the short (32-bit) prefix on, the EtherType overlaps with
> bits 64-79 of the extraction header, which are a reserved area
> transmitted as zero by the switch. The packets are not dropped by the
> DSA master with a short prefix. Actually, the frames look like this in
> tcpdump (below is a PTP frame, with an extra dsa_8021q tag - dadb 0482 -
> added by a downstream sja1105).
> 
> 89:0c:a9:f2:01:00 > 88:80:00:0a:00:1d, 802.3, length 0: LLC, \
> 	dsap Unknown (0x10) Individual, ssap ProWay NM (0x0e) Response, \
> 	ctrl 0x0004: Information, send seq 2, rcv seq 0, \
> 	Flags [Response], length 78
> 
> 0x0000:  8880 000a 001d 890c a9f2 0100 0000 100f  ................
> 0x0010:  0400 0000 0180 c200 000e 001f 7b63 0248  ............{c.H
> 0x0020:  dadb 0482 88f7 1202 0036 0000 0000 0000  .........6......
> 0x0030:  0000 0000 0000 0000 0000 001f 7bff fe63  ............{..c
> 0x0040:  0248 0001 1f81 0500 0000 0000 0000 0000  .H..............
> 0x0050:  0000 0000 0000 0000 0000 0000            ............
> 
> So the short prefix is our new default: we've shortened our RX frames by
> 12 octets, increased TX by 4, and headers are now equal between RX and
> TX. Note that we still need promiscuous mode for the DSA master to not
> drop it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
