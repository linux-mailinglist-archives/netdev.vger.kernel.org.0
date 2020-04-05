Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C63419E83E
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 03:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgDEB2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 21:28:44 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:56479 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbgDEB2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 21:28:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id B56BA77E;
        Sat,  4 Apr 2020 21:28:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 04 Apr 2020 21:28:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alistair23.me;
         h=subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm3; bh=n
        2xIAo0j6M7nb0dEky/Y1uh63ap0cnK6/HZ2kEdFDLc=; b=bjyhRyLW6TkbdYrIT
        vUuAujP2aC+R4Ld/oiSrmwXb7zKyUU+CzVq7C9X0MnhHjNjwDermHYis9yxtLTaH
        QqqNrpXHw4HakKxmMZTsxpKmAgDK/VnyEzzHTI0Jz0rWXba0+WSOJL4s7S7Cd9yo
        lwjpR5AzMtaRfNuDSzmuXp6XAINPc66pllL7rc7tMuSpYXEpOPvb+4y96J+Cqz0t
        U6bbalrnOQYrBQXrr0OnQZ+28zOo9bIf1BlkMl49+8ijYCfvjkd9HwcPxZj4cCNo
        srvx85BpXozrHD+ySA3TQzrQGdOTv9hEsF3UPW4rw4RUELdeyPnIBmI4Pnan57j3
        jJq1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=n2xIAo0j6M7nb0dEky/Y1uh63ap0cnK6/HZ2kEdFD
        Lc=; b=ZsrE0sTaJdipkfWayfTn/Odu3KKEs9rJzdcqhPV9ZZI1VGLt/AF8r8CRK
        bS1Nndrx2Ytql/AiMetktDQx+vEw9kH+E9xbZI/Of0LHWbAIfB3KtQduOGT25eQO
        qrU6ADdLhngl9NLIFjAz+UPcIFITjIB3PkWweuJO/mEB3cpNNkWaII8QqaMbuvPp
        iHnbW0THBzWa8LDRFW8zSW9xag2LlY6Rm5C2FAFqjyzMuNE3VV47Zqf8ZeoeJ0x9
        bltlcT8G6MmTB7gP2W4UnCEVwC4Dsd0lLgS/VL4dQ87AzhJYcFFADRmMKtqxQO4d
        /Ob4XmXxwBlgdJ8EvJlp2UawreuDw==
X-ME-Sender: <xms:QDSJXjEb877FyG7AHZc1lKPIIqbFZRYz1je44IgtEdcur3NfMJxQHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdelgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpeetlhhishht
    rghirhcuhfhrrghntghishcuoegrlhhishhtrghirhesrghlihhsthgrihhrvdefrdhmvg
    eqnecuffhomhgrihhnpeguvghvihgtvghtrhgvvgdrohhrghdpkhgvrhhnvghlrdhorhhg
    necukfhppeejfedrleefrdekgedrvddtkeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpegrlhhishhtrghirhesrghlihhsthgrihhrvdefrdhm
    vg
X-ME-Proxy: <xmx:QDSJXkThRhWHG37yvqbflKUZBbfteEWEAdDrfvj6BRPy6MlMshCkfA>
    <xmx:QDSJXtpB_qhggbuHYvsnJo69gSrWO9Ctjpc2jlk9GQLO5QXg_aC-0A>
    <xmx:QDSJXqr2P5Ziiou5nISNn3sil8deBdqZEa_X_AFrDgCSnAiNGHkCig>
    <xmx:SjSJXlPdDvXlZV2ZYnnevXNXVMk282B0iJzelzATqdVRpOLBl53rcrrlZb4>
Received: from [172.16.1.131] (c-73-93-84-208.hsd1.ca.comcast.net [73.93.84.208])
        by mail.messagingengine.com (Postfix) with ESMTPA id CA5033280066;
        Sat,  4 Apr 2020 21:28:30 -0400 (EDT)
