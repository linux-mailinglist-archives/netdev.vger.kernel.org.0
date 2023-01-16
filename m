Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C7366C5B5
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 17:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbjAPQJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 11:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbjAPQIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 11:08:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF8810ABD;
        Mon, 16 Jan 2023 08:05:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 969A4B81076;
        Mon, 16 Jan 2023 16:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F358C433F0;
        Mon, 16 Jan 2023 16:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673885155;
        bh=0KtEDg8V8xDJAhV2tBIlcsqXgQXnJC0hSuhkHdMLGfQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=jSemuxetuOVHS8Pu56sFFfjfqcB1KYHNqAy5QYjkqdoNImbbJWxc7ZCq+/8HagJjT
         jUzRIz+noj9vYk3bsAQi1xXV+tKh4bWariBbu64cQs+6DRJuqpYtc7VLqTq5xrGlw2
         6Xi/OHZ62Uq4XJPNcC4UsNrTUNxiwB7V6GAHEcul13wujXTPamyq65nItHnZ7NeueC
         UdUA4m04FBOhjQS8zilWEUfkvqoDyXN75QsUYtsoAHqpyL+imGRyb9kBPJkyPAyPv0
         b8EoXm1guahtqBvINwcxz3JbqxfrgwWPP8kIXmG5A03U9pSYK64UX+muyNrlnpt4DK
         dTPwrZym+NRCA==
Message-ID: <2007adb5-0980-eee3-8d2f-e30183cf408e@kernel.org>
Date:   Mon, 16 Jan 2023 18:05:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 5/5] arm64: dts: ti: k3-am625-sk: Add cpsw3g cpts
 PPS support
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        nm@ti.com, kristo@kernel.org, vigneshr@ti.com, nsekhar@ti.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
References: <20230111114429.1297557-1-s-vadapalli@ti.com>
 <20230111114429.1297557-6-s-vadapalli@ti.com>
 <6ae650c9-d68d-d2fc-8319-b7784cd2a749@kernel.org>
 <a889a47f-5f44-1ae6-1ab7-3b7e7011b4f7@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <a889a47f-5f44-1ae6-1ab7-3b7e7011b4f7@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/01/2023 09:12, Siddharth Vadapalli wrote:
> Roger,
> 
> On 13/01/23 15:48, Roger Quadros wrote:
>> Hi,
>>
>> On 11/01/2023 13:44, Siddharth Vadapalli wrote:
>>> The CPTS driver is capable of configuring GENFy (Periodic Signal Generator
>>> Function) present in the CPTS module, to generate periodic output signals
>>> with a custom time period. In order to generate a PPS signal on the GENFy
>>> output, the device-tree property "ti,pps" has to be used. The "ti,pps"
>>> property is used to declare the mapping between the CPTS HWx_TS_PUSH
>>> (Hardware Timestamp trigger) input and the GENFy output that is configured
>>> to generate a PPS signal. The mapping is of the form:
>>> <x-1 y>
>>> where the value x corresponds to HWx_TS_PUSH input (1-based indexing) and
>>> the value y corresponds to GENFy (0-based indexing).
>>
>> You mean there is no HWx_TX_PUSH0 pin? so user needs to use 0 for HWx_TX_PUSH1 pin?
> 
> The HWx_TX_PUSH pins correspond to the cpts_hw1_push, cpts_hw2_push,...,
> cpts_hw8_push pins. The names are documented at:
> 
> Link:
> https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/am62x/interrupt_cfg.html#timesync-event-router0-interrupt-router-output-destinations
> 
> Thus, considering that the documentation uses 1-based indexing, I wanted to
> indicate that the driver expects 0-based indexing, and therefore the user would
> have to provide (x-1) for cpsw_hwx_push pin.
> 
>>
>> Can you please define macros for HWx_TS_PUSH and GENFy so we avoid
>> human error with this different indexing methods?
>>
>> DT should contain the name exactly in hardware.
>>
>> So if pin is called HWx_TX_PUSH1 in hardware then DT should contain HWx_TX_PUSH(1).
> 
> The pins are called HW1_TX_PUSH, HW2_TX_PUSH and so on. This 1-based indexing is
> followed in the Technical Reference Manual. Similarly, the documentation in the
> link above also uses 1-based indexing: cpts_hw1_push, cpts_hw2_push, and so on.
> 
> However, for the GENFy pins, the documentation consistently uses 0-based
> indexing. Thus, the driver expects indices that are 0-based and the user is
> expected to convert the x to x-1 for the HWx_TX_PUSH pins while the y in GENFy
> pins can be used directly as it is already 0-based indexing.
> 
>>
>>>
>>> To verify that the signal is a PPS signal, the GENFy output signal is fed
>>> into the CPTS HWx_TS_PUSH input, which generates a timestamp event on the
>>> rising edge of the GENFy signal. The GENFy output signal can be routed to
>>> the HWx_TS_PUSH input by using the Time Sync Router. This is done by
>>> mentioning the mapping between the GENFy output and the HWx_TS_PUSH input
>>> within the "timesync_router" device-tree node.
>>>
>>> The Input Sources to the Time Sync Router are documented at: [1]
>>> The Output Destinations of the Time Sync Router are documented at: [2]
>>>
>>> The PPS signal can be verified using testptp and ppstest tools as follows:
>>>  # ./testptp -d /dev/ptp0 -P 1
>>>  pps for system time request okay
>>>  # ./ppstest /dev/pps0
>>>  trying PPS source "/dev/pps0"
>>>  found PPS source "/dev/pps0"
>>>  ok, found 1 source(s), now start fetching data...
>>>  source 0 - assert 48.000000013, sequence: 8 - clear  0.000000000, sequence: 0
>>>  source 0 - assert 49.000000013, sequence: 9 - clear  0.000000000, sequence: 0
>>>  source 0 - assert 50.000000013, sequence: 10 - clear  0.000000000, sequence: 0
>>>
>>> Add an example in the device-tree, enabling PPS generation on GENF1. The
>>> HW3_TS_PUSH Timestamp trigger input is used to verify the PPS signal.
>>>
>>> [1]
>>> Link: https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/am62x/interrupt_cfg.html#timesync-event-router0-interrupt-router-input-sources
>>> [2]
>>> Link: https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/am62x/interrupt_cfg.html#timesync-event-router0-interrupt-router-output-destinations
>>>
>>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>>> ---
>>>  arch/arm64/boot/dts/ti/k3-am625-sk.dts | 20 ++++++++++++++++++++
>>>  1 file changed, 20 insertions(+)
>>>
>>> diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk.dts b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
>>> index 4f179b146cab..962a922cc94b 100644
>>> --- a/arch/arm64/boot/dts/ti/k3-am625-sk.dts
>>> +++ b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
>>> @@ -366,6 +366,10 @@ &cpsw3g {
>>>  	pinctrl-names = "default";
>>>  	pinctrl-0 = <&main_rgmii1_pins_default
>>>  		     &main_rgmii2_pins_default>;
>>> +
>>> +	cpts@3d000 {
>>> +		ti,pps = <2 1>;
>>> +	};
>>>  };
>>>  
>>>  &cpsw_port1 {
>>> @@ -464,3 +468,19 @@ partition@3fc0000 {
>>>  		};
>>>  	};
>>>  };
>>> +
>>> +#define TS_OFFSET(pa, val)	(0x4+(pa)*4) (0x10000 | val)
>>
>> Should this go in ./include/dt-bindings/pinctrl/k3.h ?
>> That way every board DT file doesn't have to define it.
>>
>> The name should be made more platform specific.
>> e.g. K3_TS_OFFSET if it is the same for all K3 platforms.
>> If not then please add Platform name instead of K3.
> 
> The offsets are board specific. If it is acceptable, I will add board specific
> macro for the TS_OFFSET definition in the ./include/dt-bindings/pinctrl/k3.h
> file. Please let me know.

If it is board specific then it should remain in the board file.

cheers,
-roger
