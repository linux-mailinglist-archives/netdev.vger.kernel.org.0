Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3190C4542E6
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 09:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbhKQIuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 03:50:40 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:19797 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234578AbhKQIuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 03:50:39 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1637138861; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=r0//JU9f3mo3nPzQjL6r+ddUQ6S+5xMlwRZ4L0YQ4mQ=;
 b=cKygpZPGDJikcD2kJnn+rfyvh2dzlNX2Hat8Uees4IDjvYwFM70uCy+Pn2irUWYR0EDWsnVe
 MVC092OKkQJQN4Xilptyaf2KzzK+1vnoqi0utkuoNJsAjypXKEKdzh9Hp0/Sb3OQEt3iz35F
 zdbU4wCd53WiltysiGjbES3dsyc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 6194c1ac5bbbed1f706e2c36 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 17 Nov 2021 08:47:40
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6EADDC43617; Wed, 17 Nov 2021 08:47:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 22975C4338F;
        Wed, 17 Nov 2021 08:47:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 22975C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v1] ath9k: fix intr_txqs setting
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211116220720.30145-1-ps.report@gmx.net>
References: <20211116220720.30145-1-ps.report@gmx.net>
To:     Peter Seiderer <ps.report@gmx.net>
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163713885373.10263.4223864617658431026.kvalo@codeaurora.org>
Date:   Wed, 17 Nov 2021 08:47:40 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peter Seiderer <ps.report@gmx.net> wrote:

> The struct ath_hw member intr_txqs is never reset/assigned outside
> of ath9k_hw_init_queues() and with the used bitwise-or in the interrupt
> handling ar9002_hw_get_isr() accumulates all ever set interrupt flags.
> 
> Fix this by using a pure assign instead of bitwise-or for the
> first line (note: intr_txqs is only evaluated in case ATH9K_INT_TX bit
> is set).
> 
> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

How did you test this? I'm getting way too many ath9k patches which have not
been tested on a real device.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211116220720.30145-1-ps.report@gmx.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

