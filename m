Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8A821963F
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 04:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgGIC2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 22:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgGIC2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 22:28:38 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BB2C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:28:37 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e18so283879pgn.7
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 19:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8/6BvoUW9CiE2Ayp8soqUzeh9pnostUhh42tK7mSPHo=;
        b=YRfXZ03W+IKDAu6WlckmqbDZNdBfKlnupba9MEK3EbiYppKSc74ObPzDq36EevSwN1
         DI+DD4xDhzoHIMcprNvqhoYy/eqQkvOGknm4JbQzj/8eVyVwTdBBPt8Yq+iGIQeE/fDn
         F/2rjEZExOxqzBzo9aPwoQs5x3F7xNiHKBXhe3FALHO/zqOkcut+1kzfncrxoTAdONmi
         3GpG5ici1p0BZa3/RwpWqKbVrSMlbOFr6fIb8SnLUA9d6BVdRuEA4botTA0SJawg/Jv+
         LDahzwXoUmwEmdaaSM9D9TIby/udMJ0GwD3v+spe2CLzo7w4c7g4YUba6kAEVpOgjix7
         BVag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8/6BvoUW9CiE2Ayp8soqUzeh9pnostUhh42tK7mSPHo=;
        b=EcmA1cfDaUAjDffeK/TMTHtg6+vUJcceW4/pOHcV6BLxwg2JwHb9G6r/kXbk+ukENx
         pG31kTz2+t73Qy0z/1utSmF+JcTDa2/0SHEjAVZJ71kpMQzy1WcPRK7pOQC86hoNyPw/
         ZdySZt74oLMWg50H0vzBsBvFBpmJvXKhmmxCR36Z0YCNKfXi4ZJOoX5UbAkQ7+d47cvL
         Wja2SnpuVbn4r231qYAE4URPots612OJ00m/PIvYFamHyfhOLW9ZfmO4dtPNqLVdhQC4
         xsldxVM/fiFi61t0e5UTXxQheA64tgXJ3Dwa9RFX0YBZ8w8j77VyEuSnoymEf2DF2fHR
         f9sQ==
X-Gm-Message-State: AOAM532u3hXvhd4TgZTmmDVHKoR2bnlsLvbn4UuQ/g0GGU87F9aL39c/
        ZPvKW0Ew24AuoRJdTP3FMOM=
X-Google-Smtp-Source: ABdhPJwgOErlmWF1OMSPhnwVtc+CwO00a6cM1DR+VUTSC+4iDeCQ9sEHxGmPDWXu9NGXCgXjFCW8PQ==
X-Received: by 2002:a05:6a00:2294:: with SMTP id f20mr57033774pfe.126.1594261717437;
        Wed, 08 Jul 2020 19:28:37 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id k71sm730930pje.33.2020.07.08.19.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 19:28:36 -0700 (PDT)
Subject: Re: [RFC net-next 1/2] udp: add NETIF_F_GSO_UDP_L4 to
 NETIF_F_SOFTWARE_GSO
To:     tanhuazhong <tanhuazhong@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        willemb@google.com
Cc:     netdev@vger.kernel.org, linuxarm@huawei.com, kuba@kernel.org
References: <1594180136-15912-1-git-send-email-tanhuazhong@huawei.com>
 <1594180136-15912-2-git-send-email-tanhuazhong@huawei.com>
 <96a4cb06-c4d2-2aec-2d63-dfcd6691e05a@gmail.com>
 <8af4dce7-f2a0-286a-bb5b-36c66d05c0f3@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a71eaf51-eb05-f812-e1f9-f92ce55f5379@gmail.com>
Date:   Wed, 8 Jul 2020 19:28:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <8af4dce7-f2a0-286a-bb5b-36c66d05c0f3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 7:16 PM, tanhuazhong wrote:
> 
> 
> On 2020/7/8 13:26, Eric Dumazet wrote:
>>
>>
>> On 7/7/20 8:48 PM, Huazhong Tan wrote:
>>> Add NETIF_F_SOFTWARE_GSO to the the list of GSO features with
>>
>>
>> s/NETIF_F_SOFTWARE_GSO/NETIF_F_GSO_UDP_L4/
>>
> 
> yes, thanks.
> 
>>> a software fallback.  This allows UDP GSO to be used even if
>>> the hardware does not support it, and for virtual device such
>>> as VxLAN device, this UDP segmentation will be postponed to
>>> physical device.
>>
>> Is GSO stack or hardware USO able to perform this segmentation,
>> with vxlan (or other) added encapsulation ?
>>
> 
> I have tested this patch with vxlan and vlan in i40e, the driver
> of vxlan and vlan uses  NETIF_F_SOFTWARE_GSO.
> case 1:
> tx-udp-segmentation of virtual device and i40e is on, then the
> UDP GSO is handled by hardware.
> case 2:
> tx-udp-segmentation of virual device is on, i40e is off, then
> the UDP GSO is handled between xmit of virtual device and physical device.
> case 3:
> tx-udp-segmentation of virtual device and i40e is off, then
> the UDP GSO is handled before calling virtual device's xmit.
> 
> the packet captured on receiver is same for the above cases.
> so the behavior of UDP is similar to TCP (which has already been supported)?
> 
>> What about code in net/core/tso.c (in net-next tree) ?
>>
> 
> by reading the code, i can not find anything related to the
> tunnel header. Is there any way to verify it?
>

TSO is supposed to be native ipv4 + TCP
TSO6 is supposed to be native ipv6 + TCP


Variants with added encapsulation need other GSO bits
(SKB_GSO_GRE, SKB_GSO_IPXIP4, SKB_GSO_IPXIP6 ...)

net/core/tso.c does not yet support the variants. Only native TCP/UDP

I do not see vxlan adding a bit in gso_type, so I am kind-of-confused.



