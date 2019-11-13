Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 513E4FAE79
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 11:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfKMK2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 05:28:05 -0500
Received: from canardo.mork.no ([148.122.252.1]:54275 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727374AbfKMK2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 05:28:05 -0500
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id xADARvwe000540
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 13 Nov 2019 11:27:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1573640878; bh=P6+yU5QsfqoGNEzxVibdDpCcnn3di0eFZU5up5TTlnQ=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=cUakuC4WIQsu9IRTJTDsQBjJbIs2f5iHuIReRrjRlCIioJKr1gY7DG/kyI9yBSX4b
         UgqCXaHrtKTVvfQTHOaNkcFa1hg9xoQcGtMnxX74E/IB9vv6ppLcym2X+/iLlSY7XI
         jEZVe5rKb4ZMM7QBTM6aZWhlFCLzNM5jrLQR+IOE=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1iUpsT-0006a0-QL; Wed, 13 Nov 2019 11:27:57 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Aleksander Morgado <aleksander@aleksander.es>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: add support for Foxconn T77W968 LTE modules
Organization: m
References: <20191113101110.496306-1-aleksander@aleksander.es>
Date:   Wed, 13 Nov 2019 11:27:57 +0100
In-Reply-To: <20191113101110.496306-1-aleksander@aleksander.es> (Aleksander
        Morgado's message of "Wed, 13 Nov 2019 11:11:10 +0100")
Message-ID: <87woc4qdea.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.101.4 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aleksander Morgado <aleksander@aleksander.es> writes:

> These are the Foxconn-branded variants of the Dell DW5821e modules,
> same USB layout as those.
>
> The QMI interface is exposed in USB configuration #1:
>
> P:  Vendor=3D0489 ProdID=3De0b4 Rev=3D03.18
> S:  Manufacturer=3DFII
> S:  Product=3DT77W968 LTE
> S:  SerialNumber=3D0123456789ABCDEF
> C:  #Ifs=3D 6 Cfg#=3D 1 Atr=3Da0 MxPwr=3D500mA
> I:  If#=3D0x0 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Drive=
r=3Dqmi_wwan
> I:  If#=3D0x1 Alt=3D 0 #EPs=3D 1 Cls=3D03(HID  ) Sub=3D00 Prot=3D00 Drive=
r=3Dusbhid
> I:  If#=3D0x2 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Drive=
r=3Doption
> I:  If#=3D0x3 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Drive=
r=3Doption
> I:  If#=3D0x4 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Drive=
r=3Doption
> I:  If#=3D0x5 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Drive=
r=3Doption
>
> Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
> ---
>  drivers/net/usb/qmi_wwan.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 56d334b9ad45..4196c0e32740 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1371,6 +1371,8 @@ static const struct usb_device_id products[] =3D {
>  	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0191, 4)},	/* Quectel EG91 */
>  	{QMI_FIXED_INTF(0x2c7c, 0x0296, 4)},	/* Quectel BG96 */
>  	{QMI_QUIRK_SET_DTR(0x2cb7, 0x0104, 4)},	/* Fibocom NL678 series */
> +	{QMI_FIXED_INTF(0x0489, 0xe0b4, 0)},	/* Foxconn T77W968 LTE */
> +	{QMI_FIXED_INTF(0x0489, 0xe0b5, 0)},	/* Foxconn T77W968 LTE with eSIM s=
upport*/
>=20=20
>  	/* 4. Gobi 1000 devices */
>  	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>

Just one question, which I should have asked about the DW5821e too: Is
it possible to configure the firmware of these modems to USB2 only, and
do they work with the qmi_wwan driver then?

I suspect that these modems really need the SET_DTR quirk...  Or rather
that I should get around to making that default, as it seems most new
stuff needs it and most old stuff doesn't care.


Bj=C3=B8rn
