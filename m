Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C345D3B128D
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 06:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhFWEDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 00:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhFWEDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 00:03:19 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66B0C061574;
        Tue, 22 Jun 2021 21:01:02 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id f3-20020a0568301c23b029044ce5da4794so603282ote.11;
        Tue, 22 Jun 2021 21:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xu3J0MG1DAoiBty4+jXpzlIZwsi55uVKyRQkNX9z39w=;
        b=My2OQKbp4vxT5pp+htE5GMVR5w/CffUe54PAXG5EIXkMvDictyyJ36KpPZ++gkbfmJ
         MnJ9CmikGlbXwhEgrByuLfqsHRKamVBtlmMGxbdMbn+yMLL0ZTERCdGrqN5o4YirofI1
         a3GWa8F/wv1dm5+I38cLFEMt5cf6oNPB0jA1t1qqrkulCheBp1lDftNPkZyx4f7COxey
         qAfnjXzIXv+/g/IX/2efNJWsSOkwgIvwWg/5KjBsqevDUAoTxM8lvoPUIvzCF5xbdkeb
         v8vOszEaF9pXXQOPZt6RaxD0XcClJRcBr5pD5TnQIlX0s2OzsDY2CJtA+pIIbRYCe/Qp
         HXSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xu3J0MG1DAoiBty4+jXpzlIZwsi55uVKyRQkNX9z39w=;
        b=rogdcqkXn86SoWxPqBIx8nUTUE7JBoHCYuKKpB7cVbZezZAOB3O9l872RzAowrJ7b0
         vAKQWkJEe5oLFzuJ7K4VWvEtF2uuri6yYffDnwLj0LXoPg+5LQV5+MXhyEwqyR8N7tfq
         idPCf5tPDTen1b3sl2LzL1hJWf7AYPEctwtR0wcqLAAxindicEdoVoPIv13Gir1iUsxp
         B0QYmtij0qrz+/+yDI3LkN2iEknV5hOWzmjxF3IYV6uSA8Al+E5Hqy2AllyaWmlqGyI5
         iWXi7INQ1J+lKsnMXXcDP0Q7kUEIjNtaWpDZM4qXJygtvQgIECMUeSFXlL4has5hd+f0
         WXnA==
X-Gm-Message-State: AOAM530vSHMdTBPgJhQgh16tYWm9Scmy4pNICL0+cMsU+/Af0rkaJksA
        l0NTsIiPefXLxC0QqgS/XgA=
X-Google-Smtp-Source: ABdhPJyKctj3yzlrMEzrjhyzrSCUQWW3Gp8SegBTo/THZdIwOKicAP0VZPs2LI7azl6TIumN7k8Uqw==
X-Received: by 2002:a05:6830:2315:: with SMTP id u21mr6068794ote.365.1624420861910;
        Tue, 22 Jun 2021 21:01:01 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:702e:9530:891f:215c? ([2600:1700:dfe0:49f0:702e:9530:891f:215c])
        by smtp.gmail.com with ESMTPSA id y5sm59578otq.5.2021.06.22.21.00.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 21:01:01 -0700 (PDT)
Subject: Re: [PATCH v2] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
To:     Jian-Hong Pan <jhp@endlessos.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Doug Berger <opendmb@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessos.org,
        linux-rpi-kernel@lists.infradead.org
References: <CAPpJ_ecJxUjvxEb+3GLmtQyxhAZ3Tqk+hoUbSowG1bi+739u-g@mail.gmail.com>
 <20210623032802.3377-1-jhp@endlessos.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <aa2ec0dd-6b43-099f-da0a-768d1668ec50@gmail.com>
Date:   Tue, 22 Jun 2021 21:00:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210623032802.3377-1-jhp@endlessos.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The subject should be fixed s/PYH/PHY/ and also probably reworded to be:

net: bcmgenet: Add mdio-bcm-unimac soft dependency

On 6/22/2021 8:28 PM, Jian-Hong Pan wrote:
> The Broadcom UniMAC MDIO bus from mdio-bcm-unimac module comes too late.

It is not just coming too late, there is also no way for the module 
loader to figure out the dependency between GENET and its MDIO bus 
driver unless we provide this MODULE_SOFTDEP hint.

> So, GENET cannot find the ethernet PHY on UniMAC MDIO bus. This leads
> GENET fail to attach the PHY as following log:
> 
> bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
> ...
> could not attach to PHY
> bcmgenet fd580000.ethernet eth0: failed to connect to PHY
> uart-pl011 fe201000.serial: no DMA platform data
> libphy: bcmgenet MII bus: probed
> ...
> unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus
> 
> This patch adds the soft dependency to load mdio-bcm-unimac module
> before genet module to avoid the issue.
> 
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=213485
> Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: 9a4e79697009 ("net: bcmgenet: utilize generic Broadcom UniMAC 
MDIO controller driver")

> ---
> v2: Load mdio-bcm-unimac before genet module instead of trying to
>      connect the PHY in a loop.
> 
>   drivers/net/ethernet/broadcom/genet/bcmgenet.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index fcca023f22e5..41f7f078cd27 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -4296,3 +4296,4 @@ MODULE_AUTHOR("Broadcom Corporation");
>   MODULE_DESCRIPTION("Broadcom GENET Ethernet controller driver");
>   MODULE_ALIAS("platform:bcmgenet");
>   MODULE_LICENSE("GPL");
> +MODULE_SOFTDEP("pre: mdio-bcm-unimac");
> 

-- 
Florian
