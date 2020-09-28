Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C6727AAD8
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 11:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgI1Jer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 05:34:47 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:33101 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726595AbgI1Jer (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 05:34:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601285686; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=XDkFYolIXBeYJmN2F3eJjYClVgegd+Zf0+FD/Oy7wJY=; b=ufvCizgNrnZndzwcGPd6Xci8S7g+ZBYb3ImhCXUXDDW2ONzXHTInid3fz160H+Yoptf6NsgX
 wdAsmpx1UhsGAz5z/UGlHZ1X37BJdvSZFVmgyE8mcT7n0ekVbdomCBYjO/y+/G+Q5zNRaKIx
 FPtmR5+BkGRedzEBpbxi+f8DP64=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f71ae355fb64f6e37d10048 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 28 Sep 2020 09:34:45
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DF466C433CB; Mon, 28 Sep 2020 09:34:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C3F9AC433C8;
        Mon, 28 Sep 2020 09:34:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C3F9AC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Govind Singh <govinds@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ath11k@lists.infradead.org
Subject: Re: linux-next: build failure after merge of the mhi tree
References: <20200928184230.2d973291@canb.auug.org.au>
        <20200928091035.GA11515@linux>
Date:   Mon, 28 Sep 2020 12:34:40 +0300
In-Reply-To: <20200928091035.GA11515@linux> (Manivannan Sadhasivam's message
        of "Mon, 28 Sep 2020 14:40:35 +0530")
Message-ID: <87eemmfdn3.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:

> On Mon, Sep 28, 2020 at 06:42:30PM +1000, Stephen Rothwell wrote:
>> Hi all,
>> 
>> After merging the mhi tree, today's linux-next build (x86_64 allmodconfig)
>> failed like this:
>> 
>> drivers/net/wireless/ath/ath11k/mhi.c:27:4: error: 'struct
>> mhi_channel_config' has no member named 'auto_start'
>>    27 |   .auto_start = false,
>>       |    ^~~~~~~~~~
>> drivers/net/wireless/ath/ath11k/mhi.c:42:4: error: 'struct
>> mhi_channel_config' has no member named 'auto_start'
>>    42 |   .auto_start = false,
>>       |    ^~~~~~~~~~
>> drivers/net/wireless/ath/ath11k/mhi.c:57:4: error: 'struct
>> mhi_channel_config' has no member named 'auto_start'
>>    57 |   .auto_start = true,
>>       |    ^~~~~~~~~~
>> drivers/net/wireless/ath/ath11k/mhi.c:72:4: error: 'struct
>> mhi_channel_config' has no member named 'auto_start'
>>    72 |   .auto_start = true,
>>       |    ^~~~~~~~~~
>> 
>> Caused by commit
>> 
>>   ed39d7816885 ("bus: mhi: Remove auto-start option")
>> 
>> interacting with commit
>> 
>>   1399fb87ea3e ("ath11k: register MHI controller device for QCA6390")
>> 
>> from the net-next tree.
>> 
>> I applied the following merge fix patch, but maybe more is required.
>> Even if so, this could be fixed now in the net-next tree.
>> 
>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date: Mon, 28 Sep 2020 18:39:41 +1000
>> Subject: [PATCH] fix up for "ath11k: register MHI controller device for QCA6390"
>> 
>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>
> Sorry, I forgot to submit a patch against net-next for fixing this while merging
> the MHI change.

Try to notify the ath11k list (CCed) whenever changing MHI API so that
we (ath11k folks) can be prepared for any major changes.

> But your change looks good and I can just modify the subject/description and
> resubmit. Or if Dave prefers to fix the original commit itself in net-next,
> I'm fine!

Actually I prefer to apply the fix to my ath.git tree, less conflicts
that way (I have still quite a lot of ath11k patches pending for -next).
I'll then send a pull request to Dave end of this week.

So please submit the patch like a normal ath11k patch documented here:

https://wireless.wiki.kernel.org/en/users/drivers/ath11k/submittingpatches

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
