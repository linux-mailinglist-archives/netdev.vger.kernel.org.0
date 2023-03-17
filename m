Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676CD6BEA9C
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjCQOCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjCQOCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:02:53 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C843BD8D;
        Fri, 17 Mar 2023 07:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679061761; x=1710597761;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EbxyFzwhGnzm6N3+52K5AIVU3ya3miKE6ahWS/Pki3M=;
  b=MIcbjUCkNRlvfxQqs65A4o7d7Y1vvgg8/8JUzCKRVOHqYFp/ubUTJIkH
   q/VYI1XW5XXtSp3YTwgmjO31T+6ki7tr0FijHEbwarOT5AXtUm7PJp3NN
   V1eElq22am5nOCvAz5hcCOWjrVkzHpEjEOmhRYzl5l4Rhe6jB1qFpM2of
   V5IbGh/9sWe3iCo0yzBrQOIHAHwN+IsbXCjIajTvbliTTWriRtBu974zU
   AEYpK4ypTL6JRAbGLBqEIjC3JWGiVo07HbNhD3p8PftpVIQu+iXfOTid2
   E1ETJ6vHY4vFjvn2L+ukZZRh3Uw8n0D6kyjvHKXs0t5eHgAukMRUUxJ1u
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,268,1673938800"; 
   d="scan'208";a="205222557"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2023 07:02:40 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 07:02:39 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 17 Mar 2023 07:02:37 -0700
Message-ID: <3a625bc5-80ed-925d-2e16-bc3535320963@microchip.com>
Date:   Fri, 17 Mar 2023 15:02:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] net: macb: Set MDIO clock divisor for pclk higher than
 160MHz
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Bartosz Wawrzyniak <bwawrzyn@cisco.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <claudiu.beznea@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xe-linux-external@cisco.com>, <danielwa@cisco.com>,
        <olicht@cisco.com>, <mawierzb@cisco.com>
References: <20230316100339.1302212-1-bwawrzyn@cisco.com>
 <7f3d0f2c-8bf9-41aa-8a7f-79407753df3b@lunn.ch>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <7f3d0f2c-8bf9-41aa-8a7f-79407753df3b@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew,

On 16/03/2023 at 20:34, Andrew Lunn wrote:
> On Thu, Mar 16, 2023 at 10:03:39AM +0000, Bartosz Wawrzyniak wrote:
>> Currently macb sets clock divisor for pclk up to 160 MHz.
>> Function gem_mdc_clk_div was updated to enable divisor
>> for higher values of pclk.
>>
>> Signed-off-by: Bartosz Wawrzyniak <bwawrzyn@cisco.com>
>> ---
>>   drivers/net/ethernet/cadence/macb.h      | 2 ++
>>   drivers/net/ethernet/cadence/macb_main.c | 6 +++++-
>>   2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
>> index 14dfec4db8f9..c1fc91c97cee 100644
>> --- a/drivers/net/ethernet/cadence/macb.h
>> +++ b/drivers/net/ethernet/cadence/macb.h
>> @@ -692,6 +692,8 @@
>>   #define GEM_CLK_DIV48                                3
>>   #define GEM_CLK_DIV64                                4
>>   #define GEM_CLK_DIV96                                5
>> +#define GEM_CLK_DIV128                               6
>> +#define GEM_CLK_DIV224                               7
> 
> Do these divisors exist for all variants? I'm just wondering why these
> are being added now, rather than back in 2011-03-09.

I see them existing in all variants of "GEM" controller and the older 
"MACB" uses a different path so I think that we are save enabling these 
values.

The values were not added back in the days because the SoC where the 
controller was used didn't reach the frequencies that we are observing 
today for pclk. Divisors weren't needed and field even not completely 
described in Microchip datasheets.

Hope that this sheds some light. Best regards,
   Nicolas

-- 
Nicolas Ferre

