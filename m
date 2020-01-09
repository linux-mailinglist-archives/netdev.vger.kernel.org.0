Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B998135507
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 09:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgAII7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 03:59:46 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35083 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728919AbgAII7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 03:59:46 -0500
Received: by mail-wr1-f68.google.com with SMTP id g17so6495551wro.2
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 00:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ROv11xnq5VI2CFhHBvNDVYXBYJxo1AHEOzv0XAZEr4w=;
        b=Cg6lKeq95Dv7C90a3M9e5O7cVMsjFG8NWyS/pKeyGjMJbXra2L5lQiZEg9M6ILTu7F
         knozjWl11xQG2PSpoKduRonW6ltGy9qOhuTXTposQDy6mseRTGxpcM2s85FJLFtl1QlS
         2gZNs5q2ZAWm+er93KJv/nJAZ5jGJQz4Vf6dcPMpaA6DZMzVx/yV9WKcAofL7SGJo1is
         s2Ca+NwyE1jPFxxiFelfCf/f6OPQabnhGXTnJislM2s2JWgvke8+exdCJ7NcHs/D//Tz
         DzTr9LhTPDbfumP8Jf6McasQ8/YaFiZ0PDGioeNbnd3kB8UyXa2b2AlvALCVKr4tz6fO
         i1SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ROv11xnq5VI2CFhHBvNDVYXBYJxo1AHEOzv0XAZEr4w=;
        b=g2ItMPuOlxkaiWXy1grlxuer/C6Z67QhEDTm8+pKop7mZ1lkDpiWKng56xixODMW3R
         wrBT5P9WijGuh9XrAjtUz66BXt+Ut6pA1I1s7vvGe/y6W1hGRC8jN9bAxbEZb5CJg/On
         SGA5IflkMunzTEIDmPaAGmRSnWkk7BZQXztcxuY1k59nug3vOrZApyHyc/PUui38qgLZ
         SR007XNePxKEPCfJ/XpeQWSkmj7rb0Pq9rNawQP+REGRUScSAE5xPvNrZzZ3PqUdfnZO
         eKbHDanlPNbaYvOJRdf1VByEDgw0nutAXmFK5xbQliWOtADv2qQ95l988aBrmbyYFbhn
         fmvw==
X-Gm-Message-State: APjAAAUcCVo/z7rx4Uu6FDxOsJw27Fq0yUjOma6CU682NLOzpBFs59IK
        4435+GPbWYSv3lghSnxoVzFBeUYpIrg=
X-Google-Smtp-Source: APXvYqxssQNgC1yks3T1w6tZqEd8HcDfGgGp9dYJGhg5MIDXEmHdompu1ktp9Dplcz66geXrG69ZkA==
X-Received: by 2002:a5d:6692:: with SMTP id l18mr10259642wru.382.1578560384064;
        Thu, 09 Jan 2020 00:59:44 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:29c3:5035:b006:8600? ([2a01:e0a:410:bb00:29c3:5035:b006:8600])
        by smtp.gmail.com with ESMTPSA id o129sm2159885wmb.1.2020.01.09.00.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 00:59:43 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec 2/2] xfrm interface: fix packet tx through
 bpf_redirect()
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20191231165654.19434-1-nicolas.dichtel@6wind.com>
 <20191231165654.19434-3-nicolas.dichtel@6wind.com>
 <20200109084009.GA8621@gauss3.secunet.de>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <5505d62c-fd01-0b34-ba51-9d8e24959a87@6wind.com>
Date:   Thu, 9 Jan 2020 09:59:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200109084009.GA8621@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 09/01/2020 à 09:40, Steffen Klassert a écrit :
[snip]
>> @@ -352,10 +353,26 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
>>  	case htons(ETH_P_IPV6):
>>  		xfrm_decode_session(skb, &fl, AF_INET6);
>>  		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
>> +		if (!dst) {
>> +			dst = ip6_route_output(dev_net(dev), NULL, &fl.u.ip6);
>> +			if (dst->error) {
>> +				dst_release(dst);
>> +				goto tx_err;
>> +			}
>> +			skb_dst_set(skb, dst);
>> +		}
>>  		break;
>>  	case htons(ETH_P_IP):
>>  		xfrm_decode_session(skb, &fl, AF_INET);
>>  		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
>> +		if (!dst) {
>> +			struct rtable *rt = __ip_route_output_key(dev_net(dev),
>> +								  &fl.u.ip4);
>> +
>> +			if (IS_ERR(rt))
>> +				goto tx_err;
> 
> With this change, the 'if (!dst)' in xfrmi_xmit2() is meaningless
Yep, I was hesitant to remove it :)

> and we don't handle this error as a link failure anymore.
Good point, will send a v2.


Thank you,
Nicolas
