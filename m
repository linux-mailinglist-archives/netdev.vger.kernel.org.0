Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7332BBCA4
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 04:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgKUDSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 22:18:17 -0500
Received: from z5.mailgun.us ([104.130.96.5]:54577 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbgKUDSQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 22:18:16 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605928696; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=tsjgLaYaSJcIz+X5WrJmtxBmcPAH7mtdLQEdy3BKU04=; b=UsIJfiT8YgKmhjo2Hk6CrPmSq1MJmjjpcd3V+7kPOfHGtAlXm5MIyEfZEq9dZH25ik4ZVRMS
 cmSiynAdDjZQ4hPgBPjNwERqhIouc+kvcXGw1IYAjqegupLd3Hdrtot8JSBorTd1iJxnfddH
 zmUaCFiumtucIZDdfl8LSwAfHVg=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5fb886f71b731a5d9c2f8bc4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 21 Nov 2020 03:18:15
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6BDF5C43461; Sat, 21 Nov 2020 03:18:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.46.162.249] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 348C6C433ED;
        Sat, 21 Nov 2020 03:18:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 348C6C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Subject: Re: [PATCH v12 5/5] selftest: mhi: Add support to test MHI LOOPBACK
 channel
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     gregkh@linuxfoundation.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhugo@codeaurora.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org, skhan@linuxfoundation.org
References: <1605566782-38013-1-git-send-email-hemantk@codeaurora.org>
 <1605566782-38013-6-git-send-email-hemantk@codeaurora.org>
 <20201120061003.GA3909@work>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <7673cbe1-0ab1-8e44-2e24-190dd808e2e2@codeaurora.org>
Date:   Fri, 20 Nov 2020 19:18:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201120061003.GA3909@work>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Mani,
On 11/19/20 10:10 PM, Manivannan Sadhasivam wrote:
> On Mon, Nov 16, 2020 at 02:46:22PM -0800, Hemant Kumar wrote:
>> Loopback test opens the MHI device file node and writes
>> a data buffer to it. MHI UCI kernel space driver copies
>> the data and sends it to MHI uplink (Tx) LOOPBACK channel.
>> MHI device loops back the same data to MHI downlink (Rx)
>> LOOPBACK channel. This data is read by test application
>> and compared against the data sent. Test passes if data
>> buffer matches between Tx and Rx. Test application performs
>> open(), poll(), write(), read() and close() file operations.
>>
>> Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> 
> One nitpick below, with that addressed:
> 
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
[..]
> 
> Effectively this functions does parse and run, so this should be called
> as, "loopback_test_parse_run" or pthread creation should be moved here.
Done.

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
