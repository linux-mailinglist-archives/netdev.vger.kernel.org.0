Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E5430AF3E
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhBAS3A convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 1 Feb 2021 13:29:00 -0500
Received: from mga04.intel.com ([192.55.52.120]:64944 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232415AbhBASQF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 13:16:05 -0500
IronPort-SDR: B3p4QzppAx4kfC3sj6vCSm4kIAJ9hh2YEr0imo+lsVy49T+oQDhqQt5jzYfLODqr2fqUjK/VOM
 cvDHZe95+WSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="178166436"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="178166436"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 10:15:22 -0800
IronPort-SDR: dvCjgyKhYcL47WefTYb6YfXh9uNQbwUSlH0b/gL9WzIxSoQ3ZJt6bcpJzKm6KKNNhOmvKgTpIJ
 8+g8/rWf3xzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="479181864"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga001.fm.intel.com with ESMTP; 01 Feb 2021 10:15:21 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 1 Feb 2021 10:15:20 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 1 Feb 2021 10:15:20 -0800
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2106.002;
 Mon, 1 Feb 2021 10:15:20 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>
Subject: RE: [PATCH net-next 10/15] ice: display some stored NVM versions via
 devlink info
Thread-Topic: [PATCH net-next 10/15] ice: display some stored NVM versions via
 devlink info
Thread-Index: AQHW9deu/kIAhBaH902yWvZefJUQeapAP00AgANaZrA=
Date:   Mon, 1 Feb 2021 18:15:20 +0000
Message-ID: <8403365008c14c959ad9ca63f29891a4@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
        <20210129004332.3004826-11-anthony.l.nguyen@intel.com>
 <20210129223754.0376285e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129223754.0376285e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
> Sent: Friday, January 29, 2021 10:38 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; Keller, Jacob E <jacob.e.keller@intel.com>;
> netdev@vger.kernel.org; sassmann@redhat.com; Brelinski, TonyX
> <tonyx.brelinski@intel.com>
> Subject: Re: [PATCH net-next 10/15] ice: display some stored NVM versions via
> devlink info
> 
> On Thu, 28 Jan 2021 16:43:27 -0800 Tony Nguyen wrote:
> > When reporting the versions via devlink info, first read the device
> > capabilities. If there is a pending flash update, use this new function
> > to extract the inactive flash versions. Add the stored fields to the
> > flash version map structure so that they will be displayed when
> > available.
> 
> Why only report them when there is an update pending?
> 
> The expectation was that you'd always report what you can and user
> can tell the update is pending by comparing the fields.

The data in the inactive bank might not be a valid image. There's no straightforward way to verify this except by detecting that we're about to switch banks on the next reboot. If we report this information all the time, in some cases it would be reporting numbers which are meaningless and not actually valid version information. I had assumed this would lead to more confusion than only reporting the data when the bank has data we know is going to be activated soon

