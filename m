Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2778062B29
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 23:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732805AbfGHVil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 17:38:41 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35261 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730630AbfGHVil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 17:38:41 -0400
Received: by mail-io1-f68.google.com with SMTP id m24so29204261ioo.2;
        Mon, 08 Jul 2019 14:38:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=untM+Kv8ZutGAnkYCVkbqKxPIv+NhfYxHiB+6bSFjEE=;
        b=jabTb5LCFK3yoB+JVDBPjgrmd1zoyX2fjDcg1JitojN8WDaMF+cL6UgHAeqJAFJnen
         +ef8TEu+ockCaNq+uFawaiW90mxLmrALec77QHz1yJz0tNkQh6n9vs0pKuuqFwLtmMEP
         tNfc2zpDJ+bt1ZQjwirTR03yUexKDgUP6NwkMpxltlBq/wzUxS8YCEKGeQEBZNlq2Haw
         4+qsl2Pu+NDaJS6gvM6PPsb8dm2i8Qo6vmHBQZmKS3SwlWB41d/7p9rsMEClSNRA7Gpn
         IyctG44zTCid6qqjF2Y2GjorcxxuMZbFPwXOaP09j4Y9eFFiH4J/kYt7g8ipvmdkV+D9
         1Oyw==
X-Gm-Message-State: APjAAAWtZ/9BMskvpHPARyZ9cpeSicGkhHqZr1hEojM7ieQaDUvzLJ/H
        EjRqNlan5C3ZU9WS5XnfiA==
X-Google-Smtp-Source: APXvYqzGWdEgyQPIbLHBkjZ2Je6IlC+TiSD0JfeEEnJoe/Chs6bC5oSR97CEDOIUIm+cX6cVkJUNQQ==
X-Received: by 2002:a5d:940b:: with SMTP id v11mr5355941ion.69.1562621920210;
        Mon, 08 Jul 2019 14:38:40 -0700 (PDT)
Received: from localhost ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id w23sm33854623ioa.51.2019.07.08.14.38.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 14:38:39 -0700 (PDT)
Date:   Mon, 8 Jul 2019 15:38:37 -0600
From:   Rob Herring <robh@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH V5 net-next 4/6] dt-bindings: ptp: Introduce MII time
 stamping devices.
Message-ID: <20190708213837.GA28934@bogus>
References: <cover.1559281985.git.richardcochran@gmail.com>
 <d786656435c64160d50014beb3d3d9d1aaf6f22d.1559281985.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d786656435c64160d50014beb3d3d9d1aaf6f22d.1559281985.git.richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 10:56:24PM -0700, Richard Cochran wrote:
> This patch add a new binding that allows non-PHY MII time stamping
> devices to find their buses.  The new documentation covers both the
> generic binding and one upcoming user.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  Documentation/devicetree/bindings/ptp/ptp-ines.txt | 35 ++++++++++++++++++
>  .../devicetree/bindings/ptp/timestamper.txt        | 41 ++++++++++++++++++++++
>  2 files changed, 76 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ptp/ptp-ines.txt
>  create mode 100644 Documentation/devicetree/bindings/ptp/timestamper.txt
> 
> diff --git a/Documentation/devicetree/bindings/ptp/ptp-ines.txt b/Documentation/devicetree/bindings/ptp/ptp-ines.txt
> new file mode 100644
> index 000000000000..4dee9eb89455
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

This is an IP block that gets integrated into SoCs? It's not very 
specific given that there could be different versions of the IP block 
and SoC vendors can integrate various versions of the IP block in their 
own unique (i.e. buggy) way.

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
> +			phy@3 {

ethernet-phy is the correct node name.

> +				...
> +				timestamper = <&tstamper 0>;
> +			};
> +		};
> +	};
> diff --git a/Documentation/devicetree/bindings/ptp/timestamper.txt b/Documentation/devicetree/bindings/ptp/timestamper.txt
> new file mode 100644
> index 000000000000..88ea0bc7d662
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ptp/timestamper.txt
> @@ -0,0 +1,41 @@
> +Time stamps from MII bus snooping devices
> +
> +This binding supports non-PHY devices that snoop the MII bus and
> +provide time stamps.  In contrast to PHY time stamping drivers (which
> +can simply attach their interface directly to the PHY instance), stand
> +alone MII time stamping drivers use this binding to specify the
> +connection between the snooping device and a given network interface.
> +
> +Non-PHY MII time stamping drivers typically talk to the control
> +interface over another bus like I2C, SPI, UART, or via a memory mapped
> +peripheral.  This controller device is associated with one or more
> +time stamping channels, each of which snoops on a MII bus.
> +
> +The "timestamper" property lives in a phy node and links a time
> +stamping channel from the controller device to that phy's MII bus.
> +
> +Example:
> +
> +	tstamper: timestamper@10000000 {
> +		compatible = "bigcorp,ts-ctrl";

Would be better to use a real example here.

> +	};
> +
> +	ethernet@20000000 {
> +		mdio {
> +			phy@1 {
> +				timestamper = <&tstamper 0>;
> +			};
> +		};
> +	};
> +
> +	ethernet@30000000 {
> +		mdio {
> +			phy@2 {
> +				timestamper = <&tstamper 1>;
> +			};
> +		};
> +	};
> +
> +In this example, time stamps from the MII bus attached to phy@1 will
> +appear on time stamp channel 0 (zero), and those from phy@2 appear on
> +channel 1.
> -- 
> 2.11.0
> 
