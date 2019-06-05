Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06DDF36344
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 20:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFESTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 14:19:12 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34611 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbfFESTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 14:19:12 -0400
Received: by mail-lf1-f65.google.com with SMTP id y198so9329741lfa.1
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 11:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ioxq6ackk7T4k8ldqHW70CLxvDfXrnWwaJ3D/ZfF94Y=;
        b=wbKv1Gyp4Mblw7ZDI5tFqNuGbeNZTkHhrEaYqYmebEqLHF+VvyDKuHc/DjoZrrVKka
         NP4Paoh0SSEWwIdD7zNvtSndDm8bHZclpEqQFf+FCjAozvMhhiGS1jNZNEs+HPUJrJX0
         5HbXrZAmC4POk94/6jPW5iAd+eiyxo9MKSxtMyZlKjnDrPbTQW5WinvPrL6H0m1hCEKx
         VRiA4c98nu9OPvlacwZVi23Ewqvpjynz2iX+SRCDgb7D2xc1ci+r00VM+MjClcYV+IFR
         VV4bjF0njpB+w+TZTiVzJtpaLc0QeaqntEDqRoadT6qt9oD9zncH5ZPQdq8Nfxiicbt5
         gXjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Ioxq6ackk7T4k8ldqHW70CLxvDfXrnWwaJ3D/ZfF94Y=;
        b=DLhu5hp0eoocaZPn3tgJCyc5VXVNUHc48pewpBczHMIJCU9vurq/r/1BkrMA6wkHra
         VrbJAFRXTLUII9zDCmEkTZCIUPG+hNJF1IVtfmjx1JyjeMfBsIDPSPVmvEuZHBRMkdFd
         kbghq/av006rYsgNlgu83G6zu8DHXqXB1FrOIYE1AvNOAWtYPUbwqSlQL28Y0EOm3Zql
         dWfWylMUVtdSxvYLpbKAjbih65Xo2VuSnVkUm6YnsIXkbkymT1VaJeLDgDYdZtp1ghVB
         46byACrYFv9bOESIq7XJPUwioF7MwcnysyulsuZKlY4kTcnX4TdtXF0uygfbYIjKX4ns
         qVsA==
X-Gm-Message-State: APjAAAWK0SFVneERUNhQG+lFWCdRemtmKdvN2j98SD1j5al7S9/9GX5R
        VNRVpdYmXrVj12RebQG0QJEI/g==
X-Google-Smtp-Source: APXvYqxoYf0L/vunsEB/D7FShIXZECvvscq6VbVMj7ivUZYzMOoPJVlYalJvCV/Nqfm8TBi3hvbo2g==
X-Received: by 2002:a19:fc1d:: with SMTP id a29mr22327508lfi.35.1559758750858;
        Wed, 05 Jun 2019 11:19:10 -0700 (PDT)
Received: from wasted.cogentembedded.com ([31.173.84.82])
        by smtp.gmail.com with ESMTPSA id s6sm4452945lje.89.2019.06.05.11.19.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 11:19:09 -0700 (PDT)
Subject: Re: [PATCH v2] net: sh_eth: fix mdio access in sh_eth_close() for
 R-Car Gen2 and RZ/A1 SoCs
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <1559016646-7293-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <2ae6d8c6-372f-4708-8bd4-f461b403b986@cogentembedded.com>
Date:   Wed, 5 Jun 2019 21:19:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <1559016646-7293-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

   I've been meaning to look around this issue before replying to this respin
but didn't notify DaveM, so he finally merged it...

On 05/28/2019 07:10 AM, Yoshihiro Shimoda wrote:

> The sh_eth_close() resets the MAC and then calls phy_stop()
> so that mdio read access result is incorrect without any error
> according to kernel trace like below:
> 
> ifconfig-216   [003] .n..   109.133124: mdio_access: ee700000.ethernet-ffffffff read  phy:0x01 reg:0x00 val:0xffff
> 
> According to the hardware manual, the RMII mode should be set to 1
> before operation the Ethernet MAC. However, the previous code was not
> set to 1 after the driver issued the soft_reset in sh_eth_dev_exit()
> so that the mdio read access result seemed incorrect. To fix the issue,
> this patch adds a condition and set the RMII mode register in
> sh_eth_dev_exit() for R-Car Gen2 and RZ/A1 SoCs.

   I told you RZ/G1, not RZ/A1. The latter has its own data structure
 and different register layout.

> Note that when I have tried to move the sh_eth_dev_exit() calling
> after phy_stop() on sh_eth_close(), but it gets worse (kernel panic
> happened and it seems that a register is accessed while the clock is
> off).

  I've reproduced it but still don't know why that happens.

> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  Changes from v1 (https://patchwork.kernel.org/patch/10944265/):
>  - Revise the subject, commit log and the comment of the code.
>  - Move the RMII setting to right after soft_reset.
> 
>  drivers/net/ethernet/renesas/sh_eth.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
> index 6354f19..7ba35a0 100644
> --- a/drivers/net/ethernet/renesas/sh_eth.c
> +++ b/drivers/net/ethernet/renesas/sh_eth.c
> @@ -1594,6 +1594,10 @@ static void sh_eth_dev_exit(struct net_device *ndev)
>  	sh_eth_get_stats(ndev);
>  	mdp->cd->soft_reset(ndev);
>  
> +	/* Set the RMII mode again if required */

   When I asked for more details, I was meaning this comment. Thanks for telling me
about the gory details anyway. :-)

> +	if (mdp->cd->rmiimode)
> +		sh_eth_write(ndev, 0x1, RMIIMODE);
> +
>  	/* Set MAC address again */
>  	update_mac_address(ndev);
>  }

MBR, Sergei
