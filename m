Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81CC23AE16
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgHCU3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCU3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:29:19 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747D4C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 13:29:19 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id z5so20760158pgb.6
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 13:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ir//bpbhYK6988NhakmzJsV/J3PpqH6dBLAxj2tIrPk=;
        b=gsOROzs4GPiQ4iw5cAA+0MoYP26WuLwnwJN784QwDi46CIsRH5A4eSaR5uxkrdt6sT
         a/waU5JREf6vyVenmV5XqB0IRpkXtPQiO8QyGljRjV/w0L7zlEJZpRNd3ItrK7Nt+MXW
         HXStE/GRBOTWb3rmt6hdk6LDdtE9jAhoaO88gZVKfV76wrVuN0HtJGWkuTp2VyaTwqvg
         0E91XB35LSmnVeNgT+vSP1Kxy7oQSg4tV/xDxd5WwItDPzy7Kz4Jv0EnDVCzT+xyBtsv
         LxmO2K4z0Hf2ooK4Iji6k/79IDFoxYds6mK1+TU8z7uRPjE8RVsUTBGozM5TUNkb7LeY
         Zkdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ir//bpbhYK6988NhakmzJsV/J3PpqH6dBLAxj2tIrPk=;
        b=NF2gntNa2wS4PF8o7iFwmy5kzJJhJSY8hSTpkIlMb2P6Z+BjeU4Fj4r2pyy4GofBnS
         1FmYb4R/x+Z2vb5P4pbTxw+9iLpapN3YlfMr6On+AOUkqazZRiHSgnmWuUYI6PzLaq/a
         jH02v70CrUuNFeuOs0qBDJx46EmNAFMN6D+Hr5VBtI3UEwgJp2/XUFN6arkKahxzn5wM
         9CFvKYIwqHdRHuTlUwSp0dk6525+6VaLKV7pyAi21yEC5/sv/joQVJ+hAgly9QLXcxAB
         hAmyQDlyh+KX2PsFJbmu3x8D+QjIdMPNowOsTYpDcBoH3FTiwWwAkgmkKXKvTX+MI2hO
         4C0Q==
X-Gm-Message-State: AOAM530U0N8Tlo7MMBY03XxMxubdicJd7H5LMHAYiVkLbd9ROm6XooIp
        Grsz8bw1jiXd62Ay6kkm6rA=
X-Google-Smtp-Source: ABdhPJzSEIoiDghhOeOGeDdYGd56KJ5nLKIg4a5a6d3U9rRYI48t7M9a7rylFdDDM4NW2OgzwrmHTQ==
X-Received: by 2002:a63:5f04:: with SMTP id t4mr6537464pgb.308.1596486559006;
        Mon, 03 Aug 2020 13:29:19 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m23sm177291pgv.43.2020.08.03.13.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 13:29:18 -0700 (PDT)
Subject: Re: [PATCH net-next 2/5] net: dsa: loop: Support 4K VLANs
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200803200354.45062-1-f.fainelli@gmail.com>
 <20200803200354.45062-3-f.fainelli@gmail.com>
 <20200803202735.GB1919070@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <585749fb-18fa-973b-57f2-05fd03bd9fdb@gmail.com>
Date:   Mon, 3 Aug 2020 13:29:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200803202735.GB1919070@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/3/2020 1:27 PM, Andrew Lunn wrote:
> On Mon, Aug 03, 2020 at 01:03:51PM -0700, Florian Fainelli wrote:
>> Allocate a 4K array of VLANs instead of limiting ourselves to just 5
>> which is arbitrary.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  drivers/net/dsa/dsa_loop.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
>> index 4a57238cdfd8..6e97b44c6f3f 100644
>> --- a/drivers/net/dsa/dsa_loop.c
>> +++ b/drivers/net/dsa/dsa_loop.c
>> @@ -48,12 +48,10 @@ struct dsa_loop_port {
>>  	u16 pvid;
>>  };
>>  
>> -#define DSA_LOOP_VLANS	5
>> -
>>  struct dsa_loop_priv {
>>  	struct mii_bus	*bus;
>>  	unsigned int	port_base;
>> -	struct dsa_loop_vlan vlans[DSA_LOOP_VLANS];
>> +	struct dsa_loop_vlan vlans[VLAN_N_VID];
>>  	struct net_device *netdev;
>>  	struct dsa_loop_port ports[DSA_MAX_PORTS];
> 
> That is 4K x (2 x u16) = 16K RAM. I suppose for a test driver which is
> never expected to be used in production, that is O.K.

I think so too, if we are worried we could switch to vmalloc() down the
road.

> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
>     Andrew
> 

-- 
Florian
