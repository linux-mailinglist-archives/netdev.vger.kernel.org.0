Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074D52C946E
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 02:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389225AbgLABJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 20:09:14 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:38220 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389214AbgLABJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 20:09:12 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606784931; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=pTKbiMBtrJ26sLvaoisUJXi2hC33groLwAZEMc865T4=; b=FoMrPqQnQn9fgOGkT2UkxTFLx080pe9S3P1MpRrLWGNPwIBG4V0RDR3bdF6iypWK4qcGQ9/4
 nvzH+r6Q3xROMTdY0FHbwmfqui+++/xSHCvL78wDpG85T4L329Rywwg9CHZlelZQvPNKfD+z
 oDc5lFgnTgtt+82MKIHg/5HXrno=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5fc59789f4482b01c461eeff (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Dec 2020 01:08:25
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 247ADC43464; Tue,  1 Dec 2020 01:08:25 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EC7CFC43460;
        Tue,  1 Dec 2020 01:08:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EC7CFC43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Subject: Re: [PATCH v13 4/4] bus: mhi: Add userspace client interface driver
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     gregkh@linuxfoundation.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhugo@codeaurora.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org
References: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org>
 <1606533966-22821-5-git-send-email-hemantk@codeaurora.org>
 <20201128061117.GJ3077@thinkpad>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <becbd9ac-09a1-1ce7-7fdb-333a302601cb@codeaurora.org>
Date:   Mon, 30 Nov 2020 17:08:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201128061117.GJ3077@thinkpad>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mani,

On 11/27/20 10:11 PM, Manivannan Sadhasivam wrote:
> Hi Hemant,
> 
> On Fri, Nov 27, 2020 at 07:26:06PM -0800, Hemant Kumar wrote:
>> This MHI client driver allows userspace clients to transfer
>> raw data between MHI device and host using standard file operations.
>> Driver instantiates UCI device object which is associated to device
>> file node. UCI device object instantiates UCI channel object when device
>> file node is opened. UCI channel object is used to manage MHI channels
>> by calling MHI core APIs for read and write operations. MHI channels
>> are started as part of device open(). MHI channels remain in start
>> state until last release() is called on UCI device file node. Device
>> file node is created with format
>>
>> /dev/mhi_<mhi_device_name>
>>
>> Currently it supports QMI channel.
>>
> 
> Thanks for the update. This patch looks good to me. But as I'm going to
> apply Loic's "bus: mhi: core: Indexed MHI controller name" patch, you
> need to update the documentation accordingly.

This is what i added in documentation on v13


Device file node is created with format:-

/dev/mhi_<mhi_device_name>

mhi_device_name includes mhi controller name and the name of the MHI
channel being used by MHI client in userspace to send or receive data
using MHI protocol.

​
Loic's patch is going to update the controller name as indexed 
controller name, which goes fine with or without his change going first.

For example:   With Loic's change name of device node would be 
/dev/mhi_mhi0_QMI

Without Loic's change it would be

/dev/mhi_0000:00:01.2_QMI

Please let me know if i am missing something.

Thanks,
Hemant

> 
>> Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> 
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> 
> Thanks,
> Mani
> 
[..]
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
