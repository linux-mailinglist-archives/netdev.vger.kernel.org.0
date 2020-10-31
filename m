Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24692A11F6
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgJaAdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:33:19 -0400
Received: from z5.mailgun.us ([104.130.96.5]:59612 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbgJaAdT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 20:33:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604104398; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=J4FlgY/H003ixJRCI3Aazuz/jorK6RSptRDy0aW+C+o=; b=MYjY0DvlTC1i2vq/1ybWty93Cbv0oDPnxYRGfNneTt2JtMISIsVS6JeL14efxkCvOy0PbCfK
 XCymTMgSYw+0GJMC7UWGFTy6okfP7I/Sdrl9inmWY3fpIhTcq0LvXSkjnwfCrflDNvJvTxyT
 O01xYF/UahidxhzYbWqpt3RiDHw=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f9cb0ce96c0873ad5c01a09 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 31 Oct 2020 00:33:18
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 52C6AC43382; Sat, 31 Oct 2020 00:33:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [10.46.162.249] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5BF78C433C9;
        Sat, 31 Oct 2020 00:33:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5BF78C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Subject: Re: [PATCH v11 4/4] bus: mhi: Add userspace client interface driver
To:     Randy Dunlap <rdunlap@infradead.org>,
        manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
References: <1604025946-28288-1-git-send-email-hemantk@codeaurora.org>
 <1604025946-28288-5-git-send-email-hemantk@codeaurora.org>
 <88077bd6-be17-d88a-2959-9ea249614019@infradead.org>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <2aa9fcbb-40f2-ab87-a3c7-10082f2995e2@codeaurora.org>
Date:   Fri, 30 Oct 2020 17:33:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <88077bd6-be17-d88a-2959-9ea249614019@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

On 10/29/20 10:48 PM, Randy Dunlap wrote:
> On 10/29/20 7:45 PM, Hemant Kumar wrote:
>> diff --git a/drivers/bus/mhi/Kconfig b/drivers/bus/mhi/Kconfig
>> index e841c10..476cc55 100644
>> --- a/drivers/bus/mhi/Kconfig
>> +++ b/drivers/bus/mhi/Kconfig
>> @@ -20,3 +20,16 @@ config MHI_BUS_DEBUG
>>   	  Enable debugfs support for use with the MHI transport. Allows
>>   	  reading and/or modifying some values within the MHI controller
>>   	  for debug and test purposes.
>> +
>> +config MHI_UCI
>> +	tristate "MHI UCI"
>> +	depends on MHI_BUS
>> +	help
>> +	  MHI based Userspace Client Interface (UCI) driver is used for
> 
> 	  MHI-based
> 
>> +	  transferring raw data between host and device using standard file
>> +	  operations from userspace. Open, read, write, and close operations
>> +	  are supported by this driver. Please check mhi_uci_match_table for
> 
> also poll according to the documentation.
good catch, will add in next patch set.
> 
>> +	  all supported channels that are exposed to userspace.
>> +
>> +	  To compile this driver as a module, choose M here: the module will be
>> +	  called mhi_uci.
> 
> 

Thanks,
Hemant
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
