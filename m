Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC7240FB6A
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239263AbhIQPMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238936AbhIQPMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 11:12:53 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E34C061574;
        Fri, 17 Sep 2021 08:11:32 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mv7-20020a17090b198700b0019c843e7233so3875925pjb.4;
        Fri, 17 Sep 2021 08:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=r2RrJiEEpsRgQCHuxCAXJ8mbd4K7vVzXiaC0Gr2CnAw=;
        b=pWgcVNMhEZOA69aKFNWJwg3VmHa5LdQCEBJJZO1xH+PRmYT56z0jSKa+ggijbbaG+g
         12kQ25dUH682gtDxa6vXF55uC/0/19zjH+j+0L36RS1J8JRgiE049uGkBIzP3HQPaI/r
         Yhly8/8LGIqQkwqBV35mLBjYOu59M4hLRNOZ4MCClnRVEd3rPP2Z7E3cDaMENg9aCXjT
         vk5kzkSFX2KbPvVtDbVIOgQElOyLo27baw3lkKP0oWqE4nJcpRR7tLKQenEE+etmdOYO
         4GBXodOv3+WWTJhkjZA+XxZdicCjBUw6ekDnmevPQlOVqs6udae13ua6WsxCfbx0ti8X
         NSqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=r2RrJiEEpsRgQCHuxCAXJ8mbd4K7vVzXiaC0Gr2CnAw=;
        b=gtrucg3rb0c9tvRyxCdNjY4lLsiZROzi/YFVgvVPyJwkLOXiO0eFTFflu2Ly4NDTo+
         VYaxuqSqI9RDaAhalwoJRlJvMlbnpe7zKQAJEeCVt+/FZpGFgkR2otdVSXWDqo+Ud71d
         jQPUJdB5upgr/mjRrdAljnA+oOTJZyR2C8Rdvnmr6wd+Wt7G9Ub+wztcROmzcT09KUs3
         1UZbIReedM1yOJAn+suELMCHrwcavRGAde/YxHp0arDVOZyWX49jGHfVJ8FyZ1mJ5yuq
         FSt1j0gtxuNwLdyvKuoJHPJKWrb7ihlBe/iy0KNfz+Em3BeG8qRmnysa1Q5cUlIbukVI
         n5sw==
X-Gm-Message-State: AOAM530NVEf3Xa71Rf0PYaXatofhD6f1lFgA6gmvcpj6MJP0C1x5bJJr
        35eLKm9s/jHf/ekgeSn6FjY77hZb3olGtg==
X-Google-Smtp-Source: ABdhPJxJ4+6F3QMapQMAbfBhQNz7vT4Jw2fiYFQYfg8YyrrllwIi2qtejMHSvQU8z3bC4P4bDpgqag==
X-Received: by 2002:a17:90b:350d:: with SMTP id ls13mr21395876pjb.235.1631891491434;
        Fri, 17 Sep 2021 08:11:31 -0700 (PDT)
Received: from localhost (122x211x248x161.ap122.ftth.ucom.ne.jp. [122.211.248.161])
        by smtp.gmail.com with ESMTPSA id b10sm6450960pfi.122.2021.09.17.08.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 08:11:30 -0700 (PDT)
From:   Punit Agrawal <punitagrawal@gmail.com>
To:     Qu Wenruo <wqu@suse.com>
Cc:     Michael Riesch <michael.riesch@wolfvision.net>, wens@kernel.org,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>, sashal@kernel.org
Subject: Re: [PATCH] net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable
 warnings
References: <20210823143754.14294-1-michael.riesch@wolfvision.net>
        <CAGb2v67Duk_56fOKVwZsYn2HKJ99o8WJ+d4jetD2UjDsAt9BcA@mail.gmail.com>
        <568a0825-ed65-58d7-9c9c-cecb481cf9d9@wolfvision.net>
        <87czpvcaab.fsf@stealth>
        <aa905e4d-c5a7-e969-1171-3a90ecd9b9cc@wolfvision.net>
        <2424d7da-7022-0b38-46ba-b48f43cda23d@suse.com>
        <877dff7jq6.fsf@stealth>
        <902ad36d-153c-857b-40a6-449f76aa17b0@suse.com>
Date:   Sat, 18 Sep 2021 00:11:28 +0900
In-Reply-To: <902ad36d-153c-857b-40a6-449f76aa17b0@suse.com> (Qu Wenruo's
        message of "Fri, 17 Sep 2021 16:02:01 +0800")
Message-ID: <87zgsb5ja7.fsf@stealth>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qu Wenruo <wqu@suse.com> writes:

