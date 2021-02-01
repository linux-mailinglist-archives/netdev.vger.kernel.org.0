Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728B130AF3F
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhBAS3G convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 1 Feb 2021 13:29:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:21701 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232405AbhBASQE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 13:16:04 -0500
IronPort-SDR: NSvZ0lHb0Q15AdRYePe8TGp1FPPRIcDi4fHX8dKlA9OGIjIYTAaP8KBA/AbTPvaa85qmXdGBxY
 vW4MUfLciwjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="180805829"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="180805829"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 10:15:20 -0800
IronPort-SDR: XRqBZRBHKGB/1WagHC57l6VQtmWwDCpCO0l6DTeVrX+jOZtx2rKkeyIK4/FbHnikbH9Hll2+Wp
 1cLFSZhxMMTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="432461821"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 01 Feb 2021 10:15:20 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 1 Feb 2021 10:15:20 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 1 Feb 2021 10:15:19 -0800
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2106.002;
 Mon, 1 Feb 2021 10:15:19 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>
Subject: RE: [PATCH net-next 03/15] ice: read security revision to
 ice_nvm_info and ice_orom_info
Thread-Topic: [PATCH net-next 03/15] ice: read security revision to
 ice_nvm_info and ice_orom_info
Thread-Index: AQHW9detDO34SHTlSEeGIOn6G2DRAKpAQQmAgANZA6A=
Date:   Mon, 1 Feb 2021 18:15:19 +0000
Message-ID: <339cfa644eec45a7bc7b1b24dfe8b04e@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
        <20210129004332.3004826-4-anthony.l.nguyen@intel.com>
 <20210129224407.0529a802@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129224407.0529a802@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, January 29, 2021 10:44 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; Keller, Jacob E <jacob.e.keller@intel.com>;
> netdev@vger.kernel.org; sassmann@redhat.com; Brelinski, TonyX
> <tonyx.brelinski@intel.com>
> Subject: Re: [PATCH net-next 03/15] ice: read security revision to ice_nvm_info
> and ice_orom_info
> 
> On Thu, 28 Jan 2021 16:43:20 -0800 Tony Nguyen wrote:
> > From: Jacob Keller <jacob.e.keller@intel.com>
> >
> > The main NVM module and the Option ROM module contain a security
> > revision in their CSS header. This security revision is used to
> > determine whether or not the signed module should be loaded at bootup.
> > If the module security revision is lower than the associated minimum
> > security revision, it will not be loaded.
> >
> > The CSS header does not have a module id associated with it, and thus
> > requires flat NVM reads in order to access it. To do this, take
> > advantage of the cached bank information. Introduce a new
> > "ice_read_flash_module" function that takes the module and bank to read.
> > Implement both ice_read_active_nvm_module and
> > ice_read_active_orom_module. These functions will use the cached values
> > to determine the active bank and calculate the appropriate offset.
> >
> > Using these new access functions, extract the security revision for both
> > the main NVM bank and the Option ROM into the associated info structure.
> >
> > Add the security revisions to the devlink info output. Report the main
> > NVM bank security revision as "fw.mgmt.srev". Report the Option ROM
> > security revision as "fw.undi.srev".
> >
> > A future patch will add the associated minimum security revisions as
> > devlink flash parameters.
> 
> This needs a wider discussion. Hopefully we can agree on a reasonably
> uniform way of handling this across vendors. Having to fish out
> _particular_ version keys out and then target _particular_ parameters
> for each vendor is not great.
> 

Yea, I can see how that would be problematic. It does seem like some sort of tied interface would make sense.

> First off - is there a standard around the version management that we
> can base the interface on? What about key management? There's gotta be
> a way of revoking keys too, right?
> 

I am not sure. None of the implementation I've written deals with key management and it wasn't an ask.

> 
> I'd recommend separating the srev patches out of the series so the
> other ones can land.

Sure, We can do that.
