Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E393D43362D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbhJSMpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:45:06 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:33119 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230267AbhJSMpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 08:45:06 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634647373; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=EAEzTgD3dlRVMChpTEmeUHjEeqs0R/ykyjpNvM1MaPo=; b=ZmvX4yKo2ccoxPGKsyXTnxtEpqB2AlVWN8cSo9NG5W5se5CDBPmRBjBGuszIJ7oE1dwwvLEp
 jzW7r+IF1QJVGZEwbKyFg4Dr9wYhJ0sEmbT8PoZrX41TeAzo++zt9Ic6BgO8YOEU0IUy0UYf
 3se4lgcn9EoWmsTucPMvS4IraQM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 616ebd2eb03398c06ce26135 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 19 Oct 2021 12:42:22
 GMT
Sender: quic_luoj=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CF637C43616; Tue, 19 Oct 2021 12:42:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [10.92.1.38] (unknown [180.166.53.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 633B5C4360C;
        Tue, 19 Oct 2021 12:42:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 633B5C4360C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=quicinc.com
Subject: Re: [PATCH v3 03/13] net: phy: at803x: improve the WOL feature
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Luo Jie <luoj@codeaurora.org>, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-4-luoj@codeaurora.org> <YW2/wck2NPhgwjuL@lunn.ch>
 <0ba3022d-9879-bf85-251d-3f48b9cff93b@quicinc.com> <YW66DXOIt8GrR2IQ@lunn.ch>
From:   Jie Luo <quic_luoj@quicinc.com>
Message-ID: <8eebd0aa-7345-7c4b-8435-067b703ad59a@quicinc.com>
Date:   Tue, 19 Oct 2021 20:42:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YW66DXOIt8GrR2IQ@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/19/2021 8:29 PM, Andrew Lunn wrote:
>> Hi Andrew,
>>
>> when this register AT803X_INTR_STATUS bits are cleared after read, we can't
>> clear only WOL interrupt here.
> O.K. But you do have the value of the interrupt status register. So
> you could call phy_trigger_machine(phydev) if there are any other
> interrupt pending. They won't get lost that way.
>
> 	  Andrew
This make sense, thanks for this comment, will add it in the next patch set.
