Return-Path: <netdev+bounces-8721-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 89BAB725564
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:22:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF7191C20B4A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1146AAE;
	Wed,  7 Jun 2023 07:22:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529C11C3A
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:22:38 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DBA1994
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 00:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686122557; x=1717658557;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4S3CoNm+dv9nHHXRJFlqfzFDDu50Pd8nQJe4Gf0uvHw=;
  b=HC2DdjbxZ5CGy426BdP9cu/lMgWzKzkHMw0/1XnlXPfRo+K9JUwvBnZP
   3KYtrtWyuW6zaHcAwgswr25/iCOiLH3lz4Z6IlpP4hDnacuzwvDjQW/7K
   /0Oxv0b3lvQEVg2vtnTaGvKRciO3iofEHF92XM3NwGae78tPvOcK1+EHH
   j+3KjJoLNREJdIqyZmily77YDSn/hbd2n/0HQoNw3Zmm6NWmnkGG7NS/Z
   nsRar9Q1eIpT/WP2N4hjS1pQBfu3TEClaVibj+yDRqW7GTb7E+5qSxhaD
   paRxMXDHcQlk8gMEBK2fwGilyYxpyRfgppy1Eijio5jyG7VjfK1AA9Tbx
   g==;
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="228825845"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jun 2023 00:22:36 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 7 Jun 2023 00:22:36 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Wed, 7 Jun 2023 00:22:35 -0700
Date: Wed, 7 Jun 2023 07:22:34 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: "Ertman, David M" <david.m.ertman@intel.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 04/10] ice: implement lag netdev event handler
Message-ID: <20230607072234.5svu7wo3z5p76kpr@DEN-LT-70577>
References: <20230605182258.557933-1-david.m.ertman@intel.com>
 <20230605182258.557933-5-david.m.ertman@intel.com>
 <20230606095648.xy5d7mdzqyhqwqdg@DEN-LT-70577>
 <MW5PR11MB5811B2361A466FAA3094C4D1DD52A@MW5PR11MB5811.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <MW5PR11MB5811B2361A466FAA3094C4D1DD52A@MW5PR11MB5811.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > > The event handler for LAG will create a work item to place on the ordered
> > > workqueue to be processed.
> > >
> > > Add in defines for training packets and new recipes to be used by the
> > > switching block of the HW for LAG packet steering.
> > >
> > > Update the ice_lag struct to reflect the new processing methodology.
> > >
> > > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > > ---
> > >  drivers/net/ethernet/intel/ice/ice_lag.c      | 125 ++++++++++++++++--
> > >  drivers/net/ethernet/intel/ice/ice_lag.h      |  31 ++++-
> > >  drivers/net/ethernet/intel/ice/ice_virtchnl.c |   2 +
> > >  3 files changed, 144 insertions(+), 14 deletions(-)
> 
> 
> > > +       lag_work = kzalloc(sizeof(*lag_work), GFP_KERNEL);
> > > +       if (!lag_work)
> > > +               return -ENOMEM;
> > > +
> > > +       lag_work->event_netdev = netdev;
> > > +       lag_work->lag = lag;
> > > +       lag_work->event = event;
> > > +       if (event == NETDEV_CHANGEUPPER) {
> > > +               struct netdev_notifier_changeupper_info *info;
> > > +
> > > +               info = ptr;
> > > +               upper_netdev = info->upper_dev;
> > > +       } else {
> > > +               upper_netdev = netdev_master_upper_dev_get(netdev);
> > > +       }
> > > +
> > > +       INIT_LIST_HEAD(&lag_work->netdev_list.node);
> > > +       if (upper_netdev) {
> > > +               struct ice_lag_netdev_list *nd_list;
> > > +               struct net_device *tmp_nd;
> > > +
> > > +               rcu_read_lock();
> > > +               for_each_netdev_in_bond_rcu(upper_netdev, tmp_nd) {
> > > +                       nd_list = kzalloc(sizeof(*nd_list), GFP_KERNEL);
> > > +                       if (!nd_list)
> > > +                               break;
> >
> > Further up, -ENOMEM is returned in case kzalloc fails. Here the error is
> > silently ignored - is this correct? :)
> 
> The lag_work above is the container struct that needs to be present for any work
> to be done for the event.  But, as the list of elements of the bond gets built, if a single element is
> not present, it is still possible for the event to be evaluated.  There could be the issue of
> complete functionality if the wrong element is missing, but that will be handled in the processing
> of the specific event.

Ah I see. Thank you for explaining.


