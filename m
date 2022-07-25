Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B799D5806DC
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 23:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbiGYVfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 17:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237122AbiGYVfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 17:35:44 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC86564DE
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 14:35:43 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id p8so11553478plq.13
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 14:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XTfSh6kViMNkfqvzzPDH/hXm7/NmRAmAlXCFAaoCvrw=;
        b=GdZmIH++T0emTZHWUU5YHKCttV3bWzUJomEy6gMYfrgE1NykgEFg1oILU8FUJK4M0U
         wawBcIwLxNAO0AJGzpFwpu0LpCaxfDjZ3yQ3uWW6PrNlGglRkWJRHL0eY33crix/JI8h
         UP4YvgpfpLoAGC+WHJgDwx+cDu1aDW/b0PUWD8yO3HHEq5nIx78vGE4AR3RdnBLJyY9j
         2EHYodbuiAWsO4wMtrLSOXn3MPtEGjFom77bxIfK/2i/mduD4HIEzS2vL5rvVkp0sH9o
         0XQo9eSYJOGkmqGCSpxyQiQqad0r0fwmc7N7jf1P1m1Lv0FAZS5SzjYp0nuRYinrkyOB
         DkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XTfSh6kViMNkfqvzzPDH/hXm7/NmRAmAlXCFAaoCvrw=;
        b=uJKw2Fa9vDv9nyw7tzrufxre4P8qAkyHikfs0hleugAnWrMXhQTsUQk2Q1OAUh0HTa
         Z+37Wa7pm4Ry1HPKMZj4BMYqvzcZmRp//9IbwgfxPXzbpiZunb7KUTFTZmjgHRm3HNTe
         rbkb/Az103AvonACzIvaiMV2wEcrwlzt+6FJa117jZBX51BG7YGPX3HAGApJs3SxFROe
         31oTUQMzFMsnvZfpL4blU6/8R2ShIZ27Ljrs7U58GHPnHZh5bhXyE5jqBD/JE49lwmEV
         q7DAkp2lbAPrv69YJjAMH2oQgkXqL7GxE1l4Rmh6pWMB0A+iz5ZwDl3yZpvxEXfpjmm8
         Rucg==
X-Gm-Message-State: AJIora+Os/xT47zfXAfT69gBwR9tjrBgw9VPH8ppS3npzMgHBb1q5qCM
        tjjVxanAw+KvpQm3Tg91lZw=
X-Google-Smtp-Source: AGRyM1vFpTefqopIeaHrG0EWjuBmJVnj/UIpCi22HQCvLI1KpIx7zToVpxy3uXRLegnprHN+hFSDZA==
X-Received: by 2002:a17:902:ea12:b0:16d:32d5:6bdd with SMTP id s18-20020a170902ea1200b0016d32d56bddmr14159974plg.34.1658784943267;
        Mon, 25 Jul 2022 14:35:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id lx7-20020a17090b4b0700b001ef89019352sm286936pjb.3.2022.07.25.14.35.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 14:35:42 -0700 (PDT)
Message-ID: <fd16ebb3-2435-ef01-d9f1-b873c9c0b389@gmail.com>
Date:   Mon, 25 Jul 2022 14:35:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Bonded multicast traffic causing packet loss when using DSA with
 Microchip KSZ9567 switch
