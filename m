Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613F1468F1C
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 03:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbhLFCbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 21:31:00 -0500
Received: from mail.loongson.cn ([114.242.206.163]:37718 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233372AbhLFCa7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 21:30:59 -0500
Received: from [10.180.13.84] (unknown [10.180.13.84])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxP8sQda1hB2IDAA--.7780S2;
        Mon, 06 Dec 2021 10:27:29 +0800 (CST)
Subject: Re: [PATCH v2 1/2] modpost: file2alias: fixup mdio alias garbled code
 in modules.alias
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, zhuyinbo@loongson.cn
References: <1637919957-21635-1-git-send-email-zhuyinbo@loongson.cn>
 <c6d37ae0-9ccb-a527-4f55-e96972813a53@gmail.com>
 <YaYPMOJ/+OXIWcnj@shell.armlinux.org.uk> <YabEHd+Z5SPAhAT5@lunn.ch>
From:   zhuyinbo <zhuyinbo@loongson.cn>
Message-ID: <56f1d181-92a3-859e-9185-ed785ca1afa1@loongson.cn>
Date:   Mon, 6 Dec 2021 10:27:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <YabEHd+Z5SPAhAT5@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf9DxP8sQda1hB2IDAA--.7780S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw4rWFyxXr15XF4UJFWrZrb_yoW8KFWUpa
        y3ta9IkFZ8GF4xta1rZF47uFy8C3yvy3y3KF1rG39Ygwn8ZrySyw13Krn09a9rJr1fAr12
        gayYvFykC3Z5XFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9C14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F
        4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE
        67vIY487MxkF7I0En4kS14v26r1q6r43MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCFx2
        IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
        6r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
        AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
        s7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
        0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdl19UUUUU=
X-CM-SenderInfo: 52kx5xhqerqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/12/1 上午8:38, Andrew Lunn 写道:
>> However, this won't work for PHY devices created _before_ the kernel
>> has mounted the rootfs, whether or not they end up being used. So,
>> every PHY mentioned in DT will be created before the rootfs is mounted,
>> and none of these PHYs will have their modules loaded.
> Hi Russell
>
> I think what you are saying here is, if the MAC or MDIO bus driver is
> built in, the PHY driver also needs to be built in?
>
> If the MAC or MDIO bus driver is a module, it means the rootfs has
> already been mounted in order to get these modules. And so the PHY
> driver as a module will also work.
>
>> I believe this is the root cause of Yinbo Zhu's issue.
> You are speculating that in Yinbo Zhu case, the MAC driver is built
> in, the PHY is a module. The initial request for the firmware fails.
> Yinbo Zhu would like udev to try again later when the modules are
> available.
>
>> What we _could_ do is review all device trees and PHY drivers to see
>> whether DT modaliases are ever used for module loading. If they aren't,
>> then we _could_ make the modalias published by the kernel conditional
>> on the type of mdio device - continue with the DT approach for non-PHY
>> devices, and switch to the mdio: scheme for PHY devices. I repeat, this
>> can only happen if no PHY drivers match using the DT scheme, otherwise
>> making this change _will_ cause a regression.
> Take a look at
> drivers/net/mdio/of_mdio.c:whitelist_phys[] and the comment above it.
>
> So there are some DT blobs out there with compatible strings for
> PHYs. I've no idea if they actually load that way, or the standard PHY
> mechanism is used.
>
> 	Andrew

Hi Andrew, Russell King,


mdio phy device use DT that it isn't appropriate, because phy device was 
depend on mac and was set by mac use mdio.

even though, you use DT to descripte phy device and phy driver must use 
"of" type export, and in mainstrem phy driver,

most of phy driver was use "mdio",  not use DT, please you note! 
perphaps you can learn about do_of_table, and the key

point is that uevent wheter match alias configure for module auto load 
issue.

for more detailed information, please review v4 patch some explain:

[v4,1/2] modpost: file2alias: make mdio alias configure match mdio uevent.

https://patchwork.kernel.org/project/netdevbpf/patch/1638609208-10339-1-git-send-email-zhuyinbo@loongson.cn/


BRs,

Yinbo Zhu.

