Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2207B2D15FB
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgLGQcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:32:04 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:50155 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgLGQcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:32:04 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607358703; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=GxZ4jGB2NWJelasuf1KTtiksg1FVSU+tebAzvNOIINQ=;
 b=JmWhF3BesUjaJ+f8fb2ujWCCHeYXbf3NFRkDa4r0gN8VhjBsOoaagfB+GlPSsB6kb4FQ8E11
 wZvC+K0o8pMuNweRu8yyCtLpv703Jb3gI54w3kr/0OHAsqesAxA5zXf+QiAK+I2ReGPPE65a
 tYAC/RnkO4nbpYvjTccNr6xs8yQ=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5fce58d5ca03b14965e81978 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 07 Dec 2020 16:31:17
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 006FFC433C6; Mon,  7 Dec 2020 16:31:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A71F7C433ED;
        Mon,  7 Dec 2020 16:31:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A71F7C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] brmcfmac: fix compile when DEBUG is defined
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201124142440.67554-1-hby2003@163.com>
References: <20201124142440.67554-1-hby2003@163.com>
To:     hby <hby2003@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hby <hby2003@163.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201207163117.006FFC433C6@smtp.codeaurora.org>
Date:   Mon,  7 Dec 2020 16:31:16 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hby <hby2003@163.com> wrote:

> The steps:
> 1. add "#define DEBUG" in drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c line 61.
> 2. make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=../Out_Linux bcm2835_defconfig
> 3. make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=../Out_Linux/ zImage modules dtbs -j8
> 
> Then, it will fail, the compile log described below:
> 
> Kernel: arch/arm/boot/zImage is ready
> MODPOST Module.symvers
> ERROR: modpost: "brcmf_debugfs_add_entry" [drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko] undefined!
> ERROR: modpost: "brcmf_debugfs_get_devdir" [drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko] undefined!
> ERROR: modpost: "__brcmf_dbg" [drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko] undefined!
> scripts/Makefile.modpost:111: recipe for target 'Module.symvers' failed
> make[2]: *** [Module.symvers] Error 1
> make[2]: *** Deleting file 'Module.symvers'
> Makefile:1390: recipe for target 'modules' failed
> make[1]: *** [modules] Error 2
> make[1]: Leaving directory '/home/hby/gitee/linux_origin/Out_Linux'
> Makefile:185: recipe for target '__sub-make' failed
> make: *** [__sub-make] Error 2
> 
> Signed-off-by: hby <hby2003@163.com>

I checked and brcmd80211/Makefile has:

subdir-ccflags-$(CONFIG_BRCMDBG)	+= -DDEBUG

I don't understand why brcm80211 uses DEBUG flag like that, but I guess there's
a reason. I think that either _all_ DEBUG uses should be removed from the
driver, or you shouldn't add "#define DEBUG" on your own to any of the files.
So this patch is not the best solution.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201124142440.67554-1-hby2003@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

