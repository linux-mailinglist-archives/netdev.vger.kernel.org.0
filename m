Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA8716AAE
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 20:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfEGSvE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 May 2019 14:51:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:2159 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbfEGSvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 14:51:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 11:51:03 -0700
X-ExtLoop1: 1
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by orsmga006.jf.intel.com with ESMTP; 07 May 2019 11:51:03 -0700
Received: from orsmsx125.amr.corp.intel.com (10.22.240.125) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 7 May 2019 11:51:03 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.109]) by
 ORSMSX125.amr.corp.intel.com ([169.254.3.172]) with mapi id 14.03.0415.000;
 Tue, 7 May 2019 11:51:02 -0700
From:   "Michael, Alice" <alice.michael@intel.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Marczak, Piotr" <piotr.marczak@intel.com>,
        "Buchholz, Donald" <donald.buchholz@intel.com>
Subject: RE: [net-next v2 11/11] i40e: Introduce recovery mode support
Thread-Topic: [net-next v2 11/11] i40e: Introduce recovery mode support
Thread-Index: AQHVAgVO9K/GGfRe8Um4Tagu1xo8RqZbTDgAgASsqEA=
Date:   Tue, 7 May 2019 18:51:02 +0000
Message-ID: <CD14C679C9B9B1409B02829D9B523C290AE87E5E@ORSMSX112.amr.corp.intel.com>
References: <20190503230939.6739-1-jeffrey.t.kirsher@intel.com>
        <20190503230939.6739-12-jeffrey.t.kirsher@intel.com>
 <20190504073522.3bc7e00d@cakuba.netronome.com>
In-Reply-To: <20190504073522.3bc7e00d@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMTg5MTQ3MTItMzExYi00YzAwLTkyN2ItYTM2OWMxMTE1M2IwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoialwvWTdnUGNoMWwyRHJVaVRJcm43SzAzaWF2SVBCRWJ5eTU0bTVqOFlaRUZyYTJcLzJXWkJmRlhtRG9iK2pWMkx6In0=
x-ctpclassification: CTP_NT
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski [mailto:jakub.kicinski@netronome.com]
> Sent: Saturday, May 4, 2019 4:35 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; Michael, Alice
> <alice.michael@intel.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; nhorman@redhat.com;
> sassmann@redhat.com; Marczak, Piotr <piotr.marczak@intel.com>; Buchholz,
> Donald <donald.buchholz@intel.com>
> Subject: Re: [net-next v2 11/11] i40e: Introduce recovery mode support
> 
> On Fri,  3 May 2019 16:09:39 -0700, Jeff Kirsher wrote:
> > From: Alice Michael <alice.michael@intel.com>
> >
> > This patch introduces "recovery mode" to the i40e driver. It is part
> > of a new Any2Any idea of upgrading the firmware. In this approach, it
> > is required for the driver to have support for "transition firmware",
> > that is used for migrating from structured to flat firmware image. In
> > this new, very basic mode, i40e driver must be able to handle
> > particular IOCTL calls from the NVM Update Tool and run a small set of
> > AQ commands.
> 
> What's the "particular IOCTL" you speak of?  This patch adds a fake netdev with
> a .set_eeprom callback.  Are you wrapping the AQ commands in the set_eeprom
> now?  Or is there some other IOCTL here?

Yes.  The NVMUpdate tool uses the ethtool IOCTL to call the driver's .set_eeprom callback.  This then triggers the firmware AQ command.  The fake netdev needs to have ethtool support to finish upgrading the firmware using the eeprom interface.
 
> Let me repeat my other question - can the netdev you spawn in
> i40e_init_recovery_mode() pass traffic?

No, the device is not expected to pass traffic.  This mode is to allow the NVMUpdate to program the NVM.
 
~Alice
