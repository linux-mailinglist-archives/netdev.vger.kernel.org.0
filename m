Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAFF1C031D
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgD3Quv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726309AbgD3Quu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 12:50:50 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7684CC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 09:50:50 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id k12so2678482wmj.3
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 09:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5SLM4pCvnjRsvVDoIIqzLUpezzzcdO44b3OMgzOfVwo=;
        b=BUXOiNk9HzIAJIclzB9ruQ+Fcw1NjNLRIXaRkolC3Lol5iMzhMJuV+8gXImc7Voe/M
         naPMId9ubMEXVJrQwk+XEhC7E79DYQivSyWu8CMSIK5/VV6jgy4UctZ+AhgSTcMYf2He
         ok6ki42T1rXtYY7NYKsQkTXUyf9N60Bqqpt9zoNNwsJzaqRcVPac4d4n4Jlga5ES2U/n
         Ii1v6jw0R8rFsYMvJW0ldp7vPHV+CwEuOylcD2i32sBW+oSTd4M3ib9p/JVM0n/btWEq
         YUTUlSp8MD/jk8RaAec4vYliDhwA0J8XZZwNxMXNCiWxje+DEqHWbHHxl1znbQVcgIvM
         ZetQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5SLM4pCvnjRsvVDoIIqzLUpezzzcdO44b3OMgzOfVwo=;
        b=JCTaGFbF82aL5VQ2iJGNZrBAyjm3WDYZeeDXkgVt3yR2xCi4zDeRTEV4PLI+8FNIsq
         7AZXT68ZJqwRf1UK+S6LlqkW1+9MbrYexkXFbSQQUVQqTPZZtJdYxagecI6yvDCzRuwL
         N7tqc3XPLvCWn0N4++2O164QKTMleZDHbCa8jjpLsSOxh/v1n6NnKN3kSr3X1n9r/xbo
         o0uOYN0cDVhAenXHRJd+EoS60AoUZ6Mca9kA5/3K3VC0z8j8fGDMZu09LQGnvqqFEyev
         ob3FcNa5dSrPylim5Z5i8pR05Gt2TWvPj6RavC3HhPui0QuJbzN4xbH0RdF0lnWbgKu+
         elsQ==
X-Gm-Message-State: AGi0PuYxKLjbGyoIw0RH4orUz40ZDUbsZyaxHtfv38XdVVHf6icrCSDu
        aAolCML3IWlNCEQLKnEPhl8bRnen
X-Google-Smtp-Source: APiQypIaoEDzo6w7EeKW3PT7X0Y6URndVWHNpohkmpfv/VsJGmn2EJr72Aaq3UlGUFm7SJVCW57SvA==
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr3794185wmj.3.1588265448892;
        Thu, 30 Apr 2020 09:50:48 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f0e:e300:b5e1:8220:4f28:b3a8? (p200300EA8F0EE300B5E182204F28B3A8.dip0.t-ipconnect.de. [2003:ea:8f0e:e300:b5e1:8220:4f28:b3a8])
        by smtp.googlemail.com with ESMTPSA id 74sm469451wrk.30.2020.04.30.09.50.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 09:50:48 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
To:     Florent Fourcot <florent.fourcot@wifirst.fr>,
        Eric Dumazet <edumazet@google.com>
Cc:     Charles DAYMAND <charles.daymand@wifirst.fr>,
        netdev <netdev@vger.kernel.org>
References: <20200327090800.27810-1-charles.daymand@wifirst.fr>
 <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com>
 <d7a0eca8-15aa-10da-06cc-1eeef3a7a423@gmail.com>
 <CANn89iKA8k3GyxCKCJRacB42qcFqUDsiRhFOZxOQ7JCED0ChyQ@mail.gmail.com>
 <42f81a4a-24fc-f1fb-11db-ea90a692f249@gmail.com>
 <CANn89i+A=Mu=9LMscd2Daqej+uVLc3E6w33MZzTwpe2v+k89Mw@mail.gmail.com>
 <CAFJtzm03QpjGRs70tth26BdUFN_o8zsJOccbnA58ma+2uwiGcg@mail.gmail.com>
 <c02274b9-1ba0-d5e9-848f-5d6761df20f4@gmail.com>
 <CAFJtzm0H=pztSp_RQt_YNnPHQkq4N4Z5S-PqMFgE=Fp=Fo-G_w@mail.gmail.com>
 <297e210f-1784-44a9-17fb-7fbe8b6f9ec3@gmail.com>
 <CANn89iKA8MAef-XfkbLG3W+3=qUx4pqmKuWPBfrxAcupohLkyA@mail.gmail.com>
 <17fd01b4-8d4e-5c91-c51e-688a97c0da54@wifirst.fr>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <6eb1f481-17c6-4093-e0d3-21adc08999fc@gmail.com>
Date:   Thu, 30 Apr 2020 18:50:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <17fd01b4-8d4e-5c91-c51e-688a97c0da54@wifirst.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.04.2020 23:12, Florent Fourcot wrote:
> Hello Eric, Hello Heiner,
> 
> Just for a small follow-up on your questions and current status on our side for this strange topic:
> 
>  * As explained by Charles, the setup includes a mix of macvlan + vlan. So 802.1q frames are not a typo in the topic (in our real case, the second macvlan interface is sent to a network namespace, but it does not matter for the current issue).
> 
>  * We tested the same setup with other networking driver (bnx2, tg3) with tx-checksum enabled (exactly same configuration than the failing one on r8169 for checksum offloading), and it's perfectly working.
> 
>  * Packets are seen as valid by tcpdump on the sender (buggy) host.
> 
>  * Multicast *and* unicast packets are buggy. We detected it first on multicast (since the relevant hardware was sending RIP packets), but all tcp/udp packets are corrupted. ICMP packets are valid.
> 
>  * We expected as well a "simple" checksum failure, but it does not look so simple. Something, on our opinion probably the driver or hardware, is corrupting the packet.
> 
>  * Experimental patches from Heiner are not solving issue.
> 
>  * We have the same behavior on at least RTL8168d/8111d, RTL8169sc/8110sc and RTL8168h/8111h variants.
> 
> 
> As proposed by Heiner, we will try to debug step by step packet path inside the kernel to find where it's become corrupted. But it looks time consuming for people like us, not really experts in driver development. If you have any tips or ideas concerning this topic, it could help us a lot.
> 
> Best regards,
> 

Previously in this thread you sent an example of a corrupted packet, a LLC packet.
For my understanding, is LLC configured in your config? See net/llc/Kconfig.
If yes, then does the issue also occur with this option disabled?

Heiner
