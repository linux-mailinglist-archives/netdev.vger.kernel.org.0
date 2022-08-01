Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D42F586E2A
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 17:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiHAP6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 11:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiHAP6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 11:58:10 -0400
X-Greylist: delayed 399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 01 Aug 2022 08:58:06 PDT
Received: from sibelius.xs4all.nl (80-61-163-207.fixed.kpn.net [80.61.163.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF69333416;
        Mon,  1 Aug 2022 08:58:06 -0700 (PDT)
Received: from localhost (bloch.sibelius.xs4all.nl [local])
        by bloch.sibelius.xs4all.nl (OpenSMTPD) with ESMTPA id cd18dc5e;
        Mon, 1 Aug 2022 17:51:24 +0200 (CEST)
Date:   Mon, 1 Aug 2022 17:51:23 +0200 (CEST)
From:   Mark Kettenis <mark.kettenis@xs4all.nl>
To:     Rob Herring <robh@kernel.org>
Cc:     sven@svenpeter.dev, marcel@holtmann.org, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, marcan@marcan.st, alyssa@rosenzweig.io,
        asahi@lists.linux.dev, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220801153921.GC1031441-robh@kernel.org> (message from Rob
        Herring on Mon, 1 Aug 2022 09:39:21 -0600)
Subject: Re: [PATCH 2/5] dt-bindings: net: Add Broadcom BCM4377 family PCI
 Bluetooth
References: <20220801103633.27772-1-sven@svenpeter.dev>
 <20220801103633.27772-3-sven@svenpeter.dev> <20220801153921.GC1031441-robh@kernel.org>
Message-ID: <d3ce6343fdaaf127@bloch.sibelius.xs4all.nl>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Date: Mon, 1 Aug 2022 09:39:21 -0600
> From: Rob Herring <robh@kernel.org>
> 
> On Mon, Aug 01, 2022 at 12:36:30PM +0200, Sven Peter wrote:
> > These chips are combined Wi-Fi/Bluetooth radios which expose a
> > PCI subfunction for the Bluetooth part.
> > They are found in Apple machines such as the x86 models with the T2
> > chip or the arm64 models with the M1 or M2 chips.
> > 
> > Signed-off-by: Sven Peter <sven@svenpeter.dev>
> > ---
> >  .../bindings/net/brcm,bcm4377-bluetooth.yaml  | 77 +++++++++++++++++++
> >  MAINTAINERS                                   |  1 +
> >  2 files changed, 78 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
> > new file mode 100644
> > index 000000000000..afe6ecebd939
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
> > @@ -0,0 +1,77 @@
> > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/brcm,bcm4377-bluetooth.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Broadcom BCM4377 family PCI Bluetooth Chips
> > +
> > +allOf:
> > +  - $ref: bluetooth-controller.yaml#
> > +
> > +maintainers:
> > +  - Sven Peter <sven@svenpeter.dev>
> > +
> > +description:
> > +  This binding describes Broadcom BCM4377 family PCI-attached bluetooth chips
> 
> s/PCI/PCIe/
> 
> > +  usually found in Apple machines. The Wi-Fi part of the chip is described in
> > +  bindings/net/wireless/brcm,bcm4329-fmac.yaml.
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - pci14e4,5fa0 # BCM4377
> > +      - pci14e4,5f69 # BCM4378
> > +      - pci14e4,5f71 # BCM4387
> > +
> > +  reg:
> > +    description: PCI device identifier.
> > +
> > +  brcm,board-type:
> > +    $ref: /schemas/types.yaml#/definitions/string
> > +    description: Board type of the Bluetooth chip. This is used to decouple
> > +      the overall system board from the Bluetooth module and used to construct
> > +      firmware and calibration data filenames.
> > +      On Apple platforms, this should be the Apple module-instance codename
> > +      prefixed by "apple,", e.g. "apple,atlantisb".
> 
> pattern: '^apple,.*'
> 
> And when there's other known vendors we can add them.
> 
> Really, I'm not all that crazy about this property. 'firmware-name' 
> doesn't work? Or perhaps this should just be a more specific compatible 
> string.

This matches the property proposed here:

  https://patchwork.kernel.org/project/linux-wireless/patch/20220104072658.69756-2-marcan@marcan.st/

Unfortunately that series didn't make progress for other reasons...

There was some significant bikeshedding in the original version of that series already:

  https://patchwork.kernel.org/project/linux-wireless/patch/20211226153624.162281-2-marcan@marcan.st/

Are you sure you want to repeat that? ;)

> > +
> > +  brcm,taurus-cal-blob:
> > +    $ref: /schemas/types.yaml#/definitions/uint8-array
> > +    description: A per-device calibration blob for the Bluetooth radio. This
> > +      should be filled in by the bootloader from platform configuration
> > +      data, if necessary, and will be uploaded to the device.
> > +      This blob is used if the chip stepping of the Bluetooth module does not
> > +      support beamforming.
> > +
> > +  brcm,taurus-bf-cal-blob:
> > +    $ref: /schemas/types.yaml#/definitions/uint8-array
> > +    description: A per-device calibration blob for the Bluetooth radio. This
> > +      should be filled in by the bootloader from platform configuration
> > +      data, if necessary, and will be uploaded to the device.
> > +      This blob is used if the chip stepping of the Bluetooth module supports
> > +      beamforming.
> > +
> > +  local-bd-address: true
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - local-bd-address
> > +  - brcm,board-type
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    pci0 {
> 
> pcie {
> 
> > +      #address-cells = <3>;
> > +      #size-cells = <2>;
> > +
> > +      bluetooth@0,1 {
> > +        compatible = "pci14e4,5f69";
> > +        reg = <0x10100 0x0 0x0 0x0 0x0>;
> 
> reg should not have the bus number here as that is dynamic. So 0x100 for 
> the 1st cell.
> 
> > +        brcm,board-type = "apple,honshu";
> > +        /* To be filled by the bootloader */
> > +        local-bd-address = [00 00 00 00 00 00];
> > +      };
> > +    };
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index a6d3bd9d2a8d..8965556bace8 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -1837,6 +1837,7 @@ F:	Documentation/devicetree/bindings/interrupt-controller/apple,*
> >  F:	Documentation/devicetree/bindings/iommu/apple,dart.yaml
> >  F:	Documentation/devicetree/bindings/iommu/apple,sart.yaml
> >  F:	Documentation/devicetree/bindings/mailbox/apple,mailbox.yaml
> > +F:	Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
> >  F:	Documentation/devicetree/bindings/nvme/apple,nvme-ans.yaml
> >  F:	Documentation/devicetree/bindings/nvmem/apple,efuses.yaml
> >  F:	Documentation/devicetree/bindings/pci/apple,pcie.yaml
> > -- 
> > 2.25.1
> > 
> > 
> 
> 
