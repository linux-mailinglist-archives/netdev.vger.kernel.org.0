Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A35C27B236
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 18:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgI1Qp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 12:45:58 -0400
Received: from z5.mailgun.us ([104.130.96.5]:10005 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbgI1Qp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 12:45:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601311555; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=EwLls1l2z9jQQMpLSZ/QNlDEPqzOa0ZtxBdYi31RjBE=; b=i/pMuR5xfenDvf9byrlZW8zLhf77gzJPYD41Vwar9rXx+YOpw4NBE/ZNAEpBmb7O1DhXSrS0
 n4Xp29z0WcmuG4ESJ7ZAaLGMW+zztw2Pstvk0jCONp9QrOSCxRyi+oYI29fDxrYuVVPNKDpx
 E4DT5JjqdwrMzTt+fuA7q0CesCE=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f721338f38f205ebcd0bba9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 28 Sep 2020 16:45:44
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 30DACC43385; Mon, 28 Sep 2020 16:45:44 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2EEE5C433F1;
        Mon, 28 Sep 2020 16:45:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2EEE5C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Loic Poulain <loic.poulain@linaro.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ath11k@lists.infradead.org,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Govind Singh <govinds@codeaurora.org>,
        David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the mhi tree
References: <20200928184230.2d973291@canb.auug.org.au>
        <20200928091035.GA11515@linux> <87eemmfdn3.fsf@codeaurora.org>
        <20200928094704.GB11515@linux>
Date:   Mon, 28 Sep 2020 19:45:37 +0300
In-Reply-To: <20200928094704.GB11515@linux> (Manivannan Sadhasivam's message
        of "Mon, 28 Sep 2020 15:17:04 +0530")
Message-ID: <87a6x9g89a.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:

> On Mon, Sep 28, 2020 at 12:34:40PM +0300, Kalle Valo wrote:
>> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:
>> 
>> > On Mon, Sep 28, 2020 at 06:42:30PM +1000, Stephen Rothwell wrote:
>> >> Hi all,
>> >> 
>> >> After merging the mhi tree, today's linux-next build (x86_64 allmodconfig)
>> >> failed like this:
>> >> 
>> >> drivers/net/wireless/ath/ath11k/mhi.c:27:4: error: 'struct
>> >> mhi_channel_config' has no member named 'auto_start'
>> >>    27 |   .auto_start = false,
>> >>       |    ^~~~~~~~~~
>> >> drivers/net/wireless/ath/ath11k/mhi.c:42:4: error: 'struct
>> >> mhi_channel_config' has no member named 'auto_start'
>> >>    42 |   .auto_start = false,
>> >>       |    ^~~~~~~~~~
>> >> drivers/net/wireless/ath/ath11k/mhi.c:57:4: error: 'struct
>> >> mhi_channel_config' has no member named 'auto_start'
>> >>    57 |   .auto_start = true,
>> >>       |    ^~~~~~~~~~
>> >> drivers/net/wireless/ath/ath11k/mhi.c:72:4: error: 'struct
>> >> mhi_channel_config' has no member named 'auto_start'
>> >>    72 |   .auto_start = true,
>> >>       |    ^~~~~~~~~~
>> >> 
>> >> Caused by commit
>> >> 
>> >>   ed39d7816885 ("bus: mhi: Remove auto-start option")
>> >> 
>> >> interacting with commit
>> >> 
>> >>   1399fb87ea3e ("ath11k: register MHI controller device for QCA6390")
>> >> 
>> >> from the net-next tree.
>> >> 
>> >> I applied the following merge fix patch, but maybe more is required.
>> >> Even if so, this could be fixed now in the net-next tree.
>> >> 
>> >> From: Stephen Rothwell <sfr@canb.auug.org.au>
>> >> Date: Mon, 28 Sep 2020 18:39:41 +1000
>> >> Subject: [PATCH] fix up for "ath11k: register MHI controller device for QCA6390"
>> >> 
>> >> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> >
>> > Sorry, I forgot to submit a patch against net-next for fixing this while merging
>> > the MHI change.
>> 
>> Try to notify the ath11k list (CCed) whenever changing MHI API so that
>> we (ath11k folks) can be prepared for any major changes.
>> 
>
> Okay sure, will do!

Thanks. It's important that ath11k is taken into account while making
changes to MHI, otherwise there can easily be regressions.

I was looking at commit ed39d7816885 ("bus: mhi: Remove auto-start
option") and noticed this in the commit log:

    This is really up to the MHI device(channel) driver to manage the state
    of its channels.

So does this mean we have to make changes in ath11k to accomodate this?
I haven't tested linux-next yet.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
