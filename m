Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1703A34857F
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 00:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbhCXXr3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 24 Mar 2021 19:47:29 -0400
Received: from mga18.intel.com ([134.134.136.126]:42147 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234898AbhCXXq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 19:46:57 -0400
IronPort-SDR: FYawhP1L8bPQIGFrnlPh1X++U448w3kWNamt6gnf2BswZFHt6COolIF4M317DNtANmx5hal2QA
 YHfOIPBpmb4w==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="178363352"
X-IronPort-AV: E=Sophos;i="5.81,276,1610438400"; 
   d="scan'208";a="178363352"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 16:46:43 -0700
IronPort-SDR: xpoIvy36speLUBKlET1zW6DVnHarpb48WlWjuG3JPOlfp74K3fLmClHswbuFI4qo5ZRTja8ncR
 eZfQ/ypW3ocw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,276,1610438400"; 
   d="scan'208";a="413949654"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 24 Mar 2021 16:46:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 24 Mar 2021 16:46:42 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 24 Mar 2021 16:46:42 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Wed, 24 Mar 2021 16:46:42 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: RE: [PATCH v2 08/23] RDMA/irdma: Register auxiliary driver and
 implement private channel OPs
Thread-Topic: [PATCH v2 08/23] RDMA/irdma: Register auxiliary driver and
 implement private channel OPs
Thread-Index: AQHXIEEe8YLi1xzKuUiZSQHXOrFbqaqTnVIAgAADsACAAAShAIAABPuAgAAOWBA=
Date:   Wed, 24 Mar 2021 23:46:42 +0000
Message-ID: <cc3dfb411c2248fdb3a5adc042d22893@intel.com>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
 <20210324000007.1450-9-shiraz.saleem@intel.com> <YFtC9hWHYiCR9vIC@unreal>
 <20210324140046.GA481507@nvidia.com> <YFtJ8EraVBJsYjuT@unreal>
 <20210324143509.GB481507@nvidia.com>
In-Reply-To: <20210324143509.GB481507@nvidia.com>
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

> Subject: Re: [PATCH v2 08/23] RDMA/irdma: Register auxiliary driver and
> implement private channel OPs
> 
> On Wed, Mar 24, 2021 at 04:17:20PM +0200, Leon Romanovsky wrote:
> > On Wed, Mar 24, 2021 at 11:00:46AM -0300, Jason Gunthorpe wrote:
> > > On Wed, Mar 24, 2021 at 03:47:34PM +0200, Leon Romanovsky wrote:
> > > > On Tue, Mar 23, 2021 at 06:59:52PM -0500, Shiraz Saleem wrote:
> > > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > >
> > > > > Register auxiliary drivers which can attach to auxiliary RDMA
> > > > > devices from Intel PCI netdev drivers i40e and ice. Implement
> > > > > the private channel ops, and register net notifiers.
> > > > >
> > > > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > > drivers/infiniband/hw/irdma/i40iw_if.c | 229 +++++++++++++
> > > > >  drivers/infiniband/hw/irdma/main.c     | 382 ++++++++++++++++++++++
> > > > >  drivers/infiniband/hw/irdma/main.h     | 565
> +++++++++++++++++++++++++++++++++
> > > > >  3 files changed, 1176 insertions(+)  create mode 100644
> > > > > drivers/infiniband/hw/irdma/i40iw_if.c
> > > > >  create mode 100644 drivers/infiniband/hw/irdma/main.c
> > > > >  create mode 100644 drivers/infiniband/hw/irdma/main.h
> > > >
> > > > <...>
> > > >
> > > > > +/* client interface functions */ static const struct
> > > > > +i40e_client_ops i40e_ops = {
> > > > > +	.open = i40iw_open,
> > > > > +	.close = i40iw_close,
> > > > > +	.l2_param_change = i40iw_l2param_change };
> > > > > +
> > > > > +static struct i40e_client i40iw_client = {
> > > > > +	.ops = &i40e_ops,
> > > > > +	.type = I40E_CLIENT_IWARP,
> > > > > +};
> > > > > +
> > > > > +static int i40iw_probe(struct auxiliary_device *aux_dev, const
> > > > > +struct auxiliary_device_id *id) {
> > > > > +	struct i40e_auxiliary_device *i40e_adev = container_of(aux_dev,
> > > > > +							       struct
> i40e_auxiliary_device,
> > > > > +							       aux_dev);
> > > > > +	struct i40e_info *cdev_info = i40e_adev->ldev;
> > > > > +
> > > > > +	strncpy(i40iw_client.name, "irdma", I40E_CLIENT_STR_LENGTH);
> > > > > +	cdev_info->client = &i40iw_client;
> > > > > +	cdev_info->aux_dev = aux_dev;
> > > > > +
> > > > > +	return cdev_info->ops->client_device_register(cdev_info);
> > > >
> > > > Why do we need all this indirection? I see it as leftover from
> > > > previous version where you mixed auxdev with your peer registration logic.
> > >
> > > I think I said the new stuff has to be done sanely, but the i40iw
> > > stuff is old and already like this.
> >
> > They declared this specific "ops" a couple of lines above and all the
> > functions are static. At least for the new code, in the irdma, this "ops"
> > thing is not needed.
> 
> It is the code in the 'core' i40iw driver that requries this, AFAICT
> 
 Yes.
