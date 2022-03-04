Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099F24CD579
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 14:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236755AbiCDNwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 08:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236609AbiCDNwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 08:52:15 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A821B8BC1;
        Fri,  4 Mar 2022 05:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BGVtpXmJIVAedZRTMlT+Ds7jIRoGmJt31yMwbU9LdGc=; b=ctKhfDbux8dk+q601r81G+VHmI
        UWwE2565r7kzOvulIHXxejqhMA94KBMgojxCrmsTUDF6eY1oW7VJjAPlc7zY5VHx6tGvMHSdJvaSI
        92ljJMK3xJNdLniFyQ4VTn8Vqct4sshGfKYmvWbM4S2//Nh9vsdqsapXF/YJWt9+4lDw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nQ8L7-009EnX-4E; Fri, 04 Mar 2022 14:51:25 +0100
Date:   Fri, 4 Mar 2022 14:51:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun.Ramadoss@microchip.com
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        hkallweit1@gmail.com, UNGLinuxDriver@microchip.com, kuba@kernel.org
Subject: Re: [PATCH net-next 6/6] net: phy: added ethtool master-slave
 configuration support
Message-ID: <YiIZXeE8Yvp5tQHX@lunn.ch>
References: <20220304094401.31375-1-arun.ramadoss@microchip.com>
 <20220304094401.31375-7-arun.ramadoss@microchip.com>
 <YiIQfcKccbjtfPJo@lunn.ch>
 <69bfebc2a8a5cef56a4b064e32d00fcbd78f54c3.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69bfebc2a8a5cef56a4b064e32d00fcbd78f54c3.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > It looks like you can just call genphy_read_master_slave()? Or am i
> > missing some subtle difference?
> 
> Thanks for the comment.
> 
> genphy_read_master_slave() and genphy_setup_master_slave() functions
> first check for whether phy is gigabit capable. If no, it returns.
> LAN87XX is not gigabit capable, so I replicated the genphy function and
> removed only the gigabit capable check. I took nxp-tja11xx code as
> reference, which has similar implementation.

O.K, please refactor genphy_read_master_slave() and split it into two.
You can then call the inner function which does not perform the speed
check. Maybe you can also change nxp-tja11xx in the same way.

       Andrew
