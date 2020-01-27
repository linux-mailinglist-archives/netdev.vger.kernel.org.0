Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAEED14A647
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgA0OhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:37:24 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:43972 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726443AbgA0OhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 09:37:24 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580135843; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=jcqUypoTfMISgMlEHGdNws8j1IKYxgwokJDYGYbDuQU=;
 b=xf8R/LJQWWJ1ei3EhQLBsWkzzmeAWktL4PHJKF3ucJ02oFGWdakdPt506r/h82SYyE02L1Aw
 zUAqBMQQipPq7p5FF24+O8FOeeg6hqN9ukYK7r655lhJVoACDGgi+wmRDzMNUalYylQw+9PA
 PIvyuf/VVbjdMdvsu14bRJPzJtM=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2ef59e.7fee2384f500-smtp-out-n01;
 Mon, 27 Jan 2020 14:37:18 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 981A6C433CB; Mon, 27 Jan 2020 14:37:18 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0CE76C43383;
        Mon, 27 Jan 2020 14:37:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0CE76C43383
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
Message-Id: <20200127143718.981A6C433CB@smtp.codeaurora.org>
Date:   Mon, 27 Jan 2020 14:37:18 +0000 (UTC)
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
> Fixes: e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss descriptor")
> Signed-off-by: Nicolai Stange <nstange@suse.de>

2 patches applied to wireless-drivers.git, thanks.

c7bf1fb7ddca libertas: don't exit from lbs_ibss_join_existing() with RCU read lock held
1754c4f60aaf libertas: make lbs_ibss_join_existing() return error code on rates overflow

-- 
https://patchwork.kernel.org/patch/11331869/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
