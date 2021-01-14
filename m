Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FD52F6654
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 17:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbhANQtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 11:49:52 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:36659 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbhANQtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 11:49:52 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610642968; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=pTOhOFjKTSVZKN1D0SJ1Pg5lWOEdKXufF+sYmOfnZOw=;
 b=uK7m3LlTMNeYZcTmuS+5lJm56cD5bsc6Pbkwn6rrSg6veFCosQGXkBP/4ZVHiNs0xxbE+YRC
 MZTVw86QYph8A/pOGHXalFOOPKx1RZ0GCf/+9JPLyEV+JuUPtHhsVJMhaDqmH9rTDGQaO7xw
 lUNBV9bsGDuHcBeZcx2UH4TTOgo=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 600075ebc88af06107ced53d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 14 Jan 2021 16:48:43
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BE983C43461; Thu, 14 Jan 2021 16:48:42 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D370BC433C6;
        Thu, 14 Jan 2021 16:48:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D370BC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt76: Fix queue ID variable types after mcu queue split
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201229211548.1348077-1-natechancellor@gmail.com>
References: <20201229211548.1348077-1-natechancellor@gmail.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210114164842.BE983C43461@smtp.codeaurora.org>
Date:   Thu, 14 Jan 2021 16:48:42 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> wrote:

> Clang warns in both mt7615 and mt7915:
> 
> drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:271:9: warning: implicit
> conversion from enumeration type 'enum mt76_mcuq_id' to different
> enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
>                 txq = MT_MCUQ_FWDL;
>                     ~ ^~~~~~~~~~~~
> drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:278:9: warning: implicit
> conversion from enumeration type 'enum mt76_mcuq_id' to different
> enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
>                 txq = MT_MCUQ_WA;
>                     ~ ^~~~~~~~~~
> drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:282:9: warning: implicit
> conversion from enumeration type 'enum mt76_mcuq_id' to different
> enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
>                 txq = MT_MCUQ_WM;
>                     ~ ^~~~~~~~~~
> 3 warnings generated.
> 
> drivers/net/wireless/mediatek/mt76/mt7615/mcu.c:238:9: warning: implicit
> conversion from enumeration type 'enum mt76_mcuq_id' to different
> enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
>                 qid = MT_MCUQ_WM;
>                     ~ ^~~~~~~~~~
> drivers/net/wireless/mediatek/mt76/mt7615/mcu.c:240:9: warning: implicit
> conversion from enumeration type 'enum mt76_mcuq_id' to different
> enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
>                 qid = MT_MCUQ_FWDL;
>                     ~ ^~~~~~~~~~~~
> 2 warnings generated.
> 
> Use the proper type for the queue ID variables to fix these warnings.
> Additionally, rename the txq variable in mt7915_mcu_send_message to be
> more neutral like mt7615_mcu_send_message.
> 
> Fixes: e637763b606b ("mt76: move mcu queues to mt76_dev q_mcu array")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1229
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

Patch applied to wireless-drivers.git, thanks.

b7c568752ef3 mt76: Fix queue ID variable types after mcu queue split

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201229211548.1348077-1-natechancellor@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

