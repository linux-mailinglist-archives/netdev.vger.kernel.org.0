Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53B238E316
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 11:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhEXJPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 05:15:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232397AbhEXJPM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 05:15:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EBD360FE7;
        Mon, 24 May 2021 09:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621847625;
        bh=gLEwh/xrg3/6bm6NA/iMItM0ghz5DNK9xGjeSvn1l0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jCz4XGleLi33u/pN2fdy9FOgw4762PwQyV1uy5ts71SHEhBV1PUiHX+bpNL9zTC5K
         t1ToJwrok0w9FpaUUrMvvGDrylo8UFldtX/pCgyuGdyKPqKgggkhFEjwvJaNmwsnZH
         3PuHcHE81+RKO4ni7JN8Kds2sn1+InbaXKvDtu1NobJbxrnl7kMC9Q76lsny6P9azX
         K14gCvIPArji73xKw6WwhaaInAMADD84Tr0OkMbr152Lj1UifsQIk0dw5y66juwHZB
         V/xJJ4F0LycpbFJyn1YblUy+pq4lRx4fEPgwCglX0vVtCo8MQ5mc3buar0mBN175JN
         X/6a2q/+v+zSg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ll6ec-00014d-R3; Mon, 24 May 2021 11:13:42 +0200
Date:   Mon, 24 May 2021 11:13:42 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com" 
        <syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com>
Subject: Re: [PATCH net v3] r8152: check the informaton of the device
Message-ID: <YKtuRmp6mC34kf2k@hovoldconsulting.com>
References: <1394712342-15778-363-Taiwan-albertk@realtek.com>
 <1394712342-15778-365-Taiwan-albertk@realtek.com>
 <YKtdJnvZTxE1yqEK@hovoldconsulting.com>
 <1e7e1d4039724eb4bcdd5884a748d880@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e7e1d4039724eb4bcdd5884a748d880@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 08:54:50AM +0000, Hayes Wang wrote:
> Johan Hovold <johan@kernel.org>
> > Sent: Monday, May 24, 2021 4:01 PM
> [...]
> > >  	/* The vendor mode is not always config #1, so to find it out. */
> > >  	udev = interface_to_usbdev(intf);
> > >  	c = udev->config;
> > >  	num_configs = udev->descriptor.bNumConfigurations;
> > > +	if (num_configs < 2)
> > > +		return false;
> > > +
> > 
> > Nit: This check looks unnecessary also as the driver can handle a single
> > configuration just fine, and by removing it you'd be logging "Unexpected
> > Device\n" below also in the single config case.
> 
> I just want to distinguish the devices.
> It is acceptable if the device contains only one configuration.
> A mistake occurs if the device has more configurations and
> there is no expected one.
> I would remove it if you think it is better.

I'm fine with keeping the check too (e.g. as an optimisation of sort),
it's just a bit inconsistent to not log an error in that one error path.

Johan
