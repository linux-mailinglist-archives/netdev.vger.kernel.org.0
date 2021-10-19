Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D283433502
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbhJSLui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:50:38 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:59021 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230129AbhJSLuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:50:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634644103; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=6L0eRGFpxh79Zpek57KC7JtYLuMfOQqMjbjJADNCPak=; b=VzU0HTiMjzAuV1FPmp0hmJSBjqGQb5kkGh0RRj/FJHa6InJ2MxSWngmhmATlIWFJxG19Kpue
 O5GSpQq+65cWvKU3IdDpLnaV344KDBZq/ye3LS1PryXFbjjqkZunE19o4hHhOXZfbFEtPjKl
 KOD69v4yWrUMkc/pFrU/PUkXd5I=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 616eb085321f24005169aff7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 19 Oct 2021 11:48:21
 GMT
Sender: quic_luoj=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D22FEC4338F; Tue, 19 Oct 2021 11:48:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,UPPERCASE_50_75 autolearn=unavailable
        autolearn_force=no version=3.4.0
Received: from [10.92.1.38] (unknown [180.166.53.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 43512C4360C;
        Tue, 19 Oct 2021 11:48:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 43512C4360C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=quicinc.com
Subject: Re: [PATCH v3 05/13] net: phy: add qca8081 ethernet phy driver
To:     Andrew Lunn <andrew@lunn.ch>, Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-6-luoj@codeaurora.org> <YW3BLwiNGiQGUje9@lunn.ch>
From:   Jie Luo <quic_luoj@quicinc.com>
Message-ID: <2d8cca21-456f-8fb5-1590-e6c9b0f9a82c@quicinc.com>
Date:   Tue, 19 Oct 2021 19:48:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YW3BLwiNGiQGUje9@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/19/2021 2:47 AM, Andrew Lunn wrote:
>> @@ -1441,6 +1455,7 @@ static struct mdio_device_id __maybe_unused atheros_tbl[] = {
>>   	{ PHY_ID_MATCH_EXACT(ATH8032_PHY_ID) },
>>   	{ PHY_ID_MATCH_EXACT(ATH8035_PHY_ID) },
>>   	{ PHY_ID_MATCH_EXACT(ATH9331_PHY_ID) },
>> +	{ PHY_ID_MATCH_EXACT(QCA8081_PHY_ID) },
>>   	{ }
> What tree is this against? I have:
>
> static struct mdio_device_id __maybe_unused atheros_tbl[] = {
>          { ATH8030_PHY_ID, AT8030_PHY_ID_MASK },
>          { PHY_ID_MATCH_EXACT(ATH8031_PHY_ID) },
>          { PHY_ID_MATCH_EXACT(ATH8032_PHY_ID) },
>          { PHY_ID_MATCH_EXACT(ATH8035_PHY_ID) },
>          { PHY_ID_MATCH_EXACT(ATH9331_PHY_ID) },
>          { PHY_ID_MATCH_EXACT(QCA8337_PHY_ID) },
>          { PHY_ID_MATCH_EXACT(QCA8327_A_PHY_ID) },
>          { PHY_ID_MATCH_EXACT(QCA8327_B_PHY_ID) },
>          { PHY_ID_MATCH_EXACT(QCA9561_PHY_ID) },
>          { }
> };
>
> 	Andrew
will update it based on the latest tree in the next patch set.
