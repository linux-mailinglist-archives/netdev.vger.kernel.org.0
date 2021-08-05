Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B233E0E65
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 08:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237333AbhHEGb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 02:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235664AbhHEGbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 02:31:24 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C2EC061765
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 23:31:10 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n12-20020a05600c3b8cb029025a67bbd40aso5461633wms.0
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 23:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6jUhEtKSiG7ZerzsDL2H1kO7Htn4R9iX/da1sgzTYhQ=;
        b=sVkwhLsN7lFzvmfY3MOh+638o1qqgcCi1P8Mz/17oEAwPa4qnuPqbFxbhny+sYRAkX
         l3KQp/WFPkwKHO/sgBLIC6Gswo9/GKzE+u9ZBqmOq1NQd+DXQbd4Hd3BCbdCWQ57pTin
         1xA7/h53c5t/wsXjIkv0R62LWSm25FluPws1e4TUmKiDrcJMVdszVF+tf/jqCn61AC8g
         YgeQTyFVuuqAzA+PWHr9sWy3gwEKX9YYxL0mwH1uclnJaRIkiSUchCftUP8ZPwfyOQ4F
         xgNzj2zblW+nFiQcaXNTapERV2fNgVVo45D7LUjFk2u8kg4ENZEEpBNg5RnOBCZG/7t6
         XImw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6jUhEtKSiG7ZerzsDL2H1kO7Htn4R9iX/da1sgzTYhQ=;
        b=KnynWOfR0pyswwQgdeCTVJ6rOz0PMQVVAD+tr2pw53gVL2j4jhG8R+jCoiQVpKb9CB
         n08oQdLXaY7KAts1qFly5U9x6DjanH5SpB7mOlmJn7TLnmAdrJZdONot+Cfpzuq768fe
         KH4mKXJ7g11E+4xtIgJo2CseyPakURszQN5syklwSoWT4JyjTcWRcBkeN2LdCuBYyGNI
         FAHuUl49to2J97dZ3P8hh9XTTOABbo8YdHivbuCLfXITnxs4qeK5rTS6xCSQnrgAWfIg
         q+SNpkyZc2d4sihsILkeyRxe9kxnDjAh80vzm5zwwQEqErQ0JFc9rnkVuSLN/S6Sgpha
         ZROw==
X-Gm-Message-State: AOAM533t1ffFlWg04UJLC9huVD25UMWH/dpryeJjXAMUQeIsCKN55UKG
        npsIf0ivcP9tlOTj0UftVlz3YQ==
X-Google-Smtp-Source: ABdhPJwhzVUVFwT3U+v9V/pf/bnOjk+HxXuJhP6KwE+dmCvAuziAmYWEXS/ynfioDbEwv2YrnygzVg==
X-Received: by 2002:a1c:cc1a:: with SMTP id h26mr3169713wmb.47.1628145068651;
        Wed, 04 Aug 2021 23:31:08 -0700 (PDT)
Received: from [10.1.3.29] (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id j14sm4735302wrr.16.2021.08.04.23.31.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 23:31:08 -0700 (PDT)
Subject: Re: [PATCH 1/2] irqchip: irq-meson-gpio: make it possible to build as
 a module
To:     Saravana Kannan <saravanak@google.com>,
        Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Kevin Hilman <khilman@baylibre.com>,
        Lee Jones <lee.jones@linaro.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
References: <20201020072532.949137-1-narmstrong@baylibre.com>
 <20201020072532.949137-2-narmstrong@baylibre.com>
 <7hsga8kb8z.fsf@baylibre.com>
 <CAF2Aj3g6c8FEZb3e1by6sd8LpKLaeN5hsKrrQkZUvh8hosiW9A@mail.gmail.com>
 <87r1hwwier.wl-maz@kernel.org> <7h7diwgjup.fsf@baylibre.com>
 <87im0m277h.wl-maz@kernel.org>
 <CAGETcx9OukoWM_qprMse9aXdzCE=GFUgFEkfhhNjg44YYsOQLw@mail.gmail.com>
 <87sfzpwq4f.wl-maz@kernel.org>
 <CAGETcx95kHrv8wA-O+-JtfH7H9biJEGJtijuPVN0V5dUKUAB3A@mail.gmail.com>
 <CAGETcx8bpWQEnkpJ0YW9GqX8WE0ewT45zqkbWWdZ0ktJBhG4yQ@mail.gmail.com>
From:   Neil Armstrong <narmstrong@baylibre.com>
Organization: Baylibre
Message-ID: <4e98d876-330f-21a4-846e-94e1f01f0eed@baylibre.com>
Date:   Thu, 5 Aug 2021 08:31:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAGETcx8bpWQEnkpJ0YW9GqX8WE0ewT45zqkbWWdZ0ktJBhG4yQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana,

On 04/08/2021 23:47, Saravana Kannan wrote:
> On Wed, Aug 4, 2021 at 11:20 AM Saravana Kannan <saravanak@google.com> wrote:
>>
>> On Wed, Aug 4, 2021 at 1:50 AM Marc Zyngier <maz@kernel.org> wrote:
>>>
>>> On Wed, 04 Aug 2021 02:36:45 +0100,
>>> Saravana Kannan <saravanak@google.com> wrote:
>>>
>>> Hi Saravana,
>>>
>>> Thanks for looking into this.
>>
>> You are welcome. I just don't want people to think fw_devlink is broken :)
>>
>>>
>>> [...]
>>>
>>>>> Saravana, could you please have a look from a fw_devlink perspective?
>>>>
>>>> Sigh... I spent several hours looking at this and wrote up an analysis
>>>> and then realized I might be looking at the wrong DT files.
>>>>
>>>> Marc, can you point me to the board file in upstream that corresponds
>>>> to the platform in which you see this issue? I'm not asking for [1],
>>>> but the actual final .dts (not .dtsi) file that corresponds to the
>>>> platform/board/system.
>>>
>>> The platform I can reproduce this on is described in
>>> arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts. It is an
>>> intricate maze of inclusion, node merge and other DT subtleties. I
>>> suggest you look at the decompiled version to get a view of the
>>> result.
>>
>> Thanks. After decompiling it, it looks something like (stripped a
>> bunch of reg and address properties and added the labels back):
>>
>> eth_phy: mdio-multiplexer@4c000 {
>>         compatible = "amlogic,g12a-mdio-mux";
>>         clocks = <0x02 0x13 0x1e 0x02 0xb1>;
>>         clock-names = "pclk\0clkin0\0clkin1";
>>         mdio-parent-bus = <0x22>;
>>
>>         ext_mdio: mdio@0 {
>>                 reg = <0x00>;
>>
>>                 ethernet-phy@0 {
>>                         max-speed = <0x3e8>;
>>                         interrupt-parent = <0x23>;
>>                         interrupts = <0x1a 0x08>;
>>                         phandle = <0x16>;
>>                 };
>>         };
>>
>>         int_mdio: mdio@1 {
>>                 ...
>>         }
>> }
>>
>> And phandle 0x23 refers to the gpio_intc interrupt controller with the
>> modular driver.
>>
>>>> Based on your error messages, it's failing for mdio@0 which
>>>> corresponds to ext_mdio. But none of the board dts files in upstream
>>>> have a compatible property for "ext_mdio". Which means fw_devlink
>>>> _should_ propagate the gpio_intc IRQ dependency all the way up to
>>>> eth_phy.
>>>>
>>>> Also, in the failing case, can you run:
>>>> ls -ld supplier:*
>>>>
>>>> in the /sys/devices/....<something>/ folder that corresponds to the
>>>> "eth_phy: mdio-multiplexer@4c000" DT node and tell me what it shows?
>>>
>>> Here you go:
>>>
>>> root@tiger-roach:~# find /sys/devices/ -name 'supplier*'|grep -i mdio | xargs ls -ld
>>> lrwxrwxrwx 1 root root 0 Aug  4 09:47 /sys/devices/platform/soc/ff600000.bus/ff64c000.mdio-multiplexer/supplier:platform:ff63c000.system-controller:clock-controller -> ../../../../virtual/devlink/platform:ff63c000.system-controller:clock-controller--platform:ff64c000.mdio-multiplexer
>>
>> As we discussed over chat, this was taken after the mdio-multiplexer
>> driver "successfully" probes this device. This will cause
>> SYNC_STATE_ONLY device links created by fw_devlink to be deleted
>> (because they are useless after a device probes). So, this doesn't
>> show the info I was hoping to demonstrate.
>>
>> In any case, one can see that fw_devlink properly created the device
>> link for the clocks dependency. So fw_devlink is parsing this node
>> properly. But it doesn't create a similar probe order enforcing device
>> link between the mdio-multiplexer and the gpio_intc because the
>> dependency is only present in a grand child DT node (ethernet-phy@0
>> under ext_mdio). So fw_devlink is working as intended.
>>
>> I spent several hours squinting at the code/DT yesterday. Here's what
>> is going on and causing the problem:
>>
>> The failing driver in this case is
>> drivers/net/mdio/mdio-mux-meson-g12a.c. And the only DT node it's
>> handling is what I pasted above in this email. In the failure case,
>> the call flow is something like this:
>>
>> g12a_mdio_mux_probe()
>> -> mdio_mux_init()
>> -> of_mdiobus_register(ext_mdio DT node)
>> -> of_mdiobus_register_phy(ext_mdio DT node)
>> -> several calls deep fwnode_mdiobus_phy_device_register(ethernet_phy DT node)
>> -> Tried to get the IRQ listed in ethernet_phy and fails with
>> -EPROBE_DEFER because the IRQ driver isn't loaded yet.
>>
>> The error is propagated correctly all the way up to of_mdiobus_register(), but
>> mdio_mux_init() ignores the -EPROBE_DEFER from of_mdiobus_register() and just
>> continues on with the rest of the stuff and returns success as long as
>> one of the child nodes (in this case int_mdio) succeeds.
>>
>> Since the probe returns 0 without really succeeding, networking stuff
>> just fails badly after this. So, IMO, the real problem is with
>> mdio_mux_init() not propagating up the -EPROBE_DEFER. I gave Marc a
>> quick hack (pasted at the end of this email) to test my theory and he
>> confirmed that it fixes the issue (a few deferred probes later, things
>> work properly).
>>
>> Andrew, I don't see any good reason for mdio_mux_init() not
>> propagating the errors up correctly (at least for EPROBE_DEFER). I'll
>> send a patch to fix this. Please let me know if there's a reason it
>> has to stay as-is.
> 
> I sent out the proper fix as a series:
> https://lore.kernel.org/lkml/20210804214333.927985-1-saravanak@google.com/T/#t

Thanks a lot for digging here and providing the appropriate fixes !

Neil

> 
> Marc, can you give it a shot please?
> 
> -Saravana
> 
>>
>> -Saravana
>>
>> index 110e4ee85785..d973a267151f 100644
>> --- a/drivers/net/mdio/mdio-mux.c
>> +++ b/drivers/net/mdio/mdio-mux.c
>> @@ -170,6 +170,9 @@ int mdio_mux_init(struct device *dev,
>>                                 child_bus_node);
>>                         mdiobus_free(cb->mii_bus);
>>                         devm_kfree(dev, cb);
>> +                       /* Not a final fix. I think it can cause UAF issues. */
>> +                       mdio_mux_uninit(pb);
>> +                       return r;
>>                 } else {
>>                         cb->next = pb->children;
>>                         pb->children = cb;

