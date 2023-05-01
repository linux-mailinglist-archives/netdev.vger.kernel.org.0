Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249086F3948
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 22:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbjEAUeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 16:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbjEAUeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 16:34:15 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C532724
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 13:34:14 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1aaec9ad820so17224815ad.0
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 13:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mistywest-com.20221208.gappssmtp.com; s=20221208; t=1682973253; x=1685565253;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c4+SoleEkc2T9DUnq0yqIh6vqL52H15RpQIbERL7xCY=;
        b=nbZE0FSr9DZKm+9JRFoy1CB5HAftIodFHX2X1hCZ4ScWOj3AsBskNlGrATXmHQPbyx
         /7qW1s7AGQaGhixA0gcqYmvxio9Ue/Uv1FowMH3laGfKO2fXCqgMnOAkY2Ogo2LNsHmT
         GKDnAVgwwn9mr+6chluKYqid3/pR0QUpX0ka35L29CfKXArCJGX8DViG5nIPoh/7VdVn
         3/Ar7Sudnm5PGYOBy/8t2IIycsd/bixFxO1JvdoXK7PNrDkCZcLsXbM8B5tb9u0BdvwF
         SwTWe8kqNRHduKmH+oQ1kIHADweZJJzSBDCKIlvp/kAudzSHISPhBX4RpU+z5KyALU1l
         1abA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682973253; x=1685565253;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c4+SoleEkc2T9DUnq0yqIh6vqL52H15RpQIbERL7xCY=;
        b=Ic57BqmZRYmkwwDNDzQjasAvbi5S4JcLiozZVUj4HvtH0jUjN+gf5E9cCgFlrRPoTU
         X3jT2rMRiE0wBdB8zdPTx2M6kJvdp1bplcKPqYjh1HR+C8LGZNQgfB4aIt+T7fvfd4s1
         OYDNv0S8917Pc69RGMGZRaw2O2U+1YJhEEJLPAWkh1xtyhCq2qk6rQFsFUOgBTtZ9WGb
         H6gFRxvbk2BviPt4zw8Mvy2r1FTxPpVNmcw5lvbchFsBzWIt9O8XUowsG3TpPr7XCXdz
         idr68U8RDZnuRMQTxLQI6WJ+S7CjzG3AeIrhKDyFFc0L4xoVb5UTlVPNbr6D9xZYN1x0
         KD3A==
X-Gm-Message-State: AC+VfDxkjIU7WpC11oRSFssf4Ni+mdTiG7BEq1RrcRC7W3j7Rs+nalYK
        SCrJ8/3ucdUySMePC1HZUNCsG/l6rKLJyvJEHxgMCA==
X-Google-Smtp-Source: ACHHUZ7FheC0cL2CQdOZYnJHxZGPzOoTEbCNhZjMqvme2VdtCHW5uzk3JIKulbhXWrmOLZ7JZx3YYA==
X-Received: by 2002:a17:902:d484:b0:1a8:1e8c:95f5 with SMTP id c4-20020a170902d48400b001a81e8c95f5mr17912267plg.69.1682973253539;
        Mon, 01 May 2023 13:34:13 -0700 (PDT)
Received: from [192.168.1.222] (S01061c937c8195ad.vc.shawcable.net. [24.87.33.175])
        by smtp.gmail.com with ESMTPSA id jo5-20020a170903054500b001aaf536b1e3sm2403735plb.123.2023.05.01.13.34.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 13:34:13 -0700 (PDT)
Message-ID: <2c2bade5-01d5-7065-13e6-56fcdbf92b5a@mistywest.com>
Date:   Mon, 1 May 2023 13:34:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Unable to TX data on VSC8531
Content-Language: en-US
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org
References: <b0cdace8-5aa2-ce78-7cbf-4edf87dbc3a6@mistywest.com>
 <20230501064655.2ovbo3yhkym3zu57@soft-dev3-1>
From:   Ron Eggler <ron.eggler@mistywest.com>
In-Reply-To: <20230501064655.2ovbo3yhkym3zu57@soft-dev3-1>
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

Hi Horatiu,

[snip greetings]

> I've posted here previously about the bring up of two network interfaces
> on an embedded platform that is using two the Microsemi VSC8531 PHYs.
> (previous thread: issues to bring up two VSC8531 PHYs, Thanks to Heiner
> Kallweit & Andrew Lunn).
> I'm able to seemingly fully access & operate the network interfaces
> through ifconfig (and the ip commands) and I set the ip address to match
> my /24 network. However, while it looks like I can receive & see traffic
> on the line with tcpdump, it appears like none of my frames can go out
> in TX direction and hence entries in my arp table mostly remain
> incomplete (and if there actually happens to be a complete entry,
> sending anything to it doesn't seem to work and the TX counters in
> ifconfig stay at 0. How can I further troubleshoot this? I have set the
> phy-mode to rgmii-id in the device tree and have experimented with all
> the TX_CLK delay register settings in the PHY but have failed to make
> any progress.
> Some of the VSC phys have this COMA mode, and then you need to pull
> down a GPIO to take it out of this mode. I looked a little bit but I
> didn't find anything like this for VSC8531 but maybe you can double
> check this. But in that case both the RX and TX will not work.
> Are there any errors seen in the registers 16 (0x10) or register 17
> (0x11)?
Good point rewgarding the COMA mode, I have not found anything like it. 
The RGMII connectivity should be pretty straight forward per the 
datasheet, TX0-TX4, TX_CLK, TX_CTL, RXD0-RXD4, RX_CLK & RX_CTL.
Not sure if you've seen this in the subthread that is  ongoing with 
Andrew Lunn but as part of it, I did invoke the mii-tool and got a 
pretty printout of the PHY registers, see below:

# mii-tool -vv eth0
Using SIOCGMIIPHY=0x8947
eth0: negotiated 100baseTx-FD, link ok
   registers for MII PHY 0:
     1040 796d 0007 0572 01e1 45e1 0005 2801
     0000 0300 4000 0000 0000 0000 0000 3000
     9000 0000 0008 0000 0000 0000 3201 1000
     0000 a020 0000 0000 802d 0021 0400 0000
   product info: vendor 00:01:c1, model 23 rev 2
   basic mode:   autonegotiation enabled
   basic status: autonegotiation complete, link ok
   capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 
10baseT-FD 10baseT-HD
   advertising:  100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
   link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 
10baseT-FD 10baseT-HD flow-control

Alternartively, the registers can be read with phytool also:

# phytool read eth0/0/0x10
0x9000
# phytool read eth0/0/0x11
0000

-- 
Ron
