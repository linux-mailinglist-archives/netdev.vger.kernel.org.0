Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 063D98F877
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 03:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfHPB2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 21:28:18 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35862 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfHPB2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 21:28:17 -0400
Received: by mail-pf1-f194.google.com with SMTP id w2so2253839pfi.3;
        Thu, 15 Aug 2019 18:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gz9ph6cuUFzx7xIV4suHXvoUxpw716k2jFUVdSsCO8w=;
        b=D1+ILqyOnVKvWtZZFjq4yhI7VqhH//j5fRrFGMfyYRbNoiCuG3K+wIv97sf0liW3zy
         3pLEtzL6fgZC7uQU4ZAOzwHwktvSqjHO8dVN6pMiRgbK0KH7ZHWfsKxpApX2kIKnyDQi
         IW+V0KeBmOStAJtLg0xzeKu0Qab9cRePe+6FPO0fCESNgwfPm7uu2B6VYj4DN2SvXxHx
         gi+ZMhkCyutvQusUfizYEnhTBmBw1QQC67Nm7h+tc5I/JjtFB3dK8Q4o2YFJ2NHja6mh
         zO9aNkArMbLu5pWi9vD4W2H4rUx7WEIgEUZrGMUr2znxVNZgNN3YPvq8Htsw8I00Vjan
         QLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gz9ph6cuUFzx7xIV4suHXvoUxpw716k2jFUVdSsCO8w=;
        b=ocgTjoi7kQ8SWDIBNjHvFsIOfiIRT0HJ0B2Jmt3jsZ4JdgsGPiWpgGnFkDYqsiT7Fp
         ApDlE252Py/D+fXIbood3kFUE1TqX6yZCD9RucT9DvMcLm7QMc4A2nuZ7qxYiyzgm/0q
         TntCf2mfrXhh2f8vQxC3pwqTR4fclM2yideonmYsQvD+iYIo0NLStEUL179T0a9thX2p
         OX+LmK1ieisJJu+C9DSSLILfbIhhGKyyiTPct5V95HhbBmiY0cYxaSWmxzP4vPtgYH7c
         Uo/oUtGTm6v7XXndvmLsyiKEeZBEYIlq4jX86HUHzPUitnZ90cK2KY1XIq4QFMLhPBtp
         GyuA==
X-Gm-Message-State: APjAAAVfPiZ3BVj3FZT5pe0Qq6qn/K7NmDor4QxUkPzDUqVBBRzJ/2Zb
        mKF1yLa1P5Gy2lWyYbffidw=
X-Google-Smtp-Source: APXvYqwrbNeO4nIK90W12T4w3uAQzY95iCV+gQAvBjBul0BluPkBg3oqBWU43o/TvvOagTcu1V05OQ==
X-Received: by 2002:a17:90a:1110:: with SMTP id d16mr4933724pja.29.1565918897136;
        Thu, 15 Aug 2019 18:28:17 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id e9sm3848292pge.39.2019.08.15.18.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2019 18:28:16 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next 00/14] xdp_flow: Flow offload to XDP
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, William Tu <u9012063@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
 <20190814170715.GJ2820@mini-arch>
 <14c4a876-6f5d-4750-cbe4-19622f64975b@gmail.com>
 <20190815152100.GN2820@mini-arch>
 <20190815122232.4b1fa01c@cakuba.netronome.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <da840b14-ab5b-91f1-df2f-6bdd0ed41173@gmail.com>
Date:   Fri, 16 Aug 2019 10:28:10 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190815122232.4b1fa01c@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/08/16 4:22, Jakub Kicinski wrote:
> On Thu, 15 Aug 2019 08:21:00 -0700, Stanislav Fomichev wrote:
>> On 08/15, Toshiaki Makita wrote:
>>> On 2019/08/15 2:07, Stanislav Fomichev wrote:
>>>> On 08/13, Toshiaki Makita wrote:
>>>>> * Implementation
>>>>>
>>>>> xdp_flow makes use of UMH to load an eBPF program for XDP, similar to
>>>>> bpfilter. The difference is that xdp_flow does not generate the eBPF
>>>>> program dynamically but a prebuilt program is embedded in UMH. This is
>>>>> mainly because flow insertion is considerably frequent. If we generate
>>>>> and load an eBPF program on each insertion of a flow, the latency of the
>>>>> first packet of ping in above test will incease, which I want to avoid.
>>>> Can this be instead implemented with a new hook that will be called
>>>> for TC events? This hook can write to perf event buffer and control
>>>> plane will insert/remove/modify flow tables in the BPF maps (contol
>>>> plane will also install xdp program).
>>>>
>>>> Why do we need UMH? What am I missing?
>>>
>>> So you suggest doing everything in xdp_flow kmod?
>> You probably don't even need xdp_flow kmod. Add new tc "offload" mode
>> (bypass) that dumps every command via netlink (or calls the BPF hook
>> where you can dump it into perf event buffer) and then read that info
>> from userspace and install xdp programs and modify flow tables.
>> I don't think you need any kernel changes besides that stream
>> of data from the kernel about qdisc/tc flow creation/removal/etc.
> 
> There's a certain allure in bringing the in-kernel BPF translation
> infrastructure forward. OTOH from system architecture perspective IMHO
> it does seem like a task best handed in user space. bpfilter can replace
> iptables completely, here we're looking at an acceleration relatively
> loosely coupled with flower.

I don't think it's loosely coupled. Emulating TC behavior in userspace
is not so easy.

Think about recent multi-mask support in flower. Previously userspace could
assume there is one mask and hash table for each preference in TC. After the
change TC accepts different masks with the same pref. Such a change tends to
break userspace emulation. It may ignore masks passed from flow insertion
and use the mask remembered when the first flow of the pref is inserted. It
may override the mask of all existing flows with the pref. It may fail to
insert such flows. Any of them would result in unexpected wrong datapath
handling which is critical.
I think such an emulation layer needs to be updated in sync with TC.

Toshiaki Makita
