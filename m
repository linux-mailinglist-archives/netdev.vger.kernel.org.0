Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318654E3E86
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 13:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbiCVMde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 08:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiCVMdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 08:33:33 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783226D867;
        Tue, 22 Mar 2022 05:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647952325; x=1679488325;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=whvh601WI9v3GtquiQCtN3tCwEdYSA9tQKGmcV2TCX4=;
  b=jCs+fqCpJ57jrbOsdyJCHXDRvZRjcp+wEVD44wt6svV+GvmnX8OOp292
   CFGoKLT7ynDQqsWHqN68qMaT7wtHnfixOzMQECsM6Km9wpRwT7bXpDZZG
   lXSKRvY1cFI9whicqPkAvxoqUFHVFwkDFVDW9p2fppl+s6/No/ms/jrWV
   e+x/yTRdBed5pJneG6anCm9cO08ACvO7E5/7U9yhpVgktUkEM5p1bGujR
   wFRIxkbxn2OXEL7OWi+yjtDD8840dGycJItIcxXlbnt73rDYjJa/8V9e+
   BHomS+yczuDQiItd7cTg9G56o2xZc3dUPJ8vcygLr6V3ukIXgDprzWIuJ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10293"; a="245279558"
X-IronPort-AV: E=Sophos;i="5.90,201,1643702400"; 
   d="scan'208";a="245279558"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 05:32:05 -0700
X-IronPort-AV: E=Sophos;i="5.90,201,1643702400"; 
   d="scan'208";a="560365733"
Received: from dcolomor-mobl1.ger.corp.intel.com ([10.252.55.151])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 05:31:59 -0700
Date:   Tue, 22 Mar 2022 14:31:44 +0200 (EET)
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
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
Subject: Re: [PATCH net-next v5 12/13] net: wwan: t7xx: Device deep sleep
 lock/unlock
In-Reply-To: <a43666ad-4216-29e9-762d-ade19fd77620@linux.intel.com>
Message-ID: <a4eeb46f-2df1-16a6-b0e4-c6ea7683b75f@linux.intel.com>
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-13-ricardo.martinez@linux.intel.com> <1aca9e1f-8b6b-d3e2-d3ff-1bf37abe63f5@linux.intel.com> <a43666ad-4216-29e9-762d-ade19fd77620@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-2107175543-1647952324=:1722"
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-2107175543-1647952324=:1722
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 18 Mar 2022, Martinez, Ricardo wrote:

> 
> On 3/10/2022 2:21 AM, Ilpo Järvinen wrote:
> > On Wed, 23 Feb 2022, Ricardo Martinez wrote:
> > 
> > > From: Haijun Liu <haijun.liu@mediatek.com>
> > > 
> > > Introduce the mechanism to lock/unlock the device 'deep sleep' mode.
> > > When the PCIe link state is L1.2 or L2, the host side still can keep
> > > the device is in D0 state from the host side point of view. At the same
> > > time, if the device's 'deep sleep' mode is unlocked, the device will
> > > go to 'deep sleep' while it is still in D0 state on the host side.
> > > 
> > > Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> > > Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> > > Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> > > Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> > > ---
> ...
> > > +int t7xx_pci_sleep_disable_complete(struct t7xx_pci_dev *t7xx_dev)
> > > +{
> > > +	struct device *dev = &t7xx_dev->pdev->dev;
> > > +	int ret;
> > > +
> > > +	ret = wait_for_completion_timeout(&t7xx_dev->sleep_lock_acquire,
> > > +
> > > msecs_to_jiffies(PM_SLEEP_DIS_TIMEOUT_MS));
> > > +	if (!ret)
> > > +		dev_err_ratelimited(dev, "Resource wait complete timed
> > > out\n");
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +/**
> > > + * t7xx_pci_disable_sleep() - Disable deep sleep capability.
> > > + * @t7xx_dev: MTK device.
> > > + *
> > > + * Lock the deep sleep capability, note that the device can still go into
> > > deep sleep
> > > + * state while device is in D0 state, from the host's point-of-view.
> > > + *
> > > + * If device is in deep sleep state, wake up the device and disable deep
> > > sleep capability.
> > > + */
> > > +void t7xx_pci_disable_sleep(struct t7xx_pci_dev *t7xx_dev)
> > > +{
> > > +	unsigned long flags;
> > > +
> > > +	if (atomic_read(&t7xx_dev->md_pm_state) < MTK_PM_RESUMED) {
> > > +		atomic_inc(&t7xx_dev->sleep_disable_count);
> > > +		complete_all(&t7xx_dev->sleep_lock_acquire);
> > > +		return;
> > > +	}
> > > +
> > > +	spin_lock_irqsave(&t7xx_dev->md_pm_lock, flags);
> > > +	if (atomic_inc_return(&t7xx_dev->sleep_disable_count) == 1) {
> > > +		u32 deep_sleep_enabled;
> > > +
> > > +		reinit_completion(&t7xx_dev->sleep_lock_acquire);
> > You might want to check that there's a mechanism that prevents this
> > racing with wait_for_completion_timeout() in
> > t7xx_pci_sleep_disable_complete().
> > 
> > I couldn't prove it myself but there are probably aspect in the PM side of
> > things I wasn't able to take fully into account (that is, which call
> > paths are not possible to occur).
> Those functions are called in the following order:
> 1.- t7xx_pci_disable_sleep()
> 2.- t7xx_pci_sleep_disable_complete()
> 3.- t7xx_pci_enable_sleep()

That sequence gets called from 5 places:

- t7xx_cldma_send_skb
- t7xx_dpmaif_rxq_work
- t7xx_dpmaif_bat_release_work
- t7xx_dpmaif_tx_done
- t7xx_dpmaif_tx_hw_push_thread + t7xx_do_tx_hw_push

Which of those can run parallel to each other, I'm not sure of. But they 
can, the race is likely there between those "instances" of the sequence, 
one instance doing reinit_completion() and the other 
wait_for_completion_timeout().

> That sequence and md_pm_lock protect against a race condition between
> wait_for_completion_timeout() and  reinit_completion().

wait_for_completion_timeout() is not protected by md_pm_lock. There is 
a path with return in t7xx_pci_disable_sleep() before taking md_pm_lock.

> On the other hand, there could be a race condition between
> t7xx_pci_disable_sleep() and t7xx_pci_enable_sleep() which may cause sleep to
> get enabled while one thread expects it to be disabled.

...And once sleep gets enabled, this can get true, no?

	if (atomic_read(&t7xx_dev->md_pm_state) < MTK_PM_RESUMED) {

...after which there's nothing which protects 
wait_for_completion_timeout() from racing with another instance of 
the sequence which has not yet executed reinit_completion()?

I think you found the very race which I was worried about. :-)

> The fix would be to protect sleep_disable_count with md_pm_lock, then
> sleep_disable_count doesn't need to be declared as atomic.
> The next version will include cleanup in this area.

Ok. I'll take a look once you post the next version.

-- 
 i.

--8323329-2107175543-1647952324=:1722--
