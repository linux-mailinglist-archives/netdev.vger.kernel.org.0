Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D871150856
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 15:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgBCO0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 09:26:30 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56103 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgBCO0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 09:26:30 -0500
Received: by mail-wm1-f66.google.com with SMTP id q9so16107510wmj.5;
        Mon, 03 Feb 2020 06:26:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=itc17noPW/qOhrB9VNLS0A5datkiWJZoXQQ/RMMvGb4=;
        b=FbNok9t4h4HordSj02XMpfiliSEX/NEn7M/qQw4hIQva8jsU3WQviiJSjLhX+6YeRy
         at3YDSIScg4u6USeTZoyyod7EX0vNf7RZebnmNNt5/JlrQN7yifzR8r+Qt42C5u2D7bv
         reYfzBlc1rqRWf9QOFH1sqOxNFQLqnq7eMKQ2e8L+tpXRGn24pKhzQc3UKL7jO89pwc4
         mlfzI8iRBFbNbJ1cAH8yJbYpovJF8AqOTtMo8Ly0Pm0STpPdDeNxS4ewgOk8lf60JJDd
         9FIJdRru1KH+JGpRuVpORWRcqIhfNOpjvYL3/Xufe2zvAU0reYrtWTcvIW7u18emmhkY
         xrRg==
X-Gm-Message-State: APjAAAVibx/mvqo6d3q6OWw43mzJVILP+zu2DZRdMBTY6BCUP/L/DDs9
        sZf1/+gAkKPqJKnhhTrbuJs9En3bSA==
X-Google-Smtp-Source: APXvYqxc2RMlFnmFy5Opti+9z+rRZLxfxDLV3D5FBrtAkPSVjJL0S3CbhEJWd5zGMozHNjHKt12opQ==
X-Received: by 2002:a1c:96c4:: with SMTP id y187mr30487850wmd.112.1580739987385;
        Mon, 03 Feb 2020 06:26:27 -0800 (PST)
Received: from rob-hp-laptop ([212.187.182.166])
        by smtp.gmail.com with ESMTPSA id 18sm22963441wmf.1.2020.02.03.06.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 06:26:26 -0800 (PST)
Received: (nullmailer pid 27658 invoked by uid 1000);
        Mon, 03 Feb 2020 14:26:25 -0000
Date:   Mon, 3 Feb 2020 14:26:25 +0000
From:   Rob Herring <robh@kernel.org>
To:     Benjamin Gaignard <benjamin.gaignard@st.com>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        mark.rutland@arm.com, sriram.dash@samsung.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: can: Convert M_CAN to json-schema
Message-ID: <20200203142625.GA19020@bogus>
References: <20200124155542.2053-1-benjamin.gaignard@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124155542.2053-1-benjamin.gaignard@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 04:55:42PM +0100, Benjamin Gaignard wrote:
> Convert M_CAN bindings to json-schema
> 
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
> ---
>  .../bindings/net/can/can-transceiver.txt           |  24 ----
>  .../devicetree/bindings/net/can/m_can.txt          |  75 ----------
>  .../devicetree/bindings/net/can/m_can.yaml         | 151 +++++++++++++++++++++
>  3 files changed, 151 insertions(+), 99 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/can/can-transceiver.txt

No chance other controllers aren't going to have a transceiver?

>  delete mode 100644 Documentation/devicetree/bindings/net/can/m_can.txt
>  create mode 100644 Documentation/devicetree/bindings/net/can/m_can.yaml

bosch,m_can.yaml

