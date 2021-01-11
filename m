Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B120F2F0DA1
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 09:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbhAKIG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 03:06:57 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:44944 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbhAKIG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 03:06:56 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610352396; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=q6HVAxk/hQzZS5AhQvky+aYNydoq0obr1IZUR/g5mjQ=; b=uYEy7Avwl253Ph3dLPQnsNbsNlCbMVFjOmwnzj8dSznbc4N8GENMBMgcvBJUOhzs+gpRh75C
 drn5Y3lv4eVbK4fwBV84F/KbDvqjJmmarpkm8aVjXW575VmjwqMCOd8KCeVq9lH51lySmgcH
 CNmGmtoYkAPoathTNX6FdmbBTFY=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5ffc06f24dcca12475ea0824 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 11 Jan 2021 08:06:10
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 843DBC43466; Mon, 11 Jan 2021 08:06:09 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 44E4BC433C6;
        Mon, 11 Jan 2021 08:06:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 44E4BC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] mt76: Fix queue ID variable types after mcu queue split
References: <20201229211548.1348077-1-natechancellor@gmail.com>
        <20201231100918.GA1819773@computer-5.station>
Date:   Mon, 11 Jan 2021 10:06:04 +0200
In-Reply-To: <20201231100918.GA1819773@computer-5.station> (Lorenzo Bianconi's
        message of "Thu, 31 Dec 2020 11:09:18 +0100")
Message-ID: <87k0sjlwyb.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

>> Clang warns in both mt7615 and mt7915:
>> 
>> drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:271:9: warning: implicit
>> conversion from enumeration type 'enum mt76_mcuq_id' to different
>> enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
>>                 txq = MT_MCUQ_FWDL;
>>                     ~ ^~~~~~~~~~~~
>> drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:278:9: warning: implicit
>> conversion from enumeration type 'enum mt76_mcuq_id' to different
>> enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
>>                 txq = MT_MCUQ_WA;
>>                     ~ ^~~~~~~~~~
>> drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:282:9: warning: implicit
>> conversion from enumeration type 'enum mt76_mcuq_id' to different
>> enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
>>                 txq = MT_MCUQ_WM;
>>                     ~ ^~~~~~~~~~
>> 3 warnings generated.
>> 
>> drivers/net/wireless/mediatek/mt76/mt7615/mcu.c:238:9: warning: implicit
>> conversion from enumeration type 'enum mt76_mcuq_id' to different
>> enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
>>                 qid = MT_MCUQ_WM;
>>                     ~ ^~~~~~~~~~
>> drivers/net/wireless/mediatek/mt76/mt7615/mcu.c:240:9: warning: implicit
>> conversion from enumeration type 'enum mt76_mcuq_id' to different
>> enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
>>                 qid = MT_MCUQ_FWDL;
>>                     ~ ^~~~~~~~~~~~
>> 2 warnings generated.
>> 
>> Use the proper type for the queue ID variables to fix these warnings.
>> Additionally, rename the txq variable in mt7915_mcu_send_message to be
>> more neutral like mt7615_mcu_send_message.
>> 
>> Fixes: e637763b606b ("mt76: move mcu queues to mt76_dev q_mcu array")
>> Link: https://github.com/ClangBuiltLinux/linux/issues/1229
>> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>
> Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

I see that Felix already applied this, but as this is a regression
starting from v5.11-rc1 I think it should be applied to
wireless-drivers. Felix, can you drop this from your tree so that I
could apply it to wireless-drivers?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
