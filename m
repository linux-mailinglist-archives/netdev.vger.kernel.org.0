Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10F741A94E
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 09:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239181AbhI1HHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 03:07:22 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:53211 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239078AbhI1HHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 03:07:14 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632812731; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=GdbR31SuXra+bALRWxjxzcr+dhVqDYEGV27jUVNwc80=;
 b=BykueYJEEF+KseS16LunVPu6NS0rSEqMm7HHDL+d/pEMuMB1qqkgnPheDPdOj3xRxoFZaAna
 UwXxvGBkLbPcquG4UHeksoaXfrwkUQUMCH/g0l+YRqBzrAtxrbUIuO0hr55bwS9mbaRaIGZV
 UUXghLT5an0Ur61gFz/qxTS3b8U=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 6152beb91abbf21d34d297da (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 28 Sep 2021 07:05:29
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 12CE9C4360D; Tue, 28 Sep 2021 07:05:29 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E239AC4338F;
        Tue, 28 Sep 2021 07:05:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org E239AC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] iwlwifi: pcie: add configuration of a Wi-Fi adapter on
 Dell XPS 15
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210924122154.2376577-1-vladimir.zapolskiy@linaro.org>
References: <20210924122154.2376577-1-vladimir.zapolskiy@linaro.org>
To:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Julien Wajsberg <felash@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210928070529.12CE9C4360D@smtp.codeaurora.org>
Date:   Tue, 28 Sep 2021 07:05:29 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org> wrote:

> There is a Killer AX1650 2x2 Wi-Fi 6 and Bluetooth 5.1 wireless adapter
> found on Dell XPS 15 (9510) laptop, its configuration was present on
> Linux v5.7, however accidentally it has been removed from the list of
> supported devices, let's add it back.
> 
> The problem is manifested on driver initialization:
> 
>   Intel(R) Wireless WiFi driver for Linux
>   iwlwifi 0000:00:14.3: enabling device (0000 -> 0002)
>   iwlwifi: No config found for PCI dev 43f0/1651, rev=0x354, rfid=0x10a100
>   iwlwifi: probe of 0000:00:14.3 failed with error -22
> 
> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=213939
> Fixes: 3f910a25839b ("iwlwifi: pcie: convert all AX101 devices to the device tables")
> Cc: Julien Wajsberg <felash@gmail.com>
> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
> Acked-by: Luca Coelho <luca@coelho.fi>

Patch applied to wireless-drivers.git, thanks.

fe5c735d0d47 iwlwifi: pcie: add configuration of a Wi-Fi adapter on Dell XPS 15

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210924122154.2376577-1-vladimir.zapolskiy@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

