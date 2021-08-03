Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC313DF6BF
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhHCVNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbhHCVNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 17:13:15 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46D3C061757;
        Tue,  3 Aug 2021 14:13:02 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id bq29so844207lfb.5;
        Tue, 03 Aug 2021 14:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vgPl6BaCpLbOlFeMrUfjzlS6eCny+DWiPZhuCaLPfhY=;
        b=f1Q/6Ky2p7LlIdKfSXs0xlHA1+tAZQmaXKpbxmTliC9TEPdr8d2rCOjS7uFJV4e4Yb
         N0Zy2WLRnZwMNjvUjxy9sGYPeTAZZ5VTFGJbL8hOBfHbd4H828PYj/7kkI+JLGM+2LPZ
         RiMS3yVK4+9AhPtXDUkBGKwtVJSH+r/KI2FvSQS0QCDI0oh15YycydntGhukNvGlq+bR
         uM72c6jD+V+UQRPAHAZx+mfOwutIAMpjMvfHI32bghuh0+b4TZwu2cLSOvldAWNaBmLu
         Ev+tu+l1sGy5V/vntTA5NKqwnkzPTSts4qAb6rOwOLqiEGHLsPvzFz23tRxR6UxzL8kn
         xlVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vgPl6BaCpLbOlFeMrUfjzlS6eCny+DWiPZhuCaLPfhY=;
        b=h17OfS5WqPOMLYZNwW7DW49LzqaTVK9yLQDW5UrLo1aklpHtqYwdrwaHGrTtJ8rFyh
         rMfwMFnLTuLw8V5HtgzZAlTLMvR7sNwnyoX9mO8HgpV9/KVldvzH+zix7RiBZGFaYHc3
         pwYkmVIzbkVuANYiP2cqm2wvA8hJ0hmo83fj6rqAioIoW5Iw99t/HZ8FTZd4eZ/XO6MP
         kLZmpDjGK8cmf8b1+qJ4DE6NohdRf8PjbjNknSsc5l67yzAILHVeiXqwAdUMnj4tDxGq
         gkPnE6h83AqVdY75M7YhzTcXCxxk+olgQ1g+Hlt5TKgiBiZ76wS7Ies5zu3IG9qFkotW
         nQNA==
X-Gm-Message-State: AOAM531huTWe7E5y6opHQZZ6kd95cNBGEmQdvJNkKNsGT1K6YkYkYYOi
        tEPMEn2FhCOuK01xy6/B6Ec=
X-Google-Smtp-Source: ABdhPJzFAMhrLLGNCr37uBef03FfcDQ3DZJeJ8ivLOu8B3Gx+UF1llc3LfSCuesUmy2kmk2CQ4spCA==
X-Received: by 2002:ac2:4d22:: with SMTP id h2mr18045240lfk.629.1628025181286;
        Tue, 03 Aug 2021 14:13:01 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.76.0])
        by smtp.gmail.com with ESMTPSA id w40sm1344797lfu.165.2021.08.03.14.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 14:13:01 -0700 (PDT)
Subject: Re: [PATCH net-next v2 7/8] ravb: Add internal delay hw feature to
 struct ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-8-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <ad727120-3ae6-4db7-e368-f06c82cfa759@gmail.com>
Date:   Wed, 4 Aug 2021 00:12:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210802102654.5996-8-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/21 1:26 PM, Biju Das wrote:

> R-Car Gen3 supports TX and RX clock internal delay modes, whereas R-Car
> Gen2 and RZ/G2L do not support it.
> Add an internal_delay hw feature bit to struct ravb_hw_info to enable this
> only for R-Car Gen3.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
> v2:
>  * Incorporated Andrew and Sergei's review comments for making it smaller patch
>    and provided detailed description.
> ---
>  drivers/net/ethernet/renesas/ravb.h      | 3 +++
>  drivers/net/ethernet/renesas/ravb_main.c | 6 ++++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 3df813b2e253..0d640dbe1eed 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -998,6 +998,9 @@ struct ravb_hw_info {
>  	int num_tx_desc;
>  	int stats_len;
>  	size_t skb_sz;
> +
> +	/* hardware features */
> +	unsigned internal_delay:1;	/* RAVB has internal delays */

   Oops, missed it initially:
   RAVB? That's not a device name, according to the manuals. It seems to be the driver's name.
I'd drop this comment...

[...]

MBR, Sergei
