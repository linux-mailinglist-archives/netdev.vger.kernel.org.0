Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AAE41A954
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 09:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239125AbhI1HKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 03:10:23 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:52184 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233681AbhI1HKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 03:10:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632812921; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=NbgCIa3Gl+MtzFfn8EnQysUFN0JTk5Qjp1DKB1KP/v8=;
 b=GPmTMvSjQUd1hRWrp+RQQmxYGnnm8qjgm0PgpJ4DEd1oEuvPJeVG8MmN1ZTyxVpffmQwa8U+
 oWMTMRYw52gYOvg3T7m9CDxEBumJejiEzPmUf7/fe7wRe3zJWRw9J2yAV+VSuL7M/ZBL7Fa5
 B8wpLWsZGxrHz0KJDqNfFVHVxWg=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 6152bf7247d64efb6d8b2922 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 28 Sep 2021 07:08:34
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 71F4EC4338F; Tue, 28 Sep 2021 07:08:34 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5C91FC4338F;
        Tue, 28 Sep 2021 07:08:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 5C91FC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] Revert "brcmfmac: use ISO3166 country code and 0 rev as
 fallback"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210926201905.211605-1-smoch@web.de>
References: <20210926201905.211605-1-smoch@web.de>
To:     Soeren Moch <smoch@web.de>
Cc:     Soeren Moch <smoch@web.de>, stable@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210928070834.71F4EC4338F@smtp.codeaurora.org>
Date:   Tue, 28 Sep 2021 07:08:34 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Soeren Moch <smoch@web.de> wrote:

> This reverts commit b0b524f079a23e440dd22b04e369368dde847533.
> 
> Commit b0b524f079a2 ("brcmfmac: use ISO3166 country code and 0 rev
> as fallback") changes country setup to directly use ISO3166 country
> codes if no more specific code is configured. This was done under
> the assumption that brcmfmac firmwares can handle such simple
> direct mapping from country codes to firmware ccode values.
> 
> Unfortunately this is not true for all chipset/firmware combinations.
> E.g. BCM4359/9 devices stop working as access point with this change,
> so revert the offending commit to avoid the regression.
> 
> Signed-off-by: Soeren Moch <smoch@web.de>
> Cc: stable@vger.kernel.org  # 5.14.x
> Acked-by: Shawn Guo <shawn.guo@linaro.org>

Patch applied to wireless-drivers.git, thanks.

151a7c12c4fc Revert "brcmfmac: use ISO3166 country code and 0 rev as fallback"

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210926201905.211605-1-smoch@web.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

