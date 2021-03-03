Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B83F32C478
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390183AbhCDAOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:14:17 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:34596 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239319AbhCCQQH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 11:16:07 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614788103; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=G2G4SJp4FwsECyB7Y/TK8uE4IGnj8LZzweQFpxCMat0=; b=H2GtZULEqAYoW6mQImsupoWkOQP9u78Jt9YGexmMw3A1gIRnTeD9a9453HB/abp+LZZAqc1e
 ljL2CLVNbn8wgCw+btok5GxhaoGPV77AtRMz5ko8Vjq1q+cmFBSENQrTQ09mq2Sb12l8oAax
 gdxmiT860hkoIm6/J2UXs2fP5Oc=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 603fb309f7ec0ea57c0d2a27 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 03 Mar 2021 16:02:17
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 56B9DC43462; Wed,  3 Mar 2021 16:02:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A3D25C433CA;
        Wed,  3 Mar 2021 16:02:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A3D25C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Coelho\, Luciano" <luciano.coelho@intel.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: ensure that DMI scan table is properly terminated
References: <0d52ff85-323f-67b8-5fdb-bbf3093b0ccf@kernel.dk>
        <782d5382b0c8c9b33277422c8e41180c49044128.camel@intel.com>
        <3f8e28b1-0c15-7539-ef50-5cfb71a3591f@kernel.dk>
        <20cdd691-0872-523d-e565-909f75e62956@kernel.dk>
Date:   Wed, 03 Mar 2021 18:02:11 +0200
In-Reply-To: <20cdd691-0872-523d-e565-909f75e62956@kernel.dk> (Jens Axboe's
        message of "Tue, 2 Mar 2021 20:51:10 -0700")
Message-ID: <8735xc8buk.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 3/2/21 8:49 PM, Jens Axboe wrote:
>> On 3/2/21 11:34 AM, Coelho, Luciano wrote:
>>
>>> Thanks for the report and patch! And I'm sorry that we broke your
>>> laptop's boot...
>>>
>>> We already have a patch to fix this:
>>>
>>> https://patchwork.kernel.org/project/linux-wireless/patch/20210223140039.1708534-1-weiyongjun1@huawei.com/
>>>
>>> I thought I had already acked it for Kalle to take it directly to
>>> wireless-drivers, but apparently I hadn't.
>>>
>>> I acked now and assigned it to him.
>> 
>> All good thanks, as long as it gets fixed and goes upstream I don't care
>> where it's from :-)
>
> I looked at the link, and feel free to steal my commit trace/message it
> you want.

Thanks, did that. The patch is now applied:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=a22549f12767fce49c74c53a853595f82b727935

I'll send a pull request to the net tree later today.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
