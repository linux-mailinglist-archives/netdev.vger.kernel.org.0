Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739ED3AFD5D
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhFVGxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbhFVGxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 02:53:03 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CFAC061766;
        Mon, 21 Jun 2021 23:50:40 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id h2so8642073edt.3;
        Mon, 21 Jun 2021 23:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sUk1868MFewOTqTLUNq+R1n4zgGVTR/SfxekZkseJWg=;
        b=eJkqcAt/WPzmJ+r5wuDJsnuwdHhavxZ6Wn1lhPFVVa0NXNfLKJiru3KV2tkW9l5E3O
         kWITIz5u3ZjwSy+nUsTY9Is0dKvvrePmjicWByZOxuzFHcTDH7sZijr1zSfqcQsa4UwT
         7vB1PAXW+RwHmmk+nZWRm9feJtcE6Enez47IJp9dJ6pjFovesw15g4olaHZSLEc1VxyU
         xlMeBFpKiRhkPCOzR1KPBz4DS7I3luFxE2ZFRYzbuNKkGwtQ4F0vjlCTZW0NoD+dlW8N
         00qXaeqPQP6vJZ/Wwrz7EkDlFqQo9uxMVazSYBUZazrzVR2MtIZvMS7HOjTqOXxRGHfo
         uKpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sUk1868MFewOTqTLUNq+R1n4zgGVTR/SfxekZkseJWg=;
        b=aDvmCMGs9mpVOGwm4rw/qNYtcQxADQZHqBNiVRmclykbdLhL+5lY26brRkw4d3VK+4
         oJGVzNZsBvRu7RfFdpWBS1sCP5x7GRvm5uH5dAo/HAPJwAT9e22/qTyb9uioDttDJ1Zz
         SthX+0N/x5qTjONMw+RmE7UkntrfeU6lUdMpdEWzRt7GU3M9W/PtuEAqhe7FQwIM7hdL
         xd4GCdkH5Onc1DewhfcT3vGqYi4bO3tY/A2FxOsDVHYnHm/mVK+2p2WaSj0kdsG6duWz
         JpWgF+zXZ70lILuNsACXRQQ0/Kk++Iuabb0TTYprmnB2OI311JXWVqOBNuuLvfpLsjJ7
         LonQ==
X-Gm-Message-State: AOAM533vVNesdPn17oqsNnfWyYM8EV703VAToO+BVzKEUuWJbU9DxV08
        PGnAVi/SXE94j42h4rEP23A=
X-Google-Smtp-Source: ABdhPJyB7jZvmPHW59kMbnD6MORLGetYyjn1muuo/ZQf1bs/pSCDy/rnIiSgm7RhHhdwufhVKls5ew==
X-Received: by 2002:aa7:d3c2:: with SMTP id o2mr2877832edr.358.1624344638797;
        Mon, 21 Jun 2021 23:50:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:3800:e1de:e923:2b2e:5f57? (p200300ea8f293800e1dee9232b2e5f57.dip0.t-ipconnect.de. [2003:ea:8f29:3800:e1de:e923:2b2e:5f57])
        by smtp.googlemail.com with ESMTPSA id t18sm6890627eds.86.2021.06.21.23.50.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 23:50:38 -0700 (PDT)
Subject: Re: [PATCH] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
To:     Jian-Hong Pan <jhp@endlessos.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Peter Robinson <pbrobinson@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Doug Berger <opendmb@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux@endlessos.org, bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org
References: <20210621103310.186334-1-jhp@endlessos.org>
 <YNCPcmEPuwdwoLto@lunn.ch> <35f4baae-a6e1-c87d-279c-74f8c18bb5d1@gmail.com>
 <CALeDE9MjRLjTQ1R2nw_rnXsCXKHLMx8XqvG881xgqKz2aJRGfA@mail.gmail.com>
 <9c0ae9ad-0162-42d9-c4f8-f98f6333b45a@i2se.com>
 <745e7a21-d189-39d7-504a-bdae58cfb8ad@gmail.com>
 <CAPpJ_ed+8fP8y_t983pb0LMHK9pfVtGdh7fQopedqGZJCrRxvQ@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <9a1e425b-af8c-9385-a226-35f2092554ae@gmail.com>
