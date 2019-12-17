Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 824EF122FEE
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbfLQPRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:17:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57558 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727756AbfLQPRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 10:17:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=y66LTNctU06qMoQJMhGK01LwiVWQsFjlTor1V8U/M9w=; b=MsOUtrVtfaCbVMQDsLN65yytmx
        lBQezlhYx+H8SB8Q1PkUmvlmle6Gw3FX/K9nFLpjWXLMluyxbCHpFSmJ3ru9DFdMSlKfzfgDnWQ0F
        ejc83k0Hg67VLgYDuI4urPYBGKlU58n4q/76VJK0RqfADR42VeuPoXVpzcYwWziOT8HI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ihEav-0002Jg-LL; Tue, 17 Dec 2019 16:17:05 +0100
Date:   Tue, 17 Dec 2019 16:17:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: Re: [PATCH V6 net-next 08/11] dt-bindings: ptp: Introduce MII time
 stamping devices.
Message-ID: <20191217151705.GF17965@lunn.ch>
References: <cover.1576511937.git.richardcochran@gmail.com>
 <f74e71626f6c9115ab9cf919cc8eaed10220ecb2.1576511937.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f74e71626f6c9115ab9cf919cc8eaed10220ecb2.1576511937.git.richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 08:13:23AM -0800, Richard Cochran wrote:
> This patch add a new binding that allows non-PHY MII time stamping
> devices to find their buses.  The new documentation covers both the
> generic binding and one upcoming user.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Rob might want YAML?

    



> ---
>  .../devicetree/bindings/ptp/ptp-ines.txt      | 35 ++++++++++++++++
>  .../devicetree/bindings/ptp/timestamper.txt   | 41 +++++++++++++++++++
>  2 files changed, 76 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ptp/ptp-ines.txt
>  create mode 100644 Documentation/devicetree/bindings/ptp/timestamper.txt
> 
> diff --git a/Documentation/devicetree/bindings/ptp/ptp-ines.txt b/Documentation/devicetree/bindings/ptp/ptp-ines.txt
> new file mode 100644
> index 000000000000..4c242bd1ce9c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ptp/ptp-ines.txt
> @@ -0,0 +1,35 @@
> +ZHAW InES PTP time stamping IP core
> +
> +The IP core needs two different kinds of nodes.  The control node
> +lives somewhere in the memory map and specifies the address of the
> +control registers.  There can be up to three port handles placed as
> +attributes of PHY nodes.  These associate a particular MII bus with a
> +port index within the IP core.
> +
> +Required properties of the control node:
> +
> +- compatible:		"ines,ptp-ctrl"
> +- reg:			physical address and size of the register bank
> +
> +Required format of the port handle within the PHY node:
> +
> +- timestamper:		provides control node reference and
> +			the port channel within the IP core
> +
> +Example:
> +
> +	tstamper: timestamper@60000000 {
> +		compatible = "ines,ptp-ctrl";
> +		reg = <0x60000000 0x80>;
> +	};
> +
> +	ethernet@80000000 {
> +		...
> +		mdio {
> +			...
> +			ethernet-phy@3 {
> +				...
> +				timestamper = <&tstamper 0>;

You should also add this to Documentation/devicetree/bindings/net/ethernet-phy.yaml

    Andrew
