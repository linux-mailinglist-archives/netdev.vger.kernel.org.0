Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E25B7FFB80
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 20:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfKQTm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 14:42:59 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:52086 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfKQTm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 14:42:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=o9QmIsEAtk+/2GeOht7OzFU7FYfrEYn1OeoGFTTKR/g=; b=hxODYJML2rOuGcm/bP+tqiQsM
        l0j+9c+B+TXtwRqJZHI5GRAzRUs597NJEhAAVP3UCkYHnTSZH3gdbXO2JMnTmcVNY8lU93w1issdQ
        LLfkM9k3GGJsswWJd7e1XBTLd7D/SjcfUwVhXp8A0ebUpF7OCKehfcoOsJvFPQ8JX+ewcIB3OPMdN
        SV4fXjQ5Klgr4PUnv9hx+oASrwMZCroPUG7qkeUwUYU8tqZx4b62QPmRTG7pRF/2FSX1OrmV1GBio
        bbqu0hlGZJ9cDj4aP33hJ+hcdwNS3fV73jGHd9MAuHMj8PVslnEtLpwTasdbnzaD5oGaJvD336nEg
        A3tKioq6Q==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:57538)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iWQRf-0007AX-K6; Sun, 17 Nov 2019 19:42:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iWQRc-0007Tr-R9; Sun, 17 Nov 2019 19:42:48 +0000
Date:   Sun, 17 Nov 2019 19:42:48 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next v4 2/5] bus: fsl-mc: add the fsl_mc_get_endpoint
 function
Message-ID: <20191117194248.GK1344@shell.armlinux.org.uk>
References: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
 <1572477512-4618-3-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572477512-4618-3-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 01:18:29AM +0200, Ioana Ciornei wrote:
> Using the newly added fsl_mc_get_endpoint function a fsl-mc driver can
> find its associated endpoint (another object at the other link of a MC
> firmware link).
> 
> The API will be used in the following patch in order to discover the
> connected DPMAC object of a DPNI.
> 
> Also, the fsl_mc_device_lookup function is made available to the entire
> fsl-mc bus driver and not just for the dprc driver.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

When building this with gcc 4.9.2, I get these warnings:

drivers/bus/fsl-mc/fsl-mc-bus.c: In function 'fsl_mc_get_endpoint':
drivers/bus/fsl-mc/fsl-mc-bus.c:718:9: warning: missing braces around initializer [-Wmissing-braces]
  struct fsl_mc_obj_desc endpoint_desc = { 0 };
         ^
drivers/bus/fsl-mc/fsl-mc-bus.c:718:9: warning: (near initialization for 'endpoint_desc.type') [-Wmissing-braces]
drivers/bus/fsl-mc/fsl-mc-bus.c:719:9: warning: missing braces around initializer [-Wmissing-braces]
  struct dprc_endpoint endpoint1 = { 0 };
         ^
drivers/bus/fsl-mc/fsl-mc-bus.c:719:9: warning: (near initialization for 'endpoint1.type') [-Wmissing-braces]
drivers/bus/fsl-mc/fsl-mc-bus.c:720:9: warning: missing braces around initializer [-Wmissing-braces]
  struct dprc_endpoint endpoint2 = { 0 };
         ^
drivers/bus/fsl-mc/fsl-mc-bus.c:720:9: warning: (near initialization for 'endpoint2.type') [-Wmissing-braces]

This seems to be a legit complaint - the first member of these is a
char array, and initialising an array with an integer 0 has provoked
this and previous versions of GCC to complain.

Both GCC and Clang support the empty initialiser, despite not being
valid C99.  If you want to be C99 compliant, the alternative is to
explicitly memset() these structures.

In all these cases, the CPU has to do work to set these structures to
zero (using memset() will also get any padding too.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
