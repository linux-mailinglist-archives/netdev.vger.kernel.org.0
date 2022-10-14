Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB825FED31
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 13:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiJNLah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 07:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJNLad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 07:30:33 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C9BA3A92
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 04:30:30 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221014113029epoutp0378fa94cbae5329bbb61b02a89287f902~d7Bj3pNEY2894228942epoutp032
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 11:30:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221014113029epoutp0378fa94cbae5329bbb61b02a89287f902~d7Bj3pNEY2894228942epoutp032
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1665747029;
        bh=/AKHjCFjBqyfkK74ApxUVgWTDmD07lr2ge/emwzMYeE=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=uC6FvI1hT4raY6iAHLbi24OpTkeNOoKJpjBDfn+9IhkLZvD7LoHbhjoFMehgXKj/2
         goTUSo8OMQexA9SsEDhqvhxo2CFZ1hiZzms0swy7mMTA2inDalU3sCX4UKwNGrgXxd
         ANZU2rntYo7DVpUB1GuiNGXi0UvPedpNrbNBIst8=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20221014113027epcas5p28080fcf9e3aaba7ef3303f8737c1a0fc~d7BivW7Ju2932529325epcas5p2i;
        Fri, 14 Oct 2022 11:30:27 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Mpkhd30Grz4x9Pv; Fri, 14 Oct
        2022 11:30:25 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        05.32.56352.15849436; Fri, 14 Oct 2022 20:30:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221014112322epcas5p1f646c73b101df59b069c0e0c1e3e45d0~d67WW0Cdf3026430264epcas5p1G;
        Fri, 14 Oct 2022 11:23:22 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221014112322epsmtrp22094fab4913f9e7ea24a10ba00d2059a~d67WVwgbH2323323233epsmtrp2L;
        Fri, 14 Oct 2022 11:23:22 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-d1-6349485189fb
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        10.FD.18644.AA649436; Fri, 14 Oct 2022 20:23:22 +0900 (KST)
Received: from FDSFTE314 (unknown [107.122.81.85]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20221014112320epsmtip2a93e0140fa9d23f9f29556bb3546266f~d67Uo-h950486904869epsmtip2Z;
        Fri, 14 Oct 2022 11:23:20 +0000 (GMT)
From:   "Vivek Yadav" <vivek.2311@samsung.com>
To:     "'Marc Kleine-Budde'" <mkl@pengutronix.de>
Cc:     <rcsekar@samsung.com>, <wg@grandegger.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pankaj.dubey@samsung.com>, <ravi.patel@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20221014071114.a6ls5ay56xk4cin3@pengutronix.de>
Subject: RE: [PATCH v2] can: mcan: Add support for handling DLEC error on
 CAN FD
Date:   Fri, 14 Oct 2022 16:53:19 +0530
Message-ID: <00db01d8dfbf$5e38fbd0$1aaaf370$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFA9TupQLxuA4HUejy/jSNcE77YKQHiGD9PArXv/PmvGMpyAA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLJsWRmVeSWpSXmKPExsWy7bCmhm6gh2eyQfNvYYs551tYLJ4ee8Ru
        cWFbH6vFqu9TmS0u75rDZrF+0RQWi2MLxCy+nX7DaLFo6xd2i4cf9rBbzLqwg9Vi6b2drA48
        HltW3mTyWLCp1OPjpduMHptWdbJ59P818Hi/7yqbR9+WVYwenzfJBXBEZdtkpCampBYppOYl
        56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAN2qpFCWmFMKFApILC5W0rez
        KcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOuHRAouC6UsXX2bsY
        Gxh7pbsYOTkkBEwkdkx6yNrFyMUhJLCbUaJjRjMbhPOJUeJKy1R2COczo8TRjffZYFo2r7nC
        CmILCexilJg6Kxii6DmjxLQrn1hAEmwCOhLNk/8ygtgiAnoSvycsYgIpYhaYySSxf+ofZpAE
        p4CtxKIjb8CKhAWCJM49fMAEYrMIqEo8utMFFucVsJTYPm0GK4QtKHFy5hOwBcwC2hLLFr5m
        hrhIQeLn02WsEMucJB5e28kMUSMucfRnD5DNAVRzgUPiXihEuYvEurcX2SFsYYlXx7dA2VIS
        n9/thXoyWWLHv05WCDtDYsHEPYwQtr3EgStzWEBGMgtoSqzfpQ8RlpWYemodE8RWPone30+Y
        IOK8EjvmwdgqEi8+T2CFuEZKovec8ARGpVlI/pqF5K9ZSO6fhbBsASPLKkbJ1ILi3PTUYtMC
        47zUcnhsJ+fnbmIEp2Mt7x2Mjx580DvEyMTBeIhRgoNZSYT3tZJnshBvSmJlVWpRfnxRaU5q
        8SFGU2BgT2SWEk3OB2aEvJJ4QxNLAxMzMzMTS2MzQyVx3sUztJKFBNITS1KzU1MLUotg+pg4
        OKUamI4fPuzRena36e9bb7uNTu598amJmT3nntw/udSI03dX3TjfkrE1ffuU047ePv1Noiw8
        q5R4JBlvb2DzeBVr8SpsEueuPoEvobVp3cYO37kCYpXf/J0g29Y94azCjiuip+Wre8+7azjt
        lbm1a+K1Sq/glvXCITwbVhdHcMjGCyy+aPqeWYDx0soPb1nc47apmEfP4XzZuLt47q0J+zZ7
        K+m2eb9oTLt/QnrKyXa+T2+9N/85of1+ye9Y69n8gZbbc/asectzrVZuisF5b9fkzmerXxqy
        n0l4Ypqw7PqKFGHrBoGP1eb35zB6ft5163+LY/vhqPs/LIL5pnwpi321X2nl8yOTFY4mv5bd
        wh9+/4wSS3FGoqEWc1FxIgB/3sPtUAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsWy7bCSvO4qN89kg5WneCzmnG9hsXh67BG7
        xYVtfawWq75PZba4vGsOm8X6RVNYLI4tELP4dvoNo8WirV/YLR5+2MNuMevCDlaLpfd2sjrw
        eGxZeZPJY8GmUo+Pl24zemxa1cnm0f/XwOP9vqtsHn1bVjF6fN4kF8ARxWWTkpqTWZZapG+X
        wJUx+U8zY8ErxYrvzSuYGxinSXUxcnJICJhIbF5zhbWLkYtDSGAHo0TbwzOsEAkpiSlnXrJA
        2MISK/89ZwexhQSeMkosvRgNYrMJ6Eg0T/7LCGKLCOhJ/J6wiAlkELPAUiaJKVsXskBM3cco
        0fL2PhtIFaeArcSiI2/AOoQFAiQ61y5nArFZBFQlHt3pAovzClhKbJ82gxXCFpQ4OfMJ2BXM
        AtoSvQ9bGWHsZQtfM0NcpyDx8+kyVogrnCQeXtvJDFEjLnH0Zw/zBEbhWUhGzUIyahaSUbOQ
        tCxgZFnFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcm1paOxj3rPqgd4iRiYPxEKME
        B7OSCO9rJc9kId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZODil
        Gpgkdi/89Prf+tuBx4/oTNxzxuGP/PbAlbNdfgRc3C/6eobA8WcR81Wyrq9Iz/U3n218cuOW
        K9s43/C3GCqULWKMWmYpu/hNx7yThVItbxztGV2PN2SuvHI6Qb1K+fo/960uHK2KRexZa26W
        vdzxJaTuzf7pPyrZWF+815j8LGKL0vnXfFczQ2YZqVyTWPN1TsXKx00ZrA81uP14orTy7nwN
        vP147zuvmVkFWaKRopbvJvRevum7WZutctn55kNbPTiTCjnyvi7WNSsxXGYQy5Yl+kqrvdnW
        ckWflsJytqqT1f1PIpx0X85hS5n8xU6DYWbhGvZPhuJpq3YvP16+MUCM0zM8R2ueWuvxz7pf
        dp9WYinOSDTUYi4qTgQACHNNbzwDAAA=
X-CMS-MailID: 20221014112322epcas5p1f646c73b101df59b069c0e0c1e3e45d0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221014053017epcas5p359d337008999640fa140c691f47bc79c
References: <CGME20221014053017epcas5p359d337008999640fa140c691f47bc79c@epcas5p3.samsung.com>
        <20221014050332.45045-1-vivek.2311@samsung.com>
        <20221014071114.a6ls5ay56xk4cin3@pengutronix.de>
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
> From: Marc Kleine-Budde =5Bmailto:mkl=40pengutronix.de=5D
> Sent: 14 October 2022 12:41
> To: Vivek Yadav <vivek.2311=40samsung.com>
> Cc: rcsekar=40samsung.com; wg=40grandegger.com; davem=40davemloft.net;
> edumazet=40google.com; kuba=40kernel.org; pabeni=40redhat.com;
> pankaj.dubey=40samsung.com; ravi.patel=40samsung.com; linux-
> can=40vger.kernel.org; netdev=40vger.kernel.org; linux-
> kernel=40vger.kernel.org
> Subject: Re: =5BPATCH v2=5D can: mcan: Add support for handling DLEC erro=
r on
> CAN FD
>=20
> On 14.10.2022 10:33:32, Vivek Yadav wrote:
> > When a frame in CAN FD format has reached the data phase, the next CAN
> > event (error or valid frame) will be shown in DLEC.
> >
> > Utilizes the dedicated flag (Data Phase Last Error Code: DLEC flag) to
> > determine the type of last error that occurred in the data phase of a
> > CAN FD frame and handle the bus errors.
> >
> > Signed-off-by: Vivek Yadav <vivek.2311=40samsung.com>
> > ---
> > This patch is dependent on following patch from Marc:
> > =5B1=5D:
> > https://lore.kernel.org/all/20221012074205.691384-1-mkl=40pengutronix.d=
e
> > /
> >
> >  drivers/net/can/m_can/m_can.c =7C 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/can/m_can/m_can.c
> > b/drivers/net/can/m_can/m_can.c index 18a138fdfa66..8cff1f274aab
> > 100644
> > --- a/drivers/net/can/m_can/m_can.c
> > +++ b/drivers/net/can/m_can/m_can.c
> > =40=40 -156,6 +156,7 =40=40 enum m_can_reg =7B
> >  =23define PSR_EW		BIT(6)
> >  =23define PSR_EP		BIT(5)
> >  =23define PSR_LEC_MASK	GENMASK(2, 0)
> > +=23define PSR_DLEC_MASK   GENMASK(8, 10)
> >
> >  /* Interrupt Register (IR) */
> >  =23define IR_ALL_INT	0xffffffff
> > =40=40 -876,8 +877,16 =40=40 static int m_can_handle_bus_errors(struct
> net_device *dev, u32 irqstatus,
> >  	if (cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) =7B
> >  		u8 lec =3D FIELD_GET(PSR_LEC_MASK, psr);
> >
> > -		if (is_lec_err(lec))
> > +		if (is_lec_err(lec)) =7B
> >  			work_done +=3D m_can_handle_lec_err(dev, lec);
> > +		=7D else =7B
>=20
> In case of high interrupt latency there might be lec and dlec errors pend=
ing.
> As this is error handling and not the hot path, please check for both, i.=
e.:
Okay will do that.
>=20
>                 if (is_lec_err(lec))
>                         work_done +=3D m_can_handle_lec_err(dev, lec);
>=20
>                 if (is_lec_err(dlec))
>                         work_done +=3D m_can_handle_lec_err(dev, dlec);
>=20
> > +			u8 dlec =3D FIELD_GET(PSR_DLEC_MASK, psr);
> > +
> > +			if (is_lec_err(dlec)) =7B
> > +				netdev_dbg(dev, =22Data phase error
> detected=5Cn=22);
>=20
> If you add a debug, please add one for the Arbitration phase, too.
I have added the debug print specially for dlec (data phase). So we can dif=
ferentiate lec errors (for all type of frames except FD with BRS) and Data =
phase errors, as we are calling same handler function for both the errors.

If I understood your comment correctly, you are asking something like below=
:
        /* handle protocol errors in arbitration phase */
        if ((cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) &&
-           m_can_is_protocol_err(irqstatus))
+           m_can_is_protocol_err(irqstatus)) =7B
+               netdev_dbg(dev, =22Arbitration phase error detected=5Cn=22)=
;
                work_done +=3D m_can_handle_protocol_error(dev, irqstatus);
+       =7D

If the above implementation is correct as per your review comment, I think =
we don't need the above changes because=20
Debug print for arbitration failure are already there in =22 m_can_handle_p=
rotocol_error=22 function.

>=20
> > +				work_done +=3D m_can_handle_lec_err(dev,
> dlec);
> > +			=7D
> > +		=7D
> >  	=7D
> >
> >  	/* handle protocol errors in arbitration phase */
>=20
> regards,
> Marc
>=20
> --
> Pengutronix e.K.                 =7C Marc Kleine-Budde           =7C
> Embedded Linux                   =7C
> https://protect2.fireeye.com/v1/url?k=3D28e40100-499fab97-28e58a4f-
> 74fe4860001d-8e82bf09edd18d7c&q=3D1&e=3D47b831bd-4118-45e2-977c-
> eac4315bdf6d&u=3Dhttps%3A%2F%2Fwww.pengutronix.de%2F  =7C
> Vertretung West/Dortmund         =7C Phone: +49-231-2826-924     =7C
> Amtsgericht Hildesheim, HRA 2686 =7C Fax:   +49-5121-206917-5555 =7C


