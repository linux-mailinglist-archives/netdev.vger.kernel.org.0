Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213B3337CEA
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhCKSrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:47:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40828 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhCKSre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 13:47:34 -0500
Received: from mail-wm1-f70.google.com ([209.85.128.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lKQLM-0003UF-BW
        for netdev@vger.kernel.org; Thu, 11 Mar 2021 18:47:32 +0000
Received: by mail-wm1-f70.google.com with SMTP id s192so4404569wme.6
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 10:47:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AGhsYhdCQ1elD24yTKdnrXd5i7xOjzN52nW5SEJ7/Fo=;
        b=SfN2Jzo3Tt1399Los3KroFbZUmpwRbbytG/bTmVO24qCAP8Jai4tTZQo/wkLqawGM9
         oP0q8U2tWjduZF01f9Im7ZB0cx29DlBnsUW9Lcb08i1AipXllhY669tf5BpuatTQ3Gci
         b6m3gKY7iovL8nAgN3/pf7zZPskMsJfO81hEqGuOs/ZYPn92639OPSkEdUMnKToT/OJw
         ncAnFcHuZsU7bDXf2Y485ZpiFbfyQN59DcEJNExnbbmsiVKfA3hs+CrSp4LYC0mm/zKF
         cZ/m0Fvho0izbzjY9+X9hHWySMEHTHewAO4ZjqXpwJJH85sRQGskmf1YTWieepEJUvCO
         15BA==
X-Gm-Message-State: AOAM533zD7eDl6qfPTnqRrygpGXJ0tyPV4GlOg0qWMQJr7aUhBDdqBWb
        MaHrx92zPsrKN3o76NREYRg4dXo0J3rVcXBspkbFOh8CHLiRqajv5uu9csMq7cANtrpwwWnB32X
        zasQEZ5UxBsEl2cCkuDdtZmmm6fd4q1GL/w==
X-Received: by 2002:a5d:5141:: with SMTP id u1mr10282898wrt.31.1615488451951;
        Thu, 11 Mar 2021 10:47:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzEiONe/luicUkBQrryf9RIkvIG+x8+UJPcdgITbiuaICznSQKmKVThfd4wAkfQtdO2oa9H6A==
X-Received: by 2002:a5d:5141:: with SMTP id u1mr10282871wrt.31.1615488451652;
        Thu, 11 Mar 2021 10:47:31 -0800 (PST)
Received: from [192.168.1.116] (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id h6sm4972118wmi.6.2021.03.11.10.47.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 10:47:31 -0800 (PST)
Subject: Re: [PATCH v3 00/15] arm64 / clk: socfpga: simplifying, cleanups and
 compile testing
To:     Tom Rix <trix@redhat.com>, Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Moritz Fischer <mdf@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-fpga@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
References: <20210311152545.1317581-1-krzysztof.kozlowski@canonical.com>
 <f0b90916-9047-d5da-5cde-75d4330cf041@redhat.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <f581f103-270f-90ed-6946-de63b6712e82@canonical.com>
Date:   Thu, 11 Mar 2021 19:47:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <f0b90916-9047-d5da-5cde-75d4330cf041@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/03/2021 19:26, Tom Rix wrote:
> 
> On 3/11/21 7:25 AM, Krzysztof Kozlowski wrote:
>> Hi,
>>
>> All three Intel arm64 SoCFPGA architectures (Agilex, N5X and Stratix 10)
>> are basically flavors/platforms of the same architecture.  At least from
>> the Linux point of view.  Up to a point that N5X and Agilex share DTSI.
>> Having three top-level architectures for the same one barely makes
>> sense and complicates driver selection.
>>
>> Additionally it was pointed out that ARCH_SOCFPGA name is too generic.
>> There are other vendors making SoC+FPGA designs, so the name should be
>> changed to have real vendor (currently: Intel).
>>
>>
>> Dependencies / merging
>> ======================
>> 1. Patch 1 is used as base, so other changes depend on its hunks.
>>    I put it at beginning as it is something close to a fix, so candidate
>>    for stable (even though I did not mark it like that).
>> 2. Patch 2: everything depends on it.
>>
>> 3. 64-bit path:
>> 3a. Patches 3-7: depend on patch 2, from 64-bit point of view.
>> 3b. Patch 8: depends on 2-7 as it finally removes 64-bit ARCH_XXX
>>     symbols.
>>
>> 4. 32-bit path:
>> 4a. Patches 9-14: depend on 2, from 32-bit point of view.
>> 4b. Patch 15: depends on 9-14 as it finally removes 32-bit ARCH_SOCFPGA
>>     symbol.
>>
>> If the patches look good, proposed merging is via SoC tree (after
>> getting acks from everyone). Sharing immutable branches is also a way.
>>
>>
>> Changes since v2
>> ================
>> 1. Several new patches and changes.
>> 2. Rename ARCH_SOCFPGA to ARCH_INTEL_SOCFPGA on 32-bit and 64-bit.
>> 3. Enable compile testing of 32-bit socfpga clock drivers.
>> 4. Split changes per subsystems for easier review.
>> 5. I already received an ack from Lee Jones, but I did not add it as
>>    there was big refactoring.  Please kindly ack one more time if it
>>    looks good.
>>
>> Changes since v1
>> ================
>> 1. New patch 3: arm64: socfpga: rename ARCH_STRATIX10 to ARCH_SOCFPGA64.
>> 2. New patch 4: arm64: intel: merge Agilex and N5X into ARCH_SOCFPGA64.
>> 3. Fix build is.sue reported by kernel test robot (with ARCH_STRATIX10
>>    and COMPILE_TEST but without selecting some of the clocks).
>>
>>
>> RFT
>> ===
>> I tested compile builds on few configurations, so I hope kbuild 0-day
>> will check more options (please give it few days on the lists).
>> I compare the generated autoconf.h and found no issues.  Testing on real
>> hardware would be appreciated.
>>
>> Best regards,
>> Krzysztof
>>
>> Krzysztof Kozlowski (15):
>>   clk: socfpga: allow building N5X clocks with ARCH_N5X
>>   ARM: socfpga: introduce common ARCH_INTEL_SOCFPGA
>>   mfd: altera: merge ARCH_SOCFPGA and ARCH_STRATIX10
>>   net: stmmac: merge ARCH_SOCFPGA and ARCH_STRATIX10
>>   clk: socfpga: build together Stratix 10, Agilex and N5X clock drivers
>>   clk: socfpga: merge ARCH_SOCFPGA and ARCH_STRATIX10
>>   EDAC: altera: merge ARCH_SOCFPGA and ARCH_STRATIX10
>>   arm64: socfpga: merge Agilex and N5X into ARCH_INTEL_SOCFPGA
>>   clk: socfpga: allow compile testing of Stratix 10 / Agilex clocks
>>   clk: socfpga: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs (and
>>     compile test)
>>   dmaengine: socfpga: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs
>>   fpga: altera: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs
>>   i2c: altera: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs
>>   reset: socfpga: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs
>>   ARM: socfpga: drop ARCH_SOCFPGA
>>
>>  arch/arm/Kconfig                            |  2 +-
>>  arch/arm/Kconfig.debug                      |  6 +++---
>>  arch/arm/Makefile                           |  2 +-
>>  arch/arm/boot/dts/Makefile                  |  2 +-
>>  arch/arm/configs/multi_v7_defconfig         |  2 +-
>>  arch/arm/configs/socfpga_defconfig          |  2 +-
>>  arch/arm/mach-socfpga/Kconfig               |  4 ++--
>>  arch/arm64/Kconfig.platforms                | 17 ++++-------------
>>  arch/arm64/boot/dts/altera/Makefile         |  2 +-
>>  arch/arm64/boot/dts/intel/Makefile          |  6 +++---
>>  arch/arm64/configs/defconfig                |  3 +--
>>  drivers/clk/Kconfig                         |  1 +
>>  drivers/clk/Makefile                        |  4 +---
>>  drivers/clk/socfpga/Kconfig                 | 19 +++++++++++++++++++
>>  drivers/clk/socfpga/Makefile                | 11 +++++------
>>  drivers/dma/Kconfig                         |  2 +-
>>  drivers/edac/Kconfig                        |  2 +-
>>  drivers/edac/altera_edac.c                  | 17 +++++++++++------
>>  drivers/firmware/Kconfig                    |  2 +-
>>  drivers/fpga/Kconfig                        |  8 ++++----
>>  drivers/i2c/busses/Kconfig                  |  2 +-
>>  drivers/mfd/Kconfig                         |  4 ++--
>>  drivers/net/ethernet/stmicro/stmmac/Kconfig |  4 ++--
>>  drivers/reset/Kconfig                       |  6 +++---
>>  24 files changed, 71 insertions(+), 59 deletions(-)
>>  create mode 100644 drivers/clk/socfpga/Kconfig
>>
> Thanks for changing the config name.
> 
> Please review checkpatch --strict on this set, the typical complaint is
> 
> clk: socfpga: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs (and compile test)    
> WARNING: please write a paragraph that describes the config symbol fully
> #35: FILE: drivers/clk/socfpg/Kconfig:11:                       
> +config CLK_INTEL_SOCFPGA32

This symbol is not visible to the user, not selectable, so documenting
it more than what is already written in option title (the one going
after "bool") makes little sense. We don't do it for such drivers.
Mostly because it would be duplication of the option title or include
useless information (it's like documenting "int i" with "counter used
for loop"). The checkpatch complains if this is less than three lines,
but it is not possible to write here anything meaningful for more than
one line.

Really, it does not make sense. If you think otherwise, please suggest
the text which is not duplicating option title and does not include
common stuff from clocks.

Best regards,
Krzysztof
