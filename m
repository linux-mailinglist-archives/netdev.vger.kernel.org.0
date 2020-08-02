Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E0E2357D3
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 17:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgHBO6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 10:58:47 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:17966 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726744AbgHBO6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 10:58:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596380326; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=sJQnBpSFWLzIDnuY7Td1t6HUh2LChvYz8XgiglJnkfs=;
 b=QF0Kh7z4gW6Ca5X63n/WjKD9AtZQRBL/JuB9YC2OEPhT13n+Sb2fKKL8xLKgmiq1XmnkdOyb
 65pMJGNy69vWhTLA95f7HrIjSwL2C4uMIkaHX96tke1uXsQ0K06gxUQE7SPU6Ta+dNtN9/NX
 adeafKoKSj27iaOxVTBPfWF0G9Y=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f26d4a5ba6d142d1c2e0b44 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 02 Aug 2020 14:58:45
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BFC16C433CB; Sun,  2 Aug 2020 14:58:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 15F1DC433C6;
        Sun,  2 Aug 2020 14:58:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 15F1DC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH for v5.9] prism54: Replace HTTP links with HTTPS ones
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200719121224.58581-1-grandmaster@al2klimov.de>
References: <20200719121224.58581-1-grandmaster@al2klimov.de>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     mcgrof@kernel.org, davem@davemloft.net, kuba@kernel.org,
        gustavoars@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200802145845.BFC16C433CB@smtp.codeaurora.org>
Date:   Sun,  2 Aug 2020 14:58:45 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Alexander A. Klimov" <grandmaster@al2klimov.de> wrote:

> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
> 
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
> 	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>             If both the HTTP and HTTPS versions
>             return 200 OK and serve the same content:
>               Replace HTTP with HTTPS.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>

Patch applied to wireless-drivers-next.git, thanks.

87b589a19901 prism54: Replace HTTP links with HTTPS ones

-- 
https://patchwork.kernel.org/patch/11672435/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

