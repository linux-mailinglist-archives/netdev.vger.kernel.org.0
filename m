Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640522C3427
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731878AbgKXWla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgKXWla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 17:41:30 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD906C0613D6;
        Tue, 24 Nov 2020 14:41:29 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id v22so481188edt.9;
        Tue, 24 Nov 2020 14:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=h5/NEGcRaQbxARJ7pOs7y+QOBtL6oZcm2nApnzpGIeU=;
        b=tisrnfnNV0MN7LKo+eRixINZfF2YyukdJ0mMUJ/faW/TTm+THkoK/9rTFT6saK6c0v
         fCmT8ebTjTuvp7GAgfDeYjDhXA9qpVAcD0eLtNWOa/PvZstDDhiZuPkTUIRA7OvPgVsW
         KdGGnVcvaiRuXoOu7iPaNuAF7UmPR+0oeDvYRCHgmonTUblHbzyqxC+P2BJ6Q/MvLnuS
         WgYBwa7QJoRlsx9qbxJdLaTsAsWMxqPy7dwYiXHI2NONni3isuzTAnP/yTnlkclnSz8G
         dRVNyWu97UBvK/Q8qw4EUvMtcg1nOd79KmIRahpAsySX+txQw7dFiKwlbldjD49XS67V
         8D7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=h5/NEGcRaQbxARJ7pOs7y+QOBtL6oZcm2nApnzpGIeU=;
        b=SL0iyNQsRR37qDMCzSsLfCo/uyVdPAB5wklvT+qEv94D59CypNTQIzq6hNFvpucKM8
         RsrFgmmEZ4pHHlWLWK8t3jg9i3nLbx534UGLC2IUpM9lniIelboLkDX2CtmCm4W+Ig6j
         uQOVdP3Wg5pt1M6iMdNqyQr6HNn4MMzkVB/tbB9fkUpNT0B/jhNxh3ZzGrEnpUb8YM29
         K04vreeKvCNKzzAuPTSGyb7kRojrB3Bs6oajABrU8mf6QslYcEcplYHzPvF3Bt/c/K40
         cM1zVg9C3sX0E14slV1fKQ5HQ0B8vmDXGiC/3EyvQVGpKf7QXEsRszkshPf99H8Ykbsi
         Brpw==
X-Gm-Message-State: AOAM532icC06Ktgz4Pye2O1Do2MQVsY/HIvqI/zYdjU9Ps/eWT3Wzn6Z
        DjrzpOZyWAHtb/KWZqBuQrz3srMRvbm54w==
X-Google-Smtp-Source: ABdhPJwuPDJI1WZoraBmg8raCR7kxU3Wd02gqO0CY0qzV+l7YVW3chHPqsco8qNktNOn2N1x4J7ZQA==
X-Received: by 2002:aa7:d8c4:: with SMTP id k4mr740838eds.248.1606257688414;
        Tue, 24 Nov 2020 14:41:28 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:145e:bd05:1fb8:712a? (p200300ea8f232800145ebd051fb8712a.dip0.t-ipconnect.de. [2003:ea:8f23:2800:145e:bd05:1fb8:712a])
        by smtp.googlemail.com with ESMTPSA id dk4sm136419edb.54.2020.11.24.14.41.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 14:41:27 -0800 (PST)
Subject: Re: [PATCH v2] net: phy: realtek: read actual speed on rtl8211f to
 detect downshift
To:     Antonio Borneo <antonio.borneo@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Yonglong Liu <liuyonglong@huawei.com>,
        Willy Liu <willy.liu@realtek.com>
Cc:     linuxarm@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
References: <20201124143848.874894-1-antonio.borneo@st.com>
 <20201124215932.885306-1-antonio.borneo@st.com>
 <7d8bf728-7d73-fa8c-d63d-49e9e6c872fd@gmail.com>
 <57457fcd335e7d6bfd543187de02608bcccf812f.camel@st.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b469247f-607b-6f92-9f09-9ce345ca6f61@gmail.com>
