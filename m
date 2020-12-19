Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175262DEFCC
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 14:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgLSNQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 08:16:16 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:59268 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbgLSNQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 08:16:15 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608383755; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=9MLE9xXcHVscsLaARtC7eXD9drmxQPheUZGSBIyh8W4=; b=eAa8kA8K7xAP6vLONL1JTxCPDhmgwYyAUgcBLLrz3ZBYOSjOz0+D0GaUKP7VBult2LnLL5ZN
 BhEiMSrrYGAScQlMcTqQ4nM6Y69+grKXvnZYVHeruxajJ4p01HBg/572BwO3E5P/O84pTu1z
 IApevrBMjsPE75AJU44j2ksq3F4=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5fddfce6944e4d244760e815 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 19 Dec 2020 13:15:18
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1C614C43461; Sat, 19 Dec 2020 13:15:18 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0B4ACC433CA;
        Sat, 19 Dec 2020 13:15:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0B4ACC433CA
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
Subject: Re: [PATCH] [v7] wireless: Initial driver submission for pureLiFi STA devices
References: <20201116092253.1302196-1-srini.raju@purelifi.com>
        <20201124144448.4E95EC43460@smtp.codeaurora.org>
        <CWXP265MB17998453F1460D55FA667E51E0F90@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
        <CWXP265MB17995D2233C32796091FFEE4E0F20@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
        <87h7p2hoex.fsf@codeaurora.org>
        <CWXP265MB1799A9CC75C3B506E1475D4EE0F20@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
Date:   Sat, 19 Dec 2020 15:15:12 +0200
In-Reply-To: <CWXP265MB1799A9CC75C3B506E1475D4EE0F20@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
        (Srinivasan Raju's message of "Thu, 3 Dec 2020 16:50:43 +0000")
Message-ID: <87k0teq6n3.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> writes:

>> What will be the directory structure in linux-firmware? It should be
>> unique so that it's not possible to mix with other drivers.
>
> I have created the following directory structure, Please let me know if this is OK.
>
>  LICENCE.purelifi_firmware |  29 +++++++++++++++++++++++++++++
>  purelifi/Li-Fi-XL.bin     | Bin 0 -> 70228 bytes
>  purelifi/fpga.bit         | Bin 0 -> 3825907 bytes
>  purelifi/fpga_xc.bit      | Bin 0 -> 3825906 bytes
>  4 files changed, 29 insertions(+)

I would prefer to change purelifi to the name of the driver, I'll
explain more in my review in v11.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
