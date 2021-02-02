Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14F430CCCE
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 21:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240477AbhBBUIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 15:08:51 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:41367 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbhBBUIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 15:08:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612296485; x=1643832485;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RKeIouPfYkF0dzBJ5Fr1sj32s0c2UpAxGehgP0ipTIk=;
  b=uJ99v+zInCceXDFxcWbQb53kxFD3o7OUp1wBaEoRo4An+CpVgE0G1iGc
   MrD01HMfmbRuizuzlZTCMYEq2LAek5MbivyKWHYtXKPdI/INoIIiOHtDg
   bEPqSA0ZTLoPb0WqBBmpNef9dvonUIiURHoEWPR/Wvbo/aCWBbTy23ZZ8
   p4Y5LB+6n/UwUFYeMV/6rv7CQzFF5Ioj3H605813QJ9uslmkuwY8YJpA1
   MMqV0UBHoqSwHC/kMjFpX1sXGcAm85r7sdBPc/tmU1eS/lmRPnl/7X2ET
   hisqglL8ZsJHwAAiQL+3WVTAs04JbyC5Zg3OIx7XWpYVelTz0WwslGKca
   g==;
IronPort-SDR: 2xhiryMspxkpjTx8/URWFWFtt5AZqaoYtryTyoFruivUi+L6BjodWopkvomUtuzFv0TRs7RFLJ
 QCtdHBGyisQAQwHMJiKa4eZ9F2993pp8dvvqpQwH1WeGHCflqUfh8K9g15UFxbMl5tH2r87rBe
 ICS9IG3ZfSQsw3qIRPgwacdAuxk1ks5sunoGYO2waIcA5km5vo/VjojVsFKDJswHK4iSy91mc2
 Unq7G1oi5SU6sM1n/9Pa9qYk/hWSAYFb598US+0JC9hnbv9lZF/d3utjCizc4eXDgIaTbTQs9r
 glQ=
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="42661970"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2021 13:06:50 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 2 Feb 2021 13:06:50 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 2 Feb 2021 13:06:49 -0700
Date:   Tue, 2 Feb 2021 21:06:49 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next v2 0/4] bridge: mrp: Extend br_mrp_switchdev_*
Message-ID: <20210202200649.mc7vpgltoqxf2oni@soft-dev3.localdomain>
References: <20210127205241.2864728-1-horatiu.vultur@microchip.com>
 <20210129190114.3f5b6b44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9143d15f-c41d-f0ab-7be0-32d797820384@prevas.dk>
 <20210202115032.6affffdc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210202115032.6affffdc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/02/2021 11:50, Jakub Kicinski wrote:
> 
> On Tue, 2 Feb 2021 08:40:02 +0100 Rasmus Villemoes wrote:
> > On 30/01/2021 04.01, Jakub Kicinski wrote:
> > > On Wed, 27 Jan 2021 21:52:37 +0100 Horatiu Vultur wrote:
> > >> This patch series extends MRP switchdev to allow the SW to have a better
> > >> understanding if the HW can implement the MRP functionality or it needs
> > >> to help the HW to run it. There are 3 cases:
> >
> > >> v2:
> > >>  - fix typos in comments and in commit messages
> > >>  - remove some of the comments
> > >>  - move repeated code in helper function
> > >>  - fix issue when deleting a node when sw_backup was true
> > >
> > > Folks who were involved in previous MRP conversations - does this look
> > > good to you? Anyone planning to test?
> >
> > I am planning to test these, but it's unlikely I'll get around to it
> > this week unfortunately.
> 
> Horatiu are you okay with deferring the series until Rasmus validates?
> Given none of this HW is upstream now (AFAIU) this is an awkward set
> to handle. Having a confirmation from Rasmus would make us a little bit
> more comfortable.

It is perfectly fine for me to wait for Rasmus to validate this series.
Also I have started to have a look how to implement the switchdev calls
for Ocelot driver. I might have something by the end of the week, but
lets see.

-- 
/Horatiu
