Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EAE257E06
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgHaPwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:52:04 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:10855 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727799AbgHaPwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:52:02 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598889121; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=UiCtEuXB1/ghowuh3jHXLuUWPllC4130UQOUkOzWhjg=;
 b=AQjMHMN5kLIQv0ozvoWwyATpU2HZbTvAatiOrGUYeIN59xgzHiPUS6+27Un1ztfsbeY2Vgar
 I8v9vSrPPds+fVJ8eBgmi6h0Rq7KL9qZcUCRXQMp2SQFGTgJ80am1g+RbYBa79qRbAocGIXv
 gpx4xgWPYxENRIjhlru1Npc6S6I=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5f4d1c979bdf68cc0373e20d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 31 Aug 2020 15:51:51
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0DCB5C4339C; Mon, 31 Aug 2020 15:51:51 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 22DADC433CA;
        Mon, 31 Aug 2020 15:51:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 22DADC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 16/28] wireless: marvell: mwifiex: init: Move
 'tos_to_tid_inv'
 to where it's used
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200819072402.3085022-17-lee.jones@linaro.org>
References: <20200819072402.3085022-17-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200831155151.0DCB5C4339C@smtp.codeaurora.org>
Date:   Mon, 31 Aug 2020 15:51:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> 'tos_to_tid_inv' is only used in 2 of 17 files it's current being
> included into.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>  In file included from drivers/net/wireless/marvell/mwifiex/main.c:23:
>  In file included from drivers/net/wireless/marvell/mwifiex/cmdevt.c:26:
>  In file included from drivers/net/wireless/marvell/mwifiex/util.c:25:
>  In file included from drivers/net/wireless/marvell/mwifiex/txrx.c:25:
>  In file included from drivers/net/wireless/marvell/mwifiex/11n.c:25:
>  In file included from drivers/net/wireless/marvell/mwifiex/wmm.c:25:
>  In file included from drivers/net/wireless/marvell/mwifiex/11n_aggr.c:25:
>  In file included from drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c:25:
>  In file included from drivers/net/wireless/marvell/mwifiex/join.c:25:
>  In file included from drivers/net/wireless/marvell/mwifiex/sta_cmd.c:25:
>  In file included from drivers/net/wireless/marvell/mwifiex/sta_ioctl.c:25:
>  In file included from drivers/net/wireless/marvell/mwifiex/sta_event.c:25:
>  In file included from drivers/net/wireless/marvell/mwifiex/uap_txrx.c:23:
>  In file included from drivers/net/wireless/marvell/mwifiex/sdio.c:27:
>  In file included from drivers/net/wireless/marvell/mwifiex/sta_tx.c:25:
>  drivers/net/wireless/marvell/mwifiex/wmm.h:41:17: warning: ‘tos_to_tid_inv’ defined but not used [-Wunused-const-variable=]
>  41 | static const u8 tos_to_tid_inv[] = {
> 
>  NB: Snipped for brevity
> 
> Cc: Amitkumar Karwar <amitkarwar@gmail.com>
> Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
> Cc: Xinming Hu <huxinming820@gmail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

The patch creates two duplicate arrays, this makes it worse than it was
before.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/11723177/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

