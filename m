Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C31DB214F
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 15:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391682AbfIMNol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 09:44:41 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60136 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388489AbfIMNol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 09:44:41 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 17711607CA; Fri, 13 Sep 2019 13:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568382280;
        bh=vyt/3hzOSaAAxezkzLOi1iLD8HN1GuNmP4hYAG0W1FA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MnbV2qHM+bSPAbTmHbg3nNzGX8DE/Q0+tzN/lE933ZItOchPc5uZcPQs5Mz7ATmks
         JrDztRdcLFwTrmgQK95K4ty+XDlw8/PdsybhmbYwq5NZmwjbO1Dsv06Ix52pF5pcCW
         dOWdsrKhFzbaOx8HqxpOI+dsAt1RgYMWDIxp4jwI=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8882A602C3;
        Fri, 13 Sep 2019 13:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568382279;
        bh=vyt/3hzOSaAAxezkzLOi1iLD8HN1GuNmP4hYAG0W1FA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=FY+xJdkjqkV26JGjs6bIKRSpXRDCVa6SNEM0zTU+FtViblbDIbmbVNBhMGWqx9gLG
         r2xJm5zysJeRssGkH0F33b204BuNk+MPyzcB2n2/YWMyfUFqauvNVJaP8XTJKME6nz
         Bn5RqyFwn9Dq6FS4qDVz1y/o4J6Ri1rLAHgVbPmE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8882A602C3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8821ae: make array static const and remove
 redundant assignment
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190905150022.3609-1-colin.king@canonical.com>
References: <20190905150022.3609-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190913134440.17711607CA@smtp.codeaurora.org>
Date:   Fri, 13 Sep 2019 13:44:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The array channel_all can be make static const rather than populating
> it on the stack, this makes the code smaller.  Also, variable place
> is being initialized with a value that is never read, so this assignment
> is redundant and can be removed.
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>  118537	   9591	      0	 128128	  1f480	realtek/rtlwifi/rtl8821ae/phy.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>  118331	   9687	      0	 128018	  1f412	realtek/rtlwifi/rtl8821ae/phy.o
> 
> Saves 110 bytes, (gcc version 9.2.1, amd64)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

569ce0a486fd rtlwifi: rtl8821ae: make array static const and remove redundant assignment

-- 
https://patchwork.kernel.org/patch/11133295/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

