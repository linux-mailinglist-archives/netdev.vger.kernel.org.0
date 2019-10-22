Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF76FDFF5E
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 10:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388397AbfJVI0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 04:26:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46376 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388155AbfJVI0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 04:26:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1DE316079D; Tue, 22 Oct 2019 08:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571732799;
        bh=K/gWunNfzWpOoNvgi+N0faiER3IPcKA6AOuagWiAEAY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=eb0dm47I0/sBoWudqGk9JM2i4FLYHWx2OMpG5wMTL7sjikPQfQVes9IPdczF8vzVt
         QyTcF9pFqVCU+E/ldC6tBvQ4KvDrgH9QS+DYnXiPuzwXVW9rNP/cpXngql5laRRi/h
         LpmPliwWjnwhLBdwxLLF+bncCg+uH7vV3iEXlBGw=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 393CC60779;
        Tue, 22 Oct 2019 08:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571732798;
        bh=K/gWunNfzWpOoNvgi+N0faiER3IPcKA6AOuagWiAEAY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=DH4QnrxraDMwUgEb33K7vebJVkhj04kFQWh9z8Nc0Kg6plBEnjFBUpfL+VZLQ002r
         noANk2vFykv+fJ4iXttxitkT/RL1j2TIErEOv3c5SJr1JY1B/sQBp9rbGGZbJ063EB
         nUedHV3HGlS4uELVtrIsmnBaSQduJhb6WMJv/7uY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 393CC60779
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtl8xxxu: fix RTL8723BU connection failure issue after
 warm reboot
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191016015408.11091-1-chiu@endlessm.com>
References: <20191016015408.11091-1-chiu@endlessm.com>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191022082639.1DE316079D@smtp.codeaurora.org>
Date:   Tue, 22 Oct 2019 08:26:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chiu@endlessm.com> wrote:

> The RTL8723BU has problems connecting to AP after each warm reboot.
> Sometimes it returns no scan result, and in most cases, it fails
> the authentication for unknown reason. However, it works totally
> fine after cold reboot.
> 
> Compare the value of register SYS_CR and SYS_CLK_MAC_CLK_ENABLE
> for cold reboot and warm reboot, the registers imply that the MAC
> is already powered and thus some procedures are skipped during
> driver initialization. Double checked the vendor driver, it reads
> the SYS_CR and SYS_CLK_MAC_CLK_ENABLE also but doesn't skip any
> during initialization based on them. This commit only tells the
> RTL8723BU to do full initialization without checking MAC status.
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

0eeb91ade90c rtl8xxxu: fix RTL8723BU connection failure issue after warm reboot

-- 
https://patchwork.kernel.org/patch/11192201/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

