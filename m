Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2996B3C8A81
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 20:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhGNSPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 14:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhGNSPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 14:15:19 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB287C06175F
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 11:12:27 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id o72-20020a9d224e0000b02904bb9756274cso3435365ota.6
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 11:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fgp0ieWKBx6AruoJbDl10jdmeBv2qHj657ProAStU+k=;
        b=bCPrMP3UeDBKhT6MGxFA/Ed1m8usv/hpRW0vCytp6iwNPIzKK3D1WHpNUbV+H0Dv3k
         NJgR9G/gsNM/7alPj5uKGTycJ0BvTxjmZbxXdrr9RoGYsE6vaKmgEuUQoUXskpm8sSPd
         +MkidyNYZZQuCk87+cyG+2ehEvuwiFAuiZJq5IHh4GJ+V1oYQzAlQg+AzKXPWen9lZ7B
         5J8cTW8+LmxbT/gJtVzsR+Bu8LIfb+s77YcMDjY4eir9OD+z+dURQLQ0rvdNfTpFyAf7
         NSp88PzJVPQ5cu3OaYT76TqsfFZYUnxeLuHCaI3WHDF/LoFufRhcsn22NuDPOZP5MpQL
         EPLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fgp0ieWKBx6AruoJbDl10jdmeBv2qHj657ProAStU+k=;
        b=dP8PAoxObIC4mmyUCle5y69RpU9tTDaYBVKlv0ikqycndYXQlPHHlWhGVHne1JfV4i
         btf+zMx1yMH55whrJECRDQ7Q5hz0p3FOSDGor0EqfX74yLBH5uxUsWEf435DEmc4VlPE
         sJKDFxucrVRmnsrS+knPYAY8vZkuoXyXEODcSHigv5oggxiKusDHFqlfu/2pmIejsAsZ
         hZced31ztogS+EopkPtDuTl8L+7uBZ8rZo3FsZnK3rG2LfHkw3qVq4Wsjz6a7fMf+Nnq
         bub/ug52cFAwIjy6e7Tlbcsn/rv7B6nH0PD2FtokRkrIFVKBjR6ZbSA7DD/LyAFG8krU
         /owQ==
X-Gm-Message-State: AOAM530Np5mm3kfSCMq9n8gKB1+TLy6W9jKdc0b4F+0hcNrfdHAFDh1l
        3001BmBocZh2EFw8W7iE9KZH/QvNTJmJqw==
X-Google-Smtp-Source: ABdhPJyweIecWuvihjiQ1wJ/xEyTE1dNtSQFgUmqfI3MfGlHcGDRmlTFi5WmNStvoHiepMOEN4ZkJw==
X-Received: by 2002:a9d:20c5:: with SMTP id x63mr1007456ota.372.1626286346778;
        Wed, 14 Jul 2021 11:12:26 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id z3sm590336otp.32.2021.07.14.11.12.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jul 2021 11:12:26 -0700 (PDT)
Subject: Re: Fw: [Bug 213729] New: PMTUD failure with ECMP.
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Ido Schimmel <idosch@idosch.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20210714081318.40500a1b@hermes.local>
 <76039c52-5637-23a1-6ad8-36b16204ae29@novek.ru> <YO8RMnknR0oniZ/R@shredder>
 <c68ca575-9543-51c0-f6a5-abc121edc64b@novek.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <55939c8e-8149-1c12-6464-df60933194ac@gmail.com>
