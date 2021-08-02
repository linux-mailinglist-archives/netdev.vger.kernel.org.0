Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97773DE116
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhHBUzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhHBUzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 16:55:09 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967BAC061760;
        Mon,  2 Aug 2021 13:54:59 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id x8so22746682lfe.3;
        Mon, 02 Aug 2021 13:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1HZFyT/f2O2awrt0aUPQqjU99JqeiAz//7TAs6M0YVQ=;
        b=T8jRwD54Ntq3JAYWRKMH8pfquMClgQNvcwPp5a/VTVydPo0DZE07S+hYanngSlQzuo
         Ocbt+pm86Q0hGjUNqgv5dAoI2cX4UERXSrUYvvhiZoojVVV4FVQhT766tXuRcfq+zDj8
         FfYFaRnJHkYJvVwEoNAKjIhGE9hvbqGDkbycZ2Xy6n8+XVKTzMW/vu51+3BM2T0zfDt/
         Cykywwr456EA2iSDCugSYRY4x9E7WkeWOOyY5XZ55BsAQgydbLEE2W/g9OLXN/qOl4CW
         n33EDm+K6Lf6xsR5EVJbuK6ztPREIUuhRtsr0clAAj4DYSVnNvh6rO4niozLKEerVx/8
         VS0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1HZFyT/f2O2awrt0aUPQqjU99JqeiAz//7TAs6M0YVQ=;
        b=gDld3E48WysBZQRdwPUvdGdqXxfXg1O2kBol6LL0ymRP6meFk5UWA2oD7Cs56ynpvH
         RxuHCBC3OIN1c1SICCm3wxTC7oET+pBgsSDCn8Oa7/EJvBef3ve/OlNY5/oYGtaqTqKK
         QjGXwRYsrT4sGjMo15GIlqOIjgOSCwzTBtMADiDnnAeV1/GG2s4g2r8Pjz3cLrCtTA4P
         xVD7XTYwQMJrjA3wNEJ5LPWCWs9lBksaRTujFkX5PGUiuMvVezGQSOCSeRndwt0sz0mR
         WzNaMQo0ataqkHrTC5fXmf9Ebae2DtreKBoKFDDvN3uByFjGP7Cuu0R77N9sZzMMo2HD
         WMAQ==
X-Gm-Message-State: AOAM531ikSp70Gv6nmJ0lck6m9BP1f177AMSiMnWsxyeZxyDRpcU8Len
        ElZ8R1v4CkM9Qq2ctAnES1Y=
X-Google-Smtp-Source: ABdhPJx5fFLmZdBIT/BLQU33TKK5D2T9OekIYmIybGJuYAXrQBGYSiCnx2sgFnRwNh2E1xXK17URnA==
X-Received: by 2002:ac2:5e8e:: with SMTP id b14mr337767lfq.165.1627937698014;
        Mon, 02 Aug 2021 13:54:58 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.81.124])
        by smtp.gmail.com with ESMTPSA id k14sm747844lfo.262.2021.08.02.13.54.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 13:54:57 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/8] ravb: Add skb_sz to struct ravb_hw_info
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
 <20210802102654.5996-3-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <58df29d2-c791-df23-994f-7d6176f79fb3@gmail.com>
Date:   Mon, 2 Aug 2021 23:54:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210802102654.5996-3-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/21 1:26 PM, Biju Das wrote:

> The maximum descriptor size that can be specified on the reception side for
> R-Car is 2048 bytes, whereas for RZ/G2L it is 8096.
> 
> Add the skb_size variable to struct ravb_hw_info for allocating different
> skb buffer sizes for R-Car and RZ/G2L using the netdev_alloc_skb function.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
> v2:
>  * Incorporated Andrew and Sergei's review comments for making it smaller patch
>    and provided detailed description.
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 10 ++++++----
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index cfb972c05b34..16d1711a0731 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -991,6 +991,7 @@ enum ravb_chip_id {
>  struct ravb_hw_info {
>  	enum ravb_chip_id chip_id;
>  	int num_tx_desc;
> +	size_t skb_sz;

   Bad naming -- refers to software ISO hatdware, I suggest max_rx_len or s/th of that sort.

[...]

MBR, Sergei
