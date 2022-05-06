Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53D151D27E
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 09:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386467AbiEFHsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 03:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236048AbiEFHsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 03:48:20 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2205DA57
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 00:44:38 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id p18so7747430edr.7
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 00:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=v65mYI2EEz5vZsbVzSt/sJpQodaS8sIPe5rYixNFUDw=;
        b=EYthJBVpw111Ybe5r9X/Fcd5Jsb0+7uEhmhfnVh/wlK1qHQYUiV+AJD6NP9BbxK4Zk
         Y17YVl73uUONjMFsXkpOG3SGJdbHD7SHTg/s/RVSzaru6s9igLS3Sh9REu3eVu5wmx8W
         HGqRHhUgdkJBvPBiM37aSEZ+O6R4IqQX4LDiyQZoeLQdbcfzQcTwPIg5Y45S8LE64lTS
         UNW9aCDB3Zwp5zizxuqe84tESyEhV4GhnN047KL7hSz3+NsrwRGXWtDDAhXefwDB2ixT
         Zz43slzlO86EPAOooAAvb95OpygDCPsc1locUXm861/fGS0/6nMijeu+9Ef+Uhg6+NCT
         cfvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=v65mYI2EEz5vZsbVzSt/sJpQodaS8sIPe5rYixNFUDw=;
        b=vvhhkutnD99vch9rc5Vhanjb0uUT0Mps8baqrtz3DGc0MFtCUnBPDaB14wvsHZoItA
         ljXiG0bjK9gqITKQc/fhpZPy8eIuHzNHhXz2YOoq+qe+IcDPZpdbmq3c1zErfrNKm/gG
         XNuMLdE2N42qxDmOTfpslCh5zl7L15kFHsZL2IpDhgae6rXCWlXWNzwvBdR0tyovza2V
         lYWYNEtia1EHyHGQUZlMYGIPtSDhFPIJDT2q22cBddLheMAg02txUfyfUjkyD1Tmq6vd
         /86vBqSVbePTWgQJH37BDoFn+G6AE9ZF07NtsJ21a2b+fiqUMx7Ya5yQr/okY+jZa2xl
         BxQg==
X-Gm-Message-State: AOAM531TRWLcyrKq4BT7hcw9XulyPBuJ0QLxCgGzkL7jUoV9tVxgLzlw
        ARyuQTVTD/TOWwFTn95M0gM=
X-Google-Smtp-Source: ABdhPJzZAM2CsY9zmKH3fdBqrpqt2wLB8w+NrMVDsG9EfU8fmx2Ee62/DjuvbypUFTZQFp9eO2Dj1g==
X-Received: by 2002:a05:6402:370b:b0:41d:8508:20af with SMTP id ek11-20020a056402370b00b0041d850820afmr2200551edb.16.1651823076857;
        Fri, 06 May 2022 00:44:36 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id w5-20020a056402268500b0042617ba6389sm1945483edd.19.2022.05.06.00.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 00:44:36 -0700 (PDT)
Message-ID: <510bd08b-3d46-2fc8-3974-9d99fd53430e@gmail.com>
Date:   Fri, 6 May 2022 09:44:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: Optimizing kernel compilation / alignments for network
 performance
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Felix Fietkau <nbd@nbd.name>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com>
 <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
 <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
 <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com> <YnP1nOqXI4EO1DLU@lunn.ch>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <YnP1nOqXI4EO1DLU@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5.05.2022 18:04, Andrew Lunn wrote:
>> you'll see that most used functions are:
>> v7_dma_inv_range
>> __irqentry_text_end
>> l2c210_inv_range
>> v7_dma_clean_range
>> bcma_host_soc_read32
>> __netif_receive_skb_core
>> arch_cpu_idle
>> l2c210_clean_range
>> fib_table_lookup
> 
> There is a lot of cache management functions here. Might sound odd,
> but have you tried disabling SMP? These cache functions need to
> operate across all CPUs, and the communication between CPUs can slow
> them down. If there is only one CPU, these cache functions get simpler
> and faster.
> 
> It just depends on your workload. If you have 1 CPU loaded to 100% and
> the other 3 idle, you might see an improvement. If you actually need
> more than one CPU, it will probably be worse.

It seems to lower my NAT speed from ~362 Mb/s to 320 Mb/s but it feels
more stable now (lower variations). Let me spend some time on more
testing.


FWIW during all my tests I was using:
echo 2 > /sys/class/net/eth0/queues/rx-0/rps_cpus
that is what I need to get similar speeds across iperf sessions

With
echo 0 > /sys/class/net/eth0/queues/rx-0/rps_cpus
my NAT speeds were jumping between 4 speeds:
273 Mbps / 315 Mbps / 353 Mbps / 425 Mbps
(every time I started iperf kernel jumped into one state and kept the
  same iperf speed until stopping it and starting another session)

With
echo 1 > /sys/class/net/eth0/queues/rx-0/rps_cpus
my NAT speeds were jumping between 2 speeds:
284 Mbps / 408 Mbps


> I've also found that some Ethernet drivers invalidate or flush too
> much. If you are sending a 64 byte TCP ACK, all you need to flush is
> 64 bytes, not the full 1500 MTU. If you receive a TCP ACK, and then
> recycle the buffer, all you need to invalidate is the size of the ACK,
> so long as you can guarantee nothing has touched the memory above it.
> But you need to be careful when implementing tricks like this, or you
> can get subtle corruption bugs when you get it wrong.

That was actually bgmac's initial behaviour, see commit 92b9ccd34a90
("bgmac: pass received packet to the netif instead of copying it"):
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=92b9ccd34a9053c628d230fe27a7e0c10179910f

I think it was Felix who suggested me to avoid skb_copy*() and it seems
it improved performance indeed.
