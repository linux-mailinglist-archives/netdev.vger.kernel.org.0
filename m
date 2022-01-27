Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2B449E92B
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiA0Rgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:36:33 -0500
Received: from mga06.intel.com ([134.134.136.31]:15160 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234505AbiA0Rgc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 12:36:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643304992; x=1674840992;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=uOVaM3aqU2efVKuIV1QKNA+69ITzm5/5egkZQYxJzPY=;
  b=Kxi+WRWBrz1hmiCZ52znWF45esqlQ9uMUtVC2s1H+RcoGvNONzwPndhc
   dk1f2WgYVeKlNHdktgJOuxJou4sqkGov5zFTlaJ+Yiz+vIFmwYuhN2NUQ
   WEUU8xRn4Ez2Dm7p6zhshrzM5pkQHVbKfQXT3AuA7WsmV+Eq/XaxgqUKO
   b8UtRjGl/HOA6dcZiI0b08IG1uVmsV2POT/sA6vXjU4E1hGTk/4AjwG2W
   d9q02upkAvy3zhMAGVMgtXazjsKrl64aDZgcUMYxqo+wnr8ehYuOtTJXK
   BBJnBMa2LqYfG0pa54KW1MRxHYwxyxb2a7m8Xr8A9eCnmEe6iyT1UR0xY
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="307633372"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="307633372"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 09:36:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="535753201"
Received: from pstepan-mobl2.ger.corp.intel.com ([10.249.43.201])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 09:36:24 -0800
Date:   Thu, 27 Jan 2022 19:36:16 +0200 (EET)
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
Message-ID: <8b47678-7c66-e62f-e5b-442a1a14138e@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-4-ricardo.martinez@linux.intel.com> <21cc8585-9bad-2322-44c2-fc99c4dccda0@linux.intel.com> <b163fdb0-3b86-08d3-a6ef-efde3dde26ed@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-478051102-1643304991=:1631"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-478051102-1643304991=:1631
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 25 Jan 2022, Martinez, Ricardo wrote:

> On 1/24/2022 6:51 AM, Ilpo Järvinen wrote:
> > On Thu, 13 Jan 2022, Ricardo Martinez wrote:

> > > +int t7xx_fsm_append_cmd(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_cmd_state
> > > cmd_id, unsigned int flag)
> > No callsite in this patch seems to care about the error code, is it ok?
> 
> Even though there's no recovery path (like retry) for t7xx_fsm_append_cmd()
> failures, it makes sense to
> 
> propagate the error instead of ignoring it, will add that in the next version.
> 
> > E.g.:
> > > +int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
> > > +{
> > > ...
> > If this returns an error, does it mean init/probe stalls? Or is there
> > some backup to restart?
> An error here will cause probe to fail, there's no recovery path for this.

Just to clarify, I think you misunderstood what I meant as you cut the 
critical line out in the reply. ...I meant heare that if 
t7xx_fsm_append_cmd returns an error, it will not make the probe to fail 
but lead to probe stalling (which propagating the error you intend to do 
will nicely address).


-- 
 i.

--8323329-478051102-1643304991=:1631--
