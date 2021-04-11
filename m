Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9AE35B2C8
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 11:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbhDKJck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 05:32:40 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:25002 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235269AbhDKJcj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 05:32:39 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618133543; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=ORlIUfijIrnSlUyjuvajmJtLvP0WXW8LZmX4NEH0q/4=;
 b=ItHAQQb4mAhuk3ySQ9pOgPGtMRom043UFBXRjSrCJNyGIMHaGTyUi1NbREk/WEuX9y2vGmcj
 qQsm1VWCcknLIVsuiGO9jHnUoc3sFV95v/MagqBCm3cFSb5Z0nNlWCwPAccob8S7RWhIdnJ7
 VrJ9R+m2Sfu86p9cLt9FPznPuCo=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 6072c21be0e9c9a6b6fcf200 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 11 Apr 2021 09:32:11
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D8F1FC433C6; Sun, 11 Apr 2021 09:32:11 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DAE4EC433ED;
        Sun, 11 Apr 2021 09:32:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DAE4EC433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next 3/5] iwlegacy: avoid -Wempty-body warning
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210322104343.948660-3-arnd@kernel.org>
References: <20210322104343.948660-3-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, Stanislaw Gruszka <stf_xl@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210411093211.D8F1FC433C6@smtp.codeaurora.org>
Date:   Sun, 11 Apr 2021 09:32:11 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> There are a couple of warnings in this driver when building with W=1:
> 
> drivers/net/wireless/intel/iwlegacy/common.c: In function 'il_power_set_mode':
> drivers/net/wireless/intel/iwlegacy/common.c:1195:60: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
>  1195 |                                 il->chain_noise_data.state);
>       |                                                            ^
> drivers/net/wireless/intel/iwlegacy/common.c: In function 'il_do_scan_abort':
> drivers/net/wireless/intel/iwlegacy/common.c:1343:57: error: suggest braces around empty body in an 'else' statement [-Werror=empty-body]
> 
> Change the empty debug macros to no_printk(), which avoids the
> warnings and adds useful format string checks.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

Patch applied to wireless-drivers-next.git, thanks.

fa9f5d0e0b45 iwlegacy: avoid -Wempty-body warning

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210322104343.948660-3-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

