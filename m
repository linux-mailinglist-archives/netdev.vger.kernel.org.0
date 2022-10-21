Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9472607C2D
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 18:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiJUQ0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 12:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiJUQ03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 12:26:29 -0400
Received: from vps0.lunn.ch (unknown [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FDE2764D2;
        Fri, 21 Oct 2022 09:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iq1eYfHdRkn3kCl6a44vE/x3fUxXovvRR4vp6IbnJdg=; b=Ap0GIMnfBBlNRXdHy7XSru8ijN
        lN5XXWP0RyKhQ7s4p7vP9JrsBk8TiKeMH8DBKP7/Y4CRfLIJYzXd1IsMpg4QBzbRhiyacOHEL3Bmr
        ZNuU8ED6Ohs6CmCDofagncJLq6/p1wJGwwnIL9/5SJ0LJRy0fI397ror/6yZADXZhnks=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oluAC-000FKg-Ca; Fri, 21 Oct 2022 17:42:24 +0200
Date:   Fri, 21 Oct 2022 17:42:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH net-next 0/7] net: sfp: improve high power module
 implementation
Message-ID: <Y1K94ImMTITNaYE/@lunn.ch>
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NEUTRAL,SPF_NEUTRAL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 02:28:20PM +0100, Russell King (Oracle) wrote:
> Hi,
> 
> This series aims to improve the power level switching between standard
> level 1 and the higher power levels.
> 
> The first patch updates the DT binding documentation to include the
> minimum and default of 1W, which is the base level that every SFP cage
> must support. Hence, it makes sense to document this in the binding.
> 
> The second patch enforces a minimum of 1W when parsing the firmware
> description, and optimises the code for that case; there's no need to
> check for SFF8472 compliance since we will not need to touch the
> A2h registers.
> 
> Patch 3 validates that the module supports SFF-8472 rev 10.2 before
> checking for power level 2 - rev 10.2 is where support for power
> levels was introduced, so if the module doesn't support this revision,
> it doesn't support power levels. Setting the power level 2 declaration
> bit is likely to be spurious.

Or it is yet another case of violating the standard. The bit is valid,
the revision is wrong in the EEPROM. How long do you think it will be
before we see a quirk like this?

> Patch 4 does the same for power level 3, except this was introduced in
> SFF-8472 rev 11.9. The revision code was never updated, so we use the
> rev 11.4 to signify this.

Great, the standard itself is broken.

       Andrew