> diff --git a/Documentation/devicetree/bindings/net/can/m_can.yaml b/Documentation/devicetree/bindings/net/can/m_can.yaml
> new file mode 100644
> index 000000000000..efdbed81af29
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/m_can.yaml
> @@ -0,0 +1,151 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/m_can.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Bosch MCAN controller Bindings
> +
> +description: Bosch MCAN controller for CAN bus
> +
> +maintainers:
> +  -  Sriram Dash <sriram.dash@samsung.com>
> +
> +properties:
> +  compatible:
> +    const: bosch,m_can
> +
> +  reg:
> +    items:
> +      - description: M_CAN registers map
> +      - description: message RAM
> +
> +  reg-names:
> +    items:
> +      - const: m_can
> +      - const: message_ram
> +
> +  interrupts:
> +    items:
> +      - description: interrupt line0
> +      - description: interrupt line1
> +    minItems: 1
> +    maxItems: 2
> +
> +  interrupt-names:
> +    items:
> +      - const: int0
> +      - const: int1
> +    minItems: 1
> +    maxItems: 2
> +
> +  clocks:
> +    items:
> +      - description: peripheral clock
> +      - description: bus clock
> +
> +  clock-names:
> +    items:
> +      - const: hclk
> +      - const: cclk
> +
> +  bosch,mram-cfg:
> +    description: |
> +                 Message RAM configuration data.
> +                 Multiple M_CAN instances can share the same Message RAM
> +                 and each element(e.g Rx FIFO or Tx Buffer and etc) number
> +                 in Message RAM is also configurable, so this property is
> +                 telling driver how the shared or private Message RAM are
> +                 used by this M_CAN controller.
> +
> +                 The format should be as follows:
> +                 <offset sidf_elems xidf_elems rxf0_elems rxf1_elems rxb_elems txe_elems txb_elems>
> +                 The 'offset' is an address offset of the Message RAM where
> +                 the following elements start from. This is usually set to
> +                 0x0 if you're using a private Message RAM. The remain cells
> +                 are used to specify how many elements are used for each FIFO/Buffer.
> +
> +                 M_CAN includes the following elements according to user manual:
> +                 11-bit Filter	0-128 elements / 0-128 words
> +                 29-bit Filter	0-64 elements / 0-128 words
> +                 Rx FIFO 0	0-64 elements / 0-1152 words
> +                 Rx FIFO 1	0-64 elements / 0-1152 words
> +                 Rx Buffers	0-64 elements / 0-1152 words
> +                 Tx Event FIFO	0-32 elements / 0-64 words
> +                 Tx Buffers	0-32 elements / 0-576 words
> +
> +                 Please refer to 2.4.1 Message RAM Configuration in Bosch
> +                 M_CAN user manual for details.
> +    allOf:
> +      - $ref: /schemas/types.yaml#/definitions/int32-matrix

Looks like uint32-array based on the constraints.

> +      - items:
> +         items:
> +           - description: The 'offset' is an address offset of the Message RAM
> +                          where the following elements start from. This is usually
> +                          set to 0x0 if you're using a private Message RAM.
> +             default: 0
> +           - description: 11-bit Filter 0-128 elements / 0-128 words
> +             minimum: 0
> +             maximum: 128
> +           - description: 29-bit Filter 0-64 elements / 0-128 words
> +             minimum: 0
> +             maximum: 64
> +           - description: Rx FIFO 0 0-64 elements / 0-1152 words
> +             minimum: 0
> +             maximum: 64
> +           - description: Rx FIFO 1 0-64 elements / 0-1152 words
> +             minimum: 0
> +             maximum: 64
> +           - description: Rx Buffers 0-64 elements / 0-1152 words
> +             minimum: 0
> +             maximum: 64
> +           - description: Tx Event FIFO 0-32 elements / 0-64 words
> +             minimum: 0
> +             maximum: 32
> +           - description: Tx Buffers 0-32 elements / 0-576 words
> +             minimum: 0
> +             maximum: 32
> +        maxItems: 1
> +
> +  can-transceiver:
> +    type: object
> +
> +    properties:
> +      max-bitrate:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        description: a positive non 0 value that determines the max speed that
> +                     CAN/CAN-FD can run.
> +        minimum: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - interrupts
> +  - interrupt-names
> +  - clocks
> +  - clock-names
> +  - bosch,mram-cfg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/imx6sx-clock.h>
> +    can@20e8000 {
> +      compatible = "bosch,m_can";
> +      reg = <0x020e8000 0x4000>, <0x02298000 0x4000>;
> +      reg-names = "m_can", "message_ram";
> +      interrupts = <0 114 0x04>, <0 114 0x04>;
> +      interrupt-names = "int0", "int1";
> +      clocks = <&clks IMX6SX_CLK_CANFD>,
> +               <&clks IMX6SX_CLK_CANFD>;
> +      clock-names = "hclk", "cclk";
> +      bosch,mram-cfg = <0x0 0 0 32 0 0 0 1>;
> +
> +      can-transceiver {
> +        max-bitrate = <5000000>;
> +      };
> +    };
> +
> +...
> -- 
> 2.15.0
> 
