Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377125A1CDC
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 00:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244264AbiHYW6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 18:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbiHYW57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 18:57:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E0DC2EAB;
        Thu, 25 Aug 2022 15:57:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB83661CFA;
        Thu, 25 Aug 2022 22:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F31C433D6;
        Thu, 25 Aug 2022 22:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661468278;
        bh=r6JZyqW6S9RG4eDZIgslFoKC3t2I0DV9CVvoSL3Tn3w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t/SI79+oQN2XJMz1cFpQnN36XKRNGP1fWt/LqW5S4U+Hh8i9ZgmvcYdctJJoBjsqG
         mQRXhP3rNMODbKqjGO0/8Lw0r85FYPGMTkgAzP6yD0XMXN2MSWJQkIrEEHDKACz8rc
         Mzdqc4ffJ7JjPYZoZvznL8O14eWaM3YhsjGYdiPSXzRxwWjPpOzbJbBnjPuTP4Ej5s
         cHblulGAlKHsgVp5u6+/njxX75vajIYGNSs0d4O+8w4oHvYeEmXxFS1eXFv7V8aD8z
         12zdqhj4ynywTPqkI+fDYan5z+D9NqEVkjlXQX2GfK0b3Zn0a87nbQLQ8t5IOb5UzE
         BbTtb7fY28CXw==
Date:   Thu, 25 Aug 2022 15:57:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: Re: [PATCH net-next v3 00/17] net: dsa: microchip: add error
 handling and register access validation
Message-ID: <20220825155756.142c07a5@kernel.org>
In-Reply-To: <20220825214424.u6oawi5n47zyn7rd@skbuf>
References: <20220823080231.2466017-1-o.rempel@pengutronix.de>
        <a359692096f20b2abc5e53cb796c892f97acec1b.camel@redhat.com>
        <20220825214424.u6oawi5n47zyn7rd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Aug 2022 00:44:24 +0300 Vladimir Oltean wrote:
> On Thu, Aug 25, 2022 at 11:00:44AM +0200, Paolo Abeni wrote:
> > On Tue, 2022-08-23 at 10:02 +0200, Oleksij Rempel wrote:  
> > > changes v3:
> > > - fix build error in the middle of the patch stack.  
> > 
> > The series looks reasonable to me, let's see the comments from the DSA
> > crew;)  
> 
> Patch set looks ok from my side, won't leave review tags for each of the
> 17 patches, just here
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Thanks a lot!

Oleksij there are quite a few checkpatch annoyances here, please fix up:

-------------------------------------------------------------------------------------------
Commit 0ef2f8617176 ("net: dsa: microchip: do per-port Gbit detection instead of per-chip")
-------------------------------------------------------------------------------------------
WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#12: 
ksz9477_switch_init() function. Which is using undocumented REG_GLOBAL_OPTIONS

total: 0 errors, 1 warnings, 0 checks, 144 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

Commit 0ef2f8617176 ("net: dsa: microchip: do per-port Gbit detection instead of per-chip") has style problems, please review.
-------------------------------------------------------------------------------------------------------
Commit 06c98e1faaa7 ("net: dsa: microchip: don't announce extended register support on non Gbit chips")
-------------------------------------------------------------------------------------------------------
CHECK: Please don't use multiple blank lines
#29: FILE: drivers/net/dsa/microchip/ksz9477.c:267:
 
+

total: 0 errors, 0 warnings, 1 checks, 32 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

Commit 06c98e1faaa7 ("net: dsa: microchip: don't announce extended register support on non Gbit chips") has style problems, please review.


------------------------------------------------------------------------------------------------------
Commit 872fff3049d3 ("net: dsa: microchip: forward error value on all ksz_pread/ksz_pwrite functions")
------------------------------------------------------------------------------------------------------
CHECK: Alignment should match open parenthesis
#28: FILE: drivers/net/dsa/microchip/ksz_common.h:397:
+static inline int ksz_pread8(struct ksz_device *dev, int port, int offset,
 			      u8 *data)

CHECK: Alignment should match open parenthesis
#36: FILE: drivers/net/dsa/microchip/ksz_common.h:403:
+static inline int ksz_pread16(struct ksz_device *dev, int port, int offset,
 			       u16 *data)

