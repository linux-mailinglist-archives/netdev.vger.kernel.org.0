Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B043416807
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 00:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239507AbhIWWar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 18:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243475AbhIWWam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 18:30:42 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B16C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 15:29:10 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id l6so4936015plh.9
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 15:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=izFcRZ2+Ha7ZzH8z2txug/mfHIrAhcXbDqg/b0gcwYs=;
        b=EXRWYBloa9BNhq5Cmgih/YIxV6XeXsSBhXNu/0le9ExcG1NVL/sGoUCsxi3evCdLq6
         RC4Bld18K6qcpGwcPkncNOfknoKqCEhhrKpSh0F8AYMsk6zU+3YQIyNH53I4Nv6AjaMp
         lINlCgMRDk3EZJ1TcTHgNxWZs0QA3V6jpQl4jH5Yn1GGewKZ+k+0Ku0z4sBLVwa7pu39
         Cs3XVpZM3xwATHsHDCL0Q4wokc5QideRxr21Tmmh6heVulqW1JcZ7hqKiwfq3POKYMAh
         gevsoubnaqdVFbnsezHC3SybCUAlR1yewTRyFVzC0Kme+nu11ChlwCUR85bXYdzOJJDo
         5ESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=izFcRZ2+Ha7ZzH8z2txug/mfHIrAhcXbDqg/b0gcwYs=;
        b=Aw6WjleAOL4q6FdDCGCPqsHqrRQgOHLwcv966TSc0sPf64fMI+Q+JwO9OSSh5y3aK6
         l0vudOqw9jRrM7A1NBZg7Hg8m5g7jQfuhrELFv3doJ4IyazQXtEKMlctYx/SoIzobjZl
         alqlA9LdPftX7aLYQEkweM6MRhxV2NBUObzeWYIwdKG7KkUevY8w5RGEQF9+UahwBxKq
         o+Cai5UbuBlWQeTDvyX0FAIJpPoAePRUIUtwTH54hYmuI0Lj5H2Kxa4b3FzeK46LPVsh
         OdUusdM1hnHBU3uhcVB7hJKr9g+s1bZN1E61WIzbigywiPt2N+oYxwr6kLh37IH3wP1U
         obVQ==
X-Gm-Message-State: AOAM532OeXQDDf+s/UfYBaFJipx0sIZxXpX6132iA49wMI4+CpNIs4HG
        8W87IEg4EUKDu7EtCI9rGsKPWDfBqaQ=
X-Google-Smtp-Source: ABdhPJy8/WHpyZWIJ97n7KmBXgiHjfiCCQtFW3TVHrY9U1Z6gqzqWaYkvIPwsUsIZrp7GoS333ezDw==
X-Received: by 2002:a17:903:18d:b0:13c:aad1:e74e with SMTP id z13-20020a170903018d00b0013caad1e74emr5995594plg.64.1632436149596;
        Thu, 23 Sep 2021 15:29:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id lj7sm6118060pjb.18.2021.09.23.15.29.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 15:29:09 -0700 (PDT)
Subject: Re: [RFC PATCH 0/4] Faster ndo_fdb_dump for drivers with shared FDB
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210821210018.1314952-1-vladimir.oltean@nxp.com>
 <20210923152510.uuelo5buk3yxqpjv@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <187e4376-e7bb-3e12-f746-8cb3d11f0dc4@gmail.com>
Date:   Thu, 23 Sep 2021 15:29:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210923152510.uuelo5buk3yxqpjv@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 8:25 AM, Vladimir Oltean wrote:
> Roopa, Andrew, Florian,
> 
> On Sun, Aug 22, 2021 at 12:00:14AM +0300, Vladimir Oltean wrote:
>> I have a board where it is painfully slow to run "bridge fdb". It has 16
>> switch ports which are accessed over an I2C controller -> I2C mux 1 ->
>> I2C mux 2 -> I2C-to-SPI bridge.
>>
>> It doesn't really help either that we traverse the hardware FDB of each
>> switch for every netdev, even though we already know all there is to
>> know the first time we traversed it. In fact, I hacked up some rtnetlink
>> and DSA changes, and with those, the time to run 'bridge fdb' on this
>> board decreases from 207 seconds to 26 seconds (2 FDB traversals instead
>> of 16), turning something intolerable into 'tolerable'.
>>
>> I don't know how much we care about .ndo_fdb_dump implemented directly
>> by drivers (and that's where I expect this to be most useful), because
>> of SWITCHDEV_FDB_ADD_TO_BRIDGE and all that. So this is RFC in case it
>> is helpful for somebody, at least during debugging.
>>
>> Vladimir Oltean (4):
>>   net: rtnetlink: create a netlink cb context struct for fdb dump
>>   net: rtnetlink: add a minimal state machine for dumping shared FDBs
>>   net: dsa: implement a shared FDB dump procedure
>>   net: dsa: sja1105: implement shared FDB dump
>>
>>  drivers/net/dsa/sja1105/sja1105_main.c        |  50 +++--
>>  .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   9 +-
>>  drivers/net/ethernet/mscc/ocelot.c            |   5 +-
>>  drivers/net/ethernet/mscc/ocelot_net.c        |   4 +
>>  drivers/net/vxlan.c                           |   8 +-
>>  include/linux/rtnetlink.h                     |  25 +++
>>  include/net/dsa.h                             |  17 ++
>>  net/bridge/br_fdb.c                           |   6 +-
>>  net/core/rtnetlink.c                          | 105 +++++++---
>>  net/dsa/dsa2.c                                |   2 +
>>  net/dsa/dsa_priv.h                            |   1 +
>>  net/dsa/slave.c                               | 189 ++++++++++++++++--
>>  net/dsa/switch.c                              |   8 +
>>  13 files changed, 368 insertions(+), 61 deletions(-)
>>
>> -- 
>> 2.25.1
>>
> 
> Does something like this have any chance of being accepted?
> https://patchwork.kernel.org/project/netdevbpf/cover/20210821210018.1314952-1-vladimir.oltean@nxp.com/

Had not seen the link you just posted, in premise speeding up the FDB
dump sounds good to me, especially given that we typically have these
slow buses to work with.

These questions are probably super stupid and trivial and I really
missed reviewing properly your latest work, how do we manage to keep the
bridge's FDB and hardware FDB in sync given that switches don't
typically tell us when they learn new addresses?
--
Florian
