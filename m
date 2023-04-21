Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F9A6EB19F
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 20:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbjDUS2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 14:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbjDUS2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 14:28:37 -0400
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223111BD5;
        Fri, 21 Apr 2023 11:28:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682101673; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=SaSBoPob1vx8UxWGw/1V+TbNRkGJAsK90tRye9/VlpgU8VwLnDSHghVoWUYgAjhPjoRrCWPMCItu6Twjq/fMouX8cle3IP85FsAzQ+fuTOMJmV5hyfaI60KAaEpIB/vcn4xbhatpIi6wyGmnthH1/wbL4H8s7U2zI4yryNVrGJw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682101673; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=HhtGCpgs8VG3ou8855pH8L7tkz77AnXTHtobCoUAuVM=; 
        b=jDUZmxX2h5DWOd56WLqqY9Owk6FnqPIR/pjpPBoRhXGffhpEG2g6jacEeok7CPfMWcXKqXOzA3fnFRfr7ixvriIPCROSr12kBjLl+wwxcdmvK4iU4832VvBUlD6ZpN+GV/UISRD/tKMd2OnKwmjglhADyikmXLq165b5dpL6p0U=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682101673;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=HhtGCpgs8VG3ou8855pH8L7tkz77AnXTHtobCoUAuVM=;
        b=Y4ageSokWBom/G2ZCmFb/b81B/hbHdFJvx36UnHpALK+9EHjrIBm1URAAg1Ra1hW
        zPny3BfiOWOHfbi26F2qoXjgHI4nSL9KeR0quy6dEeAEPYHP63eaiDKdgtiimB8c9Tv
        gRdrOTcPG0Ix59uu3nHkY8IwbIQc9FTHmFcxDIAc=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1682101672038904.708571478262; Fri, 21 Apr 2023 11:27:52 -0700 (PDT)
Message-ID: <6493c52f-247c-c9c0-8352-4b312b7e67e4@arinc9.com>
Date:   Fri, 21 Apr 2023 21:27:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH net-next 02/22] net: dsa: mt7530: use
 p5_interface_select as data type for p5_intf_sel
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230421143648.87889-1-arinc.unal@arinc9.com>
 <20230421143648.87889-3-arinc.unal@arinc9.com>
 <ZEK4gVx-WQv0j2cR@makrotopia.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZEK4gVx-WQv0j2cR@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.04.2023 19:23, Daniel Golle wrote:
> On Fri, Apr 21, 2023 at 05:36:28PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> Use the p5_interface_select enumeration as the data type for the
>> p5_intf_sel field. This ensures p5_intf_sel can only take the values
>> defined in the p5_interface_select enumeration.
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   drivers/net/dsa/mt7530.h | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
>> index 845f5dd16d83..703f8a528317 100644
>> --- a/drivers/net/dsa/mt7530.h
>> +++ b/drivers/net/dsa/mt7530.h
>> @@ -674,13 +674,13 @@ struct mt7530_port {
>>   };
>>   
>>   /* Port 5 interface select definitions */
>> -enum p5_interface_select {
>> -	P5_DISABLED = 0,
>> +typedef enum {
> 
> We usually avoid adding typedef in kernel code. If the purpose is
> just to be more verbose in the struct definition, you can as well
> also just use 'enum p5_interface_select as type in the struct.
> 
>> +	P5_DISABLED,
>>   	P5_INTF_SEL_PHY_P0,
>>   	P5_INTF_SEL_PHY_P4,
>>   	P5_INTF_SEL_GMAC5,
>>   	P5_INTF_SEL_GMAC5_SGMII,
>> -};
>> +} p5_interface_select;
>>   
>>   struct mt7530_priv;
>>   
>> @@ -768,7 +768,7 @@ struct mt7530_priv {
>>   	bool			mcm;
>>   	phy_interface_t		p6_interface;
>>   	phy_interface_t		p5_interface;
>> -	unsigned int		p5_intf_sel;
>> +	p5_interface_select	p5_intf_sel;
> 
> enum p5_interface_select	p5_intf_sel;

Will do, thanks.

Arınç