CHECK: Alignment should match open parenthesis
#44: FILE: drivers/net/dsa/microchip/ksz_common.h:409:
+static inline int ksz_pread32(struct ksz_device *dev, int port, int offset,
 			       u32 *data)

CHECK: Alignment should match open parenthesis
#52: FILE: drivers/net/dsa/microchip/ksz_common.h:415:
+static inline int ksz_pwrite8(struct ksz_device *dev, int port, int offset,
 			       u8 data)

CHECK: Alignment should match open parenthesis
#60: FILE: drivers/net/dsa/microchip/ksz_common.h:421:
+static inline int ksz_pwrite16(struct ksz_device *dev, int port, int offset,
 				u16 data)

CHECK: Alignment should match open parenthesis
#69: FILE: drivers/net/dsa/microchip/ksz_common.h:428:
+static inline int ksz_pwrite32(struct ksz_device *dev, int port, int offset,
 				u32 data)

total: 0 errors, 0 warnings, 6 checks, 58 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

Commit 872fff3049d3 ("net: dsa: microchip: forward error value on all ksz_pread/ksz_pwrite functions") has style problems, please review.

-----------------------------------------------------------------------------------------------------------------
Commit a615f4ad0116 ("net: dsa: microchip: KSZ9893: do not write to not supported Output Clock Control Register")
-----------------------------------------------------------------------------------------------------------------
WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#8: 
KSZ9893 compatible chips do not have "Output Clock Control Register 0x0103".

total: 0 errors, 1 warnings, 0 checks, 15 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

Commit a615f4ad0116 ("net: dsa: microchip: KSZ9893: do not write to not supported Output Clock Control Register") has style problems, please review.
---------------------------------------------------------------------------------
Commit d1abab8b5762 ("net: dsa: microchip: add support for regmap_access_tables")
---------------------------------------------------------------------------------
WARNING: unnecessary whitespace before a quoted newline
#43: FILE: drivers/net/dsa/microchip/ksz_common.h:338:
+		dev_err(dev->dev, "can't read 8bit reg: 0x%x %pe \n", reg,

WARNING: unnecessary whitespace before a quoted newline
#56: FILE: drivers/net/dsa/microchip/ksz_common.h:351:
+		dev_err(dev->dev, "can't read 16bit reg: 0x%x %pe \n", reg,

WARNING: unnecessary whitespace before a quoted newline
#69: FILE: drivers/net/dsa/microchip/ksz_common.h:364:
+		dev_err(dev->dev, "can't read 32bit reg: 0x%x %pe \n", reg,

WARNING: unnecessary whitespace before a quoted newline
#84: FILE: drivers/net/dsa/microchip/ksz_common.h:378:
+		dev_err(dev->dev, "can't read 64bit reg: 0x%x %pe \n", reg,

WARNING: unnecessary whitespace before a quoted newline
#99: FILE: drivers/net/dsa/microchip/ksz_common.h:392:
+		dev_err(dev->dev, "can't write 8bit reg: 0x%x %pe \n", reg,

WARNING: unnecessary whitespace before a quoted newline
#112: FILE: drivers/net/dsa/microchip/ksz_common.h:404:
+		dev_err(dev->dev, "can't write 16bit reg: 0x%x %pe \n", reg,

WARNING: unnecessary whitespace before a quoted newline
#125: FILE: drivers/net/dsa/microchip/ksz_common.h:416:
+		dev_err(dev->dev, "can't write 32bit reg: 0x%x %pe \n", reg,

total: 0 errors, 7 warnings, 0 checks, 123 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

Commit d1abab8b5762 ("net: dsa: microchip: add support for regmap_access_tables") has style problems, please review.

----------------------------------------------------------------------------------------------------
Commit 39a148ccc56c ("net: dsa: microchip: ksz9477: remove MII_CTRL1000 check from ksz9477_w_phy()")
----------------------------------------------------------------------------------------------------
WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#11: 
With proper regmap_ranges provided for all chips we will be able to catch this

total: 0 errors, 1 warnings, 0 checks, 14 lines checked
