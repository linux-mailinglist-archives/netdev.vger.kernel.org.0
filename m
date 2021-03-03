Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F1932C46F
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354982AbhCDAN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:13:56 -0500
Received: from z11.mailgun.us ([104.130.96.11]:58146 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245073AbhCCP6B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 10:58:01 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614787057; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Bk8N7ltWopTTqKsfTNF0yc3K+wDZTbr+CiOMIc1zrJM=;
 b=gNHciC5E0GS10BNo2hmr49TypHZwr14gu2+YWTr6O6woTexAkpob5AYo+LSSSvwn2d0p1i9K
 LU98OrJK0VHNxZVncR+vkfN0reyqkYxjVd2KvaMUdaH2mmcdWJVxCQ58Y/0cxkKv6HSrtlEN
 p0BpJrPh6UeOwtAFrASKEqlxqEM=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 603fb1d060050cf4d0e96afa (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 03 Mar 2021 15:57:04
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 917D5C433C6; Wed,  3 Mar 2021 15:57:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 33CA8C433ED;
        Wed,  3 Mar 2021 15:56:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 33CA8C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: iwlwifi: mvm: add terminate entry for dmi_system_id tables
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210223140039.1708534-1-weiyongjun1@huawei.com>
References: <20210223140039.1708534-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Hulk Robot <hulkci@huawei.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
        Gil Adam <gil.adam@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210303155704.917D5C433C6@smtp.codeaurora.org>
Date:   Wed,  3 Mar 2021 15:57:04 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wei Yongjun <weiyongjun1@huawei.com> wrote:

> Make sure dmi_system_id tables are NULL terminated. This crashed when LTO was enabled:
> 
> BUG: KASAN: global-out-of-bounds in dmi_check_system+0x5a/0x70
> Read of size 1 at addr ffffffffc16af750 by task NetworkManager/1913
> 
> CPU: 4 PID: 1913 Comm: NetworkManager Not tainted 5.12.0-rc1+ #10057
> Hardware name: LENOVO 20THCTO1WW/20THCTO1WW, BIOS N2VET27W (1.12 ) 12/21/2020
> Call Trace:
>  dump_stack+0x90/0xbe
>  print_address_description.constprop.0+0x1d/0x140
>  ? dmi_check_system+0x5a/0x70
>  ? dmi_check_system+0x5a/0x70
>  kasan_report.cold+0x7b/0xd4
>  ? dmi_check_system+0x5a/0x70
>  __asan_load1+0x4d/0x50
>  dmi_check_system+0x5a/0x70
>  iwl_mvm_up+0x1360/0x1690 [iwlmvm]
>  ? iwl_mvm_send_recovery_cmd+0x270/0x270 [iwlmvm]
>  ? setup_object.isra.0+0x27/0xd0
>  ? kasan_poison+0x20/0x50
>  ? ___slab_alloc.constprop.0+0x483/0x5b0
>  ? mempool_kmalloc+0x17/0x20
>  ? ftrace_graph_ret_addr+0x2a/0xb0
>  ? kasan_poison+0x3c/0x50
>  ? cfg80211_iftype_allowed+0x2e/0x90 [cfg80211]
>  ? __kasan_check_write+0x14/0x20
>  ? mutex_lock+0x86/0xe0
>  ? __mutex_lock_slowpath+0x20/0x20
>  __iwl_mvm_mac_start+0x49/0x290 [iwlmvm]
>  iwl_mvm_mac_start+0x37/0x50 [iwlmvm]
>  drv_start+0x73/0x1b0 [mac80211]
>  ieee80211_do_open+0x53e/0xf10 [mac80211]
>  ? ieee80211_check_concurrent_iface+0x266/0x2e0 [mac80211]
>  ieee80211_open+0xb9/0x100 [mac80211]
>  __dev_open+0x1b8/0x280
> 
> Fixes: a2ac0f48a07c ("iwlwifi: mvm: implement approved list for the PPAG feature")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> Tested-by: Victor Michel <vic.michel.web@gmail.com>
> Acked-by: Luca Coelho <luciano.coelho@intel.com>
> [kvalo@codeaurora.org: improve commit log]

Patch applied to wireless-drivers.git, thanks.

a22549f12767 iwlwifi: mvm: add terminate entry for dmi_system_id tables

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210223140039.1708534-1-weiyongjun1@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

