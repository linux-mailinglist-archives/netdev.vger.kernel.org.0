Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8DE63E8E6
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 05:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiLAEhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 23:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiLAEhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 23:37:13 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D595277425
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 20:37:10 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221201043708epoutp01ebc35c2d0e8b7359bbadab267bb37673~skWXsAaDQ3044330443epoutp01O
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 04:37:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221201043708epoutp01ebc35c2d0e8b7359bbadab267bb37673~skWXsAaDQ3044330443epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669869428;
        bh=z/uj3aw1pAluhqEep2srfIlcP+du9f+FkKAdDbyUsiY=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=KAtXC1NuHE5vcNPAEUlfx9BJPpR2qpVPvcoP8D3/NV/ayGPRchZVP3giTgyaHSyuI
         A+XK/ZtUpRsAgsAFMgLhWdHFyUqfUYpBdicLTYFcT2uEUC7npcR1DtR4s2poMLbrz6
         1+HoGeV/8w2JJn40kUNlxkSoHqY4olWpvpkCDLE0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221201043708epcas5p4ec9c2d060a41756dee37e1d4251756aa~skWXAlGLD1260512605epcas5p4W;
        Thu,  1 Dec 2022 04:37:08 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4NN3FZ2q17z4x9Pt; Thu,  1 Dec
        2022 04:37:06 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EE.64.56352.27F28836; Thu,  1 Dec 2022 13:37:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221201041110epcas5p1b0f4efd9b6c225ab5203d840099f649f~sj-sFqa6D0484304843epcas5p1M;
        Thu,  1 Dec 2022 04:11:10 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221201041110epsmtrp203f02a4b4228ebe1be25ea2b6f0baa04~sj-sD_scY1904419044epsmtrp2i;
        Thu,  1 Dec 2022 04:11:10 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-55-63882f725909
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        07.F7.18644.D5928836; Thu,  1 Dec 2022 13:11:09 +0900 (KST)
Received: from FDSFTE314 (unknown [107.122.81.85]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20221201041104epsmtip1fbe8af72afac5e3640d702a0af30fb0f~sj-m4_qG_2592925929epsmtip1W;
        Thu,  1 Dec 2022 04:11:04 +0000 (GMT)
From:   "Vivek Yadav" <vivek.2311@samsung.com>
To:     "'Marc Kleine-Budde'" <mkl@pengutronix.de>
Cc:     <rcsekar@samsung.com>, <krzysztof.kozlowski+dt@linaro.org>,
        <wg@grandegger.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <pankaj.dubey@samsung.com>,
        <ravi.patel@samsung.com>, <alim.akhtar@samsung.com>,
        <linux-fsd@tesla.com>, <robh+dt@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <aswani.reddy@samsung.com>, <sriranjani.p@samsung.com>
In-Reply-To: <20221124145405.d67cb6xmoiqfdsq3@pengutronix.de>
Subject: RE: RE: [PATCH v3 1/2] can: m_can: Move mram init to mcan device
 setup
Date:   Thu, 1 Dec 2022 09:40:50 +0530
Message-ID: <01f901d9053a$f138bdd0$d3aa3970$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKzKt4C0V6WIa1X2lvfORr5q2BWDgH5Y+bNAeiPnOMDLJn5dwD4TowRAqfPl+usTqoaEA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJsWRmVeSWpSXmKPExsWy7bCmum6RfkeywZ1ZfBYP5m1jszi0eSu7
        xZzzLSwW84+cY7V4euwRu0Xfi4fMFhe29bFabHp8jdVi1fepzBYPX4VbXN41h81ixvl9TBbr
        F01hsTi2QMzi2+k3jBaLtn5ht3j4YQ+7xawLO1gtWvceYbe4/WYdq8XSeztZHUQ9tqy8yeSx
        YFOpx8dLtxk9Nq3qZPO4c20Pm8fmJfUe/X8NPN7vu8rm0bdlFaPHv6a57B6fN8kFcEdl22Sk
        JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAfamkUJaYUwoU
        CkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM6YemQ/
        Y0GveMWTQxdYGhg/C3UxcnJICJhIXPu3mBHEFhLYzShxt9Oni5ELyP7EKPFg3kFGCOczo8SJ
        3W1sMB2X3z5mgujYxSjxb00NRNFzRolb15ewgCTYBHQkmif/BRsrIqAn8XvCIrAGZoH1LBLf
        DomA2JwCthK3vk5mBbGFBQIl3t1pAKtnEVCR2PC4F6yeV8BSovnuF0YIW1Di5MwnLBBztCWW
        LXzNDHGQgsTPp8tYIXaFSXz8dIwZokZc4ujPHqia+ZwSH5+lQNguElP//2SHsIUlXh3fAmVL
        SXx+txfqyWSJHf86WSHsDIkFE/cwQtj2EgeuzAG6gQNovqbE+l36EGFZiamn1kG9yCfR+/sJ
        E0ScV2LHPBhbReLF5wmsIK0gq3rPCU9gVJqF5LFZSB6bheSBWQjLFjCyrGKUTC0ozk1PLTYt
        MM5LLYfHdnJ+7iZGcA7Q8t7B+OjBB71DjEwcjIcYJTiYlUR4Oz63JQvxpiRWVqUW5ccXleak
        Fh9iNAWG9kRmKdHkfGAWyiuJNzSxNDAxMzMzsTQ2M1QS5108QytZSCA9sSQ1OzW1ILUIpo+J
        g1OqgclL6OHyxcktq85Fm/D27RWVtlyv+a6zNvJA7VnntSERGwTOrPjySWhFN9cPvavfliZ3
        HXF+NkW8cmHgMqnPUVUvG4V4KgLebONWr71/ueNvTLL0tZC2pHMhvhoPlS2NI2bPXFa7+sHC
        2mXyDjHtxlfV/n049fmZBUu6W/5aoeUK2rsLihRD1RVfiSozzrpRffTgJcsa5uiz+2PnTGR1
        YzkT/zhuzc3mjJ4sr4UzfwhFW12ezlPoe7im74DzjeTp11L+SPBfCjTODzyisCb/GWPssZ9v
        4ieLCGVMOjo5vOtXFutqLRGT7gzfv77zedR//72xQKp51bN/EgzanqJtVeuapS+bJ9yaxCHZ
        0xjwQ4mlOCPRUIu5qDgRAA7kQnWKBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0yMcRzHfe95nnue4rrHXe6+splOm/XrUYZ9WcwWesyP8Edis5w8q1td
        bs8VyaZIpigscp2jH7h1Z8nukkpCTpZfhYmkOHf9ICUqSTLrbrb+e23vX58/PhQmceI+lCop
        meOTlIkKoSde9UAxN3in//HYkCLdcvTxUpUQNVhvksjQfBRHRbbnBOpq/ESivF47hlqq8ghk
        cbQSyDx6DkP2L9vQq1qDEOma6wWoovQsjhqLZejnk68Ald4cJpF9sI5E+pZqAmXdsZGo/et1
        Al3trCFWzWIrTW0CttiSwn5/2Q5YizlbyL5vrROy1ivp7KmJEPZb/Wshm1dpBuzfIxdJdsgy
        d/P0HZ5he7hE1T6OX7hyl2f84wtnSE2TLLW8zSnMABWSHOBBQXoxfNXvEOQAT0pCVwM4VF9I
        uAUfePbpZ9zNUmj620O6TV0AtltLwaQgpINgZv6Ei71pBo6fLnU1YfQjHH5o6yTciWcCOGwb
        xSZdHvQK+G4k3zUhpSOhqaPMNYHTfvCGI1cwySJ6GczsGAZungmbCp0uD0YHwlx7FvjPxpI+
        zH3ePDjWZSTcV0TB7z8aMbdHDh+OncROA6l+SpV+SpV+SpV+SqQY4GYwm9No1XFqbahmURK3
        n9Eq1dqUpDgmdq/aAlyPEBBQDerMg0wDEFCgAUAKU3iLjg8di5WI9igPpHH83hg+JZHTNoA5
        FK6Qi1pymmIkdJwymUvgOA3H/1cFlIdPhiDig2ydDhP1Pw0ekP6xHVYFOUZu9Wzt9fti1Uem
        GZc405t9l6+yj+czY6rIASJxY3stL8q13V/v0Zjlb5g/HpYqXjtWtxV/E9C6o7ZAI55pDP5t
        CIvO/MUclG7yggOFGb3mfN5eZa6XOgp9vU/NkK3JZPpOpDq7NwTG7I5K2RS0whBYEyJfQIhr
        jKE6VeX2KLm4u79kOlOeXgTDz+Nvl1nv7ja2eplkVInxthfbNxr24mr2aEHZIF3ZoVtarjoE
        izb2FNh8dt6LuPZMnKwpH2HDSW305QcvfD9NY9riqARTckT06y1+6t9yZedB9a2JoXNUcVoQ
        r1vtPy9NrMC18crQAIzXKv8BMvCK1XcDAAA=
X-CMS-MailID: 20221201041110epcas5p1b0f4efd9b6c225ab5203d840099f649f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221122105022epcas5p3f5db1c5790b605bac8d319fe06ad915b
References: <20221122105455.39294-1-vivek.2311@samsung.com>
        <CGME20221122105022epcas5p3f5db1c5790b605bac8d319fe06ad915b@epcas5p3.samsung.com>
        <20221122105455.39294-2-vivek.2311@samsung.com>
        <20221123224146.iic52cuhhnwqk2te@pengutronix.de>
        <01a101d8ffe4$1797f290$46c7d7b0$@samsung.com>
        <20221124145405.d67cb6xmoiqfdsq3@pengutronix.de>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        PDS_BAD_THREAD_QP_64,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Marc Kleine-Budde <mkl=40pengutronix.de>
> Sent: 24 November 2022 20:24
> To: Vivek Yadav <vivek.2311=40samsung.com>
> Cc: rcsekar=40samsung.com; krzysztof.kozlowski+dt=40linaro.org;
> wg=40grandegger.com; davem=40davemloft.net; edumazet=40google.com;
> kuba=40kernel.org; pabeni=40redhat.com; pankaj.dubey=40samsung.com;
> ravi.patel=40samsung.com; alim.akhtar=40samsung.com; linux-fsd=40tesla.co=
m;
> robh+dt=40kernel.org; linux-can=40vger.kernel.org; netdev=40vger.kernel.o=
rg;
> linux-kernel=40vger.kernel.org; linux-arm-kernel=40lists.infradead.org; l=
inux-
> samsung-soc=40vger.kernel.org; devicetree=40vger.kernel.org;
> aswani.reddy=40samsung.com; sriranjani.p=40samsung.com
> Subject: Re: RE: =5BPATCH v3 1/2=5D can: m_can: Move mram init to mcan de=
vice
> setup
>=20
> On 24.11.2022 14:36:48, Vivek Yadav wrote:
> > > Why not call the RAM init directly from m_can_chip_config()?
> > >
> > m_can_chip_config function is called from m_can open.
> >
> > Configuring RAM init every time we open the CAN instance is not
> > needed, I think only once during the probe is enough.
>=20
> That probably depends on you power management. If I add a regulator to
> power the external tcan4x5x chip and power it up during open(), I need to
> initialize the RAM.
>=20
Thanks for the clarification,
There is one doubt for which I need clarity if I add ram init in m_can_chip=
_config.

In the current implementation, m_can_ram_init is added in the probe and m_c=
an_class_resume function.
If I add the ram init function in chip_config which is getting called from =
m_can_start, then m_can_init_ram will be called two times, once in resume a=
nd next from m_can_start also.

Can we add ram init inside the m_can_open function itself?
Because it is independent of m_can resume functionality.

> > If message RAM init failed then fifo Transmit and receive will fail
> > and there will be no communication. So there is no point to =22open and
> > Configure CAN chip=22.
>=20
> For mmio devices the RAM init will probably not fail. There are return va=
lues
> and error checking for the SPI attached devices. Where the SPI
> communication will fail. However if this is problem, I assume the chip wi=
ll not
> be detected in the first place.
>=20
> > From my understanding it's better to keep RAM init inside the probe
> > and if there is a failure happened goes to CAN probe failure.
>=20
> Marc
>=20
> --
> Pengutronix e.K.                 =7C Marc Kleine-Budde           =7C
> Embedded Linux                   =7C
> https://protect2.fireeye.com/v1/url?k=3D2053d9ab-7fc8e0b4-205252e4-
> 000babdfecba-a8c309c53e3358f5&q=3D1&e=3Dc0cfd0e2-a422-4821-a49d-
> 113cfa4da9cb&u=3Dhttps%3A%2F%2Fwww.pengutronix.de%2F  =7C
> Vertretung West/Dortmund         =7C Phone: +49-231-2826-924     =7C
> Amtsgericht Hildesheim, HRA 2686 =7C Fax:   +49-5121-206917-5555 =7C

