Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55293ECEF0
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 09:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbhHPHDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 03:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233723AbhHPHDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 03:03:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83EC261A86;
        Mon, 16 Aug 2021 07:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629097359;
        bh=NEhOhNn51b6BaxHNGueUbfM3PA9uRwYmLljxdcnbVZ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ISbwARMFpUlx050yLFm9ANJgbNAyDab8u1K2UH2/KbiYEKGLl4FnqqlRePYPzto52
         bNFtIsGXt610MnH8LHCdwjC4IENw4gN46HiTdbU04PVIY+Cxtb9lQVQyKxyiR7Dj8C
         ZYg8Ld/x5GW1zvWbaA2B6IH04yf2n26kvf2acObw=
Date:   Mon, 16 Aug 2021 09:02:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     David Miller <davem@davemloft.net>, tuba@ece.ufl.edu,
        netdev@vger.kernel.org, kuba@kernel.org, oneukum@suse.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2] net: hso: do not call unregister if not registered
Message-ID: <YRoNjEERjPz0AYEQ@kroah.com>
References: <20201002114323.GA3296553@kroah.com>
 <20201003.170042.489590204097552946.davem@davemloft.net>
 <20201004071433.GA212114@kroah.com>
 <YRoLSvowhZsyKbOk@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRoLSvowhZsyKbOk@eldamar.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 08:52:58AM +0200, Salvatore Bonaccorso wrote:
> Hi Greg, Tuba,
> 
> On Sun, Oct 04, 2020 at 09:14:33AM +0200, Greg KH wrote:
> > On Sat, Oct 03, 2020 at 05:00:42PM -0700, David Miller wrote:
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > Date: Fri, 2 Oct 2020 13:43:23 +0200
> > > 
> > > > @@ -2366,7 +2366,8 @@ static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
> > > >  
> > > >  	remove_net_device(hso_net->parent);
> > > >  
> > > > -	if (hso_net->net)
> > > > +	if (hso_net->net &&
> > > > +	    hso_net->net->reg_state == NETREG_REGISTERED)
> > > >  		unregister_netdev(hso_net->net);
> > > >  
> > > >  	/* start freeing */
> > > 
> > > I really want to get out of the habit of drivers testing the internal
> > > netdev registration state to make decisions.
> > > 
> > > Instead, please track this internally.  You know if you registered the
> > > device or not, therefore use that to control whether you try to
> > > unregister it or not.
> > 
> > Fair enough.  Tuba, do you want to fix this up in this way, or do you
> > recommend that someone else do it?
> 
> Do I miss something, or did that possibly fall through the cracks?
> 
> I was checking some open issues on a downstream distro side and found
> htat this thread did not got a follow-up.

I did not see a follow-up patch :(
