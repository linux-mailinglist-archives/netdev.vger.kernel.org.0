Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC24D5822
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 22:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbfJMUl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 16:41:28 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46514 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfJMUl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 16:41:28 -0400
Received: by mail-pf1-f195.google.com with SMTP id q5so9157228pfg.13
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 13:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DMfG+ifpYMcUvdJ17kTYbqrGbVlpdmKOjFF1QItpK04=;
        b=XvdrQD2GMYZV6qNQPqZFUoGtvFi3QmkrWrbg3fwIA13Sn//jxTIWDmBiZpbBVdfZwx
         r/WuXd7E9kbGf3AdOSMMDWX0XSWHrwwqyAlx1TNQ4+gK3SVLfu4PTodwypkrW7Sy5pqS
         rb8rQxEBuV7s81RzcSIGMWxsO3oFigE2cY7f44F2Vld8su4NalSyjZ4Y2ZEqUSoV2ngh
         zEeL7E4D16DrsMCCVco74SuWgp9DsBp2pMysLm77qG4DoH4pjBmbAh8xXMoViasKt9aP
         4vrDZxx9TH7hs/LowUqgGEp9eGHLCim0LreHFhQC8ASLWgWEIoHgTnMeGFgL5+L2aujA
         azTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DMfG+ifpYMcUvdJ17kTYbqrGbVlpdmKOjFF1QItpK04=;
        b=nJCjSAhtvhK0AE32wQeWV13i+qyhDbGdD98BeLGuAvyqzINlXtbwAYJSsP9eKnfYlu
         9X1YNX1BLpqOJ0CE+Ewzb4spZZulaAWUlz3jKny2FWP/siJdZBhWislStnB9+3vqOfQA
         wR8gNlKs2gjeCkszgJs0MS83kb0htQVRe1msRbJH5fUD1jaqCUoR0Uhc7FtEfeERRObm
         1CMk8J89JIdHAmQ+uOru41B1ZiJREUdRIAHNeDEqz9Vb/6IE67b5Kt4T2YkLX/Mkg3Dl
         2epLfa0G66D/YJ092y4Vkl168Bp8zy511UNBBFDo3M5bpacMragTfnJk4I/md6Q0PT/Z
         7psA==
X-Gm-Message-State: APjAAAUIPMHxZuZb0Me+UUMpnCEh8r/dNqicI8OkBxZ6QzwKR2+NseZT
        24JedxMJH05ZQRZILB/PzMs=
X-Google-Smtp-Source: APXvYqxmTrt5wLEE8GcGrhRHuxnV4HZ9ZDzLfpmqcgayVwmrEiNHGjj05iUOslzA6AOrSkL+fpqK9Q==
X-Received: by 2002:a63:c446:: with SMTP id m6mr15107278pgg.136.1570999287241;
        Sun, 13 Oct 2019 13:41:27 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id m26sm25667924pgn.71.2019.10.13.13.41.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Oct 2019 13:41:26 -0700 (PDT)
Subject: Re: [PATCH V3 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs
To:     Marek Vasut <marex@denx.de>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        George McCollister <george.mccollister@gmail.com>,
        Sean Nyekjaer <sean.nyekjaer@prevas.dk>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
References: <20191013193403.1921-1-marex@denx.de>
 <61012315-cbe0-c738-2e8d-0080ec382af9@gmail.com>
 <174ba346-b87d-d928-5ef2-59287d5280be@denx.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f8038c1e-35f2-4944-5802-8f7b8e3936f7@gmail.com>
Date:   Sun, 13 Oct 2019 13:41:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <174ba346-b87d-d928-5ef2-59287d5280be@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/2019 1:29 PM, Marek Vasut wrote:
> On 10/13/19 10:15 PM, Heiner Kallweit wrote:
>> On 13.10.2019 21:34, Marek Vasut wrote:
>>> The KSZ8051 PHY and the KSZ8794/KSZ8795/KSZ8765 switch share exactly the
>>> same PHY ID. Since KSZ8051 is higher in the ksphy_driver[] list of PHYs
>>> in the micrel PHY driver, it is used even with the KSZ87xx switch. This
>>> is wrong, since the KSZ8051 configures registers of the PHY which are
>>> not present on the simplified KSZ87xx switch PHYs and misconfigures
>>> other registers of the KSZ87xx switch PHYs.
>>>
>>> Fortunatelly, it is possible to tell apart the KSZ8051 PHY from the
>>> KSZ87xx switch by checking the Basic Status register Bit 0, which is
>>> read-only and indicates presence of the Extended Capability Registers.
>>> The KSZ8051 PHY has those registers while the KSZ87xx switch does not.
>>>
>>> This patch implements simple check for the presence of this bit for
>>> both the KSZ8051 PHY and KSZ87xx switch, to let both use the correct
>>> PHY driver instance.
>>>
>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>> Cc: Andrew Lunn <andrew@lunn.ch>
>>> Cc: David S. Miller <davem@davemloft.net>
>>> Cc: Florian Fainelli <f.fainelli@gmail.com>
>>> Cc: George McCollister <george.mccollister@gmail.com>
>>> Cc: Heiner Kallweit <hkallweit1@gmail.com>
>>> Cc: Sean Nyekjaer <sean.nyekjaer@prevas.dk>
>>> Cc: Tristram Ha <Tristram.Ha@microchip.com>
>>> Cc: Woojung Huh <woojung.huh@microchip.com>
>>> Fixes: 9d162ed69f51 ("net: phy: micrel: add support for KSZ8795")
>>
>> The Fixes tag has to be the first one. And patch still misses
>> the "net" annotation. For an example just see other fix submissions
>> on the mailing list.
> 
> The "net" annotation ? The net: tag is right there in the subject.
> 

It is missing from within the [PATCH] part of the subject, so it should
be [PATCH net] for the net tree (bugfixes) or [PATCH net-next] for
features (broadly speaking). This is explained in the netdev-FAQ that
Heiner pointed out previously:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/netdev-FAQ.rst#n94
-- 
Florian
