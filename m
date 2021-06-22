Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF363B0918
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 17:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbhFVPcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 11:32:22 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:11757 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbhFVPby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 11:31:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624375778; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=z7NDcu8cPjZwCK7QqOyl43gPgmkxXEZyQgRW5JNHxRI=;
 b=fmaSKcE6wKs39Cpi5ZOx6h3cipBCvlYLmfUK6K97tuXsdLm8QCaugdJWwqf3I+8oX+qPbqkH
 R6D5T5+tTzoOes0oiJ8rmZEhHcdkZCHD79vPmMp/s2ZzPRMg3IxxHj8V8Qyf7877lJCaJKcJ
 73TapaI6CMyeggdEh4HJ1LnNvww=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 60d201a31200320241f5756e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Jun 2021 15:28:35
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AAC31C43148; Tue, 22 Jun 2021 15:28:34 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E4206C43144;
        Tue, 22 Jun 2021 15:28:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E4206C43144
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wcn36xx: Avoid memset() beyond end of struct field
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210617171058.3410494-1-keescook@chromium.org>
References: <20210617171058.3410494-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210622152834.AAC31C43148@smtp.codeaurora.org>
Date:   Tue, 22 Jun 2021 15:28:34 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring array fields.
> 
> Instead of writing past the end of the header to reach the rest of
> the body, replace the redundant function with existing macro to wipe
> struct contents and set field values. Additionally adjusts macro to add
> missing parens.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

d3a1a18ab034 wcn36xx: Avoid memset() beyond end of struct field

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210617171058.3410494-1-keescook@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

