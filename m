Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D57E10891C
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 08:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfKYHZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 02:25:05 -0500
Received: from mga03.intel.com ([134.134.136.65]:8498 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfKYHZE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 02:25:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Nov 2019 23:25:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,240,1571727600"; 
   d="scan'208";a="206031621"
Received: from slehanex-mobl1.ger.corp.intel.com ([10.252.10.177])
  by fmsmga008.fm.intel.com with ESMTP; 24 Nov 2019 23:24:59 -0800
Message-ID: <ea75c55485c0d893b15a67462728b45b775921b0.camel@intel.com>
Subject: Re: iwlwifi: Checking a kmemdup() call in iwl_req_fw_callback()
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Markus Elfring <Markus.Elfring@web.de>,
        linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Kangjie Lu <kjlu@umn.edu>, Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>
Date:   Mon, 25 Nov 2019 09:24:58 +0200
In-Reply-To: <71774617-79f9-1365-4267-a15a47422d10@web.de>
References: <71774617-79f9-1365-4267-a15a47422d10@web.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-10-12 at 19:26 +0200, Markus Elfring wrote:
> Hello,
> 
> I tried another script for the semantic patch language out.
> This source code analysis approach points out that the implementation
> of the function “iwl_req_fw_callback” contains still an unchecked call
> of the function “kmemdup”.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/wireless/intel/iwlwifi/iwl-drv.c?id=1c0cc5f1ae5ee5a6913704c0d75a6e99604ee30a#n1454
> https://elixir.bootlin.com/linux/v5.4-rc2/source/drivers/net/wireless/intel/iwlwifi/iwl-drv.c#L1454
> 
> Can it be that just an other data structure member should be used
> for the desired null pointer check at this place?

Hi Markus,

Sorry for the delay in replying to this.

I've checked this now and you are right.  We are checking the element
in the array that contains the length of the allocation we requested
instead of checking the pointer returned by kmemdup().  This was
probably a typo.

I have fixed this in our internal tree and it will reach the mainline
following our normal upstreaming process.

Thanks for reporting!

--
Cheers,
Luca.

