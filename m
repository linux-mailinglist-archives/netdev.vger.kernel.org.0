Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F16F2CAC99
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbgLATlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:41:50 -0500
Received: from m42-5.mailgun.net ([69.72.42.5]:13415 "EHLO m42-5.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729049AbgLATlu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 14:41:50 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606851689; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=u0ASTfvQ8ODEFBCvRqnSAJ/D/bJXHlTvFNQagCu11Rw=; b=OjCjJ7vSzC/t5HW+xcq9AxRU+CL01mF1i/ibN7gxNa35YR8pI1+oVl8nZdHBLBZ19C99M4XH
 o9J5GdPj+4TzhQhOl4qXPttSDl5/R6NVhhRZa8A+5nkKnM8JAlpzPB08u85owcrfX5H/nxsi
 Jp529ArLwj8rOJW/RrrA79G6Ixw=
X-Mailgun-Sending-Ip: 69.72.42.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5fc69c46f4482b01c4cc0b36 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Dec 2020 19:40:54
 GMT
Sender: jhugo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 49BF6C433C6; Tue,  1 Dec 2020 19:40:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [10.226.59.216] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jhugo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AFD3AC433ED;
        Tue,  1 Dec 2020 19:40:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AFD3AC433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jhugo@codeaurora.org
Subject: Re: [PATCH v13 0/4] userspace MHI client interface driver
To:     Jakub Kicinski <kuba@kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>
Cc:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
References: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org>
 <20201201112901.7f13e26c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Jeffrey Hugo <jhugo@codeaurora.org>
Message-ID: <c6359962-a378-ed03-0fab-c2f6c8a1b8eb@codeaurora.org>
Date:   Tue, 1 Dec 2020 12:40:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201201112901.7f13e26c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/2020 12:29 PM, Jakub Kicinski wrote:
> On Fri, 27 Nov 2020 19:26:02 -0800 Hemant Kumar wrote:
>> This patch series adds support for UCI driver. UCI driver enables userspace
>> clients to communicate to external MHI devices like modem and WLAN. UCI driver
>> probe creates standard character device file nodes for userspace clients to
>> perform open, read, write, poll and release file operations. These file
>> operations call MHI core layer APIs to perform data transfer using MHI bus
>> to communicate with MHI device. Patch is tested using arm64 based platform.
> 
> Wait, I thought this was for modems.
> 
> Why do WLAN devices need to communicate with user space?
> 

Why does it matter what type of device it is?  Are modems somehow unique 
in that they are the only type of device that userspace is allowed to 
interact with?

However, I'll bite.  Once such usecase would be QMI.  QMI is a generic 
messaging protocol, and is not strictly limited to the unique operations 
of a modem.

Another usecase would be Sahara - a custom file transfer protocol used 
for uploading firmware images, and downloading crashdumps.

Off the top of my head, this driver is useful for modems, wlan, and AI 
accelerators.

-- 
Jeffrey Hugo
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
