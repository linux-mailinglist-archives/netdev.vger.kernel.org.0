Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0133E15F0
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 15:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241261AbhHENon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 09:44:43 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:61016 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239222AbhHENom (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 09:44:42 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628171069; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=UDqqULtEilcoytZXS/txGxlVIVFuUcqpiXHWmqfAO/E=; b=hynM6R9MEB9mKwo/gtJY/gdKh2DvE3awN/Ft29y/6F58foq+nSUVGVke0XpVuJ4tRAkbCnpy
 b2h+7FJIv8ndtWwqttzDHEMS9P3sNfLuDmy83BX6HF9VUAlidF0IFq/grVqUhVENQmMZZQna
 JCcLdhwcg8uIvzdJpIpSbj+XxAY=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 610beb3ab4dfc4b0ef2dfff3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 05 Aug 2021 13:44:26
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 64548C43144; Thu,  5 Aug 2021 13:44:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9B60DC4338A;
        Thu,  5 Aug 2021 13:44:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9B60DC4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Liwei Song <liwei.song@windriver.com>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        David <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: select MAC80211_LEDS conditionally
References: <20210624100823.854-1-liwei.song@windriver.com>
        <87sg17ilz2.fsf@codeaurora.org>
        <92d293b4-0ef1-6239-4b91-4af420786980@windriver.com>
Date:   Thu, 05 Aug 2021 16:44:17 +0300
In-Reply-To: <92d293b4-0ef1-6239-4b91-4af420786980@windriver.com> (Liwei
        Song's message of "Thu, 24 Jun 2021 19:06:39 +0800")
Message-ID: <87fsvoc8ge.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liwei Song <liwei.song@windriver.com> writes:

> On 6/24/21 18:41, Kalle Valo wrote:
>> Liwei Song <liwei.song@windriver.com> writes:
>> 
>>> MAC80211_LEDS depends on LEDS_CLASS=y or LEDS_CLASS=MAC80211,
>>> add condition to enable it in iwlwifi/Kconfig to avoid below
>>> compile warning when LEDS_CLASS was set to m:
>>>
>>> WARNING: unmet direct dependencies detected for MAC80211_LEDS
>>>   Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=y] &&
>>> (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=MAC80211 [=y])
>>>   Selected by [m]:
>>>   - IWLWIFI_LEDS [=y] && NETDEVICES [=y] && WLAN [=y] &&
>>> WLAN_VENDOR_INTEL [=y] && IWLWIFI [=m] && (LEDS_CLASS [=m]=y ||
>>> LEDS_CLASS [=m]=IWLWIFI [=m]) && (IWLMVM [=m] || IWLDVM [=m])
>>>
>>> Signed-off-by: Liwei Song <liwei.song@windriver.com>
>> 
>> Is this is a new regression or an old bug? What commit caused this?
>
> It should be exist when the below commit change the dependency of MAC80211_LEDS
> to fix some build error:
>
> commit b64acb28da8394485f0762e657470c9fc33aca4d
> Author: Arnd Bergmann <arnd@arndb.de>
> Date:   Mon Jan 25 12:36:42 2021 +0100
>
>     ath9k: fix build error with LEDS_CLASS=m

Thanks, it seems LEDS_CLASS is a constant source of problems for
wireless drivers :/

Luca, what should we do? We cannot have compile errors in the tree.

I assigned this patch to me on patchwork.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
