Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56FAC50BDC
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbfFXNWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:22:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39162 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728736AbfFXNWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:22:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0736E60F3A; Mon, 24 Jun 2019 13:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561382556;
        bh=/MhzFPrOnJsUwbR+A+aF2D34pmO0qEliUUfT/mjNyNs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Y9x1+NcaLtpIN7gPioOPg/8z8wwHa2FSqJtAgONCDtRTeyGCQZ+o9HPn4XkND86hE
         raV9/MPJ8zG4zkt2IK+lkHMTE3Ja+9vBME185EMC03/xg+yT9Ll7ZpZbmdl34sYY4C
         patxw1w+WtWHvmIhxnCmxqxzj2YzZLr+AUReCzGA=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7D6B7615AD;
        Mon, 24 Jun 2019 13:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561382554;
        bh=/MhzFPrOnJsUwbR+A+aF2D34pmO0qEliUUfT/mjNyNs=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=U6n0smKxOy260RvyjFc69NoBQy+7qpriFKg9Nwkc5Kx9v4vPaoSVIeKW7gRhbeofr
         n1kShrSS+zkt0YsbIeA4sbwHG+O7mIiTRVdSo9vHVgriFsCGcaQ5BZBwJafPRJOlPA
         /oVPB1KWtQnXL0wA33EoYCLN+WX3ZV9uT0nZGpCo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7D6B7615AD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wl18xx: Fix Wunused-const-variable
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190614171713.89262-1-nhuck@google.com>
References: <20190614171713.89262-1-nhuck@google.com>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>,
        clang-built-linux@googlegroups.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190624132236.0736E60F3A@smtp.codeaurora.org>
Date:   Mon, 24 Jun 2019 13:22:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nathan Huckleberry <nhuck@google.com> wrote:

> Clang produces the following warning
> 
> drivers/net/wireless/ti/wl18xx/main.c:1850:43: warning: unused variable
> 'wl18xx_iface_ap_cl_limits' [-Wunused-const-variable] static const struct
> ieee80211_iface_limit wl18xx_iface_ap_cl_limits[] = { ^
> drivers/net/wireless/ti/wl18xx/main.c:1869:43: warning: unused variable
> 'wl18xx_iface_ap_go_limits' [-Wunused-const-variable] static const struct
> ieee80211_iface_limit wl18xx_iface_ap_go_limits[] = { ^
> 
> The commit that added these variables never used them. Removing them.
> 
> Cc: clang-built-linux@googlegroups.com
> Link: https://github.com/ClangBuiltLinux/linux/issues/530
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Patch applied to wireless-drivers.git, thanks.

608fd7214323 wl18xx: Fix Wunused-const-variable

-- 
https://patchwork.kernel.org/patch/10996073/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

