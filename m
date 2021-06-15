Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525C53A7C15
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 12:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhFOKie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 06:38:34 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:51033 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbhFOKid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 06:38:33 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623753389; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=alpzxyvk2Njro7UNVcgYjWQhHTgptmyg+naabYVQMLk=;
 b=dkjXaJP08jNU1Mp1vaMR+fAVRyPuhf9BVfUtOUtbK9kocB90Bn1wGciMmIuh0gdQ7IKe8SxZ
 0ib2I/b5HKTc39t2y4uYUJb++L7/RSHTpdt4MUVKkcRvozDEj0vz8fk7hWzGHr50l75GvzzZ
 Dy6NAEmHdXdsw3awGOiGJoY1Egw=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60c882aced59bf69cc390458 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 10:36:28
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4211BC43460; Tue, 15 Jun 2021 10:36:28 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9FAEBC433F1;
        Tue, 15 Jun 2021 10:36:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9FAEBC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: use ISO3166 country code and 0 rev as fallback
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210425110200.3050-1-shawn.guo@linaro.org>
References: <20210425110200.3050-1-shawn.guo@linaro.org>
To:     Shawn Guo <shawn.guo@linaro.org>
Cc:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, Shawn Guo <shawn.guo@linaro.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210615103628.4211BC43460@smtp.codeaurora.org>
Date:   Tue, 15 Jun 2021 10:36:28 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shawn Guo <shawn.guo@linaro.org> wrote:

> Instead of aborting country code setup in firmware, use ISO3166 country
> code and 0 rev as fallback, when country_codes mapping table is not
> configured.  This fallback saves the country_codes table setup for recent
> brcmfmac chipsets/firmwares, which just use ISO3166 code and require no
> revision number.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

Patch applied to wireless-drivers-next.git, thanks.

b0b524f079a2 brcmfmac: use ISO3166 country code and 0 rev as fallback

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210425110200.3050-1-shawn.guo@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

