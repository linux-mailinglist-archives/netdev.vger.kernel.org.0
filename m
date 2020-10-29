Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3554829F09C
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 16:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbgJ2P4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 11:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728450AbgJ2P4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 11:56:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CDFD206B2;
        Thu, 29 Oct 2020 15:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603986989;
        bh=UIYyaC9mWXzASi/e/U7uoy/4dyXW1LiDvKm13VKMy4s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PEI41i3ZoJhIeG7S0wdP61pqF6ebSRk+K7bVoA6WcmUVOTRSP7TeVEngKZIxFm9IC
         2/I5TlPAOE902RPm+CL85tl7glSA+edgRpHtIKvbE1fbSh4qpma6ZuyY5n37A+3biq
         QpqmaTuKGayA9PYTEjoam2qco5dRtw+uf4nTXBeA=
Date:   Thu, 29 Oct 2020 08:56:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        devel@driverdev.osuosl.org, Arnd Bergmann <arnd@arndb.de>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] wimax: move out to staging
Message-ID: <20201029085627.698080a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201028055628.GB244117@kroah.com>
References: <20201027212448.454129-1-arnd@kernel.org>
        <20201028055628.GB244117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 06:56:28 +0100 Greg Kroah-Hartman wrote:
> On Tue, Oct 27, 2020 at 10:20:13PM +0100, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > There are no known users of this driver as of October 2020, and it will
> > be removed unless someone turns out to still need it in future releases.
> > 
> > According to https://en.wikipedia.org/wiki/List_of_WiMAX_networks, there
> > have been many public wimax networks, but it appears that these entries
> > are all stale, after everyone has migrated to LTE or discontinued their
> > service altogether.
> > 
> > NetworkManager appears to have dropped userspace support in 2015
> > https://bugzilla.gnome.org/show_bug.cgi?id=747846, the
> > www.linuxwimax.org
> > site had already shut down earlier.
> > 
> > WiMax is apparently still being deployed on airport campus networks
> > ("AeroMACS"), but in a frequency band that was not supported by the old
> > Intel 2400m (used in Sandy Bridge laptops and earlier), which is the
> > only driver using the kernel's wimax stack.
> > 
> > Move all files into drivers/staging/wimax, including the uapi header
> > files and documentation, to make it easier to remove it when it gets
> > to that. Only minimal changes are made to the source files, in order
> > to make it possible to port patches across the move.
> > 
> > Also remove the MAINTAINERS entry that refers to a broken mailing
> > list and website.
> > 
> > Suggested-by: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>  
> 
> Is this ok for me to take through the staging tree?  If so, I need an
> ack from the networking maintainers.
> 
> If not, feel free to send it through the networking tree and add:
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thinking about it now - we want this applied to -next, correct? 
In that case it may be better if we take it. The code is pretty dead
but syzbot and the trivial fix crowd don't know it, so I may slip,
apply something and we'll have a conflict.
