Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CF53161D1
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhBJJKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhBJJEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:04:48 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AC1C061756;
        Wed, 10 Feb 2021 01:04:05 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id w4so1135766wmi.4;
        Wed, 10 Feb 2021 01:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=glEqUJGEBd/fOME9jfBAMFBavuhpbO//etL8K9JgZ4M=;
        b=oE0vkUeEIh2AmBXcV4iMa7zW7qT4lgH+zrhdIn0ryOjn4Q1ZsLKdQMZltnxL1JfF/h
         hFIdv1p5Y0nypgZ1MKiqEfDCQaM4lEpgowylHKAkFfsOgJfUXgkl/IfqL+O1UVmbiNVK
         YXo9gXV0AFz0S3+EyIWep37w2I0uuVKWwTQ7Ril+wVfEHJ7+6OzmUH7bVqRS1Mcp8+Ud
         vJV8/ry15lhWY8//JSIRiVByl97N8yRSVGtiimV7JuxQaYw2RVDXMm+AgFAiXufkGNIg
         QqkMZCAUyuoS6+1VefnLChI5iEmeNij2iKlv0KKpv+jWE3t1JzynNQYswMU2Q2uhR0Zk
         LJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=glEqUJGEBd/fOME9jfBAMFBavuhpbO//etL8K9JgZ4M=;
        b=tfUrpF/Xb+EEAADtge1v8GnHRf31bg8USI9AmbS9zmvDKoe9EgEXRbNhqGOiMzZ14L
         AjTg5qtG4MLH3yH7NrmuzUGhFyuCmYLbmbnHtdZl0qlSBjjIW2qQJy0F+gAL4yGZHdkw
         3GUMKo0KqUORSM83dUS/7+PxYea0Y0YqRmueaTeIODRG1THad4GI7VvnqbBt0+b1oW7e
         LWaZJeaIq31qLyKt5IOJBCIjkbLrO0/Pw5Y7mWLPpsYjVVufQnASMDN076CVtR7kGWo7
         j0xZoGLv6jBKLZjY8tWwxteIOHYDOk8vqRBR06Dt8NDBQ+dkl+vh7lCt8k+GU6gDKi/2
         y+wA==
X-Gm-Message-State: AOAM532cuCwPgAC48DkH7HTUZ+3P+E39BqlQ8hEtvxjOCRiU//zhJD5M
        g3gxSiz90TBl5vNnF+Lp3g0yaLL9r0f3Cw==
X-Google-Smtp-Source: ABdhPJwF7MaqLyerBnqd14Tw0z+8d2qrsAAbLGJka4YNdKyP1v8Yog66PXNRm0GwCxkvN2+5zUxQQQ==
X-Received: by 2002:a1c:3cd6:: with SMTP id j205mr1980180wma.166.1612947839023;
        Wed, 10 Feb 2021 01:03:59 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:b0ff:e539:9460:c978? (p200300ea8f1fad00b0ffe5399460c978.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:b0ff:e539:9460:c978])
        by smtp.googlemail.com with ESMTPSA id d23sm1734510wmd.11.2021.02.10.01.03.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 01:03:58 -0800 (PST)
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-8-michael@walle.cc>
 <d5672062-c619-02a4-3bbe-dad44371331d@gmail.com>
 <e9d26cd6634a8c066809aa92e1481112@walle.cc>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 7/9] net: phy: icplus: select page before writing
 control register
