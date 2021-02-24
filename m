Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54443323772
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 07:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbhBXGiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 01:38:08 -0500
Received: from z11.mailgun.us ([104.130.96.11]:57951 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233944AbhBXGiG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 01:38:06 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614148657; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=48yz8jIM52Gzthc3eIwA3MFNH39afr9/7f7lqtwUPCM=;
 b=k4U5BATpF/Nc6ffOe/uC9jsODVK/SiyHrZX6V4/ytB06YtSJst1PvkafDe9D417hwkriRZNn
 rsZiBImA2DbPGFUtfUOK5gyNJC/m2JTKRJWjkieRZ91+FRK9c1hfNrXjj5XrbwdrcbY7Wf9R
 fHyzEqJvrQd9H6FZoEX2/3JGwiA=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 6035f430ba08663830c1375b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 24 Feb 2021 06:37:36
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CE9B5C43462; Wed, 24 Feb 2021 06:37:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 25611C433CA;
        Wed, 24 Feb 2021 06:37:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 25611C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ath11k: qmi: use %pad to format dma_addr_t
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210221182754.2071863-1-geert@linux-m68k.org>
References: <20210221182754.2071863-1-geert@linux-m68k.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210224063736.CE9B5C43462@smtp.codeaurora.org>
Date:   Wed, 24 Feb 2021 06:37:36 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> If CONFIG_ARCH_DMA_ADDR_T_64BIT=n:
> 
>     drivers/net/wireless/ath/ath11k/qmi.c: In function ‘ath11k_qmi_respond_fw_mem_request’:
>     drivers/net/wireless/ath/ath11k/qmi.c:1690:8: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 5 has type ‘dma_addr_t’ {aka ‘unsigned int’} [-Wformat=]
>      1690 |        "qmi req mem_seg[%d] 0x%llx %u %u\n", i,
> 	  |        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      1691 |         ab->qmi.target_mem[i].paddr,
> 	  |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 	  |                              |
> 	  |                              dma_addr_t {aka unsigned int}
>     drivers/net/wireless/ath/ath11k/debug.h:64:30: note: in definition of macro ‘ath11k_dbg’
>        64 |   __ath11k_dbg(ar, dbg_mask, fmt, ##__VA_ARGS__); \
> 	  |                              ^~~
>     drivers/net/wireless/ath/ath11k/qmi.c:1690:34: note: format string is defined here
>      1690 |        "qmi req mem_seg[%d] 0x%llx %u %u\n", i,
> 	  |                               ~~~^
> 	  |                                  |
> 	  |                                  long long unsigned int
> 	  |                               %x
> 
> Fixes: d5395a5486596308 ("ath11k: qmi: add debug message for allocated memory segment addresses and sizes")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Patch applied to wireless-drivers.git, thanks.

ebb9d34e073d ath11k: qmi: use %pad to format dma_addr_t

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210221182754.2071863-1-geert@linux-m68k.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

