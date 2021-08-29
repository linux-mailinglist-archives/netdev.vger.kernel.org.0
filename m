Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5913FAA2B
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 10:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbhH2IdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 04:33:12 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:31805 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbhH2IdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 04:33:08 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630225936; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=sDPTy8KAE9CIK5/hJskuePHV4t04MtL3PTjzg1WFFFE=;
 b=GI0IXmTbiwBWUI4jsB8jZHX0Yfj43sLQ347ZT0POU9iVM+HW5Zam/qow9SjtVXflX92p5bm8
 Uef6o9ngb1Sxb8N/O0yXECs7aA23U7cBd8mAoANxzszyMT+TAcUdQSAGf2hNndzVQwvzYdLP
 DA2Htq8lMthLAz6dq9QH4v71v9U=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 612b460f40d2129ac1b87139 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 29 Aug 2021 08:32:15
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 90630C43617; Sun, 29 Aug 2021 08:32:15 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9F7DFC4338F;
        Sun, 29 Aug 2021 08:32:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 9F7DFC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: make array fsm_state static const,
 makes object smaller
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210819125018.8577-1-colin.king@canonical.com>
References: <20210819125018.8577-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210829083215.90630C43617@smtp.codeaurora.org>
Date:   Sun, 29 Aug 2021 08:32:15 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the array fsm_state on the stack but instead it
> static const. Makes the object code smaller by 154 bytes:
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>    9213	   3904	      0	  13117	   333d	.../wireless/rsi/rsi_91x_debugfs.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>    8995	   3968	      0	  12963	   32a3	.../wireless/rsi/rsi_91x_debugfs.o
> 
> (gcc version 10.3.0)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

f4c813641897 rsi: make array fsm_state static const, makes object smaller

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210819125018.8577-1-colin.king@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

