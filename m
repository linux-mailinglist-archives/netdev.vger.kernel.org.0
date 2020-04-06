Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD19519F7AA
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 16:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgDFOLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 10:11:05 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:23892 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728405AbgDFOLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 10:11:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586182264; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=T762Ltvl3MIN58a0l0ALvp6dao1KdO6KlC6hvEUSLiQ=;
 b=uegtYdbvnEkod1cKIgBTsFY1PpWXe75IXqnWxhwbI9XZkI7MYjgL0CuB5jcnKJvLI8RcrKeJ
 DpJVP8uLaLXEM8TjjJYzZPNBvNIK6ubsBtV9nC5BJJhE0b4R5LJCVvIwvBWOkgCVJqQWUIkN
 904TjVKvAkZji4+zp4qBK3leXKA=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e8b3872.7f29c75bb260-smtp-out-n03;
 Mon, 06 Apr 2020 14:10:58 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 29895C43637; Mon,  6 Apr 2020 14:10:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8EF11C433D2;
        Mon,  6 Apr 2020 14:10:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8EF11C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: actually check allocated conf_tlv pointer
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200402050219.4842-1-chris@rorvick.com>
References: <20200402050219.4842-1-chris@rorvick.com>
To:     Chris Rorvick <chris@rorvick.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Rorvick <chris@rorvick.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200406141058.29895C43637@smtp.codeaurora.org>
Date:   Mon,  6 Apr 2020 14:10:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Rorvick <chris@rorvick.com> wrote:

> Commit 71bc0334a637 ("iwlwifi: check allocated pointer when allocating
> conf_tlvs") attempted to fix a typoe introduced by commit 17b809c9b22e
> ("iwlwifi: dbg: move debug data to a struct") but does not implement the
> check correctly.
> 
> This can happen in OOM situations and, when it does, we will potentially try to
> dereference a NULL pointer.
> 
> Tweeted-by: @grsecurity
> Signed-off-by: Chris Rorvick <chris@rorvick.com>

Fails to build, please rebase on top of wireless-drivers.

drivers/net/wireless/intel/iwlwifi/iwl-drv.c: In function 'iwl_req_fw_callback':
drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1470:16: error: 'struct iwl_fw' has no member named 'dbg_conf_tlv'
    if (!drv->fw.dbg_conf_tlv[i])
                ^
make[5]: *** [drivers/net/wireless/intel/iwlwifi/iwl-drv.o] Error 1
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [drivers/net/wireless/intel/iwlwifi] Error 2
make[3]: *** [drivers/net/wireless/intel] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/11470125/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
