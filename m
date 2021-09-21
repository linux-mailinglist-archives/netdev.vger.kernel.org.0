Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E804130AF
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 11:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbhIUJWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 05:22:52 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:52381 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbhIUJWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 05:22:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632216076; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=OMY3JiSinJsecAd6FsgSgZC/tu3ABFVOkx6GKyh9kOA=; b=NKafI2ciPcpEnsbVJSD5j0sx6O2DZWeeQvAXWhUHAKg62l04fFpROu3rmWaRJ690FSwn+S1h
 j2h2qRt0SEXByCuiuklblSgVqwHx5EJ86reKBzJ8Zs4h0YkOx7CrUJt+nKHs5nJ+VSST9v3s
 o4PE/2uwS6Nfr+bnS0xDaznPwhU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 6149a3d7507800c8804db641 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 21 Sep 2021 09:20:23
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 62615C4361B; Tue, 21 Sep 2021 09:20:22 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D5C3BC4338F;
        Tue, 21 Sep 2021 09:20:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org D5C3BC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Shawn Guo <shawn.guo@linaro.org>
Cc:     Soeren Moch <smoch@web.de>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-rockchip\@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>
Subject: Re: [BUG] Re: [PATCH] brcmfmac: use ISO3166 country code and 0 rev as fallback
References: <20210425110200.3050-1-shawn.guo@linaro.org>
        <cb7ac252-3356-8ef7-fcf9-eb017f5f161f@web.de>
        <20210908010057.GB25255@dragon>
        <100f5bef-936c-43f1-9b3e-a477a0640d84@web.de>
        <20210909022033.GC25255@dragon>
        <56e9a81a-4e05-cf5e-a8df-782ac75fdbe6@web.de>
        <20210912015137.GD25255@dragon>
Date:   Tue, 21 Sep 2021 12:20:13 +0300
In-Reply-To: <20210912015137.GD25255@dragon> (Shawn Guo's message of "Sun, 12
        Sep 2021 09:51:38 +0800")
Message-ID: <87pmt2uvxu.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shawn Guo <shawn.guo@linaro.org> writes:

>> Is this not the usual DT policy, that missing optional properties should
>> not prevent a device to work, that old dtbs should still work when new
>> properties are added?
>> 
>> I'm not sure what's the best way forward. A plain revert of this patch
>> would at least bring back wifi support for RockPro64 devices with
>> existing dtbs. Maybe someone else has a better proposal how to proceed.
>
> Go ahead to revert if we do not hear a better solution, I would say.

Yes, please do send a revert. And remember to explain the regression in
the commit log.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
