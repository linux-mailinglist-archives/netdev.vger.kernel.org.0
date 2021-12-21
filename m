Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EDC47C22B
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbhLUPCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbhLUPCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:02:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3F5C061574;
        Tue, 21 Dec 2021 07:02:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E59C6162A;
        Tue, 21 Dec 2021 15:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02074C36AE8;
        Tue, 21 Dec 2021 15:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640098971;
        bh=LlzjFDFyeYsNvKei/p4c++vqP/wlNDuge3mZPC23l9w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0aoiRiJnxJWC22KFSrpe1VpWybQ9Q3XnpcRvQn/heaECXNBkLUSsJobIAP01hWm4W
         +34v9YOrEATVgzVFfhH2AUbaitZZBpHNFDTjFN/4x5GdCkWUVWE7f+3gdkrJwmDdYZ
         PNxALTwN/RfOklFxL9ulWTdy2bgJJruNfCsQpl5A=
Date:   Tue, 21 Dec 2021 16:02:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Message-ID: <YcHskr0KSFSR35xY@kroah.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <20211221065047.290182-2-mike.ximing.chen@intel.com>
 <YcF+QIHKgNLJOxUh@kroah.com>
 <YcGW3lm4UBbDHURW@kroah.com>
 <CO1PR11MB51707B01007B77CEF4F1640BD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
 <CO1PR11MB5170FB6317CE0A8ECBD0436ED97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB5170FB6317CE0A8ECBD0436ED97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 02:42:10PM +0000, Chen, Mike Ximing wrote:
> 
> 
> > -----Original Message-----
> > From: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> > Sent: Tuesday, December 21, 2021 9:26 AM
> > To: Greg KH <gregkh@linuxfoundation.org>
> > Cc: linux-kernel@vger.kernel.org; arnd@arndb.de; Williams, Dan J <dan.j.williams@intel.com>; pierre-
> > louis.bossart@linux.intel.com; netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org
> > Subject: RE: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
> > 
> > 
> > > -----Original Message-----
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > Sent: Tuesday, December 21, 2021 3:57 AM
> > > To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> > > Cc: linux-kernel@vger.kernel.org; arnd@arndb.de; Williams, Dan J
> > > <dan.j.williams@intel.com>; pierre- louis.bossart@linux.intel.com;
> > > netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org
> > > Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
> > >
> > > On Tue, Dec 21, 2021 at 08:12:00AM +0100, Greg KH wrote:
> > > > On Tue, Dec 21, 2021 at 12:50:31AM -0600, Mike Ximing Chen wrote:
> > > > > +/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved.
> > > > > +*/
> > > >
> > > > So you did not touch this at all in 2021?  And it had a
> > > > copyrightable changed added to it for every year, inclusive, from 2016-2020?
> > > >
> > > > Please run this past your lawyers on how to do this properly.
> > >
> > > Ah, this was a "throw it over the fence at the community to handle for
> > > me before I go on vacation" type of posting, based on your autoresponse email that happened when I
> > sent this.
> > >
> > > That too isn't the most kind thing, would you want to be the reviewer
> > > of this if it were sent to you?  Please take some time and start doing
> > > patch reviews for the char/misc drivers on the mailing list before submitting any more new code.
> > >
> > > Also, this patch series goes agains the internal rules that I know
> > > your company has, why is that?  Those rules are there for a good
> > > reason, and by ignoring them, it's going to make it much harder to get patches to be reviewed.
> > >
> > 
> > I assume that you referred to the "Reviewed-by" rule from Intel. Since this is a RFC and we are seeking for
> > comments and guidance on our code structure, we thought it was appropriate to send out patch set out
> > with a full endorsement from our internal reviewers. The questions I posted in the cover letter (patch
> > 00/17) are from the discussions with our internal reviewers.
> .
> "we thought it was appropriate to send out the patch set out without* a full endorsement from our
> Internal reviewers"  --- sorry for misspelling.

I think you mean something like "we had an internal deadline to meet so
we are willing to ignore our rules and throw it over the wall and let
the community worry about it."

Congratulations, I now feel like the hours I spent last week talking to
hundreds of Intel developers about this very topic were totally wasted.

{sigh}

Intel now owes me another bottle of liquor...

greg k-h
