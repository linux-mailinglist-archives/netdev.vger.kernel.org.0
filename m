Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B9DB642E
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 15:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbfIRNRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 09:17:08 -0400
Received: from mga05.intel.com ([192.55.52.43]:58261 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbfIRNRG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 09:17:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Sep 2019 06:17:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,520,1559545200"; 
   d="scan'208";a="202054130"
Received: from lngladki-mobl2.ccr.corp.intel.com ([10.252.31.176])
  by fmsmga001.fm.intel.com with ESMTP; 18 Sep 2019 06:17:02 -0700
Message-ID: <d135b9ba7900c28b3d11560666a4790e015490a2.camel@intel.com>
Subject: Re: [PATCH net] iwlwifi: add dependency of THERMAL with IWLMVM
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Kalle Valo <kvalo@codeaurora.org>, Mao Wenan <maowenan@huawei.com>
Cc:     johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        linuxwifi@intel.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date:   Wed, 18 Sep 2019 16:17:02 +0300
In-Reply-To: <875zlpbvks.fsf@kamboji.qca.qualcomm.com>
References: <20190918122815.155657-1-maowenan@huawei.com>
         <875zlpbvks.fsf@kamboji.qca.qualcomm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-09-18 at 16:08 +0300, Kalle Valo wrote:
> Mao Wenan <maowenan@huawei.com> writes:
> 
> > If CONFIG_IWLMVM=y, CONFIG_THERMAL=n, below error can be found:
> > drivers/net/wireless/intel/iwlwifi/mvm/fw.o: In function `iwl_mvm_up':
> > fw.c:(.text+0x2c26): undefined reference to `iwl_mvm_send_temp_report_ths_cmd'
> > make: *** [vmlinux] Error 1
> > 
> > After commit 242d9c8b9a93 ("iwlwifi: mvm: use FW thermal
> > monitoring regardless of CONFIG_THERMAL"), iwl_mvm_up()
> > calls iwl_mvm_send_temp_report_ths_cmd(), but this function
> > is under CONFIG_THERMAL, which is depended on CONFIG_THERMAL.
> > 
> > Fixes: 242d9c8b9a93 ("iwlwifi: mvm: use FW thermal monitoring regardless of CONFIG_THERMAL")
> > Signed-off-by: Mao Wenan <maowenan@huawei.com>
> 
> Luca, should I apply this directly to wireless-drivers?

No, this patch defeats the point of the patch it fixes.

We have a proper fix already internally, which I haven't sent out yet,
that moves a couple of #ifdef's around to solve the issue.  I'll send
the patch in a sec.

--
Cheers,
Luca.

