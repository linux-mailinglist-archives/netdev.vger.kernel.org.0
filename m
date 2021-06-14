Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055BE3A66CC
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhFNMmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:42:45 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37366 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbhFNMmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 08:42:43 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 027192197A;
        Mon, 14 Jun 2021 12:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623674439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XBYOvFAFTda/NVTkMZ0PeZiEtTLP6Wn9QeCT3FHWm6s=;
        b=k4e1oIMCQH05405X0OEqHcA34zn7X5BMMFN6uRoeakLI/bSmkKyqmv2xUk3whG0BRMMgJg
        KT+Xzggu277Ntm78EwDPzStut9sDhEVfNyFIkdTYOcnlMb4/hFO/7Y5WB/ckYNywz0I4oW
        KrrvC1jedquufkilCZBjfGvlV+1Rkfc=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id A24C5118DD;
        Mon, 14 Jun 2021 12:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623674438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XBYOvFAFTda/NVTkMZ0PeZiEtTLP6Wn9QeCT3FHWm6s=;
        b=bI7gcEeAsDNvz1ea4QsseLE+hrztdiYgYiiCLWdVt99cR415yNbJdVuxHmu1vdM/EUC6Kn
        iv8VQg8QZ0OV09xWfkqEpEK1VH5uZfHyFnRra/KOGfUeBiXHL3PWqTVtZAQGyGC7e5O+Wi
        GcX7U7JRzwMz0WCwl9QIDzFCf5kStEA=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id iLUpJUZOx2DuPAAALh3uQQ
        (envelope-from <oneukum@suse.com>); Mon, 14 Jun 2021 12:40:38 +0000
Message-ID: <3567e925f1750babe9508377678c55a2e4610af5.camel@suse.com>
Subject: Re: [PATCH] net: usbnet: allow overriding of default USB interface
 naming
From:   Oliver Neukum <oneukum@suse.com>
To:     Jonathan Davies <jonathan.davies@nutanix.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 14 Jun 2021 14:40:37 +0200
In-Reply-To: <e35ddece-3fd2-4252-6786-af507ba819d2@nutanix.com>
References: <20210611152339.182710-1-jonathan.davies@nutanix.com>
         <YMOaZB6xf2xOpC0S@lunn.ch>
         <e35ddece-3fd2-4252-6786-af507ba819d2@nutanix.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Montag, den 14.06.2021, 10:32 +0100 schrieb Jonathan Davies:
> On 11/06/2021 18:16, Andrew Lunn wrote:
> > On Fri, Jun 11, 2021 at 03:23:39PM +0000, Jonathan Davies wrote:

Hi,

> > > Hence it is useful to be able to override the default name. A new
> > > usbnet
> > > module parameter allows this to be configured.

1. This issue exists with all hotpluggable interfaces
2. It exists for all USB devices so it does not belong in usbnet,
leaving out drivers like kaweth.

> > > 
> > Module parameter are not liked in the network stack.
> 
> Thanks, I wasn't aware. Please help me understand: is that in an
> effort 
> to avoid configurability altogether, or because there's some
> preferred 
> mechanism for performing configuration?

Configurability belongs into user space if possible.
> 
> > It actually seems like a udev problem, and you need to solve it
> > there. It is also not specific to USB. Any sort of interface can
> > pop
> > up at an time, especially with parallel probing of busses.
> 
> Yes, this is also applicable to the naming done for all ethernet 
> devices. But I've seen the problem multiple times for USB NICs, which
> is 
> why I proposed a fix here first.

Because USb devices are common. Your observations are determined
by ubiquity, not intrinsic factors.

> > So you need
> > udev to detect there has been a race condition and try again with
> > the
> > rename.
> 

Yes, now, it may be that we do not export the information udev
would need to or you want new kinds of rules. But I see no evidence
of that.

	Regards
		Oliver



