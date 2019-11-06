Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68BC4F1D70
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 19:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732495AbfKFSXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 13:23:04 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52008 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbfKFSXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 13:23:03 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C39B46039C; Wed,  6 Nov 2019 18:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573064582;
        bh=f8LjsY8UAdJTWrsEXBbmOOJZMmDExAEs4UlfYAv6xAE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YQWssHj1hIp+G+mBMsNF/15B/cru208q0naT/vdBj3rtlvIu7fUahenofDI4Piq/y
         qNiNd1pxe245ohucnRRUocr5eajxHZz+C/KU6HmfVXMYUSzJk4WAUIv2J1th6eZERc
         sIcnVZfWrRrtW66MdifMuOenKtQG2c8Jv6OscM2U=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 832D860274;
        Wed,  6 Nov 2019 18:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573064582;
        bh=f8LjsY8UAdJTWrsEXBbmOOJZMmDExAEs4UlfYAv6xAE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YQWssHj1hIp+G+mBMsNF/15B/cru208q0naT/vdBj3rtlvIu7fUahenofDI4Piq/y
         qNiNd1pxe245ohucnRRUocr5eajxHZz+C/KU6HmfVXMYUSzJk4WAUIv2J1th6eZERc
         sIcnVZfWrRrtW66MdifMuOenKtQG2c8Jv6OscM2U=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 832D860274
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ikjoon Jang <ikjn@chromium.org>
Cc:     ath10k@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ath10k: disable cpuidle during downloading firmware.
References: <20191101054035.42101-1-ikjn@chromium.org>
Date:   Wed, 06 Nov 2019 20:22:58 +0200
In-Reply-To: <20191101054035.42101-1-ikjn@chromium.org> (Ikjoon Jang's message
        of "Fri, 1 Nov 2019 13:40:35 +0800")
Message-ID: <87y2ws3lvh.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ikjoon Jang <ikjn@chromium.org> writes:

> Downloading ath10k firmware needs a large number of IOs and
> cpuidle's miss predictions make it worse. In the worst case,
> resume time can be three times longer than the average on sdio.
>
> This patch disables cpuidle during firmware downloading by
> applying PM_QOS_CPU_DMA_LATENCY in ath10k_download_fw().
>
> Signed-off-by: Ikjoon Jang <ikjn@chromium.org>

On what hardware and firmware versions did you test this? I'll add that
to the commit log.

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/submittingpatches#guidelines

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
