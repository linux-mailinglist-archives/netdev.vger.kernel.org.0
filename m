Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACA41201A
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 18:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfEBQ07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 12:26:59 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55512 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfEBQ07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 12:26:59 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A3E5B6083E; Thu,  2 May 2019 16:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556814418;
        bh=4odLYN4jUCJCzuV9WQU82jYINI/bjqsc5/jaSqVbFvI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hp7vtlBledDfIdDiTCjJxCZ392orplE5rk1jJeghhCUjQTCwRTsKvWLbwAP+YincW
         sSWPOlK+Z0C51USQGbEJFEeJVosCasEJio5DOjxapbo3W5QOzrY6U63u8Dkx/FWHeB
         RdmCvY4QMoyoEdCe5lbOJMuk5B1kkOy4TcfVGgMQ=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 69849608D4;
        Thu,  2 May 2019 16:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556814418;
        bh=4odLYN4jUCJCzuV9WQU82jYINI/bjqsc5/jaSqVbFvI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=irXBtchtqKmL5KPkQeC53tejKauDKzMHgOVvG3NgvhRWZyZglakmclIjb4VV/TnBt
         qRPBhBm+njcO33WM6FaP26iW7ytQvSYsMVFw/C7jjBPcYTgJdwvVNYBG31LkapyCfP
         eFsrPCoF8RksNOAuNOj2pF0cRor3ws+2W8So1Epg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 69849608D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtw88: Make RA_MASK macros ULL
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190502150209.4475-1-natechancellor@gmail.com>
References: <20190502150209.4475-1-natechancellor@gmail.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190502162658.A3E5B6083E@smtp.codeaurora.org>
Date:   Thu,  2 May 2019 16:26:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> wrote:

> Clang warns about the definitions of these macros (full warnings trimmed
> for brevity):
> 
> drivers/net/wireless/realtek/rtw88/main.c:524:15: warning: signed shift
> result (0x3FF00000000) requires 43 bits to represent, but 'int' only has
> 32 bits [-Wshift-overflow]
>                         ra_mask &= RA_MASK_VHT_RATES | RA_MASK_OFDM_IN_VHT;
>                                    ^~~~~~~~~~~~~~~~~
> drivers/net/wireless/realtek/rtw88/main.c:527:15: warning: signed shift
> result (0xFF0000000) requires 37 bits to represent, but 'int' only has
> 32 bits [-Wshift-overflow]
>                         ra_mask &= RA_MASK_HT_RATES | RA_MASK_OFDM_IN_HT_5G;
>                                    ^~~~~~~~~~~~~~~~
> 
> Given that these are all used with ra_mask, which is of type u64, we can
> just declare the macros to be ULL as well.
> 
> Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
> Link: https://github.com/ClangBuiltLinux/linux/issues/467
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

237b47efcdbc rtw88: Make RA_MASK macros ULL

-- 
https://patchwork.kernel.org/patch/10927105/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

