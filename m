Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD2E5E4C1
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 15:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfGCNBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 09:01:42 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35432 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCNBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 09:01:42 -0400
Received: by mail-qt1-f193.google.com with SMTP id d23so2913298qto.2;
        Wed, 03 Jul 2019 06:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zOwWMRCLSzYayOqA0/S/uTmbNChTaq0MzbltnUW5FxI=;
        b=Ij7RZFuK5WQRiu8VSbvHSEhaJa/mnsaU9/5GhZF6CnxeIMzhTdAuqc96aLTEdFXXMK
         yhBCFDrXKbouUzWN3Wq1gZf4qijAl1KOlRPwX0Utt+txkqQ+U4+vBSeGMUoi6Lvqn2v6
         2leRJ39y6Fqh2uSDd2QxLoHAy8Kx/94WAFTRAisIzjfla05vWZeG+5iFYIa5TjLdHWYt
         YPW8YkLBOKbvMW0LQQX0jWMN6WfWbgeIKrQ61FiVH1gpIUcEUpKXxBwBrSbkmMTB0ix6
         7bBcdie+ko5W8MdakCdhk8BeYQUScEPtzJtVI/0LhHok751xTTFwoghZS0o6pD4GjLYH
         49EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zOwWMRCLSzYayOqA0/S/uTmbNChTaq0MzbltnUW5FxI=;
        b=rUHXO6M/sQUWXdRM54i9ex2F86TCbRyCuUordULC6cWNqGlQobZK7ezALh0Wx8rq2G
         uvqLG/cWT0czXSYgSNVXNDV3enjluoPyUhb25/ApeV/otoVevYOtrlgtwilHfyQ8zqyq
         eGS9vEhpHadab+Q++KCrFmCHTSoaexh9gH+oBmD6dgzmYcOY3WJ9WbGoGTm/SOJb60tW
         SlyHpiyRDEfFPsc9Bv7FueafVdnDy4mgQ2EPGc+XOoqYKVK+CU1ckZHLlUP8zzBfa0/U
         cYCsu+zVNqaDSvgsts+FnX7rGaS5cjhBGchHo4AeN4ib8KXrIUQ48cnntSo8mlJfim4E
         WO+Q==
X-Gm-Message-State: APjAAAWZFPXqUztqESnvzAP4G4Lkj7KA+msHbSQvplKzCI4plDssjE7Z
        Zv3n3vWKuZI5GOU7/GUho/k=
X-Google-Smtp-Source: APXvYqymLHrXn9+dZNQRLMDmXjtfMhrejm/JMPcr1rvuLJJOMPHIW3gnrvBehpb3Z2r96ynnnDbLCA==
X-Received: by 2002:aed:39e5:: with SMTP id m92mr29964740qte.135.1562158900632;
        Wed, 03 Jul 2019 06:01:40 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d9::105b? ([2620:10d:c091:480::2a6d])
        by smtp.gmail.com with ESMTPSA id s127sm870575qkd.107.2019.07.03.06.01.39
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 06:01:40 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH] rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
References: <20190627095247.8792-1-chiu@endlessm.com>
 <31f59db2-0e04-447b-48f8-66ea53ebfa7d@gmail.com>
 <CAB4CAwcEdcg91Bgb+JoCdk_zQKsWT-K+cb07-5mrrx+__X2RMA@mail.gmail.com>
Message-ID: <afa1e967-dba0-d6ea-fe62-67a9411638a7@gmail.com>
Date:   Wed, 3 Jul 2019 09:01:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAB4CAwcEdcg91Bgb+JoCdk_zQKsWT-K+cb07-5mrrx+__X2RMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/2/19 11:25 PM, Chris Chiu wrote:
> On Tue, Jul 2, 2019 at 8:44 PM Jes Sorensen <jes.sorensen@gmail.com> wrote:
>>
>> On 6/27/19 5:52 AM, Chris Chiu wrote:
>>> The WiFi tx power of RTL8723BU is extremely low after booting. So
>>> the WiFi scan gives very limited AP list and it always fails to
>>> connect to the selected AP. This module only supports 1x1 antenna
>>> and the antenna is switched to bluetooth due to some incorrect
>>> register settings.
>>>
>>> This commit hand over the antenna control to PTA, the wifi signal
>>> will be back to normal and the bluetooth scan can also work at the
>>> same time. However, the btcoexist still needs to be handled under
>>> different circumstances. If there's a BT connection established,
>>> the wifi still fails to connect until disconneting the BT.
>>>
>>> Signed-off-by: Chris Chiu <chiu@endlessm.com>
>>> ---
>>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 9 ++++++---
>>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 3 ++-
>>>  2 files changed, 8 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
>>> index 3adb1d3d47ac..6c3c70d93ac1 100644
>>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
>>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
>>> @@ -1525,7 +1525,7 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
>>>       /*
>>>        * WLAN action by PTA
>>>        */
>>> -     rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x04);
>>> +     rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x0c);
>>>
>>>       /*
>>>        * BT select S0/S1 controlled by WiFi
>>> @@ -1568,9 +1568,12 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
>>>       rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.ant_sel_rsv));
>>>
>>>       /*
>>> -      * 0x280, 0x00, 0x200, 0x80 - not clear
>>> +      * Different settings per different antenna position.
>>> +      * Antenna switch to BT: 0x280, 0x00 (inverse)
>>> +      * Antenna switch to WiFi: 0x0, 0x280 (inverse)
>>> +      * Antenna controlled by PTA: 0x200, 0x80 (inverse)
>>>        */
>>> -     rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
>>> +     rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x80);
>>>
>>>       /*
>>>        * Software control, antenna at WiFi side
>>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>>> index 8136e268b4e6..87b2179a769e 100644
>>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>>> @@ -3891,12 +3891,13 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
>>>
>>>       /* Check if MAC is already powered on */
>>>       val8 = rtl8xxxu_read8(priv, REG_CR);
>>> +     val16 = rtl8xxxu_read16(priv, REG_SYS_CLKR);
>>>
>>>       /*
>>>        * Fix 92DU-VC S3 hang with the reason is that secondary mac is not
>>>        * initialized. First MAC returns 0xea, second MAC returns 0x00
>>>        */
>>> -     if (val8 == 0xea)
>>> +     if (val8 == 0xea || !(val16 & BIT(11)))
>>>               macpower = false;
>>>       else
>>>               macpower = true;
>>
>> This part I would like to ask you take a good look at the other chips to
>> make sure you don't break support for 8192cu, 8723au, 8188eu with this.
>>
>> Cheers,
>> Jes
> 
> I checked the vendor code of 8192cu and 8188eu, they don't have this part
> of code to check the REG_CR before power on sequence. I can only find
> similar code in rtl8723be.
> if (tmp_u1b != 0 && tmp_u1b !=0xea)
>     rtlhal->mac_func_enable = true;
> 
> By definition, the BIT(11) of REG_SYS_CLKR in rtl8xxxu_regs.h is
> SYS_CLK_MAC_CLK_ENABLE. It seems to make sense to check this value
> for macpower no matter what chip it is. I think I can make it more
> self-expressive
> as down below.
> 
>  if (val8 == 0xea || !(val16 & SYS_CLK_MAC_CLK_ENABLE))

Yes, please always use the descriptive defines rather than hard coding
the bit numbers.

> And per the comment, this code is for 92DU-VC S3 hang problem and I think an
> OR check for SYS_CLK_MAC_CLK_ENABLE is still safe for this.

Sounds reasonable - keep in mind that some of these bugs may have been
fixed for one chip, and then just copied forward.

Cheers,
Jes
