Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507D35B1B67
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 13:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiIHL3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 07:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiIHL3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 07:29:46 -0400
Received: from hutie.ust.cz (hutie.ust.cz [185.8.165.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E868B18B0B;
        Thu,  8 Sep 2022 04:29:42 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cutebit.org; s=mail;
        t=1662636574; bh=eA2LMCy4I214W/X512BaZYIk9y7xAY0TdZeYuwcrUnM=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To;
        b=mrzaxyx6V/uFgjAWurZEr3sq5LP2vqupdTG4Sad9liAwF7U47bMDSRCVzE+8pgDYj
         U3S9PNkA+QF1l9PjI1eDBYJu+5qeTOHgIKmu4QO7BwG8kWq0+CljGW5nPPtCqLKrxI
         TaIdqkMQtfnca25A0/5N1Cl6B7Mr1O2vaW8iHR3I=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH v2 2/5] dt-bindings: net: Add Broadcom BCM4377 family PCIe
 Bluetooth
From:   =?utf-8?Q?Martin_Povi=C5=A1er?= <povik@cutebit.org>
In-Reply-To: <bcb799ea-d58e-70dc-c5c2-daaff1b19bf5@linaro.org>
Date:   Thu, 8 Sep 2022 13:29:30 +0200
Cc:     Sven Peter <sven@svenpeter.dev>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E53D41D9-1675-42EB-BC76-3453043FCB6E@cutebit.org>
References: <20220907170935.11757-1-sven@svenpeter.dev>
 <20220907170935.11757-3-sven@svenpeter.dev>
 <bcb799ea-d58e-70dc-c5c2-daaff1b19bf5@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 8. 9. 2022, at 13:19, Krzysztof Kozlowski =
<krzysztof.kozlowski@linaro.org> wrote:
>=20
> On 07/09/2022 19:09, Sven Peter wrote:
>> These chips are combined Wi-Fi/Bluetooth radios which expose a
>> PCI subfunction for the Bluetooth part.
>> They are found in Apple machines such as the x86 models with the T2
>> chip or the arm64 models with the M1 or M2 chips.
>>=20
>> Signed-off-by: Sven Peter <sven@svenpeter.dev>
>> ---
>> changes from v1:
>> - added apple,* pattern to brcm,board-type
>> - s/PCI/PCIe/
>> - fixed 1st reg cell inside the example to not contain the bus number
>>=20
>> .../bindings/net/brcm,bcm4377-bluetooth.yaml | 78 +++++++++++++++++++
>> MAINTAINERS | 1 +
>> 2 files changed, 79 insertions(+)
>> create mode 100644 =
Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
>>=20
>> diff --git =
a/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml =
b/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
>> new file mode 100644
>> index 000000000000..fb851f8e6bcb
>> --- /dev/null
>> +++ =
b/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
>> @@ -0,0 +1,78 @@
>> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/brcm,bcm4377-bluetooth.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Broadcom BCM4377 family PCIe Bluetooth Chips
>> +
>> +allOf:
>> + - $ref: bluetooth-controller.yaml#
>=20
> Put it before properties (so after description).
>=20
>> +
>> +maintainers:
>> + - Sven Peter <sven@svenpeter.dev>
>> +
>> +description:
>> + This binding describes Broadcom BCM4377 family PCIe-attached =
bluetooth chips
>> + usually found in Apple machines. The Wi-Fi part of the chip is =
described in
>> + bindings/net/wireless/brcm,bcm4329-fmac.yaml.
>> +
>> +properties:
>> + compatible:
>> + enum:
>> + - pci14e4,5fa0 # BCM4377
>> + - pci14e4,5f69 # BCM4378
>> + - pci14e4,5f71 # BCM4387
>> +
>> + reg:
>> + description: PCI device identifier.
>=20
> maxItems: X
>=20
>> +
>> + brcm,board-type:
>> + $ref: /schemas/types.yaml#/definitions/string
>> + description: Board type of the Bluetooth chip. This is used to =
decouple
>> + the overall system board from the Bluetooth module and used to =
construct
>> + firmware and calibration data filenames.
>> + On Apple platforms, this should be the Apple module-instance =
codename
>> + prefixed by "apple,", e.g. "apple,atlantisb".
>> + pattern: '^apple,.*'
>> +
>> + brcm,taurus-cal-blob:
>> + $ref: /schemas/types.yaml#/definitions/uint8-array
>> + description: A per-device calibration blob for the Bluetooth radio. =
This
>> + should be filled in by the bootloader from platform configuration
>> + data, if necessary, and will be uploaded to the device.
>> + This blob is used if the chip stepping of the Bluetooth module does =
not
>> + support beamforming.
>=20
> Isn't it:
> s/beamforming/beam forming/
> ?

Doesn=E2=80=99t seem like it:
https://www.google.com/search?hl=3Den&q=3Dbeam%20forming

Best,
Martin

>> +
>> + brcm,taurus-bf-cal-blob:
>> + $ref: /schemas/types.yaml#/definitions/uint8-array
>> + description: A per-device calibration blob for the Bluetooth radio. =
This
>> + should be filled in by the bootloader from platform configuration
>> + data, if necessary, and will be uploaded to the device.
>> + This blob is used if the chip stepping of the Bluetooth module =
supports
>> + beamforming.
>=20
> Same here.


> Best regards,
> Krzysztof

