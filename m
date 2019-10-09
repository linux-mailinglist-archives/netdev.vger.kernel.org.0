Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 673ECD0EA8
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 14:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731096AbfJIMZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 08:25:29 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51015 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730861AbfJIMZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 08:25:28 -0400
Received: by mail-wm1-f68.google.com with SMTP id 5so2360281wmg.0;
        Wed, 09 Oct 2019 05:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Nua5OwsPnbNn30zwIcxj0beDs8kg/5lbLMEpadI7ppk=;
        b=uP1ipqzGDpN1R6Nms0UCBk1psp927dNjLCNGdZSxCo+8XEWhWNKOBg2RDaDB96DfJf
         4UcrqRQT1wSnZsimngeyACcA8nV1/CnBjndXcc4tYxxKeVv8luxk3yXgeJivxXsjHyRT
         6S0xgVerM2OXSriKBG6ds8XFggKkZ40+NU22lk2cyO/7EKYS2JND/BHaH/4zOSfaR/Xe
         Sf1UL9AAASTFnrPT9ivMJspyLF+L27cDatMKG9wUnfTnaCzmsoFqJWnaCF7DzEbMi1Fx
         tujQZcAddlMeuvOamIWxHm4Ew+uJWu23j/EQDkTUPcJE/DIqfSQ64EU5Z5JC/pg94v/c
         dq6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nua5OwsPnbNn30zwIcxj0beDs8kg/5lbLMEpadI7ppk=;
        b=Rx59OopVrgZwKGy3RH0geJDQYRB7cPZhN/fwClAzAKxotaRgr64guOQERFdcbcomuE
         PRT78GPGHfmi4Rv0JNLxVniE96u83HvGwtB0S6tXdeMEhmzzIAcEM4hhm/7MJd2aP7Ik
         VmRIwEYmC+v7NRpo2sTyr0bMPSdPq/vjRzx9jOaJN9pjU+ECvAMZtrslIApuTJ8bCxM4
         BcWpFRX+Jnk7dIApY7o4N+dhG1q9H6rNwdtObM76zvNndkdbrlA0v+lhvIw5F305iwAk
         jIcI6h3074UEulRFZJa0gkmhbvB+a4tZrqr0FP6i2Uqt2pvoX2NkPAWBWT9EzRqoVDii
         4+NQ==
X-Gm-Message-State: APjAAAVbc05YkRp8Yh+g1uiKlVpTICm7PvrnQAAy+aI7pNo8z2LEC0EP
        EYytKombXMvmmyH/vKsio1Og/6grfiU=
X-Google-Smtp-Source: APXvYqz5OSnwj4duPROK4v5pcFuX2jdZ4kqAmKthfByNi0LQaLJaPXjjt0a4ls1yw/qM1y0+vza2EA==
X-Received: by 2002:a1c:3908:: with SMTP id g8mr2311817wma.34.1570623925358;
        Wed, 09 Oct 2019 05:25:25 -0700 (PDT)
Received: from [192.168.1.35] (46.red-83-42-66.dynamicip.rima-tde.net. [83.42.66.46])
        by smtp.gmail.com with ESMTPSA id c17sm2807618wrc.60.2019.10.09.05.25.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 05:25:24 -0700 (PDT)
Subject: Re: [PATCH v8 2/5] MIPS: PCI: use information from 1-wire PROM for
 IOC3 detection
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
References: <20191009101713.12238-1-tbogendoerfer@suse.de>
 <20191009101713.12238-3-tbogendoerfer@suse.de>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <ea44d4a2-3011-fba8-4d6a-7b63c77ba00a@amsat.org>
Date:   Wed, 9 Oct 2019 14:25:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191009101713.12238-3-tbogendoerfer@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/19 12:17 PM, Thomas Bogendoerfer wrote:
> IOC3 chips in SGI system are conntected to a bridge ASIC, which has

Typo: "connected".

> a 1-wire prom attached with part number information. This changeset
> uses this information to create PCI subsystem information, which
> the MFD driver uses for further platform device setup.
> 
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> ---
>   arch/mips/include/asm/pci/bridge.h |   1 +
>   arch/mips/include/asm/sn/ioc3.h    |   9 +++
>   arch/mips/pci/pci-xtalk-bridge.c   | 135 ++++++++++++++++++++++++++++++++++++-
>   arch/mips/sgi-ip27/ip27-xtalk.c    |  38 +++++++++--
>   4 files changed, 175 insertions(+), 8 deletions(-)