Subject: Re: [PATCH 1/3] dt-bindings: net: bluetooth: Add rtl8723bs-bluetooth
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     alistair23@gmail.com, anarsoul@gmail.com,
        devicetree@vger.kernel.org, johan.hedberg@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, mripard@kernel.org, netdev@vger.kernel.org,
        wens@csie.org, max.chou@realtek.com, hdegoede@redhat.com
References: <20200404204850.405050-1-alistair@alistair23.me>
 <20200404224205.1643238-1-martin.blumenstingl@googlemail.com>
From:   Alistair Francis <alistair@alistair23.me>
Message-ID: <46b0f1dc-15df-55d5-1a9c-cb70a7d453ad@alistair23.me>
Date:   Sat, 4 Apr 2020 18:28:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200404224205.1643238-1-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/04/2020 3:42 pm, Martin Blumenstingl wrote:
> Hi Alistair,
>
> +Cc Max Chou, he may be interested in this also
>
> [...]
>> @@ -0,0 +1,56 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/realtek,rtl8723bs-bt.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: RTL8723BS/RTL8723CS Bluetooth Device Tree Bindings
> I suggest you also add RTL8822C here (as well as to the compatible enum
> and the description below). commit 848fc6164158d6 ("Bluetooth: hci_h5:
> btrtl: Add support for RTL8822C") adde support for that chip but didn't
> add the dt-binding documentation.


Done!


>
> [...]
>> +  device-wake-gpios:
>> +    description:
>> +      GPIO specifier, used to wakeup the BT module (active high)
>> +
>> +  enable-gpios:
>> +    description:
>> +      GPIO specifier, used to enable the BT module (active high)
>> +
>> +  host-wake-gpios:
>> +    desciption:
>> +      GPIO specifier, used to wakeup the host processor (active high)
> regarding all GPIOs here: it entirely depends on the board whether these
> are active HIGH or LOW. even though the actual Bluetooth part may
> require a specific polarity there can be (for example) a transistor on
> the board which could be used to invert the polarity (from the SoC's
> view).


I have removed the "(active..." part from the GPIOs.


>
> also "make dt_binding_check" reports:
>    properties:host-wake-gpios: 'maxItems' is a required property
> I assume that it'll be the same for the other properties


Added.


>
>> +firmware-postfix: firmware postfix to be used for firmware config
> there's no other dt-binding that uses "firmware-postfix" yet. However,
> there are a few that use "firmware-name". My opinion hasn't changed
> since Vasily has posted this series initially: I would not add that
> property for now because there seems to be a "standard" config blob
> (which works for "all" boards), see Hans' analysis result of the ACPI
> config blobs for RTL8723BS: [0].


I have removed the 'firmware-postfix" part from this series.


> Getting that "standard" config blob into linux-firmware would be
> awesome (I assume licensing is not an issue here, Hans can probably give
> more details here). I'm not sure about the licenses of "board specific"
> config blobs and whether these can be added to linux-firmware.
>
> also indentation seems wrong here
>
>> +reset-gpios: GPIO specifier, used to reset the BT module (active high)
> indentation seems wrong here too


Fixed.


>
> also please note that there is currently no support for this property
> inside the hci_h5 driver and you don't seem to add support for it within
> this series either. so please double check that the reset GPIO is really
> wired up on your sopine board.


Removed.


>
>> +required:
>> +  - compatible
>> +
>> +examples:
>> +  - |
>> +    &uart1 {
>> +        pinctrl-names = "default";
>> +        pinctrl-0 = <&uart1_pins>, <&uart1_rts_cts_pins>;
>> +        status = "okay";
> AFAIK the "status" property should be omitted from examples


Removed.


> Z
> also please add a "uart-has-rtscts" propery, see
> Documentation/devicetree/bindings/serial/serial.yaml
> Also please update patch #3.


Added.


Thanks for the review.


Alistair


>
>
> Martin
>
>
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/rtl_bt/rtl8723bs_config-OBDA8723.bin?id=e6b9001e91110c654573b8f8e2db6155d10d3b57
