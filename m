Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A7B43815E
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 03:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhJWB56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 21:57:58 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:21303 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhJWB55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 21:57:57 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634954139; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=KZV6Gnl4idAD75N9GVn65JILQSvJTQSWBTaysVWdJ4Q=; b=h1rTfmL5dpu+LD/YqToOTRlBgs6eBFDD9oYgpCStxMsJVmvuwEOMYPaIgoCG1r4PheCNS0zT
 eSr9hy1+9QSS7xFG6Ar7fYtI53sW1NRJMVzWolpwlRHFJnC77BKkF3A5yhAwTs7RHxUyvVxo
 TTuBDQtjeM5YAsaPKGIL6cqgggk=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 61736b94daa899cf7473c02f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 23 Oct 2021 01:55:32
 GMT
Sender: quic_luoj=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 95B40C4360D; Sat, 23 Oct 2021 01:55:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.1.4] (unknown [183.192.232.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1A67BC4338F;
        Sat, 23 Oct 2021 01:55:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 1A67BC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=quicinc.com
Subject: Re: [PATCH v4 05/14] net: phy: add qca8081 ethernet phy driver
To:     Jakub Kicinski <kuba@kernel.org>, Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
References: <20211022120624.18069-1-luoj@codeaurora.org>
 <20211022120624.18069-6-luoj@codeaurora.org>
 <20211022090315.67e8bf8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jie Luo <quic_luoj@quicinc.com>
Message-ID: <b38b2992-8e77-d105-9be1-b20fd346f331@quicinc.com>
Date:   Sat, 23 Oct 2021 09:55:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211022090315.67e8bf8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/23/2021 12:03 AM, Jakub Kicinski wrote:
> On Fri, 22 Oct 2021 20:06:15 +0800 Luo Jie wrote:
>> qca8081 is a single port ethernet phy chip that supports
>> 10/100/1000/2500 Mbps mode.
>>
>> Add the basic phy driver features, and reuse the at803x
>> phy driver functions.
>>
>> Signed-off-by: Luo Jie <luoj@codeaurora.org>
> Does not apply cleanly to net-next/master. Please rebase and repost.
Thanks Jakub for the comments, will update the tree and repost it.
