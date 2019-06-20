Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C471E4D3E0
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 18:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfFTQgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 12:36:23 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45576 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTQgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 12:36:23 -0400
Received: by mail-io1-f66.google.com with SMTP id e3so1346219ioc.12
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 09:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jKAkGXkGSj9JUqpbhkZQPFUMG4cP2TxEqJUQp3kb1vM=;
        b=eWNUBjje7LHE3dyHDpGr//p7Ng6L1YWRNmrIUyKuU12nUFIdnM8mkw4y6I85KNw+dq
         Qo+j1Jzwm7Hvmzhuss5keaDg9RWbJBJV+c/EZTAnVqbnZTTD5R2Vm+SZyy7pBQGgDUmJ
         tolYVPYBFVjMxdL8naaghyGGZuafxf77sQwO/SLgkFhguL22GOWVSXMjWmQkuuUPipKj
         A9ZPiUCSJ8fv9ijCyAgmxBt2m4X8Z6W8bw1jRWbFNDoTk1J9YUx0zIlQ+KGjskjnArr3
         lN2wWQbn8b5YqkQPJQUVOp4ssWW3rXOGCAe9lR+I0nqkEDMEj2xi+tJBVb3QShNkl9nE
         i5vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jKAkGXkGSj9JUqpbhkZQPFUMG4cP2TxEqJUQp3kb1vM=;
        b=M6C9oGWlNZPI91QbFRDWHeNHGfvH1jqsZ+zJhKr5nyMoVPwRkyAQoCQIV7kKKWAnSS
         q5OOHIGX+94JXkHGwRzXIZOPYGe77DoIoY+Eju353b2gVspn6pn2eA+d2Go7zUmvW/Gy
         DBqaMpvA1NkZxNw/cBN412PO9IG7vUI09wWphUFcE8vQ5oMsYSZwq0RoaMe2Ubi6hm2R
         BWo75gz/xnqPtYxIr282py83c36JFxRRXrpwcKX5TCoW8olhNdi/CWYRpXTIpsBHAmX6
         bXQXsDvJb7bhZglYzQYnbVhNiG8zPkanpd8lpgp3m+7wxATAYNTveLPIUlxKBfZxYY2w
         9S+g==
X-Gm-Message-State: APjAAAVRxJmxRo7g0DcfSyvhE+pJIYGfDFHXWvDftMMGQtb1tHxzA5BH
        e+62xbrcbKWhSWcrV7lFl388VIbm
X-Google-Smtp-Source: APXvYqyuaIRHvpUIts1Efwa8dzZgg04mzT1YubcvPZtXYk9JTRDz3eTWdDglIvrbEl7itOiEX4ehcw==
X-Received: by 2002:a6b:2bcd:: with SMTP id r196mr4255082ior.73.1561048582179;
        Thu, 20 Jun 2019 09:36:22 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:9c46:f142:c937:3c50? ([2601:284:8200:5cfb:9c46:f142:c937:3c50])
        by smtp.googlemail.com with ESMTPSA id z1sm356682ioh.52.2019.06.20.09.36.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 09:36:20 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: fix neighbour resolution with raw socket
To:     nicolas.dichtel@6wind.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190620123434.7219-1-nicolas.dichtel@6wind.com>
 <fb3ed305-0161-8d6a-975c-54b29cfcb0ef@gmail.com>
 <3066f846-f549-f982-7bc0-1f9bc3d87b94@6wind.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c1e3d444-a7c9-def4-9f16-37db5dd071fe@gmail.com>
