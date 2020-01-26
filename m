Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4380149B53
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 16:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgAZPOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 10:14:54 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:10576 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725907AbgAZPOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 10:14:54 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580051693; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Y+S8D8aDvc3709rvH/pShWk38I9cJw+rSMPM2E0L9S8=;
 b=fhpIg5X5ebJ5x/08bu6fjpa9X8OEXU1MmFZbrJR9kkFNaLi7HaMA5JfgLnacUcSrP0OZIdrz
 jJ4oufCAEo/GjLdHQKEbVQApVgFdizKJgbi3o1H2HX3wtKH+eJoHu06RKHDlPxj4XwgTnrix
 ovWpPJ+OWkzuRoLeX37aPPMJkGQ=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2dacec.7f4b9dbd7ab0-smtp-out-n02;
 Sun, 26 Jan 2020 15:14:52 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DB95CC433A2; Sun, 26 Jan 2020 15:14:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0BFB3C433CB;
        Sun, 26 Jan 2020 15:14:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0BFB3C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] libertas: don't exit from lbs_ibss_join_existing()
 with RCU read lock held
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200114103903.2336-2-nstange@suse.de>
References: <20200114103903.2336-2-nstange@suse.de>
To:     Nicolai Stange <nstange@suse.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Wen Huang <huangwenabc@gmail.com>,
        Nicolai Stange <nstange@suse.de>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Miroslav Benes <mbenes@suse.cz>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126151452.DB95CC433A2@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 15:14:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nicolai Stange <nstange@suse.de> wrote:

> Commit e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss
> descriptor") introduced a bounds check on the number of supplied rates to
> lbs_ibss_join_existing().
> 
> Unfortunately, it introduced a return path from within a RCU read side
> critical section without a corresponding rcu_read_unlock(). Fix this.
> 
> Fixes: e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss
>                       descriptor")
> Signed-off-by: Nicolai Stange <nstange@suse.de>

I'll queue these to v5.5, unless Linus releases the final today and then they
will go to v5.6.

-- 
https://patchwork.kernel.org/patch/11331869/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
