Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C79F3F3BF3
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 19:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbhHURvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 13:51:15 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:58877 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbhHURvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 13:51:14 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629568234; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=ctxiQcX4qsO4AfpsVtAdyDLSagP5vHWXtonW9I/Mmjg=;
 b=ui1dPu8S9RDA+5wqB1O3BUrjcQe5snqi7GXtVjioLipqgXrZQT1HhSEjyoYAnSTuNxS1EdEe
 vvwlFmzSty9uFw2KeHPBOBqTBh0tYUwTBub4qmFrvZfm0HIqQf3nLaflRrFPCLTfG0N9FAY7
 DPLG+vj9gwL2Xws3qRRR/ilcthw=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 61213ce8f588e42af154c612 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 21 Aug 2021 17:50:32
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A0F69C43617; Sat, 21 Aug 2021 17:50:32 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C8FB1C4338F;
        Sat, 21 Aug 2021 17:50:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org C8FB1C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: make arrays static const, makes object smaller
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210819121651.7566-1-colin.king@canonical.com>
References: <20210819121651.7566-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210821175032.A0F69C43617@smtp.codeaurora.org>
Date:   Sat, 21 Aug 2021 17:50:32 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the arrays wpa_oui and wps_oui on the stack but
> instead them static const. Makes the object code smaller by 63 bytes:
> 
> Before:
>    text   data  bss     dec    hex filename
>   29453   5451   64   34968   8898 .../wireless/marvell/mwifiex/sta_ioctl.o
> 
> After:
>    text	  data  bss     dec    hex filename
>   29356	  5611   64   35031   88d7 ../wireless/marvell/mwifiex/sta_ioctl.o
> 
> (gcc version 10.3.0)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

da2c9cedc0d0 mwifiex: make arrays static const, makes object smaller

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210819121651.7566-1-colin.king@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

