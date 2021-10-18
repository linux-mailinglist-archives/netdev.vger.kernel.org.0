Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7743432463
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 19:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhJRRJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 13:09:05 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:57394 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbhJRRJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 13:09:04 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 825691FD7F;
        Mon, 18 Oct 2021 17:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634576812; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g+xEncPLzGx9ZCLG9ruFPU6W88FhG8Xg3tx8dZBe/xU=;
        b=y0EDyqcDOsCrk1vKiyIg/AuKOoB0r0I3EXF4nXhCj54KmtJmQiNN+iOzHMGwe/Q7/Q/uJj
        NYH5fn7QQLHcdZbh92bzNkyJBn6k/8IQL6oYD2StyBolME3mMiCWDHh6yocqnEzlrNzR/D
        gtl2P+9T+nWW6zGlraejSDj2cWv0hc0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634576812;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g+xEncPLzGx9ZCLG9ruFPU6W88FhG8Xg3tx8dZBe/xU=;
        b=b0DV2eKqDyWp2HUHhAN8fFwVy5suKshGIJtkq/wuEGeiZgvm2xoZRBP9NxjexR7Xk77Gu5
        YVNoEj0OqdA438DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2970B140D1;
        Mon, 18 Oct 2021 17:06:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id A8svB6ypbWENSgAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Mon, 18 Oct 2021 17:06:52 +0000
Subject: Re: [PATCH] mISDN: Fix return values of the probe function
To:     Zheyu Ma <zheyuma97@gmail.com>, isdn@linux-pingi.de,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1634566838-3804-1-git-send-email-zheyuma97@gmail.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <02fe8f6c-e332-5286-a759-750f47c3512a@suse.de>
Date:   Mon, 18 Oct 2021 20:06:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1634566838-3804-1-git-send-email-zheyuma97@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



10/18/21 5:20 PM, Zheyu Ma пишет:
> During the process of driver probing, the probe function should return < 0
> for failure, otherwise, the kernel will treat value > 0 as success.

setup_card() checks for the return value.
Thus it makes sense to submit the patch with net-next tag

> 
> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
> ---
>   drivers/isdn/hardware/mISDN/hfcpci.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
> index e501cb03f211..bd087cca1c1d 100644
> --- a/drivers/isdn/hardware/mISDN/hfcpci.c
> +++ b/drivers/isdn/hardware/mISDN/hfcpci.c
> @@ -1994,14 +1994,14 @@ setup_hw(struct hfc_pci *hc)
>   	pci_set_master(hc->pdev);
>   	if (!hc->irq) {
>   		printk(KERN_WARNING "HFC-PCI: No IRQ for PCI card found\n");
> -		return 1;
> +		return -EINVAL;
>   	}
>   	hc->hw.pci_io =
>   		(char __iomem *)(unsigned long)hc->pdev->resource[1].start;
>   
>   	if (!hc->hw.pci_io) {
>   		printk(KERN_WARNING "HFC-PCI: No IO-Mem for PCI card found\n");
> -		return 1;
> +		return -ENOMEM;
>   	}
>   	/* Allocate memory for FIFOS */
>   	/* the memory needs to be on a 32k boundary within the first 4G */
> @@ -2012,7 +2012,7 @@ setup_hw(struct hfc_pci *hc)
>   	if (!buffer) {
>   		printk(KERN_WARNING
>   		       "HFC-PCI: Error allocating memory for FIFO!\n");
> -		return 1;
> +		return -ENOMEM;
>   	}
>   	hc->hw.fifos = buffer;
>   	pci_write_config_dword(hc->pdev, 0x80, hc->hw.dmahandle);
> @@ -2022,7 +2022,7 @@ setup_hw(struct hfc_pci *hc)
>   		       "HFC-PCI: Error in ioremap for PCI!\n");
>   		dma_free_coherent(&hc->pdev->dev, 0x8000, hc->hw.fifos,
>   				  hc->hw.dmahandle);
> -		return 1;
> +		return -ENOMEM;
>   	}
>   
>   	printk(KERN_INFO
> 
