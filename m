Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AD62807C4
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732803AbgJATac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:30:32 -0400
Received: from z5.mailgun.us ([104.130.96.5]:43550 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730152AbgJATa3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 15:30:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601580628; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=nBJ75yP41UnXYdgyDPSxmOLYDANcHjhJRBqTGpKi2qk=;
 b=Sz5n41rM4kPnN/MRcTTm2K0SqEt18AWh/HLEjOXZNTVD49KBgSyWrNe5puiiDXHSfRLCOwkj
 3GuHWZ9VOxHsv10O2zkxMdUi5c3g8pqN7RZlX+X+pW/1w+YNJ5MCGPDeVk6kun8BptcAsqc9
 035GkkWJ3g5cGRsleWK45zSOq7k=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5f762e53e89f7b4c78450058 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 01 Oct 2020 19:30:27
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0F73EC433CB; Thu,  1 Oct 2020 19:30:27 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C924BC433CA;
        Thu,  1 Oct 2020 19:30:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C924BC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: Correctly check errors for calls to
 debugfs_create_dir()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200927132451.585473-1-alex.dewar90@gmail.com>
References: <20200927132451.585473-1-alex.dewar90@gmail.com>
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input)
        Alex Dewar <alex.dewar90@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)Alex Dewar <alex.dewar90@gmail.com>
                                                                     ^-missing end of address
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201001193027.0F73EC433CB@smtp.codeaurora.org>
Date:   Thu,  1 Oct 2020 19:30:27 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alex Dewar <alex.dewar90@gmail.com> wrote:

> debugfs_create_dir() returns an ERR_PTR in case of error, but never a
> null pointer. There are a number of places where error-checking code can
> accordingly be simplified.
> 
> Addresses-Coverity: CID 1497150: Memory - illegal accesses (USE_AFTER_FREE)
> Addresses-Coverity: CID 1497158: Memory - illegal accesses (USE_AFTER_FREE)
> Addresses-Coverity: CID 1497160: Memory - illegal accesses (USE_AFTER_FREE)
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

476c1d3c2e61 ath11k: Correctly check errors for calls to debugfs_create_dir()

-- 
https://patchwork.kernel.org/patch/11802131/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

