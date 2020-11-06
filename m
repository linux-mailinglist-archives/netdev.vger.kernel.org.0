Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424112A8F7B
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 07:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgKFGgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 01:36:02 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:35262 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbgKFGgC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 01:36:02 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604644561; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=tM5oyoSHdl+1J/pOwaOVdO0e2S4mJz91rpdSkgpqyx0=;
 b=CEzqJ08SGG8gGfeykWyQyg5R4EJ9CmNApyk22Pflt4Yxn6EcGg/gMO5zPFYCPgOtigd0j+lW
 6N/iM0WGWEXTAyzTaD1a4STAwXQj0iBYdnKRlcKeO+FUFSPAxN81PKgnzFoCIQoQVXgiWUBG
 WQXZQRBdUSk2vEBye6/bR1LhGf0=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5fa4eed01baf490ee90e54e8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 06 Nov 2020 06:36:00
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 91670C433FF; Fri,  6 Nov 2020 06:36:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 86CC2C433C8;
        Fri,  6 Nov 2020 06:35:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 86CC2C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: sdio: remove redundant check in for loop
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200916165748.20927-1-alex.dewar90@gmail.com>
References: <20200916165748.20927-1-alex.dewar90@gmail.com>
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input)
        Alex Dewar <alex.dewar90@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)Alex Dewar <alex.dewar90@gmail.com>
                                                                     ^-missing end of address
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201106063600.91670C433FF@smtp.codeaurora.org>
Date:   Fri,  6 Nov 2020 06:36:00 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alex Dewar <alex.dewar90@gmail.com> wrote:

> The for loop checks whether cur_section is NULL on every iteration, but
> we know it can never be NULL as there is another check towards the
> bottom of the loop body. Refactor to avoid this unnecessary check.
> 
> Also, increment the variable i inline for clarity
> 
> Addresses-Coverity: 1496984 ("Null pointer dereferences)
> Suggested-by: Saeed Mahameed <saeedm@nvidia.com>
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

dbeb101d28eb ath10k: sdio: remove redundant check in for loop

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20200916165748.20927-1-alex.dewar90@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

