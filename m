Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093842DF90A
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 06:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgLUF6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 00:58:20 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:13778 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728518AbgLUF6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 00:58:20 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608530274; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=sEY+xIJ0XXXuL7Fjm7+Q2MBFKhj3vlIlLwjAvEKA18A=; b=nnzEZQ5VHwCxOpSDGqNtVbbHhCDvxhmBhlV7Gc7QHBall4bxHEwGQcTHTSHsdyLVSak+Vjog
 DojCBcS2p9DOuWk2GVmriS4XidKZrYluA6Y3QxwJbcL9cEw5y8HHwfxLb5hG36qE40L7jGRi
 b6OuTTXDS2EasYjKH+Q8MmR5gr0=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5fe0394475ab652e87bad560 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 21 Dec 2020 05:57:24
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 009E3C433CA; Mon, 21 Dec 2020 05:57:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A35E9C433CA;
        Mon, 21 Dec 2020 05:57:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A35E9C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS \(WIRELESS\)" 
        <linux-wireless@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v11] wireless: Initial driver submission for pureLiFi STA devices
References: <20200928102008.32568-1-srini.raju@purelifi.com>
        <20201208115719.349553-1-srini.raju@purelifi.com>
        <87o8iqq6os.fsf@codeaurora.org>
        <CWXP265MB17998064FCE8FCE6B313FAD1E0C00@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
Date:   Mon, 21 Dec 2020 07:57:17 +0200
In-Reply-To: <CWXP265MB17998064FCE8FCE6B313FAD1E0C00@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
        (Srinivasan Raju's message of "Mon, 21 Dec 2020 05:52:16 +0000")
Message-ID: <877dpbd7lu.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> writes:

>> I see lots of magic numbers in the driver like 2, 0x33 and 0x34 here.
>> Please convert the magic numbers to proper defines explaining the
>> meaning. And for vendor commands you could even use enum to group
>> them better in .h file somewhere.
>
> Hi Kalle,
>
> Thanks for reviewing the driver, We will work on the comments.

I haven't had time to do a throrough review yet, but I suggest fixing
the stuff I commented and submitting v12. I'll then do a new review with
v12.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
