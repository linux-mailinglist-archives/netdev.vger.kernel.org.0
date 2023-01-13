Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11FF66693E7
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 11:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240960AbjAMKTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 05:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjAMKSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 05:18:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5A26878B;
        Fri, 13 Jan 2023 02:18:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D5876117E;
        Fri, 13 Jan 2023 10:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E31C433EF;
        Fri, 13 Jan 2023 10:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673605123;
        bh=sUKOlNUy/idpXauShp//31+R4ncJrtV2+7nCN6c80Bw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=IszNHv9GKOjTegRQgaSb1/E4juCNlcVjleK93m5v3jBwImySUNURMWYM7ax0Y7/6X
         nmPebdNbodjU3Vy+MpFn63FEKn3mHX+qjIz2edbM9svn8u9w2ZSfFH/2aQtmBJMfqq
         2voienLWONXMzpfGYHi+1xO6nk5wHACmz028e8dPOBIUykjG0rJT96b/5Cpjl+SrUq
         TQ3b0yvScMLRzSqTDvRoqhnCfHzKt2hjrom5C8lvlR7/A/zqemG2t2ZDiqnJTPdftI
         BbbXq1zA9zEjBLx00ZaGJ5rtjDAqg0BhCejdMbEH5LIFmrRbt/gr2MFX8tc8MGC65Z
         /JFoxQjmjmcAQ==
Message-ID: <6ae650c9-d68d-d2fc-8319-b7784cd2a749@kernel.org>
Date:   Fri, 13 Jan 2023 12:18:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 5/5] arm64: dts: ti: k3-am625-sk: Add cpsw3g cpts
 PPS support
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski@linaro.org,
        krzysztof.kozlowski+dt@linaro.org, nm@ti.com, kristo@kernel.org,
        vigneshr@ti.com, nsekhar@ti.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
References: <20230111114429.1297557-1-s-vadapalli@ti.com>
 <20230111114429.1297557-6-s-vadapalli@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230111114429.1297557-6-s-vadapalli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 11/01/2023 13:44, Siddharth Vadapalli wrote:
> The CPTS driver is capable of configuring GENFy (Periodic Signal Generator
> Function) present in the CPTS module, to generate periodic output signals
> with a custom time period. In order to generate a PPS signal on the GENFy
> output, the device-tree property "ti,pps" has to be used. The "ti,pps"
> property is used to declare the mapping between the CPTS HWx_TS_PUSH
> (Hardware Timestamp trigger) input and the GENFy output that is configured
> to generate a PPS signal. The mapping is of the form:
> <x-1 y>
> where the value x corresponds to HWx_TS_PUSH input (1-based indexing) and
> the value y corresponds to GENFy (0-based indexing).

You mean there is no HWx_TX_PUSH0 pin? so user needs to use 0 for HWx_TX_PUSH1 pin?

Can you please define macros for HWx_TS_PUSH and GENFy so we avoid
human error with this different indexing methods?

DT should contain the name exactly in hardware.

So if pin is called HWx_TX_PUSH1 in hardware then DT should contain HWx_TX_PUSH(1).

> 
> To verify that the signal is a PPS signal, the GENFy output signal is fed
> into the CPTS HWx_TS_PUSH input, which generates a timestamp event on the
> rising edge of the GENFy signal. The GENFy output signal can be routed to
> the HWx_TS_PUSH input by using the Time Sync Router. This is done by
> mentioning the mapping between the GENFy output and the HWx_TS_PUSH input
> within the "timesync_router" device-tree node.
> 
> The Input Sources to the Time Sync Router are documented at: [1]
> The Output Destinations of the Time Sync Router are documented at: [2]
> 
> The PPS signal can be verified using testptp and ppstest tools as follows:
>  # ./testptp -d /dev/ptp0 -P 1
>  pps for system time request okay
>  # ./ppstest /dev/pps0
>  trying PPS source "/dev/pps0"
>  found PPS source "/dev/pps0"
>  ok, found 1 source(s), now start fetching data...
>  source 0 - assert 48.000000013, sequence: 8 - clear  0.000000000, sequence: 0
>  source 0 - assert 49.000000013, sequence: 9 - clear  0.000000000, sequence: 0
>  source 0 - assert 50.000000013, sequence: 10 - clear  0.000000000, sequence: 0
> 
> Add an example in the device-tree, enabling PPS generation on GENF1. The
> HW3_TS_PUSH Timestamp trigger input is used to verify the PPS signal.
> 
> [1]
> Link: https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/am62x/interrupt_cfg.html#timesync-event-router0-interrupt-router-input-sources
> [2]
> Link: https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/am62x/interrupt_cfg.html#timesync-event-router0-interrupt-router-output-destinations
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  arch/arm64/boot/dts/ti/k3-am625-sk.dts | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk.dts b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
> index 4f179b146cab..962a922cc94b 100644
> --- a/arch/arm64/boot/dts/ti/k3-am625-sk.dts
> +++ b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
> @@ -366,6 +366,10 @@ &cpsw3g {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&main_rgmii1_pins_default
>  		     &main_rgmii2_pins_default>;
> +
> +	cpts@3d000 {
> +		ti,pps = <2 1>;
> +	};
>  };
>  
>  &cpsw_port1 {
> @@ -464,3 +468,19 @@ partition@3fc0000 {
>  		};
>  	};
>  };
> +
> +#define TS_OFFSET(pa, val)	(0x4+(pa)*4) (0x10000 | val)

Should this go in ./include/dt-bindings/pinctrl/k3.h ?
That way every board DT file doesn't have to define it.

The name should be made more platform specific.
e.g. K3_TS_OFFSET if it is the same for all K3 platforms.
If not then please add Platform name instead of K3.

> +
> +&timesync_router {
> +	status = "okay";
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&cpsw_cpts>;
> +
> +	/* Example of the timesync routing */
> +	cpsw_cpts: cpsw-cpts {
> +		pinctrl-single,pins = <
> +			/* pps [cpsw cpts genf1] in17 -> out12 [cpsw cpts hw3_push] */
> +			TS_OFFSET(12, 17)
> +			>;
> +	};
> +};

cheers,
-roger
