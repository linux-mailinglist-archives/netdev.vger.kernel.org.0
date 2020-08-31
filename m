Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAF4257C2D
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgHaPTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:19:48 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:56631 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728109AbgHaPTr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 11:19:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598887187; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=RWOS40LHxnB4cN9/rrpLElSswicob5Pl/GeeENE0Pmw=;
 b=INi3MJIaYr+BVxIeSmMmVcEmjGMjPy+mDVKtW0VGiAwhiYCC/Extc7L0jvgdQ+Owe7r9UOLY
 4s++kpth7CSGShuPI1SYzQbSwMN7qHAYoM0lMpfy0V0gRXZxSbJHObsuWqNj70vBhkQICXbo
 tT+wROPrl6dpr5WKz9xCBVaZSn0=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f4d150eba408b30cedd9718 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 31 Aug 2020 15:19:42
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5D233C43387; Mon, 31 Aug 2020 15:19:41 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0AFC7C433C6;
        Mon, 31 Aug 2020 15:19:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0AFC7C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 08/30] net: wireless: ath: carl9170: Convert
 'ar9170_qmap'
 to inline function
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200827093351.GA1627017@dell>
References: <20200827093351.GA1627017@dell>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200831151941.5D233C43387@smtp.codeaurora.org>
Date:   Mon, 31 Aug 2020 15:19:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> 'ar9170_qmap' is used in some source files which include carl9170.h,
> but not all of them.  A 'defined but not used' warning is thrown when
> compiling the ones which do not use it.
> 
> Fixes the following W=1 kernel build warning(s)
> 
>  from drivers/net/wireless/ath/carl9170/carl9170.h:57,
>  In file included from drivers/net/wireless/ath/carl9170/carl9170.h:57,
>  drivers/net/wireless/ath/carl9170/carl9170.h:71:17: warning: ‘ar9170_qmap’ defined but not used [-Wunused-const-variable=]
> 
>  NB: Snipped - lots of these repeat
> 
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

859228a3ae82 carl9170: Convert 'ar9170_qmap' to inline function

-- 
https://patchwork.kernel.org/patch/11740469/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

