Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFC66C3054
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjCULZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbjCULZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:25:33 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD73DD1
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:25:28 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r11so58258529edd.5
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google; t=1679397927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=phIyHpsboecY5RF5OBRqLn8uD/J3lWi4Rc69PpJL5Bc=;
        b=GOcT/9E5+QYltXqEh/dnICjtYW7yCmPKBm2EtWGJ2KkivTzQb5X6RHoulXGWOGS8Cl
         zb0ZZbJ7k2XxfnFr0mQGPxIyxzjGZJ0c4IDGNR2S6awnGK47ng8cLMHtGLNstbimNG2d
         I0eb2jOUlD0vu01fKd9E3IerqNuQjHFW1taOc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679397927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=phIyHpsboecY5RF5OBRqLn8uD/J3lWi4Rc69PpJL5Bc=;
        b=t0UwkSyj2C9L4zq+2K2GTe5tGauCFYxqa5pZNlLsbhXsB0qh3FhRCoFPkaHpxMxFZy
         He8QMm+k7LQdwulkREZBzFp9xFTSmNuK34rNN0PWJbcuACaAC4uKYN1K1zTOZG9WQiFi
         SsSaUwUMs2PnoPZHVQ2b3+HnUa0G/N29UNayNNAhdM50GC6OGFWjjKJCzjft8bT1vBHz
         gpw2JvK+XQ5MpvNPDO6hheesgHborztNuMgpcTmfbVfAgwjhPa9gNYEl7k+I8GzWoufR
         RbiXMgzznHHCnhIA1NLHOcBkum4zVZiHAHUkgPGPq2NDJ7kMs4C/VZsMkV5hujGGo2jJ
         kyTw==
X-Gm-Message-State: AO0yUKUihSGn7tcrAxNdnhRgBh2bcNpxhczN9NBrXcfiH8sH1Q+ftEZI
        mzuGNBbrkbh/UR9gLdBMRSteP0Wo4+1HjeyovpIsjQ==
X-Google-Smtp-Source: AK7set91VuwaUepd7Vt3K1fy1d/n7st/TOfB6tvcTnmo2f/H/2B2br/upz782ZAOuj+JinSHfZMAFAZjLIw4q7lDiHQ=
X-Received: by 2002:a05:6402:2550:b0:4af:62ad:6099 with SMTP id
 l16-20020a056402255000b004af62ad6099mr10473403edb.2.1679397927156; Tue, 21
 Mar 2023 04:25:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230315211040.2455855-1-dario.binacchi@amarulasolutions.com>
In-Reply-To: <20230315211040.2455855-1-dario.binacchi@amarulasolutions.com>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Tue, 21 Mar 2023 12:25:15 +0100
Message-ID: <CABGWkvpHHLNzZHDMzWveoHtApmR3czVvoCOnuWBZt-UoLVU-6g@mail.gmail.com>
Subject: Re: [RESEND PATCH v7 0/5] can: bxcan: add support for ST bxCAN controller
To:     linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh@kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        michael@amarulasolutions.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A gentle ping to remind you of this series.
I have no idea why it hasn't deserved any response for quite some
time.
Is there anything I am still missing?

Please let me know.

Thanks and regards,

Dario


