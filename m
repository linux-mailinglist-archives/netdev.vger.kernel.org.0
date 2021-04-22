Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED24B368295
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 16:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237454AbhDVOlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 10:41:04 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:48208 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236893AbhDVOk7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 10:40:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619102424; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=iEBvrbk2q7rMUoHph8b/yTMS2b++mbwgR9IYEcQh7dA=;
 b=TfJvW8mlzgoXVg48jnsZOJSOa5h2Yt+EehVzHLLu/j474MShhwvToZ9NUAn1WJrtOuvLYCBy
 NzaSv1Cmiqur9qJmvmjvecqPgxxSMNOTc6nOJv2BxB5vp+rLGZZ9/nQrMh0ZX4XsKuFvjZW2
 PcMsVgzRcGvWB6kOKbcueRHQGUI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60818abdc39407c3274be57a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 22 Apr 2021 14:39:57
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CF11CC43217; Thu, 22 Apr 2021 14:39:56 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9F8EAC433F1;
        Thu, 22 Apr 2021 14:39:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9F8EAC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next][V2] wlcore: Fix buffer overrun by snprintf due to
 incorrect buffer size
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210419141405.180582-1-colin.king@canonical.com>
References: <20210419141405.180582-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210422143956.CF11CC43217@smtp.codeaurora.org>
Date:   Thu, 22 Apr 2021 14:39:56 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The size of the buffer than can be written to is currently incorrect, it is
> always the size of the entire buffer even though the snprintf is writing
> as position pos into the buffer. Fix this by setting the buffer size to be
> the number of bytes left in the buffer, namely sizeof(buf) - pos.
> 
> Addresses-Coverity: ("Out-of-bounds access")
> Fixes: 7b0e2c4f6be3 ("wlcore: fix overlapping snprintf arguments in debugfs")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers-next.git, thanks.

a9a4c080deb3 wlcore: Fix buffer overrun by snprintf due to incorrect buffer size

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210419141405.180582-1-colin.king@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

