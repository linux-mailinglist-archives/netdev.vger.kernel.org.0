Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7405BC06
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 14:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfGAMov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 08:44:51 -0400
Received: from mx.0dd.nl ([5.2.79.48]:53902 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfGAMou (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 08:44:50 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id D5BDF5FBBA;
        Mon,  1 Jul 2019 14:44:47 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="s0QcYMee";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 987321CEAE35;
        Mon,  1 Jul 2019 14:44:47 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 987321CEAE35
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1561985087;
        bh=HD07xirr5v6niPTGZlUhmDwV64b2Isb4hPBudEVnkxk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s0QcYMee9v616AwnQE7o/KyMHJxWrvg97rhqGBYBzqm7tI0neQIrXhvAbSBmhKD0+
         /juQUY3TY4xroXrrElNvz1V++cvQ9wtf5nM5LuobL7BkndHbv22WzCweGQqJsDDnTg
         87kZhwVKbdlzjOoza5+aDtYM8sMc3hljar5K7IK+h/VoQR/8VLA0qF5Y57clNp4C5S
         plDuc8y69EsLzYbknY1SYBI1wncJ+k1DJr7POylVHUzUE8yGeksp2qPsebQTWRJi7K
         ZuVu6tF653OM8/MM1J4JjnR9RkkGyelUFVjAy5w370fGK5xhltvIZCKNLgi+nq9057
         3mrWYN1W7NaFw==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Mon, 01 Jul 2019 12:44:47 +0000
Date:   Mon, 01 Jul 2019 12:44:47 +0000
Message-ID: <20190701124447.Horde.RNUh-fSQf6XMauvPaGIYpKj@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, David Miller <davem@davemloft.net>,
        matthias.bgg@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        frank-w@public-files.de,
        Network Development <netdev@vger.kernel.org>,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: mediatek: Fix overlapping capability
 bits.
References: <20190629122419.19026-1-opensource@vdorst.com>
 <CA+FuTSdr8HCRJTE8pEVxsga3N-xx-fEAxzKAAyPFWH6doVRHbQ@mail.gmail.com>
In-Reply-To: <CA+FuTSdr8HCRJTE8pEVxsga3N-xx-fEAxzKAAyPFWH6doVRHbQ@mail.gmail.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Willem de Bruijn <willemdebruijn.kernel@gmail.com>:

> On Sat, Jun 29, 2019 at 8:24 AM René van Dorst <opensource@vdorst.com> wrote:
>>
>> Both MTK_TRGMII_MT7621_CLK and MTK_PATH_BIT are defined as bit 10.
>>
>> This causes issues on non-MT7621 devices which has the
>> MTK_PATH_BIT(MTK_ETH_PATH_GMAC1_RGMII) capability set.
>> The wrong TRGMII setup code is executed.
>>
>> Moving the MTK_PATH_BIT to bit 11 fixes the issue.
>>
>> Fixes: 8efaa653a8a5 ("net: ethernet: mediatek: Add MT7621 TRGMII mode
>> support")
>> Signed-off-by: René van Dorst <opensource@vdorst.com>
>
> This targets net? Please mark networking patches [PATCH net] or [PATCH
> net-next].

Hi Willem,

Thanks for you input.

This patch was for net-next.

>
>> ---
>>  drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h  
>> b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
>> index 876ce6798709..2cb8a915731c 100644
>> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
>> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
>> @@ -626,7 +626,7 @@ enum mtk_eth_path {
>>  #define MTK_TRGMII_MT7621_CLK          BIT(10)
>>
>>  /* Supported path present on SoCs */
>> -#define MTK_PATH_BIT(x)         BIT((x) + 10)
>>
>> +#define MTK_PATH_BIT(x)         BIT((x) + 11)
>>
>
> To avoid this happening again, perhaps make the reserved range more explicit?
>
> For instance
>
> #define MTK_FIXED_BIT_LAST 10
> #define MTK_TRGMII_MT7621_CLK  BIT(MTK_FIXED_BIT_LAST)
>
> #define MTK_PATH_BIT_FIRST  (MTK_FIXED_BIT_LAST + 1)
> #define MTK_PATH_BIT_LAST (MTK_FIXED_BIT_LAST + 7)
> #define MTK_MUX_BIT_FIRST (MTK_PATH_BIT_LAST + 1)
>
> Though I imagine there are cleaner approaches. Perhaps define all
> fields as enum instead of just mtk_eth_mux and mtk_eth_path. Then
> there can be no accidental collision.

You mean in a similar way as done in the ethtool.h [0]?

Use a enum to define the unique bits.

enum mtk_bits {
	MTK_RGMII_BIT = 0,
	MTK_SGMII_BIT,
	MTK_TRGMII_BIT,
	AND SO ON ....
};

Also move the mtk_eth_mux and mtk_eth_path in to this enum.

Then use defines to convert bits to values.

#define MTK_RGMII  BIT(MTK_RGMII_BIT)
#define MTK_TRGMII BIT(MTK_TRGMII_BIT)

Replace the MTK_PATH_BIT and MTK_PATH_BIT macro with BIT()

Is this what you had in mind?

Greats,

René

[0]:  
https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/ethtool.h#L1402