Date:   Wed, 14 Jul 2021 12:12:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <c68ca575-9543-51c0-f6a5-abc121edc64b@novek.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/21 11:51 AM, Vadim Fedorenko wrote:
> On 14.07.2021 17:30, Ido Schimmel wrote:
>> On Wed, Jul 14, 2021 at 05:11:45PM +0100, Vadim Fedorenko wrote:
>>> On 14.07.2021 16:13, Stephen Hemminger wrote:
>>>>
>>>>
>>>> Begin forwarded message:
>>>>
>>>> Date: Wed, 14 Jul 2021 13:43:51 +0000
>>>> From: bugzilla-daemon@bugzilla.kernel.org
>>>> To: stephen@networkplumber.org
>>>> Subject: [Bug 213729] New: PMTUD failure with ECMP.
>>>>
>>>>
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=213729
>>>>
>>>>               Bug ID: 213729
>>>>              Summary: PMTUD failure with ECMP.
>>>>              Product: Networking
>>>>              Version: 2.5
>>>>       Kernel Version: 5.13.0-rc5
>>>>             Hardware: x86-64
>>>>                   OS: Linux
>>>>                 Tree: Mainline
>>>>               Status: NEW
>>>>             Severity: normal
>>>>             Priority: P1
>>>>            Component: IPV4
>>>>             Assignee: stephen@networkplumber.org
>>>>             Reporter: skappen@mvista.com
>>>>           Regression: No
>>>>
>>>> Created attachment 297849
>>>>     -->
>>>> https://bugzilla.kernel.org/attachment.cgi?id=297849&action=edit
>>>> Ecmp pmtud test setup
>>>>
>>>> PMTUD failure with ECMP.
>>>>
>>>> We have observed failures when PMTUD and ECMP work together.
>>>> Ping fails either through gateway1 or gateway2 when using MTU
>>>> greater than
>>>> 1500.
>>>> The Issue has been tested and reproduced on CentOS 8 and mainline
>>>> kernels.
>>>>
>>>>
>>>> Kernel versions:
>>>> [root@localhost ~]# uname -a
>>>> Linux localhost.localdomain 4.18.0-305.3.1.el8.x86_64 #1 SMP Tue Jun
>>>> 1 16:14:33
>>>> UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
>>>>
>>>> [root@localhost skappen]# uname -a
>>>> Linux localhost.localdomain 5.13.0-rc5 #2 SMP Thu Jun 10 05:06:28
>>>> EDT 2021
>>>> x86_64 x86_64 x86_64 GNU/Linux
>>>>
>>>>
>>>> Static routes with ECMP are configured like this:
>>>>
>>>> [root@localhost skappen]#ip route
>>>> default proto static
>>>>           nexthop via 192.168.0.11 dev enp0s3 weight 1
>>>>           nexthop via 192.168.0.12 dev enp0s3 weight 1
>>>> 192.168.0.0/24 dev enp0s3 proto kernel scope link src 192.168.0.4
>>>> metric 100
>>>>
>>>> So the host would pick the first or the second nexthop depending on
>>>> ECMP's
>>>> hashing algorithm.
>>>>
>>>> When pinging the destination with MTU greater than 1500 it works
>>>> through the
>>>> first gateway.
>>>>
>>>> [root@localhost skappen]# ping -s1700 10.0.3.17
>>>> PING 10.0.3.17 (10.0.3.17) 1700(1728) bytes of data.
>>>>   From 192.168.0.11 icmp_seq=1 Frag needed and DF set (mtu = 1500)
>>>> 1708 bytes from 10.0.3.17: icmp_seq=2 ttl=63 time=0.880 ms
>>>> 1708 bytes from 10.0.3.17: icmp_seq=3 ttl=63 time=1.26 ms
>>>> ^C
>>>> --- 10.0.3.17 ping statistics ---
>>>> 3 packets transmitted, 2 received, +1 errors, 33.3333% packet loss,
>>>> time 2003ms
>>>> rtt min/avg/max/mdev = 0.880/1.067/1.255/0.190 ms
>>>>
>>>> The MTU also gets cached for this route as per rfc6754:
>>>>
>>>> [root@localhost skappen]# ip route get 10.0.3.17
>>>> 10.0.3.17 via 192.168.0.11 dev enp0s3 src 192.168.0.4 uid 0
>>>>       cache expires 540sec mtu 1500
>>>>
>>>> [root@localhost skappen]# tracepath -n 10.0.3.17
>>>>    1?: [LOCALHOST]                      pmtu 1500
>>>>    1:  192.168.0.11                                          1.475ms
>>>>    1:  192.168.0.11                                          0.995ms
>>>>    2:  192.168.0.11                                          1.075ms !H
>>>>        Resume: pmtu 1500
>>>>
>>>> However when the second nexthop is picked PMTUD breaks. In this
>>>> example I ping
>>>> a second interface configured on the same destination
>>>> from the same host, using the same routes and gateways. Based on
>>>> ECMP's hashing
>>>> algorithm this host would pick the second nexthop (.2):
>>>>
>>>> [root@localhost skappen]# ping -s1700 10.0.3.18
>>>> PING 10.0.3.18 (10.0.3.18) 1700(1728) bytes of data.
>>>>   From 192.168.0.12 icmp_seq=1 Frag needed and DF set (mtu = 1500)
>>>>   From 192.168.0.12 icmp_seq=2 Frag needed and DF set (mtu = 1500)
>>>>   From 192.168.0.12 icmp_seq=3 Frag needed and DF set (mtu = 1500)
>>>> ^C
>>>> --- 10.0.3.18 ping statistics ---
>>>> 3 packets transmitted, 0 received, +3 errors, 100% packet loss, time
>>>> 2062ms
>>>> [root@localhost skappen]# ip route get 10.0.3.18
>>>> 10.0.3.18 via 192.168.0.12 dev enp0s3 src 192.168.0.4 uid 0
>>>>       cache
>>>>
>>>> [root@localhost skappen]# tracepath -n 10.0.3.18
>>>>    1?: [LOCALHOST]                      pmtu 9000
>>>>    1:  192.168.0.12                                          3.147ms
>>>>    1:  192.168.0.12                                          0.696ms
>>>>    2:  192.168.0.12                                          0.648ms
>>>> pmtu 1500
>>>>    2:  192.168.0.12                                          0.761ms !H
>>>>        Resume: pmtu 1500
>>>>
>>>> The ICMP frag needed reaches the host, but in this case it is ignored.
>>>> The MTU for this route does not get cached either.
>>>>
>>>>
>>>> It looks like mtu value from the next hop is not properly updated
>>>> for some
>>>> reason.
>>>>
>>>>
>>>> Test Case:
>>>> Create 2 networks: Internal, External
>>>> Create 4 virtual machines: Client, GW-1, GW-2, Destination
>>>>
>>>> Client
>>>> configure 1 NIC to internal with MTU 9000
>>>> configure static route with ECMP to GW-1 and GW-2 internal address
>>>>
>>>> GW-1, GW-2
>>>> configure 2 NICs
>>>> - to internal with MTU 9000
>>>> - to external MTU 1500
>>>> - enable ip_forward
>>>> - enable packet forward
>>>>
>>>> Target
>>>> configure 1 NIC to external MTU with 1500
>>>> configure multiple IP address(say IP1, IP2, IP3, IP4) on the same
>>>> interface, so
>>>> ECMP's hashing algorithm would pick different routes
>>>>
>>>> Test
>>>> ping from client to target with larger than 1500 bytes
>>>> ping the other addresses of the target so ECMP would use the other
>>>> route too
>>>>
>>>> Results observed:
>>>> Through GW-1 PMTUD works, after the first frag needed message the
>>>> MTU is
>>>> lowered on the client side for this target. Through the GW-2 PMTUD
>>>> does not,
>>>> all responses to ping are ICMP frag needed, which are not obeyed by
>>>> the kernel.
>>>> In all failure cases mtu is not cashed on "ip route get".
>>>>
>>> Looks like I'm in context of PMTU and also I'm working on
>>> implementing several
>>> new test cases for pmtu.sh test, so I will take care of this one too
>>
>> Thanks
>>
>> There was a similar report from around a year ago that might give you
>> more info:
>>
>> https://lore.kernel.org/netdev/CANXY5y+iuzMg+4UdkPJW_Efun30KAPL1+h2S7HeSPp4zOrVC7g@mail.gmail.com/
>>
>>
> 
> Thanks Ido, will definitely look at it!

I believe that one is fixed by 2fbc6e89b2f1403189e624cabaf73e189c5e50c6

The root cause of this problem is icmp's taking a path that the original
packet did not. i.e., the ICMP is received on device 1 and the exception
is created on that device but Rx chooses device 2 (a different leg in
the ECMP).
