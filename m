Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D3A177A6D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729872AbgCCP3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:29:42 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:45235 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728918AbgCCP3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:29:41 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583249381; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=DGm1tyLTMS++kedpz+qyweZ6Iu5ZVMUBPPMKBo/asTk=;
 b=c9BFRZS0k4ZknSfvlgu20oHGUDYUWbMJ47BXC8HbCJE8C9jyrAXaO8SanLF3jceZH/hZysgJ
 6vmIXDghLkwANibjHBYkZxk0nCy61zoHagihUSKVGiyvZDXSWidCNFlQ1vN0nlK4g9qZuohF
 1EFWmjWHHY11try0BRAVDipWY/Q=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e5e77d6.7fae349aa0a0-smtp-out-n01;
 Tue, 03 Mar 2020 15:29:26 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4C552C4479C; Tue,  3 Mar 2020 15:29:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A491FC43383;
        Tue,  3 Mar 2020 15:29:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A491FC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: pcie: restore support for Killer Qu C0 NICs
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191224051639.6904-1-jan.steffens@gmail.com>
References: <20191224051639.6904-1-jan.steffens@gmail.com>
To:     "Jan Alexander Steffens (heftig)" <jan.steffens@gmail.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jan Alexander Steffens (heftig)" <jan.steffens@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200303152925.4C552C4479C@smtp.codeaurora.org>
Date:   Tue,  3 Mar 2020 15:29:25 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jan Alexander Steffens (heftig)" <jan.steffens@gmail.com> wrote:

> Commit 809805a820c6 ("iwlwifi: pcie: move some cfg mangling from
> trans_pcie_alloc to probe") refactored the cfg mangling. Unfortunately,
> in this process the lines which picked the right cfg for Killer Qu C0
> NICs after C0 detection were lost. These lines were added by commit
> b9500577d361 ("iwlwifi: pcie: handle switching killer Qu B0 NICs to
> C0").
> 
> I suspect this is more of the "merge damage" which commit 7cded5658329
> ("iwlwifi: pcie: fix merge damage on making QnJ exclusive") talks about.
> 
> Restore the missing lines so the driver loads the right firmware for
> these NICs.
> 
> Fixes: 809805a820c6 ("iwlwifi: pcie: move some cfg mangling from trans_pcie_alloc to probe")
> Signed-off-by: Jan Alexander Steffens (heftig) <jan.steffens@gmail.com>

As Luca said, this fails to apply to wireless-drivers. Please rebase and
resend as v2.

Recorded preimage for 'drivers/net/wireless/intel/iwlwifi/pcie/drv.c'
error: Failed to merge in the changes.
Applying: iwlwifi: pcie: restore support for Killer Qu C0 NICs
Using index info to reconstruct a base tree...
M	drivers/net/wireless/intel/iwlwifi/pcie/drv.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/intel/iwlwifi/pcie/drv.c
CONFLICT (content): Merge conflict in drivers/net/wireless/intel/iwlwifi/pcie/drv.c
Patch failed at 0001 iwlwifi: pcie: restore support for Killer Qu C0 NICs
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/11309095/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
