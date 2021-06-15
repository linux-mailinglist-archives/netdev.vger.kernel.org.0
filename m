Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500AB3A81B8
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhFOOGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:06:30 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:60310 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbhFOOGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:06:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623765840; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=uSOjW2PIXQ8WAoXFoxYSHFnVzsjgBvCSgyXBJHrOxfM=;
 b=ixyxqDN6qmgnhHKk4bBU0KFn5tKLGsrv+v6RljLIQejtf7lJrw3WBwHJflorC3pSQ8EpYy5Z
 +KMK1Ir5w4L9gm0MCn2YLUh3xqT3/c2m6Ahd0kHaNyrPubEMmRZjwZGd1LRnUrXQ3xdfITSO
 8UY2q6wPzsNVbEt6T8QPt4JQQlI=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 60c8b2e7f726fa4188bacb2a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 14:02:15
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 73C95C433D3; Tue, 15 Jun 2021 14:02:14 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CA6C8C433D3;
        Tue, 15 Jun 2021 14:02:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CA6C8C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: Fix an error handling path in
 'ath11k_core_fetch_board_data_api_n()'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <e959eb544f3cb04258507d8e25a6f12eab126bde.1621676864.git.christophe.jaillet@wanadoo.fr>
References: <e959eb544f3cb04258507d8e25a6f12eab126bde.1621676864.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, bperumal@codeaurora.org,
        akolli@codeaurora.org, milehu@codeaurora.org, lkp@intel.com,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210615140214.73C95C433D3@smtp.codeaurora.org>
Date:   Tue, 15 Jun 2021 14:02:14 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> All error paths but this one 'goto err' in order to release some
> resources.
> Fix this.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

515bda1d1e51 ath11k: Fix an error handling path in ath11k_core_fetch_board_data_api_n()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/e959eb544f3cb04258507d8e25a6f12eab126bde.1621676864.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

