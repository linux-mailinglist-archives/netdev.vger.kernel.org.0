Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC792BC25C
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 23:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgKUWDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 17:03:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728554AbgKUWDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 17:03:13 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00D2F221EB;
        Sat, 21 Nov 2020 22:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605996192;
        bh=R6LqJxezNsIXeikq7/GWHBaCNJJhNQqtYGcbp68R/3M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DHo8lItmfyDlGx9rDMqCPK3RRroyKQ1eP/qG2LLbTrbP86PRDurhtMGIjcPjaPGFF
         GbWL1gsbT9DO9XYEjhQ+Sk+nVuGrCVmCwPe2UfADDYAcqNrmN43VavyrrCmsRg0gM5
         I3lzR5ifW8oYRN04boVkjovzzP11R6f7R6sNQpZo=
Date:   Sat, 21 Nov 2020 14:03:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yves-Alexis Perez <corsac@corsac.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Martin Habets <mhabets@solarflare.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matti Vuorela <matti.vuorela@bitfactor.fi>,
        stable@vger.kernel.org
Subject: Re: [PATCH] usbnet: ipheth: fix connectivity with iOS 14
Message-ID: <20201121140311.42585c68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201119172439.94988-1-corsac@corsac.net>
References: <CAAn0qaXmysJ9vx3ZEMkViv_B19ju-_ExN8Yn_uSefxpjS6g4Lw@mail.gmail.com>
        <20201119172439.94988-1-corsac@corsac.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 18:24:39 +0100 Yves-Alexis Perez wrote:
> Starting with iOS 14 released in September 2020, connectivity using the
> personal hotspot USB tethering function of iOS devices is broken.
> 
> Communication between the host and the device (for example ICMP traffic
> or DNS resolution using the DNS service running in the device itself)
> works fine, but communication to endpoints further away doesn't work.
> 
> Investigation on the matter shows that UDP and ICMP traffic from the
> tethered host is reaching the Internet at all. For TCP traffic there are
> exchanges between tethered host and server but packets are modified in
> transit leading to impossible communication.
> 
> After some trials Matti Vuorela discovered that reducing the URB buffer
> size by two bytes restored the previous behavior. While a better
> solution might exist to fix the issue, since the protocol is not
> publicly documented and considering the small size of the fix, let's do
> that.
> 
> Tested-by: Matti Vuorela <matti.vuorela@bitfactor.fi>
> Signed-off-by: Yves-Alexis Perez <corsac@corsac.net>
> Link: https://lore.kernel.org/linux-usb/CAAn0qaXmysJ9vx3ZEMkViv_B19ju-_ExN8Yn_uSefxpjS6g4Lw@mail.gmail.com/
> Link: https://github.com/libimobiledevice/libimobiledevice/issues/1038

Applied to net with the typo fixed, thanks!
