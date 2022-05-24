Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1501F5322FF
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 08:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbiEXGQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 02:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbiEXGQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 02:16:37 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B6313F47
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 23:16:32 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220524061626euoutp020c874651bc07b09b450a9018d7115a78~x9fi93fqj3035730357euoutp02Y
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 06:16:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220524061626euoutp020c874651bc07b09b450a9018d7115a78~x9fi93fqj3035730357euoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653372986;
        bh=mn9zKsCf6mgmN2wSv0nETX/pws120ToEJ+0wXRVQ+XE=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=jJp5MkgUc1he54MarAr71k/7mxSYGp62IziKpUZzMhp9q+iKaqldxBcgawNohHvV+
         pIHydJpIHekKhNc/LnQAdEGze2xIpb4PV3LJ92/Er+M0FYGOTDE+8acH77zhLYqmK1
         TTwhGFjfpf8LLDYYfTmSBxWqP7QUQqcVhap9J8Fk=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220524061626eucas1p2e4d5e1594962a995a9d60f37974de0e4~x9fiXhrhl1241412414eucas1p2O;
        Tue, 24 May 2022 06:16:26 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 33.22.09887.A387C826; Tue, 24
        May 2022 07:16:26 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220524061625eucas1p14d35738b12d15ff5b2f8ca2a1f796335~x9fh8TqZs1693616936eucas1p1w;
        Tue, 24 May 2022 06:16:25 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220524061625eusmtrp18b79e7f79de062a4e70e5db94315b376~x9fh7RJJI3186931869eusmtrp1l;
        Tue, 24 May 2022 06:16:25 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-24-628c783a00ed
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 43.93.09522.9387C826; Tue, 24
        May 2022 07:16:25 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220524061624eusmtip1ecd6af5e8747afda7384e2b4d550f510~x9fgr5ZbC0365303653eusmtip1o;
        Tue, 24 May 2022 06:16:24 +0000 (GMT)
Message-ID: <2f612dd0-ac30-4860-ef1b-bbb180da21af@samsung.com>
Date:   Tue, 24 May 2022 08:16:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v3 5/7] usbnet: smsc95xx: Forward PHY
 interrupts to PHY driver to avoid polling
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Lukas Wunner <lukas@wunner.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <Yowv95s7g7Ou5U8J@lunn.ch>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf1CTdRzH+z7Pw7OH5ehxWPsG/rgjxUsTMqr78uOULsqnfzzqzqK6szb2
        3ERhcJvIxO5aEpobJMipbHIIKEM2lEXjhyRYQxgycNAaOQQvEpqOXwKr0ERjPFj89/q8P+/P
        r+99KVxYSoZQKfL9rEIuTg0j+URDx4MbW2JUeZJX75kpVHLEzUOOISuO/nAPkKjE8TWBRjt+
        56G50jYSOU4fxlHFVHEAcjjMPNTb8G0AGjEZMFTsaMVQhSEXR9aTLQBd8xkJdNcTin7r0xCo
        o+wFpLlTTaKy3FEC/WUfByhnxouhfwr7yHgR4+zvw5mmofOAsVS7MeayfojH3J/ezZTVZTKj
        BUU8ps54jGSuuYcBc7lpFmMG5yoBM9XqIhn3pBdnnuQ4CabW4iKY2bq1icJP+HFSNjXlAKuI
        3PY5f4/n7DCZUStQeWu6CDWw8TUgkIL067DzSQHuZyF9AUBHa4IG8BfYB2BX9yTOBbMAur7K
        xZ5WGI5XklyiCsBqzQOCC6YBvHfq3KJLQG+DzZ5mnp8JegO8W6PGOX0lvK4bIfz8PC2B4+Ou
        RT2YlsMxtzHAzzgtggMjZxf6UNQqOh7eeiT398fpqyS8Uti66CHprVAzoSH9HEhvhI2Ts0u1
        62DjRMni2pAu58OCAQPg1k6AA79Ylk4Ihl6bhcfxamgvyiP8wyCdDueLozhZBfvHanCOY+Hg
        jYek34LTL8Pa5khOfgtO/3gb5yqD4M2JldwGQfBEw+klWQC/OSLk3OFQb7v038yfen/GC0CY
        ftmb6Jfdrl92i/7/uWWAMAIRm6lMk7HK1+RsVoRSnKbMlMsiktPT6sDCF7Y/tvmaQJV3OsIK
        MApYAaTwsFUC6Yd5EqFAKj6YzSrSP1NkprJKKwiliDCRIDnFLBbSMvF+dh/LZrCKp1mMCgxR
        Y+aWRNSdv3mnSIK93yatsNfIbXXd2jnJl9fbsk/F3K7ftZaIawzuvJRliv/o1hg4szq/9nDW
        G9r29nCZ+d36rk4Hm0Er6tt9YyviJs7Ua1XrpR+8kxgz1vtm/oy6cEVT5Itmk/2Z3JmeouEk
        Z0tQaJUu2jNPtm2Jntp8dDhjTdT2mwmV4RcPHbwaKzWvK79/NCnwinRNqm5w9BWTbk514NCf
        puy9pscXwA6XVuusPrm3XPZDfw/hOeY2sMkvOTc0itWlsZaZHc/x/357KPo7kXGTQvHxp7aq
        wmdDbBepnQ/fe3Tue0uHb6Ny+68BUY6B41rdnf6cXqevZ3fSvizrri9K5sMI5R7x1k24Qin+
        FzIoqQUxBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t/xu7qWFT1JBgf+qVvMabvJbnH+7iFm
        i2c3b7FZzDnfwmLx9Ngjdosf8w6zWZyf3sRssej9DFaL8+c3sFtc2NbHavFk9TImixnn9zFZ
        LFrWymxxaOpeRosjX1axWLx4Lm3x4GIXi8WxBWIWXY9XslksaH3KYvHt9BtGi+ZPr5gsfk+8
        yOYg7nH52kVmjx13lzB6bFl5k8lj56y77B4fPsZ5LNhU6vF0wmR2j02rOtk8jtx8yOixc8dn
        Jo87P5Yyerzfd5XN4+a7V8we/5svs3is33KVxePzJrkAoSg9m6L80pJUhYz84hJbpWhDCyM9
        Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jOfzH7IVrOeteLXmFEsD43GuLkZODgkB
        E4ll/UvZuhi5OIQEljJKvDp/ngUiISNxcloDK4QtLPHnWhdU0XtGiSW734AV8QrYSex6vosd
        xGYRUJV4saaBGSIuKHFy5hOgGg4OUYEkiSOH+UHCwgJ5Eqeb34DNZBYQl7j1ZD4TSImIgIPE
        7T95IOOZBY6ySVy5dY0JYtcCZokJE/rBZrIJGEp0vQU5gpODU0BdYvu7z1CDzCS6tnYxQtjy
        EtvfzmGewCg0C8kZs5Dsm4WkZRaSlgWMLKsYRVJLi3PTc4sN9YoTc4tL89L1kvNzNzECU8+2
        Yz8372Cc9+qj3iFGJg7GQ4wSHMxKIrwpYT1JQrwpiZVVqUX58UWlOanFhxhNgWExkVlKNDkf
        mPzySuINzQxMDU3MLA1MLc2MlcR5PQs6EoUE0hNLUrNTUwtSi2D6mDg4pRqYSheuOVi0Uu8Z
        /1WnGwXqfRvOv7rHFW70r/iu5PxOTd1TGfrzP0Ze/u0nWOB8LuDXRKXujb1h4XreJ9WX2L1y
        5v9ZNjclbto3kVuhP4OtZn1SS1yVGBvlze8tsWqz3KX7LDrKxrV++U/8uMqN7v10yb7LU8Pk
        vIH1M2vhfSmzmvply92msFx//OXBww+3VM/trTrfYzv9ruuPtc9XGCzgsD/tnJU1e9spfcVV
        H7tuv6257jDpRJVa/953iot/8P/Mysr+9spy7yuGqP+zU0ybmBdF5Fusfiz499UlkTtZHtIe
        R7s2Fm47o1dlGvDnv0VE6u4n88VKBNXOcvmvO87wvefitE0iv84udQo6GD/DRImlOCPRUIu5
        qDgRACIgJePGAwAA
