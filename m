Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9540A149A30
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 11:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbgAZKpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 05:45:49 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:11300 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729299AbgAZKps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 05:45:48 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580035547; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=lKIj5JfD580Id9PMIjtYGG9Iadxjo+CVo5FKnaSVU/o=;
 b=sDIzu8PhGj+lfcwZ2Vj/mHDk0I3QG3vBVXWLyPmwEddMJrttto8hgbesywn5hVd4YFA9f6iO
 /BYffGRSX+UUWshMCG4M0M/LQDP/TojgCgtAwuIOntOPyu6pvKXy9BjpHp59VWBWq59mfuzq
 VLR8sOj6RDtweQuyP60rnFcxyU0=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2d6dda.7f30fa55b688-smtp-out-n01;
 Sun, 26 Jan 2020 10:45:46 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 83226C447A2; Sun, 26 Jan 2020 10:45:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5B208C433CB;
        Sun, 26 Jan 2020 10:45:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5B208C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: ensure ts.flags is initialized before bit-wise
 or'ing in values
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191221004046.15859-1-colin.king@canonical.com>
References: <20191221004046.15859-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Anilkumar Kolli <akolli@codeaurora.org>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        Sven Eckelmann <seckelmann@datto.com>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126104545.83226C447A2@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 10:45:45 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> Currently the structure ts is not inititalized and ts.flags contains
> garbage values from the stack.  This is being passed into function
> ath11k_dp_tx_status_parse that bit-wise or'ing in settings into the
> ts.flags field.  To avoid flags (and other fields) from containing
> garbage, initialize the structure to zero before use.
> 
> Addresses-Coverity: ("Uninitialized scalar variable)"
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

eefca584140b ath11k: ensure ts.flags is initialized before bit-wise or'ing in values

-- 
https://patchwork.kernel.org/patch/11306545/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
