Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2466E5636A3
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 17:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiGAPJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 11:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiGAPJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 11:09:00 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC7952655C;
        Fri,  1 Jul 2022 08:08:55 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19C17113E;
        Fri,  1 Jul 2022 08:08:55 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F3BE3F66F;
        Fri,  1 Jul 2022 08:08:51 -0700 (PDT)
Date:   Fri, 1 Jul 2022 16:08:48 +0100
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Tony Lindgren <tony@atomide.com>, Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>
Subject: Re: [PATCH v2 1/9] PM: domains: Delete usage of
 driver_deferred_probe_check_state()
Message-ID: <20220701150848.75eeprptmb5beip7@bogus>
References: <YrQP3OZbe8aCQxKU@atomide.com>
 <CAGETcx9aFBzMcuOiTAEy5SJyWw3UfajZ8DVQfW2DGmzzDabZVg@mail.gmail.com>
 <Yrlz/P6Un2fACG98@atomide.com>
 <CAGETcx8c+P0r6ARmhv+ERaz9zAGBOVJQu3bSDXELBycEGfkYQw@mail.gmail.com>
 <CAL_JsqJd3J6k6pRar7CkHVaaPbY7jqvzAePd8rVDisRV-dLLtg@mail.gmail.com>
 <CAGETcx9ZmeTyP1sJCFZ9pBbMyXeifQFohFvWN3aBPx0sSOJ2VA@mail.gmail.com>
 <Yr6HQOtS4ctUYm9m@atomide.com>
 <Yr6QUzdoFWv/eAI6@atomide.com>
 <CAGETcx-0bStPx8sF3BtcJFiu74NwiB0btTQ+xx_B=8B37TEb8w@mail.gmail.com>
 <CAGETcx-Yp2JKgCNfaGD0SzZg9F2Xnu8A3zXmV5=WX1hY7uR=0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-Yp2JKgCNfaGD0SzZg9F2Xnu8A3zXmV5=WX1hY7uR=0g@mail.gmail.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Saravana,

On Fri, Jul 01, 2022 at 01:26:12AM -0700, Saravana Kannan wrote:

[...]

> Can you check if this hack helps? If so, then I can think about
> whether we can pick it up without breaking everything else. Copy-paste
> tab mess up warning.

Sorry for jumping in late and not even sure if this is right thread.
I have not bisected anything yet, but I am seeing issues on my Juno R2
with SCMI enabled power domains and Coresight AMBA devices.

OF: amba_device_add() failed (-19) for /etf@20010000
OF: amba_device_add() failed (-19) for /tpiu@20030000
OF: amba_device_add() failed (-19) for /funnel@20040000
OF: amba_device_add() failed (-19) for /etr@20070000
OF: amba_device_add() failed (-19) for /stm@20100000
OF: amba_device_add() failed (-19) for /replicator@20120000
OF: amba_device_add() failed (-19) for /cpu-debug@22010000
OF: amba_device_add() failed (-19) for /etm@22040000
OF: amba_device_add() failed (-19) for /cti@22020000
OF: amba_device_add() failed (-19) for /funnel@220c0000
OF: amba_device_add() failed (-19) for /cpu-debug@22110000
OF: amba_device_add() failed (-19) for /etm@22140000
OF: amba_device_add() failed (-19) for /cti@22120000
OF: amba_device_add() failed (-19) for /cpu-debug@23010000
OF: amba_device_add() failed (-19) for /etm@23040000
OF: amba_device_add() failed (-19) for /cti@23020000
OF: amba_device_add() failed (-19) for /funnel@230c0000
OF: amba_device_add() failed (-19) for /cpu-debug@23110000
OF: amba_device_add() failed (-19) for /etm@23140000
OF: amba_device_add() failed (-19) for /cti@23120000
OF: amba_device_add() failed (-19) for /cpu-debug@23210000
OF: amba_device_add() failed (-19) for /etm@23240000
OF: amba_device_add() failed (-19) for /cti@23220000
OF: amba_device_add() failed (-19) for /cpu-debug@23310000
OF: amba_device_add() failed (-19) for /etm@23340000
OF: amba_device_add() failed (-19) for /cti@23320000
OF: amba_device_add() failed (-19) for /cti@20020000
OF: amba_device_add() failed (-19) for /cti@20110000
OF: amba_device_add() failed (-19) for /funnel@20130000
OF: amba_device_add() failed (-19) for /etf@20140000
OF: amba_device_add() failed (-19) for /funnel@20150000
OF: amba_device_add() failed (-19) for /cti@20160000

These are working fine with deferred probe in the mainline.
I tried the hack you have suggested here(rather Tony's version), also
tried with fw_devlink=0 and fw_devlink=1 && fw_devlink.strict=0
No change in the behaviour.

The DTS are in arch/arm64/boot/dts/arm/juno-*-scmi.dts and there
coresight devices are mostly in juno-cs-r1r2.dtsi

Let me know if there is anything obvious or you want me to bisect which
means I need more time. I can do that next week.

-- 
Regards,
Sudeep
