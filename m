Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1530D1E93F4
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729350AbgE3Ve5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729083AbgE3Ve5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 17:34:57 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59C4C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 14:34:55 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id t18so7660171wru.6
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 14:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E/9l0YuQtAKyfeMoM9rSoXjbGJSt0Tzhx7PAOO4y/zI=;
        b=SFzmFOM3gVCpRcfg1eWpKCp2LDwQbYQ6mR+NaTgANAz3FqFsGVbHzo9OxEjpfAbmSb
         Al85F+FdXv5mUETYDjvUROWkk3CVvyac4lY9/57y408ysuZIXQjrQVU4hTR8QRbJ23/e
         ENgL28qp//kFOjGCS3vV3eCxMCOHyk7lnwXbSmQnt5rKBFQQiDXH7HuK2WD31iWRRp5c
         iAAxf/wbsNIfm+6KLryP0B33+5ZRibI93+DlvLMwzMM/5rMCZ2NK/5lnhXk9eSvqvsiw
         DL5UkvqfXeT82Y+JwUkM4g/iqPDZMxFDG4BnqieK6NfFtE6QNZdJyAWYWJe+iLNyiafm
         ii5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E/9l0YuQtAKyfeMoM9rSoXjbGJSt0Tzhx7PAOO4y/zI=;
        b=sPLjlkd5e7Y1pFVRcv9LwkHyKGRXqjg0kV6gvU8LFFt5aiRLMcERGRGDCi9c3MpN2K
         y3JH7NRKmiVTNLPmuLVURFZNTAO+4hPo9qWKXrFbEmtVTdGKNokbN1cVWoYWH02Nj67T
         W+Ci3VmwKr8leTUhdRVnVJ9Oola5vpJQxQrLwJuJUkiQWzVSKGg4AMGRy2coKIwdITlw
         ibcncrd2rojG+Isp09Pu/2bsH/ulLGGeMg6evhLFDKCzd7iZPeiDlfyHe/cfeqXCPPJ9
         L2VJNcY5WxpOgElwLAbF1kqUXTQTWu0db06wKwVkHQpvFao1hMwA8isrjEKnaSeXeq46
         Vw0w==
X-Gm-Message-State: AOAM5305Nq5vB3i8DeBZyPJq4c7UL09j9fs5T7qciLJDzR3pn/UVcCEB
        k1UT7qwAsMaeke9vyfloS6E=
X-Google-Smtp-Source: ABdhPJy36laB+Ve6t9RuhxyW5YZmtZRmEeGRsIWmdO0zfYTCuHnxfe4r0G0502O5QDguGqOHm/HD5Q==
X-Received: by 2002:adf:fd48:: with SMTP id h8mr15769116wrs.226.1590874494474;
        Sat, 30 May 2020 14:34:54 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id i3sm15227496wrm.83.2020.05.30.14.34.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 14:34:53 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 05/13] net: mscc: ocelot: convert
 QSYS_SWITCH_PORT_MODE and SYS_PORT_MODE to regfields
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru,
        Mark Brown <broonie@kernel.org>
References: <20200530115142.707415-1-olteanv@gmail.com>
 <20200530115142.707415-6-olteanv@gmail.com>
 <88be2af0-b68d-4eea-bfb4-9a7dd5276df8@gmail.com>
 <CA+h21hpEZchbE_weA_tZm-XW9o9uHU=7TvKhD2ZAYX7e5GootA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <af464691-cf9c-130b-c565-620c0e2ab3fe@gmail.com>
Date:   Sat, 30 May 2020 14:34:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <CA+h21hpEZchbE_weA_tZm-XW9o9uHU=7TvKhD2ZAYX7e5GootA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/2020 2:25 PM, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Sun, 31 May 2020 at 00:18, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 5/30/2020 4:51 AM, Vladimir Oltean wrote:
>>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>>
>>> Currently Felix and Ocelot share the same bit layout in these per-port
>>> registers, but Seville does not. So we need reg_fields for that.
>>>
>>> Actually since these are per-port registers, we need to also specify the
>>> number of ports, and register size per port, and use the regmap API for
>>> multiple ports.
>>>
>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>> ---
>>> Changes in v2:
>>> None.
>>
>> [snip]
>>
>>
>>>       /* Core: Enable port for frame transfer */
>>> -     ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
>>> -                      QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
>>> -                      QSYS_SWITCH_PORT_MODE_PORT_ENA,
>>> -                      QSYS_SWITCH_PORT_MODE, port);
>>> +     ocelot_fields_write(ocelot, port,
>>> +                         QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE, 1);
>>> +     ocelot_fields_write(ocelot, port,
>>> +                         QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
>>
>> I am a bit confused throughout this patch sometimes SCH_NEXT_CFG is set
>> to 1, sometimes not, this makes it a bit harder to review the
>> conversion, assuming this is fine:
>>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>> --
>> Florian
> 
> Yes, this is a subtle point, but it's correct the way it is, and I
> didn't want to insist on the details of it, but now that you mentioned
> it, let's go.
> Seville does not have the QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG register
> field at all. And using the previous API (ocelot_write_rix), we were
> only writing 1 for Felix and Ocelot, which was their hardware-default
> value, so we weren't changing its value in practice. So the equivalent
> with ocelot_fields_write would be to simply not do anything at all for
> the SCH_NEXT_CFG field, which is actually something that is required
> if we want to support Seville too.

OK, thank you for providing these details.
-- 
Florian
