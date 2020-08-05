Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE3123CF00
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgHETLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:11:50 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:53462 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgHETKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 15:10:31 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 075IqwJU062765;
        Wed, 5 Aug 2020 13:52:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1596653578;
        bh=mPHLH8mNp+iVjY7OLSuSpUU1EWSn3dk/JVXrDKmY+iQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=T8SR2HMtv4vZ6Fm3f/vLEvP1V+y7gdmF+WzH7R8+EaoxzNIQ+4KC0waCeSiReLYWN
         Ht1Mn4onAfj1+E4Dwg3C6Ioq2LDm2+/U12Irvejcns3IMnDhRrkx0eNquoJ5zPRuCy
         yMcg5VVQnR7Tq5VZD758TpIftVZGXudYxV9oTJy0=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 075Iqwkm111913
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 5 Aug 2020 13:52:58 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 5 Aug
 2020 13:52:58 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 5 Aug 2020 13:52:58 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 075Iqpm1001834;
        Wed, 5 Aug 2020 13:52:53 -0500
Subject: Re: [PATCH v3 6/9] ethernet: ti: cpts: Use generic helper function
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, <netdev@vger.kernel.org>,
        Petr Machata <petrm@mellanox.com>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-7-kurt@linutronix.de>
 <81037828-42e0-e584-30dd-23052fa82ee9@gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <96c57989-49bc-a0e7-2dae-e19e23be64b7@ti.com>
Date:   Wed, 5 Aug 2020 21:52:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <81037828-42e0-e584-30dd-23052fa82ee9@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02/08/2020 23:22, Florian Fainelli wrote:
> 
> 
> On 7/30/2020 1:00 AM, Kurt Kanzenbach wrote:
>> In order to reduce code duplication between ptp drivers, generic helper
>> functions were introduced. Use them.
>>
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> ---
> [snip]
>> -	if (unlikely(ptp_class & PTP_CLASS_V1))
>> -		msgtype = data + offset + OFF_PTP_CONTROL;
>> -	else
>> -		msgtype = data + offset;
>> +	msgtype = ptp_get_msgtype(hdr, ptp_class);
>> +	seqid	= be16_to_cpu(hdr->sequence_id);
> 
> Same comment as patch 5 would probably apply here as well, with using
> ntohs():
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>


As reported in [1] this patch as is broke cpts and below diff on top restore it

[1] https://lore.kernel.org/netdev/20200805152503.GB9122@hoboy/T/#mcf2bd0322805e6706ee9fe4f10805e657fd0103e

-- 
Best regards,
grygorii

---------------
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -509,6 +509,11 @@ void cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb)
         int ret;
         u64 ns;
  
+       /* cpts_rx_timestamp() is called before eth_type_trans(), so
+        * skb MAC Hdr properties are not configured yet. Hence need to
+        * rest skb MAC header here
+        */
+       skb_reset_mac_header(skb);
         ret = cpts_skb_get_mtype_seqid(skb, &skb_cb->skb_mtype_seqid);
         if (!ret)
                 return;
