Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDDC40F309
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 09:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239361AbhIQHU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 03:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239196AbhIQHU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 03:20:26 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414F2C061764;
        Fri, 17 Sep 2021 00:19:01 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so8705804pjb.2;
        Fri, 17 Sep 2021 00:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=KKt5AWTLK0tIOKcdr0XGkLxMl+Fod9jsU5NOqvL/LwY=;
        b=OGNcv4U9n6ABRlqOjeyYxj2m2dLT+GdPU3h8J90Fo/RDGo4LKnf6Sw8Zschlp+zyd5
         8RwwSpbSUeQXDsZOaw4XlENYpT9wge5Ee0se75p3Ph/CODaSmXnWY9jlGaP8z87bTAum
         QsBe9jie20lsUrSZVSnSqXk5m7/TL1pwr2JXW3uCD0QSGY/thhd+h7eDqzPaebrgl43Z
         +Pu+gvepvhfM6tBXXZ44bEvuRgx0N7jz1AyYIxFy6jQc6mcZioxE5AMTuSAWV84IM/kV
         nE6GvoYICahyNUHrH8Nk85g7Hu0BHfQLOiNLpTJf9FKXL08Rz6g/73Yngdyh4gPbElou
         8Dwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=KKt5AWTLK0tIOKcdr0XGkLxMl+Fod9jsU5NOqvL/LwY=;
        b=GcX+EuqaQmhRDT/zo932gNrymKjmL84jbBSyPuJjG1su9pgFkCQTP+30j04TBPVK2I
         oYcEo+kNj13qIKkhz2h2YvssdgPmvwMJ1J+bWh58pzMu5r/7P/i3uYRi5C/7hgNM0CGd
         Xri6h+ghkwP7N3kKet5ghhgiY/iJzj+pIKeRUQZ0YViQfDFktPMIYc4YhuBKtWn8fm28
         A+n8lOPwYhUFvCiXc6miV5E4NBOZDjcnYlgFU1CJqMcA3P7zVliX+meaa51W7r1bkHAL
         T5bE/VqKgsYgjUaeJwmjP/ot0xiJc6RgIcZbjaHTzO2PwcYvLjdrWhcrrUeGaCRgiXzo
         IPZA==
X-Gm-Message-State: AOAM530lAAn/7sWdc/rppwADHEYW3AhkomeXuPN0S0WrJn98csh23Haj
        ql+4sClgYJfHGCIXzEC3y1A=
X-Google-Smtp-Source: ABdhPJzLTe/k8m8JKgJLdgpYaFvNkIQ7/arj27CdRiFqtG2lS8t+qLupw+ufAavOnpAYvnYjA2SITA==
X-Received: by 2002:a17:90b:1642:: with SMTP id il2mr10681860pjb.167.1631863140606;
        Fri, 17 Sep 2021 00:19:00 -0700 (PDT)
Received: from localhost (122x211x248x161.ap122.ftth.ucom.ne.jp. [122.211.248.161])
        by smtp.gmail.com with ESMTPSA id u10sm4815419pjf.46.2021.09.17.00.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 00:18:59 -0700 (PDT)
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
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
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
Date:   Fri, 17 Sep 2021 16:18:57 +0900
In-Reply-To: <2424d7da-7022-0b38-46ba-b48f43cda23d@suse.com> (Qu Wenruo's
        message of "Fri, 17 Sep 2021 10:22:09 +0800")
Message-ID: <877dff7jq6.fsf@stealth>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Qu,

Qu Wenruo <wqu@suse.com> writes:

> On 2021/8/30 22:10, Michael Riesch wrote:
>> Hi Punit,
>> On 8/30/21 3:49 PM, Punit Agrawal wrote:
>>> Hi Michael,
>>>
>>> Michael Riesch <michael.riesch@wolfvision.net> writes:
>>>
>>>> Hi ChenYu,
>>>>
>>>> On 8/29/21 7:48 PM, Chen-Yu Tsai wrote:
>>>>> Hi,
>>>>>
>>>>> On Mon, Aug 23, 2021 at 10:39 PM Michael Riesch
>>>>> <michael.riesch@wolfvision.net> wrote:
>>>>>>
>>>>>> This reverts commit 2c896fb02e7f65299646f295a007bda043e0f382
>>>>>> "net: stmmac: dwmac-rk: add pd_gmac support for rk3399" and fixes
>>>>>> unbalanced pm_runtime_enable warnings.
>>>>>>
>>>>>> In the commit to be reverted, support for power management was
>>>>>> introduced to the Rockchip glue code. Later, power management support
>>>>>> was introduced to the stmmac core code, resulting in multiple
>>>>>> invocations of pm_runtime_{enable,disable,get_sync,put_sync}.
>>>>>>
>>>>>> The multiple invocations happen in rk_gmac_powerup and
>>>>>> stmmac_{dvr_probe, resume} as well as in rk_gmac_powerdown and
>>>>>> stmmac_{dvr_remove, suspend}, respectively, which are always called
>>>>>> in conjunction.
>>>>>>
>>>>>> Signed-off-by: Michael Riesch <michael.riesch@wolfvision.net>
>>>>>
>>>>> I just found that Ethernet stopped working on my RK3399 devices,
>>>>> and I bisected it down to this patch.
>>>>
>>>> Oh dear. First patch in a kernel release for a while and I already break
>>>> things.
>>>
>>> I am seeing the same failure symptoms reported by ChenYu on my RockPro64
>>> with v5.14. Reverting the revert i.e., 2d26f6e39afb ("net: stmmac:
>>> dwmac-rk: fix unbalanced pm_runtime_enable warnings") brings back the
>>> network.
>>>
>>>> Cc: Sasha as this patch has just been applied to 5.13-stable.
>>>>
>>>>> The symptom I see is no DHCP responses, either because the request
>>>>> isn't getting sent over the wire, or the response isn't getting
>>>>> received. The PHY seems to be working correctly.
>>>>
>>>> Unfortunately I don't have any RK3399 hardware. Is this a custom
>>>> board/special hardware or something that is readily available in the
>>>> shops? Maybe this is a good reason to buy a RK3399 based single-board
>>>> computer :-)
>>>
>>> Not sure about the other RK3399 boards but RockPro64 is easily
>>> available.
>> I was thinking to get one of those anyway ;-)
>> 
>>>> I am working on the RK3568 EVB1 and have not encountered faulty
>>>> behavior. DHCP works fine and I can boot via NFS. Therefore, not sure
>>>> whether I can be much of help in this matter, but in case you want to
>>>> discuss this further please do not hesitate to contact me off-list.
>>>
>>> I tried to look for the differences between RK3568 and RK3399 but the
>>> upstream device tree doesn't seem to carry a gmac node in the device
>>> tree for EK3568 EVB1. Do you have a pointer for the dts you're using?
>> The gmac nodes have been added recently and should enter
>> 5.15-rc1. Until
>> then, you can check out the dts from linux-rockchip/for-next [0].
>
> Do you have the upstream commit?
>
> As I compiled v5.15-rc1 and still can't get the ethernet work.
>
> Not sure if it's my Uboot->systemd-boot->customer kernel setup not
> passing the device tree correctly or something else...

For the RK3568 device tree changes, I think the pull request got delayed
to the next cycle. So likely to land in v5.16.

In case you're after ethernet on RK3399, there's no solution
yet. Reverting 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced
pm_runtime_enable warnings") gets you there in the meanwhile.

[...]

