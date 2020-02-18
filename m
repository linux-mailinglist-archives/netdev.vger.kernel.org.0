Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85460162B29
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 17:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgBRQzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 11:55:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:34596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgBRQzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 11:55:25 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFCEF2176D;
        Tue, 18 Feb 2020 16:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582044924;
        bh=zYbH/t2V9dViGFpxKrN5WN7wgyb79NK7aWjvZ9PciMc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R9r7mZsOXkH6Cq5Wn+tL7rpjvwdL3DqF//EHE9ESINIx3jR3WAWLykk2MhJ1MsWA9
         tSYdaAYD570uNZnKVG5i31pZYfBeMYJdQOuxMq8sw/svJvLjsXiWwpm3QckELfPlfA
         xp+dPDbYl4rHKvYknSzg0qDyp10Z+cb+/3M/3d/k=
Date:   Tue, 18 Feb 2020 08:55:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <andrew@lunn.ch>, <jeffrey.t.kirsher@intel.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v3 00/10]  net: bridge: mrp: Add support for
 Media Redundancy Protocol (MRP)
Message-ID: <20200218085522.630e4778@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20200218121811.xo3o6zzrhl5p3j2s@lx-anielsen.microsemi.net>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
        <20200218121811.xo3o6zzrhl5p3j2s@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Feb 2020 13:18:11 +0100 Allan W. Nielsen wrote:
> But we should try make sure this also works in a backwards compatible
> way with future MRP aware HW, and with existing (and future) SwitchDev
> offloaded HW. At the very least we want to make this run on Ocelot, HW
> offload the MRC role, but do the MRM in SW (as the HW is not capable of
> this).
> 
> If we use the kernel to abstract the MRP forwarding (not the entire
> protocol like we did in v1/v2, not just the HW like we did in v3) then
> we will have more flxibility to support other HW with a different set of
> offload facilities, we can most likely achieve better performance, and
> it would be a cleaner design.
> 
> This will mean, that if user-space ask for MRP frame to be generated,
> the kernel should make sure it will happen. The kernel can try to
> offload this via the switchdev API, or it can do it in kernel-space.
> 
> Again, it will mean putting back some code into kernel space, but I
> think it is worth it.

FWIW having the guarantee that the kernel can always perform requested
service/operation (either thru offload or in SW in kernel space) seems
appealing and in line what we've been doing for other offloads. 

IOW it'd be nice to have a kernel space software fallback for the
offloaded operations.
