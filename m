Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5262FE34
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 18:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfD3Qzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 12:55:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50974 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfD3Qzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 12:55:50 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8EA5F60A42; Tue, 30 Apr 2019 16:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556643349;
        bh=d1iRsf4F2z9V/o+Mttdya64V61jxD6FJmL9Sbb5c4rU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dRlJqITIpTIeKH2kFazFIpghIYIHKRLsZExY/OUwPDD/P0bhqjIw86TooZQLteDWO
         k8nMDI7qsjq92UE+Hh0hZZi2sxJf2iXeXk9J1r1wTds1RqH19f2twJdTkwyIABefpx
         nxkTtlPRiMnB29QEhI4rd6ml0nsdoA7qDrlK+GQ4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B683760214;
        Tue, 30 Apr 2019 16:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556643348;
        bh=d1iRsf4F2z9V/o+Mttdya64V61jxD6FJmL9Sbb5c4rU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=iwrdSDqwIAJFr2YWw6YwfmFhLU30STWamHkZINhNuYCk7Y8t283enoJjjogwZFWYY
         OINDYJGDIftyqHoLOOtcHmfLles5KDNVfN+18gTZ7AOnUaGVWXmpZ8Aj50MnidQeC1
         iJSdvdu9cDlcy0EEqpgwp+0VeeZ7ab2ZTdd4V5MM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B683760214
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers 2019-04-30
References: <8736lzpm0m.fsf@kamboji.qca.qualcomm.com>
        <20190430.120117.1616322040923778364.davem@davemloft.net>
Date:   Tue, 30 Apr 2019 19:55:45 +0300
In-Reply-To: <20190430.120117.1616322040923778364.davem@davemloft.net> (David
        Miller's message of "Tue, 30 Apr 2019 12:01:17 -0400 (EDT)")
Message-ID: <87r29jo2jy.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Kalle Valo <kvalo@codeaurora.org>
> Date: Tue, 30 Apr 2019 18:10:01 +0300
>
>> here's one more pull request to net tree for 5.1, more info below.
>> 
>> Also note that this pull conflicts with net-next. And I want to emphasie
>> that it's really net-next, so when you pull this to net tree it should
>> go without conflicts. Stephen reported the conflict here:
>> 
>> https://lkml.kernel.org/r/20190429115338.5decb50b@canb.auug.org.au
>> 
>> In iwlwifi oddly commit 154d4899e411 adds the IS_ERR_OR_NULL() in
>> wireless-drivers but commit c9af7528c331 removes the whole check in
>> wireless-drivers-next. The fix is easy, just drop the whole check for
>> mvmvif->dbgfs_dir in iwlwifi/mvm/debugfs-vif.c, it's unneeded anyway.
>> 
>> As usual, please let me know if you have any problems.
>
> Pulled, thanks Kalle.

Great, thanks.

> Thanks for the conflict resolution information, it is very helpful.
>
> However, can you put it into the merge commit text next time as well?
> I cut and pasted it in there when I pulled this stuff in.

A good idea, I'll do that. Just to be sure, do you mean that I should
add it only with conflicts between net and net-next (like in this case)?
Or should I add it everytime I see a conflict, for example between
wireless-drivers-next and net-next? I hope my question is not too
confusing...

-- 
Kalle Valo
