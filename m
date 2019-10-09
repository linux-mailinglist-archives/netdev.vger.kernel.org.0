Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4854D0828
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 09:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbfJIHSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 03:18:05 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38851 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfJIHSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 03:18:04 -0400
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iI6EP-0001UZ-PG; Wed, 09 Oct 2019 09:17:57 +0200
Received: from [IPv6:2a03:f580:87bc:d400:3041:7636:c70e:730f] (unknown [IPv6:2a03:f580:87bc:d400:3041:7636:c70e:730f])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 08A70463372;
        Wed,  9 Oct 2019 07:17:53 +0000 (UTC)
Subject: Re: [PATCH 2/6] net: can: xilinx_can: Fix flags field initialization
 for axi can and canps
To:     Appana Durga Kedareswara Rao <appanad@xilinx.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     "wg@grandegger.com" <wg@grandegger.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
References: <1552908766-26753-1-git-send-email-appana.durga.rao@xilinx.com>
 <1552908766-26753-3-git-send-email-appana.durga.rao@xilinx.com>
 <d1bedb13-f66f-b0fd-bd6d-9f95b64fc405@bitwise.fi>
 <MN2PR02MB64004059908C95EB5E16746FDC950@MN2PR02MB6400.namprd02.prod.outlook.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <644fb76f-8169-4911-2293-92ae2dfe4e1c@pengutronix.de>
Date:   Wed, 9 Oct 2019 09:17:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <MN2PR02MB64004059908C95EB5E16746FDC950@MN2PR02MB6400.namprd02.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="o6gGPgD5ZTyYWoRyGFKHldQgJZ9IWZIQR"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--o6gGPgD5ZTyYWoRyGFKHldQgJZ9IWZIQR
Content-Type: multipart/mixed; boundary="r6Se4r1d84yFfg5K20EFRv9UIXwPXokF8";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Appana Durga Kedareswara Rao <appanad@xilinx.com>,
 Anssi Hannula <anssi.hannula@bitwise.fi>
Cc: "wg@grandegger.com" <wg@grandegger.com>,
 "davem@davemloft.net" <davem@davemloft.net>,
 Michal Simek <michals@xilinx.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Message-ID: <644fb76f-8169-4911-2293-92ae2dfe4e1c@pengutronix.de>
Subject: Re: [PATCH 2/6] net: can: xilinx_can: Fix flags field initialization
 for axi can and canps
References: <1552908766-26753-1-git-send-email-appana.durga.rao@xilinx.com>
 <1552908766-26753-3-git-send-email-appana.durga.rao@xilinx.com>
 <d1bedb13-f66f-b0fd-bd6d-9f95b64fc405@bitwise.fi>
 <MN2PR02MB64004059908C95EB5E16746FDC950@MN2PR02MB6400.namprd02.prod.outlook.com>
In-Reply-To: <MN2PR02MB64004059908C95EB5E16746FDC950@MN2PR02MB6400.namprd02.prod.outlook.com>

--r6Se4r1d84yFfg5K20EFRv9UIXwPXokF8
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 10/9/19 6:01 AM, Appana Durga Kedareswara Rao wrote:
> Hi,
>=20
> <Snip>
>> On 18.3.2019 13.32, Appana Durga Kedareswara rao wrote:
>>> AXI CAN IP and CANPS IP supports tx fifo empty feature, this patch
>>> updates the flags field for the same.
>>>
>>> Signed-off-by: Appana Durga Kedareswara rao
>>> <appana.durga.rao@xilinx.com>
>>> ---
>>>  drivers/net/can/xilinx_can.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/net/can/xilinx_can.c
>>> b/drivers/net/can/xilinx_can.c index 2de51ac..22569ef 100644
>>> --- a/drivers/net/can/xilinx_can.c
>>> +++ b/drivers/net/can/xilinx_can.c
>>> @@ -1428,6 +1428,7 @@ static const struct dev_pm_ops xcan_dev_pm_ops
>> =3D
>>> {  };
>>>
>>>  static const struct xcan_devtype_data xcan_zynq_data =3D {
>>> +	.flags =3D XCAN_FLAG_TXFEMP,
>>>  	.bittiming_const =3D &xcan_bittiming_const,
>>>  	.btr_ts2_shift =3D XCAN_BTR_TS2_SHIFT,
>>>  	.btr_sjw_shift =3D XCAN_BTR_SJW_SHIFT,
>>
>> Thanks for catching this, this line seemed to have been incorrectly re=
moved by
>> my 9e5f1b273e ("can: xilinx_can: add support for Xilinx CAN FD core").=

>>
>> But:
>>
>>> @@ -1435,6 +1436,7 @@ static const struct xcan_devtype_data
>>> xcan_zynq_data =3D {  };
>>>
>>>  static const struct xcan_devtype_data xcan_axi_data =3D {
>>> +	.flags =3D XCAN_FLAG_TXFEMP,
>>>  	.bittiming_const =3D &xcan_bittiming_const,
>>>  	.btr_ts2_shift =3D XCAN_BTR_TS2_SHIFT,
>>>  	.btr_sjw_shift =3D XCAN_BTR_SJW_SHIFT,
>>
>>
>> Are you sure this is right?
>> In the documentation [1] there does not seem to be any TXFEMP interrup=
t, it
>> would be interrupt bit 14 but AXI CAN 5.0 seems to only go up to 11.
>>
>> Or maybe it is undocumented or there is a newer version somewhere?
>=20
> Sorry for the delay in the reply.=20
> Agree TXFEMP interrupt feature is not supported by the Soft IP CAN.
> Since this patch already got applied will send a separate patch to fix =
this.

Please base your patch on net/master and add the appropriate fixes tag:

Fixes: 3281b380ec9f ("can: xilinx_can: Fix flags field initialization for=
 axi can and canps")

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--r6Se4r1d84yFfg5K20EFRv9UIXwPXokF8--

--o6gGPgD5ZTyYWoRyGFKHldQgJZ9IWZIQR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEmvEkXzgOfc881GuFWsYho5HknSAFAl2diZ0ACgkQWsYho5Hk
nSDwGwf+Oxe0LBV8cKXYL5gwSl2c4iMUIorM6JCFmH1Uavtlp11+g91f3qyPCpyq
MVHHsIeBIbta2dN1oBY7tGBmBH5s4MNdxhFlc8EajUeYf6sZBD+BK243TSJVC7hF
pjVtdIEhiPkZcveLzF2TIaBMVPqLiJyKmsJvgVlXLUY9TYOi7BGqu0NoTvEOjNJ9
HThgvSUH/zfJrWIT5m6DMxg+39QacVCjfTtlXIhefPsr/F6IPZ855qItY9mNGsPh
2qC24k6Pq70Q4h7uGtKO+/dU1Uy0Ru/t7BOlhzcEG/cwVuLE/x3tW2ccnNKdeBoq
MLDHd+vQ3kqakVr4m010yE8l/cBiPA==
=mgwU
-----END PGP SIGNATURE-----

--o6gGPgD5ZTyYWoRyGFKHldQgJZ9IWZIQR--
