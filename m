Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1EB8197F46
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 17:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgC3PL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 11:11:29 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:34200 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbgC3PL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 11:11:28 -0400
Received: by mail-il1-f194.google.com with SMTP id t11so16145561ils.1;
        Mon, 30 Mar 2020 08:11:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Wg2V9C53DlqPodPsHDEJ/E9f60hkJENPbg3weWQQbWg=;
        b=Q84yjlb81ULF9T9kBgpZ1hushUTKLika2lcBbsseGQ9AmMSUBltFXgUt1bTPQ1ODuX
         GOUqHO5UAi0H2bteCYwklaQyGCsS+SJqAydYjTDtBkhOvAsPL645WJXejr+mukdXap1R
         vozXZzvphu/lGtNsfTnuvhFrcb6OkrAF13sWmV+m2hyslrVu228ElSLawPFeK9nz2bRO
         XrLkzLzZTVcKAa5GeUctA46kE88TV2Gr0s2X8tYddqy5DlKNSPlYhsdjCthMJB2RI0hc
         vRBp3x5dnXB0hs83xZn/N4CAZ5hHYELgX7jJlLQvfwFsN+e044n0usgCD0Ru2rm0Z9tP
         mQGA==
X-Gm-Message-State: ANhLgQ1AG40wTeaczyS3zWQM7hANPwMhN0WYeHCEDtIU7sWXsxUjZOna
        tyAJGv7p5Soe4ceN9bomcwECMDE=
X-Google-Smtp-Source: ADFU+vv1QY72ToqhHii/CGo5fEmMH0Hv59kt3x+UZiddA6Lw9P1UMrD0ngQu9AVFE8Yfi0YSS6vk7w==
X-Received: by 2002:a92:8c93:: with SMTP id s19mr10499418ill.222.1585581087447;
        Mon, 30 Mar 2020 08:11:27 -0700 (PDT)
Received: from rob-hp-laptop ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id c88sm4945302ill.15.2020.03.30.08.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 08:11:26 -0700 (PDT)
Received: (nullmailer pid 9592 invoked by uid 1000);
        Mon, 30 Mar 2020 15:11:24 -0000
Date:   Mon, 30 Mar 2020 09:11:24 -0600
From:   Rob Herring <robh@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 1/2] dt-bindings: net: add marvell usb to mdio bindings
Message-ID: <20200330151124.GA30148@bogus>
References: <20200321202443.15352-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321202443.15352-1-tobias@waldekranz.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 09:24:42PM +0100, Tobias Waldekranz wrote:
> Describe how the USB to MDIO controller can optionally use device tree
> bindings to reference attached devices such as switches.

Looks like this is in linux-next now. First I'm seeing it because the DT 
list was not Cc'ed.

This is breaking 'make dt_binding_check'. Revert or fix before this goes 
to Linus please.

> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  .../bindings/net/marvell,mvusb.yaml           | 65 +++++++++++++++++++
>  MAINTAINERS                                   |  6 ++
>  2 files changed, 71 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/marvell,mvusb.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/marvell,mvusb.yaml b/Documentation/devicetree/bindings/net/marvell,mvusb.yaml
> new file mode 100644
> index 000000000000..9458f6659be1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/marvell,mvusb.yaml
> @@ -0,0 +1,65 @@
> +# SPDX-License-Identifier: GPL-2.0

New bindings should be:

(GPL-2.0-only OR BSD-2-Clause)

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/marvell,mvusb.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Marvell USB to MDIO Controller
> +
> +maintainers:
> +  - Tobias Waldekranz <tobias@waldekranz.com>
> +
> +description: |+
> +  This controller is mounted on development boards for Marvell's Link Street
> +  family of Ethernet switches. It allows you to configure the switch's registers
> +  using the standard MDIO interface.
> +
> +  Since the device is connected over USB, there is no strict requirement of
> +  having a device tree representation of the device. But in order to use it with
> +  the mv88e6xxx driver, you need a device tree node in which to place the switch
> +  definition.
> +
> +allOf:
> +  - $ref: "mdio.yaml#"
> +
> +properties:
> +  compatible:
> +    const: usb1286,1fa4
> +  reg:
> +    maxItems: 1
> +    description: The USB port number on the host controller

Really, it's the port on the hub which could be a root hub.

> +
> +required:
> +  - compatible
> +  - reg
> +  - "#address-cells"
> +  - "#size-cells"
> +
> +examples:
> +  - |
> +    /* USB host controller */
> +    &usb1 {

This won't compile because there's no 'usb1' to reference.

> +            mvusb: mdio@1 {
> +                    compatible = "usb1286,1fa4";
> +                    reg = <1>;
> +                    #address-cells = <1>;
> +                    #size-cells = <0>;
> +            };
> +    };
> +
> +    /* MV88E6390X devboard */
> +    &mvusb {

Move this into the above node.

> +            switch@0 {
> +                    compatible = "marvell,mv88e6190";
> +                    status = "ok";

Don't show status in examples.

> +                    reg = <0x0>;
> +
> +                    ports {
> +                            /* Port definitions */

Incomplete examples will eventually fail as when complete schema are 
present.

> +                    };
> +
> +                    mdio {
> +                            /* PHY definitions */
> +                    };
> +            };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 97dce264bc7c..ff35669f8712 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10101,6 +10101,12 @@ M:	Nicolas Pitre <nico@fluxnic.net>
>  S:	Odd Fixes
>  F:	drivers/mmc/host/mvsdio.*
>  
> +MARVELL USB MDIO CONTROLLER DRIVER
> +M:	Tobias Waldekranz <tobias@waldekranz.com>
> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +F:	Documentation/devicetree/bindings/net/marvell,mvusb.yaml
> +
>  MARVELL XENON MMC/SD/SDIO HOST CONTROLLER DRIVER
>  M:	Hu Ziji <huziji@marvell.com>
>  L:	linux-mmc@vger.kernel.org
> -- 
> 2.17.1
> 
