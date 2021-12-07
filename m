Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1658846BFA4
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239028AbhLGPmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239027AbhLGPme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:42:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D291C061574;
        Tue,  7 Dec 2021 07:39:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D232B80DBF;
        Tue,  7 Dec 2021 15:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4072AC341C1;
        Tue,  7 Dec 2021 15:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638891541;
        bh=JVL0Sq2i+LUFVXYb3DxB2ruUAdzAFklM0iojGMbanEA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=harAXc6BJFLTNKLdlynKCgJmeQk9xgu01DVNGr4UfugAA5FgPJbEEVvSTxDuQ5w4t
         fsHgY26HsHERlD2+3RO/LwOM3jcl23lfMMMMMXzcEkQilgQ8pzj8GfKf2qOUKDvqjP
         TFW66v3rLbM2M5sUfKV/1bC/18zu4AcflT/W1KySDVxQV+p3bXQoFgiwfWcWTt9Pju
         e0NSBW25Rs0QjAPZF+CfclFtIBNsny6mEL1U98DTfsdmg7SN9Jd89NGnhKlS9PUbKg
         u2tZ/Uxg6J9La2xXBZrXfz3VGbnF7Q+NeMDf5E2oLv2osrtcLP0hkc9c0GHHIrnob4
         AVMNwSI8Ua3QQ==
Date:   Tue, 7 Dec 2021 07:39:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Colin Foster <colin.foster@in-advantage.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 net-next 5/5] net: mscc: ocelot: expose ocelot wm
 functions
Message-ID: <20211207073900.151725ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207153011.xs5k3ir4jzftbxct@skbuf>
References: <20211204182858.1052710-1-colin.foster@in-advantage.com>
        <20211204182858.1052710-6-colin.foster@in-advantage.com>
        <20211206180922.1efe4e51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <Ya9KJAYEypSs6+dO@shell.armlinux.org.uk>
        <20211207121121.baoi23nxiitfshdk@skbuf>
        <20211207072652.36827870@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211207153011.xs5k3ir4jzftbxct@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Dec 2021 15:30:12 +0000 Vladimir Oltean wrote:
> On Tue, Dec 07, 2021 at 07:26:52AM -0800, Jakub Kicinski wrote:
> > On Tue, 7 Dec 2021 12:11:22 +0000 Vladimir Oltean wrote:  
> > > I'm not taking this as a spiteful comment either, it is a very fair point.
> > > Colin had previously submitted this as part of a 23-patch series and it
> > > was me who suggested that this change could go in as part of preparation
> > > work right away:
> > > https://patchwork.kernel.org/project/netdevbpf/cover/20211116062328.1949151-1-colin.foster@in-advantage.com/#24596529
> > > I didn't realize that in doing so with this particular change, we would
> > > end up having some symbols exported by the ocelot switch lib that aren't
> > > yet in use by other drivers. So yes, this would have to go in at the
> > > same time as the driver submission itself.  
> >
> > I don't know the dependencies here (there are also pinctrl patches
> > in the linked series) so I'll defer to you, if there is a reason to
> > merge the unused symbols it needs to be spelled out, otherwise let's
> > drop the last patch for now.  
> 
> I don't think there's any problem with dropping the last patch for now,
> as that's the safer thing to do (Colin?), but just let us know whether
> you prefer Colin to resend a 4-patch series, or you can pick this series
> up without the last one.

Repost once it's confirmed that's the right course of action.
I'll merge it right away.
