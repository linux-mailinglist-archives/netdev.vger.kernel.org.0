Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB07A2AA6A3
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 17:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgKGQTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 11:19:53 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:50521 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728250AbgKGQTw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 11:19:52 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604765992; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=NnQ6UNO+8umQ59Id60TVdkDgcWPo+xFIoMKHjZf9InY=;
 b=WpUsXIIZoRfebsT9uVTrln/9p6edvvBNgYMwTxKtxXsLmxECO3SenyeRIk+7yD0cIzFqcjab
 L68pPuEab6g4Xlj5QHWyY0ujeE+uI3wfSxxL2sm+hkvBx8MMgl6W9gff6zmhzs3jgjdPGZqb
 VlM1nrevYK91m5ZwxN4VhUF6qQI=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5fa6c927c1b74298b70a68c0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 16:19:51
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7B88EC43387; Sat,  7 Nov 2020 16:19:50 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D5FC3C433C6;
        Sat,  7 Nov 2020 16:19:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D5FC3C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v2] brcmfmac: Fix memory leak for unpaired brcmf_{alloc/free}
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1603849967-22817-1-git-send-email-sw0312.kim@samsung.com>
References: <1603849967-22817-1-git-send-email-sw0312.kim@samsung.com>
To:     Seung-Woo Kim <sw0312.kim@samsung.com>
Cc:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, smoch@web.de,
        sandals@crustytoothpaste.net, rafal@milecki.pl, digetx@gmail.com,
        double.lo@cypress.com, amsr@cypress.com, stanley.hsu@cypress.com,
        saravanan.shanmugham@cypress.com, jean-philippe@linaro.org,
        frank.kao@cypress.com, netdev@vger.kernel.org,
        sw0312.kim@samsung.com, jh80.chung@samsung.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107161950.7B88EC43387@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 16:19:50 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Seung-Woo Kim <sw0312.kim@samsung.com> wrote:

> There are missig brcmf_free() for brcmf_alloc(). Fix memory leak
> by adding missed brcmf_free().
> 
> Reported-by: Jaehoon Chung <jh80.chung@samsung.com>
> Fixes: a1f5aac1765a ("brcmfmac: don't realloc wiphy during PCIe reset")
> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

9db946284e07 brcmfmac: Fix memory leak for unpaired brcmf_{alloc/free}

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1603849967-22817-1-git-send-email-sw0312.kim@samsung.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

