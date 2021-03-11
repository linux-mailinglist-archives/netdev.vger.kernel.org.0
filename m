Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F995336A95
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 04:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhCKDVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 22:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhCKDUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 22:20:35 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A68C061574;
        Wed, 10 Mar 2021 19:20:35 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id q5so108386pgk.5;
        Wed, 10 Mar 2021 19:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jSq/VmwagzBOBa03hMY+8so/zoyaXeG8kRRLRJzJ8nk=;
        b=uumTrVJ45hnIy/cf95GpU7MA5pyBCfjmEDmJpYejNC0Z1j9cKwl0AbhpHoX5XjqV7b
         JTZLciKAgw5DEXkHPOBcXIhjouosdT8l7iPBbAdKmHDw8fANKTRdaQR3GgS4yMI7mEK1
         F7L4rgqIfm1IT4N0bwFMtsx1r9VJcDfkHdlqZqbgdg6FRtQ4J6qHWt49TlhTb/v/RSFT
         7qk/VgA6YoKF4HPN9+pkgCd1ACT+WnQTcIfszMpt4kKDkV2qgS5CTBiII/UONmd2l7lb
         mmA6ScrjQbpyW/N+ppXWF0CV9UH7I2VJ6Rsdb2WilRbWRU3madrg1yA/YArANlu0BjIy
         c/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jSq/VmwagzBOBa03hMY+8so/zoyaXeG8kRRLRJzJ8nk=;
        b=Y6vbeKxg+CUOeUeBAwpQ1cJU9wJgE6Cye4UOzY9dOCX/FhvEbpvw450XQy40bPxfFb
         2w6edul67kICah6FLKdeOu9pbNtiTnhf1L6YJq9B/ou3p5iY0R4CStxTuL5lWEuqTfuJ
         I5o36h1Ob/uow46mmW9+ktl6MYDIcPL8ow6bTvbfBBnbIsi+gD5/xRhJSk2Xadc9Cyou
         cKFNoIQJdnI01QmlQEQp6vZjEZ3QH1clA2IipWjj+T2pK2jsBgW/2sOlfmTnd/JMcQHD
         6WKJAvQyt0E/k0E1vnpmzvr3dfg8tyck/x3vxDIFIFY+Kyc+F+pT7GdhPLdllWSZzTE8
         4o8w==
X-Gm-Message-State: AOAM530XER6jGES7ut8KAcW4qL3Xf8xt/JI8cuJx/Cbi+grffgNBMB3S
        BLkJUuz5FAdY7fz6xqV0PYOV7nG5v/w=
X-Google-Smtp-Source: ABdhPJxgQK9RkpzDwxLk/UFqgLqSvjr0yAQt+fkwlG4zBDNpJDIK/lM6YvMZvupw0+OuWnP1TW56sg==
X-Received: by 2002:a62:3085:0:b029:1ec:a570:682c with SMTP id w127-20020a6230850000b02901eca570682cmr5774827pfw.28.1615432833737;
        Wed, 10 Mar 2021 19:20:33 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a15sm670517pju.34.2021.03.10.19.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 19:20:33 -0800 (PST)
Subject: Re: [PATCH 3/3] net: dsa: mt7530: setup core clock even in TRGMII
 mode
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20210310211420.649985-1-ilya.lipnitskiy@gmail.com>
 <20210310211420.649985-3-ilya.lipnitskiy@gmail.com>
 <20210310231026.lhxakeldngkr7prm@skbuf>
 <CALCv0x0FKVKpVtKsxkq5BwzrSP2SnuYUaK38RHjd_zgoBCpdeA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <169c64ac-c200-fa5d-6563-3be5263d0b99@gmail.com>
Date:   Wed, 10 Mar 2021 19:20:29 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CALCv0x0FKVKpVtKsxkq5BwzrSP2SnuYUaK38RHjd_zgoBCpdeA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/2021 7:17 PM, Ilya Lipnitskiy wrote:
> Hi Vladimir,
> 
> On Wed, Mar 10, 2021 at 3:10 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>>
>> Hello Ilya,
>>
>> On Wed, Mar 10, 2021 at 01:14:20PM -0800, Ilya Lipnitskiy wrote:
>>> 3f9ef7785a9c ("MIPS: ralink: manage low reset lines") made it so mt7530
>>> actually resets the switch on platforms such as mt7621 (where bit 2 is
>>> the reset line for the switch). That exposed an issue where the switch
>>> would not function properly in TRGMII mode after a reset.
>>>
>>> Reconfigure core clock in TRGMII mode to fix the issue.
>>>
>>> Also, disable both core and TRGMII Tx clocks prior to reconfiguring.
>>> Previously, only the core clock was disabled, but not TRGMII Tx clock.
>>>
>>> Tested on Ubiquity ER-X (MT7621) with TRGMII mode enabled.
>>>
>>> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
>>> ---
>>
>> For the networking subsystem there are two git trees, "net" for bugfixes
>> and "net-next" for new features, and we specify the target tree using
>> git send-email --subject-prefix="PATCH net-next".
>>
>> I assume you would like the v5.12 kernel to actually be functional on
>> the Ubiquiti ER-X switch, so I would recommend keeping this patch
>> minimal and splitting it out from the current series, and targeting it
>> towards the "net" tree, which will eventually get merged into one of the
>> v5.12 rc's and then into the final version. The other patches won't go
>> into v5.12 but into v5.13, hence the "next" name.
> I thought I figured it out - now I'm confused. Can you explain why
> https://patchwork.kernel.org/project/netdevbpf/patch/20210311012108.7190-1-ilya.lipnitskiy@gmail.com/
> is marked as supeseded?

That looks like a mistake on the maintainer side, I do not believe that
patch should be Superseded since you just submitted it.
-- 
Florian
