Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388E53E2AB4
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 14:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343734AbhHFMfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 08:35:40 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:33262 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343724AbhHFMfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 08:35:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628253324; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=N2y4oRCNfmsOR5AcLj7KTqZExbR4TqZaeaiHeBAWq7o=; b=S0MIYlKVBti4dThUFgq/St1y19X91dbIPDdqqYO6c6m8K1Pz90t811ScuU8+UhenB+Xinkb/
 XdWHCAmHj3m229b+CU0XhDDyAoV2I+dLQ+7jNCl1sn+a7mITy1UdHnXetByoGP1LXCGD+IEs
 K+JmHkN5gweB3qcuZikNP5N2PxI=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 610d2c815c73bba6fbbc3544 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 06 Aug 2021 12:35:13
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 81AB6C43145; Fri,  6 Aug 2021 12:35:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D3A5AC433F1;
        Fri,  6 Aug 2021 12:35:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D3A5AC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] brcmfmac: firmware: Fix uninitialized variable ret
References: <20210803150904.80119-1-colin.king@canonical.com>
        <CACRpkdZ5u-C8uH2pCr1689v_ndyzqevDDksXvtPYv=FfD=x_xg@mail.gmail.com>
        <875ywkc80d.fsf@codeaurora.org>
        <96709926-30c6-457e-3e80-eb7ad6e9d778@broadcom.com>
        <b2034ac5-0080-a2fb-32ef-61ad50dfd248@canonical.com>
Date:   Fri, 06 Aug 2021 15:35:05 +0300
In-Reply-To: <b2034ac5-0080-a2fb-32ef-61ad50dfd248@canonical.com> (Colin Ian
        King's message of "Fri, 6 Aug 2021 12:28:29 +0100")
Message-ID: <87eeb6bvk6.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.king@canonical.com> writes:

> On 06/08/2021 12:23, Arend van Spriel wrote:
>> On 05-08-2021 15:53, Kalle Valo wrote:
>>> Linus Walleij <linus.walleij@linaro.org> writes:
>>>
>>>> On Tue, Aug 3, 2021 at 5:09 PM Colin King <colin.king@canonical.com>
>>>> wrote:
>>>>
>>>>> From: Colin Ian King <colin.king@canonical.com>
>>>>>
>>>>> Currently the variable ret is uninitialized and is only set if
>>>>> the pointer alt_path is non-null. Fix this by ininitializing ret
>>>>> to zero.
>>>>>
>>>>> Addresses-Coverity: ("Uninitialized scalar variable")
>>>>> Fixes: 5ff013914c62 ("brcmfmac: firmware: Allow per-board firmware
>>>>> binaries")
>>>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>>>
>>>> Nice catch!
>>>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>>>
>>> I assume this will be fixed by Linus' patch "brcmfmac: firmware: Fix
>>> firmware loading" and I should drop Colin's patch, correct?
>> 
>> That would be my assumption as well, but not sure when he will submit
>> another revision of it. You probably know what to do ;-)
>
> I'd prefer my patch to be dropped in preference to Linus' fix.

Ok, I'll then drop Colin's patch.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
