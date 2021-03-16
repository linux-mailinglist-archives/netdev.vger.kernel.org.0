Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D963433CED7
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 08:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbhCPHuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 03:50:01 -0400
Received: from mga05.intel.com ([192.55.52.43]:1301 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232920AbhCPHtn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 03:49:43 -0400
IronPort-SDR: 6PHEbW71WGuPEm+JFVRhkTyxPtvyZcpcI0mzfhHWVJ0HsbZcWSRR/bh8bhrZAzllgASE0tDHGu
 Se80ubPa/7SQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="274259298"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="274259298"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 00:49:43 -0700
IronPort-SDR: FHC6uCu1cPcfY5Ovo0Wn8pBTWGzq9ofn3w88hUE81p8TQweOrSCNzKA+trIaiC+uNaTRiK3vpy
 bSIDCf6ZgdXg==
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="412121872"
Received: from chenyu-desktop.sh.intel.com (HELO chenyu-desktop) ([10.239.158.173])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 00:49:40 -0700
Date:   Tue, 16 Mar 2021 15:53:46 +0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, sassmann@redhat.com,
        kai.heng.feng@canonical.com, rjw@rjwysocki.net,
        len.brown@intel.com, todd.e.brandt@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        "yu.c.chen@intel.com Dvora Fuxbrumer" 
        <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 1/2] e1000e: Leverage direct_complete to speed
 up s2ram
Message-ID: <20210316075346.GA125266@chenyu-desktop>
References: <20210315190231.3302869-1-anthony.l.nguyen@intel.com>
 <20210315190231.3302869-2-anthony.l.nguyen@intel.com>
 <20210315140422.7a3d3bb2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315140422.7a3d3bb2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,
thanks for taking a look!
On Mon, Mar 15, 2021 at 02:04:22PM -0700, Jakub Kicinski wrote:
> On Mon, 15 Mar 2021 12:02:30 -0700 Tony Nguyen wrote:
> > +static __maybe_unused int e1000e_pm_prepare(struct device *dev)
> > +{
> > +	return pm_runtime_suspended(dev) &&
> > +		pm_suspend_via_firmware();
> 
> nit: I don't think you need to mark functions called by __maybe_unused
>      as __maybe_unused, do you?
> 
Not sure which function do you refer to having the __maybe_unused attribute
and invokes this e1000e_pm_prepare()?
I copied the definition from e1000e_pm_suspend() that if CONFIG_PM_SLEEP is not
set, we might get compile error of such PM hooks in this driver.
> The series LGTM although I don't know much about PM.
Thanks!

Best,
Chenyu
