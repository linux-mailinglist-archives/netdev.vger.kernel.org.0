Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF0336820C
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 16:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbhDVOCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 10:02:15 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:11367 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236226AbhDVOCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 10:02:12 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619100097; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=9uDftcBL8Z/JOSMWyrbhAcEYePFk6Rg2aRLvXo+zRUI=;
 b=sLLLzQMSnfrU8htGOeNEOswly9pjsB/AnzBBfXbJ8acDbCBfbd8+z3RGD6QbP96ugbRa2R8x
 be1lAnZP1/7wCxEsnRJFsZUqD7NKz4vLUjKM9MXzqTNjSQn1lyH3SBtatZQDtJvYEbXmbKv9
 bJuxiYSsgszn8gEG3A0aKjHUTlE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 6081819603cfff3452910250 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 22 Apr 2021 14:00:54
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 437B6C4338A; Thu, 22 Apr 2021 14:00:53 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 76C7AC433F1;
        Thu, 22 Apr 2021 14:00:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 76C7AC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix ath10k_wmi_tlv_op_pull_peer_stats_info()
 unlock
 without lock
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210406230228.31301-1-skhan@linuxfoundation.org>
References: <20210406230228.31301-1-skhan@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, pavel@ucw.cz
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210422140053.437B6C4338A@smtp.codeaurora.org>
Date:   Thu, 22 Apr 2021 14:00:53 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shuah Khan <skhan@linuxfoundation.org> wrote:

> ath10k_wmi_tlv_op_pull_peer_stats_info() could try to unlock RCU lock
> winthout locking it first when peer reason doesn't match the valid
> cases for this function.
> 
> Add a default case to return without unlocking.
> 
> Fixes: 09078368d516 ("ath10k: hold RCU lock when calling ieee80211_find_sta_by_ifaddr()")
> Reported-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

eaaf52e4b866 ath10k: Fix ath10k_wmi_tlv_op_pull_peer_stats_info() unlock without lock

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210406230228.31301-1-skhan@linuxfoundation.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

