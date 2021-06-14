Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF333A6AAD
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 17:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhFNPnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 11:43:19 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:20605 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234056AbhFNPnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 11:43:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623685275; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=1VUK17VDEqlhzzGGrjKr05lLrqM02n+e4Lw+khFBvkc=;
 b=va6Q9KSTSf6agCbK1/hvznA3nu1O4mg0MxlDnw8Ki9uUpqvjS4aXlJZDPdQFsJhqfBPfvmBN
 5ZZ57AHvFbvSOq961pEF2tQOnTgzAcgZlLXqg7GVG74GELUfDiRTgJdq9GRpTvivN1Uqj6O6
 V6OroFR1pJstvsM2Vxxl8Lk3bfE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60c77881ed59bf69cc5b15a4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 14 Jun 2021 15:40:49
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AFD84C433D3; Mon, 14 Jun 2021 15:40:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5E5CBC4338A;
        Mon, 14 Jun 2021 15:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5E5CBC4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix an error code in ath10k_add_interface()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1621939577-62218-1-git-send-email-yang.lee@linux.alibaba.com>
References: <1621939577-62218-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210614154048.AFD84C433D3@smtp.codeaurora.org>
Date:   Mon, 14 Jun 2021 15:40:48 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> wrote:

> When the code execute this if statement, the value of ret is 0.
> However, we can see from the ath10k_warn() log that the value of
> ret should be -EINVAL.
> 
> Clean up smatch warning:
> 
> drivers/net/wireless/ath/ath10k/mac.c:5596 ath10k_add_interface() warn:
> missing error code 'ret'
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: 'commit ccec9038c721 ("ath10k: enable raw encap mode and software
> crypto engine")'
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Fixes tag is wrong, it should be:

Fixes: ccec9038c721 ("ath10k: enable raw encap mode and software crypto engine")

I fixed this in the pending branch, no need to resend because of this.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1621939577-62218-1-git-send-email-yang.lee@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

