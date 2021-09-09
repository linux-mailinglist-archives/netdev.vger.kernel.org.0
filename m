Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9F9405A7D
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 18:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbhIIQBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 12:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbhIIQBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 12:01:37 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41EEC061574;
        Thu,  9 Sep 2021 09:00:27 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n4so1344093plh.9;
        Thu, 09 Sep 2021 09:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ShIwsrMXfW3/Yrzc0ZIXeANjlzz7dQBqXVqjI+SxjTY=;
        b=dBChgycr53cNPic6HHMTdDbJa0VYmQ3rqhecQ/uh//NlOM8gE2bpZ+v6yRuGJs52pf
         XhZ+YWUYxHmiQvlxXTrP7SUwdisJErR4umzYEZxK8rbcY5tWZIvj8KG5eZg3ernyGmVE
         svKP0r4QtU9c78qUpFI97jggv22uhdtt6rnR7qFcAyg/1gxzA3RtJNXY452M008VydbT
         8Yj+ODEErtcVNjcnu1Pv47H4yfturP/05XwZ9fUtAjxd5qfmsIP2gK1FriNhyeXj+J0d
         5f4mBstyaQnNa/ecX+02SmQmuectPRQmcESvbcj+A/CrYnqEGaj1tDnKB0bVdoUpWpTJ
         1ERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ShIwsrMXfW3/Yrzc0ZIXeANjlzz7dQBqXVqjI+SxjTY=;
        b=MLvp1I8g47AXEgXJfhhOvUNd6I13pJYVVvd7J1ReB3do8yiZS85aRq+EFhno6sJFc/
         jUZuWSj5V8gka5PBVBU9Le3oqWF6MpMG1C8OzvX2KbCq4o8Kmu9B2PEvu9TQCkcTUkbB
         RB6WRXIQDmLtWXVSP24OZnHpgoK6MbDGt9BoYD+64YajnVLM/rcTsZX88CPItAY7Zd0G
         nuSCGw5fXryA3tX25u+t9yGPXRlSPyrcUlxhFJCX2+Fx3iVviyN+yKnZbye5QM6RMQE2
         /OvXZ/5JEtGLWdCKKRPiH7VPmJKpfJ21g0FOPc383YyGy7JtIu9cM2sQE3DOpFYhdAVf
         IyEw==
X-Gm-Message-State: AOAM530c+oPmx+eBeLXnY7pqTUxDuqE6KljnQBFvF8mG2S3xG0yHL+jS
        4oUsL/2gHhXXZT9WbNMxsfM=
X-Google-Smtp-Source: ABdhPJxaKJ6M8DAo5gMOure1MZbTIoVLb9ZcvBBHlTYLDGKsdifW48rKeBJRgsILENXWhfuyoJ1Esg==
X-Received: by 2002:a17:90b:4c4d:: with SMTP id np13mr4469858pjb.166.1631203227323;
        Thu, 09 Sep 2021 09:00:27 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id q21sm2900457pgk.71.2021.09.09.09.00.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 09:00:26 -0700 (PDT)
Message-ID: <92ad3d7d-78db-289b-47d7-55b33b83c24e@gmail.com>
Date:   Thu, 9 Sep 2021 09:00:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Saravana Kannan <saravanak@google.com>
Cc:     p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
 <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <20210909154734.ujfnzu6omcjuch2a@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210909154734.ujfnzu6omcjuch2a@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Saravana,

On 9/9/2021 8:47 AM, Vladimir Oltean wrote:
> On Thu, Sep 09, 2021 at 03:19:52PM +0200, Lino Sanfilippo wrote:
>>> Do you see similar things on your 5.10 kernel?
>>
>> For the master device is see
>>
>> lrwxrwxrwx 1 root root 0 Sep  9 14:10 /sys/class/net/eth0/device/consumer:spi:spi3.0 -> ../../../virtual/devlink/platform:fd580000.ethernet--spi:spi3.0
> 
> So this is the worst of the worst, we have a device link but it doesn't help.
> 
> Where the device link helps is here:
> 
> __device_release_driver
> 	while (device_links_busy(dev))
> 		device_links_unbind_consumers(dev);
> 
> but during dev_shutdown, device_links_unbind_consumers does not get called
> (actually I am not even sure whether it should).
> 
> I've reproduced your issue by making this very simple change:
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> index 60d94e0a07d6..ec00f34cac47 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -1372,6 +1372,7 @@ static struct pci_driver enetc_pf_driver = {
>   	.id_table = enetc_pf_id_table,
>   	.probe = enetc_pf_probe,
>   	.remove = enetc_pf_remove,
> +	.shutdown = enetc_pf_remove,
>   #ifdef CONFIG_PCI_IOV
>   	.sriov_configure = enetc_sriov_configure,
>   #endif
> 
> on my DSA master driver. This is what the genet driver has "special".
> 
> I was led into grave error by Documentation/driver-api/device_link.rst,
> which I've based my patch on, where it clearly says that device links
> are supposed to help with shutdown ordering (how?!).

I was also under the impression that device links were supposed to help 
with shutdown ordering, because it does matter a lot. One thing that I 
had to work before (and seems like it came back recently) is the 
shutdown ordering between gpio_keys.c and the GPIO controller. If you 
suspend the GPIO controller first, gpio_keys.c never gets a chance to 
keep the GPIO pin configured for a wake-up interrupt, therefore no 
wake-up event happens on key presses, whoops.

> 
> So the question is, why did my DSA trees get torn down on shutdown?
> Basically the short answer is that my SPI controller driver does
> implement .shutdown, and calls the same code path as the .remove code,
> which calls spi_unregister_controller which removes all SPI children..
> 
> When I added this device link, one of the main objectives was to not
> modify all DSA drivers. I was certain based on the documentation that
> device links would help, now I'm not so sure anymore.
> 
> So what happens is that the DSA master attempts to unregister its net
> device on .shutdown, but DSA does not implement .shutdown, so it just
> sits there holding a reference (supposedly via dev_hold, but where from?!)
> to the master, which makes netdev_wait_allrefs to wait and wait.

It's not coming from of_find_net_device_by_node() that's for sure and 
with OF we don't go through the code path calling 
dsa_dev_to_net_device() which does call dev_hold() and then shortly 
thereafter the caller calls dev_put() anyway.

> 
> I need more time for the denial phase to pass, and to understand what
> can actually be done. I will also be away from the keyboard for the next
> few days, so it might take a while. Your patches obviously offer a
> solution only for KSZ switches, we need something more general. If I
> understand your solution, it works not by virtue of there being any
> shutdown ordering guarantee at all, but simply due to the fact that
> DSA's .shutdown hook gets called eventually, and the reference to the
> master gets freed eventually, which unblocks the unregister_netdevice
> call from the master. I don't yet understand why DSA holds a long-term
> reference to the master, that's one thing I need to figure out.
> 

Agreed.
-- 
Florian
