Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B35821296AD
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfLWNwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:52:49 -0500
Received: from mga07.intel.com ([134.134.136.100]:16790 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbfLWNwt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 08:52:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Dec 2019 05:52:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,347,1571727600"; 
   d="scan'208";a="214245229"
Received: from tblake-mobl2.ger.corp.intel.com ([10.252.4.201])
  by fmsmga008.fm.intel.com with ESMTP; 23 Dec 2019 05:52:44 -0800
Message-ID: <88b9ffdc51ae5e11341332d7f5efed07320251c6.camel@intel.com>
Subject: Re: [PATCH] Revert "iwlwifi: mvm: fix scan config command size"
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Thomas Backlund <tmb@mageia.org>, Roman Gilg <subdiff@gmail.com>,
        Mehmet Akif Tasova <makiftasova@gmail.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Tova Mussai <tova.mussai@intel.com>,
        Ayala Beker <ayala.beker@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 Dec 2019 15:52:43 +0200
In-Reply-To: <946da821-9e54-4508-e3ab-f2cdc19c8084@mageia.org>
References: <20191213203512.8250-1-makiftasova@gmail.com>
         <CAJcyoyusgtw0++KsEHK-t=EFGx2v9GKv7+BSViUCaB3nyDr2Jw@mail.gmail.com>
         <946da821-9e54-4508-e3ab-f2cdc19c8084@mageia.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-12-23 at 14:24 +0200, Thomas Backlund wrote:
> Den 18-12-2019 kl. 21:12, skrev Roman Gilg:
> > On Fri, Dec 13, 2019 at 9:36 PM Mehmet Akif Tasova
> > <makiftasova@gmail.com> wrote:
> > > Since Linux 5.4.1 released, iwlwifi could not initialize Intel(R) Dual Band
> > > Wireless AC 9462 firmware, failing with following error in dmesg:
> > > 
> > > iwlwifi 0000:00:14.3: FW error in SYNC CMD SCAN_CFG_CMD
> > > 
> > > whole dmesg output of error can be found at:
> > > https://gist.github.com/makiftasova/354e46439338f4ab3fba0b77ad5c19ec
> > > 
> > > also bug report from ArchLinux bug tracker (contains more info):
> > > https://bugs.archlinux.org/task/64703
> > 
> > Since this bug report is about the Dell XPS 13 2-in1: I tested your
> > revert with this device, but the issue persists at least on this
> > device. So these might be two different issues, one for your device
> > and another one for the XPS.
> 
> Yeah, to get iwlwifi to work somewhat nicely you need this revert

Indeed the revert is correct.  I'm going to apply it in our internal
tree and send it out for v5.5-rc* (with stable in CC so it goes to
v5.4).  Thanks Mehmet!


> [...]and also theese on top of 5.4.6:
> 
>  From db5cce1afc8d2475d2c1c37c2a8267dd0e151526 Mon Sep 17 00:00:00 2001
> From: Anders Kaseorg <andersk@mit.edu>
> Date: Mon, 2 Dec 2019 17:09:20 -0500
> Subject: Revert "iwlwifi: assign directly to iwl_trans->cfg in QuZ 
> detection"
> 
>  From 0df36b90c47d93295b7e393da2d961b2f3b6cde4 Mon Sep 17 00:00:00 2001
> From: Luca Coelho <luciano.coelho@intel.com>
> Date: Thu, 5 Dec 2019 09:03:54 +0200
> Subject: iwlwifi: pcie: move power gating workaround earlier in the flow

The fixes for these two are already in v5.5-rc3, [1] and [2]
respectively.  They are both marked for v5.4, hopefully they'll be
included in v5.4.7.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=db5cce1afc8d2475d2c1c37c2a8267dd0e151526
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0df36b90c47d93295b7e393da2d961b2f3b6cde4


> and atleast v2 of the "iwlwifi: mvm: don't send the 
> IWL_MVM_RXQ_NSSN_SYNC notif to Rx queues" patch that is being debated on 
> this list.

Kalle is on vacation, but when he gets, back we'll decide what to do
with this.  If he really doesn't like our v4, I'll send out a new
version that satisfies him so we can finally fix this bug.


> With theese in place, we seem to have it behaving properly again for 
> Mageia users reporting various problems / firmware crashes / ...

Thanks, Thomas, for the comprehensive list of fixes needed here!


--
Cheers,
Luca.

