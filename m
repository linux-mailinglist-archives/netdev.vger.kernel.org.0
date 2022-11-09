Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8265D622913
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 11:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiKIKwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 05:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiKIKwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 05:52:25 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AA2286D0
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:52:15 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221109105213epoutp03a1f1bfba26f61a8572f229864015b218~l5RlON4GJ1347613476epoutp03O
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:52:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221109105213epoutp03a1f1bfba26f61a8572f229864015b218~l5RlON4GJ1347613476epoutp03O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667991133;
        bh=ocZAgU20W/C0Wvjj4phlLrBK6F98ICtmzHG2kkClc80=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=qzrgOSa0Ly5ps5rB8OsNQmgR3XPiQjfogwaEL+981JlUXZPDXLW6R4M5iurdY1XfY
         dpv6nOOFZGRwhz6o8MV4EhnI1N2siBxKae44YaPmcGFxNtLElOj0GaGsTrgGUm62z/
         6oJEJOEN2j9q/8aX7MI0ciK/tzQw5JNQciL+DJrU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221109105213epcas5p10a269c5bf6f21d29adc39b13286ed184~l5RkplBa00080600806epcas5p1C;
        Wed,  9 Nov 2022 10:52:13 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4N6hcW0DzKz4x9Q1; Wed,  9 Nov
        2022 10:52:11 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CA.17.39477.A568B636; Wed,  9 Nov 2022 19:52:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221109095504epcas5p261f629654560751da44f215a0d6fbce3~l4frf8sd20210902109epcas5p2T;
        Wed,  9 Nov 2022 09:55:04 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221109095504epsmtrp250b6fa61ed7eee65484ead4c3a0c4456~l4frfEg0H0878408784epsmtrp2t;
        Wed,  9 Nov 2022 09:55:04 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-64-636b865a44ec
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7D.B8.18644.8F87B636; Wed,  9 Nov 2022 18:55:04 +0900 (KST)
Received: from FDSFTE314 (unknown [107.122.81.85]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20221109095502epsmtip1915b9ad39f7f44504323d4b984ead38d~l4fpsletY3004230042epsmtip1Y;
        Wed,  9 Nov 2022 09:55:02 +0000 (GMT)
From:   "Vivek Yadav" <vivek.2311@samsung.com>
To:     "'Marc Kleine-Budde'" <mkl@pengutronix.de>
Cc:     <rcsekar@samsung.com>, <wg@grandegger.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pankaj.dubey@samsung.com>, <ravi.patel@samsung.com>,
        <alim.akhtar@samsung.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20221025074424.udfltascaqjc6dhs@pengutronix.de>
Subject: RE: [PATCH 4/7] can: mcan: enable peripheral clk to access mram
Date:   Wed, 9 Nov 2022 15:25:01 +0530
Message-ID: <01f301d8f421$5758b8c0$060a2a40$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJD6JMFT7t8BSDsfE8Wj4Sh/mZZ1gIQFV+aApEtDMUCdlaOq60ntEFA
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJsWRmVeSWpSXmKPExsWy7bCmpm5UW3ayweqJFhYP5m1js5hzvoXF
        4umxR+wWF7b1sVqs+j6V2eLyrjlsFusXTWGxOLZAzOLb6TeMFou2fmG3ePhhD7vFrAs7WC2W
        3tvJ6sDrsWXlTSaPBZtKPT5eus3osWlVJ5tH/18Dj/f7rrJ59G1ZxejxeZNcAEdUtk1GamJK
        apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0MFKCmWJOaVAoYDE
        4mIlfTubovzSklSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyM95NvMhdc
        4q94cvETYwPjA54uRk4OCQETiY1LXrN3MXJxCAnsZpS4vGUSG0hCSOATo8TMvlKIxGdGiQdP
        FzPCdPStmscMkdjFKNF39zOU85xRYkPPOWaQKjYBHYnmyX/BOkQE9CR+T1jEBGIzC2xhkvj7
        vgzE5hSwlVh0+wIriC0s4CHR/XYXWD2LgIrE3jfPwM7gFbCUWP+/kRHCFpQ4OfMJC8QcbYll
        C18zQ1ykIPHz6TJWiF1uEtuedjJD1IhLHP3ZA3achMAVDonZ66azQTS4SCw4ewWqWVji1fEt
        7BC2lMTnd3uhapIldvzrZIWwMyQWTNwD9b69xIErc4CO4ABaoCmxfpc+RFhWYuqpdVA/8kn0
        /n7CBBHnldgxD8ZWkXjxeQIrSCvIqt5zwhMYlWYh+WwWks9mIflgFsKyBYwsqxglUwuKc9NT
        i00LjPJSy+HxnZyfu4kRnJy1vHYwPnzwQe8QIxMH4yFGCQ5mJRFebo3sZCHelMTKqtSi/Pii
        0pzU4kOMpsDgnsgsJZqcD8wPeSXxhiaWBiZmZmYmlsZmhkrivItnaCULCaQnlqRmp6YWpBbB
        9DFxcEo1MDXZhvts9Wa4beIkUcr+dJYri4Pcz5CsZyeXunYZbpDjeT9x2232rlMFB7V0/kvl
        LAsMjLx9ZtWruw8WzJiox8vW/bX+0tRGWz71iwvsyrd8Dmk8aiqzdNHJ1JirAr87pp2PCPo1
        hfHTwYfac5YsOnY/ttZ/945XZc8sq1PWPLdyeX54wWpLf5kT+gs+rNrlw/C90/j4vxif14HN
        XRU3y37G6x5Tkp0W2VQrYZygpNsbyXMp3c1hRW7nBqa8vt7XLb69Gj+tclJSfkmcfHenY86K
        Sf/bWXWVzDIlOtb9TZ6QWuG5ilW+z2eGwjYTvvb56myn7Qz4ru86EcUyaUrcVCkZmViVs0Vb
        v3/d+Tn0vRJLcUaioRZzUXEiAHLN1V9XBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWy7bCSnO6PiuxkgyObFSwezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFos
        vbeT1YHXY8vKm0weCzaVeny8dJvRY9OqTjaP/r8GHu/3XWXz6NuyitHj8ya5AI4oLpuU1JzM
        stQifbsEroxfux+zFazgr5i9/TtLA+Mmni5GTg4JAROJvlXzmLsYuTiEBHYwSjx+eIUNIiEl
        MeXMSxYIW1hi5b/n7BBFTxklVjw8wgSSYBPQkWie/JcRxBYR0JP4PWERE0gRs8AhJon5f1az
        QHS8Y5R4fWgyWAengK3EotsXWEFsYQEPie63u8C6WQRUJPa+eQa2mlfAUmL9/0ZGCFtQ4uTM
        J2BnMAtoSzy9+RTOXrbwNTPEeQoSP58uY4W4wk1i29NOZogacYmjP3uYJzAKz0IyahaSUbOQ
        jJqFpGUBI8sqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgONXS2sG4Z9UHvUOMTByM
        hxglOJiVRHi5NbKThXhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl
        4uCUamDaUz/1Um3JP7vQmnIdn4J/ctx6AqFHUrP9TG1LK+6Z8s6U58+Mf7e+sTBouY7R0bqf
        DsozbtvVs2wU7amflNn3YOnevc1cj53ZhY3PPjr3OXHFX2ld68WyfQfPth5wfdwUWZl3pPjI
        /lvnH5Z76atYVpmyznHW7eyu73j5vYU9pcm06NzdciP+zGkbXyUxn11913T6ncSpGx8pNJut
        P/Sg/aZ8tlLL0uNNK/dY2hz6sK/cRkU74GqemBVX/LcrBhe3zv78z2XhYoucW99Exa+xOm1/
        9SpQ57lBetm98oRvuqfXzFXev2LZAYtzG9ZLvGMVa/YUvvCDPbHnyyK/OQwf7hlNyuQOkJn0
        +va3uItKLMUZiYZazEXFiQC7oNfKQgMAAA==
X-CMS-MailID: 20221109095504epcas5p261f629654560751da44f215a0d6fbce3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021102632epcas5p29333840201aacbae42bc90f651ac85cd
References: <20221021095833.62406-1-vivek.2311@samsung.com>
        <CGME20221021102632epcas5p29333840201aacbae42bc90f651ac85cd@epcas5p2.samsung.com>
        <20221021095833.62406-5-vivek.2311@samsung.com>
        <20221025074424.udfltascaqjc6dhs@pengutronix.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Marc Kleine-Budde <mkl=40pengutronix.de>
> Sent: 25 October 2022 13:14
> To: Vivek Yadav <vivek.2311=40samsung.com>
> Cc: rcsekar=40samsung.com; wg=40grandegger.com; davem=40davemloft.net;
> edumazet=40google.com; kuba=40kernel.org; pabeni=40redhat.com;
> pankaj.dubey=40samsung.com; ravi.patel=40samsung.com;
> alim.akhtar=40samsung.com; linux-can=40vger.kernel.org;
> netdev=40vger.kernel.org; linux-kernel=40vger.kernel.org
> Subject: Re: =5BPATCH 4/7=5D can: mcan: enable peripheral clk to access m=
ram
>=20
> On 21.10.2022 15:28:30, Vivek Yadav wrote:
> > When we try to access the mcan message ram addresses, make sure hclk
> > is not gated by any other drivers or disabled. Enable the clock (hclk)
> > before accessing the mram and disable it after that.
> >
> > This is required in case if by-default hclk is gated.
>=20
> From my point of view it makes no sense to init the RAM during probe.
> Can you move the init_ram into the m_can_chip_config() function? The
> clocks should be enabled then.
>=20
As per my understanding, we should not remove message ram init from probe b=
ecause if message ram init failed then there will be no=20
Storing of Tx/Rx messages onto message ram, so it's better to confirm write=
 operations onto message ram before CAN communication.

So we can kept init_ram in the probe function only, but we will shift init_=
ram into m_can_dev_setup function by the time clks are already enabled.
> Marc
>=20
Thanks for the review.
> --
> Pengutronix e.K.                 =7C Marc Kleine-Budde           =7C
> Embedded Linux                   =7C https://protect2.fireeye.com/v1/url?=
k=3Dfc7bf79b-
> 9c996ac6-fc7a7cd4-000babd9f1ba-3024ea0d5d83d168&q=3D1&e=3D87d053cd-
> e4ab-41e4-a21b-
> c348747c0ce5&u=3Dhttps%3A%2F%2Fwww.pengutronix.de%2F  =7C
> Vertretung West/Dortmund         =7C Phone: +49-231-2826-924     =7C
> Amtsgericht Hildesheim, HRA 2686 =7C Fax:   +49-5121-206917-5555 =7C

