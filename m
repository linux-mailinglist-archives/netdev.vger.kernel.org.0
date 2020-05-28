Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAB31E69A2
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 20:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405937AbgE1SnS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 May 2020 14:43:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:57116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391488AbgE1SnP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 14:43:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 26997AB5C;
        Thu, 28 May 2020 18:43:13 +0000 (UTC)
Date:   Thu, 28 May 2020 20:43:12 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-Id: <20200528204312.df9089425162a22e89669cf1@suse.de>
In-Reply-To: <20200528144805.GW1551@shell.armlinux.org.uk>
References: <20200528121121.125189-1-tbogendoerfer@suse.de>
        <20200528130738.GT1551@shell.armlinux.org.uk>
        <20200528151733.f1bc2fcdcb312b19b2919be9@suse.de>
        <20200528135608.GU1551@shell.armlinux.org.uk>
        <20200528163335.8f730b5a3ddc8cd9beab367f@suse.de>
        <20200528144805.GW1551@shell.armlinux.org.uk>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 15:48:05 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Thu, May 28, 2020 at 04:33:35PM +0200, Thomas Bogendoerfer wrote:
> > below is the dts part for the two network interfaces. The switch to
> > the outside has two ports, which correlate to the two internal ports.
> > And the switch propagates the link state of the external ports to
> > the internal ports.
> 
> Okay, so this DTS hasn't been reviewed...

that's from our partner, I'm just using it. Stripping it down isn't
the point for my now.

> This isn't correct - you are requesting that in-band status is used
> (i.o.w. the in-band control word, see commit 4cba5c210365), but your
> bug report wants to enable AN bypass because there is no in-band
> control word.  This seems to be rather contradictory.
> 
> May I suggest you use a fixed-link here, which will not have any

afaik fixed-link will always be up, and we want to have the link state
from the switch external ports.

> inband status, as there is no in-band control word being sent by
> the switch?  That is also the conventional way of handling switch
> links.

again, we want to propagte the external link state inside to all
the internal nodes. So this will not work anymore with fixed-link.

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 36809 (AG Nürnberg)
Geschäftsführer: Felix Imendörffer
