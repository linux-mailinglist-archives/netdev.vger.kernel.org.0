Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8BB2AA339
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 09:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgKGIJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 03:09:56 -0500
Received: from z5.mailgun.us ([104.130.96.5]:64836 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727810AbgKGIJz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 03:09:55 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604736595; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=cg9r/MY6oCuxsxyWO63XaogHeNRyaD9FufpA/fkOxbY=;
 b=NUGPcZCAEJ+20w6C/BkSPFDvsEizHNzmARRlKW/eFgmWcRXoDEoeDAYK7Vdr/SHyfTY/EIbm
 ZDonvaM73bK4VWK7VogRrxMAhGDRYZFcVLA5tXyAfkUAZRcuwswEcGzwZHZOL3Li7nNKEdr/
 lDKx3P0BWIFh9ACrbSZsX/zxHa4=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5fa6560f60d9475652bccc50 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 08:08:47
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C2D83C433CB; Sat,  7 Nov 2020 08:08:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4CFFFC433C8;
        Sat,  7 Nov 2020 08:08:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4CFFFC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next 09/11] ath6kl: fix enum-conversion warning
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201026213040.3889546-9-arnd@kernel.org>
References: <20201026213040.3889546-9-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Raja Mani <rmani@qca.qualcomm.com>,
        Suraj Sumangala <surajs@qca.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Vivek Natarajan <nataraja@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107080847.C2D83C433CB@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 08:08:47 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> gcc -Wextra points out a type mismatch
> 
> drivers/net/wireless/ath/ath6kl/wmi.c: In function 'ath6kl_wmi_cmd_send':
> drivers/net/wireless/ath/ath6kl/wmi.c:1825:19: warning: implicit conversion from 'enum <anonymous>' to 'enum wmi_data_hdr_data_type' [-Wenum-conversion]
>  1825 |            false, false, 0, NULL, if_idx);
>       |                   ^~~~~
> 
> As far as I can tell, the numeric value is current here,
> so just use the correct enum literal instead of 'false'.
> 
> Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

ce54bf5e9554 ath6kl: fix enum-conversion warning

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201026213040.3889546-9-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

