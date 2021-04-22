Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483783681F4
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 15:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbhDVNzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 09:55:11 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:22708 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236365AbhDVNzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 09:55:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619099674; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=uv2qyrmEi4TwpCp1U2TqtW6eqajB9ZYNrKzSmO0EAjo=;
 b=LVBrAamyiUn+zEq1UNd1foDR9Linir6527ngnTUFooMCB//oLwjtlWXzvGcFGCjHQZmdT74s
 34dMe3cBsOtspH3SD0tXM/xXxgF0d6t3R6UXtthM92FUY5ldq/QV2uBfsX/zRi8pMbLfTsRc
 YFBKWHHNzK5DVGrdfBEUsYP4ETA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 60818019e0e9c9a6b6e084f8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 22 Apr 2021 13:54:33
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CB321C433F1; Thu, 22 Apr 2021 13:54:33 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BB23DC433D3;
        Thu, 22 Apr 2021 13:54:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BB23DC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wireless: ath10k: Fix a use after free in
 ath10k_htc_send_bundle
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210329120154.8963-1-lyl2019@mail.ustc.edu.cn>
References: <20210329120154.8963-1-lyl2019@mail.ustc.edu.cn>
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210422135433.CB321C433F1@smtp.codeaurora.org>
Date:   Thu, 22 Apr 2021 13:54:33 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lv Yunlong <lyl2019@mail.ustc.edu.cn> wrote:

> In ath10k_htc_send_bundle, the bundle_skb could be freed by
> dev_kfree_skb_any(bundle_skb). But the bundle_skb is used later
> by bundle_skb->len.
> 
> As skb_len = bundle_skb->len, my patch replaces bundle_skb->len to
> skb_len after the bundle_skb was freed.
> 
> Fixes: c8334512f3dd1 ("ath10k: add htt TX bundle for sdio")
> Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

8392df5d7e0b ath10k: Fix a use after free in ath10k_htc_send_bundle

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210329120154.8963-1-lyl2019@mail.ustc.edu.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

