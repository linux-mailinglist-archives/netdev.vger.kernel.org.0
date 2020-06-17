Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C16A1FC932
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 10:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgFQIri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 04:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgFQIri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 04:47:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDAFC061573
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 01:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=A5uBvHe/R8YOF3jyBgcnPbJZT+qcpuI30bs5+E03FhU=; b=RmYo/m9uPdI9Ju3KP8ps2WPyY
        Pqo6/ZzU4vJ7yXdNe8rlqYS9NMmMix14qjDQJuLoM8X+FMU7iMduMKp5kd9UWtFk/DkP8R/Nz2S7p
        BqBbqn1uDy9d1ZUjQRYvE3I7qmbVkAAkggoIQxe7yQgAZneLYbgV4oV8/dU1V9xAI2GZSJr0Vv2m8
        GyF1Ewj6LdhP+3bOrxGlP28ejb3a4QChEu7PL1eGOJwVQasANjDhGnxqA1GEvMPe6iw3aTaTca3k4
        lccvqX+nxs1TYAg+47btqFPHOKV4CLZNZ1q+OukZEaryb1U/aIp9NVLLoZf7eMgFeGrfzJfBSqAq9
        Se4+n/FEQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58266)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlTjH-0003VC-EL; Wed, 17 Jun 2020 09:47:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlTjF-0003VA-LF; Wed, 17 Jun 2020 09:47:29 +0100
Date:   Wed, 17 Jun 2020 09:47:29 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH v2 01/02] net: phy: marvell: Add Marvell 88E1340 support
Message-ID: <20200617084729.GN1551@shell.armlinux.org.uk>
References: <05f6912b-d529-ae7d-183e-efa6951e94b7@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05f6912b-d529-ae7d-183e-efa6951e94b7@inbox.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 07:52:45AM +0300, Maxim Kochetkov wrote:
> Add Marvell 88E1340 support
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> ---
>  drivers/net/phy/marvell.c   | 23 +++++++++++++++++++++++
>  include/linux/marvell_phy.h |  1 +
>  2 files changed, 24 insertions(+)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 7fc8e10c5f33..4cc4e25fed2d 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -2459,6 +2459,28 @@ static struct phy_driver marvell_drivers[] = {
>  		.get_tunable = m88e1540_get_tunable,
>  		.set_tunable = m88e1540_set_tunable,
>  	},
> +	{
> +		.phy_id = MARVELL_PHY_ID_88E1340S,
> +		.phy_id_mask = MARVELL_PHY_ID_MASK,
> +		.name = "Marvell 88E1340S",
> +		.probe = m88e1510_probe,
> +		/* PHY_GBIT_FEATURES */
> +		.config_init = &marvell_config_init,
> +		.config_aneg = &m88e1510_config_aneg,
> +		.read_status = &marvell_read_status,
> +		.ack_interrupt = &marvell_ack_interrupt,
> +		.config_intr = &marvell_config_intr,
> +		.did_interrupt = &m88e1121_did_interrupt,
> +		.resume = &genphy_resume,
> +		.suspend = &genphy_suspend,
> +		.read_page = marvell_read_page,
> +		.write_page = marvell_write_page,
> +		.get_sset_count = marvell_get_sset_count,
> +		.get_strings = marvell_get_strings,
> +		.get_stats = marvell_get_stats,
> +		.get_tunable = m88e1540_get_tunable,
> +		.set_tunable = m88e1540_set_tunable,

Can we use a single style for referencing functions please?  The kernel
in general does not use &func, it's more typing than is necessary.  The
C99 standard says:

   6.3.2.1  Lvalues, arrays, and function designators

4  A function designator is an expression that has function type.
   Except when it is the operand of the sizeof operator or the unary
   & operator, a function designator with type ``function returning
   type'' is converted to an expression that has type ``pointer to
   function returning type''.

Hence, 

  .resume = &genphy_resume

and

  .resume = genphy_resume

are equivalent but sizeof(genphy_resume) and sizeof(&genphy_resume) are
not.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
