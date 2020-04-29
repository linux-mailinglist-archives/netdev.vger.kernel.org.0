Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539321BE3F1
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 18:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgD2Qdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 12:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726456AbgD2Qdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 12:33:47 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297D1C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:33:47 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id j14so2209228lfg.9
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xW1xFsOuJe/yAnDwgSHYXBKQa2TZwwsDIi6Nosny60M=;
        b=AZ/wtucgU9Q7yaXXNlJ14eFMxn1cJvtsXHGCWCJPiRr8o4pQZSy6l/0jW93ul0K5Ev
         6CJSH+VcncGx4dxcw/jKTT7FngnBK6K6wW/iApclswEtRfB/IrwmjSdzeKTlb6MZAJMy
         +L2+pZqv7xlvlkZugLKwXBExppZHFKy2F+FIE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xW1xFsOuJe/yAnDwgSHYXBKQa2TZwwsDIi6Nosny60M=;
        b=Rt1cmYYwovcq+XFph/x7c4ErX9OtAjXQklaobWL0mVzh7p16YzreU0ic1xE4ojCRo4
         CZlTvXnykgDFOcD2959g12zKXgt45lvQ61oTH+KtVVtlJq7xqLHJvJZY/L+JAkbZ/yqq
         Y/vJzvjkFnpkZ6Lzl4OO4vuRrKTQdABwMnVjGe0jzX9XoXzUmkl5hZOShe3zpk93bhDj
         N+vataIAtxXdq3nYcRrs12yEX/PhtGx5tWyGMmZ+dCcv1Clf/4Vb52jVCR4yg8+RHxra
         lRRiwjUvmySV0mW8PWtZ7HPq/yZg9pV7MoAh+aLqP/syhbdem7INjUL5yLDp2o0Xe8Ht
         nsAw==
X-Gm-Message-State: AGi0PuaRnHF5VVGwX9olMVC5GDE+XzKf9VoAsrSZ0b36pUParJ0xOx16
        GnDXx/7ZmFtQKkMs4ZlvYPW5ew==
X-Google-Smtp-Source: APiQypIpowcNZW+VWWOon20Cq4WztUuhQ9YpmFvESfW8OYKtVCMTToLIdlf+hyj25/Rd3umDN19hEg==
X-Received: by 2002:a19:ca0e:: with SMTP id a14mr23539521lfg.105.1588178025508;
        Wed, 29 Apr 2020 09:33:45 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q16sm2518272ljj.23.2020.04.29.09.33.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 09:33:44 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] bridge: Allow enslaving DSA master network
 devices
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, leoyang.li@nxp.com,
        Roopa Prabhu <roopa@cumulusnetworks.com>
References: <20200429161952.17769-1-olteanv@gmail.com>
 <20200429161952.17769-2-olteanv@gmail.com>
 <6b1681a7-13e1-9aaa-f765-2a327fb27555@cumulusnetworks.com>
Message-ID: <147e0ee1-75f9-4dba-aff5-f7b4a078cbae@cumulusnetworks.com>
Date:   Wed, 29 Apr 2020 19:33:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <6b1681a7-13e1-9aaa-f765-2a327fb27555@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+CC Roopa

On 29/04/2020 19:27, Nikolay Aleksandrov wrote:
> On 29/04/2020 19:19, Vladimir Oltean wrote:
>> From: Florian Fainelli <f.fainelli@gmail.com>
>>
>> Commit 8db0a2ee2c63 ("net: bridge: reject DSA-enabled master netdevices
>> as bridge members") added a special check in br_if.c in order to check
>> for a DSA master network device with a tagging protocol configured. This
>> was done because back then, such devices, once enslaved in a bridge
>> would become inoperative and would not pass DSA tagged traffic anymore
>> due to br_handle_frame returning RX_HANDLER_CONSUMED.
>>
>> But right now we have valid use cases which do require bridging of DSA
>> masters. One such example is when the DSA master ports are DSA switch
>> ports themselves (in a disjoint tree setup). This should be completely
>> equivalent, functionally speaking, from having multiple DSA switches
>> hanging off of the ports of a switchdev driver. So we should allow the
>> enslaving of DSA tagged master network devices.
>>
>> Make br_handle_frame() return RX_HANDLER_PASS in order to call into the
>> DSA specific tagging protocol handlers, and lift the restriction from
>> br_add_if.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> ---
>>  net/bridge/br_if.c    | 4 +---
>>  net/bridge/br_input.c | 4 +++-
>>  2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
>> index ca685c0cdf95..e0fbdb855664 100644
>> --- a/net/bridge/br_if.c
>> +++ b/net/bridge/br_if.c
>> @@ -18,7 +18,6 @@
>>  #include <linux/rtnetlink.h>
>>  #include <linux/if_ether.h>
>>  #include <linux/slab.h>
>> -#include <net/dsa.h>
>>  #include <net/sock.h>
>>  #include <linux/if_vlan.h>
>>  #include <net/switchdev.h>
>> @@ -571,8 +570,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
>>  	 */
>>  	if ((dev->flags & IFF_LOOPBACK) ||
>>  	    dev->type != ARPHRD_ETHER || dev->addr_len != ETH_ALEN ||
>> -	    !is_valid_ether_addr(dev->dev_addr) ||
>> -	    netdev_uses_dsa(dev))
>> +	    !is_valid_ether_addr(dev->dev_addr))
>>  		return -EINVAL;
>>  
>>  	/* No bridging of bridges */
>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>> index d5c34f36f0f4..396bc0c18cb5 100644
>> --- a/net/bridge/br_input.c
>> +++ b/net/bridge/br_input.c
>> @@ -17,6 +17,7 @@
>>  #endif
>>  #include <linux/neighbour.h>
>>  #include <net/arp.h>
>> +#include <net/dsa.h>
>>  #include <linux/export.h>
>>  #include <linux/rculist.h>
>>  #include "br_private.h"
>> @@ -263,7 +264,8 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
>>  	struct sk_buff *skb = *pskb;
>>  	const unsigned char *dest = eth_hdr(skb)->h_dest;
>>  
>> -	if (unlikely(skb->pkt_type == PACKET_LOOPBACK))
>> +	if (unlikely(skb->pkt_type == PACKET_LOOPBACK) ||
>> +	    netdev_uses_dsa(skb->dev))
>>  		return RX_HANDLER_PASS;
>>  
>>  	if (!is_valid_ether_addr(eth_hdr(skb)->h_source))
>>
> 
> Yet another test in fast-path for all packets.
> Since br_handle_frame will not be executed at all for such devices I'd suggest
> to look into a scheme that avoid installing rx_handler and thus prevents br_handle_frame
> to be called in the frist place. In case that is not possible then we can discuss adding
> one more test in fast-path.
> 
> Actually you can just add a dummy rx_handler that simply returns RX_HANDLER_PASS for
> these devices and keep rx_handler_data so all br_port_get_* will continue working.
> 
> Thanks,
>  Nik
> 
> 
> 
> 

