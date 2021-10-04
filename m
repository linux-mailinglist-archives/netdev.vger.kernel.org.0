Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B551421314
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 17:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236003AbhJDPwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 11:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235986AbhJDPwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 11:52:49 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7C2C061745;
        Mon,  4 Oct 2021 08:51:00 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id j5so68532608lfg.8;
        Mon, 04 Oct 2021 08:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4Pb1LTHDnswW0aMXbAqZbT75ZmuwObo40xPn0GtE5ZA=;
        b=JIOQEAqEQs2KUbSPAlxKXe4/WB6n5QsQtdpsDo0oD9lPvk42aQTnRRtixmr6k2PbT+
         Zm9j4KoRnlff3Z+JawpHXn767EMyQ3fqoWtf9NP7JdBKVe7Rs3iPn1NKVMUCo8fVNHDN
         uDe9WnHsDdyc4ZHylJ91HewNPMXW4rObSp7Fs/hiRHwbl+yMgqLeXN9S6/WP3rTMtvA2
         IQIZxD29HF78xMyhCLQ+fvzdz41hgoahIZqwnEn0+F802QYT26sH+A54AB04RZ5+2+pP
         159WGeOeQcPG0gq6EvRtcypgNsLseOzulNbVSn31Pmhc5CLsGs6Rw8dGmLSgFKEKhGOD
         7Vbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Pb1LTHDnswW0aMXbAqZbT75ZmuwObo40xPn0GtE5ZA=;
        b=2VYlFvwbNIYTltSpQzSmgb82HM19DssT30rW1BOVQAGv8g7hfO6fnsOWCM41psICB1
         anOSxh6OyRFvwZ0XU8OTz27hdaGxvnaqfYPdTpFSl8OzODrS+9/vmbdRGUOpJ4wx4sGa
         ee/MRuLzkqgnYG82jl7pkxG3agqreV2XytgYYCaXGiP6GdktV4xOjiZHZK5HVT6+MEx4
         Dr1gKViigqpVk2Whq8us8cYQD6tJX8YaH7hs4NWbfKI+q4AgyABW7jHyCs57zcRh6GCw
         O7FA0jk6IHKJmBqI+ZT3srTSHQPGtAslQP3A+yMeZoyUlB7dZQXm5MctajJNEuviirQ2
         nrLA==
X-Gm-Message-State: AOAM531K3Mc26D8qWCzXNQbDrQH2fSfTlT7Mzv/cgW5sBluaHi0RFRHZ
        sY+VGva1IAu3SL7DA0qgdI4=
X-Google-Smtp-Source: ABdhPJzGUaBSSCJACgIXEe3B42X5y7LsiODJ5jvoUQxEmYgaI25NsYcTXEomYfNZQwPcGTZmOachwg==
X-Received: by 2002:a05:6512:a93:: with SMTP id m19mr4472789lfu.574.1633362656315;
        Mon, 04 Oct 2021 08:50:56 -0700 (PDT)
Received: from [192.168.1.103] ([178.176.79.223])
        by smtp.gmail.com with ESMTPSA id r23sm1006221lfe.268.2021.10.04.08.50.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 08:50:55 -0700 (PDT)
Subject: Re: [PATCH 05/10] ravb: Initialize GbEthernet DMAC
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
 <20211001150636.7500-6-biju.das.jz@bp.renesas.com>
 <58ca2e47-9c25-c394-51e5-067ebaa66538@omp.ru>
 <OS0PR01MB5922A72D9E04C359C64ACE4486AE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <fb9d4094-6458-f0b3-9e41-be5903f2800e@gmail.com>
Date:   Mon, 4 Oct 2021 18:50:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB5922A72D9E04C359C64ACE4486AE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/21 4:12 PM, Biju Das wrote:

>> Subject: Re: [PATCH 05/10] ravb: Initialize GbEthernet DMAC
>>
>> Hello!
>>
>> On 10/1/21 6:06 PM, Biju Das wrote:
>>
>>> Initialize GbEthernet DMAC found on RZ/G2L SoC.
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>> ---
>>> RFC->v1:
>>>  * Removed RIC3 initialization from DMAC init, as it is
>>>    same as reset value.
>>
>>    I'm not sure we do a reset everytime...
>>
>>>  * moved stubs function to earlier patches.
>>>  * renamed "rgeth" with "gbeth"
>>> ---
>>>  drivers/net/ethernet/renesas/ravb.h      |  3 ++-
>>>  drivers/net/ethernet/renesas/ravb_main.c | 30
>>> +++++++++++++++++++++++-
>>>  2 files changed, 31 insertions(+), 2 deletions(-)
>>>
>> [...]
>>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
>>> b/drivers/net/ethernet/renesas/ravb_main.c
>>> index dc817b4d95a1..5790a9332e7b 100644
>>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>>> @@ -489,7 +489,35 @@ static void ravb_emac_init(struct net_device
>>> *ndev)
>>>
>>>  static int ravb_dmac_init_gbeth(struct net_device *ndev)  {
>>> -	/* Place holder */
>>> +	int error;
>>> +
>>> +	error = ravb_ring_init(ndev, RAVB_BE);
>>> +	if (error)
>>> +		return error;
>>> +
>>> +	/* Descriptor format */
>>> +	ravb_ring_format(ndev, RAVB_BE);
>>> +
>>> +	/* Set AVB RX */
>>
>>    AVB? We don't have it, do we?
> 
> Good catch. I Will update the comment in next RFC patch.

   That's trifles, not worth a patch on its own...

>>
>>> +	ravb_write(ndev, 0x60000000, RCR);
>>
>>    Not even RCR.EFFS? And what do bits 29..30 mean?
> 
> RZ/G2L Bit 31 is reserved.
> Bit 16:30 Reception fifo critical level.
> Bit 15:1 reserved
> Bit 0 : EFFS
> 
> I am not sure, where do you get 29..30? can you please clarify.

   0x60000000 has bits 29..30 set and gen3 manual has these bits reserved. 

>> [...]
>>> +	/* Set FIFO size */
>>> +	ravb_write(ndev, 0x00222200, TGC);
>>
>>    Do TBD<n> (other than TBD0) fields even exist?
> 
> Only TBD (Bit 8..9) is available to write,

   Thought so! :-)

> rest all are reserved with remaining values
> as in "0x00222200"

  Oh, so the defaluts are the sme on RZ/G2L, despite only 1 TX queue?

> Regds,
> Biju

MBR, Sergey
