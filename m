Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8990234D50A
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhC2QZj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Mar 2021 12:25:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:53517 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231686AbhC2QZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 12:25:20 -0400
IronPort-SDR: PA0hT1Aj2WxZWOP6dEft7qoD4bLrfO0ctVkDpsDn63pTuTQzNnkqx51utqphchOtckuluHAtOu
 7mPa8tE00oMA==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="255578520"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="255578520"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 09:25:18 -0700
IronPort-SDR: CBjPOPboEJfGhA8GgVDYKP0eR6+zw66LHPgNUmYCeQ7+6VLsI9GqTERa6f0cL6j54MN/hClsYh
 Wg1NsBMjFtOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="376484213"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga003.jf.intel.com with ESMTP; 29 Mar 2021 09:25:18 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 29 Mar 2021 09:25:17 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 29 Mar 2021 09:25:16 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Mon, 29 Mar 2021 09:25:16 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Parav Pandit <parav@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH v2 05/23] ice: Add devlink params support
Thread-Topic: [PATCH v2 05/23] ice: Add devlink params support
Thread-Index: AQHXIEEcbZGM34aJmkKTShEWbKmaC6qTB12AgAH624CABp30gP//ix2Q
Date:   Mon, 29 Mar 2021 16:25:16 +0000
Message-ID: <b558d34577594116ac1c0a16789ce172@intel.com>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
 <20210324000007.1450-6-shiraz.saleem@intel.com>
 <BY5PR12MB43228B823CA619460AAF2099DC639@BY5PR12MB4322.namprd12.prod.outlook.com>
 <9ae54c8e60fe4036bd3016cfa0798dac@intel.com>
 <20210329160751.GE2356281@nvidia.com>
In-Reply-To: <20210329160751.GE2356281@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v2 05/23] ice: Add devlink params support
> 
> On Thu, Mar 25, 2021 at 08:10:13PM +0000, Saleem, Shiraz wrote:
> 
> > Maybe I am missing something but I see that a devlink hot reload is
> > required to enforce the update?  There isn't really a de-init required
> > of PCI driver entities in this case for this rdma param.
> > But only an unplug, plug of the auxdev with new value. Intuitively it
> > feels more runtime-ish.
> >
> > There is also a device powerof2 requirement on the maxqp which I don't
> > see enforceable as it stands.
> >
> > This is not super-critical for the initial submission but a nice to
> > have. But I do want to brainstorm options..
> 
> devlink upai often seems to be an adventure, can you submit this driver without
> devlink (or any other uapis) then debate how to add them in as followup patches?
> 

Yes to removing this particular param 'resource_limits_sel' from first submission.
I think Parav has given some good pointers. Will review internally and continue the discussion.
And submit follow on patch for it.

W.r.t protocol selection, without devlink, user cannot configure roce (iwarp is default) on the function.
So its good to get that in if possible. It seemed people were ok with our approach on it.

Shiraz


