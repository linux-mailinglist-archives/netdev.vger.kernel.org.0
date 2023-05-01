Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FA06F3B02
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 01:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbjEAXVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 19:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbjEAXV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 19:21:29 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223612D63;
        Mon,  1 May 2023 16:21:27 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 341NKt1D058631;
        Mon, 1 May 2023 18:20:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682983255;
        bh=Xmhleu14St0oAnzFVYD5xIrgI9Uu7DM9K/wGhipL9Vw=;
        h=Date:Subject:From:To:CC:References:In-Reply-To;
        b=QQ3coQPbxfKk7t/p5wnFlIYzL9r5yl2VMbXgBEVIGXF1Gw5lRCmIk3Yx2Om94MMBF
         b3NX0+igDQ+W2bnGRjgg/sjtEtq6iky6pXoAC8u05xcJivPP7OvLIOgpWs/7IX46bV
         PK1oJM/bImTD0Bfl3gQ52PKW0JKcFxVvmnsXc/nw=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 341NKt1b023951
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 1 May 2023 18:20:55 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 1
 May 2023 18:20:55 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 1 May 2023 18:20:55 -0500
Received: from [128.247.81.95] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 341NKt6i107254;
        Mon, 1 May 2023 18:20:55 -0500
Message-ID: <5ec79304-0339-517a-a5e6-92054eec2d2e@ti.com>
Date:   Mon, 1 May 2023 18:20:54 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 0/4] Enable multiple MCAN on AM62x
From:   Judith Mendez <jm@ti.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Simon Horman <simon.horman@corigine.com>
References: <20230501223121.21663-1-jm@ti.com>
Content-Language: en-US
In-Reply-To: <20230501223121.21663-1-jm@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

On 5/1/23 17:31, Judith Mendez wrote:
> On AM62x there is one MCAN in MAIN domain and two in MCU domain.
> The MCANs in MCU domain were not enabled since there is no
> hardware interrupt routed to A53 GIC interrupt controller.
> Therefore A53 Linux cannot be interrupted by MCU MCANs.
> 
> This solution instantiates a hrtimer with 1 ms polling interval
> for MCAN device when there is no hardware interrupt and there is
> poll-interval property in DTB MCAN node. The hrtimer generates a
> recurring software interrupt which allows to call the isr. The isr
> will check if there is pending transaction by reading a register
> and proceed normally if there is.
> 
> On AM62x, this series enables two MCU MCAN which will use the hrtimer
> implementation. MCANs with hardware interrupt routed to A53 Linux
> will continue to use the hardware interrupt as expected.
> 
> Timer polling method was tested on both classic CAN and CAN-FD
> at 125 KBPS, 250 KBPS, 1 MBPS and 2.5 MBPS with 4 MBPS bitrate
> switching.
> 
> Letency and CPU load benchmarks were tested on 3x MCAN on AM62x.
> 1 MBPS timer polling interval is the better timer polling interval
> since it has comparable latency to hardware interrupt with the worse
> case being 1ms + CAN frame propagation time and CPU load is not
> substantial. Latency can be improved further with less than 1 ms
> polling intervals, howerver it is at the cost of CPU usage since CPU
> load increases at 0.5 ms.
> 
> Note that in terms of power, enabling MCU MCANs with timer-polling
> implementation might have negative impact since we will have to wake
> up every 1 ms whether there are CAN packets pending in the RX FIFO or
> not. This might prevent the CPU from entering into deeper idle states
> for extended periods of time.
> 
> This patch series depends on 'Enable CAN PHY transceiver driver':
> Link: https://lore.kernel.org/lkml/775ec9ce-7668-429c-a977-6c8995968d6e@app.fastmail.com/T/
> 
> v2:
> Link: https://lore.kernel.org/linux-can/20230424195402.516-1-jm@ti.com/T/#t
> 
> V1:
> Link: https://lore.kernel.org/linux-can/19d8ae7f-7b74-a869-a818-93b74d106709@ti.com/T/#t
> 
> RFC:
> Link: https://lore.kernel.org/linux-can/52a37e51-4143-9017-42ee-8d17c67028e3@ti.com/T/#t
> 
> Changes since v2:
> - Change binding patch first
> - Update binding poll-interval description
> - Add oneOf to select either interrupts/interrupt-names or poll-interval
> - Sort list of includes
> - Create a define for 1 ms polling interval
> - Change plarform_get_irq to optional to not print error msg
> - Fix indentations, lengths of code lines, and added other style changes
> 
> Changes since v1:
> - Add poll-interval property to bindings and MCAN DTB node
> - Add functionality to check for 'poll-interval' property in MCAN node 
> - Bindings: add an example using poll-interval
> - Add 'polling' flag in driver to check if device is using polling method
> - Check for both timer polling and hardware interrupt case, default to
> hardware interrupt method
> - Change ns_to_ktime() to ms_to_ktime()

Please ignore this version v3, apologies for sending the wrong patches.

regards,
Judith