Message-ID: <1656b889-12c4-b376-5cdf-38e1dcc500bc@gmail.com>
Date:   Wed, 10 Feb 2021 10:03:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <e9d26cd6634a8c066809aa92e1481112@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.02.2021 09:25, Michael Walle wrote:
> Hi,
> 
> Am 2021-02-10 08:03, schrieb Heiner Kallweit:
>> On 09.02.2021 17:40, Michael Walle wrote:
>>> Registers >= 16 are paged. Be sure to set the page. It seems this was
>>> working for now, because the default is correct for the registers used
>>> in the driver at the moment. But this will also assume, nobody will
>>> change the page select register before linux is started. The page select
>>> register is _not_ reset with a soft reset of the PHY.
>>>
>>> Add read_page()/write_page() support for the IP101G and use it
>>> accordingly.
>>>
>>> Signed-off-by: Michael Walle <michael@walle.cc>
>>> ---
>>>  drivers/net/phy/icplus.c | 50 +++++++++++++++++++++++++++++++---------
>>>  1 file changed, 39 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
>>> index a6e1c7611f15..858b9326a72d 100644
>>> --- a/drivers/net/phy/icplus.c
>>> +++ b/drivers/net/phy/icplus.c
>>> @@ -49,6 +49,8 @@ MODULE_LICENSE("GPL");
>>>  #define IP101G_DIGITAL_IO_SPEC_CTRL            0x1d
>>>  #define IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32        BIT(2)
>>>
>>> +#define IP101G_DEFAULT_PAGE            16
>>> +
>>>  #define IP175C_PHY_ID 0x02430d80
>>>  #define IP1001_PHY_ID 0x02430d90
>>>  #define IP101A_PHY_ID 0x02430c54
>>> @@ -250,23 +252,25 @@ static int ip101a_g_probe(struct phy_device *phydev)
>>>  static int ip101a_g_config_init(struct phy_device *phydev)
>>>  {
>>>      struct ip101a_g_phy_priv *priv = phydev->priv;
>>> -    int err;
>>> +    int oldpage, err;
>>> +
>>> +    oldpage = phy_select_page(phydev, IP101G_DEFAULT_PAGE);
>>>
>>>      /* configure the RXER/INTR_32 pin of the 32-pin IP101GR if needed: */
>>>      switch (priv->sel_intr32) {
>>>      case IP101GR_SEL_INTR32_RXER:
>>> -        err = phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
>>> -                 IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32, 0);
>>> +        err = __phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
>>> +                   IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32, 0);
>>>          if (err < 0)
>>> -            return err;
>>> +            goto out;
>>>          break;
>>>
>>>      case IP101GR_SEL_INTR32_INTR:
>>> -        err = phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
>>> -                 IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32,
>>> -                 IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32);
>>> +        err = __phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
>>> +                   IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32,
>>> +                   IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32);
>>>          if (err < 0)
>>> -            return err;
>>> +            goto out;
>>>          break;
>>>
>>>      default:
>>> @@ -284,12 +288,14 @@ static int ip101a_g_config_init(struct phy_device *phydev)
>>>       * reserved as 'write-one'.
>>>       */
>>>      if (priv->model == IP101A) {
>>> -        err = phy_set_bits(phydev, IP10XX_SPEC_CTRL_STATUS, IP101A_G_APS_ON);
>>> +        err = __phy_set_bits(phydev, IP10XX_SPEC_CTRL_STATUS,
>>> +                     IP101A_G_APS_ON);
>>>          if (err)
>>> -            return err;
>>> +            goto out;
>>>      }
>>>
>>> -    return 0;
>>> +out:
>>> +    return phy_restore_page(phydev, oldpage, err);
>>
>> If a random page was set before entering config_init, do we actually want
>> to restore it? Or wouldn't it be better to set the default page as part
>> of initialization?
> 
> First, I want to convert this to the match_phy_device() and while at it,
> I noticed that there is this one "problem". Short summary: the IP101A isn't
> paged, the IP101G has serveral and if page 16 is selected it is more or
> less compatible with the IP101A. My problem here is now how to share the
> functions for both PHYs without duplicating all the code. Eg. the IP101A
> will phy_read/phy_write/phy_modify(), that is, all the locked versions.
> For the IP101G I'd either need the _paged() versions or the __phy ones
> which don't take the mdio_bus lock.
> 
> Here is what I came up with:
> (1) provide a common function which uses the __phy ones, then the
>     callback for the A version will take the mdio_bus lock and calls
>     the common one. The G version will use phy_{select,restore}_page().
> (2) the phy_driver ops for A will also provde a .read/write_page()
>     callback which is just a no-op. So A can just use the G versions.
> (3) What Heiner mentioned here, just set the default page in
>     config_init().
> 
> (1) will still bloat the code; (3) has the disadvantage, that the
> userspace might fiddle around with the page register and then the
> whole PHY driver goes awry. I don't know if we have to respect that
> use case in general. I know there is an API to read/write the PHY
> registers and it could happen.
> 

The potential issue you mention here we have with all PHY's using
pages. As one example, the genphy functions rely on the PHY being
set to the default page. In general userspace can write PHY register
values that break processing, independent of paging.
I'm not aware of any complaints regarding this behavior, therefore
wouldn't be too concerned here.

Regarding (2) I'd like to come back to my proposal from yesterday,
implement match_phy_device to completely decouple the A and G versions.
Did you consider this option?

> That being said, I'm either fine with (2) and (3) but I'm preferring
> (2).
> 
> BTW, this patch is still missing read/writes to the interrupt status
> and control registers which is also paged.
> 
> -michael

Heiner
