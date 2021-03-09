Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BEA332359
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 11:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhCIKuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 05:50:10 -0500
Received: from z11.mailgun.us ([104.130.96.11]:17920 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhCIKti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 05:49:38 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615286978; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=262kPBkfPskEU7H8i6yK0y3xXTvs+et/XQylcPjZ9UU=;
 b=pHp5jDaDqE4ZxeUTxHYS7Uc1bOvh4CEc47zLvU3mQh0Cis28uXM1WS2n+GC9ZDKkpuxy1mvD
 ben5kBB1eQqeNaGYW0HyT47CmPsBxCxr5OgOt8UHqlw0D/YV4+mIcLSRJ3V+eJUmujWMhnIa
 3La8a1/+jrFPBecB/PFC/JSfYqk=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 604752bff842f723a9da3fae (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 09 Mar 2021 10:49:35
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 155B5C433ED; Tue,  9 Mar 2021 10:49:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B3619C433CA;
        Tue,  9 Mar 2021 10:49:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B3619C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] ath10k: skip the wait for completion to recovery in
 shutdown path
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210223142908.23374-1-youghand@codeaurora.org>
References: <20210223142908.23374-1-youghand@codeaurora.org>
To:     Youghandhar Chintala <youghand@codeaurora.org>
Cc:     ath10k@lists.infradead.org,
        ath10k-review.external@qti.qualcomm.com, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuabhs@chromium.org, dianders@chromium.org,
        briannorris@chromium.org,
        Youghandhar Chintala <youghand@codeaurora.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210309104935.155B5C433ED@smtp.codeaurora.org>
Date:   Tue,  9 Mar 2021 10:49:35 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Youghandhar Chintala <youghand@codeaurora.org> wrote:

> Currently in the shutdown callback we wait for recovery to complete
> before freeing up the resources. This results in additional two seconds
> delay during the shutdown and thereby increase the shutdown time.
> 
> As an attempt to take less time during shutdown, remove the wait for
> recovery completion in the shutdown callback and added an API to freeing
> the reosurces in which they were common for shutdown and removing
> the module.
> 
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Youghandhar Chintala <youghand@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

018e3fa8e7ff ath10k: skip the wait for completion to recovery in shutdown path

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210223142908.23374-1-youghand@codeaurora.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

