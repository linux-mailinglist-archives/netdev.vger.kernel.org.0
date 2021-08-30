Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C1C3FB742
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 15:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236945AbhH3Nub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 09:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbhH3Nua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 09:50:30 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBADC061575;
        Mon, 30 Aug 2021 06:49:36 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id d5so3741367pjx.2;
        Mon, 30 Aug 2021 06:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=sEL6//skpXK4Qyqc8Jdde129w8xF3Lu6qgCZPjdrGcQ=;
        b=smBI4VAxUel1TB4Wlp0QPxXgQboRnJKcEpl4OcOuGH6xZJbVE2lKRCc966PDCx1U+C
         5YImx8GxcydtlVg9a2PYyYmgTHqgHOWYJnvYvPMbzmw0KPBubmblPmwmZRZAQcDG7F6u
         qSnaBQ3yvDyt7fpMxbSiIYeN/q+WP4403Sn5v5eJo4C/i8r/0dh2PZPcbXgtQ08dwdia
         jaCHA8HR6W1cD4kuqgtdMObTvy5KG/odhgkhaDaTGTzm7NyTl/U6L6zDRRsIGNUvOgSD
         WSdWEt4Mr2BxHINBk4U4RzXhuZEPR3FaZyqj0k8ZoX7re2eGwbN82w8XulFV/mR//e0/
         2rRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=sEL6//skpXK4Qyqc8Jdde129w8xF3Lu6qgCZPjdrGcQ=;
        b=TAojoJnBsFqxT2eVvQF37sMw+YabrgLIXm1lJnIFiKB7kHsFFSUZWJtWStr6Nmv+vD
         96v34Ta5cb60c7QtjDObDLse0BxwW+ESw7fHEma6W9bJMTrPjEGN5+/7dwfgEbgysG0u
         lXEyDVnrjfbPH/BMp+L+9sQzBdZg+graGzwdgg3QqZy+8XQ5X4gzKb9s5l8FgRNLdQmQ
         HAkOxVm0ulcQd1GvPW5aSRqHh3P+gQEHal6GJTj7ZU/qj3QuU1ofM9ALjCdM1hzgLjfG
         tTXU1mbiRu774OGr1QILN1PSJPq8nrF7T0mYGuzWqaGF6IzUUC1boLoVHNJdBo5Mh4KK
         xBsg==
X-Gm-Message-State: AOAM532idiCGc/pe5tHGxHU7ETw6vU7byf8gP4DlXeeJgQRHdxycMKt0
        YzYEyEPAV0i0Xdi0wI65hxg=
X-Google-Smtp-Source: ABdhPJxr+a34jajETUtu8a+GSDU1I2IxnoOCr/ht7tNQDe29mKMxkdj59W4xIpvU5RL6/AtyL+FKXA==
X-Received: by 2002:a17:902:6a81:b0:12d:c933:6330 with SMTP id n1-20020a1709026a8100b0012dc9336330mr21632098plk.69.1630331376009;
        Mon, 30 Aug 2021 06:49:36 -0700 (PDT)
Received: from localhost (122x211x248x161.ap122.ftth.ucom.ne.jp. [122.211.248.161])
        by smtp.gmail.com with ESMTPSA id j6sm16585933pgh.17.2021.08.30.06.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 06:49:35 -0700 (PDT)
From:   Punit Agrawal <punitagrawal@gmail.com>
To:     Michael Riesch <michael.riesch@wolfvision.net>
Cc:     wens@kernel.org, netdev <netdev@vger.kernel.org>,
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
Date:   Mon, 30 Aug 2021 22:49:32 +0900
In-Reply-To: <568a0825-ed65-58d7-9c9c-cecb481cf9d9@wolfvision.net> (Michael
        Riesch's message of "Mon, 30 Aug 2021 09:57:51 +0200")
Message-ID: <87czpvcaab.fsf@stealth>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

Michael Riesch <michael.riesch@wolfvision.net> writes:

> Hi ChenYu,
>
> On 8/29/21 7:48 PM, Chen-Yu Tsai wrote:
>> Hi,
>> 
>> On Mon, Aug 23, 2021 at 10:39 PM Michael Riesch
>> <michael.riesch@wolfvision.net> wrote:
>>>
>>> This reverts commit 2c896fb02e7f65299646f295a007bda043e0f382
>>> "net: stmmac: dwmac-rk: add pd_gmac support for rk3399" and fixes
>>> unbalanced pm_runtime_enable warnings.
>>>
>>> In the commit to be reverted, support for power management was
>>> introduced to the Rockchip glue code. Later, power management support
>>> was introduced to the stmmac core code, resulting in multiple
>>> invocations of pm_runtime_{enable,disable,get_sync,put_sync}.
>>>
>>> The multiple invocations happen in rk_gmac_powerup and
>>> stmmac_{dvr_probe, resume} as well as in rk_gmac_powerdown and
>>> stmmac_{dvr_remove, suspend}, respectively, which are always called
>>> in conjunction.
>>>
>>> Signed-off-by: Michael Riesch <michael.riesch@wolfvision.net>
>> 
>> I just found that Ethernet stopped working on my RK3399 devices,
>> and I bisected it down to this patch.
>
> Oh dear. First patch in a kernel release for a while and I already break
> things.

I am seeing the same failure symptoms reported by ChenYu on my RockPro64
with v5.14. Reverting the revert i.e., 2d26f6e39afb ("net: stmmac:
dwmac-rk: fix unbalanced pm_runtime_enable warnings") brings back the
network.

> Cc: Sasha as this patch has just been applied to 5.13-stable.
>
>> The symptom I see is no DHCP responses, either because the request
>> isn't getting sent over the wire, or the response isn't getting
>> received. The PHY seems to be working correctly.
>
> Unfortunately I don't have any RK3399 hardware. Is this a custom
> board/special hardware or something that is readily available in the
> shops? Maybe this is a good reason to buy a RK3399 based single-board
> computer :-)

Not sure about the other RK3399 boards but RockPro64 is easily
available.

> I am working on the RK3568 EVB1 and have not encountered faulty
> behavior. DHCP works fine and I can boot via NFS. Therefore, not sure
> whether I can be much of help in this matter, but in case you want to
> discuss this further please do not hesitate to contact me off-list.

I tried to look for the differences between RK3568 and RK3399 but the
upstream device tree doesn't seem to carry a gmac node in the device
tree for EK3568 EVB1. Do you have a pointer for the dts you're using?

Also, other than the warning "Unbalanced pm_runtime_enable!" do you
notice any other ill-effects without your patch?

If this affects all RK3399 boards as ChenYu suggests quite a few users
are going to miss the network once they upgrade.

Punit

[...]

