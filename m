Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A693EC5E0
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 01:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbhHNXBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 19:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbhHNXBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 19:01:33 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89DAC061764;
        Sat, 14 Aug 2021 16:01:03 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v4so11133696wro.12;
        Sat, 14 Aug 2021 16:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F0KrfeTE+tsg/Qt+4vIwCwCUxCe3RnVdvTIxQapRRBU=;
        b=dMdPvC8p2JeXHOlEzWT/VBfYLBlZKoYgwJhgSXighky301sWWQsPXh5thWDg+Sm6ea
         G08zrwGJgxzNZ7gXPF+YLZRtaELWm+CLu4JjTAJ+dNgR1oT6ukDWxZRGiDC0u4vhZf/V
         bVF/jBgrLNGSog4aAWBMHjfVuWQLO9kkHGbd5t0BedekIbc5xbA5i/5gdVlDNbBf2uV7
         A2bNzEmsYRrt1tf5PsGy7cPup7dOPwksn7Vu3O9Ud9s1+I/80NI9UCTod2fYY3jfDBf7
         oVAm79i3br3F0gDXKpPDTh90KWn7I4ZZZsXHDl5sqMV3oPcBVEa4yZgqklN4veV4ffFo
         oO0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F0KrfeTE+tsg/Qt+4vIwCwCUxCe3RnVdvTIxQapRRBU=;
        b=Trb9zc6XcLxs00I+Mfvavkrj63p+0iDJL5b2bDCOVQ4B4eJb1z6myyHuarfgjzsAtf
         eoHkGI0/elNl5tk+XA905cl7mPFf4nKN7BTR3z0+M+ukF0NjywcIhkZToGCmp6Wy4VML
         FN5xl+JAkYz0LPSGGd93lPhyxp+frrSLArPW3NQCg2gs2RcGL4gPWWmRrBOiPrQb4arD
         hdxkfRhF6eihlNB3YjZ/w8uyO+A8ob/LKFt+z8USUZz82S8MF/6FsFns5GQcgGTkTkOT
         6lW1w8viZMNPR+g/786QSb/0iNRKZrPPGPubtTAXZDIcRm1geGNfEF5+NPv0wiNDn0un
         HzMg==
X-Gm-Message-State: AOAM532MCpoEBrpns2vFYGgVnobhSK6HzF8VZNq7x8Zaku22ic1TmS2R
        NIWg3AdaCFA4iDhyaoz5xvHYUz2nA2tALg==
X-Google-Smtp-Source: ABdhPJz3K5FR014vEjskeLkNH0rB3s1UkF7tzTsyIhxf4LsVJMg2leVTehwZ/aSo9PSoc4VeSg1l2g==
X-Received: by 2002:adf:df0c:: with SMTP id y12mr10222584wrl.155.1628982062215;
        Sat, 14 Aug 2021 16:01:02 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:1df:469f:59ab:ca40? (p200300ea8f10c20001df469f59abca40.dip0.t-ipconnect.de. [2003:ea:8f10:c200:1df:469f:59ab:ca40])
        by smtp.googlemail.com with ESMTPSA id t14sm5998262wmj.2.2021.08.14.16.00.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Aug 2021 16:01:01 -0700 (PDT)
To:     David Bauer <mail@david-bauer.net>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, Pavel Machek <pavel@ucw.cz>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
References: <20210814181107.138992-1-mail@david-bauer.net>
 <74795336-e3fa-422f-0004-a8cb180d84bc@gmail.com>
 <96f1d554-647b-fc75-8c5c-60bc20d79c80@david-bauer.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: net: add RTL8152 binding documentation
Message-ID: <7a6e07fa-3eaf-8604-f788-2a0f58b88cf3@gmail.com>
Date:   Sun, 15 Aug 2021 01:00:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <96f1d554-647b-fc75-8c5c-60bc20d79c80@david-bauer.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.08.2021 00:26, David Bauer wrote:
> Hi Heiner,
> 
> On 8/14/21 8:33 PM, Heiner Kallweit wrote:
>> On 14.08.2021 20:11, David Bauer wrote:
>>> Add binding documentation for the Realtek RTL8152 / RTL8153 USB ethernet
>>> adapters.
>>>
>>> Signed-off-by: David Bauer <mail@david-bauer.net>
>>> ---
>>>   .../bindings/net/realtek,rtl8152.yaml         | 43 +++++++++++++++++++
>>>   1 file changed, 43 insertions(+)
>>>   create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl8152.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/realtek,rtl8152.yaml b/Documentation/devicetree/bindings/net/realtek,rtl8152.yaml
>>> new file mode 100644
>>> index 000000000000..ab760000b3a6
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/net/realtek,rtl8152.yaml
>>> @@ -0,0 +1,43 @@
>>> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/net/realtek,rtl8152.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: Realtek RTL8152/RTL8153 series USB ethernet
>>> +
>>> +maintainers:
>>> +  - David Bauer <mail@david-bauer.net>
>>> +
>>> +properties:
>>> +  compatible:
>>> +    oneOf:
>>> +      - items:
>>> +          - enum:
>>> +              - realtek,rtl8152
>>> +              - realtek,rtl8153
>>> +
>>> +  reg:
>>> +    description: The device number on the USB bus
>>> +
>>> +  realtek,led-data:
>>> +    $ref: /schemas/types.yaml#/definitions/uint32
>>> +    description: Value to be written to the LED configuration register.
>>> +
>>
>> +Pavel as LED subsystem maintainer
>>
>> There's an ongoing discussion (with certain decisions taken already) about
>> how to configure network device LEDs.
> 
> Thanks, I didn't knew about this.
> 
> Is there any place where i can read up specifics about
> this topic?
> 

A recent mail thread about network device LEDs is here:
https://lore.kernel.org/netdev/20210716212427.821834-6-anthony.l.nguyen@intel.com/

To cut a long story short:
LED subsystem maintainer has ideas how a unified solution could like,
and he has some work-in-progress patches. And some statements exist
how not to do it and what to avoid. But there's still some open
issues, therefore no solution is available yet. It's not really clear
how to go on with network device LED support in the meantime.

> Best
> David
> 
Heiner

>>
>>> +required:
>>> +  - compatible
>>> +  - reg
>>> +
>>> +examples:
>>> +  - |
>>> +    usb@100 {
>>> +      reg = <0x100 0x100>;
>>> +      #address-cells = <1>;
>>> +      #size-cells = <0>;
>>> +
>>> +      usb-eth@2 {
>>> +        compatible = "realtek,rtl8153";
>>> +        reg = <0x2>;
>>> +        realtek,led-data = <0x87>;
>>> +      };
>>> +    };
>>>
>>

