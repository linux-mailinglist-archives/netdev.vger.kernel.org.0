Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415782545DD
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 15:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgH0NZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 09:25:05 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:34318 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727103AbgH0NXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 09:23:21 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598534601; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=OEnpR1YGQbng0mx9A15xqaUuwikZzc9dBMrRdkV04tU=;
 b=K3wfB20cIFXENQl46Bley2M7Gpypj73IAHlhREWC/TJNgJyyntBYu4RWOJA3kVcmVpLHGhzY
 r9z9UZUqj+jQ33g1rnuKlY8n/GeHsa8QnG7C2Wb+MKL/N5C4v2wCzl0qzmrM+w1avjD1phMz
 nVzscOLFfMV+r/E/GX7quSyIf9E=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5f47b3c891574590bf6cd432 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 13:23:20
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B70A9C433AD; Thu, 27 Aug 2020 13:23:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2A790C433CA;
        Thu, 27 Aug 2020 13:23:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2A790C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [05/16] atmel: convert tasklets to use new tasklet_setup() API
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200817090637.26887-6-allen.cryptic@gmail.com>
References: <20200817090637.26887-6-allen.cryptic@gmail.com>
To:     Allen Pais <allen.cryptic@gmail.com>
Cc:     kuba@kernel.org, jirislaby@kernel.org, mickflemm@gmail.com,
        mcgrof@kernel.org, chunkeey@googlemail.com,
        Larry.Finger@lwfinger.net, stas.yakovlev@gmail.com,
        helmut.schaa@googlemail.com, pkshih@realtek.com,
        yhchuang@realtek.com, dsd@gentoo.org, kune@deine-taler.de,
        keescook@chromium.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, b43-dev@lists.infradead.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200827132320.B70A9C433AD@smtp.codeaurora.org>
Date:   Thu, 27 Aug 2020 13:23:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allen Pais <allen.cryptic@gmail.com> wrote:

> From: Allen Pais <allen.lkml@gmail.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly
> and remove .data field.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>

11 patches applied to wireless-drivers-next.git, thanks.

a36f50e5b937 atmel: convert tasklets to use new tasklet_setup() API
fc6722301428 b43legacy: convert tasklets to use new tasklet_setup() API
427a06beb072 brcmsmac: convert tasklets to use new tasklet_setup() API
ae6cf59f80f7 ipw2x00: convert tasklets to use new tasklet_setup() API
b81b9d372ac8 iwlegacy: convert tasklets to use new tasklet_setup() API
7433c9690318 intersil: convert tasklets to use new tasklet_setup() API
51c41aa93ef5 mwl8k: convert tasklets to use new tasklet_setup() API
aff8e8d02ec2 qtnfmac: convert tasklets to use new tasklet_setup() API
a0d6ea9b6e1c rt2x00: convert tasklets to use new tasklet_setup() API
d3ccc14dfe95 rtlwifi/rtw88: convert tasklets to use new tasklet_setup() API
26721b02466e zd1211rw: convert tasklets to use new tasklet_setup() API

-- 
https://patchwork.kernel.org/patch/11717451/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

