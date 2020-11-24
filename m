Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F61B2C2BAD
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389799AbgKXPpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:45:44 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:31563 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389355AbgKXPpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 10:45:44 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606232743; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=v/Oe4s865T1a+g0gQ1U29DLdij5r77q2OiCX7XZuaoQ=; b=V6ysEwTBZCn8gsYGk2sZhB2aC94RzWIpBhLkOUAHVnT9YF0dAw/wMZq6SRalWw+sl/FHmlLg
 ykidcnfMTH5dw/WBUkasuGivb1sP38ZdbdLfkV3hS8t1xzLBsqn84F29LaaP5fChwRdhOqR7
 YFCQDah/Id0WQcUyAMlJGeead+A=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5fbd2aa5a5a29b56a1aed31f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 24 Nov 2020 15:45:41
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1CB68C43464; Tue, 24 Nov 2020 15:45:41 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4F02EC433C6;
        Tue, 24 Nov 2020 15:45:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4F02EC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-wireless@vger.kernel.org,
        bbhatt@codeaurora.org, netdev@vger.kernel.org,
        hemantk@codeaurora.org, ath11k@lists.infradead.org
Subject: Re: [PATCH] bus: mhi: Remove auto-start option
References: <20201118053102.13119-1-manivannan.sadhasivam@linaro.org>
        <877dqjz0bv.fsf@codeaurora.org> <20201118093107.GC3286@work>
Date:   Tue, 24 Nov 2020 17:45:35 +0200
In-Reply-To: <20201118093107.GC3286@work> (Manivannan Sadhasivam's message of
        "Wed, 18 Nov 2020 15:01:07 +0530")
Message-ID: <87a6v6rc68.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:

> On Wed, Nov 18, 2020 at 07:43:48AM +0200, Kalle Valo wrote:
>> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:
>> 
>> > From: Loic Poulain <loic.poulain@linaro.org>
>> >
>> > There is really no point having an auto-start for channels.
>> > This is confusing for the device drivers, some have to enable the
>> > channels, others don't have... and waste resources (e.g. pre allocated
>> > buffers) that may never be used.
>> >
>> > This is really up to the MHI device(channel) driver to manage the state
>> > of its channels.
>> >
>> > While at it, let's also remove the auto-start option from ath11k mhi
>> > controller.
>> >
>> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
>> > Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>> > [mani: clubbed ath11k change]
>> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>> 
>> Thanks and feel free to take this to the immutable branch:
>> 
>> Acked-by: Kalle Valo <kvalo@codeaurora.org>
>
> Patch applied to mhi-ath11k-immutable branch and merged into mhi-next.

Tested on QCA6390 hw2.0 and pulled also to ath-next, thanks.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
