Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808843B941D
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhGAPmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbhGAPmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 11:42:09 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199CFC061762;
        Thu,  1 Jul 2021 08:39:39 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id a133so7679358oib.13;
        Thu, 01 Jul 2021 08:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KEplDKp1FOGLfnZGT2m2+KyDyN4fHFRZtave3m+V8GE=;
        b=ZGMiu+fEWdzxTL9k5TUnYzQvOwgDnFXhbJAaUylvJZgHMOrexCscTfx04QmN/s1oL2
         pl4aAciUGurxIi/Wy2+zYKSAmo15K6MpgGTkqT5KvzFu+z8N7o7pcFzsXiapZ/VNOKbY
         veeyRxFEuINqa67cEW+Q6xo+16JOoYAoEY3w7YnU1+d2fs3ANHBfDjkP1yGnx0e+Tlom
         Xmmy5+s5i9QBcpn2rmtTZ4l3g0LWzaoS/5Tr8bbr9hBO1ptQCZosKEMjaPhCer9l8OJI
         /VouAIwy4bJS/VMJunZ8aidbGvc4Ee1TKCopSgky01tnc6DpCK8AeKiVEHa0oh8tfP8q
         N3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KEplDKp1FOGLfnZGT2m2+KyDyN4fHFRZtave3m+V8GE=;
        b=iWEPYH+HmkJMS+niTR38rcQgvABeGpErQE0iFMxNAxgoZZ46w2zFWKz0eG5quW2eqE
         W/D4xwIVcwYTiQnjZPuXDbCiFJQfgQJtZM14V++EWuV4guQFMX0tgCWZJaG8vO8Wovbx
         MiU5gIaMGDy7EMIT2OcQkhXWkkTcpVNv5s7Bbsfp4MJnoXU96cu8ccIkJ9EcHO67fLC6
         0WOjYK0pF36A2NF7UR2gFdaYwxv6PhJPYwzwPcfjeCPxHhUhHKOu1iQ7+Oa1FYV8h2O5
         PgRcFiXPToGhr6+j97JvGKgY0ay3I+cjR7GQX5DwuZmCnGiJ2JciFWbebDphgyhJcuIk
         N9rA==
X-Gm-Message-State: AOAM533NNrM+wYi+LaequeX6SdfrVgOotiwDT4QKSHBe8Ne4LoZbw+U/
        eRqXZq4k4TD2MOsQ/lVII7g=
X-Google-Smtp-Source: ABdhPJzouFR2MKj1BAD/FyNWrocTXMmWe5UT92xiGJBAhsBbCPoyksfTAgYlQOj1xeCDXduK4uj77g==
X-Received: by 2002:a05:6808:1313:: with SMTP id y19mr83454oiv.37.1625153978493;
        Thu, 01 Jul 2021 08:39:38 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id n72sm57531oig.5.2021.07.01.08.39.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 08:39:37 -0700 (PDT)
Subject: Re: [regression] UDP recv data corruption
To:     Matthias Treydte <mt@waldheinz.de>, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, regressions@lists.linux.dev,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org
References: <20210701124732.Horde.HT4urccbfqv0Nr1Aayuy0BM@mail.your-server.de>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <38ddc0e8-ba27-279b-8b76-4062db6719c6@gmail.com>
Date:   Thu, 1 Jul 2021 09:39:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701124732.Horde.HT4urccbfqv0Nr1Aayuy0BM@mail.your-server.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ adding Paolo, author of 18f25dc39990 ]

On 7/1/21 4:47 AM, Matthias Treydte wrote:
> Hello,
> 
> we recently upgraded the Linux kernel from 5.11.21 to 5.12.12 in our
> video stream receiver appliance and noticed compression artifacts on
> video streams that were previously looking fine. We are receiving UDP
> multicast MPEG TS streams through an FFMpeg / libav layer which does the
> socket and lower level protocol handling. For affected kernels it spills
> the log with messages like
> 
>> [mpegts @ 0x7fa130000900] Packet corrupt (stream = 0, dts = 6870802195).
>> [mpegts @ 0x7fa11c000900] Packet corrupt (stream = 0, dts = 6870821068).
> 
> Bisecting identified commit 18f25dc399901426dff61e676ba603ff52c666f7 as
> the one introducing the problem in the mainline kernel. It was
> backported to the 5.12 series in
> 450687386cd16d081b58cd7a342acff370a96078. Some random observations which
> may help to understand what's going on:
> 
>    * the problem exists in Linux 5.13
>    * reverting that commit on top of 5.13 makes the problem go away
>    * Linux 5.10.45 is fine
>    * no relevant output in dmesg
>    * can be reproduced on different hardware (Intel, AMD, different
> NICs, ...)
>    * we do use the bonding driver on the systems (but I did not yet
> verify that this is related)
>    * we do not use vxlan (mentioned in the commit message)
>    * the relevant code in FFMpeg identifying packet corruption is here:
>     
> https://github.com/FFmpeg/FFmpeg/blob/master/libavformat/mpegts.c#L2758
> 
> And the bonding configuration:
> 
> # cat /proc/net/bonding/bond0
> Ethernet Channel Bonding Driver: v5.10.45
> 
> Bonding Mode: fault-tolerance (active-backup)
> Primary Slave: None
> Currently Active Slave: enp2s0
> MII Status: up
> MII Polling Interval (ms): 100
> Up Delay (ms): 0
> Down Delay (ms): 0
> Peer Notification Delay (ms): 0
> 
> Slave Interface: enp2s0
> MII Status: up
> Speed: 1000 Mbps
> Duplex: full
> Link Failure Count: 0
> Permanent HW addr: 80:ee:73:XX:XX:XX
> Slave queue ID: 0
> 
> Slave Interface: enp3s0
> MII Status: down
> Speed: Unknown
> Duplex: Unknown
> Link Failure Count: 0
> Permanent HW addr: 80:ee:73:XX:XX:XX
> Slave queue ID: 0
> 
> 
> If there is anything else I can do to help tracking this down please let
> me know.
> 
> 
> Regards,
> -Matthias Treydte
> 
> 

