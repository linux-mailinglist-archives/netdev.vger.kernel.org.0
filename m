Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC5C3AD8D3
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 11:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbhFSJPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 05:15:37 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:64467 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230471AbhFSJPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Jun 2021 05:15:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624094006; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=H0sbWODlKoSLIOSfRR0sPPZJCVLCPWUz5A6uE/iTadY=;
 b=LTmPwYykkzATrXY7i3mziZHMk+Vf+tUsPvZA7krsI627g88ryaDP6FmJ77/LHhJjBfCqMZEm
 Mrle6CyZTA5136kycTsizvOKHWulwAiJY5XUGIxAQKDCCp3OOyANhed+VzwsFaTqfEp/d5Mm
 WN+MmJ2orKw/DCTD73Yf3n509tE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60cdb5202eaeb98b5e8cc93d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 19 Jun 2021 09:13:04
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 24FCBC4338A; Sat, 19 Jun 2021 09:13:04 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 83CA3C433F1;
        Sat, 19 Jun 2021 09:13:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 83CA3C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: demote chan info without scan request warning
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210522171609.299611-1-caleb@connolly.tech>
References: <20210522171609.299611-1-caleb@connolly.tech>
To:     Caleb Connolly <caleb@connolly.tech>
Cc:     caleb@connolly.tech, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210619091304.24FCBC4338A@smtp.codeaurora.org>
Date:   Sat, 19 Jun 2021 09:13:04 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Caleb Connolly <caleb@connolly.tech> wrote:

> Some devices/firmwares cause this to be printed every 5-15 seconds,
> though it has no impact on functionality. Demote this to a debug
> message.
> 
> I see this on SDM845 and MSM8998 platforms, specifically the OnePlus 6 devices,
> PocoPhone F1 and OnePlus 5.  On the OnePlus 6 (SDM845) we are stuck with the
> following signed vendor fw:
> 
> [    9.339873] ath10k_snoc 18800000.wifi: qmi chip_id 0x30214 chip_family 0x4001 board_id 0xff soc_id 0x40030001
> [    9.339897] ath10k_snoc 18800000.wifi: qmi fw_version 0x20060029 fw_build_timestamp 2019-07-12 02:14 fw_build_id QC_IMAGE_VERSION_STRING=WLAN.HL.2.0.c8-00041-QCAHLSWMTPLZ-1
> 
> The OnePlus 5 (MSM8998) is using firmware:
> 
> [ 6096.956799] ath10k_snoc 18800000.wifi: qmi chip_id 0x30214 chip_family 0x4001 board_id 0xff soc_id 0x40010002
> [ 6096.956824] ath10k_snoc 18800000.wifi: qmi fw_version 0x1007007e fw_build_timestamp 2020-04-14 22:45 fw_build_id QC_IMAGE_VERSION_STRING=WLAN.HL.1.0.c6-00126-QCAHLSWMTPLZ-1.211883.1.278648.
> 
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.2.0.c8-00041-QCAHLSWMTPLZ-1
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.1.0.c6-00126-QCAHLSWMTPLZ-1.211883.1.278648
> 
> Signed-off-by: Caleb Connolly <caleb@connolly.tech>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

8a952a955de7 ath10k: demote chan info without scan request warning

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210522171609.299611-1-caleb@connolly.tech/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

