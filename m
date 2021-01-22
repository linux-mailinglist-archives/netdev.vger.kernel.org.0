Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB8A300FEC
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730553AbhAVTyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 14:54:10 -0500
Received: from mail-ot1-f46.google.com ([209.85.210.46]:38508 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729001AbhAVTXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 14:23:14 -0500
Received: by mail-ot1-f46.google.com with SMTP id s2so3975086otp.5;
        Fri, 22 Jan 2021 11:22:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AcWL/Daw/XNoId/ExdNCO9ieLMb3o6Tm1Cik9cvjN0Y=;
        b=KUtkAnRLFQpVFxbEEtYDyCj7N56rrgcYPN8N7bqTDkEr8ucG5dTuVE4QGC/QSau+oK
         geuOFHKplFc265ckq1YTCTLwRBM7KrpaCiyJ8M+tV/YlxibX7yYuPVxZ/B8+e1xaGfe+
         y/3TPqJxfQAyxrJnSuy1nOFiTfLamz96lNQnRGd/yXsYuRVuleHFIItEkBYoZdKlXrPM
         fILgG55w33OLPZCycqRhsU+Tm/bKhCYjUX8Gv7cyqwnHn91TZe9J5HSYpEFepVJ/g77w
         jRlonfsD4IAsUdxjQ8g01/fKWjldaKOCd3tBoh/MIx6HzCzhaWvdPt5ubDuDAleW8duJ
         pnPg==
X-Gm-Message-State: AOAM530NVKAX7+cHvnm/sdLyogeYVZ5MhOI9VSixDMYWpt+6XVyMva5S
        DMWAfJv/EUsyrgSieFRZkxWdyR98+0Mw2H+xC73H1XR6JM4sRw==
X-Google-Smtp-Source: ABdhPJzweY2mg/zFWP93YsFHVJt5xaD20MtLkVatRFMIokm+C6mB13HNhebPzAWgGsPX6kHU3X2VmvszA6UQsk6dJgw=
X-Received: by 2002:a05:6830:2313:: with SMTP id u19mr1341091ote.321.1611343352346;
 Fri, 22 Jan 2021 11:22:32 -0800 (PST)
MIME-Version: 1.0
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com> <20210122154300.7628-2-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210122154300.7628-2-calvin.johnson@oss.nxp.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 22 Jan 2021 20:22:21 +0100
Message-ID: <CAJZ5v0iX3uU36448ALA20hiVk968VKTsvgwLrp8ur96MQo3Acw@mail.gmail.com>
Subject: Re: [net-next PATCH v4 01/15] Documentation: ACPI: DSD: Document MDIO PHY
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 4:43 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> provide them to be connected to MAC.
>
> Describe properties "phy-handle" and "phy-mode".
>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
>
> Changes in v4:
> - More cleanup

This looks much better that the previous versions IMV, some nits below.

> Changes in v3: None
> Changes in v2:
> - Updated with more description in document
>
>  Documentation/firmware-guide/acpi/dsd/phy.rst | 129 ++++++++++++++++++
>  1 file changed, 129 insertions(+)
>  create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
>
> diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> new file mode 100644
> index 000000000000..76fca994bc99
> --- /dev/null
> +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> @@ -0,0 +1,129 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=========================
> +MDIO bus and PHYs in ACPI
> +=========================
> +
> +The PHYs on an MDIO bus [1] are probed and registered using
> +fwnode_mdiobus_register_phy().

Empty line here, please.

> +Later, for connecting these PHYs to MAC, the PHYs registered on the
> +MDIO bus have to be referenced.
> +
> +The UUID given below should be used as mentioned in the "Device Properties
> +UUID For _DSD" [2] document.
> +   - UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301

I would drop the above paragraph.

> +
> +This document introduces two _DSD properties that are to be used
> +for PHYs on the MDIO bus.[3]

I'd say "for connecting PHYs on the MDIO bus [3] to the MAC layer."
above and add the following here:

"These properties are defined in accordance with the "Device
Properties UUID For _DSD" [2] document and the
daffd814-6eba-4d8c-8a91-bc9bbf4aa301 UUID must be used in the Device
Data Descriptors containing them."

> +
> +phy-handle
> +----------
> +For each MAC node, a device property "phy-handle" is used to reference
> +the PHY that is registered on an MDIO bus. This is mandatory for
> +network interfaces that have PHYs connected to MAC via MDIO bus.
> +
> +During the MDIO bus driver initialization, PHYs on this bus are probed
> +using the _ADR object as shown below and are registered on the MDIO bus.

Do you want to mention the "reg" property here?  I think it would be
useful to do that.

> +
> +::
> +      Scope(\_SB.MDI0)
> +      {
> +        Device(PHY1) {
> +          Name (_ADR, 0x1)
> +        } // end of PHY1
> +
> +        Device(PHY2) {
> +          Name (_ADR, 0x2)
> +        } // end of PHY2
> +      }
> +
> +Later, during the MAC driver initialization, the registered PHY devices
> +have to be retrieved from the MDIO bus. For this, MAC driver needs

"the MAC driver" I suppose?

> +reference to the previously registered PHYs which are provided

s/reference/references/ (plural)

> +using reference to the device as {\_SB.MDI0.PHY1}.

"as device object references (e.g. \_SB.MDI0.PHY1}."

> +
> +phy-mode
> +--------
> +The "phy-mode" _DSD property is used to describe the connection to
> +the PHY. The valid values for "phy-mode" are defined in [4].
> +

One empty line should be sufficient.

> +
> +An ASL example of this is shown below.

"The following ASL example illustrates the usage of these properties."

> +
> +DSDT entry for MDIO node
> +------------------------

Empty line here, please.

> +The MDIO bus has an SoC component(MDIO controller) and a platform

Missing space after "component".

> +component (PHYs on the MDIO bus).
> +
> +a) Silicon Component
> +This node describes the MDIO controller, MDI0
> +---------------------------------------------
> +::
> +       Scope(_SB)
> +       {
> +         Device(MDI0) {
> +           Name(_HID, "NXP0006")
> +           Name(_CCA, 1)
> +           Name(_UID, 0)
> +           Name(_CRS, ResourceTemplate() {
> +             Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
> +             Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
> +              {
> +                MDI0_IT
> +              }
> +           }) // end of _CRS for MDI0
> +         } // end of MDI0
> +       }
> +
> +b) Platform Component
> +This node defines the PHYs that are connected to the MDIO bus, MDI0

