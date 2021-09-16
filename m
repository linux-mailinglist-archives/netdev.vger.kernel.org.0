Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4CB40D29F
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 06:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbhIPElR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 00:41:17 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:46273 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhIPElO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 00:41:14 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1631767194; h=Content-Type: MIME-Version: Message-ID: Date:
 References: In-Reply-To: Subject: Cc: To: From: Sender;
 bh=/+s/jscahNm5opYfahNTF4pek+pW4Sb5V6rCSNLcwfc=; b=DwlqTQHIELPi8q7fQVC4MvJXb/KjtHcKLzH2E4HpX4326iHAtHW25/7AGATKklCtPCzQwwbb
 OZ5ADTTp5LUP0EwkG197/7Ly5uQunUBJ8b9XaWZSD7mYMEAHZamXKNQnWenKT66EbMgNN+8Q
 9C8rQq5e8xiT70f61CH8cHpG1ig=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 6142ca8e507800c880a4bef4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 16 Sep 2021 04:39:42
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 33B47C43619; Thu, 16 Sep 2021 04:39:41 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ABD35C4338F;
        Thu, 16 Sep 2021 04:39:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org ABD35C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Karun Eagalapati <karun256@gmail.com>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, stable@vger.kernel.org,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rsi: Fix module dev_oper_mode parameter description
In-Reply-To: <20210915080841.73938-1-marex@denx.de> (Marek Vasut's message of
        "Wed, 15 Sep 2021 10:08:41 +0200")
References: <20210915080841.73938-1-marex@denx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Thu, 16 Sep 2021 07:39:33 +0300
Message-ID: <87fsu516d6.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ linux-wireless

Marek Vasut <marex@denx.de> writes:

> The module parameters are missing dev_oper_mode 12, BT classic alone,
> add it. Moreover, the parameters encode newlines, which ends up being
> printed malformed e.g. by modinfo, so fix that too.
>
> However, the module parameter string is duplicated in both USB and SDIO
> modules and the dev_oper_mode mode enumeration in those module parameters
> is a duplicate of macros used by the driver. Furthermore, the enumeration
> is confusing.
>
> So, deduplicate the module parameter string and use __stringify() to
> encode the correct mode enumeration values into the module parameter
> string. Finally, replace 'Wi-Fi' with 'Wi-Fi alone' and 'BT' with
> 'BT classic alone' to clarify what those modes really mean.
>
> Fixes: 898b255339310 ("rsi: add module parameter operating mode")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> Cc: Angus Ainslie <angus@akkea.ca>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Karun Eagalapati <karun256@gmail.com>
> Cc: Martin Fuzzey <martin.fuzzey@flowbird.group>
> Cc: Martin Kepplinger <martink@posteo.de>
> Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> Cc: Siva Rebbagondla <siva8118@gmail.com>
> To: netdev@vger.kernel.org
> Cc: <stable@vger.kernel.org> # 4.17+
> ---
>  drivers/net/wireless/rsi/rsi_91x_sdio.c |  5 +----
>  drivers/net/wireless/rsi/rsi_91x_usb.c  |  5 +----
>  drivers/net/wireless/rsi/rsi_hal.h      | 11 +++++++++++
>  3 files changed, 13 insertions(+), 8 deletions(-)

linux-wireless is not included so patchwork won't see this patch. Please
resubmit (as v2) and include linux-wireless, more info in the wiki
below.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
