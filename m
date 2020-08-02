Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE764235814
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 17:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHBPTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 11:19:38 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:57271 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgHBPTh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 11:19:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596381577; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=1ceprmMKUngVAI6NwlVtOnpRsGz6GuKVyY+WV80AFIs=;
 b=e9AChbeDLcKMAC+cCeHpQoIRm5s/WhYthI0CfnQITv2fGdd30wZAGAFt+U16Ar0LcKUrcVpE
 Y7np0Eid7QecW97jP9g/x2kYRsk0BoC23qtRGNRT2ReM6pUv21lY/bjk3lYX4oMkhTtfbdRU
 sf0SDnClLMGhORtJQ7tLeJOeKXw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5f26d97e2c24b37bbe11a8d6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 02 Aug 2020 15:19:26
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 81F7EC433C9; Sun,  2 Aug 2020 15:19:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4B677C433C6;
        Sun,  2 Aug 2020 15:19:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4B677C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] ipw2100: Use GFP_KERNEL instead of GFP_ATOMIC in some
 memory allocation
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200722101701.26126-1-christophe.jaillet@wanadoo.fr>
References: <20200722101701.26126-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     stas.yakovlev@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200802151925.81F7EC433C9@smtp.codeaurora.org>
Date:   Sun,  2 Aug 2020 15:19:25 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> The call chain is:
>    ipw2100_pci_init_one            (the probe function)
>      --> ipw2100_queues_allocate
>        --> ipw2100_tx_allocate
> 
> No lock is taken in the between.
> So it is safe to use GFP_KERNEL in 'ipw2100_tx_allocate()'.
> 
> BTW, 'ipw2100_queues_allocate()' also calls 'ipw2100_msg_allocate()' which
> already allocates some memory using GFP_KERNEL.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

2 patches applied to wireless-drivers-next.git, thanks.

9130559cf8db ipw2100: Use GFP_KERNEL instead of GFP_ATOMIC in some memory allocation
e52525c0c320 ipw2x00: switch from 'pci_' to 'dma_' API

-- 
https://patchwork.kernel.org/patch/11678101/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

