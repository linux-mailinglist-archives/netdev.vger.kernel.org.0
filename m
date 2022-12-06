Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6053D643E85
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 09:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbiLFI0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 03:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbiLFI0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 03:26:23 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91050E0CA
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 00:26:20 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221206082616epoutp037bf44bba5a8cce0cbce43c823c87dcd2~uJs2n-5er1563815638epoutp03G
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:26:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221206082616epoutp037bf44bba5a8cce0cbce43c823c87dcd2~uJs2n-5er1563815638epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1670315176;
        bh=IhcQl0HPVLdtWeNLGBj/d+NRbYFd5rnYwId9KFHJKc0=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=aDoNSPHvgZBaBe6fiF2BQ6FDkY/L7nu0iqkmYjy154SsSwFGqSdhgGpTo+27R8ALz
         4ABLMQxNwIZqbzOkABVvQb9y9Y29yvRURyqQCdNtnDomjGFJqu8kqCQwyDYNXwWwpx
         DxJ+/oVG6xEGEjEwVrXwsf12zDlYinUxDoueXrow=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20221206082615epcas5p21c28596a2f86b5089fb31c6483ffe2de~uJs13VYYH1050210502epcas5p2m;
        Tue,  6 Dec 2022 08:26:15 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4NRD5d6w9rz4x9Q7; Tue,  6 Dec
        2022 08:26:13 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D9.08.01710.5ACFE836; Tue,  6 Dec 2022 17:26:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20221206082613epcas5p3694abb2a9be9aca2788f7b91e5845beb~uJszYeC1t0439104391epcas5p3f;
        Tue,  6 Dec 2022 08:26:13 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221206082613epsmtrp2e2849adfe87d80b5097f89408c065b53~uJszXNzC-0530205302epsmtrp2J;
        Tue,  6 Dec 2022 08:26:13 +0000 (GMT)
