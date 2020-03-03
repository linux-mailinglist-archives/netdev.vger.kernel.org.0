Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A66B176EDE
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgCCFkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:40:42 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:40463 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725840AbgCCFkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 00:40:42 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583214041; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=qr3JVYtKfOWIi/bSPDEd0ztBd3h/rs+zEN/13ZtS5I8=; b=iED+vhrTLLtWIGmt2f6BBKkhQcCCHHeELED6jG0a7TTyqeVFBonQh+H/KCwp2ALzhMQ5Lqrn
 mffuODzuc8X7Wj48XNhEDbfWoTLnOS81/fpTz2jDmkKFY0LpOluL5qm6f/DRif2AHNZ7dQhB
 6tFcPbo2m85WJnc/bwyXnbpE3Rs=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e5dedd2.7ff80c9b47a0-smtp-out-n03;
 Tue, 03 Mar 2020 05:40:34 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 22058C4479C; Tue,  3 Mar 2020 05:40:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 70B65C43383;
        Tue,  3 Mar 2020 05:40:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 70B65C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Leho Kraav <leho@kraav.com>
Cc:     "Jan Alexander Steffens \(heftig\)" <jan.steffens@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: pcie: restore support for Killer Qu C0 NICs
References: <20191224051639.6904-1-jan.steffens@gmail.com>
        <20200221121135.GA9056@papaya>
Date:   Tue, 03 Mar 2020 07:40:26 +0200
In-Reply-To: <20200221121135.GA9056@papaya> (Leho Kraav's message of "Fri, 21
        Feb 2020 14:11:35 +0200")
Message-ID: <871rqauhbp.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leho Kraav <leho@kraav.com> writes:

> On Tue, Dec 24, 2019 at 06:16:39AM +0100, Jan Alexander Steffens (heftig) wrote:
>> Commit 809805a820c6 ("iwlwifi: pcie: move some cfg mangling from
>> trans_pcie_alloc to probe") refactored the cfg mangling. Unfortunately,
>> in this process the lines which picked the right cfg for Killer Qu C0
>> NICs after C0 detection were lost. These lines were added by commit
>> b9500577d361 ("iwlwifi: pcie: handle switching killer Qu B0 NICs to
>> C0").
>> 
>> I suspect this is more of the "merge damage" which commit 7cded5658329
>> ("iwlwifi: pcie: fix merge damage on making QnJ exclusive") talks about.
>> 
>> Restore the missing lines so the driver loads the right firmware for
>> these NICs.
>
> This seems real, as upgrading 5.5.0 -> 5.5.5 just broke my iwlwifi on XPS 7390.
> How come?

Luca, should I apply this to wireless-drivers?

https://patchwork.kernel.org/patch/11309095/

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
