Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1F84216A2
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 20:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbhJDSjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 14:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhJDSi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 14:38:57 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CFBC061745;
        Mon,  4 Oct 2021 11:37:08 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id x27so75649658lfu.5;
        Mon, 04 Oct 2021 11:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xem27AtWW1FQA6QFUscNmpNu/Mi0AlB3uxJE9Zg7LWU=;
        b=VvlK17bgfWju26sVx30X0JjTItRn2NqFbmnHvE2isMMlopyEpyhXM0Rj2E4M62D6Il
         mTRup9WRJoLo6k5LORBQarOAcJa4XMLNjfXqvEABYiG4zjR6yNuJgUDgNTZIPyh2Ke1Y
         9NhX46dJrB0Owho9XbLusMcZ4Od/DsIVa72+Gxas+FJoQg98YXn3bNb6UXzpmwtgkQDD
         bowtIgQ7TXO7XcLVGzkL9wWyKCMBc49lGkB1FjmTmKoRY4Fm1o4Ek41/0OMycbY3jNrf
         hoEwSuuwje+C1Dgd2fdtnIwWYBkWgZy5DcPgdDJ14Y4COisSaFLc8+1x/pe6Ia5Sqo35
         C7tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xem27AtWW1FQA6QFUscNmpNu/Mi0AlB3uxJE9Zg7LWU=;
        b=H+anMHbHrvM5PlquRcHpiAnSi5ckGn/NrkzNRCwSRhd5gDKQZFf3RNjQNM6k3LXe1m
         UiWw5ksNfJcuepAsS3I1GrVMUqYfoo8MLzuvN9ywfztY+c4jrNoraRQ0shltrIoEJt8P
         MQodXiY8UHVLIMOndRfsRvJnL1V2Or6Y7/+wYvjdL7xrQRZUNQUmEoHcoHI09xwsKSN8
         nwXnFXjSwgnlhGFvMVp9G9T1yxSXMHv2Q0WSaLzv2epkZXsumAzoTcqMc6iJ3mf5MDLg
         RLIrI3zroktVfJVgYaPYic5ja03rALENdvbXi1N7WfZ9o/NHB6AHtTkdnVj8frFdTm7h
         7tkw==
X-Gm-Message-State: AOAM532h8JGmtjlWA4GPnLeOuWftKAZelC5oHAOgyjzbMZSOq5nB11Pp
        LipSUh/9XtNveNRZ4j/22ZM=
X-Google-Smtp-Source: ABdhPJxh4rDbJVCVy7zoAFnE3MkIxBFqljK7Opdyx3aKJumHOnHj5ZBOKogs7h85DCNjYopavjgDbA==
X-Received: by 2002:a2e:a277:: with SMTP id k23mr14153835ljm.53.1633372626602;
        Mon, 04 Oct 2021 11:37:06 -0700 (PDT)
Received: from [192.168.1.103] ([178.176.79.223])
        by smtp.gmail.com with ESMTPSA id w26sm1695440ljo.33.2021.10.04.11.37.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 11:37:06 -0700 (PDT)
Subject: Re: [PATCH 07/10] ravb: Add tsrq to struct ravb_hw_info
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Biju Das <biju.das.jz@bp.renesas.com>,
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
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-8-biju.das.jz@bp.renesas.com>
 <5193e153-2765-943b-4cf8-413d5957ec01@omp.ru>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <e83b3688-4cfe-8706-bd42-ab1ad8644239@gmail.com>
Date:   Mon, 4 Oct 2021 21:37:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5193e153-2765-943b-4cf8-413d5957ec01@omp.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/21 9:00 PM, Sergey Shtylyov wrote:

[...]
>    The TCCR bits are called transmit start request (queue 0/1), not transmit start request queue 0/1.
> I think you've read too much value into them for what is just TX queue 0/1.
> 
>> Add a tsrq variable to struct ravb_hw_info to handle this
>> difference.
>>
>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>> ---
>> RFC->v1:
>>  * Added tsrq variable instead of multi_tsrq feature bit.
>> ---
>>  drivers/net/ethernet/renesas/ravb.h      | 1 +
>>  drivers/net/ethernet/renesas/ravb_main.c | 9 +++++++--
>>  2 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
>> index 9cd3a15743b4..c586070193ef 100644
>> --- a/drivers/net/ethernet/renesas/ravb.h
>> +++ b/drivers/net/ethernet/renesas/ravb.h
>> @@ -997,6 +997,7 @@ struct ravb_hw_info {
>>  	netdev_features_t net_features;
>>  	int stats_len;
>>  	size_t max_rx_len;
>> +	u32 tsrq;
> 
>    I'd call it 'tccr_value' instead.

    Or even better, 'tccr_mask'...

[...]

MBR, Sergey
