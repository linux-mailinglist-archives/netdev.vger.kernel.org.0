Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BD66AC055
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjCFNGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbjCFNGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:06:30 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CD42C656;
        Mon,  6 Mar 2023 05:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FQqcuORaXLfMiKxDrJIZ8q68OPExEvTNfqCIywjvNAs=; b=T3EsYv0/u6FJJLnFYiWK90J/eP
        t4hbyBL5ORJv/DSLRiTTqkkGS1gf/Qu/O9gATSBVksRA+tPgjTB/UVzBC0oE8wGAprl2JoWgtnb77
        8dl32tz7yYUErAxgYRpbHlq//h2HkALXTjx5EeDjJQbJJF/ZxAsYkshyf95tl4Oh3XSY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pZAXk-006Z5s-Pg; Mon, 06 Mar 2023 14:06:20 +0100
Date:   Mon, 6 Mar 2023 14:06:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Emil Renner Berthing <emil.renner.berthing@canonical.com>
Cc:     Guo Samin <samin.guo@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: Re: [PATCH v5 08/12] net: stmmac: starfive_dmac: Add phy interface
 settings
Message-ID: <52822ce5-0712-48e5-81e0-c6ac09d6a6ee@lunn.ch>
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-9-samin.guo@starfivetech.com>
 <CAJM55Z-3CCY8xx81Qr9UqSSQ+gOer3XXJzOvnAe7yyESk23pQw@mail.gmail.com>
 <bc79afab-17d1-8789-3325-8e6d62123dce@starfivetech.com>
 <CAJM55Z8zYUQc33r9tJB1du-FSp+uDf40720taMuGTuPcPU+aZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJM55Z8zYUQc33r9tJB1du-FSp+uDf40720taMuGTuPcPU+aZg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ugh, you're right. Both the syscon block, the register offset and the
> bit position in those registers are different from gmac0 to gmac1, and
> since we need a phandle to the syscon block anyway passing those two
> other parameters as arguments is probably the nicest solution. For the
> next version I'd change the 2nd argument from mask to the bit position
> though. It seems the field is always 3 bits wide and this makes it a
> little clearer that we're not just putting register values in the
> device tree.

I prefer bit position over mask.

But please fully document this in the device tree. This is something a
board developer is going to get wrong, because they assume MAC blocks
are identical, and normally need identical configuration.

I assume this is also a hardware 'bug', and the next generation of the
silicon will have this fixed? So this will go away?

	Andrew