X-CMS-MailID: 20220524061625eucas1p14d35738b12d15ff5b2f8ca2a1f796335
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99
References: <cover.1652343655.git.lukas@wunner.de>
        <748ac44eeb97b209f66182f3788d2a49d7bc28fe.1652343655.git.lukas@wunner.de>
        <CGME20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99@eucas1p2.samsung.com>
        <a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com>
        <20220519190841.GA30869@wunner.de>
        <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
        <20220523094343.GA7237@wunner.de> <Yowv95s7g7Ou5U8J@lunn.ch>
X-Spam-Status: No, score=-11.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.05.2022 03:08, Andrew Lunn wrote:
>> @@ -976,6 +977,25 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
>>   	struct phy_driver *drv = phydev->drv;
>>   	irqreturn_t ret;
>>   
>> +	if (IS_ENABLED(CONFIG_PM_SLEEP) &&
>> +	    (phydev->mdio.dev.power.is_prepared ||
>> +	     phydev->mdio.dev.power.is_suspended)) {
>> +		struct net_device *netdev = phydev->attached_dev;
>> +
>> +		if (netdev) {
>> +			struct device *parent = netdev->dev.parent;
>> +
>> +			if (netdev->wol_enabled)
>> +				pm_system_wakeup();
>> +			else if (device_may_wakeup(&netdev->dev))
>> +				pm_wakeup_dev_event(&netdev->dev, 0, true);
>> +			else if (parent && device_may_wakeup(parent))
>> +				pm_wakeup_dev_event(parent, 0, true);
>> +		}
>> +
>> +		return IRQ_HANDLED;
> I'm not sure you can just throw the interrupt away. There have been
> issues with WoL, where the WoL signal has been applied to a PMC, not
> an actual interrupt. Yet the PHY driver assumes it is an
> interrupt. And in order for WoL to work correctly, it needs the
> interrupt handler to be called. We said the hardware is broken, WoL
> cannot work for that setup.
>
> Here you have correct hardware, but you are throwing the interrupt
> away, which will have the same result. So i think you need to abort
> the suspend, get the bus working again, and call the interrupt
> handler. If this is a WoL interrupt you are supposed to be waking up
> anyway.

This hardware doesn't support wake-on-lan. It looks somehow that it 
manages to throw an interrupt just a moment before the power regulator 
for the whole usb bus is cut off.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

