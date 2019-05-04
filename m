Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7568D13B62
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 19:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfEDRYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 13:24:11 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45711 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbfEDRYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 13:24:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id e24so4497635pfi.12;
        Sat, 04 May 2019 10:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0JVR+B0UU3TgsLiMAHGGrQRoriLTMKx5OUbcXksRlDc=;
        b=NrhwHrCg0m6lIyB40Emk1ksd8UDGBYE4QQkeWpHGEkFKzWtAB8HNQl/amDI2FVPdMX
         a3MBH2WXso6QDtLwZ8LInhkJyZbJdACglugp2WK1a1mGwrwNw5JeDQxlPcVoyt1ArHmj
         kgG05BnmgfEqJTunyjQNg3Asyg3hUW10b4wrdrZv34TPvjN4HXeBvjLfjtnX1Ahyowyi
         uxIGVDQajqOrz9Qnd7tZRLL/EOSwaSZrd9AB40rlpQjbZmLlwmv2tNgTg9wEjQ3ghF7j
         25mHK4BEESYwMHNbw2Qwrz6p50D3Z+FsHW+pTpwZ9vD9Dpq/70cogv9fDI7o7hZQst+u
         2jqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0JVR+B0UU3TgsLiMAHGGrQRoriLTMKx5OUbcXksRlDc=;
        b=o8npqdAh0OgnRqC6d45Y4ZzzdRY9HrGqvYByYd4sZX5MNz7UecoSyItFafLnpr22Vc
         kZQQxM34l6EZJd1OidYas+JteUzNSF/QVFxajsNk/xyGlG3O0ZvAhFA4o82I4UxXq0aN
         8Ow0X0l2tG9VPDiPVLlq8b281G0vuTI9VlJl4F+vyWHvE7u5J/MVYKeBqAfhxSOZ0VJm
         jy813EG86xIMRTADARlnRuMiacKWVs6hMpQTX6AztOWr+Cby6OSJBtDTVR/ezWbfjG8J
         +UuVPCGsuA5ELx8/ZNdVeu0skT4QmophOwn9WmJt4gYULmHJIE/WuEJOAHo70/eiyIbW
         VASg==
X-Gm-Message-State: APjAAAWMykSroUJkK8f4xWx263LWxDAxsW1upT2zUKnzbqbbNfSPdyYV
        v3QNnVZsvzn/TXkxrLsergg=
X-Google-Smtp-Source: APXvYqzyt8fj+PtMYmfYVnfnoWHBpNYlydeIU8RPI/1Dvq2GoGrHyzbCh7vMR8XYPW3NDXgJ+ZCQ1g==
X-Received: by 2002:a62:4690:: with SMTP id o16mr20782606pfi.166.1556990649903;
        Sat, 04 May 2019 10:24:09 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id n9sm6965141pff.59.2019.05.04.10.24.07
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 10:24:08 -0700 (PDT)
Subject: Re: [PATCH] ipv4: Delete uncached routes upon unregistration of
 loopback device.
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "David S. Miller" <davem@davemloft.net>
Cc:     David Ahern <dsahern@gmail.com>, Julian Anastasov <ja@ssi.bg>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        ddstreet@ieee.org, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mahesh Bandewar <maheshb@google.com>
References: <0000000000007d22100573d66078@google.com>
 <alpine.LFD.2.20.1808201527230.2758@ja.home.ssi.bg>
 <4684eef5-ea50-2965-86a0-492b8b1e4f52@I-love.SAKURA.ne.jp>
 <9d430543-33c3-0d9b-dc77-3a179a8e3919@I-love.SAKURA.ne.jp>
 <920ebaf1-ee87-0dbb-6805-660c1cbce3d0@I-love.SAKURA.ne.jp>
 <cc054b5c-4e95-8d30-d4bf-9c85f7e20092@gmail.com>
 <15b353e9-49a2-f08b-dc45-2e9bad3abfe2@i-love.sakura.ne.jp>
 <057735f0-4475-7a7b-815f-034b1095fa6c@gmail.com>
 <6e57bc11-1603-0898-dfd4-0f091901b422@i-love.sakura.ne.jp>
 <f71dd5cd-c040-c8d6-ab4b-df97dea23341@gmail.com>
 <d56b7989-8ac6-36be-0d0b-43251e1a2907@gmail.com>
 <117fcc49-d389-c389-918f-86ccaef82e51@i-love.sakura.ne.jp>
 <70be7d61-a6fe-e703-978a-d17f544efb44@gmail.com>
 <40199494-8eb7-d861-2e3b-6e20fcebc0dc@i-love.sakura.ne.jp>
 <519ea12b-4c24-9e8e-c5eb-ca02c9c7d264@i-love.sakura.ne.jp>
 <f6f770a7-17af-d51f-3ffb-4edba9b28101@gmail.com>
 <ab80de53-25b8-618b-4dcb-b732059f6f9c@i-love.sakura.ne.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ed916873-4d7d-43f3-07cf-028d3ef4177c@gmail.com>
Date:   Sat, 4 May 2019 13:24:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <ab80de53-25b8-618b-4dcb-b732059f6f9c@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/19 1:09 PM, Tetsuo Handa wrote:
> On 2019/05/05 0:56, Eric Dumazet wrote:> 
>> Well, you have not fixed a bug, you simply made sure that whatever cpu is using the
>> routes you forcibly deleted is going to crash the host very soon (use-after-frees have
>> undefined behavior, but KASAN should crash most of the times)
> 
> I confirmed that this patch survives "#syz test:" before submitting.
> But you know that this patch is deleting the route entry too early. OK.
> 
>>
>> Please do not send patches like that with a huge CC list, keep networking patches
>> to netdev mailing list.
> 
> If netdev people started working on this "minutely crashing bug" earlier,
> I would not have written a patch...


So, just that you know, we are working on bug fixes, and this is best effort.

It is not because _you_ want to fix a particular bug (out of hundreds)
that we need to stop everything and work full time on a particular bug.

And here the root cause of the problem is elsewhere. A dst is leaking somewhere,
and prevents the netns dismantle.

We had many dst leaks in the past, and they keep being added by new bugs.

> 
>>
>> Mahesh has an alternative patch, adding a fake device that can not be dismantled
>> to make sure we fully intercept skbs sent through a dead route, instead of relying
>> on loopback dropping them later at some point.
> 
> So, the reason to temporarily move the refcount is to give enough period
> so that the route entry is no longer used. But moving the refcount to a
> loopback device in a namespace was wrong. Is this understanding correct?

I believe you need spend more time on studying the networking code by yourself,
add tracing if you believe this could be useful to you and others.

> 
> Compared to moving the refcount to the loopback device in the init namespace,
> the fake device can somehow drop the refcount moved via rt_flush_dev(), can't it?
> 

The fake device wont ever disappear.

> Anyway, I'll wait for Mahesh.
> 
