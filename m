Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373FE282E91
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 02:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgJEAp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 20:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgJEAp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 20:45:26 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB01C0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 17:45:26 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id o20so5584645pfp.11
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 17:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZfCvM0LuBUn6L3/rkXI1nPyO1nCP2wxfVU3p8Z/BC/Q=;
        b=OMzigPdB3QapQt6QjiObT9D1Xttv6+uLfLbBTSMO9tsku6YvMYVk+2y96JjT+IZU7f
         ovIgIMKfthn6pQ5TJn8clwfkvumAgRD+NCQmWZBwUMBrRNo1W97ziSRHqq/rLvNcUEAu
         VQCgUSt8RU0TGZHP2aAT1LDNiG9/9AM8EUvb/ULnHzL1wIQABSsYfRVSZnFqPbFevmFW
         t3fpFlMzbTu6Bic+bTyejjZ/3aw+hsbnoqYoEiZZ90faMkfqFK5swPgg5ooc62ipQO2O
         39d1X/bV2aBGleCtM7/o0WMkuP8ioqK97hecEXKgH/KDA1iJq/quBFipreq6d7sthbVE
         3vig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZfCvM0LuBUn6L3/rkXI1nPyO1nCP2wxfVU3p8Z/BC/Q=;
        b=Oux/FjQSB46OwWMkrzqEynM3oPzmeKX82055bVR0/wC3XDVagUsPNNUEH8tQpi4W7e
         lEwmSFMAEGD71amjrDo+/MLNrH6vZF33C7UwgzSvtwJ8KlVxHEOmaDSw9VCoRlCxJtn0
         3ofByCVm3ncDMuX+17o2Glefh4b2/KjO8peheXdLbkXFFzRfaZTFOZaH02qexc990Mo4
         isOWpzXnQP2bTtRsWBp0hAWWmWpcCVWc1anSVNcEppYnyWSfofz+fpjc/QbB6p+YG3ik
         iO/Zwaj3dSxXh4D8dBP5+zk91cQwQ5vyWlgv9sQ8LxvztpWXlpVWPjVe5sOjp+jWLU2p
         FpAQ==
X-Gm-Message-State: AOAM533Aq1mbraZwEKulIoPSBOxWVwBtF+oFybk2ztgMHMiBlYtdKUnE
        PYTQEtdKItmVQ2M6Sp+KExo=
X-Google-Smtp-Source: ABdhPJxLrVmxXgXsKTa1SJDiWwKmuF01p3vAzbm42eKV0ftbDC6X/oDhOwIvHjOOBwfv0TFEkYq6Yw==
X-Received: by 2002:a65:6410:: with SMTP id a16mr2890171pgv.123.1601858725702;
        Sun, 04 Oct 2020 17:45:25 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k24sm9980545pfg.148.2020.10.04.17.45.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Oct 2020 17:45:25 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: propagate switchdev vlan_filtering
 prepare phase to drivers
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
References: <20201002220646.3826555-1-vladimir.oltean@nxp.com>
 <20201004205943.rfblrsivuf47d2m6@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5f93783f-a92e-6c1c-5b4a-20031129771d@gmail.com>
Date:   Sun, 4 Oct 2020 17:45:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201004205943.rfblrsivuf47d2m6@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/2020 1:59 PM, Vladimir Oltean wrote:
> On Sat, Oct 03, 2020 at 01:06:46AM +0300, Vladimir Oltean wrote:
> [...]
>> ---
>> The API for this one was chosen to be different than the one for
>> .port_vlan_add and .port_vlan_prepare because
>> (a) the list of dsa_switch_ops is growing bigger but in this case there
>>      is no justification for it. For example there are some drivers that
>>      don't do anything in .port_vlan_prepare, and likewise, they may not
>>      need to do anything in .port_vlan_filtering_prepare either
>> (b) the DSA API should be as close as possible to the switchdev API
>>      except when there's a strong reason for that not to be the case. In
>>      this situation, I don't see why it would be different.
> 
> I understand that this new function prototype is not to everyone's
> taste?

Just need more time to review, have not looked at it yet.
--
Florian
