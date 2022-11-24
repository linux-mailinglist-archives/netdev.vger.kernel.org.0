Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA57637562
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiKXJmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiKXJms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:42:48 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535175C766
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:42:42 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221124094240epoutp0461c7c06a5f69a39d38536f6a01365209~qfAIVby722243422434epoutp04S
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 09:42:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221124094240epoutp0461c7c06a5f69a39d38536f6a01365209~qfAIVby722243422434epoutp04S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669282960;
        bh=Ne0RD0QrosRcxErJlyFLLb5vaEZYJjy1mHUEW059JvQ=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=k/3agZPTdCEJhxg3JGY+dFOMK+yqM/Xw3rSacSwU0d/Z2g1Do5MIx0UeGcdVzguzf
         eFOGpVfCoa0HJ4HyoqWFP5QktLEUmshI2vNYdLYRcgJjrXkxT/xw/9tlAw4cU3ma4u
         H90oep2e35b8MijhwcRvM7Jiv7Losdv6mnfVcgXA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221124094239epcas5p312b6ec7151e2b1d3a57b7f4ae602e773~qfAHmLNvW3143031430epcas5p39;
        Thu, 24 Nov 2022 09:42:39 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4NHtMK5RFSz4x9Q3; Thu, 24 Nov
        2022 09:42:37 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        17.CD.39477.D8C3F736; Thu, 24 Nov 2022 18:42:37 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20221124090652epcas5p3ba44d631e567a45ca8e614e2b3638e41~qeg4GOtuT1196511965epcas5p3t;
        Thu, 24 Nov 2022 09:06:52 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221124090652epsmtrp29782bb6b75cc5cfe4a1b1cea24849513~qeg4ENfrz1965419654epsmtrp23;
        Thu, 24 Nov 2022 09:06:52 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-8d-637f3c8d6163
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D8.24.14392.C243F736; Thu, 24 Nov 2022 18:06:52 +0900 (KST)
Received: from FDSFTE314 (unknown [107.122.81.85]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20221124090649epsmtip169c9a855d6e7cb497081c9d0d95a68a3~qeg1QdoN42186821868epsmtip1t;
        Thu, 24 Nov 2022 09:06:49 +0000 (GMT)
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
In-Reply-To: <20221123224146.iic52cuhhnwqk2te@pengutronix.de>
Subject: RE: [PATCH v3 1/2] can: m_can: Move mram init to mcan device setup
Date:   Thu, 24 Nov 2022 14:36:48 +0530
Message-ID: <01a101d8ffe4$1797f290$46c7d7b0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKzKt4C0V6WIa1X2lvfORr5q2BWDgH5Y+bNAeiPnOMDLJn5d6xg/cig
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJsWRmVeSWpSXmKPExsWy7bCmpm6vTX2ywao+DYsH87axWRzavJXd
        Ys75FhaL+UfOsVo8PfaI3aLvxUNmiwvb+lgtNj2+xmqx6vtUZouHr8ItLu+aw2Yx4/w+Jov1
        i6awWBxbIGbx7fQbRotFW7+wWzz8sIfdYtaFHawWrXuPsFvcfrOO1WLpvZ2sDqIeW1beZPJY
        sKnU4+Ol24wem1Z1snncubaHzWPzknqP/r8GHu/3XWXz6NuyitHjX9Ncdo/Pm+QCuKOybTJS
        E1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAvlRSKEvMKQUK
        BSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGd8X7KR
        teCmYEX7hEVMDYwX+LoYOTkkBEwkzn9/xAZiCwnsZpSY2h/cxcgFZH9ilGj48IIFwvnGKNF7
        ZyU7TMeRza+hEnsZJc5P6mGCcJ4zSrTfawebxSagI9E8+S8jiC0ioCfxG2gniM0ssJ5F4tsh
        ERCbU8BWYtXX/awgtrCAt8SdqZOYQWwWAVWJ/1NmAs3h4OAVsJQ49csLJMwrIChxcuYTFogx
        2hLLFr5mhjhIQeLn02WsEKvcJC6f/skMUSMucfRnDzPIbRICyzklOpZPZ4RocJGYuvstG4Qt
        LPHq+Baoz6QkPr/bCxVPltjxr5MVws6QWDBxD1SvvcSBK3NYQG5jFtCUWL9LHyIsKzH11Dqo
        F/kken8/YYKI80rsmAdjq0i8+DyBFaQVZFXvOeEJjEqzkHw2C8lns5B8MAth2QJGllWMkqkF
        xbnpqcWmBUZ5qeXw6E7Oz93ECM4CWl47GB8++KB3iJGJg/EQowQHs5IIb71nTbIQb0piZVVq
        UX58UWlOavEhRlNgaE9klhJNzgfmobySeEMTSwMTMzMzE0tjM0Mlcd7FM7SShQTSE0tSs1NT
        C1KLYPqYODilGphYVlRdt58mJRct5aR/6cgpuYfP+4seHuYStPz+5sT5pSLfQvebHPpQwyvY
        Fl+rZfRxaeeDR6LtiuXln+doTL3S+DfmeIT0zvYpzUzXRLZcK5kTNYcreqJ2l5BLs0XUxuMX
        qu+u2v8xoLT+tGnrtQl7d19p/7PaQU7WrufA+/ld/cKvX1bEnt3p016nl9yr8OJEVl9kz72T
        5q9O+R3TcBH7lPJ9V/TVP+15Ao498f+T1R2f5JlG7L2yaH5PlMuD2Ze9/m3mNGQ6anVCnM8v
        /sMMo5BvpSu3nZZbcFT58CWv/l03m94Ky6aWs8zYUKwZmp4s0XPPSqrn6AHOZ6vvvqtfbKVZ
        0NgaPSOqdv7b9XlKLMUZiYZazEXFiQBkgaxZiwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUzMcRzHfe/3WBy/7nr4ink4y0PqFLGvLXlY7Edsedg8jOW3+i1xd879
        5PGm5uGPbiQq6qZcIbqZuNMVIutRD6qJUt2QOpySUFpR7Lqx/nvt837Y+48PjUk6cG86RnWQ
        16g4hYx0xS2lsmn+fkFxkQHlek/0LtNCohJzPoWu1J/G0dWyOgLZKt5TKPFTO4YaLIkEMnU0
        Ecg4kIqh9s9bUePDKyRKq38iQnnZKTiqMHiinzXdAGXn91GovbeIQvqGQgKdeVxGobbuOwS6
        8eYBscKDvZ/bImINplj224s2wJqMCSRrbSoiWfP1OPb8cAD79ckrkk28bwTsyMkMiv1hmhY+
        fodrcBSviDnEaxaE7HbdU5BhJtRJbkf0Ny4R8SBhog640JAJgmXmLlwHXGkJ8wjAjLvplFPw
        him1dtzJUpg78pFymmwAWp9dwxwCyfjBU8nDwMHujBz+SsoWOUwYU4nDty1vCGeiB8DWzrzR
        hAuzDBr7iwkHS5kwaE29OHrHGR/4JyWd1AGaFjNLYfXQOsdZzLjBqvTO0RUYMx/aWmz/OSer
        C3OumwEHbTmEc8Qa2FgziDk9XrB88CyWBKT6MVX6MVX6MVX6MREDwI1gMq8WlNFKIVAdqOIP
        ywVOKcSqouWR+5UmMPoHvvMKQYGxV14CRDQoAZDGZO7iuLXaSIk4ijt6jNfsj9DEKnihBEyh
        cZmXuEFXFSFhormD/D6eV/Oaf6qIdvGOF6XXzirSVPbYmz3qD1VmZaaEdL24Hj4sdPmaLEjX
        s2bqxrqF0pgt/Movi97eo1+nnXCLUlRn5fpM2PXHuokyhWJF58JDy7V+y5ItLas+cY8Nff1p
        gtYv4pZPP7fNZX3Ize45Cex38zGSOOMl/lzxIWdnc5biXU+jONaeZxhX2rr49OXjTcq9Hu6L
        t1vdpWVc2+VZGPuj015D+g/M/tV04OXAR9/brPbordXzC9ebo74v/y1RedbmaJf8nnTpqVvb
        zenFQ9SGmfavz4cazwc8EgXfXXTncPVg8fF73j51SzM21xXYgjrkDcjYVzB3pTkMSMQXNiUL
        W7+R+eFqRena0G01MlzYwwX6YhqB+wu4qgMFdgMAAA==
X-CMS-MailID: 20221124090652epcas5p3ba44d631e567a45ca8e614e2b3638e41
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
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        PDS_BAD_THREAD_QP_64,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Marc Kleine-Budde <mkl=40pengutronix.de>
> Sent: 24 November 2022 04:12
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
> Subject: Re: =5BPATCH v3 1/2=5D can: m_can: Move mram init to mcan device
> setup
>=20
> On 22.11.2022 16:24:54, Vivek Yadav wrote:
> > When we try to access the mcan message ram addresses, hclk is gated by
> > any other drivers or disabled, because of that probe gets failed.
> >
> > Move the mram init functionality to mcan device setup called by mcan
> > class register from mcan probe function, by that time clocks are
> > enabled.
>=20
> Why not call the RAM init directly from m_can_chip_config()?
>=20
m_can_chip_config function is called from m_can open.

Configuring RAM init every time we open the CAN instance is not needed, I t=
hink only once during the probe is enough.=20

If message RAM init failed then fifo Transmit and receive will fail and the=
re will be no communication. So there is no point to =22open and Configure =
CAN chip=22.

=46rom my understanding it's better to keep RAM init inside the probe and i=
f there is a failure happened goes to CAN probe failure.
> Marc
Thanks for reviewing the patch.
>=20
> --
> Pengutronix e.K.                 =7C Marc Kleine-Budde           =7C
> Embedded Linux                   =7C
> https://protect2.fireeye.com/v1/url?k=3D818c3690-e0f1dc13-818dbddf-
> 74fe48600158-a08b6a4bfa0b043e&q=3D1&e=3D315ed8d1-1645-4c16-b5e7-
> 2a250ae36941&u=3Dhttps%3A%2F%2Fwww.pengutronix.de%2F  =7C
> Vertretung West/Dortmund         =7C Phone: +49-231-2826-924     =7C
> Amtsgericht Hildesheim, HRA 2686 =7C Fax:   +49-5121-206917-5555 =7C

