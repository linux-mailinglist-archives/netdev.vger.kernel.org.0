Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB516CA1B7
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbjC0KwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjC0KwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:52:06 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B3E40CD
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:52:01 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id y4so34271509edo.2
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1679914320;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wd/POrxQypBhLMF2V1CYad4Fz3s/OVjgtvRSXxYdi6w=;
        b=Ksl9pb3IbeS3DiJI8LyBvaJrGSMJw4vJ34z8SssBxEX+RWd73IWtzSdRFBLnVrLMpz
         e4nxMmL7DPiOitY/5mwce+TK5pq/fJqRzveP+3+u0CpxYMrDcWLmWXU6fpEDknTbRSYI
         +gf5MWzDETcGy2GtnDQVfyS6em/pyvX6nIstijacnVrv4GqF76R2ndKlGH5Pho9ogEhr
         OhrRYMPzB9STuVic+vu/5SGWQum7LXvZt7qvAEsQJuU7G3Dwj8uBkZ0PBxLomR+xCzzR
         6vpcKZHdwEBU9Cil1logR/+m1KvONkAmT+kZmRvXiN6I/LNvsRI8CRxJk9TTuFteRZ3/
         yBLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679914320;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wd/POrxQypBhLMF2V1CYad4Fz3s/OVjgtvRSXxYdi6w=;
        b=FTrS2Phkl13U+F1M7sLoeuzkkSWamdRuGezMMxYG/NtbfRQBY/LUH2WKJxI9bKTWr6
         VJfmE4WZ6kSTYc9qkXG6nO0tXSVSCCyK430tUTPgruJMhOLyiEL96yQW1CLvZuRouwfX
         M/WUmkXZSkBoh3j5IdFcfOePZR6zkNbNxk2Wd5zHWHFEVIdK/UD6433X4IVncAy7FAyI
         1LAYa48xsXIqbzc+Ee/X5paVqhQ++AzQ5M1NRw5ghcqWoasOKK8qlK9sCq6MdEGB13/B
         vkaCyDFyUO4Ii/DmsPiSn83EPfV1M9zD5+LrjctpY6RIp06R4uawJG03g2zpnGlo1Zju
         i3ag==
X-Gm-Message-State: AAQBX9cYm76qkcuThFCWQoTQf5mHDMbvauUYY4Kw6w5/DA4hwXAa3oLS
        YEX8uSPVixWwLR/63Bf1dylF6w==
X-Google-Smtp-Source: AKy350YQ9/vyGdqu8iodTKkawJiPKGinHIvrkQ9JKOoVHWOdhEfku8GbiVqs6KmvV+N2OnzU4NqcqA==
X-Received: by 2002:a17:906:2bc9:b0:939:e870:2b37 with SMTP id n9-20020a1709062bc900b00939e8702b37mr12478545ejg.70.1679914320052;
        Mon, 27 Mar 2023 03:52:00 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id rk28-20020a170907215c00b00933b38505f9sm11382514ejb.152.2023.03.27.03.51.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 03:51:59 -0700 (PDT)
Message-ID: <46d04b78-bde5-b979-c552-57b6e8d1eee4@blackwall.org>
Date:   Mon, 27 Mar 2023 13:51:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: What is the best way to provide FDB related metrics to user
 space?
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Roopa Prabhu <roopa@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
References: <20230324140622.GB28424@pengutronix.de>
 <20230324144351.54kyejvgqvkozuvp@skbuf>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230324144351.54kyejvgqvkozuvp@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/03/2023 16:43, Vladimir Oltean wrote:
> Hi Oleksij,
> 
> On Fri, Mar 24, 2023 at 03:06:22PM +0100, Oleksij Rempel wrote:
>> Hello all,
>>
>> I am currently working on implementing an interface to provide
>> FDB-related metrics to user space, such as the size of the FDB, the
>> count of objects, and so on. The IEEE 802.1Q-2018 standard offers some
>> guidance on this topic. For instance, section "17.2.4 Structure of the
>> IEEE8021-Q-BRIDGE-MIB" defines the ieee8021QBridgeFdbDynamicCount
>> object, and section "12.7.1.1.3 Outputs" provides additional outputs
>> that can be utilized for proper bridge management.
>>
>> I've noticed that some DSA drivers implement devlink raw access to the
>> FDB. I am wondering if it would be acceptable to provide a generic
>> interface for all DSA switches for these kinds of metrics. What would be
>> the best interface to use for this purpose - devlink, sysfs, or
>> something else?
> 
> It's not an easy question. It probably depends on what exactly you need
> it for.
> 
> At a first glance, I'd say that the bridge's netlink interface should
> probably report these, based on information collected and aggregated
> from its bridge ports. But it becomes quite complicated to aggregate
> info from switchdev and non-switchdev (Wi-Fi, plain Ethernet) ports into
> a single meaningful number. Also, the software bridge does not have a
> hard limit per se when it comes to the number of FDB entries (although
> maybe it wouldn't be such a bad idea).
> 

I've had such patch lying around for a very long time. I can polish and upstream
it if there is interest, I think I dropped it because I wanted to do also per-port
limits for dynamic entries which are much harder to get right and higher prio
tasks took over at the time. I could revisit if there is interest.

> ieee8021QBridgeFdbDynamicCount seems defined as "The current number of
> dynamic entries in this Filtering Database." So we're already outside
> the territory of statically defined "maximums" and we're now talking
> about the degree of occupancy of certain tables. That will be a lot
> harder for the software bridge to aggregate coherently, and it can't
> just count its own dynamic FDB entries. Things like dynamic address
> learning of FDB entries learned on foreign interfaces would make that
> utilization figure quite imprecise. Also, some DSA switches have a
> VLAN-unaware FDB, and if the bridge is VLAN-aware, it will have one FDB
> entry per each VLAN, whereas the hardware table will have a single FDB
> entry. Also, DSA in general does not attempt to sync the software FDB
> with the hardware FDB.
> 

Agreed, it's hard to sync the hw/sw fdb.

> So, while we could in theory make the bridge forward this information
> from drivers to user space in a unified form, it seems that the device
> specific information is hard to convert in a lossless form to generic
> information.
> 

If it can be made consistent somehow and the counters are generic enough for
everyone to use and export, and it can work with multiple bridges and so on,
that's not so bad.

> Which is exactly the reason why we have what we have now, I guess.
> 
> What do you mean by "devlink raw access"? In Documentation/networking/dsa/dsa.rst
> we say:
> 
> | - Resources: a monitoring feature which enables users to see the degree of
> |   utilization of certain hardware tables in the device, such as FDB, VLAN, etc.
> 
> If you search for dsa_devlink_resource_register(), you'll see the
> current state of things. What is reported there as device-specific
> resources seems to be the kind of thing you would be interested in.

