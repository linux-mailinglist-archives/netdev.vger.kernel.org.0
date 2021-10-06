Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295DF42475F
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 21:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239445AbhJFTr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 15:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbhJFTrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 15:47:55 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17ADFC061746;
        Wed,  6 Oct 2021 12:46:03 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t9so14740406lfd.1;
        Wed, 06 Oct 2021 12:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wmbVcJCU0UMxjZJ6KxgSa9j9LhdzbNeiHGn798E77Sw=;
        b=iCySlt3p3pCZaH9oFxNOUqiTmpeBbseJNJ73EX3lPpKJFKh8pK7pt8NiNM30AHAaut
         WW9cQW3P1CS/pHJ3zXlUVF2SXFrabOrtSTRikY7O8eHoNAMwUnkYiFv084rrDHgO0GoU
         YFz6sLxwGGh9EPJc3V/GmRquklE3NPPMXWmkpPtp8W3LW13h63DG37lyE11ztm4GrFa9
         3uikUe3qzC8Puo1L44eoSRB5fh1iZqTan8yxT3GpMK5OGn0wttFJ7+4BC6OGR1NwxdF1
         iSyeKtiqch1jOVq6OcJA1PyxfsNujbbb5t80t1QTRLC9Cm/OMvyTq4s5KWWVEhNsiekp
         FIpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wmbVcJCU0UMxjZJ6KxgSa9j9LhdzbNeiHGn798E77Sw=;
        b=KfJqiTotecxIJGZIZaIzD3U5nr5YOTMZ42XVNDB4B/H8QDLG9ymPvFOmAPR/2idDfw
         K+7Huhlut2SxOmzYF+w5UapgIFwWRUMP5PBqCsqGKr6HuivFz1UW5V2qhqk7HVg9KnQg
         YeCIN5AWuGjADCLLA34FSvDsCO3GgDSnd3bkjI7BF4p7Bwp8UnrfrbJ5pAg08ahsFspr
         u8tGQNaLuxWmpnlAOBJtGeEGz1qa3V1+pMN9vALnjLbKJqnuERHBPpVKPzkYBsGYZwiW
         rsIuXaKgxu4vRIwb+/CvQ4b/x29O1BQaiUgza9HWIyLLqyQCbDdlFq50qF1lyAZ2WTWG
         AtqA==
X-Gm-Message-State: AOAM533UuLPBWNqVRbAaO4uWbgMd8IHsB00lSm5cb03wXZZai1T9rRvh
        t9OddWnFhu7QEdKrSw6SbDY=
X-Google-Smtp-Source: ABdhPJxx/9JxGlQ6wMr+587Qv8qoom+WWa4tcpDM0lLMVmoDOWeXlfUdb0fsEtCcf/SQcN1jPVERjQ==
X-Received: by 2002:ac2:4e98:: with SMTP id o24mr11519147lfr.295.1633549561211;
        Wed, 06 Oct 2021 12:46:01 -0700 (PDT)
Received: from [192.168.1.103] ([31.173.86.247])
        by smtp.gmail.com with ESMTPSA id a6sm2041705lfg.38.2021.10.06.12.45.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 12:46:00 -0700 (PDT)
Subject: Re: [PATCH 03/10] ravb: Add nc_queue to struct ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-4-biju.das.jz@bp.renesas.com>
 <334a8156-0645-b29c-137b-1e76d524efb9@omp.ru>
 <OS0PR01MB59222DB9D710A944235FD1D586AD9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <757eb986-d3cc-322a-64e8-3b23a3dd07d3@gmail.com>
Date:   Wed, 6 Oct 2021 22:45:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB59222DB9D710A944235FD1D586AD9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/3/21 9:58 AM, Biju Das wrote:

>>> R-Car supports network control queue whereas RZ/G2L does not support
>>> it. Add nc_queue to struct ravb_hw_info, so that NC queue is handled
>>> only by R-Car.
>>>
>>> This patch also renames ravb_rcar_dmac_init to ravb_dmac_init_rcar to
>>> be consistent with the naming convention used in sh_eth driver.
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>
>> Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>>
>>    One little nit below:
>>
>>> ---
>>> RFC->v1:
>>>  * Handled NC queue only for R-Car.
>>> ---
>>>  drivers/net/ethernet/renesas/ravb.h      |   3 +-
>>>  drivers/net/ethernet/renesas/ravb_main.c | 140
>>> +++++++++++++++--------
>>>  2 files changed, 94 insertions(+), 49 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>> b/drivers/net/ethernet/renesas/ravb.h
>>> index a33fbcb4aac3..c91e93e5590f 100644
>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>> @@ -986,7 +986,7 @@ struct ravb_hw_info {
>>>  	bool (*receive)(struct net_device *ndev, int *quota, int q);
>>>  	void (*set_rate)(struct net_device *ndev);
>>>  	int (*set_feature)(struct net_device *ndev, netdev_features_t
>> features);
>>> -	void (*dmac_init)(struct net_device *ndev);
>>> +	int (*dmac_init)(struct net_device *ndev);
>>>  	void (*emac_init)(struct net_device *ndev);
>>>  	const char (*gstrings_stats)[ETH_GSTRING_LEN];
>>>  	size_t gstrings_size;
>>> @@ -1002,6 +1002,7 @@ struct ravb_hw_info {
>>>  	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple
>> irqs */
>>>  	unsigned gptp:1;		/* AVB-DMAC has gPTP support */
>>>  	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in
>> config mode */
>>> +	unsigned nc_queue:1;		/* AVB-DMAC has NC queue */
>>
>>    Rather "queues" as there are RX and TX NC queues, no?
> 
> It has NC queue on both RX and TX.
> 
> If needed, I can send a follow up patch as RFC with the following changes.
> 
> unsigned nc_queue:1;		/* AVB-DMAC has NC queue on both RX and TX  */
> 
> or 
> 
> unsigned nc_queues:1;		/* AVB-DMAC has RX and TX NC queues */
> 
> please let me know.

   Yes, please do it.

> Regards,
> Biju

MNR, Sergey

