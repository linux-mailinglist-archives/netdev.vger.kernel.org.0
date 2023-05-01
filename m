Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632E16F391D
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 22:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjEAUXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 16:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjEAUXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 16:23:54 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886641FFD
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 13:23:53 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-63b5ce4f069so3482434b3a.1
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 13:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mistywest-com.20221208.gappssmtp.com; s=20221208; t=1682972633; x=1685564633;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S4moYw04P3+WZ9/6ZA+hbZiYpWYhiQemxrj8IS4pIZ8=;
        b=GCiqZTlqgyosv0YQK51g0A4fyEMjYpPPlhUG9NWt4u2lKL8c3XqP2sV5Kjhuh41zZN
         ZKqNRJAywy05LM04NPIwwi/rv6F7jcUnG6Or5oVEL3PbzzZFtsD/EeVHjORKybXDno7d
         EWvd3JPsozO1ptcHQK8KoA7QO9TTKsrVetMi/Ixhsb8wEcPC9LyerD4B6qZ5wuklC9qa
         8P5yP0mX215PfGBhqB1FWHy43vkg8kUzCN+M8nVWRK9Tr7P8NgRlfIA5LNmFRunTODa8
         n8ZawOFri6sAIrck/DHBkDxyFEoXJzBDqkWKVaDwgYCXMy83H0gq/EXWZM7nX0YF7gic
         YeQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682972633; x=1685564633;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S4moYw04P3+WZ9/6ZA+hbZiYpWYhiQemxrj8IS4pIZ8=;
        b=DE3ah6hxmLWHV+WeH2XZQKqt61zGJBN7K98gyKxKS5SNpIOspJmC6NUa/aZmxv/P5g
         R2jrgw9NvK4+hsY5N6kXJ81adoNr5mCUjOx34njAZdSFHyeb546b+3L61UKFt6Y9c3Pb
         pUeiEGXo/HQ5qHq+xiq2ji9l7I2MxfEwGbBijL4n1cOmUsNJyfdGtljewWbOjOhTMT38
         F5Au13ZJZQr6jLkNNxXzzh4Sd4la0Pv5Xhpw1mLqtFtJ3URdQ0Qq/DQGbvaQeicizGRw
         plOmPaou1O+YKjIK7Ko51lE13FEuwZf8cMO7DGgpXVSzjZal8AzC1kdyCWSgj1KvsCEZ
         J4Gw==
X-Gm-Message-State: AC+VfDzlH2JZYOUS0QlhUsf6+9s9gFIn8AC7jULiqNMhvH4D4iOlkNRp
        xItPGaU/UkxUfZLrO0IzU/tHD6+7qwzlJdhJfmj7bQ==
X-Google-Smtp-Source: ACHHUZ5LG+zJrpCDB6CvQpBz4Ffu8I+3dCOIaxRq0rtlpaHLDWWg2CE238jxxjJeP+nrZWkBNgc69w==
X-Received: by 2002:a05:6a20:3d83:b0:f3:6746:ba37 with SMTP id s3-20020a056a203d8300b000f36746ba37mr13750434pzi.13.1682972632920;
        Mon, 01 May 2023 13:23:52 -0700 (PDT)
Received: from [192.168.1.222] (S01061c937c8195ad.vc.shawcable.net. [24.87.33.175])
        by smtp.gmail.com with ESMTPSA id i7-20020a056a00224700b0063b675f01a5sm20981766pfu.11.2023.05.01.13.23.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 13:23:52 -0700 (PDT)
Message-ID: <1c2db687-fdf8-1f6b-9d97-2ec98435fdf8@mistywest.com>
Date:   Mon, 1 May 2023 13:23:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Unable to TX data on VSC8531
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <b0cdace8-5aa2-ce78-7cbf-4edf87dbc3a6@mistywest.com>
 <73139af8-03a7-4788-bbf1-f76b963acb37@lunn.ch>
 <44fe99ec-42a0-688f-16a0-0a3be3750290@mistywest.com>
 <b2e5bbf6-de38-47e5-9b93-6811979cf180@lunn.ch>
From:   Ron Eggler <ron.eggler@mistywest.com>
In-Reply-To: <b2e5bbf6-de38-47e5-9b93-6811979cf180@lunn.ch>
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

On 5/1/23 13:12, Andrew Lunn wrote:
>> After a fresh rebootI executed:
>>
>> # ping 192.168.1.222 -c 1
>>
>> and see the following:
>>
>> # ifconfig
>> eth0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500  metric 1
>>          inet 192.168.1.123  netmask 255.255.255.0  broadcast 192.168.1.255
>>          ether be:a8:27:1f:63:6e  txqueuelen 1000  (Ethernet)
>>          RX packets 469  bytes 103447 (101.0 KiB)
>>          RX errors 0  dropped 203  overruns 0  frame 0
>>          TX packets 0  bytes 0 (0.0 B)
>>          TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
>>          device interrupt 170
>>
>> eth1: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500  metric 1
>>          ether fe:92:66:6c:4e:24  txqueuelen 1000  (Ethernet)
>>          RX packets 0  bytes 0 (0.0 B)
>>          RX errors 0  dropped 0  overruns 0  frame 0
>>          TX packets 0  bytes 0 (0.0 B)
>>          TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
>>          device interrupt 173
>>
>> lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536  metric 1
>>          inet 127.0.0.1  netmask 255.0.0.0
>>          loop  txqueuelen 1000  (Local Loopback)
>>          RX packets 1  bytes 112 (112.0 B)
>>          RX errors 0  dropped 0  overruns 0  frame 0
>>          TX packets 1  bytes 112 (112.0 B)
>>          TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
>>
>> it appears like the ping got sent to the loopback device instead of the
>> eth0, is this possible?
> It is unlikely. Loopback is used for lots of things. Rather than -c 1,
> leave it running. There should be an arp sent around once a
> second. See if the statistics for lo go up at that rate.
Yes, the TX packets on lo actually do increase every second or so when I 
have a ping running,
it's not 1 packet at a time but rather 3 or 4, it's nnot fully 
consistent, when I scroll back the TX packets on the lo interface 
increased like:

23
26
30
33
37
40

>> I got the following:
>>
>> # mii-tool -vv eth0
>> Using SIOCGMIIPHY=0x8947
>> eth0: negotiated 100baseTx-FD, link ok
>>    registers for MII PHY 0:
>>      1040 796d 0007 0572 01e1 45e1 0007 2801
>>      0000 0300 4000 0000 0000 0000 0000 3000
>>      9000 0000 0008 0000 0000 0000 3201 1000
>>      0000 a020 a000 0000 802d 0021 0400 0000
>>    product info: vendor 00:01:c1, model 23 rev 2
>>    basic mode:   autonegotiation enabled
>>    basic status: autonegotiation complete, link ok
>>    capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
>> 10baseT-FD 10baseT-HD
>>    advertising:  100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
>>    link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
>> 10baseT-FD 10baseT-HD flow-control
> So you have the register values to answer Horatiu question.
Yes, I realized now only that mii-tool provides a pretty output like this.
Thanks for that!
-- 
Ron
