Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE724301AF
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 11:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240111AbhJPJyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 05:54:32 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:13678 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236710AbhJPJyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 05:54:31 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634377943; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=YDjU1Hp2eUm33Aa/Rzcjoft0RKalrfyE5SPNRjlio3g=; b=Gco+E95wKWhSdw3l3z2nEIhdLWhUTagSXNFestKkTE2a4goeGxUukex8ROMV9fP4yZyosghv
 hW+d1UibG9K7/r4Mf4kuDp/lpoHWQ+GutwNdzsltQU23opVikqEXB9fAFhH9g9a+MAiYL6Px
 TG3l3+hoENmxbxUPtIReEnsg0mQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 616aa0c6446c6db0cba7dbd2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 16 Oct 2021 09:52:06
 GMT
Sender: quic_luoj=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C7477C4361A; Sat, 16 Oct 2021 09:52:05 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [192.168.1.4] (unknown [183.192.232.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9866CC4338F;
        Sat, 16 Oct 2021 09:52:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 9866CC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=quicinc.com
Subject: Re: [PATCH v2 05/13] net: phy: add qca8081 ethernet phy driver
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
References: <20211015073505.1893-1-luoj@codeaurora.org>
 <20211015073505.1893-6-luoj@codeaurora.org>
 <YWkzxd7xzTDngoT9@shell.armlinux.org.uk>
From:   Jie Luo <quic_luoj@quicinc.com>
Message-ID: <73d24f3d-3327-5d4b-c308-e5b145cbe6a5@quicinc.com>
Date:   Sat, 16 Oct 2021 17:51:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YWkzxd7xzTDngoT9@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/15/2021 3:54 PM, Russell King (Oracle) wrote:
> On Fri, Oct 15, 2021 at 03:34:57PM +0800, Luo Jie wrote:
>> @@ -1431,6 +1433,18 @@ static struct phy_driver at803x_driver[] = {
>>   	.get_sset_count = at803x_get_sset_count,
>>   	.get_strings = at803x_get_strings,
>>   	.get_stats = at803x_get_stats,
>> +}, {
>> +	/* Qualcomm QCA8081 */
>> +	PHY_ID_MATCH_EXACT(QCA8081_PHY_ID),
>> +	.name			= "Qualcomm QCA8081 PHY",
> I don't think we need the " PHY" suffix. This name gets printed in a
> context where it's obvious it's a network PHY.
thanks Russell, will remove the suffix " PHY" in the next patch set.
>
