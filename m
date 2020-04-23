Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47061B61B1
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 19:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbgDWRPZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Apr 2020 13:15:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:54156 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729674AbgDWRPY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 13:15:24 -0400
IronPort-SDR: r1MeSjDyF71qJdppm1BWSR5L7DGvnsEScIkTQmjloWfOG2LHZQ+eErJ/aoLWMxchVUFOgOJ8gK
 6GfeLK/VvdLg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 10:15:24 -0700
IronPort-SDR: omFd0JT0/w4rkhUDev+2EoEGUnsrUWQX2Bdwx0o0QG7ukg1DQI3Ky7ur41lOLnsvOmM0HaIRMN
 vk5SGpgQc+gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="292347956"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga008.jf.intel.com with ESMTP; 23 Apr 2020 10:15:23 -0700
Received: from fmsmsx153.amr.corp.intel.com (10.18.125.6) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 23 Apr 2020 10:15:23 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.70]) by
 FMSMSX153.amr.corp.intel.com ([169.254.9.123]) with mapi id 14.03.0439.000;
 Thu, 23 Apr 2020 10:15:23 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>
Subject: RE: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
 definitions
Thread-Topic: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
 definitions
Thread-Index: AQHWFNtu4ugEuh6AnUe8PZpOjYV9PKh+KgSAgAPqlNCAASOfAIAAk97AgACTTgD//+mbEIADAuyA//+LpnA=
Date:   Thu, 23 Apr 2020 17:15:22 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7DCD4ED27@fmsmsx124.amr.corp.intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-2-jeffrey.t.kirsher@intel.com>
 <20200417193421.GB3083@unreal>
 <9DD61F30A802C4429A01CA4200E302A7DCD4853F@fmsmsx124.amr.corp.intel.com>
 <20200421004628.GQ26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4A3E9@fmsmsx124.amr.corp.intel.com>
 <20200421182256.GT26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4DB92@fmsmsx124.amr.corp.intel.com>
 <20200423150201.GY26002@ziepe.ca>
In-Reply-To: <20200423150201.GY26002@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
> definitions
> 
> On Thu, Apr 23, 2020 at 12:32:48AM +0000, Saleem, Shiraz wrote:
> 
> > we have a split initialization design for gen2 and future products.
> > phase1 is control path resource initialization in irdma_probe_dev and
> > phase-2 is the rest of the resources with the ib registration at the
> > end of irdma_open. irdma_close must de-register the ib device which
> > will take care of ibdev free too. So it makes sense to keep allocation
> > of the ib device in irdma_open.
> 
> The best driver pattern is to allocate the ib_device at the very start of probe() and
> use this to anchor all the device resources and memories.
> 
> The whole close/open thing is really weird, you should get rid of it.
maybe I missing something. But why is it weird?

underlying configuration changes and reset management for the physical
function need a light-weight mechanism which is realized with the close/open
from netdev PCI drv --> rdma drv.
Without a teardown and re-add of virtual device off the bus.

