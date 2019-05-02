Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB40411BF2
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 16:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfEBO7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 10:59:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39610 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEBO7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 10:59:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 07D1E607DE; Thu,  2 May 2019 14:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556809152;
        bh=tvE6bs3u//JBi0RudTVDwr4Bu5XwLKDo+Px9JH/bPHE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=aRlxpkRw07eTZ77rhCflFNXpR2l83KpnA/lRsYX6BzO6Q6U8FtQDPjaEv4LBQpNVF
         Z3i8KeyKpq501QrlK4LYz8qaezhpXQN5CHwOgxCnHuhrzMrrkXOGZHjgQTP+PdD29N
         nQDE+YIpopx9EGo5uEFK27kLln3GdNqcgdlXX4Cw=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9EBB8601D4;
        Thu,  2 May 2019 14:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556809151;
        bh=tvE6bs3u//JBi0RudTVDwr4Bu5XwLKDo+Px9JH/bPHE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=UayMX6sNuO6FdW4bpau5v0rRs4BhZyGUZVXBjgqsm0BPWiNMYkAwy7Wgi2sqGdKZy
         aM95DI+TAzm8T+E4caRu6nOHtcC7SNCeX+6+WqOC3jO0DBy/nvK2CngvSaexOEJRy2
         di9BrWlUfQ/HcWbTPQE3O582//burQV8FyqWbE9o=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9EBB8601D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] rtw88: phy: mark expected switch fall-throughs
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190501151615.GA18557@embeddedor>
References: <20190501151615.GA18557@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190502145912.07D1E607DE@smtp.codeaurora.org>
Date:   Thu,  2 May 2019 14:59:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> In preparation to enabling -Wimplicit-fallthrough, mark switch
> cases where we are expecting to fall through.
> 
> This patch fixes the following warnings:
> 
> drivers/net/wireless/realtek/rtw88/phy.c: In function ‘rtw_get_channel_group’:
> ./include/linux/compiler.h:77:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
>  # define unlikely(x) __builtin_expect(!!(x), 0)
>                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
> ./include/asm-generic/bug.h:125:2: note: in expansion of macro ‘unlikely’
>   unlikely(__ret_warn_on);     \
>   ^~~~~~~~
> drivers/net/wireless/realtek/rtw88/phy.c:907:3: note: in expansion of macro ‘WARN_ON’
>    WARN_ON(1);
>    ^~~~~~~
> drivers/net/wireless/realtek/rtw88/phy.c:908:2: note: here
>   case 1:
>   ^~~~
> In file included from ./include/linux/bcd.h:5,
>                  from drivers/net/wireless/realtek/rtw88/phy.c:5:
> drivers/net/wireless/realtek/rtw88/phy.c: In function ‘phy_get_2g_tx_power_index’:
> ./include/linux/compiler.h:77:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
>  # define unlikely(x) __builtin_expect(!!(x), 0)
>                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
> ./include/asm-generic/bug.h:125:2: note: in expansion of macro ‘unlikely’
>   unlikely(__ret_warn_on);     \
>   ^~~~~~~~
> drivers/net/wireless/realtek/rtw88/phy.c:1021:3: note: in expansion of macro ‘WARN_ON’
>    WARN_ON(1);
>    ^~~~~~~
> drivers/net/wireless/realtek/rtw88/phy.c:1022:2: note: here
>   case RTW_CHANNEL_WIDTH_20:
>   ^~~~
> 
> Warning level 3 was used: -Wimplicit-fallthrough=3
> 
> This patch is part of the ongoing efforts to enable
> -Wimplicit-fallthrough.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied to wireless-drivers-next.git, thanks.

aa8eaaaa123a rtw88: phy: mark expected switch fall-throughs

-- 
https://patchwork.kernel.org/patch/10925201/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

