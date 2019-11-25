Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46E26108DAC
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 13:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfKYMPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 07:15:00 -0500
Received: from a27-185.smtp-out.us-west-2.amazonses.com ([54.240.27.185]:56476
        "EHLO a27-185.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbfKYMPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 07:15:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574684099;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=FYS9WywPAdYEkfH5HwtBByCXzTvOkzfIsREpBKqsp2Q=;
        b=k33wwE1sDLEH5lvh2dQgQ6AGE9noYYXlWHB4n28pLiGfeUroOxaFidRUYPVFPRcA
        h9lIpEvpL8I2H5TmJyy8CQ5XWlqgAfK0ktDHHSMoD3fn2mjSq8mRROUmsoKvHSLSIdc
        uAvxBoZp7DWDApzfrbYCOwrGwL9KbT8GA44I3olM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574684099;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=FYS9WywPAdYEkfH5HwtBByCXzTvOkzfIsREpBKqsp2Q=;
        b=JAQUZMQA7hAvQZk6uUmWvW6GoN24nuu4KP4Cocmn47L/RPAqE6h9NST0i0alTxDp
        yXE6SLEmhEPayhFxW11PBHUNmccEbKgxqxJrwzUZOG+Wcts5WFBNYCEawv8XgPiH0Pk
        1LAkIY2qWTuDqTaQfWBOGEwQuOhXp5n6BysUTH4A=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D993DC76F45
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wil6210: fix break that is never reached because of
 zero'ing of a retry counter
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191115120953.48137-1-colin.king@canonical.com>
References: <20191115120953.48137-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Maya Erez <merez@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-ID: <0101016ea27c8290-6a36151e-699b-46d6-a206-290403315074-000000@us-west-2.amazonses.com>
Date:   Mon, 25 Nov 2019 12:14:59 +0000
X-SES-Outgoing: 2019.11.25-54.240.27.185
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> There is a check on the retry counter invalid_buf_id_retry that is always
> false because invalid_buf_id_retry is initialized to zero on each iteration
> of a while-loop.  Fix this by initializing the retry counter before the
> while-loop starts.
> 
> Addresses-Coverity: ("Logically dead code")
> Fixes: b4a967b7d0f5 ("wil6210: reset buff id in status message after completion")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Reviewed-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

5b1413f00b5b wil6210: fix break that is never reached because of zero'ing of a retry counter

-- 
https://patchwork.kernel.org/patch/11246193/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

