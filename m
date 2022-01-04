Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6AC483BBE
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 06:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiADFrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 00:47:37 -0500
Received: from marcansoft.com ([212.63.210.85]:48898 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230181AbiADFrh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 00:47:37 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id CF9BA419BC;
        Tue,  4 Jan 2022 05:47:25 +0000 (UTC)
Message-ID: <4cbafb7b-cdde-8555-40d3-f37e998c7e64@marcan.st>
Date:   Tue, 4 Jan 2022 14:47:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH 01/34] dt-bindings: net: bcm4329-fmac: Add Apple
 properties & chips
Content-Language: en-US
To:     Mark Kettenis <mark.kettenis@xs4all.nl>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, rafael@kernel.org, lenb@kernel.org,
        aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, sven@svenpeter.dev, alyssa@rosenzweig.io,
        kettenis@openbsd.org, zajec5@gmail.com,
        pieter-paul.giesberts@broadcom.com, linus.walleij@linaro.org,
        hdegoede@redhat.com, linville@tuxdriver.com,
        sandals@crustytoothpaste.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-2-marcan@marcan.st>
 <d3cb7b3782b16029@bloch.sibelius.xs4all.nl>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <d3cb7b3782b16029@bloch.sibelius.xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/12/30 1:42, Mark Kettenis wrote:
>> From: Hector Martin <marcan@marcan.st>
>> Cc: Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
>>         Alyssa Rosenzweig <alyssa@rosenzweig.io>,
>>         Mark Kettenis <kettenis@openbsd.org>,
>>         Rafał Miłecki <zajec5@gmail.com>,
>>         Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
>>         Linus Walleij <linus.walleij@linaro.org>,
>>         Hans de Goede <hdegoede@redhat.com>,
>>         "John W. Linville" <linville@tuxdriver.com>,
>>         "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
>>         "brian m. carlson" <sandals@crustytoothpaste.net>,
>>         linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
>>         devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
>>         linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
>>         SHA-cyfmac-dev-list@infineon.com
>> Date: Mon, 27 Dec 2021 00:35:51 +0900
>>
>> This binding is currently used for SDIO devices, but these chips are
>> also used as PCIe devices on DT platforms and may be represented in the
>> DT. Re-use the existing binding and add chip compatibles used by Apple
>> T2 and M1 platforms (the T2 ones are not known to be used in DT
>> platforms, but we might as well document them).
>>
>> Then, add properties required for firmware selection and calibration on
>> M1 machines.
>>
>> Signed-off-by: Hector Martin <marcan@marcan.st>
>> ---
>>  .../net/wireless/brcm,bcm4329-fmac.yaml       | 32 +++++++++++++++++--
>>  1 file changed, 29 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
>> index c11f23b20c4c..2530ff3e7b90 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
>> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
>> @@ -4,7 +4,7 @@
>>  $id: http://devicetree.org/schemas/net/wireless/brcm,bcm4329-fmac.yaml#
>>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>>  
>> -title: Broadcom BCM4329 family fullmac wireless SDIO devices
>> +title: Broadcom BCM4329 family fullmac wireless SDIO/PCIE devices
>>  
>>  maintainers:
>>    - Arend van Spriel <arend@broadcom.com>
>> @@ -36,16 +36,22 @@ properties:
>>                - brcm,bcm43455-fmac
>>                - brcm,bcm43456-fmac
>>                - brcm,bcm4354-fmac
>> +              - brcm,bcm4355c1-fmac
>>                - brcm,bcm4356-fmac
>>                - brcm,bcm4359-fmac
>> +              - brcm,bcm4364b2-fmac
>> +              - brcm,bcm4364b3-fmac
>> +              - brcm,bcm4377b3-fmac
>> +              - brcm,bcm4378b1-fmac
>> +              - brcm,bcm4387c2-fmac
>>                - cypress,cyw4373-fmac
>>                - cypress,cyw43012-fmac
>>            - const: brcm,bcm4329-fmac
>>        - const: brcm,bcm4329-fmac
> 
> I suppose this helps with validation of device trees.  However, nodes
> for PCI devices are not supposed to have a "compatible" property as
> the PCI vendor and device IDs are supposed to be used to identify a
> device.
> 
> That does raise the question how a schema for additional properties
> for PCI device nodes is supposed to be defined...

Apparently using a "pciVVVV,DDDD" compatible is one way, see
bindings/net/wireless/qca,ath9k.yaml

There's apparently exactly one example of this in in-tree devicetrees:
boot/dts/rockchip/rk3399-gru-chromebook.dtsi

I guess this is the way to go then, unless Rob has a different idea :)

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