X-AuditID: b6c32a49-a41ff700000006ae-27-638efca5780f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BB.32.14392.4ACFE836; Tue,  6 Dec 2022 17:26:12 +0900 (KST)
Received: from pankajdubey02 (unknown [107.122.12.6]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221206082606epsmtip1d722ea017a8488472beba38f2e7d48ab~uJss-GzeB1603816038epsmtip1l;
        Tue,  6 Dec 2022 08:26:05 +0000 (GMT)
From:   "Pankaj Dubey" <pankaj.dubey@samsung.com>
To:     "'Vivek Yadav'" <vivek.2311@samsung.com>, <rcsekar@samsung.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <wg@grandegger.com>,
        <mkl@pengutronix.de>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <ravi.patel@samsung.com>,
        <alim.akhtar@samsung.com>, <linux-fsd@tesla.com>,
        <robh+dt@kernel.org>
Cc:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <aswani.reddy@samsung.com>, <sriranjani.p@samsung.com>
In-Reply-To: <20221122105455.39294-3-vivek.2311@samsung.com>
Subject: RE: [PATCH v3 2/2] arm64: dts: fsd: Add MCAN device node
Date:   Tue, 6 Dec 2022 13:56:01 +0530
Message-ID: <017901d9094c$669e5fc0$33db1f40$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKzKt4C0V6WIa1X2lvfORr5q2BWDgLDsng4Azn5VYCsfFVowA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te1BUZRjG51x3sVk7cfMLG9vONM7IdZfLdnBABS9zGmlEk2oow+NyZmFY
        zm67ixKjYYghxK7akAazrAuy27CiyEokIJsuqIMEbBIWSQUiCggJGXKppF0OFf8973t+z/d+
        z/nmFSLec3iAMJ3TsRqOUZL4CrShdV1giOUvg1ySf0pGDZgacMp56SsBZezOR6kzbV0YNXzj
        noAyjAwilKvBgFH2oTsYZZv5HKEGx96mepqMOPVFtwOmaitLUOqG2Z962jEOUYOTVwRUmesy
        Rh1taRNQd8cvYNR8RStKWX5pxDb50fXVfTBttmfRU7fvQrTdVojT/Xeu4PSlqlz6+N8S+rGj
        F6cN9TaIfpZXLqCf2NckPpecEZPGMqmsRsxyclVqOqeIJbe/mbI5JUomkYZIo6nXSDHHZLKx
        5JaExJBt6Up3SlK8n1FmuVuJjFZLhm2I0aiydKw4TaXVxZKsOlWpjlSHaplMbRanCOVY3Xqp
        RBIe5Qb3ZqQVuPpwtdEre+xmG34YOiEsgryEgIgE+slqtAhaIfQmmiHg+KNOwBe/Q6C8cgLm
        i6cQMPV+jBdBwkWL0aTg+y0QGJmrWbKPQcA6dA33nIsTYaBr1oR5PvgSPTDoOOrAPQVC5MHA
        8ci5SHkRMaB/uhHxaB8iDhQ3ty9qlHgVTE8MLDIiIhp8Zy6FeP0CaC+9j3o0QgQBa8UjhE8h
        BnPDVsyjfYl4cKpxBuOZVWD0epuAZ855gYXiIF5vAfOl00teHzB2s36JCQBPfmtZipkALM00
        39aBi8UWlNcbwdXvjagHQYh1oLYpjJ+0Euj/vA/zThE49ok3T68FMw+/XRr0Ehg8YoF5TYNf
        r1XhJ6BXypblKluWq2zZ/cv+H2aGUBv0IqvWZipYbZRayrEH/ntvuSrTDi3uQODrl6GfByZD
        nRAshJwQECKkr2ikTi/3FqUyH+awGlWKJkvJap1QlPtnn0QC/OQq9xJxuhRpZLQkUiaTRUZH
        yKTkKpGl5Jjcm1AwOjaDZdWs5l8fLPQKOAyfzV9dX1Mq192q2NmauydObN/1MG4sbCHtsxz3
        Npbs7/Yrf/6NzUmOqZVJAtO+XJd1OG6X7XQcN67JNv44Fz1zYBO0IbPCFDFdum93fu11UgFz
        wU0Th9Z8ND6bl1Tonxqew11kVAnW8gvfzL5nqIyX+LdXjg5tExUEG/qmzZj5Nt4l7PjJvj1i
        t0t/OriuK6LRnLc1/lZ/97MFrFM8nz0aTxaNFGzEzsG9pnt7HugP/jD76bvJPluPEwqba0fP
        eunqnWebDnbXcKFz8qmXldUfvDOwtjDx/eRwvbH1/Jl6vx1HkPCCQuXkg2zJW4eCvq6iGzuv
        dqLOhC/9rZLHs+eb9pKoNo2RBiIaLfMPYcEMPowEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsWy7bCSnO6SP33JBq2TLS0ezNvGZnFo81Z2
        iznnW1gs5h85x2rx9Ngjdou+Fw+ZLS5s62O12PT4GqvFqu9TmS0evgq3uLxrDpvFjPP7mCzW
        L5rCYnFsgZjFt9NvGC0eftjDbjHrwg5Wi9a9R9gtbr9Zx2rxa+FhFoul93ayOoh6bFl5k8lj
        waZSj4+XbjN6bFrVyeZx59oeNo/NS+o9+v8aeLzfd5XNo2/LKkaPf01z2T0+b5IL4I7isklJ
        zcksSy3St0vgyrhxo5+x4AlHxcnPHUwNjDfYuxg5OCQETCTmzEvvYuTiEBLYzSixu3Ubcxcj
        J1BcRmLy6hWsELawxMp/z9khil4wSnw7f50dJMEmoC9x7sc8VpCEiMBjJom/3XPZQBxmgS4m
        ibM3/rGAVAkJ7GWU+H03AMTmFLCRuPN1J9gKYQFHiZ7dJ8FsFgEVia9vH7CB2LwClhIXF8xk
        hLAFJU7OfAI2h1lAW6L3YSsjjL1s4WuoUxUkfj5dBnaqiICTxLSd31khasQlXh49wj6BUXgW
        klGzkIyahWTULCQtCxhZVjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525iBKcDLc0djNtX
        fdA7xMjEwXiIUYKDWUmE98XG3mQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRm
        p6YWpBbBZJk4OKUamDbPMZ9fvPuHQszS1jOLur/sYt15ILtBV7FpRumOzSu7zVZr/f7/bWHr
        y0nr7jyUW5x6brlO08eWmUc+TvnE8/jCVw/TmSnzG5JzF6rJHF2ld/lbxY77HJVzNkjcTFDb
        NZXRX8UkdMJ3O59zq0xvfyx2VHaaKLDsZKqbcsLMCVf+Hsi7eKXqoF7U4ddvvwTd4Hwo+V53
        9dOGMgOnLfzhWUvKd9zP2pD1ziL05rSL16YlzNnzg01Z18XnyWy5m93VdUY82/KezHySVCga
        s25rxccmybINa4wKvP3D5qgmsJR79AS4nd193eCwx3yzdZdsE0wEumbc/K8o5RpXuT3DeN6B
        wrZnH/qXX0xJqT0i8mCJEktxRqKhFnNRcSIAwQ4KVHYDAAA=
X-CMS-MailID: 20221206082613epcas5p3694abb2a9be9aca2788f7b91e5845beb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221122105027epcas5p2237c5bc9ab02cf12f6e0f603c5bb90c4
References: <20221122105455.39294-1-vivek.2311@samsung.com>
        <CGME20221122105027epcas5p2237c5bc9ab02cf12f6e0f603c5bb90c4@epcas5p2.samsung.com>
        <20221122105455.39294-3-vivek.2311@samsung.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
> From: Vivek Yadav <vivek.2311=40samsung.com>
> Sent: Tuesday, November 22, 2022 4:25 PM
> To: rcsekar=40samsung.com; krzysztof.kozlowski+dt=40linaro.org;
> wg=40grandegger.com; mkl=40pengutronix.de; davem=40davemloft.net;
> edumazet=40google.com; kuba=40kernel.org; pabeni=40redhat.com;
> pankaj.dubey=40samsung.com; ravi.patel=40samsung.com;
> alim.akhtar=40samsung.com; linux-fsd=40tesla.com; robh+dt=40kernel.org
> Cc: linux-can=40vger.kernel.org; netdev=40vger.kernel.org; linux-
> kernel=40vger.kernel.org; linux-arm-kernel=40lists.infradead.org; linux-s=
amsung-
> soc=40vger.kernel.org; devicetree=40vger.kernel.org;
> aswani.reddy=40samsung.com; sriranjani.p=40samsung.com; Vivek Yadav
> <vivek.2311=40samsung.com>
> Subject: =5BPATCH v3 2/2=5D arm64: dts: fsd: Add MCAN device node
>=20
> Add MCAN device node and enable the same for FSD platform.
> This also adds the required pin configuration for the same.
>=20
> Signed-off-by: Sriranjani P <sriranjani.p=40samsung.com>
> Signed-off-by: Vivek Yadav <vivek.2311=40samsung.com>
> ---

Looks good to me.=20
Reviewed-by: Pankaj Dubey <pankaj.dubey=40samsung.com>

