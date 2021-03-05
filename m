Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9838432EC65
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 14:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhCENlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 08:41:02 -0500
Received: from z11.mailgun.us ([104.130.96.11]:53144 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhCENkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 08:40:46 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614951645; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=DmIWVPazE1ZGWAakc7cfMkZrozZnhscQVMNNwhF/Zw0=; b=SUbZLWtDloN3I+Qtkprr02tADf7NMZ9PenrnJ83W2EEp94i0TsZa+amQDJFlIQmenFWWagNz
 t3JhXShX+wmRyxPHwRUYPSH3GhlAI7Td1g4z0xruywORXfnD63OjwI8cvvTfqGaGzIguRfHT
 KbS2Yfhrh6pR4n9Gzh4aT8n9fRI=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 604234d62a5e6d1bfa490ca2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 05 Mar 2021 13:40:38
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BCE50C43464; Fri,  5 Mar 2021 13:40:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1EADCC433CA;
        Fri,  5 Mar 2021 13:40:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1EADCC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH RESEND][next] rtl8xxxu: Fix fall-through warnings for Clang
References: <20210305094850.GA141221@embeddedor>
Date:   Fri, 05 Mar 2021 15:40:33 +0200
In-Reply-To: <20210305094850.GA141221@embeddedor> (Gustavo A. R. Silva's
        message of "Fri, 5 Mar 2021 03:48:50 -0600")
Message-ID: <871rct67n2.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> writes:

> In preparation to enable -Wimplicit-fallthrough for Clang, fix
> multiple warnings by replacing /* fall through */ comments with
> the new pseudo-keyword macro fallthrough; instead of letting the
> code fall through to the next case.
>
> Notice that Clang doesn't recognize /* fall through */ comments as
> implicit fall-through markings.
>
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

It's not cool that you ignore the comments you got in [1], then after a
while mark the patch as "RESEND" and not even include a changelog why it
was resent.

[1] https://patchwork.kernel.org/project/linux-wireless/patch/d522f387b2d0dde774785c7169c1f25aa529989d.1605896060.git.gustavoars@kernel.org/

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
