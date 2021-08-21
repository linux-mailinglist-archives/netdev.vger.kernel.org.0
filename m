Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFFA3F3C44
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 21:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhHUTVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 15:21:10 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:24212 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhHUTVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 15:21:08 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629573629; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=a/CGSa13ltQ0+VJXtsPJ4pMzrIAABHKl6f/JaLvluu4=;
 b=R9JmEfly6Jq6s1gpFOXkceMH5vNsYZm2VBV8fZ6dxONmlQ7tV+KX+5Hypoc2R0a/17dKQYWq
 KFtKscakidkDWzxP3ce4ydECxEcwzbwgB2G9dyToBCDdweSz5B5UOGC8V/EF2cM3EQLMpBKu
 TJ2sFMVkQK5nyAJxnSu8BOeOcI8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 612151e7f588e42af19bb408 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 21 Aug 2021 19:20:07
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A2C21C4360C; Sat, 21 Aug 2021 19:20:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5E08DC4338F;
        Sat, 21 Aug 2021 19:20:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 5E08DC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4] rtw88: Remove unnecessary check code
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210731163546.10753-1-len.baker@gmx.com>
References: <20210731163546.10753-1-len.baker@gmx.com>
To:     Len Baker <len.baker@gmx.com>
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Len Baker <len.baker@gmx.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Brian Norris <briannorris@chromium.org>,
        Pkshih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210821192007.A2C21C4360C@smtp.codeaurora.org>
Date:   Sat, 21 Aug 2021 19:20:07 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Len Baker <len.baker@gmx.com> wrote:

> The rtw_pci_init_rx_ring function is only ever called with a fixed
> constant or RTK_MAX_RX_DESC_NUM for the "len" argument. Since this
> constant is defined as 512, the "if (len > TRX_BD_IDX_MASK)" check
> can never happen (TRX_BD_IDX_MASK is defined as GENMASK(11, 0) or in
> other words as 4095).
> 
> So, remove this check.
> 
> The true motivation for this patch is to silence a false Coverity
> warning.
> 
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Len Baker <len.baker@gmx.com>

Patch applied to wireless-drivers-next.git, thanks.

d816ce8744db rtw88: Remove unnecessary check code

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210731163546.10753-1-len.baker@gmx.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