Date:   Tue, 24 Nov 2020 23:41:15 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <57457fcd335e7d6bfd543187de02608bcccf812f.camel@st.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 24.11.2020 um 23:33 schrieb Antonio Borneo:
> On Tue, 2020-11-24 at 23:22 +0100, Heiner Kallweit wrote:
>> Am 24.11.2020 um 22:59 schrieb Antonio Borneo:
>>> The rtl8211f supports downshift and before commit 5502b218e001
>>> ("net: phy: use phy_resolve_aneg_linkmode in genphy_read_status")
>>> the read-back of register MII_CTRL1000 was used to detect the
>>> negotiated link speed.
>>> The code added in commit d445dff2df60 ("net: phy: realtek: read
>>> actual speed to detect downshift") is working fine also for this
>>> phy and it's trivial re-using it to restore the downshift
>>> detection on rtl8211f.
>>>
>>> Add the phy specific read_status() pointing to the existing
>>> function rtlgen_read_status().
>>>
>>> Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
>>> Link: https://lore.kernel.org/r/478f871a-583d-01f1-9cc5-2eea56d8c2a7@huawei.com
>>> ---
>>> To: Andrew Lunn <andrew@lunn.ch>
>>> To: Heiner Kallweit <hkallweit1@gmail.com>
>>> To: Russell King <linux@armlinux.org.uk>
>>> To: "David S. Miller" <davem@davemloft.net>
>>> To: Jakub Kicinski <kuba@kernel.org>
>>> To: netdev@vger.kernel.org
>>> To: Yonglong Liu <liuyonglong@huawei.com>
>>> To: Willy Liu <willy.liu@realtek.com>
>>> Cc: linuxarm@huawei.com
>>> Cc: Salil Mehta <salil.mehta@huawei.com>
>>> Cc: linux-stm32@st-md-mailman.stormreply.com
>>> Cc: linux-kernel@vger.kernel.org
>>> In-Reply-To: <20201124143848.874894-1-antonio.borneo@st.com>
>>>
>>> V1 => V2
>>> 	move from a generic implementation affecting every phy
>>> 	to a rtl8211f specific implementation
>>> ---
>>>  drivers/net/phy/realtek.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
>>> index 575580d3ffe0..8ff8a4edc173 100644
>>> --- a/drivers/net/phy/realtek.c
>>> +++ b/drivers/net/phy/realtek.c
>>> @@ -621,6 +621,7 @@ static struct phy_driver realtek_drvs[] = {
>>>  		PHY_ID_MATCH_EXACT(0x001cc916),
>>>  		.name		= "RTL8211F Gigabit Ethernet",
>>>  		.config_init	= &rtl8211f_config_init,
>>> +		.read_status	= rtlgen_read_status,
>>>  		.ack_interrupt	= &rtl8211f_ack_interrupt,
>>>  		.config_intr	= &rtl8211f_config_intr,
>>>  		.suspend	= genphy_suspend,
>>>
>>> base-commit: 9bd2702d292cb7b565b09e949d30288ab7a26d51
>>>
>>
>> Pefect would be to make this a fix for 5502b218e001,
>> but rtlgen_read_status() was added one year after this change.
>> Marking the change that added rtlgen_read_status() as "Fixes"
>> would be technically ok, but as it's not actually broken not
>> everybody may be happy with this.
>> Having said that I'd be fine with treating this as an improvement,
>> downshift should be a rare case.
> 
> Correct! Being the commit that adds rtlgen_read_status() an improvement,
> should not be backported, so this patch is not marked anymore as a fix!
> Plus, this does not fix 5502b218e001 in the general case, but limited to
> one specific phy, making the 'fixes' label less relevant.
> Anyway, the commit message reports all the ingredients for a backport.
> 
> By the way, I have incorrectly sent this based on netdev, but it's not a
> fix anymore! Should I rebase it on netdev-next and resend?
> 
For this small change it shouldn't make a difference whether it's based
on net or net-next. I don't think anything has changed here. But better
check whether patch applies cleanly on net-next. Patch should have been
annotated as [PATCH net-next], but I think a re-send isn't needed as
Jakub can see it based on this communication.

> Antonio
> 

