Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD782F34A2
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391959AbhALPta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:49:30 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:52042 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391940AbhALPta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:49:30 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610466544; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=dQsFYL2Fqo/Ms9AYBDcr2klxwo7e9LsBdIxT+fqGyGA=; b=dsGDCHhBWxtqKsmZXpOxa7eb0RsxzqlDMfGKzzRzaHrS+SSV3es2B5vubSJA5QM4zFDpNpUq
 muizAt0lazG6tGQnvTFTXDcWJGwjgWN3QoPta3ES0hfIvcdy9QNSJan+io1HzdNT3hgwOUWy
 8IrD4xzkgvpPRABwY6Ph5lxa7BY=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5ffdc4ec2a47972bcc670e44 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 12 Jan 2021 15:49:00
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 63A32C433CA; Tue, 12 Jan 2021 15:49:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A213BC43466;
        Tue, 12 Jan 2021 15:48:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A213BC43466
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 1/2] iwlwifi: dbg: Don't touch the tlv data
References: <20210112132449.22243-1-tiwai@suse.de>
        <20210112132449.22243-2-tiwai@suse.de>
Date:   Tue, 12 Jan 2021 17:48:56 +0200
In-Reply-To: <20210112132449.22243-2-tiwai@suse.de> (Takashi Iwai's message of
        "Tue, 12 Jan 2021 14:24:48 +0100")
Message-ID: <87turmrw9j.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Takashi Iwai <tiwai@suse.de> writes:

> The commit ba8f6f4ae254 ("iwlwifi: dbg: add dumping special device
> memory") added a termination of name string just to be sure, and this
> seems causing a regression, a GPF triggered at firmware loading.
> Basically we shouldn't modify the firmware data that may be provided
> as read-only.
>
> This patch drops the code that caused the regression and keep the tlv
> data as is.
>
> Fixes: ba8f6f4ae254 ("iwlwifi: dbg: add dumping special device memory")
> BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1180344
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=210733
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

I'm planning to queue this to v5.11. Should I add cc stable?

Luca, can I have your ack?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
