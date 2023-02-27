Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6916D6A4C35
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 21:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjB0UYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 15:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjB0UYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 15:24:04 -0500
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E332384E;
        Mon, 27 Feb 2023 12:23:59 -0800 (PST)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-17227cba608so8709748fac.3;
        Mon, 27 Feb 2023 12:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=4AFZ9m2Uo0roC/no8Q0t3rsuUCj3YEMdleppwDbbZ0w=;
        b=CM81SwPHmyUGm/GQeR7qj5jBPrjlR+voIRtCrsnzbrB4S20f1QYqkhPw6wlD4rwCee
         hu0lwmWD5nd99ACC1pmn9zD7Sz0IeJQOk5GdvT3PZHusQX0/DaBdqhh5Ha+5r2P7rMdQ
         C6dNkblhacfdvZ2GNYFNXECQaN0Gnoaqxe8v3nWeIKTeO+gCZThGpwP0SoMb46KV793v
         jzX0FLmtQihCk2wA2R78iRiTOm6LahWIe8mNvreRl++twD2KOsG04rqG/bC6kI47lg8+
         /am2Yf4zMI/Hj1fGNrlO0WRJtn7wT/wUeY0vodFe+nu3S8SLz0twBzrL5KJNaZ2N3rQX
         HpHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4AFZ9m2Uo0roC/no8Q0t3rsuUCj3YEMdleppwDbbZ0w=;
        b=5kIXtEUmbqx9Xe9gWgLWPJVdznCVvX+7RLKFN+DILHkBJc7gCpbj/NzCFxbk0W255q
         Z5gsu7TZdvNz3gdkHtpgXZnIpcTxQZExIQZi+O+5PpnkWE6qtCZNulB7koeyAMKIYy7Y
         akTdRXf5+WiYc7Hdo5sNdk6SK7LN1adcZnxEFyJb8zS45lFNjy4/jtXcy5kg0tnxR1ub
         DicieuwPd48cmRH40RBZO38wxA3CCufq6/eJ3RLvbZTupJ3mjkOR7WfghheMCQTzXD23
         uaFBpzZoiaY8WE3o0vH29B6kLLQSXeAiH6GQ1uujAlfQfPO1OYjfX5gIaJhaC73Wic5X
         17DA==
X-Gm-Message-State: AO0yUKWsP5yKtVJYqArIWsJCKC69aQFDiJCGmk5TgeLlRlbR9TW8bFqI
        ffwmfvf39hFjvVCBtySDvi4=
X-Google-Smtp-Source: AK7set9W6WLCz+dx+ySEZpPGkbpRb5svOjsSEklcRriG8mHuhdKSqyX27vGIsZtNpEXNGPsvKAnRWQ==
X-Received: by 2002:a05:6870:a116:b0:16e:87f:424 with SMTP id m22-20020a056870a11600b0016e087f0424mr19167088oae.47.1677529439164;
        Mon, 27 Feb 2023 12:23:59 -0800 (PST)
Received: from [192.168.1.135] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id h9-20020a4aa289000000b005253a5cc3cfsm3002535ool.29.2023.02.27.12.23.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 12:23:58 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <3d8f28d7-78df-5276-612c-85b5262a987a@lwfinger.net>
Date:   Mon, 27 Feb 2023 14:23:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
To:     Arnd Bergmann <arnd@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Olof Johansson <olof@lixom.net>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20230227133457.431729-1-arnd@kernel.org>
Content-Language: en-US
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20230227133457.431729-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/27/23 07:34, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Based on some recent discussions [1][2][3], I experimented wtih what
> drivers/pcmcia would look like if we completely removed 16-bit support,
> which was one of the options that Dominik suggested for winding down
> pcmcia maintenance.
> 
> The remaining cardbus/yenta support is essentially a PCI hotplug driver
> with a slightly unusual sysfs interface, and it would still support all
> 32-bit cardbus hosts and cards, but no longer work with the even older
> 16-bit cards that require the pcmcia_driver infrastructure.
> 
> I don't expect this to be a problem normal laptop support, as the last
> PC models that predate Cardbus support (e.g. 1997 ThinkPad 380ED) are
> all limited to i586MMX CPUs and 80MB of RAM. This is barely enough to
> boot Tiny Core Linux but not a regular distro.
> 
> Support for device drivers is somewhat less clear. Losing support for
> 16-bit cards in cardbus sockets is obviously a limiting factor for
> anyone who still has those cards, but there is also a good chance that
> the only reason to keep the cards around is for using them in pre-cardbus
> machines that cannot be upgrade to 32-bit devices.
> 
> Completely removing the 16-bit PCMCIA support would however break some
> 20+ year old embedded machines that rely on CompactFlash cards as their
> mass-storage device (extension), this notably includes early PocketPC
> models and the reference implementations for OMAP1, StrongARM1100,
> Alchemy and PA-Semi. All of these are still maintained, though most
> of the PocketPC machines got removed in the 6.3 merge window and the
> PA-Semi Electra board is the only one that was introduced after
> 2003.
> 
> The approach that I take in this series is to split drivers/pcmcia
> into two mutually incompatible parts: the Cardbus support contains
> all the code that is relevant for post-1997 laptops and gets moved
> to drivers/pci/hotplug, while the drivers/pcmcia/ subsystem is
> retained for both the older laptops and the embedded systems but no
> longer works with the yenta socket host driver. The BCM63xx
> PCMCIA/Cardbus host driver appears to be unused and conflicts with
> this series, so it is removed in the process.
> 
> My series does not touch any of the pcmcia_driver instances, but
> if there is consensus about splitting out the cardbus support,
> a lot of them can probably get removed as a follow-up.

Arnd,

Your patch set also breaks my PowerBook G4. The output of 'lspci -nn | grep 
Network' shows the following before your patch is applied:

0001:10:12.0 Network controller [0280]: Broadcom Inc. and subsidiaries BCM4306 
802.11b/g Wireless LAN Controller [14e4:4320] (rev 03)
0001:11:00.0 Network controller [0280]: Broadcom Inc. and subsidiaries BCM4318 
[AirForce One 54g] 802.11g Wireless LAN Controller [14e4:4318] (rev 02)

The first of these is broken and built into the laptop. The second is plugged 
into a PCMCIA slot, and uses yenta-socket as a driver.

When your patches are applied, the second entry vanishes.

Yes, this hardware is ancient, but I would prefer having this wifi interface 
work. I can provide any output you need.

Larry


