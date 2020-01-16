Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD4213DC4B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgAPNqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:46:05 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:56829 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbgAPNqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 08:46:04 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579182363; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=Y9GHzjAM1zM7h/28lY72lnOTSt5XWYLk7EuIzZ5W14o=; b=J65oa/ANLK8GElx1wDh3h/bpwUY0KbqiUAqav1eKw3AklZOfjtSRdAxD2xLPpzmoQgedRgfN
 7wKcNnRNHA4kbgrV2yBAZ+F7+nTuUPLfJg/h690K3fI9jWXOKeHYPU63inGA+ssLfk78e/vC
 9SMkBvLS6b91S4ZcdIDbAj1ODrc=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e20691a.7f55bd282260-smtp-out-n03;
 Thu, 16 Jan 2020 13:46:02 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 37BC5C447A4; Thu, 16 Jan 2020 13:46:02 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B3D82C433A2;
        Thu, 16 Jan 2020 13:45:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B3D82C433A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Chen Zhou <chenzhou10@huawei.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, ath11k@lists.infradead.org
Subject: Re: [PATCH -next] mac80111: fix build error without CONFIG_ATH11K_DEBUGFS
References: <20200116125155.166749-1-chenzhou10@huawei.com>
        <d9e0af66e2d8cb26ef595e1a2133f55567f4b5e0.camel@sipsolutions.net>
        <943b570c-48f9-fe5b-1691-37539e3eeec8@huawei.com>
Date:   Thu, 16 Jan 2020 15:45:56 +0200
In-Reply-To: <943b570c-48f9-fe5b-1691-37539e3eeec8@huawei.com> (Chen Zhou's
        message of "Thu, 16 Jan 2020 21:35:44 +0800")
Message-ID: <87lfq7zf8r.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ ath11k

Chen Zhou <chenzhou10@huawei.com> writes:

> Hi johannes,
>
> On 2020/1/16 20:59, Johannes Berg wrote:
>> On Thu, 2020-01-16 at 20:51 +0800, Chen Zhou wrote:
>>> If CONFIG_ATH11K_DEBUGFS is n, build fails:
>>>
>>> drivers/net/wireless/ath/ath11k/debugfs_sta.c: In function ath11k_dbg_sta_open_htt_peer_stats:
>>> drivers/net/wireless/ath/ath11k/debugfs_sta.c:416:4: error: struct ath11k has no member named debug
>>>   ar->debug.htt_stats.stats_req = stats_req;
>>>       ^~
>>> and many more similar messages.
>>>
>>> Select ATH11K_DEBUGFS under config MAC80211_DEBUGFS to fix this.
>> 
>> Heh, no. You need to find a way in ath11 to fix this.
>
> In file drivers/net/wireless/ath/ath11k/Makefile, "ath11k-$(CONFIG_MAC80211_DEBUGFS) += debugfs_sta.o",
> that is, debugfs_sta only compiled when CONFIG_MAC80211_DEBUGFS is y.
>
> Any suggestions about this?

Arnd already fixed this:

https://patchwork.kernel.org/patch/11321921/

I'm planning to apply the patch soon.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