"The PHY1 and PHY2 nodes represent the PHYs connected to MDIO bus MDI0."

> +-------------------------------------------------------------------
> +::
> +       Scope(\_SB.MDI0)
> +       {
> +         Device(PHY1) {
> +           Name (_ADR, 0x1)
> +         } // end of PHY1
> +
> +         Device(PHY2) {
> +           Name (_ADR, 0x2)
> +         } // end of PHY2
> +       }
> +
> +

"DSDT entries representing MAC nodes
-----------------------------------"

Plus an empty line.

> +Below are the MAC nodes where PHY nodes are referenced.
> +phy-mode and phy-handle are used as explained earlier.
> +------------------------------------------------------
> +::
> +       Scope(\_SB.MCE0.PR17)
> +       {
> +         Name (_DSD, Package () {
> +            ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +                Package () {
> +                    Package (2) {"phy-mode", "rgmii-id"},
> +                    Package (2) {"phy-handle", \_SB.MDI0.PHY1}
> +             }
> +          })
> +       }
> +
> +       Scope(\_SB.MCE0.PR18)
> +       {
> +         Name (_DSD, Package () {
> +           ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +               Package () {
> +                   Package (2) {"phy-mode", "rgmii-id"},
> +                   Package (2) {"phy-handle", \_SB.MDI0.PHY2}}
> +           }
> +         })
> +       }
> +
> +References
> +==========
> +
> +[1] Documentation/networking/phy.rst
> +
> +[2] https://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> +
> +[3] Documentation/firmware-guide/acpi/DSD-properties-rules.rst
> +
> +[4] Documentation/devicetree/bindings/net/ethernet-controller.yaml
> --
> 2.17.1
>
