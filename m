Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E474FD7C
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 20:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfFWSRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 14:17:10 -0400
Received: from eva.aplu.fr ([91.224.149.41]:48270 "EHLO eva.aplu.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726634AbfFWSRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 14:17:10 -0400
Received: from eva.aplu.fr (localhost [127.0.0.1])
        by eva.aplu.fr (Postfix) with ESMTP id 48E11C45;
        Sun, 23 Jun 2019 20:17:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aplu.fr; s=s4096;
        t=1561313827; bh=QQ+p7ZvdJhbEmx8uGpHZdfsHEb5iJlIlXsDH8L3dznM=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=pNtl7SV56DwrdH1N56yItqUQepmW1aoPFSMYGNkxq9Ey7ROI+qQnhgAQw/O1ilpCG
         Iq9a6+A1VYgRyUrng4EhnJ9LZ9cmX8GzIllbTJH0Sd2rg+NmSik1Su+3ECZXFshENG
         cFG9wMd6bQ3TpdAwRQPFq+FhaYm9sTfcYDr2QmLvbETOeH3MeIzSGjrnREtsPt87xY
         5RjyDs/Zi6Ui6TppmhggvCoGbNx+0CrLZIZsgjEliFpYL7A2rGAGvBXBogQhXqF7EB
         cp9ZZkpc/VOxDzIOpXw9REKA5vzcbTtXYE2PiV5+VRyvJdnzhyNB7Bd5eOF+f+bVh/
         cdLZmMtJ/LcUnHjmyc8WELvhfDHhEU6RWL+a73s6/Wf4jsR8rFGBUd2aPX2dPGqbyR
         y1TMAaBDh6PU1ImCdxdoHPLWKlperfGhVzyxIsaVWeDuib/QJDFHKqRfrFAmxNmtXs
         kFx5iB1cFdfcxP508Q1mhgI4KZcwhNxbR+rQPZhI+6uk0nVcnxHUx89v6vL2+wvRi3
         phIpRmdq0/AD/V9Lj4zApisYAd6eHxahVipqRouqz+DMobmM+aOMhzybD/EJ5lyjco
         Ik/eggiQh+1Ys4TI4w/xEQxUmP9CRcnG0D0/wVuoEG4Vb77xN2+7fcthWBrkTF9lRX
         o0N9RDsvwIXvM6jhIUScfEgE=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on eva.aplu.fr
X-Spam-Level: 
X-Spam-Status: No, score=-102.5 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        SHORTCIRCUIT shortcircuit=ham autolearn=disabled version=3.4.2
Received: from [IPv6:2a03:7220:8081:2901::1003] (unknown [IPv6:2a03:7220:8081:2901::1003])
        by eva.aplu.fr (Postfix) with ESMTPSA id CC72DA1E;
        Sun, 23 Jun 2019 20:17:06 +0200 (CEST)
Authentication-Results: eva.aplu.fr; dmarc=fail (p=none dis=none) header.from=aplu.fr
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aplu.fr; s=s4096;
        t=1561313826; bh=QQ+p7ZvdJhbEmx8uGpHZdfsHEb5iJlIlXsDH8L3dznM=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=dCxerk4aexoNLRPPL0oEH3MENsOqzdl/hgzUGMI74KJUoWNrm3V9MnTdXfqNEJZLc
         DE7OZrDu4DuxkVNtO24PwuT7RCPKwSe61cAKwDvfqqrCQ8ZZHviRLIfiukUG+bWeUf
         bn/1V27IiCNOOctV9azzlIg5JiZSoC4cpyl6fb7MVq/c7TzMHBxgHHddLWjIFiH7Wa
         GYedlH5WsphMkUKjQCJbVaZKf563t3dT4rIdCc27c6c19wDN9LZS4FzSOGG+Q06qMC
         ksDpILBTPZ5bViZOCuX1zI35TQRWGQAb2X+v5cMejh9iFYFCUgTkiBJEgVtrXJKNRb
         Si4+LedgWQVImf2ti1lThchkZ8M22R5HJk0+fQR85D+rkkJaeU1iwcG7qFNRwD713z
         fhyLbSw8kc466RT4zxTbWqHDV5SeicjMRuqcLeebqegZWuvPhAsgC7mKzlAaLFkYhW
         gSlEAxZuR4rWpw8CV9x2FJLLmuoiH6bHeOE1fT063UCJ0vBQJeTHjVno7zO3dqdn/U
         A1oXEtav9KtEZsAyraTn6TWym6FzBg8zXnT/g47yQx/nXBn+bfUD1yxwyE90fYpTgv
         5CbSdA/xTn+fNwZzneotkPxaza/81ThP9vVLtrBB1gIHf/4fMuTvxIyMULbBpegylx
         BnnoK/zos8KSOH5rK+GfYi3Q=
Subject: Re: network unstable on odroid-c1/meson8b.
From:   Aymeric <mulx@aplu.fr>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, linux-amlogic@lists.infradead.org
References: <ff9a72bf-7eeb-542b-6292-dd70abdc4e79@aplu.fr>
 <0df100ad-b331-43db-10a5-3257bd09938d@gmail.com>
 <d2e298040f4887c547da11178f9ea64f@aplu.fr>
 <1f34f3b6-2c70-9ff3-3f5a-597e4bd9c66f@gmail.com>
 <fc416bf0-3f3c-72a8-0500-4e487d8f3a27@aplu.fr>
Openpgp: preference=signencrypt
Autocrypt: addr=mulx@aplu.fr; prefer-encrypt=mutual; keydata=
 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
Message-ID: <57de5c6e-b964-70e1-ed60-527f2be2a961@aplu.fr>
Date:   Sun, 23 Jun 2019 20:16:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <fc416bf0-3f3c-72a8-0500-4e487d8f3a27@aplu.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: fr
X-AV-Checked: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 20/06/2019 à 22:54, Aymeric a écrit :
> Le 20/06/2019 à 17:53, Heiner Kallweit a écrit :
>> On 20.06.2019 09:55, Aymeric wrote:
>>> Hi,
>>> On 2019-06-20 00:14, Heiner Kallweit wrote:
>>>> On 19.06.2019 22:18, Aymeric wrote:
>>>>> Hello all,
>>>>>
>>>> Kernel 3.10 didn't have a dedicated RTL8211F PHY driver yet, therefore
>>>> I assume the genphy driver was used. Do you have a line with
>>>> "attached PHY driver" in dmesg output of the vendor kernel?
>>> No.
>>> Here is the full output of the dmesg from vendor kernel [¹].
>>>
>>> I've also noticed something strange, it might be linked, but mac address of the board is set to a random value when using mainline kernel and I've to set it manually but not when using vendor kernel.
>>>
>>>> The dedicated PHY driver takes care of the tx delay, if the genphy
>>>> driver is used we have to rely on what uboot configured.
>>>> But if we indeed had an issue with a misconfigured delay, I think
>>>> the connection shouldn't be fine with just another link partner.
>>>> Just to have it tested you could make rtl8211f_config_init() in
>>>> drivers/net/phy/realtek.c a no-op (in current kernels).
>>>>
>>> I'm not an expert here, just adding a "return 0;" here[²] would be enough?
>>>
>>>> And you could compare at least the basic PHY registers 0x00 - 0x30
>>>> with both kernel versions, e.g. with phytool.
>>>>
>>> They are not the same but I don't know what I'm looking for, so for kernel 3.10 [³] and for kernel 5.1.12 [⁴].
>>>
>>> Aymeric
>>>
>>> [¹]: https://paste.aplu.fr/?38ef95b44ebdbfc3#G666/YbhgU+O+tdC/2HaimUCigm8ZTB44qvQip/HJ5A=
>>> [²]: https://github.com/torvalds/linux/blob/241e39004581475b2802cd63c111fec43bb0123e/drivers/net/phy/realtek.c#L164
>>> [³]: https://paste.aplu.fr/?2dde1c32d5c68f4c#6xIa8MjTm6jpI6citEJAqFTLMMHDjFZRet/M00/EwjU=
>>> [⁴]: https://paste.aplu.fr/?32130e9bcb05dde7#N/xdnvb5GklcJtiOxMpTCm+9gsUliRwH8X3dcwSV+ng=
>>>
>> The vendor kernel has some, but not really much magic:
>> https://github.com/hardkernel/linux/blob/odroidc-3.10.y/drivers/amlogic/ethernet/phy/am_rtl8211f.c
>> The write to RTL8211F_PHYCR2 is overwritten later, therefore we don't have to consider it.
>>
>> The following should make the current Realtek PHY driver behave like in the vendor driver.
>> Could you test it?
> (sending again for mailing list, sorry, I forgot to force it in plaintext…)
>
> I've applied your patch and tried but it doesn't change anything.
>
> Here is dmesg output and phytool results.
>
> https://paste.aplu.fr/?9735c99907528929#SeCgwR45cgnbDA1tXIVBHCBT8RNct2r41jU6vsguLVc=
>
Hello all,

I had some news from a friend who have the same issue than me, his board
is connected to an "intelligent" switch a Ubiquiti EdgeSwitch.

Also, when he force the link to 100 it is stable.

Aymeric.

-- 
Aymeric
