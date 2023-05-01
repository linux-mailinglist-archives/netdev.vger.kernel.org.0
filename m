Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E19A6F38D0
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 21:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbjEAT6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 15:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbjEAT6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 15:58:04 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC4435A9
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 12:57:18 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b64a32fd2so3368775b3a.2
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 12:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mistywest-com.20221208.gappssmtp.com; s=20221208; t=1682971027; x=1685563027;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ARPxs2HAaeg8m91JFa3GC+qKmNRuS3xg3ZOpcc87TIs=;
        b=dIOHtt0fRwtUJUAfYiLI2LNJY2myO9Hy2AwqugzjC/Ed7Lqxn16m4wYdiZTvl/AN/u
         OgYQhF+rO5wA/PZgsS1AB681fQBQNjQn9I/w5GloutPNHA0z5X2re3ur2K/nh9P4Kp/t
         oP7Dgq95iBdvuuDbtmyb2GGJE/eg0dDcnEjW0zNlN3v1ITt6MXb9R/GSEhhfgtaMNW8q
         3hdBxcvA3Rnpd0prjgbexelUw0QErTy7nDvnPwiYlmTT3fz3e8tUn56AZtWMXN8nXCkj
         LgeiloYkACWfPX6c2txyy5k/qGqxtqvnoztpyl/NfcpPPkQygDwMv/CIwN5v0xL5DKrR
         TZmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682971027; x=1685563027;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ARPxs2HAaeg8m91JFa3GC+qKmNRuS3xg3ZOpcc87TIs=;
        b=VSAyew/BI3YqsqN/yEqX0s3rAuQq3y+/gXZ1zK+kx8Oxr5om8Mm6Dic4bQKHKRGlJZ
         F/DdEa45MpJCVdcWIp+4EEG8LnOaPaIVtQq8q8eM4knKyFcHu5y5jgLcNOScjLgDK6XB
         WC2Rlr/gF0rt7U2aISmMofv/3j5HuFpspmNrHu86x+FBDrUH6c4Mzy9U3+UZ8cZ93P0X
         /ePA/vRmHZguwxz5L+pP+WhT3/5UHtGCj6ezcLhb55FlcX3qEB45SvKRXX0J6HSiWnn6
         PzWDd0SUessIgd4mkFP4cbJUzKWkZEzBw2D/vAm4G7jc6braOlimfnZ5yZ65Botgs+DT
         q7QA==
X-Gm-Message-State: AC+VfDxllkKThdLH1mlVoqUqRxej2aB7MgJ7gQ9HwBXbKfzl+rjhR3x1
        XciErrVYbEAz/GeP66nfMvPBt0c4nrddP4Wg1PEsfA==
X-Google-Smtp-Source: ACHHUZ5d/39IC03tOXHcPRiw36FtvXcul5M9YQivFNars3pVmkJDedUu41p4KjsOnjiZ+9sYCbpw7g==
X-Received: by 2002:a05:6a00:148e:b0:640:dbe5:e2ee with SMTP id v14-20020a056a00148e00b00640dbe5e2eemr22700779pfu.10.1682971026740;
        Mon, 01 May 2023 12:57:06 -0700 (PDT)
Received: from [192.168.1.222] (S01061c937c8195ad.vc.shawcable.net. [24.87.33.175])
        by smtp.gmail.com with ESMTPSA id w14-20020a056a0014ce00b0063ba9108c5csm21020966pfu.149.2023.05.01.12.57.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 12:57:06 -0700 (PDT)
Message-ID: <44fe99ec-42a0-688f-16a0-0a3be3750290@mistywest.com>
Date:   Mon, 1 May 2023 12:57:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Unable to TX data on VSC8531
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <b0cdace8-5aa2-ce78-7cbf-4edf87dbc3a6@mistywest.com>
 <73139af8-03a7-4788-bbf1-f76b963acb37@lunn.ch>
