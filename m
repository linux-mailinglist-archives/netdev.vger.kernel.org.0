Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37C91FF90F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731453AbgFRQTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 12:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbgFRQTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:19:12 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289FAC06174E;
        Thu, 18 Jun 2020 09:19:11 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id q2so4248614wrv.8;
        Thu, 18 Jun 2020 09:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8WbWb/rh17O2FOPGzHzwKOpepFQSzXzuV1eAuPNrEak=;
        b=mljGeutj7UU8b1Y0O2M3yVHAaoqSYhqxn/1afiqMJZJpSMUY+32Gyf8Tvyj/oW+kq7
         FIgG7+uUWLNsAkD/iXE4P5XF3/VdUXdADvIQZBayJseob9MWvBoPpalg/dQ8U1WDNJ6h
         LQXSabLZuVeq6t6//8dTrWZHiJKNcgTc2RRdu7WhBL5tcR7FBhdPJQzemi65u+/cwEhI
         VycskAY2JbwMbjQBUepz5Mbv+t2YFv6Z8izKnGEDZ8rtdLUK0cuE33npqjLiQKopRz2z
         FzBpJ7zEVDCOVEAWPzFkRjsvcScXej8x78lv4gq9gJHpglcafZrsusnxjWCxrHywfkPg
         4NGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8WbWb/rh17O2FOPGzHzwKOpepFQSzXzuV1eAuPNrEak=;
        b=KAFu6d1UzACLzPXtRUAcrcPFAjU/jLdajH1iHr/EcG2WNDD8TFN2N4rUhqXwqj8iwX
         b6OrKCWSGY0S385vANEaEhGfHscLTSlY6kZiCmhhsPBUYglI/SnRUC7Fq62FA6HlS0r2
         MFPP2F2+6WYKrTpRxD3upefC7yN0LgSsOJ5SPec9vSxK9Gu18md710y3BEJk0ZAcrnlc
         obvsBJc437kq1EqsF6raNmZjrFYwEzuvRR4DhIQqw+TxMcbcS6RRMvvIV/33NHQkwk9s
         D5w6PgHc+xUYE2LxIfQ1qrQJE1jmh2lKXQB2A1An4KZq2+1TJgJxIwd824VvQ2e3kxUF
         GZzg==
X-Gm-Message-State: AOAM533tXl2tFSJhZb9hooxjXUxWaMdQHR6cEfUS89bdIC3We5XyIJse
        1CjICDMDaV5r2ig0yZF9Q8KSd8DZ
X-Google-Smtp-Source: ABdhPJza/9Oyu5LS/XiF0vHJyPK5HtUWpZdrviopBqelEtl9zOklzWaZHM1/5DChsp5VNDlnWhKadQ==
X-Received: by 2002:a5d:6a03:: with SMTP id m3mr5308757wru.293.1592497149579;
        Thu, 18 Jun 2020 09:19:09 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id e8sm2368235wrv.24.2020.06.18.09.19.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 09:19:09 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Fix node reference count
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200618034245.29928-1-f.fainelli@gmail.com>
 <20200618125640.GL249144@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d00c5ca2-5c49-b558-0dfd-fd3e9391abf4@gmail.com>
Date:   Thu, 18 Jun 2020 09:19:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200618125640.GL249144@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/2020 5:56 AM, Andrew Lunn wrote:
> On Wed, Jun 17, 2020 at 08:42:44PM -0700, Florian Fainelli wrote:
>> of_find_node_by_name() will do an of_node_put() on the "from" argument.
> 
>> Fixes: afa3b592953b ("net: dsa: bcm_sf2: Ensure correct sub-node is parsed")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  drivers/net/dsa/bcm_sf2.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
>> index c1bd21e4b15c..9f62ba3e4345 100644
>> --- a/drivers/net/dsa/bcm_sf2.c
>> +++ b/drivers/net/dsa/bcm_sf2.c
>> @@ -1154,6 +1154,8 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
>>  	set_bit(0, priv->cfp.used);
>>  	set_bit(0, priv->cfp.unique);
>>  
>> +	/* Balance of_node_put() done by of_find_node_by_name() */
>> +	of_node_get(dn);
>>  	ports = of_find_node_by_name(dn, "ports");
> 
> That if_find_node_by_name() does a put is not very intuitive.
> Maybe document that as well in the kerneldocs?

Yes that is the plan, most callers call it with a NULL from argument but
that is a bit silly if you know what the Device Tree looks like, you can
search quicker to the target node. Thanks.

> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
>     Andrew
> 

-- 
Florian
