Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45D32C0F83
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 17:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731770AbgKWP5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:57:09 -0500
Received: from z5.mailgun.us ([104.130.96.5]:33740 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730718AbgKWP4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 10:56:20 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606146980; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=peXIXBUMti9vrUsUY2tlDaUe3oM+23n8MgT8+LCvaAE=; b=V13zddUsn+vfJkxaW4nRUaYXMjbyC/ZLWiWWrKymLLu2mDF4qXVGNnmW7hcKoiFCNtVnOyTE
 7cgyZ1d+fC6bvRF3ONAPmGB+R7UDcpEpNZrQs7a6X2vXAV2AcScEJWAGe37Ju5g/MuZpKBsm
 +vZs/XhRN9jjHlpUOhs35Hb8JMs=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5fbbdba3a5a29b56a1a48144 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 23 Nov 2020 15:56:19
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5A3C7C433ED; Mon, 23 Nov 2020 15:56:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 305EFC43460;
        Mon, 23 Nov 2020 15:56:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 305EFC43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     byhoo <hby2003@163.com>
Cc:     "davem\@davemloft.net" <davem@davemloft.net>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: Fix the Raspberry Pi debug version compile
References: <20201122100606.20289-1-hby2003@163.com>
        <5359213d.1442.175ef72e5b7.Coremail.hby2003@163.com>
Date:   Mon, 23 Nov 2020 17:56:10 +0200
In-Reply-To: <5359213d.1442.175ef72e5b7.Coremail.hby2003@163.com> (byhoo's
        message of "Sun, 22 Nov 2020 18:14:45 +0800 (GMT+08:00)")
Message-ID: <87v9dwqd7p.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

byhoo <hby2003@163.com> writes:

> The steps:
> 1. add "#define DEBUG" in
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c line 61.
> 2. make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=../Out_Linux
> bcm2835_defconfig
> 3. make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=../Out_Linux/
> zImage modules dtbs -j8
>
> Then, it will fail, the compile log described below:
>
> Kernel: arch/arm/boot/zImage is ready MODPOST Module.symvers ERROR:
> modpost: "brcmf_debugfs_add_entry"
> [drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko]
> undefined! ERROR: modpost: "brcmf_debugfs_get_devdir"
> [drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko]
> undefined! ERROR: modpost: "__brcmf_dbg"
> [drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko]
> undefined!
> /home/hby/gitee/linux_origin/Linux/scripts/Makefile.modpost:111:
> recipe for target 'Module.symvers' failed make[2]: ***
> [Module.symvers] Error 1 make[2]: *** Deleting file 'Module.symvers'
> /home/hby/gitee/linux_origin/Linux/Makefile:1390: recipe for target
> 'modules' failed make[1]: *** [modules] Error 2 make[1]: Leaving
> directory '/home/hby/gitee/linux_origin/Out_Linux' Makefile:185:
> recipe for target '__sub-make' failed make: *** [__sub-make] Error 2 

Please add this info to the commit log.

And please don't submit HTML emails, the lists will drop those
automatically. See the wiki below for more info.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