On Wed, Mar 15, 2023 at 10:10=E2=80=AFPM Dario Binacchi
<dario.binacchi@amarulasolutions.com> wrote:
>
> The series adds support for the basic extended CAN controller (bxCAN)
> found in many low- to middle-end STM32 SoCs.
>
> The driver design (one core module and one driver module) was inspired
> by other ST drivers (e. g. drivers/iio/adc/stm32-adc.c,
> drivers/iio/adc/stm32-adc-core.c) where device instances share resources.
> The shared resources functions are implemented in the core module, the
> device driver in a separate module.
>
> The driver has been tested on the stm32f469i-discovery board with a
> kernel version 5.19.0-rc2 in loopback + silent mode:
>
> ip link set can0 type can bitrate 125000 loopback on listen-only on
> ip link set up can0
> candump can0 -L &
> cansend can0 300#AC.AB.AD.AE.75.49.AD.D1
>
> For uboot and kernel compilation, as well as for rootfs creation I used
> buildroot:
>
> make stm32f469_disco_sd_defconfig
> make
>
> but I had to patch can-utils and busybox as can-utils and iproute are
> not compiled for MMU-less microcotrollers. In the case of can-utils,
> replacing the calls to fork() with vfork(), I was able to compile the
> package with working candump and cansend applications, while in the
> case of iproute, I ran into more than one problem and finally I decided
> to extend busybox's ip link command for CAN-type devices. I'm still
> wondering if it was really necessary, but this way I was able to test
> the driver.
>
> Changes in v7:
> - Add Vincent Mailhol's Reviewed-by tag.
> - Remove all unused macros for reading/writing the controller registers.
> - Add CAN_ERR_CNT flag to notify availability of error counter.
> - Move the "break" before the newline in the switch/case statements.
> - Print the mnemotechnic instead of the error value in each netdev_err().
> - Remove the debug print for timings parameter.
> - Do not copy the data if CAN_RTR_FLAG is set in bxcan_start_xmit().
> - Populate ndev->ethtool_ops with the default timestamp info.
>
> Changes in v6:
> - move can1 node before gcan to keep ordering by address.
>
> Changes in v5:
> - Add Rob Herring's Acked-by tag.
> - Add Rob Herring's Reviewed-by tag.
> - Put static in front of bxcan_enable_filters() definition.
>
> Changes in v4:
> - Remove "st,stm32f4-bxcan-core" compatible. In this way the can nodes
>  (compatible "st,stm32f4-bxcan") are no longer children of a parent
>   node with compatible "st,stm32f4-bxcan-core".
> - Add the "st,gcan" property (global can memory) to can nodes which
>   references a "syscon" node containing the shared clock and memory
>   addresses.
> - Replace the node can@40006400 (compatible "st,stm32f4-bxcan-core")
>   with the gcan@40006600 node ("sysnode" compatible). The gcan node
>   contains clocks and memory addresses shared by the two can nodes
>   of which it's no longer the parent.
> - Add to can nodes the "st,gcan" property (global can memory) which
>   references the gcan@40006600 node ("sysnode compatibble).
> - Add "dt-bindings: arm: stm32: add compatible for syscon gcan node" patc=
h.
> - Drop the core driver. Thus bxcan-drv.c has been renamed to bxcan.c and
>   moved to the drivers/net/can folder. The drivers/net/can/bxcan director=
y
>   has therefore been removed.
> - Use the regmap_*() functions to access the shared memory registers.
> - Use spinlock to protect bxcan_rmw().
> - Use 1 space, instead of tabs, in the macros definition.
> - Drop clock ref-counting.
> - Drop unused code.
> - Drop the _SHIFT macros and use FIELD_GET()/FIELD_PREP() directly.
> - Add BXCAN_ prefix to lec error codes.
> - Add the macro BXCAN_RX_MB_NUM.
> - Enable time triggered mode and use can_rx_offload().
> - Use readx_poll_timeout() in function with timeouts.
> - Loop from tail to head in bxcan_tx_isr().
> - Check bits of tsr register instead of pkts variable in bxcan_tx_isr().
> - Don't return from bxcan_handle_state_change() if skb/cf are NULL.
> - Enable/disable the generation of the bus error interrupt depending
>   on can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING.
> - Don't return from bxcan_handle_bus_err() if skb is NULL.
> - Drop statistics updating from bxcan_handle_bus_err().
> - Add an empty line in front of 'return IRQ_HANDLED;'
> - Rename bxcan_start() to bxcan_chip_start().
> - Rename bxcan_stop() to bxcan_chip_stop().
> - Disable all IRQs in bxcan_chip_stop().
> - Rename bxcan_close() to bxcan_ndo_stop().
> - Use writel instead of bxcan_rmw() to update the dlc register.
>
> Changes in v3:
> - Remove 'Dario Binacchi <dariobin@libero.it>' SOB.
> - Add description to the parent of the two child nodes.
> - Move "patterProperties:" after "properties: in top level before "requir=
ed".
> - Add "clocks" to the "required:" list of the child nodes.
> - Remove 'Dario Binacchi <dariobin@libero.it>' SOB.
> - Add "clocks" to can@0 node.
> - Remove 'Dario Binacchi <dariobin@libero.it>' SOB.
> - Remove a blank line.
> - Remove 'Dario Binacchi <dariobin@libero.it>' SOB.
> - Fix the documentation file path in the MAINTAINERS entry.
> - Do not increment the "stats->rx_bytes" if the frame is remote.
> - Remove pr_debug() call from bxcan_rmw().
>
> Changes in v2:
> - Change the file name into 'st,stm32-bxcan-core.yaml'.
> - Rename compatibles:
>   - st,stm32-bxcan-core -> st,stm32f4-bxcan-core
>   - st,stm32-bxcan -> st,stm32f4-bxcan
> - Rename master property to st,can-master.
> - Remove the status property from the example.
> - Put the node child properties as required.
> - Remove a blank line.
> - Fix sparse errors.
> - Create a MAINTAINERS entry.
> - Remove the print of the registers address.
> - Remove the volatile keyword from bxcan_rmw().
> - Use tx ring algorithm to manage tx mailboxes.
> - Use can_{get|put}_echo_skb().
> - Update DT properties.
>
> Dario Binacchi (5):
>   dt-bindings: arm: stm32: add compatible for syscon gcan node
>   dt-bindings: net: can: add STM32 bxcan DT bindings
>   ARM: dts: stm32: add CAN support on stm32f429
>   ARM: dts: stm32: add pin map for CAN controller on stm32f4
>   can: bxcan: add support for ST bxCAN controller
>
>  .../bindings/arm/stm32/st,stm32-syscon.yaml   |    2 +
>  .../bindings/net/can/st,stm32-bxcan.yaml      |   83 ++
>  MAINTAINERS                                   |    7 +
>  arch/arm/boot/dts/stm32f4-pinctrl.dtsi        |   30 +
>  arch/arm/boot/dts/stm32f429.dtsi              |   29 +
>  drivers/net/can/Kconfig                       |   12 +
>  drivers/net/can/Makefile                      |    1 +
>  drivers/net/can/bxcan.c                       | 1088 +++++++++++++++++
>  8 files changed, 1252 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-bx=
can.yaml
>  create mode 100644 drivers/net/can/bxcan.c
>
> --
> 2.32.0
>


--=20

Dario Binacchi

Senior Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com
