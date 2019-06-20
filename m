Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 486634D259
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 17:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfFTPmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 11:42:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38526 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTPmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 11:42:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so3639765wmj.3
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 08:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7izjioCttOH7ft7yqIZygkkNEDXwmNV4sSZUMRqUXts=;
        b=AFD2AbYUJg+hGGMmrNJDQYFT0P8y1mg7ZG+TDN+2ukEHLf5K1dsxlXvHs+V4+ENbM2
         7uiCRfbjTJ5YA5G8nskiGA2ROQWnPTtHh1/yW9Au55qhn5IECwRZx8R1zw22Bd2NslIE
         gV5eXXetoPUZykfp2PtoSvzQhY9UfDk1hFpNgkzva5QkrkohVkawis9MLFgfIB0RbW2I
         WxhV+IMfOOzyz0NbhiwBg8U7hZpaYRbsqyfqntuukcwr1gUTQ9/FqFR1b+v1khBWuZ9b
         ZCjN7/u8aBEowrxUkhYym74oQLVv8NPmuhlISh/BOA8cSoh0kSdLeJdgoqaT0s4uyvGY
         STPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7izjioCttOH7ft7yqIZygkkNEDXwmNV4sSZUMRqUXts=;
        b=Xbyei19LvlJOYH6zVMX8tNnLbuSyos4cztrlFPsMgIKxnkl8g1aYTS2JYczxsjX0qi
         yE45kv7e6tdDJ/ivwEUO97EARLsqP6oofTwJEJecV/2muwRr/xyGXIoStR6NcvpuvsIg
         XbPG9Ne6Fe3M9zmh5OE7SHsMRfQLcXroGWFJ8ZQc2NXrHlEQrRWY0qR4Oyp6oqWcHgHJ
         7oEX4dWV0F/Xj/9yYmcEEAj059dWQI1xAwQkHV4JMcferPXIB8TpZY0Pt8A1ZEh+NylM
         7B2knYT9BQJq3Otkg0Y8HTOxVuVaREssGER+NkvH27FcxvfhexmN/78RaXlZWikY29RH
         uDcA==
X-Gm-Message-State: APjAAAX6gNxjVTSHx2MsbuOWx9vOJ0POhD1q8cNPKKW5014bnC8/ptsV
        fCCG+V+jNW4iVZgVba6m/KPyPCPrKdI=
X-Google-Smtp-Source: APXvYqxDboUnqZcQGD5Z9N6pn4LBMtwzLIXe7IhiOBTOhDR+63a1AswHUR8Te3gzOng4roO08cBFyA==
X-Received: by 2002:a1c:67c2:: with SMTP id b185mr187847wmc.98.1561045370088;
        Thu, 20 Jun 2019 08:42:50 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:490c:d7fe:b3e5:eb35? ([2a01:e35:8b63:dc30:490c:d7fe:b3e5:eb35])
        by smtp.gmail.com with ESMTPSA id q1sm4328346wmq.25.2019.06.20.08.42.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 08:42:49 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] ipv6: fix neighbour resolution with raw socket
To:     David Ahern <dsahern@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190620123434.7219-1-nicolas.dichtel@6wind.com>
 <fb3ed305-0161-8d6a-975c-54b29cfcb0ef@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <3066f846-f549-f982-7bc0-1f9bc3d87b94@6wind.com>
Date:   Thu, 20 Jun 2019 17:42:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <fb3ed305-0161-8d6a-975c-54b29cfcb0ef@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 20/06/2019 à 17:12, David Ahern a écrit :
> On 6/20/19 6:34 AM, Nicolas Dichtel wrote:
>> The scenario is the following: the user uses a raw socket to send an ipv6
>> packet, destinated to a not-connected network, and specify a connected nh.
>> Here is the corresponding python script to reproduce this scenario:
>>
>>  import socket
>>  IPPROTO_RAW = 255
>>  send_s = socket.socket(socket.AF_INET6, socket.SOCK_RAW, IPPROTO_RAW)
>>  # scapy
>>  # p = IPv6(src='fd00:100::1', dst='fd00:200::fa')/ICMPv6EchoRequest()
>>  # str(p)
>>  req = b'`\x00\x00\x00\x00\x08:@\xfd\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\xfd\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfa\x80\x00\x81\xc0\x00\x00\x00\x00'
>>  send_s.sendto(req, ('fd00:175::2', 0, 0, 0))
>>
>> fd00:175::/64 is a connected route and fd00:200::fa is not a connected
>> host.
>>
>> With this scenario, the kernel starts by sending a NS to resolve
>> fd00:175::2. When it receives the NA, it flushes its queue and try to send
>> the initial packet. But instead of sending it, it sends another NS to
>> resolve fd00:200::fa, which obvioulsy fails, thus the packet is dropped. If
>> the user sends again the packet, it now uses the right nh (fd00:175::2).
>>
> 
> what's the local address and route setup? You reference fd00:100::1 and
> fd00:200::fa with connected route fd00:175::/64.
> 

The test in done on the dut:

    +-----+             +------+             +------+             +-----+
    | tnl |             | dut  |.1         .2|router|             | tnr |
    |     |             |     2+-------------+2     |             |     |
    |     |.1         .2|      |fd00:125::/64|      |.2         .1|     |
    |    1+-------------+1     |             |     1+-------------+1    |
    |     |fd00:100::/64|      |             |      |fd00:200::/64|     |
    |     |             |      |.1         .2|      |             |     |
    |     |             |     3+-------------+3     |             |     |
    |     |             |      |fd00:175::/64|      |             |     |
    +-----+             +------+             +------+             +-----+

On dut:
ip address add fd00:100::2/64 dev ntfp1
ip address add fd00:125::1/64 dev ntfp2
ip address add fd00:175::1/64 dev ntfp3
ip route add fd00:200::/64 via fd00:125::2
ip route add fd00:200::/120 nexthop via fd00:125::2 nexthop via fd00:175::2

Note that fd00:200::fa is not reachable but we expect to see the packet on the
host 'router'.
