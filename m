Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249DA1B32AA
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 00:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDUWgY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Apr 2020 18:36:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:13922 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgDUWgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 18:36:23 -0400
IronPort-SDR: F4+WM55c8SEFpsXlBPOFxxJCM+jO6JeWiLFPs+IE8yzjYUAWx6cJg1tINm6Hf4K7ovF8y0myA5
 kuKTaTIR1yzw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 15:36:23 -0700
IronPort-SDR: hSJxiPhzqiHA087KObs2+U7YZavfWMtUDEjSVEuzm39j74GNCZjio2ZS0H5kJzHZbpa4yRAuBY
 sgfitVSNbGKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="279803925"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga004.fm.intel.com with ESMTP; 21 Apr 2020 15:36:22 -0700
Received: from orsmsx156.amr.corp.intel.com (10.22.240.22) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 15:36:22 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.248]) by
 ORSMSX156.amr.corp.intel.com ([169.254.8.70]) with mapi id 14.03.0439.000;
 Tue, 21 Apr 2020 15:36:22 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kwapulinski, Piotr" <piotr.kwapulinski@intel.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next 3/4] i40e: Add support for a new feature: Total Port
 Shutdown
Thread-Topic: [net-next 3/4] i40e: Add support for a new feature: Total Port
 Shutdown
Thread-Index: AQHWF38oXbYwrraOr02XwU5N6bu+wKiEUoqA///VLFA=
Date:   Tue, 21 Apr 2020 22:36:21 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D9404498670105@ORSMSX112.amr.corp.intel.com>
References: <20200421014932.2743607-1-jeffrey.t.kirsher@intel.com>
        <20200421014932.2743607-4-jeffrey.t.kirsher@intel.com>
 <20200421105551.6f41673a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200421105551.6f41673a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, April 21, 2020 10:56
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Kubalewski, Arkadiusz
> <arkadiusz.kubalewski@intel.com>; netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; Kwapulinski, Piotr
> <piotr.kwapulinski@intel.com>; Loktionov, Aleksandr
> <aleksandr.loktionov@intel.com>; Bowers, AndrewX
> <andrewx.bowers@intel.com>
> Subject: Re: [net-next 3/4] i40e: Add support for a new feature: Total Port
> Shutdown
> 
> On Mon, 20 Apr 2020 18:49:31 -0700 Jeff Kirsher wrote:
> > From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> >
> > Currently after requesting to down a link on a physical network port,
> > the traffic is no longer being processed but the physical link with a
> > link partner is still established.
> >
> > Total Port Shutdown allows to completely shutdown the port on the
> > link-down procedure by physically removing the link from the port.
> >
> > Introduced changes:
> > - probe NVM if the feature was enabled at initialization of the port
> > - special handling on link-down procedure to let FW physically
> > shutdown the port if the feature was enabled
> 
> How is this different than link-down-on-close?
[Kirsher, Jeffrey T] 

First of all total-port-shutdown is a read only flag, the user cannot set it
from the OS.  It is possible to set it in bios, but only if the motherboard
supports it and the NIC has that capability.  Also, the behavior on both
slightly differs, link-down-on-close brings the link down by sending
(to firmware) phy_type=0, while total-port-shutdown does not, the
phy_type is not changed, instead firmware is using
I40E_AQ_PHY_ENABLE_LINK flag. 

> 
> Perhaps it'd be good to start documenting the private flags in Documentation/
[Kirsher, Jeffrey T] 

We could look at adding that information into our kernel documentation, I am
planning on updating the driver documentation in a follow-up patch set.  Would
a descriptive code comment help in this case? 

> 
> > Testing Hints (required if no HSD):
> > Link up/down, link-down-on-close
> >
> > Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> > Signed-off-by: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
> > Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> > Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> 
> > @@ -12012,6 +12085,16 @@ static int i40e_sw_init(struct i40e_pf *pf)
> >
> >  	pf->tx_timeout_recovery_level = 1;
> >
> > +	if (pf->hw.mac.type != I40E_MAC_X722 &&
> > +	    i40e_is_total_port_shutdown_enabled(pf)) {
> > +		/* Link down on close must be on when total port shutdown
> > +		 * is enabled for a given port
> > +		 */
> > +		pf->flags |= (I40E_FLAG_TOTAL_PORT_SHUTDOWN
> > +			  | I40E_FLAG_LINK_DOWN_ON_CLOSE_ENABLED);
> 
> FWIW this is the correct code style in the kernel:
> 
> flags = BLA |
>         BLA2;
[Kirsher, Jeffrey T] 

This will get fixed in v2.

> 
> > +		dev_info(&pf->pdev->dev,
> > +			 "Total Port Shutdown is enabled, link-down-on-close
> forced on\n");
> > +	}
> >  	mutex_init(&pf->switch_mutex);
> >
> >  sw_init_done:
