Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1134ADDC1
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382239AbiBHP4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382673AbiBHPzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:55:52 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CE4C061578
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 07:55:51 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nHSq9-00015b-Hq; Tue, 08 Feb 2022 16:55:37 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DB1242E763;
        Tue,  8 Feb 2022 15:55:34 +0000 (UTC)
Date:   Tue, 8 Feb 2022 16:55:31 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Cc:     appana.durga.rao@xilinx.com, wg@grandegger.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        git@xilinx.com, naga.sureshkumar.relli@xilinx.com,
        michal.simek@xilinx.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: can: xilinx_can: Convert Xilinx CAN binding
 to YAML
Message-ID: <20220208155531.uxyyiwuewlk5rtvb@pengutronix.de>
References: <20220208155209.25926-1-amit.kumar-mahapatra@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kdrzfvarlmluvr5z"
Content-Disposition: inline
In-Reply-To: <20220208155209.25926-1-amit.kumar-mahapatra@xilinx.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kdrzfvarlmluvr5z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On 08.02.2022 21:22:09, Amit Kumar Mahapatra wrote:
> Convert Xilinx CAN binding documentation to YAML.
>
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
> ---
> BRANCH: yaml
> ---
>  .../bindings/net/can/xilinx_can.txt           |  61 --------
>  .../bindings/net/can/xilinx_can.yaml          | 146 ++++++++++++++++++
>  2 files changed, 146 insertions(+), 61 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt
>  create mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.yaml
>
> diff --git a/Documentation/devicetree/bindings/net/can/xilinx_can.txt b/Documentation/devicetree/bindings/net/can/xilinx_can.txt
> deleted file mode 100644
> index 100cc40b8510..000000000000
> --- a/Documentation/devicetree/bindings/net/can/xilinx_can.txt
> +++ /dev/null
> @@ -1,61 +0,0 @@
> -Xilinx Axi CAN/Zynq CANPS controller Device Tree Bindings
> ----------------------------------------------------------
> -
> -Required properties:
> -- compatible		: Should be:
> -			  - "xlnx,zynq-can-1.0" for Zynq CAN controllers
> -			  - "xlnx,axi-can-1.00.a" for Axi CAN controllers
> -			  - "xlnx,canfd-1.0" for CAN FD controllers
> -			  - "xlnx,canfd-2.0" for CAN FD 2.0 controllers
> -- reg			: Physical base address and size of the controller
> -			  registers map.
> -- interrupts		: Property with a value describing the interrupt
> -			  number.
> -- clock-names		: List of input clock names
> -			  - "can_clk", "pclk" (For CANPS),
> -			  - "can_clk", "s_axi_aclk" (For AXI CAN and CAN FD).
> -			  (See clock bindings for details).
> -- clocks		: Clock phandles (see clock bindings for details).
> -- tx-fifo-depth		: Can Tx fifo depth (Zynq, Axi CAN).
> -- rx-fifo-depth		: Can Rx fifo depth (Zynq, Axi CAN, CAN FD in
> -                          sequential Rx mode).
> -- tx-mailbox-count	: Can Tx mailbox buffer count (CAN FD).
> -- rx-mailbox-count	: Can Rx mailbox buffer count (CAN FD in mailbox Rx
> -			  mode).
> -
> -
> -Example:
> -
> -For Zynq CANPS Dts file:
> -	zynq_can_0: can@e0008000 {
> -			compatible = "xlnx,zynq-can-1.0";
> -			clocks = <&clkc 19>, <&clkc 36>;
> -			clock-names = "can_clk", "pclk";
> -			reg = <0xe0008000 0x1000>;
> -			interrupts = <0 28 4>;
> -			interrupt-parent = <&intc>;
> -			tx-fifo-depth = <0x40>;
> -			rx-fifo-depth = <0x40>;
> -		};
> -For Axi CAN Dts file:
> -	axi_can_0: axi-can@40000000 {
> -			compatible = "xlnx,axi-can-1.00.a";
> -			clocks = <&clkc 0>, <&clkc 1>;
> -			clock-names = "can_clk","s_axi_aclk" ;
> -			reg = <0x40000000 0x10000>;
> -			interrupt-parent = <&intc>;
> -			interrupts = <0 59 1>;
> -			tx-fifo-depth = <0x40>;
> -			rx-fifo-depth = <0x40>;
> -		};
> -For CAN FD Dts file:
> -	canfd_0: canfd@40000000 {
> -			compatible = "xlnx,canfd-1.0";
> -			clocks = <&clkc 0>, <&clkc 1>;
> -			clock-names = "can_clk", "s_axi_aclk";
> -			reg = <0x40000000 0x2000>;
> -			interrupt-parent = <&intc>;
> -			interrupts = <0 59 1>;
> -			tx-mailbox-count = <0x20>;
> -			rx-fifo-depth = <0x20>;
> -		};
> diff --git a/Documentation/devicetree/bindings/net/can/xilinx_can.yaml b/Documentation/devicetree/bindings/net/can/xilinx_can.yaml
> new file mode 100644
> index 000000000000..cdf2e4a20662
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/xilinx_can.yaml
> @@ -0,0 +1,146 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/xilinx_can.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title:
> +  Xilinx Axi CAN/Zynq CANPS controller Binding
> +
> +maintainers:
> +  - Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
> +

Please add:

allOf:
  - $ref: can-controller.yaml#

Marc

--
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kdrzfvarlmluvr5z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmICkm4ACgkQrX5LkNig
013G+Qf/XXs+9iWONiI7XzlZBD94Mv/cyow0j2FmhqX8tA/jC0wrNuC2+rh2Aksj
ElrCHqfLmzw0SKRD8ncbZ0boOpEqPcGoAivziBTEcFpS0EVrmxrFtE2PrOOwVG/7
ATRsA97OQANlG37GyrlvjnmVX10YfnS6pQNBby/YF4P5Jo4r97X3fxedqva9o3ch
S6xeU8cbukXz5J3cV/qd7a7qYOGv2BTld6fkhWEUL8O5JUFUbqKnjUeOYsmjQ1Ph
1OKU+4QZeiw00B0M6Tpc3ydNeIwcrwHElcZ7yDbcRoG9Bvb+z0ohnS3K9eEAjoSJ
zNubODBeQjzXu3/1zx1Xay5fgfcbwA==
=3Hgw
-----END PGP SIGNATURE-----

--kdrzfvarlmluvr5z--
