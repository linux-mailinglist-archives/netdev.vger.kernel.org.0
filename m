Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7887A3B2C99
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 12:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbhFXKnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 06:43:37 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:53201 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbhFXKne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 06:43:34 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624531275; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=/2Zk5R1tA/Y+vHgERNReTA4Bg9VjltrQTBXdKggxMXc=; b=Pc/4up9ZV5NYZB1QpDymLhHTQlnuSohQJ5uiyLzNKvBI7w6VDtaEX2woqzZRSUVTUeYIww9x
 ODGefMN0Z8nU/ZjXdvPT1hp+SXFrHfg7w1+/5IqucEDTSkSmQYOP6kdgON185wALlXuDWSJJ
 0Md+jxl2/UWhYKl+ysyt/34k19I=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 60d46149ec0b18a745e9d3bc (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Jun 2021 10:41:13
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2BA47C4338A; Thu, 24 Jun 2021 10:41:13 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 00543C433F1;
        Thu, 24 Jun 2021 10:41:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 00543C433F1
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
Date:   Thu, 24 Jun 2021 13:41:05 +0300
In-Reply-To: <20210624100823.854-1-liwei.song@windriver.com> (Liwei Song's
        message of "Thu, 24 Jun 2021 18:08:23 +0800")
Message-ID: <87sg17ilz2.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liwei Song <liwei.song@windriver.com> writes:

> MAC80211_LEDS depends on LEDS_CLASS=y or LEDS_CLASS=MAC80211,
> add condition to enable it in iwlwifi/Kconfig to avoid below
> compile warning when LEDS_CLASS was set to m:
>
> WARNING: unmet direct dependencies detected for MAC80211_LEDS
>   Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=y] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=MAC80211 [=y])
>   Selected by [m]:
>   - IWLWIFI_LEDS [=y] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_INTEL [=y] && IWLWIFI [=m] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=IWLWIFI [=m]) && (IWLMVM [=m] || IWLDVM [=m])
>
> Signed-off-by: Liwei Song <liwei.song@windriver.com>

Is this is a new regression or an old bug? What commit caused this?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
