Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18573428697
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 08:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbhJKGGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 02:06:47 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:13485 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233853AbhJKGGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 02:06:43 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633932284; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=er5IrrkOUDHmVjILIRqINntFeH/7+WS563hJtxyeM3I=;
 b=ho6EEZGjr/FZ2z6q/sMPqg5e3Aoscf08zcCz3QFA1mnv3FBarDUnvi6fJofq+4rg8mdOAWx3
 7UN9YRaNGwvNt/nm3Sa6u83JOEPjAu4fmV86STTk4BgCl+QyEuiwxW/jbGJXJYh4R82w5azH
 lhiWcQKO2o524g92qOOy8SOD/D0=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 6163d3fb446c6db0cb7b4878 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 11 Oct 2021 06:04:43
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E19C6C4361B; Mon, 11 Oct 2021 06:04:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B402DC4338F;
        Mon, 11 Oct 2021 06:04:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org B402DC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210307113550.7720-1-konrad.dybcio@somainline.org>
References: <20210307113550.7720-1-konrad.dybcio@somainline.org>
To:     Konrad Dybcio <konrad.dybcio@somainline.org>
Cc:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        martin.botka@somainline.org,
        angelogioacchino.delregno@somainline.org,
        marijn.suijten@somainline.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163393227439.11913.16736072075122117569.kvalo@codeaurora.org>
Date:   Mon, 11 Oct 2021 06:04:42 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Konrad Dybcio <konrad.dybcio@somainline.org> wrote:

> Add support for BCM43596 dual-band AC chip, found in
> SONY Xperia X Performance, XZ and XZs smartphones (and
> *possibly* other devices from other manufacturers).
> The chip doesn't require any special handling and seems to work
> just fine OOTB.
> 
> PCIe IDs taken from: https://github.com/sonyxperiadev/kernel/commit/9e43fefbac8e43c3d7792e73ca52a052dd86d7e3.patch
> 
> Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>

Failed to apply, please rebase on top of wireless-drivers-next and
resend as v2.

Recorded preimage for 'drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c'
error: Failed to merge in the changes.
hint: Use 'git am --show-current-patch' to see the failed patch
Applying: brcmfmac: Add support for BCM43596 PCIe Wi-Fi
Using index info to reconstruct a base tree...
M	drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
M	drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
M	drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
CONFLICT (content): Merge conflict in drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
Patch failed at 0001 brcmfmac: Add support for BCM43596 PCIe Wi-Fi

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210307113550.7720-1-konrad.dybcio@somainline.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