Date:   Thu, 20 Jun 2019 10:36:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <3066f846-f549-f982-7bc0-1f9bc3d87b94@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/19 9:42 AM, Nicolas Dichtel wrote:
> Le 20/06/2019 à 17:12, David Ahern a écrit :
>> On 6/20/19 6:34 AM, Nicolas Dichtel wrote:
>>> The scenario is the following: the user uses a raw socket to send an ipv6
>>> packet, destinated to a not-connected network, and specify a connected nh.
>>> Here is the corresponding python script to reproduce this scenario:
>>>
>>>  import socket
>>>  IPPROTO_RAW = 255
>>>  send_s = socket.socket(socket.AF_INET6, socket.SOCK_RAW, IPPROTO_RAW)
>>>  # scapy
>>>  # p = IPv6(src='fd00:100::1', dst='fd00:200::fa')/ICMPv6EchoRequest()
>>>  # str(p)
>>>  req = b'`\x00\x00\x00\x00\x08:@\xfd\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\xfd\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfa\x80\x00\x81\xc0\x00\x00\x00\x00'
>>>  send_s.sendto(req, ('fd00:175::2', 0, 0, 0))
>>>
>>> fd00:175::/64 is a connected route and fd00:200::fa is not a connected
>>> host.
>>>
>>> With this scenario, the kernel starts by sending a NS to resolve
>>> fd00:175::2. When it receives the NA, it flushes its queue and try to send
>>> the initial packet. But instead of sending it, it sends another NS to
>>> resolve fd00:200::fa, which obvioulsy fails, thus the packet is dropped. If
>>> the user sends again the packet, it now uses the right nh (fd00:175::2).
>>>
>>
>> what's the local address and route setup? You reference fd00:100::1 and
>> fd00:200::fa with connected route fd00:175::/64.
>>
> 
> The test in done on the dut:
> 
>     +-----+             +------+             +------+             +-----+
>     | tnl |             | dut  |.1         .2|router|             | tnr |
>     |     |             |     2+-------------+2     |             |     |
>     |     |.1         .2|      |fd00:125::/64|      |.2         .1|     |
>     |    1+-------------+1     |             |     1+-------------+1    |
>     |     |fd00:100::/64|      |             |      |fd00:200::/64|     |
>     |     |             |      |.1         .2|      |             |     |
>     |     |             |     3+-------------+3     |             |     |
>     |     |             |      |fd00:175::/64|      |             |     |
>     +-----+             +------+             +------+             +-----+
> 
> On dut:
> ip address add fd00:100::2/64 dev ntfp1
> ip address add fd00:125::1/64 dev ntfp2
> ip address add fd00:175::1/64 dev ntfp3
> ip route add fd00:200::/64 via fd00:125::2
> ip route add fd00:200::/120 nexthop via fd00:125::2 nexthop via fd00:175::2
> 
> Note that fd00:200::fa is not reachable but we expect to see the packet on the
> host 'router'.
> 

gotcha. Thanks for the diagram.

Reviewed-by: David Ahern <dsahern@gmail.com>

You don't have a fixes tag, but this should go to stable releases.

Also, this does not fix the forwarding case. For the forwarding case I
still see it trying to resolve fd00:200::fa from dut.

Namespace version of the above setup:

create_ns() {
        local ns=$1
        ip netns add ${ns}
        ip -netns ${ns} link set lo up
        ip netns exec ${ns} sysctl -qw net.ipv4.ip_forward=1
        ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.keep_addr_on_down=1
        ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.forwarding=1
        ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.forwarding=1
}

create_ns tnl
create_ns dut
create_ns router
create_ns tnr

ip -netns tnl li add eth1 type veth peer name eth1d
ip -netns tnl li set eth1d netns dut name eth1
ip -netns tnl li set eth1 up
ip -netns tnl addr add fd00:100::1/64 dev eth1
ip -netns tnl -6 ro add default via fd00:100::2

ip -netns dut li set eth1 up
ip -netns dut addr add fd00:100::2/64 dev eth1

ip -netns dut li add eth2 type veth peer name eth2r
ip -netns dut li set eth2r netns router name eth2
ip -netns dut li set eth2 up
ip -netns dut addr add dev eth2 fd00:125::1/64
ip -netns router  li set eth2 up
ip -netns router addr add dev eth2 fd00:125::2/64

ip -netns dut li add eth3 type veth peer name eth3r
ip -netns dut li set eth3r netns router name eth3
ip -netns dut li set eth3 up
ip -netns dut addr add dev eth3 fd00:175::1/64
ip -netns router li set eth3 up
ip -netns router addr add dev eth3 fd00:175::2/64

ip -netns router li add eth1 type veth peer name eth1t
ip -netns router li set eth1t netns tnr name eth1
ip -netns router li set eth1 up
ip -netns router addr add dev eth1 fd00:200::2/64
ip -netns tnr li set eth1 up
ip -netns tnr addr add dev eth1 fd00:200::1/64

ip -netns dut route add fd00:200::/64 via fd00:125::2
ip -netns dut route add fd00:200::/120 nexthop via fd00:125::2 nexthop
via fd00:175::2
