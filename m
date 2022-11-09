Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0BAD622915
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 11:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiKIKwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 05:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiKIKw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 05:52:27 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6F927CC6
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:52:18 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221109105216epoutp0439993efa9184b933348ca5fbc123257a~l5Rn71Upk0204302043epoutp04H
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:52:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221109105216epoutp0439993efa9184b933348ca5fbc123257a~l5Rn71Upk0204302043epoutp04H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667991136;
        bh=w9Zc6JFIS3hiKLUCh9R+a4qxPCofwfAVFdRJ3akN168=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=PtMK8+xvXoUUjpGnvFNLjPDEazzAHuMXX4d7ZxQ5zn//n0sC/YY6rhhATEwcTb0c2
         GisicLYDG3VuY8RFDoVzQP86RKFQujLrDXHoRCKGwSGOX7bayRn075BiMYtvIZ5Rrt
         CyGF0EplP/mxFTJ4y2OejXCJBLsUSGemPc7UIYSs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20221109105215epcas5p241fc0e17571ab866af073a08e1b317df~l5RnMdh1q1803118031epcas5p2_;
        Wed,  9 Nov 2022 10:52:15 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4N6hcZ0Xv0z4x9Pw; Wed,  9 Nov
        2022 10:52:14 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F2.21.01710.D568B636; Wed,  9 Nov 2022 19:52:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221109100000epcas5p2ae6d9bb7e2d602363f7d2878bc672fca~l4j_tGxEy2859328593epcas5p2Z;
        Wed,  9 Nov 2022 10:00:00 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221109100000epsmtrp23bdd87efbe23aebff976fb1914316982~l4j_sQbps1163511635epsmtrp2g;
        Wed,  9 Nov 2022 10:00:00 +0000 (GMT)