Content-Language: en-US
To:     Brian Hutchinson <b.hutchman@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, Vladimir Oltean <olteanv@gmail.com>,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org
References: <CAFZh4h-JVWt80CrQWkFji7tZJahMfOToUJQgKS5s0_=9zzpvYQ@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAFZh4h-JVWt80CrQWkFji7tZJahMfOToUJQgKS5s0_=9zzpvYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/25/22 08:12, Brian Hutchinson wrote:
> I'm experiencing large packet loss when using multicast with bonded
> DSA interfaces.
> 
> I have the first two ports of a ksz9567 setup as individual network
> interfaces in device tree that shows up in the system as lan1 and lan2
> and I have those two interfaces bonded in an "active-backup" bond with
> the intent of having each slave interface go to redundant switches.
> I've tried connecting both interfaces to the same switch and also to
> separate switches that are then connected together.  In the latter
> setup, if I disconnect the two switches I don't see the problem.
> 
> The kernel bonding documentation says "active-backup" will work with
> any layer2 switch and doesn't need smart/managed switches configured
> in any particular way.  I'm currently using dumb switches.
> 
> I can readily reproduce the packet loss issue running iperf to
> generate multicast traffic.
> 
> If I ping my board with the ksz9567 from a PC while iperf is
> generating multicast packets, I get tons of packet loss.  If I run
> heavily loaded iperf tests that are not multicast I don't notice the
> packet loss problem.
> 
> Here is ifconfig view of interfaces:
> 
> bond1: flags=5187<UP,BROADCAST,RUNNING,MASTER,MULTICAST>  mtu 1500  metric 1
>        inet 192.168.1.6  netmask 255.255.255.0  broadcast 0.0.0.0
>        inet6 fd1c:a799:6054:0:60e2:5ff:fe75:6716  prefixlen 64
> scopeid 0x0<global>
>        inet6 fe80::60e2:5ff:fe75:6716  prefixlen 64  scopeid 0x20<link>
>        ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
>        RX packets 1264782  bytes 84198600 (80.2 MiB)
>        RX errors 0  dropped 40  overruns 0  frame 0
>        TX packets 2466062  bytes 3705565532 (3.4 GiB)
>        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> 
> eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1506  metric 1
>        inet6 fe80::f21f:afff:fe6b:b218  prefixlen 64  scopeid 0x20<link>
>        ether f0:1f:af:6b:b2:18  txqueuelen 1000  (Ethernet)
>        RX packets 1264782  bytes 110759022 (105.6 MiB)
>        RX errors 0  dropped 0  overruns 0  frame 0
>        TX packets 2466097  bytes 3710503019 (3.4 GiB)
>        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> 
> lan1: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500  metric 1
>        ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
>        RX packets 543771  bytes 37195218 (35.4 MiB)
>        RX errors 0  dropped 20  overruns 0  frame 0
>        TX packets 1058336  bytes 1593030865 (1.4 GiB)
>        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> 
> lan2: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500  metric 1
>        ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
>        RX packets 721011  bytes 47003382 (44.8 MiB)
>        RX errors 0  dropped 0  overruns 0  frame 0
>        TX packets 1407726  bytes 2112534667 (1.9 GiB)
>        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> 
> lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536  metric 1
>        inet 127.0.0.1  netmask 255.0.0.0
>        inet6 ::1  prefixlen 128  scopeid 0x10<host>
>        loop  txqueuelen 1000  (Local Loopback)
>        RX packets 394  bytes 52052 (50.8 KiB)
>        RX errors 0  dropped 0  overruns 0  frame 0
>        TX packets 394  bytes 52052 (50.8 KiB)
>        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> 
> Is what I'm trying to do even valid with dumb switches or is the
> bonding documentation wrong/outdated regarding active-backup bonds not
> needing smart switches?
> 
> I know there's probably not going to be anyone out there that can
> reproduce my setup to look at this problem but I'm willing to run
> whatever tests and provide all the info/feedback I can.
> 
> I'm running 5.10.69 on iMX8MM with custom Linux OS based on Yocto
> Dunfell release.
> 
> I know that DSA master interface eth0 is not to be accessed directly
> yet I see eth0 is getting an ipv6 address and I'm wondering if that
> could cause a scenario where networking stack could attempt to use
> eth0 directly for traffic.

This is a red herring, we cannot tell the network stack without much special casing that the DSA network device must only transport tagged traffic to/from the switch, so the IPv6 stack still happily generates a link local address for your adapter.

Any chance of getting the outputs of ethtool -S for lan1 and lan2, and eth0 so we could possibly glean something from the hardware maintained statistics?
-- 
Florian
