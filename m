Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA881651D
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 15:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfEGNxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 09:53:16 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59960 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfEGNxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 09:53:16 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2CAA5618DD; Tue,  7 May 2019 13:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557237195;
        bh=aOm21351qlYoCS9pCWfVXhiDH7ERraPogBHBMNHCVBE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=V/d1Gad4N+8SHZtqYdk+WxgFUvezsC2FCwN+FbdAZeQqs0VTXCCCvBWINmjnGSanQ
         gf3w0FJ+f/C7A2IdYv1ydOVf4bDX8jtQQruA0SOnkFakZ/pZvKYBT7AoYARIiGELvv
         AhX3ZrV/HnfsGt2MNagGj2aDUu3+/aZdtzIKcPLo=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1069D618CE;
        Tue,  7 May 2019 13:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557237193;
        bh=aOm21351qlYoCS9pCWfVXhiDH7ERraPogBHBMNHCVBE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=k1dVyMfrryn/R0K5Xlv6dU99wKnAxYeTe80gj7GTspdSxSonIXMjn6gy5LoqatKxW
         NPwCzwAERoricN4T6c+ypGkzKJlvRiUpWE3kEWxhpiMEGayobh9UX2I07FxXYY/0FZ
         kAOgiBjFcJqSCIrBqKNm52pEglBO7k9GX5YTTja4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1069D618CE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath10k: coredump: use struct_size() helper
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190403190636.GA9827@embeddedor>
References: <20190403190636.GA9827@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190507135315.2CAA5618DD@smtp.codeaurora.org>
Date:   Tue,  7 May 2019 13:53:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes, in particular in the
> context in which this code is being used.
> 
> So, replace code of the following form:
> 
> sizeof(*ce_hdr) + CE_COUNT * sizeof(ce_hdr->entries[0])
> 
> with:
> 
> struct_size(ce_hdr, entries, CE_COUNT)
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

4f735cd73650 ath10k: coredump: use struct_size() helper

-- 
https://patchwork.kernel.org/patch/10884377/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

