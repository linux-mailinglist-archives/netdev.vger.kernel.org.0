Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6293E418B0B
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 22:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhIZUul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 16:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhIZUuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 16:50:40 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF17C061570;
        Sun, 26 Sep 2021 13:49:02 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id b15so66708233lfe.7;
        Sun, 26 Sep 2021 13:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SoTTB9hYB1EsRKeHtwIj9mIjzMNXA/oST3YFw6F+v40=;
        b=KbJG8f5RCGD/uLOn6P1Gzo2mHZy+o6xH4cx71HO6O4vp3GbE6cqGhzKStegXMRzqqO
         +MSHlmNQsZKSgi/YjlZMIM8VDz61MjM3UyU0dquBAORgteLPPS0RgbLHjCgRglwmVJq9
         s5qC9xZL38i89bZRbTV+mI2NFClNkXoZZA0Zv+DgvGfwUSraBrbcx7nAP4eWdV3joHOL
         VzHec9XqXHf40NmbbFCv9q3XWPTUWn4tsXrreD5KVZ8NWP2oKyB32eTANWJzIK91OuSB
         rWjvcPy3kD3vwzUFUykYx+v+V+3N8xDRhfjrqCh1zHT+qHZxNP5x81oe2MmEVVBtzPvH
         ckjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SoTTB9hYB1EsRKeHtwIj9mIjzMNXA/oST3YFw6F+v40=;
        b=Z0N+6OHB5u7hjTCIGLHPUHxPiVIMI161Z4vcNMWDsffr6DBXltCF/xKAq2xldbg36B
         KrhhTsEUz1sY1qNgUeNbIKzM7UyY+KWcya6agk4Zq24pE5MXlOHSRPdq7yL0YJXE9N0X
         Fk9BZKE7thzaLYKQ49wnSMlIaxXYOI0zEcsqIgaATryrv77XwbsTqKHS6ax2WgImb5Kt
         c/fh6wjHWeRFj9AHfnzUGSEMWzjriao1t8t/t3c187H4tOQpdP503HSuKwOhhbU/I75a
         PjyysLAp0aBCWC1nb4rcgFb9GwLh4cfb9OiuIdMVue4XURxrTzXOUbpZOVab/Y990QaH
         6nJw==
X-Gm-Message-State: AOAM530r4fJsYepXuXUQm1dlFxiIXbqZ2zMhIxnrRS939Vx9mULl3n+A
        lL7YdZmX5MpsE/I9VA/ndVM=
X-Google-Smtp-Source: ABdhPJyjgwJoETHQJTqXdAEEWKHLUg8zlLEJvapNEfikwXjlUYYzKjUDlrpMX6a0KTzhPmVzDLk9Ng==
X-Received: by 2002:a05:6512:31d4:: with SMTP id j20mr20529844lfe.135.1632689341023;
        Sun, 26 Sep 2021 13:49:01 -0700 (PDT)
Received: from [192.168.1.103] ([178.176.73.38])
        by smtp.gmail.com with ESMTPSA id a21sm1905818lji.135.2021.09.26.13.48.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Sep 2021 13:49:00 -0700 (PDT)
Subject: Re: [RFC/PATCH 12/18] ravb: Add timestamp to struct ravb_hw_info
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-13-biju.das.jz@bp.renesas.com>
 <ef7c0a4c-cd4d-817a-d5af-3af1c058964f@omp.ru>
 <OS0PR01MB5922426AACFBDF176125A9AF86A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <45c1dedb-6804-444f-703e-2aa1788e4360@omp.ru>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <ea925b7f-fcc7-d21f-c3bb-6fb8d210bbb2@gmail.com>
Date:   Sun, 26 Sep 2021 23:48:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <45c1dedb-6804-444f-703e-2aa1788e4360@omp.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/26/21 11:45 PM, Sergey Shtylyov wrote:

>>> -----Original Message-----
>>> Subject: Re: [RFC/PATCH 12/18] ravb: Add timestamp to struct ravb_hw_info
>>>
>>> On 9/23/21 5:08 PM, Biju Das wrote:
>>>
>>>> R-Car AVB-DMAC supports timestamp feature.
>>>> Add a timestamp hw feature bit to struct ravb_hw_info to add this
>>>> feature only for R-Car.
>>>>
>>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>>> ---
>>>>  drivers/net/ethernet/renesas/ravb.h      |  2 +
>>>>  drivers/net/ethernet/renesas/ravb_main.c | 68
>>>> +++++++++++++++---------
>>>>  2 files changed, 45 insertions(+), 25 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>>> b/drivers/net/ethernet/renesas/ravb.h
>>>> index ab4909244276..2505de5d4a28 100644
>>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>>> @@ -1034,6 +1034,7 @@ struct ravb_hw_info {
>>>>  	unsigned mii_rgmii_selection:1;	/* E-MAC supports mii/rgmii
>>> selection */
>>>>  	unsigned half_duplex:1;		/* E-MAC supports half duplex mode */
>>>>  	unsigned rx_2k_buffers:1;	/* AVB-DMAC has Max 2K buf size on RX
>>> */
>>>> +	unsigned timestamp:1;		/* AVB-DMAC has timestamp */
>>>
>>>    Isn't this a matter of the gPTP support as well, i.e. no separate flag
>>> needed?
>>
>> Agreed. Previously it is suggested to use timestamp. I will change it to as part of gPTP support cases.
> 
>    TIA. :-)
> 
>>>
>>> [...]
>>>> @@ -1089,6 +1090,7 @@ struct ravb_private {
>>>>  	unsigned int num_tx_desc;	/* TX descriptors per packet */
>>>>
>>>>  	int duplex;
>>>> +	struct ravb_rx_desc *rgeth_rx_ring[NUM_RX_QUEUE];
>>>
>>>    Strange place to declare this...
>>
>> Agreed. This has to be on later patch. Will move it.
> 
>    I only meant that these fields should go together with rx_ring[]. Apparently

   Sorry, this field.

> we have a case of wrong patch ordering here (as this patch needs this field declared)...
[...]

>> Regards,
>> Biju

MBR, Sergey
