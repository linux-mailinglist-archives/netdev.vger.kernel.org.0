Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612682D160D
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgLGQdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:33:41 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:19932 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgLGQdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:33:41 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607358809; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=6WOopDI/unQJHf8aMm74k1dhc1OxvbsE01SWfNkNfBs=;
 b=vOoA6oyswIGI9lt9kQz5wyD3LJTwYWL22Pr0jUnb6ObvxGOByw+/n5UDrowucyyz3a75l2Kb
 NjDKGYrnkatcBtNytSzWdd3tGE2CawMyJrdHwEK0PBQK6hvzTNdiNRWgANQA4xHmjEBsuSz2
 TvFJA2NZsMMT3kPQ3ge7bNlB+8w=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5fce5933ae7b105766d749a7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 07 Dec 2020 16:32:51
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 184B6C43463; Mon,  7 Dec 2020 16:32:51 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 46670C433CA;
        Mon,  7 Dec 2020 16:32:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 46670C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [17/17] rtw88: pci: Add prototypes for .probe,
 .remove and .shutdown
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201126133152.3211309-18-lee.jones@linaro.org>
References: <20201126133152.3211309-18-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201207163251.184B6C43463@smtp.codeaurora.org>
Date:   Mon,  7 Dec 2020 16:32:51 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Also strip out other duplicates from driver specific headers.
> 
> Ensure 'main.h' is explicitly included in 'pci.h' since the latter
> uses some defines from the former.  It avoids issues like:
> 
>  from drivers/net/wireless/realtek/rtw88/rtw8822be.c:5:
>  drivers/net/wireless/realtek/rtw88/pci.h:209:28: error: ‘RTK_MAX_TX_QUEUE_NUM’ undeclared here (not in a function); did you mean ‘RTK_MAX_RX_DESC_NUM’?
>  209 | DECLARE_BITMAP(tx_queued, RTK_MAX_TX_QUEUE_NUM);
>  | ^~~~~~~~~~~~~~~~~~~~
> 
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/realtek/rtw88/pci.c:1488:5: warning: no previous prototype for ‘rtw_pci_probe’ [-Wmissing-prototypes]
>  1488 | int rtw_pci_probe(struct pci_dev *pdev,
>  | ^~~~~~~~~~~~~
>  drivers/net/wireless/realtek/rtw88/pci.c:1568:6: warning: no previous prototype for ‘rtw_pci_remove’ [-Wmissing-prototypes]
>  1568 | void rtw_pci_remove(struct pci_dev *pdev)
>  | ^~~~~~~~~~~~~~
>  drivers/net/wireless/realtek/rtw88/pci.c:1590:6: warning: no previous prototype for ‘rtw_pci_shutdown’ [-Wmissing-prototypes]
>  1590 | void rtw_pci_shutdown(struct pci_dev *pdev)
>  | ^~~~~~~~~~~~~~~~
> 
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied to wireless-drivers-next.git, thanks.

2e86ef413ab3 rtw88: pci: Add prototypes for .probe, .remove and .shutdown

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201126133152.3211309-18-lee.jones@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

