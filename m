Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D562A6A3D
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbfICNnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:43:52 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54682 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728860AbfICNnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:43:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 65443602CA; Tue,  3 Sep 2019 13:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567518231;
        bh=IBO8RtL89xZJKFCTGE+LZnciWa2CSGbLi/4TyJ+gpUo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=VX47K6t+WcJ3Xh8fm9qhJC8WwDyoVMEW1x361kw6idoXHonmT/US/r97rLfMPiNHB
         oyBOUk5uWnzl+aTcIvBJX8DZm42etnW4dAbkMtFu8vbJIljsxFmQNIsWOIYhJ72f19
         aRXsFQ+9q8B3CAVXijJwWL0hYL7OFhSWISe4htEI=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7501F607F4;
        Tue,  3 Sep 2019 13:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567518230;
        bh=IBO8RtL89xZJKFCTGE+LZnciWa2CSGbLi/4TyJ+gpUo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=LqCamezDsX08xuc7ET3GbzIbPWrx5EAA6RHjDnWtpEj3iZ5JFnTS2XGo0arlU9o/U
         dbsSqshlDPNsP93tpkGFBe1/h/fT1ycKTzp4zQMqF0GukMTIYj/UYsEdJ7m4pqO3z9
         5NHFrDziGioNdQrOApNUl3Ouk0C2EMhOSzab25Fk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7501F607F4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: replace strncpy() by strscpy()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190823074708.20081-1-xulin.sun@windriver.com>
References: <20190823074708.20081-1-xulin.sun@windriver.com>
To:     Xulin Sun <xulin.sun@windriver.com>
Cc:     <stefan.wahren@i2se.com>, <xulin.sun@windriver.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <brcm80211-dev-list@cypress.com>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <linux-wireless@vger.kernel.org>, <arend.vanspriel@broadcom.com>,
        <franky.lin@broadcom.com>, <hante.meuleman@broadcom.com>,
        <chi-hsien.lin@cypress.com>, <wright.feng@cypress.com>,
        <davem@davemloft.net>, <stanley.hsu@cypress.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903134351.65443602CA@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:43:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xulin Sun <xulin.sun@windriver.com> wrote:

> The strncpy() may truncate the copied string,
> replace it by the safer strscpy().
> 
> To avoid below compile warning with gcc 8.2:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:In function 'brcmf_vndr_ie':
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:4227:2:
> warning: 'strncpy' output truncated before terminating nul copying 3 bytes from a string of the same length [-Wstringop-truncation]
>   strncpy(iebuf, add_del_cmd, VNDR_IE_CMD_LEN - 1);
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Xulin Sun <xulin.sun@windriver.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

5f42b382ead2 brcmfmac: replace strncpy() by strscpy()

-- 
https://patchwork.kernel.org/patch/11110841/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