Date:   Tue, 22 Jun 2021 08:50:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAPpJ_ed+8fP8y_t983pb0LMHK9pfVtGdh7fQopedqGZJCrRxvQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.06.2021 08:29, Jian-Hong Pan wrote:
> Florian Fainelli <f.fainelli@gmail.com> 於 2021年6月22日 週二 上午5:47寫道：
>>
>> On 6/21/21 1:15 PM, Stefan Wahren wrote:
>>> Am 21.06.21 um 18:56 schrieb Peter Robinson:
>>>> On Mon, Jun 21, 2021 at 5:39 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>>>> On 6/21/21 6:09 AM, Andrew Lunn wrote:
>>>>>> On Mon, Jun 21, 2021 at 06:33:11PM +0800, Jian-Hong Pan wrote:
>>>>>>> The Broadcom UniMAC MDIO bus comes too late. So, GENET cannot find the
>>>>>>> ethernet PHY on UniMAC MDIO bus. This leads GENET fail to attach the
>>>>>>> PHY.
>>>>>>>
>>>>>>> bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
>>>>>>> ...
>>>>>>> could not attach to PHY
>>>>>>> bcmgenet fd580000.ethernet eth0: failed to connect to PHY
>>>>>>> uart-pl011 fe201000.serial: no DMA platform data
>>>>>>> libphy: bcmgenet MII bus: probed
>>>>>>> ...
>>>>>>> unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus
>>>>>>>
>>>>>>> This patch makes GENET try to connect the PHY up to 3 times. Also, waits
>>>>>>> a while between each time for mdio-bcm-unimac module's loading and
>>>>>>> probing.
>>>>>> Don't loop. Return -EPROBE_DEFER. The driver core will then probed the
>>>>>> driver again later, by which time, the MDIO bus driver should of
>>>>>> probed.
>>>>> This is unlikely to work because GENET register the mdio-bcm-unimac
>>>>> platform device so we will likely run into a chicken and egg problem,
>>>>> though surprisingly I have not seen this on STB platforms where GENET is
>>>>> used, I will try building everything as a module like you do. Can you
>>>>> see if the following helps:
>>>> For reference we have mdio_bcm_unimac/genet both built as modules in
>>>> Fedora and I've not seen this issue reported using vanilla upstream
>>>> kernels if that's a useful reference point.
>>>
>>> I was also unable to reproduce this issue, but it seems to be a known
>>> issue [1], [2].
>>>
>>> Jian-Hong opened an issue in my Github repo [3], but before the issue
>>> was narrowed down, he decided to send this workaround.
>>
>> The comment about changing the phy-mode property is not quite making
>> sense to me, except if that means that in one case the Broadcom PHY
>> driver is used and in the other case the Generic PHY driver is used.
>>
>> What is not clear to me from the debugging that has been done so far is
>> whether the mdio-bcm-unimac MDIO controller was not loaded at the time
>> of_phy_connect() was trying to identify the PHY device.
> 
> MODULE_SOFTDEP("pre: mdio-bcm-unimac")  mentioned in the comment [1]
> solves this issue.
> 
> Tracing the code by following the debug message in comment #2 [2], I
> learned the path bcmgenet_mii_probe()'s of_phy_connect() ->
> of_phy_find_device() -> of_mdio_find_device() ->
> bus_find_device_by_of_node().  And, bus_find_device_by_of_node()
> cannot find the device on the mdio bus.
> 
> So, I traced bcm2711-rpi-4-b's device tree to find out which one is
> the mdio device and why it has not been prepared ready on the mdio bus
> for genet.
> Then, I found out it is mdio-bcm-unimac module as mentioned in comment
> #4 [3].  Also, noticed "unimac-mdio unimac-mdio.-19: Broadcom UniMAC
> MDIO bus" comes after "bcmgenet fd580000.ethernet eth0: failed to
> connect to PHY" in the log.
> 
> With these findings, I try to re-modprobe genet module again.  The
> ethernet on RPi 4B works correctly!  Also, noticed mdio-bcm-unimac
> module is loaded before I re-modprobe genet module.
> Therefore, I try to make mdio-bcm-unimac built in kernel image,
> instead of a module.  Then, genet always can find the mdio device on
> the bus and the ethernet works as well.
> 
> Consequently, the idea, loading mdio-bcm-unimac module earlier than
> genet module comes in my head!  However, I don't know the key word
> "MODULE_SOFTDEP" until Florian's guide.  That is why I have a loop to
> connect the PHY in the original patch.  But, I understand
> MODULE_SOFTDEP is a better solution now!
> 
> I think this is like the module loading order situation mentioned in
> commit 11287b693d03 ("r8169: load Realtek PHY driver module before
> r8169") [4].
> 
The reason in r8169 is different. When people add r8169 module to
initramfs but not the Realtek PHY driver module then loading
r8169 will fail. The MODULE_SOFTDEP is a hint to tools building
initramfs.

> [1] https://bugzilla.kernel.org/show_bug.cgi?id=213485#c6
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=213485#c2
> [3] https://bugzilla.kernel.org/show_bug.cgi?id=213485#c4
> [4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=11287b693d03830010356339e4ceddf47dee34fa
> 
> Jian-Hong Pan
> 

