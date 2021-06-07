Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720B539E8C3
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhFGU4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhFGU4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 16:56:13 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4B6C061574
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 13:54:21 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id o127so477789wmo.4
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 13:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mrrJ6d2Qk5toGywnG9LSV+sHjbNYcls9niVMD9wGLHo=;
        b=MOUe4sT4ZIvBCOD1HVaim61IJrlwPAX209Ab9MPvvKCu3nZ7z5F+c2Vc7C43QZxIFa
         GVeLr69BCK0WTLpoMf7SpDSVBGN5Uu2jpG2a2gr4OKHSJgpBl7KzqXQbggT0Iu5voP+L
         br+ChyzW+ZMD//OeUPh9uLsiah166RTYak4/WB9hZMsDXxyD0KEVtkZ7eSdccCEIVk7w
         uOtWi+Ag5IU1X6Zpfrt60QA5g9TuoAiGaStvyuOvWBc7RW8Qk6Ccb5EiQ+R237wRT6Ac
         B/lE7EB8JosCVfuUHlhBmAWIqTBAQVeribAhN2JEB1jOrNV9lyJupB1HHVMW0Mph0o37
         KvJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mrrJ6d2Qk5toGywnG9LSV+sHjbNYcls9niVMD9wGLHo=;
        b=f29U0DtW1zS11WgaRxqayHZcx1Y/Erw+s3LkQqnnNXOUVgfvE9ltD/oPlw2V14TbZM
         rAkVxXW7tNTSh7vgeWN6CG6bUqdDdQuFmmaui4dc4wx4WEzuv5BeUsvVWZYne/dk7r1S
         xOASBIAKD1iJFJoM+DfozzugVLAKoyPxhqBDKTMgjd3Iya7lJJxZ0rdxZDvZkoJLwOwE
         gonZJshs/bwYUA8I9s4qxVCEnRRU7286/eY8dPJaoFGe/gjLhwyoxMMw3EIr7bmgEt5H
         SNaQXJeaGmNsGjlAn7ueFVke5UqO+Eh2MDicSsRulcW9grh7Lfoj+WVNrg67fEqi7mSO
         Q1pQ==
X-Gm-Message-State: AOAM532lmV1BfkBHl5BLnMPCbL6Th5LzopukF7f0u6KZcN+F2FyfUGXJ
        RVy/h8Y9ppOEvah6Nh9S84yIGT4pS7s=
X-Google-Smtp-Source: ABdhPJxHJ8VnOZjQ6QVxTqXp89giedBWoFuYJPL6ZbavSCv6O1F8XpBwfr22CtkieDSqnXqy5deWTA==
X-Received: by 2002:a1c:b306:: with SMTP id c6mr844318wmf.37.1623099257333;
        Mon, 07 Jun 2021 13:54:17 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:c00:6021:9b38:9cf3:356a? (p200300ea8f2f0c0060219b389cf3356a.dip0.t-ipconnect.de. [2003:ea:8f2f:c00:6021:9b38:9cf3:356a])
        by smtp.googlemail.com with ESMTPSA id 92sm18894047wrp.88.2021.06.07.13.54.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 13:54:16 -0700 (PDT)
Subject: Re: Load on RTL8168g/8111g stalls network for multiple seconds
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     =?UTF-8?Q?Johannes_Brandst=c3=a4tter?= <jbrandst@2ds.eu>
Cc:     netdev@vger.kernel.org
References: <5b08afe02cb0baa7ae3e19fd0bc9d1cbe9ea89c9.camel@2ds.eu>
 <a4e4902d-5534-6c66-63f5-d88059604c78@gmail.com>
Message-ID: <8b9007d3-a7d9-4678-13bf-2cb2ffe3a927@gmail.com>
Date:   Mon, 7 Jun 2021 22:54:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <a4e4902d-5534-6c66-63f5-d88059604c78@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.06.2021 22:39, Heiner Kallweit wrote:
> On 07.06.2021 15:11, Johannes Brandstätter wrote:
>> Hi,
>>
>> just the other day I wanted to set up a bridge between an external 2.5G
>> RTL8156 USB Ethernet adapter (using r8152) and the built in dual
>> RTL8168g/8111g Ethernet chip (using r8169).
>> I compiled the kernel as of 5.13.0-rc4 because of the r8125 supporting
>> the RTL8156.
>> This was done using the Debian kernel config of 5.10.0-4 as a base and
>> left the rest as default.
>>
>> So this setup was working the way I wanted it to, but unfortunately
>> when running iperf3 against the machine it would rather quickly stall
>> all communications on the internal RTL8168g.
>> I was still able to communicate fine over the external RTL8156 link
>> with the machine.
>> Even without the generated network load, it would occasionally become
>> stalled.
>>
>> The only information I could really gather were that the rx_missed
>> counter was going up, and this kernel message some time after the stall
>> was happening:
>>
>> [81853.129107] r8169 0000:02:00.0 enp2s0: rtl_rxtx_empty_cond == 0
>> (loop: 42, delay: 100).
>>
>> Which has apparently to do with the wait for an empty fifo within the
>> r8169 driver.
>>
>> Until that the machine (an UP² board) using the RTL8168g ran without
>> any issues for multiple years in different configurations.
>> Only bridging immediately showed the issue when given enough network
>> load.
>>
>> After many hours of trying out different things, nothing of which
>> showed any difference whatsoever, I tried to replace the internal
>> RTL8168g with an additional external USB Ethernet adapter which I had
>> laying around, having a RTL8153 inside.
>>
>> Once the RTL8168g was removed and the RTL8153 added to the bridge, I
>> was unable to reproduce the issue.
>> Of course I'd rather like to make use of the two internal Ethernet
>> ports if I somehow can.
>>
>> So is there anything I could try to do?
>>
> Do you have flow control enabled? From 5.13-rc r8169 supports adjusting
> pause settings via ethtool. You could play with the settings to see
> whether it makes a difference.
> Next thing you could check is whether the issue persists when using
> the r8168 vendor driver.
> 
> However I'm not an expert in bridging and don't know which difference
> it could make whether a NIC is operated standalone or as part of a bridge.
> 
>> I'm eyeing with a regression test next on the kernel's r8168 driver.
>> Though this is without me knowing if there ever was a working version.
>> As this is a rather large task, with only limited time I wanted to seek
>> out some help before I go down that route.
>>
>> Maybe you could point me into the right direction, as to what to try
>> next.
>>
>> Thanks and best regards,
>> Johannes
>>
> Heiner
> 

Also something you could test, I run my interfaces with the following
settings (as replacement for traditional interrupt coalescing).

echo 20000 > /sys/class/net/enp2s0/gro_flush_timeout
echo 1 > /sys/class/net/enp2s0/napi_defer_hard_irqs