From:   Ron Eggler <ron.eggler@mistywest.com>
In-Reply-To: <73139af8-03a7-4788-bbf1-f76b963acb37@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 4/30/23 07:23, Andrew Lunn wrote:
> On Sun, Apr 30, 2023 at 07:08:21AM -0700, Ron Eggler wrote:
>> Hi,
>>
>> I've posted here previously about the bring up of two network interfaces on
>> an embedded platform that is using two the Microsemi VSC8531 PHYs. (previous
>> thread: issues to bring up two VSC8531 PHYs, Thanks to Heiner Kallweit &
>> Andrew Lunn).
>> I'm able to seemingly fully access & operate the network interfaces through
>> ifconfig (and the ip commands) and I set the ip address to match my /24
>> network. However, while it looks like I can receive & see traffic on the
>> line with tcpdump
> So receive definitely works?
It would appear so as I can monitor traffic that's on the line with 
tcpdump and my arp table sometimes gets populated when an arp broadcast 
for an incomplete entry in the table can be picked up (due to other 
traffic on the network).
> It is a long shot, but a couple of decades ago, i had a board where
> the PHY came up in loopback mode. All transmits never went out the
> cable, they just came straight back again.
>
> When running tcpdump during transmit, do you see each packet twice?

Good idea, I tried this out but cannot make out anything related to 
pings (or arp requests) in tcpdump when I ping at the same time.

However, one thing:

After a fresh rebootI executed:

# ping 192.168.1.222 -c 1

and see the following:

# ifconfig
eth0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500  metric 1
         inet 192.168.1.123  netmask 255.255.255.0  broadcast 192.168.1.255
         ether be:a8:27:1f:63:6e  txqueuelen 1000  (Ethernet)
         RX packets 469  bytes 103447 (101.0 KiB)
         RX errors 0  dropped 203  overruns 0  frame 0
         TX packets 0  bytes 0 (0.0 B)
         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
         device interrupt 170

eth1: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500  metric 1
         ether fe:92:66:6c:4e:24  txqueuelen 1000  (Ethernet)
         RX packets 0  bytes 0 (0.0 B)
         RX errors 0  dropped 0  overruns 0  frame 0
         TX packets 0  bytes 0 (0.0 B)
         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
         device interrupt 173

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536  metric 1
         inet 127.0.0.1  netmask 255.0.0.0
         loop  txqueuelen 1000  (Local Loopback)
         RX packets 1  bytes 112 (112.0 B)
         RX errors 0  dropped 0  overruns 0  frame 0
         TX packets 1  bytes 112 (112.0 B)
         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

it appears like the ping got sent to the loopback device instead of the 
eth0, is this possible?

The routing table looks like:

# route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use 
Iface
192.168.1.0     *               255.255.255.0   U     0 0        0 eth0

What's going on here?

> Please run mii-tool on the interface. e.g. for my device:
>
> mii-tool -vv enp2s0:
> Using SIOCGMIIPHY=0x8947
> enp2s0:: no link
>    registers for MII PHY 0:
>      1040 79c9 001c c800 0de1 0000 0064 0000
>      0000 0200 0000 0000 0000 0000 0000 2000
>      0000 0000 ffff 0000 0000 0400 0f00 0f00
>      319b 0053 1002 80d9 84ca 0000 0000 0000
>    product info: vendor 00:e0:4c or 00:07:32, model 0 rev 0
>    basic mode:   autonegotiation enabled
>    basic status: no link
>    capabilities: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
>    advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control

I got the following:

# mii-tool -vv eth0
Using SIOCGMIIPHY=0x8947
eth0: negotiated 100baseTx-FD, link ok
   registers for MII PHY 0:
     1040 796d 0007 0572 01e1 45e1 0007 2801
     0000 0300 4000 0000 0000 0000 0000 3000
     9000 0000 0008 0000 0000 0000 3201 1000
     0000 a020 a000 0000 802d 0021 0400 0000
   product info: vendor 00:01:c1, model 23 rev 2
   basic mode:   autonegotiation enabled
   basic status: autonegotiation complete, link ok
   capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 
10baseT-FD 10baseT-HD
   advertising:  100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
   link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 
10baseT-FD 10baseT-HD flow-control

-- 
Ron
