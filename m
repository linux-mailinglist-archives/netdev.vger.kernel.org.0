Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26AC149C7CC
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240153AbiAZKpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:45:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:49236 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240130AbiAZKpa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 05:45:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643193930; x=1674729930;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=kERvq1ifgEgnAvnV19UgAWo345YAZUwV8YP1gTeW9Eg=;
  b=CyRcK27z2Q15lDsoiUZ471OTxNbbTuh2wmRTLS9nEH30StvGE97ZGeIq
   QlpVZVRE5zxq5w3ZdBDYpqHvyBLa1LVc3+2W/QguDxPXz/B6hzrbmVZ1t
   wJOQ70K3haaLLEaPx3PHi2YiUIwTzqp0h3cr0k6Fd65MhhiPZABw0aAUx
   W2z1wTEPi1n6EGS6qwAynjheCMwCV9F3D97y7tyc5rTx+dH6m2egiANhJ
   zd+AMnHAtJE1Qtl1IPUhutWE9pzhSPfI1IixH7hiNXi3gxJBHXn0+brPi
   iXAi3dCJOjBOfmEYqrnhhhcVtJREuCJVq2Mnp1dSvxMDYzk0DxU0aSH/H
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="233899667"
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="233899667"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 02:45:30 -0800
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="477445728"
Received: from unknown (HELO ijarvine-MOBL2.mshome.net) ([10.237.66.44])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 02:45:24 -0800
Date:   Wed, 26 Jan 2022 12:45:19 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v4 03/13] net: wwan: t7xx: Add core components
In-Reply-To: <b163fdb0-3b86-08d3-a6ef-efde3dde26ed@linux.intel.com>
Message-ID: <e5c618-849-ba1c-4f53-12f943b2d93@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-4-ricardo.martinez@linux.intel.com> <21cc8585-9bad-2322-44c2-fc99c4dccda0@linux.intel.com> <b163fdb0-3b86-08d3-a6ef-efde3dde26ed@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-446898368-1643193929=:3132"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-446898368-1643193929=:3132
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 25 Jan 2022, Martinez, Ricardo wrote:

> 
> On 1/24/2022 6:51 AM, Ilpo Järvinen wrote:
> > On Thu, 13 Jan 2022, Ricardo Martinez wrote:
> > 
> > > From: Haijun Liu <haijun.liu@mediatek.com>
> > > 
> > > Registers the t7xx device driver with the kernel. Setup all the core
> > > components: PCIe layer, Modem Host Cross Core Interface (MHCCIF),
> > > modem control operations, modem state machine, and build
> > > infrastructure.
> > > 
> > > * PCIe layer code implements driver probe and removal.
> > > * MHCCIF provides interrupt channels to communicate events
> > >    such as handshake, PM and port enumeration.
> > > * Modem control implements the entry point for modem init,
> > >    reset and exit.
> > > * The modem status monitor is a state machine used by modem control
> > >    to complete initialization and stop. It is used also to propagate
> > >    exception events reported by other components.
> > > 
> > > Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> > > Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> > > Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> > > Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> > > ---
> > Some states in t7xx_common.h (MD_STATE_...) would logically belong to this
> > patch instead of 02/. ...I think they were initally here but got moved
> > with t7xx_skb_data_area_size(). And there was also things clearly related
> > to 05/ in t7xx_common.h (at least CTL_ID_*).
> 
> Originally, 02 and 03 were going to be part of the same "Core functionality"
> patch,
> 
> the only reason for splitting it was to make that core patch smaller. The
> result is that
> 
> 02 uses code defined at 03, note that compilation is enabled at 03.
> 
> Will merge 02 and 03 in the next version, also clean t7xx_common.h from
> definitions
> 
> not used.

I didn't mind the core split itself but some things just logically seemed 
to clearly belong to the other side of the split (or to a later patch 
altogether). As the split was made mostly based on files rather than on 
logical level, it is no surprise some defs end up into wrong side of it.
That being said, then there's IMHO no need to go entirely overboard with 
this and fine-comb every single line in the header files.

And yes, I know the compile cannot fail until 03. However, the other 
aspect is that when somebody, a few years from now, has to look to 
these changes from the git history, having most of the elements in
logical places will help.


-- 
 i.

--8323329-446898368-1643193929=:3132--
