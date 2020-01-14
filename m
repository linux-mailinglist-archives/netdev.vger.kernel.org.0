Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3211F13B3AF
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 21:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgANUda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 15:33:30 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:38708 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728869AbgANUda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 15:33:30 -0500
Received: from pps.filterd (m0170392.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00EKUG64025181;
        Tue, 14 Jan 2020 15:33:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=YcVTsFVCk33wsAAbjgqR5UImqzVzyOEDm+5euXlYj4A=;
 b=fDtwT+lGLI+UBFyd7y22qRmTdwDQqJasOPo4ZGD6OrzRFqRYFOM88pU92Sw1KGJz+HkE
 ycEscT/piAr8isyVBn8TcmCj46wAxwESNxJy8rLEX6yg1l43Pry9yXw/WaZIuT2tByid
 eSZ/dGgslgmtNL6qpCoH5l2RRpsAl4+qvo9QihUxNO3JRsZ4Gjegyr7mmlhsJILFP116
 znzQhCs5Jjs3PkPDCajChsSs7r6pDTYWF4yKvasP7wEIlnNy8F+iqUQT73dJbCKkD1CQ
 4PPyZRt3OwihASS/MFwc3zAAXdz/L4C0WhuGjyyvEWxMTRLfdpyftM7ZIJnW49I3qJip dA== 
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0a-00154904.pphosted.com with ESMTP id 2xfadfmnrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jan 2020 15:33:28 -0500
Received: from pps.filterd (m0144103.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00EKWZtg178088;
        Tue, 14 Jan 2020 15:33:27 -0500
Received: from ausxipps301.us.dell.com (ausxipps301.us.dell.com [143.166.148.223])
        by mx0b-00154901.pphosted.com with ESMTP id 2xgv7unf13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 15:33:27 -0500
X-LoopCount0: from 10.166.132.128
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.60,349,1549951200"; 
   d="scan'208";a="445730065"
From:   <Mario.Limonciello@dell.com>
To:     <kai.heng.feng@canonical.com>, <davem@davemloft.net>,
        <hayeswang@realtek.com>
CC:     <jakub.kicinski@netronome.com>, <pmalani@chromium.org>,
        <grundler@chromium.org>, <David.Chen7@Dell.com>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] r8152: Add MAC passthrough support to new device
Thread-Topic: [PATCH] r8152: Add MAC passthrough support to new device
Thread-Index: AQHVypTyXWy+UgfzBkaZbhNc/JuHNafqnTJA
Date:   Tue, 14 Jan 2020 20:33:19 +0000
Message-ID: <d8af34dbf4994b7b8b0bf48e81084dd0@AUSX13MPC101.AMER.DELL.COM>
References: <20200114044127.20085-1-kai.heng.feng@canonical.com>
In-Reply-To: <20200114044127.20085-1-kai.heng.feng@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Mario_Limonciello@Dell.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2020-01-14T20:33:18.1061397Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual;
 aiplabel=External Public
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.143.18.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_06:2020-01-14,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 phishscore=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 mlxlogscore=433 spamscore=0 bulkscore=0
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001140157
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=550
 spamscore=0 priorityscore=1501 bulkscore=0 mlxscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001140156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Sent: Monday, January 13, 2020 10:41 PM
> To: davem@davemloft.net; hayeswang@realtek.com
> Cc: Kai-Heng Feng; Jakub Kicinski; Prashant Malani; Grant Grundler; Limon=
ciello,
> Mario; Chen7, David; open list:USB NETWORKING DRIVERS; open list:NETWORKI=
NG
> DRIVERS; open list
> Subject: [PATCH] r8152: Add MAC passthrough support to new device
>=20
>=20
> [EXTERNAL EMAIL]
>=20
> Device 0xa387 also supports MAC passthrough, therefore add it to the
> whitelst.

Have you confirmed whether this product ID is unique to the products that
support this feature or if it's also re-used in other products?

For Dell's devices there are very specific tests that make sure that this
feature only applies on the products it is supposed to and nothing else
(For example RTL8153-AD checks variant as well as effuse value)
(Example two: RTL8153-BND is a Dell only part).

>=20
> BugLink: https://bugs.launchpad.net/bugs/1827961/comments/30
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/usb/r8152.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index c5ebf35d2488..42dcf1442cc0 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -6657,7 +6657,8 @@ static int rtl8152_probe(struct usb_interface *intf=
,
>  	}
>=20
>  	if (le16_to_cpu(udev->descriptor.idVendor) =3D=3D VENDOR_ID_LENOVO &&
> -	    le16_to_cpu(udev->descriptor.idProduct) =3D=3D 0x3082)
> +	    (le16_to_cpu(udev->descriptor.idProduct) =3D=3D 0x3082 ||
> +	     le16_to_cpu(udev->descriptor.idProduct) =3D=3D 0xa387))
>  		set_bit(LENOVO_MACPASSTHRU, &tp->flags);
>=20
>  	if (le16_to_cpu(udev->descriptor.bcdDevice) =3D=3D 0x3011 && udev->seri=
al
> &&
> --
> 2.17.1

