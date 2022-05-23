Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A67530FD9
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbiEWLiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 07:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234885AbiEWLiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 07:38:07 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DF743AC2
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 04:38:06 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220523113804euoutp012914f25d2f80d60079be0cedd2c7dbf2~xuPFSry_20621606216euoutp01Y
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:38:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220523113804euoutp012914f25d2f80d60079be0cedd2c7dbf2~xuPFSry_20621606216euoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653305884;
        bh=ztC9+74A/VOT6Iots1KmQwx7+4e/XR+aAflW71XWvrA=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=Th9a8eHg25iY8jkRMrTT7iOpe0UlpcxrnlOCKOy7FzqkwlH67bpcldFwvtKfMv/YO
         bTmX+R/AO331yd4+HBupUizf3adggM7JdyVVkQixquu59+IGFUlHqUAZjBY8c9eb89
         IIGpXcXEbj5AxpGvClJa59zrTdTM/a1XKiNUv1wQ=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220523113804eucas1p2c964132fa3bbb6f2d43b06ca6686ac41~xuPEkjwZe0567905679eucas1p25;
        Mon, 23 May 2022 11:38:04 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 8B.17.09887.B127B826; Mon, 23
        May 2022 12:38:03 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220523113803eucas1p2ca6d500fef769c98a60938f00413aedb~xuPD5-zYI3165831658eucas1p2n;
        Mon, 23 May 2022 11:38:03 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220523113803eusmtrp2bff93cb125138bdd2fa08ce94b30544a~xuPD2jHhp3201432014eusmtrp2N;
        Mon, 23 May 2022 11:38:03 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-c1-628b721bef90
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id CA.5C.09404.B127B826; Mon, 23
        May 2022 12:38:03 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220523113801eusmtip27a8f2fbd782dde5ce6df003a7fdf255b~xuPCkIwTT2483224832eusmtip2c;
        Mon, 23 May 2022 11:38:01 +0000 (GMT)
Message-ID: <e0f4b751-bd94-194f-b6b8-972ae02298f7@samsung.com>
Date:   Mon, 23 May 2022 13:38:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v3 5/7] usbnet: smsc95xx: Forward PHY
 interrupts to PHY driver to avoid polling
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>
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
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20220523094343.GA7237@wunner.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTH8/Te3tt2KV4q0GdAwHXOTbdRcIt5khEyHSQ3Cx+IH5bNIO4i
        N0CAAq1gt/GhowpYpjDUwRqQSvCldSCpDIoBZRVpJokX6oorASZvc7a8VTqn+NJZLm58+53/
        Oef5n3PyiDCZiYgU5aoOsWoVk68gJHjX4JPb70epqzPj+9sSUWOFm0TchB1Df7rHCNTIHcHR
        3OA0iR6fuUEgrr4cQy1LDULEcR0kGu46IUSzl84LUAN3TYBazh/FkP10H0ADfguO/rofhe6N
        GHA0aIpAhhkzgUxH53D0aGgeIP1DjwA9/X6E+FhO3xkdwWjbRCugO81uAd1jnCDpZV8GbbKW
        0HO1J0naajlG0APuKUD32FYE9Pjjc4BeuuYiaPeiB6MD+js4fbnThdMr1pg02T5JYhabn1vK
        qpVJX0py9D4zWaQL15Z/10rowDRlAGIRpD6E7SsPhQYgEcmoiwDe4zrXAz+A884WjA9WABzz
        dAhetfTebcT5xAUAawzd64EPwJbOprUqKZUEq58HyCDj1FvwQd8y4PVQ+OuPs3iQw6lMOD/v
        woK8mVJBr9siDDJGyeHYbPPaO2GUApafWhQEDTDqDwL6rtxaSxBUAjQsGIggi6k4+Nv1fpxv
        joXdC41rc0PqnAR67q8Q/NzJ0OuqXd9hM/Q4Okmeo2GgJ+gmesmF8HnDB7yshaPenzCeP4Lj
        t1eJYAlGbYeXryp5eTf09U9ifGcI/H0hlJ8gBNZ11a/LUlhVIeOrt0Gjo/0/z1+GnVgtUBg3
        HMW4YXnjhl2M//uaAG4BcrZEU5DNanaq2MNxGqZAU6LKjjtYWGAFLz/x0AuH3wYueHxxdiAQ
        ATuAIkwRJu1mqjJl0izmq69ZdeEBdUk+q7GDKBGukEsP5nYwMiqbOcTmsWwRq36VFYjEkTpB
        nldrm3pvKsG7Lefz18nC6G+O1GaddD4zY8dHm2pCDjzbmjKc/vfhmflV17vCogevjWx646Zu
        7wldfINyS4q88mZd1q0JYXxHIK44Jao3EPEpU7o0lTE+ILYMgGPW9u1XRovrS/+ZPlXzc1Vb
        MkwU+yu4mSrtVZGxL31nbF1qxw0ue+9+c2XMm8a01N7T18Wbsorg0/2Mc6Bpz3J4YLb57epG
        hvxsTni35du2H7jJHcd9VLNjtcuZ/mSLzmjjIvQpyj2hCSbyLCNT7dLvwyLFaUOOlJhVTZX1
        UezFs5VpydGTZcnad+aUeYutGZ8MhxXTqUkhu3a/SPBLyoq8ZV8oFbgmh0nYgak1zL+IgVup
        MwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t/xe7rSRd1JBquaeS3mtN1ktzh/9xCz
        xbObt9gs5pxvYbF4euwRu8WPeYfZLM5Pb2K2WPR+BqvF+fMb2C0ubOtjtXiyehmTxYzz+5gs
        Fi1rZbY4NHUvo8WRL6tYLF48l7Z4cLGLxeLYAjGLrscr2SwWtD5lsfh2+g2jRfOnV0wWvyde
        ZHMQ97h87SKzx467Sxg9tqy8yeSxc9Zddo8PH+M8Fmwq9Xg6YTK7x6ZVnWweR24+ZPTYueMz
        k8edH0sZPd7vu8rmcfPdK2aP/82XWTzWb7nK4vF5k1yAUJSeTVF+aUmqQkZ+cYmtUrShhZGe
        oaWFnpGJpZ6hsXmslZGpkr6dTUpqTmZZapG+XYJeRvPHlewFDaIVTT1L2BoYHwl0MXJySAiY
        SOy5Poeli5GLQ0hgKaNE7/z/LBAJGYmT0xpYIWxhiT/Xutggit4zSky/eocdJMErYCfR/fc/
        mM0ioCrxcu8HRoi4oMTJmU+ABnFwiAokSRw5zA8SFhbIkzjd/AZsJrOAuMStJ/OZQGwRASWJ
        pinvmEDmMws8ZpOY8HUmO8SyVmaJ7U3HwTrYBAwlut6CXMHJwSmgJ3Fl/wEWiElmEl1buxgh
        bHmJ7W/nME9gFJqF5I5ZSBbOQtIyC0nLAkaWVYwiqaXFuem5xUZ6xYm5xaV56XrJ+bmbGIHJ
        Z9uxn1t2MK589VHvECMTB+MhRgkOZiUR3u2JHUlCvCmJlVWpRfnxRaU5qcWHGE2BgTGRWUo0
        OR+Y/vJK4g3NDEwNTcwsDUwtzYyVxHk9CzoShQTSE0tSs1NTC1KLYPqYODilGpicfl4/zFj2
        xWvG6mCxk22PheZsPWQsO5Wp8p9mf5H5s+0PDBfeltU3cU3MnbwhxEPmvqhZ3qkE4WSNxyuO
        6x5MnuOR+srr2auHT7Y4vO7cnft145lT+1xXurd6XVy4cV/DD2u9qzeqLRxvxRcF1bulTs1U
        PFJXcMJiSc5lNtWne5ckLpA3FLnNVdLskDljj+b3O81Hw+R7AjWOX0zz9b0t9f3Ux7dpL62u
        Sfe6nTTSj9onWnzQ/ljvp3cLiyW3eZhMWXnyWu78oG8iyhPepGsuaJQ/cz3IM6e1027Tp8vl
        LzUyjVVKWLyvhfCWczdMEtui/Zd54WO39+4KIRHbbq2ZVrjFh5XzfpC89vfZDVuVWIozEg21
        mIuKEwFKPJSqxwMAAA==