X-AuditID: b6c32a49-c9ffa700000006ae-fd-636b865de005
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        57.19.18644.F1A7B636; Wed,  9 Nov 2022 18:59:59 +0900 (KST)
Received: from FDSFTE314 (unknown [107.122.81.85]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20221109095958epsmtip26041ff8fe3cb76c3020dd55ea9a2a4dd~l4j8won6v1396413964epsmtip29;
        Wed,  9 Nov 2022 09:59:57 +0000 (GMT)
From:   "Vivek Yadav" <vivek.2311@samsung.com>
To:     "'Marc Kleine-Budde'" <mkl@pengutronix.de>
Cc:     <rcsekar@samsung.com>, <wg@grandegger.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pankaj.dubey@samsung.com>, <ravi.patel@samsung.com>,
        <alim.akhtar@samsung.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20221025081610.h6bjg6nuqdhkupvg@pengutronix.de>
Subject: RE: [PATCH 6/7] can: m_can: Add ECC functionality for message RAM
Date:   Wed, 9 Nov 2022 15:29:56 +0530
Message-ID: <01fa01d8f422$07636710$162a3530$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJD6JMFT7t8BSDsfE8Wj4Sh/mZZ1gFwMrEpAbQ8dpQCiaJb7q0zAQSA
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJsWRmVeSWpSXmKPExsWy7bCmum5sW3aywewlNhYP5m1js5hzvoXF
        4umxR+wWF7b1sVqs+j6V2eLyrjlsFusXTWGxOLZAzOLb6TeMFou2fmG3ePhhD7vFrAs7WC2W
        3tvJ6sDrsWXlTSaPBZtKPT5eus3osWlVJ5tH/18Dj/f7rrJ59G1ZxejxeZNcAEdUtk1GamJK
        apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0MFKCmWJOaVAoYDE
        4mIlfTubovzSklSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMD90v2AoO
        eVecXryYqYFxqlUXIyeHhICJxMq2KyxdjFwcQgK7GSWm/vvGCOF8YpT40PeOGcL5zCjxd+ct
        VpiWpr/fmSASu4ASuxdC9T9nlHhxqZkNpIpNQEeiefJfRhBbREBP4veERUwgNrPAFiaJv+/L
        QGxOAVuJ6ZfWAK3g4BAW8JJ4OtkZJMwioCLx+PU9dhCbV8BSYnrbVDYIW1Di5MwnLBBjtCWW
        LXzNDHGQgsTPp8tYIVa5Sex9s4ERokZc4ujPHrAPJASucEj8af3KBtHgIrFq+XQmCFtY4tXx
        LewQtpTE53d7oWqSJXb864T6OENiwcQ9jBC2vcSBK3NYQG5mFtCUWL9LHyIsKzH11DqoF/kk
        en8/gRrPK7FjHoytIvHi8wRWkFaQVb3nhCcwKs1C8tksJJ/NQvLBLIRlCxhZVjFKphYU56an
        FpsWGOallsPjOzk/dxMjODlree5gvPvgg94hRiYOxkOMEhzMSiK83BrZyUK8KYmVValF+fFF
        pTmpxYcYTYHBPZFZSjQ5H5gf8kriDU0sDUzMzMxMLI3NDJXEeRfP0EoWEkhPLEnNTk0tSC2C
        6WPi4JRqYIo/U73p4ifbU/tWHQ3ibrMv1nns82JONE/j66KT8oelV0yeLnHk6kPWm7e3632L
        bz54YN7maMc1+52Myk/fSP5yT5e95uLhuyv/5K+/Mv3rtheXfBUaJx9qUa64+/j5prSq/wGX
        IuZf37829/Tiot+7njhUaKTr5y3s3XjI2+Pic/n16ZNCbuf+i7q2wlxJakpqRUDmrLpvOl0u
        yw80CxTumcesN7P1y8WTG9/3pKhrKMescjjA51oUMvuiw8vkgB3KXsvV8gzeKvn1frr1+Df/
        JvuYC7cTlq//eMoqQ9OW/0KUaNUX9sKY+UpPp0k9XLjinF5/2+rPL5svv7+VExnwyWxbm8X0
        S1Od2s/tZzJvV2Ipzkg01GIuKk4EAAStx/lXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWy7bCSvK58VXaywcbvNhYP5m1js5hzvoXF
        4umxR+wWF7b1sVqs+j6V2eLyrjlsFusXTWGxOLZAzOLb6TeMFou2fmG3ePhhD7vFrAs7WC2W
        3tvJ6sDrsWXlTSaPBZtKPT5eus3osWlVJ5tH/18Dj/f7rrJ59G1ZxejxeZNcAEcUl01Kak5m
        WWqRvl0CV8b2C0vYC/Z7VtzY84WlgbHHoouRk0NCwESi6e93pi5GLg4hgR2MEr82dTNCJKQk
        ppx5yQJhC0us/PecHaLoKaPEyrbz7CAJNgEdiebJf8EaRAT0JH5PWAQ2iVngEJPE/D+rWSA6
        3jFKrN3dzQxSxSlgKzH90hogm4NDWMBL4ulkZ5Awi4CKxOPX98CG8gpYSkxvm8oGYQtKnJz5
        BOwKZgFtiac3n8LZyxa+Zoa4TkHi59NlrBBHuEnsfbOBEaJGXOLozx7mCYzCs5CMmoVk1Cwk
        o2YhaVnAyLKKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4SrW0djDuWfVB7xAjEwfj
        IUYJDmYlEV5ujexkId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZ
        ODilGphO2G7Q2Jbw/6yExNVvm9g8pCa4Vtz76jn5a03MZrlW7pjnXaaH2/TNy2X6Y+ekTz9b
        H5d7T7i3o4FbOb7mldiKiU4L290EGB5FvLm/L/dDrHJBhkjZv577Mn87Sm8cs7UXK7YNW3Xw
        q4WcqM8a/carrpPfZyfHb1Zx9V1ZN+ek89HjZfyL1yx631DQKufM1xLHwMP05tefNJXff9Mi
        T8rv3/b+526HfsX2FQ/rgtXfSp5YfEbpysPK09dnrwmJf1K+fVNO2bMwIbP58wOW7zl35Yz4
        jqMKnStb73BcuaApkyO08Ynb0yNb36+/8PMIcyi/m+pfyfAlF7ku2oanvpY4Lavzem70gxoF
        BWcmtzwlluKMREMt5qLiRAAH26fGQQMAAA==
X-CMS-MailID: 20221109100000epcas5p2ae6d9bb7e2d602363f7d2878bc672fca
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021102639epcas5p2241192d3ac873d1262372eeae948b401
References: <20221021095833.62406-1-vivek.2311@samsung.com>
        <CGME20221021102639epcas5p2241192d3ac873d1262372eeae948b401@epcas5p2.samsung.com>
        <20221021095833.62406-7-vivek.2311@samsung.com>
        <20221025081610.h6bjg6nuqdhkupvg@pengutronix.de>
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
> Sent: 25 October 2022 13:46
> To: Vivek Yadav <vivek.2311=40samsung.com>
> Cc: rcsekar=40samsung.com; wg=40grandegger.com; davem=40davemloft.net;
> edumazet=40google.com; kuba=40kernel.org; pabeni=40redhat.com;
> pankaj.dubey=40samsung.com; ravi.patel=40samsung.com;
> alim.akhtar=40samsung.com; linux-can=40vger.kernel.org;
> netdev=40vger.kernel.org; linux-kernel=40vger.kernel.org
> Subject: Re: =5BPATCH 6/7=5D can: m_can: Add ECC functionality for messag=
e RAM
>=20
> On 21.10.2022 15:28:32, Vivek Yadav wrote:
> > Whenever MCAN Buffers and FIFOs are stored on message ram, there are
>                                                         RAM
> > inherent risks of corruption known as single-bit errors.
> >
> > Enable error correction code (ECC) data intigrity check for Message
> > RAM to create valid ECC checksums.
> >
> > ECC uses a respective number of bits, which are added to each word as
> > a parity and that will raise the error signal on the corruption in the
> > Interrupt Register(IR).
> >
> > Message RAM bit error controlled by input signal m_can_aeim_berr=5B0=5D=
,
> > generated by an optional external parity / ECC logic attached to the
> > Message RAM.
> >
I will remove this text from commit as this indicates the handling of ECC e=
rror.

> > This indicates either Bit Error detected and Corrected(BEC) or No bit
> > error detected when reading from Message RAM.
>=20
> There is no ECC error handler added to the code.
>=20
Yes, we are not adding the ECC error handler in the code.=20
As per my understanding this is already handled in <m_can_handle_other_err>=
 function.

> > Signed-off-by: Vivek Yadav <vivek.2311=40samsung.com>
> > ---
> >  drivers/net/can/m_can/m_can.c =7C 73
> > +++++++++++++++++++++++++++++++++++
> >  drivers/net/can/m_can/m_can.h =7C 24 ++++++++++++
> >  2 files changed, 97 insertions(+)
> >
> > diff --git a/drivers/net/can/m_can/m_can.c
> > b/drivers/net/can/m_can/m_can.c index dcb582563d5e..578146707d5b
> > 100644
> > --- a/drivers/net/can/m_can/m_can.c
> > +++ b/drivers/net/can/m_can/m_can.c
> > =40=40 -1535,9 +1535,62 =40=40 static void m_can_stop(struct net_device=
 *dev)
> >  	cdev->can.state =3D CAN_STATE_STOPPED;  =7D
> >
> > +int m_can_config_mram_ecc_check(struct m_can_classdev *cdev, int
> > +enable,
> static                                                          =5E=5E=5E=
 bool
> > +				struct device_node *np)
> > +=7B
> > +	int val =3D 0;
> > +	int offset =3D 0, ret =3D 0;
> > +	int delay_count =3D MRAM_INIT_TIMEOUT;
> > +	struct m_can_mraminit *mraminit =3D &cdev->mraminit_sys;
>=20
> Please sort by reverse Christmas tree.
>=20
Okay, I will address this in next patch series.
> > +
> > +	mraminit->syscon =3D syscon_regmap_lookup_by_phandle(np,
> > +							   =22mram-ecc-cfg=22);
>=20
> Please check if syscon_regmap_lookup_by_phandle_args() is better suited.
>=20
Okay, I will check and make it better.
> You probably want to do the syscon lookup once during
> m_can_class_register().
>
Yes, It should be once only, I will address this.
> > +	if (IS_ERR(mraminit->syscon)) =7B
> > +		/* can fail with -EPROBE_DEFER */
>=20
> m_can_config_mram_ecc_check() is called from m_can_open() and
> m_can_close(), returning -EPROBE_DEFER makes no sense there.
>=20
> > +		ret =3D PTR_ERR(mraminit->syscon);
> > +		return ret;
> > +	=7D
> > +
> > +	if (of_property_read_u32_index(np, =22mram-ecc-cfg=22, 1,
> > +				       &mraminit->reg)) =7B
> > +		dev_err(cdev->dev, =22couldn't get the mraminit reg.
> offset=21=5Cn=22);
> > +		return -ENODEV;
> > +	=7D
> > +
> > +	val =3D ((MRAM_ECC_ENABLE_MASK =7C MRAM_CFG_VALID_MASK =7C
> > +		MRAM_INIT_ENABLE_MASK) << offset);
>=20
> please make use of FIELD_PREP
>=20
Okay, I will do.
> > +	regmap_clear_bits(mraminit->syscon, mraminit->reg, val);
> > +
> > +	if (enable) =7B
> > +		val =3D (MRAM_ECC_ENABLE_MASK =7C
> MRAM_INIT_ENABLE_MASK) << offset;
>=20
> same here
>=20
okay
> > +		regmap_set_bits(mraminit->syscon, mraminit->reg, val);
> > +	=7D
> > +
> > +	/* after enable or disable valid flag need to be set*/
>                                                            =5E=5E=5E
>                                                            missing space
> > +	val =3D (MRAM_CFG_VALID_MASK << offset);
>=20
> here, too
>=20
okay
> > +	regmap_set_bits(mraminit->syscon, mraminit->reg, val);
> > +
> > +	if (enable) =7B
> > +		do =7B
> > +			regmap_read(mraminit->syscon, mraminit->reg,
> &val);
> > +
> > +			if (val & (MRAM_INIT_DONE_MASK << offset))
> > +				return 0;
> > +
> > +			udelay(1);
> > +		=7D while (delay_count--);
>=20
> please make use of regmap_read_poll_timeout().
>=20
Okay, I will add this in next patch series.
> > +
> > +		return -ENODEV;
> > +	=7D
> > +
> > +	return 0;
> > +=7D
> > +
> >  static int m_can_close(struct net_device *dev)  =7B
> >  	struct m_can_classdev *cdev =3D netdev_priv(dev);
> > +	struct device_node *np;
> > +	int err =3D 0;
> >
> >  	netif_stop_queue(dev);
> >
> > =40=40 -1557,6 +1610,15 =40=40 static int m_can_close(struct net_device=
 *dev)
> >  	if (cdev->is_peripheral)
> >  		can_rx_offload_disable(&cdev->offload);
> >
> > +	np =3D cdev->dev->of_node;
> > +
> > +	if (np && of_property_read_bool(np, =22mram-ecc-cfg=22)) =7B
> > +		err =3D m_can_config_mram_ecc_check(cdev, ECC_DISABLE,
> np);
> > +		if (err < 0)
> > +			netdev_err(dev,
> > +				   =22Message RAM ECC disable config
> failed=5Cn=22);
> > +	=7D
> > +
> >  	close_candev(dev);
> >
> >  	phy_power_off(cdev->transceiver);
> > =40=40 -1754,6 +1816,7 =40=40 static int m_can_open(struct net_device *=
dev)  =7B
> >  	struct m_can_classdev *cdev =3D netdev_priv(dev);
> >  	int err;
> > +	struct device_node *np;
> >
> >  	err =3D phy_power_on(cdev->transceiver);
> >  	if (err)
> > =40=40 -1798,6 +1861,16 =40=40 static int m_can_open(struct net_device =
*dev)
> >  		goto exit_irq_fail;
> >  	=7D
> >
> > +	np =3D cdev->dev->of_node;
> > +
> > +	if (np && of_property_read_bool(np, =22mram-ecc-cfg=22)) =7B
> > +		err =3D m_can_config_mram_ecc_check(cdev, ECC_ENABLE,
> np);
> > +		if (err < 0) =7B
> > +			netdev_err(dev,
> > +				   =22Message RAM ECC enable config
> failed=5Cn=22);
> > +		=7D
> > +	=7D
> > +
> >  	/* start the m_can controller */
> >  	m_can_start(dev);
> >
> > diff --git a/drivers/net/can/m_can/m_can.h
> > b/drivers/net/can/m_can/m_can.h index 4c0267f9f297..3cbfdc64a7db
> > 100644
> > --- a/drivers/net/can/m_can/m_can.h
> > +++ b/drivers/net/can/m_can/m_can.h
> > =40=40 -28,6 +28,8 =40=40
> >  =23include <linux/can/dev.h>
> >  =23include <linux/pinctrl/consumer.h>
> >  =23include <linux/phy/phy.h>
> > +=23include <linux/mfd/syscon.h>
> > +=23include <linux/regmap.h>
>=20
> please make a separate patch that sorts these includes alphabetically, th=
en
> add the new includes sorted.
>=20
Okay, I will post the separate patch for this.
> >
> >  /* m_can lec values */
> >  enum m_can_lec_type =7B
> > =40=40 -52,12 +54,33 =40=40 enum m_can_mram_cfg =7B
> >  	MRAM_CFG_NUM,
> >  =7D;
> >
> > +enum m_can_ecc_cfg =7B
> > +	ECC_DISABLE =3D 0,
> > +	ECC_ENABLE,
> > +=7D;
> > +
>=20
> unused
>=20
Okay, I will remove or make better use of this.
> >  /* address offset and element number for each FIFO/Buffer in the
> > Message RAM */  struct mram_cfg =7B
> >  	u16 off;
> >  	u8  num;
> >  =7D;
> >
> > +/* MRAM_INIT_BITS */
> > +=23define MRAM_CFG_VALID_SHIFT   5
> > +=23define MRAM_CFG_VALID_MASK    BIT(MRAM_CFG_VALID_SHIFT)
> > +=23define MRAM_ECC_ENABLE_SHIFT  3
> > +=23define MRAM_ECC_ENABLE_MASK   BIT(MRAM_ECC_ENABLE_SHIFT)
> > +=23define MRAM_INIT_ENABLE_SHIFT 1
> > +=23define MRAM_INIT_ENABLE_MASK  BIT(MRAM_INIT_ENABLE_SHIFT)
> > +=23define MRAM_INIT_DONE_SHIFT   0
> > +=23define MRAM_INIT_DONE_MASK    BIT(MRAM_INIT_DONE_SHIFT)
> > +=23define MRAM_INIT_TIMEOUT      50
>=20
> Please move these bits to the m_can.c file.
>=20
Okay, I will move.
> Add a common prefix M_CAN_ to them.
>=20
Okay, I will address this in next patch series.
> Remove the SHIFT values, directly define the MASK using BIT() (for single=
 set
> bits) or GEN_MASK() (for multiple set bits).
>=20
> > +
> > +struct m_can_mraminit =7B
>=20
> Is this RAM init or ECC related?
>=20
This is for ECC only, I will give better naming for this for better underst=
anding.
> > +	struct regmap *syscon;  /* for mraminit ctrl. reg. access */
> > +	unsigned int reg;       /* register index within syscon */
> > +=7D;
> > +
> >  struct m_can_classdev;
> >  struct m_can_ops =7B
> >  	/* Device specific call backs */
> > =40=40 -92,6 +115,7 =40=40 struct m_can_classdev =7B
> >  	int pm_clock_support;
> >  	int is_peripheral;
> >
> > +	struct m_can_mraminit mraminit_sys;     /* mraminit via syscon
> regmap */
> >  	struct mram_cfg mcfg=5BMRAM_CFG_NUM=5D;
> >  =7D;
> >
> > --
> > 2.17.1
> >
> >
>=20
> Marc
>=20
Thank you for your feedback and reviewing the patches.
> --
> Pengutronix e.K.                 =7C Marc Kleine-Budde           =7C
> Embedded Linux                   =7C
> https://protect2.fireeye.com/v1/url?k=3D7f1e79b1-1e956c87-7f1ff2fe-
> 74fe485cbff1-92aa04a06e5e6383&q=3D1&e=3D543e935e-4838-4692-b1da-
> d42741c9ad3f&u=3Dhttps%3A%2F%2Fwww.pengutronix.de%2F  =7C
> Vertretung West/Dortmund         =7C Phone: +49-231-2826-924     =7C
> Amtsgericht Hildesheim, HRA 2686 =7C Fax:   +49-5121-206917-5555 =7C

