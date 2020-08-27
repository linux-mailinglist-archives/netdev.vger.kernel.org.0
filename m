Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625192545C7
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 15:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgH0NSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 09:18:38 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:51085 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727769AbgH0NRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 09:17:17 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598534236; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=qjM5TvevdF5BS4WxhbMS1yvGeMjUtBBsveQHXqbPgr0=;
 b=IT+rTL9uKfyxHm4xYZom/bgNKNKd42hY++DPiUNeP4EaTKwyz7O57jj1CzJ45kNSk8G3TaDq
 uLl6TL0Q4EZvghqifWbdvjXzxP29oIIjD5ueIZjR3dpDK7epa3YxBdhCuppQTeL/FjYXWbfy
 UzanGhxgSJFva1mgymS11keqpQU=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f47b23615988fabe06c04de (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 13:16:38
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5DCFFC433CA; Thu, 27 Aug 2020 13:16:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 11869C433CA;
        Thu, 27 Aug 2020 13:16:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 11869C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [net] mwifiex: Increase AES key storage size to 256 bits
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200825153829.38043-1-luzmaximilian@gmail.com>
References: <20200825153829.38043-1-luzmaximilian@gmail.com>
To:     Maximilian Luz <luzmaximilian@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input)
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Kaloyan Nikolov <konik98@gmail.com>
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)Amitkumar Karwar <amitkarwar@gmail.com>
                                                                     ^-missing end of address
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200827131638.5DCFFC433CA@smtp.codeaurora.org>
Date:   Thu, 27 Aug 2020 13:16:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maximilian Luz <luzmaximilian@gmail.com> wrote:

> Following commit e18696786548 ("mwifiex: Prevent memory corruption
> handling keys") the mwifiex driver fails to authenticate with certain
> networks, specifically networks with 256 bit keys, and repeatedly asks
> for the password. The kernel log repeats the following lines (id and
> bssid redacted):
> 
>     mwifiex_pcie 0000:01:00.0: info: trying to associate to '<id>' bssid <bssid>
>     mwifiex_pcie 0000:01:00.0: info: associated to bssid <bssid> successfully
>     mwifiex_pcie 0000:01:00.0: crypto keys added
>     mwifiex_pcie 0000:01:00.0: info: successfully disconnected from <bssid>: reason code 3
> 
> Tracking down this problem lead to the overflow check introduced by the
> aforementioned commit into mwifiex_ret_802_11_key_material_v2(). This
> check fails on networks with 256 bit keys due to the current storage
> size for AES keys in struct mwifiex_aes_param being only 128 bit.
> 
> To fix this issue, increase the storage size for AES keys to 256 bit.
> 
> Fixes: e18696786548 ("mwifiex: Prevent memory corruption handling keys")
> Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
> Reported-by: Kaloyan Nikolov <konik98@gmail.com>
> Tested-by: Kaloyan Nikolov <konik98@gmail.com>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Tested-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers.git, thanks.

4afc850e2e9e mwifiex: Increase AES key storage size to 256 bits

-- 
https://patchwork.kernel.org/patch/11735929/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