> On 2021/9/17 15:18, Punit Agrawal wrote:
>> Hi Qu,
>> Qu Wenruo <wqu@suse.com> writes:
>> 
>>> On 2021/8/30 22:10, Michael Riesch wrote:
>>>> Hi Punit,
>>>> On 8/30/21 3:49 PM, Punit Agrawal wrote:
>>>>> Hi Michael,
>>>>>
>>>>> Michael Riesch <michael.riesch@wolfvision.net> writes:
>>>>>
>>>>>> Hi ChenYu,
>>>>>>
>>>>>> On 8/29/21 7:48 PM, Chen-Yu Tsai wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> On Mon, Aug 23, 2021 at 10:39 PM Michael Riesch
>>>>>>> <michael.riesch@wolfvision.net> wrote:
>>>>>>>>
>>>>>>>> This reverts commit 2c896fb02e7f65299646f295a007bda043e0f382
>>>>>>>> "net: stmmac: dwmac-rk: add pd_gmac support for rk3399" and fixes
>>>>>>>> unbalanced pm_runtime_enable warnings.
>>>>>>>>
>>>>>>>> In the commit to be reverted, support for power management was
>>>>>>>> introduced to the Rockchip glue code. Later, power management support
>>>>>>>> was introduced to the stmmac core code, resulting in multiple
>>>>>>>> invocations of pm_runtime_{enable,disable,get_sync,put_sync}.
>>>>>>>>
>>>>>>>> The multiple invocations happen in rk_gmac_powerup and
>>>>>>>> stmmac_{dvr_probe, resume} as well as in rk_gmac_powerdown and
>>>>>>>> stmmac_{dvr_remove, suspend}, respectively, which are always called
>>>>>>>> in conjunction.
>>>>>>>>
>>>>>>>> Signed-off-by: Michael Riesch <michael.riesch@wolfvision.net>
>>>>>>>
>>>>>>> I just found that Ethernet stopped working on my RK3399 devices,
>>>>>>> and I bisected it down to this patch.
>>>>>>
>>>>>> Oh dear. First patch in a kernel release for a while and I already break
>>>>>> things.
>>>>>
>>>>> I am seeing the same failure symptoms reported by ChenYu on my RockPro64
>>>>> with v5.14. Reverting the revert i.e., 2d26f6e39afb ("net: stmmac:
>>>>> dwmac-rk: fix unbalanced pm_runtime_enable warnings") brings back the
>>>>> network.
>>>>>
>>>>>> Cc: Sasha as this patch has just been applied to 5.13-stable.
>>>>>>
>>>>>>> The symptom I see is no DHCP responses, either because the request
>>>>>>> isn't getting sent over the wire, or the response isn't getting
>>>>>>> received. The PHY seems to be working correctly.
>>>>>>
>>>>>> Unfortunately I don't have any RK3399 hardware. Is this a custom
>>>>>> board/special hardware or something that is readily available in the
>>>>>> shops? Maybe this is a good reason to buy a RK3399 based single-board
>>>>>> computer :-)
>>>>>
>>>>> Not sure about the other RK3399 boards but RockPro64 is easily
>>>>> available.
>>>> I was thinking to get one of those anyway ;-)
>>>>
>>>>>> I am working on the RK3568 EVB1 and have not encountered faulty
>>>>>> behavior. DHCP works fine and I can boot via NFS. Therefore, not sure
>>>>>> whether I can be much of help in this matter, but in case you want to
>>>>>> discuss this further please do not hesitate to contact me off-list.
>>>>>
>>>>> I tried to look for the differences between RK3568 and RK3399 but the
>>>>> upstream device tree doesn't seem to carry a gmac node in the device
>>>>> tree for EK3568 EVB1. Do you have a pointer for the dts you're using?
>>>> The gmac nodes have been added recently and should enter
>>>> 5.15-rc1. Until
>>>> then, you can check out the dts from linux-rockchip/for-next [0].
>>>
>>> Do you have the upstream commit?
>>>
>>> As I compiled v5.15-rc1 and still can't get the ethernet work.
>>>
>>> Not sure if it's my Uboot->systemd-boot->customer kernel setup not
>>> passing the device tree correctly or something else...
>> For the RK3568 device tree changes, I think the pull request got
>> delayed
>> to the next cycle. So likely to land in v5.16.
>> In case you're after ethernet on RK3399, there's no solution
>> yet. Reverting 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced
>> pm_runtime_enable warnings") gets you there in the meanwhile.
>
> Thanks, currently I have seen other distros like ManjaroARM is already
> reverting that commit.
>
> But even with that commit reverted, I still get some other strange
> network behavior.
>
> The most weird one is distcc, when the RK3399 board is the client and
> x86_64 desktop acts as a volunteer, after compiling hundreds of files, 
> it suddenly no longer work.

I haven't seen something like this - but then I am not a heavy user of
the network on the board. 

Is it just the network that dies or the whole system freezes? Sometimes
I've seen the board lock up if it's under heavy load.

> All work can no longer be distributed to the same volunteer.
>
>
> But on RPI CM4 board, the same kernel (both upstream 5.14.2, even the
> binary is the same), the same distro (Manjaro ARM), the same distcc 
> setup, the setup works flawless.
>
>
> Not sure if this is related, but it looks like a network related
> problem, and considering both boards are using the same kernel, just 
> different ethernet driver, I guess there is something more problematic
> here in recent RK3399 code.

If you are only seeing the problem with recent kernels, maybe a bisect
might help narrow things down.

[...]