X-CMS-MailID: 20220523113803eucas1p2ca6d500fef769c98a60938f00413aedb
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
        <20220523094343.GA7237@wunner.de>
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

Hi Lukas,

On 23.05.2022 11:43, Lukas Wunner wrote:
> On Thu, May 19, 2022 at 11:22:36PM +0200, Marek Szyprowski wrote:
>> On 19.05.2022 21:08, Lukas Wunner wrote:
>>> Taking a step back though, I'm wondering if there's a bigger problem here:
>>> This is a USB device, so we stop receiving interrupts once the Interrupt
>>> Endpoint is no longer polled.  But what if a PHY's interrupt is attached
>>> to a GPIO of the SoC and that interrupt is raised while the system is
>>> suspending?  The interrupt handler may likewise try to reach an
>>> inaccessible (suspended) device.
>>>
>>> The right thing to do would probably be to signal wakeup.  But the
>>> PHY drivers' irq handlers instead schedule the phy_state_machine().
>>> Perhaps we need something like the following at the top of
>>> phy_state_machine():
>>>
>>> 	if (phydev->suspended) {
>>> 		pm_wakeup_dev_event(&phydev->mdio.dev, 0, true);
>>> 		return;
>>> 	}
>>>
>>> However, phydev->suspended is set at the *bottom* of phy_suspend(),
>>> it would have to be set at the *top* of mdio_bus_phy_suspend()
>>> for the above to be correct.  Hmmm...
>> Well, your concern sounds valid, but I don't have a board with such hw
>> configuration, so I cannot really test.
> I'm torn whether I should submit the quick fix in my last e-mail
> or attempt to address the deeper issue.  The quick fix would ensure
> v5.19-rc1 isn't broken, but if possible I'd rather address the deeper
> issue...
>
> Below is another patch.  Would you mind testing if it fixes the problem
> for you?  It's a replacement for the patch in my last e-mail and seeks
> to fix the problem for all drivers, not just smsc95xx.  If you don't
> have time to test it, let me know and I'll just submit the quick fix
> in my previous e-mail.

I've just tested it on top of next-20220519 and I was not able to 
reproduce the issue, so it looks it also fixes the issue. :)

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

> BTW, getting a PHY interrupt on suspend seems like a corner case to me,
> so I'm amazed you found this and seem to be able to reproduce it 100%.
> Out of curiosity, is this a CI test you're performing?

I've have some semi-automated (based on simple bash scripts) tests 
utilizing remote test boards (with remote power on/off control, serial 
console, tftp booting). This issue was quite easy to reproduce, even 
manually. Maybe it is somehow specific to the Odroid-XU3/XU3-lite boards 
and the way the smsc95xx USB ethernet chip is connected there, but it 
happens there usually in 2 of 3 suspend/resume tests.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

