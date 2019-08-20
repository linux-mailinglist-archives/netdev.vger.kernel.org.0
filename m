Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F266796C15
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730957AbfHTWVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:21:19 -0400
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:2906 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727358AbfHTWVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:21:19 -0400
Received: from pps.filterd (m0170389.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KMFDso015677;
        Tue, 20 Aug 2019 18:21:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dellteam.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=smtpout1; bh=B+wXgXgTvN363It3lsd6rFsNGvZA0bT1QIBC3//VrxE=;
 b=FAg8ZxlCtzuDLEDiRTUgY2+YnIvn+T7FkoRG+AMawpBnPjIcU8mx3dfx8qGQgfWIoscL
 26jpiBsCo8ltV/9D0qWsJ9d/gprui8nHqcMU0z6YTVzr+PV6eu8RazC5T+w4XJVWHJ7C
 mJb1jd2hOi79e6qVyX5rkjOIkQHw9dOYq7v4L7sp1eif7GQz5oicznj1wAdtI3QNf7Dh
 tjNuyS/LFKoq0hRjJWyLZUrtTlQTSy9AG6KIsDsgpuszoVg//j3A9KEDtB0JNw70z2pf
 HCi4EAkEddVgv9g7QI9UFcUVqt9RM83wmCxj4rHDLR9A0oMyKxgRpFQA4MJicY5veGdu rQ== 
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0a-00154904.pphosted.com with ESMTP id 2ug0d16b0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 18:21:06 -0400
Received: from pps.filterd (m0144104.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KMI5S2026865;
        Tue, 20 Aug 2019 18:21:05 -0400
Received: from ausc60ps301.us.dell.com (ausc60ps301.us.dell.com [143.166.148.206])
        by mx0b-00154901.pphosted.com with ESMTP id 2ugpb7jjju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 18:21:05 -0400
X-LoopCount0: from 10.166.132.132
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.60,349,1549951200"; 
   d="scan'208";a="1346990097"
From:   <Charles.Hyde@dellteam.com>
To:     <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <Mario.Limonciello@dell.com>,
        <oliver@neukum.org>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>
Subject: [RFC 2/4] Allow cdc_ncm to set MAC address in hardware
Thread-Topic: [RFC 2/4] Allow cdc_ncm to set MAC address in hardware
Thread-Index: AQHVV6VMi2mBgTVez06jTeC7fFTbBw==
Date:   Tue, 20 Aug 2019 22:21:03 +0000
Message-ID: <1566339663476.54366@Dellteam.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.177.90.69]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200205
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200204
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for pushing a MAC address out to USB based=0A=
ethernet controllers driven by cdc_ncm.  With this change, ifconfig can=0A=
now set the device's MAC address.  For example, the Dell Universal Dock=0A=
D6000 is driven by cdc_ncm.  The D6000 can now have its MAC address set=0A=
by ifconfig, as it can be done in Windows.  This was tested with a D6000=0A=
using ifconfig.=0A=
=0A=
Signed-off-by: Charles Hyde <charles.hyde@dellteam.com>=0A=
Cc: Mario Limonciello <mario.limonciello@dell.com>=0A=
Cc: Oliver Neukum <oliver@neukum.org>=0A=
Cc: netdev@vger.kernel.org=0A=
Cc: linux-usb@vger.kernel.org=0A=
---=0A=
 drivers/net/usb/cdc_ncm.c  | 20 +++++++++++++++++++-=0A=
 drivers/net/usb/usbnet.c   | 37 ++++++++++++++++++++++++++++---------=0A=
 include/linux/usb/usbnet.h |  1 +=0A=
 3 files changed, 48 insertions(+), 10 deletions(-)=0A=
=0A=
diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c=0A=
index 50c05d0f44cb..f77c8672f972 100644=0A=
--- a/drivers/net/usb/cdc_ncm.c=0A=
+++ b/drivers/net/usb/cdc_ncm.c=0A=
@@ -750,6 +750,24 @@ int cdc_ncm_change_mtu(struct net_device *net, int new=
_mtu)=0A=
 }=0A=
 EXPORT_SYMBOL_GPL(cdc_ncm_change_mtu);=0A=
 =0A=
+/* Provide method to push MAC address to the USB device's ethernet control=
ler.=0A=
+ */=0A=
+int cdc_ncm_set_mac_addr(struct net_device *net, void *p)=0A=
+{=0A=
+	struct usbnet *dev =3D netdev_priv(net);=0A=
+	struct sockaddr *addr =3D p;=0A=
+=0A=
+	memcpy(dev->net->dev_addr, addr->sa_data, ETH_ALEN);=0A=
+	/*=0A=
+	 * Try to push the MAC address out to the device.  Ignore any errors,=0A=
+	 * to be compatible with prior versions of this source.=0A=
+	 */=0A=
+	usbnet_set_ethernet_addr(dev);=0A=
+=0A=
+	return eth_mac_addr(net, p);=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(cdc_ncm_set_mac_addr);=0A=
+=0A=
 static const struct net_device_ops cdc_ncm_netdev_ops =3D {=0A=
 	.ndo_open	     =3D usbnet_open,=0A=
 	.ndo_stop	     =3D usbnet_stop,=0A=
@@ -757,7 +775,7 @@ static const struct net_device_ops cdc_ncm_netdev_ops =
=3D {=0A=
 	.ndo_tx_timeout	     =3D usbnet_tx_timeout,=0A=
 	.ndo_get_stats64     =3D usbnet_get_stats64,=0A=
 	.ndo_change_mtu	     =3D cdc_ncm_change_mtu,=0A=
-	.ndo_set_mac_address =3D eth_mac_addr,=0A=
+	.ndo_set_mac_address =3D cdc_ncm_set_mac_addr,=0A=
 	.ndo_validate_addr   =3D eth_validate_addr,=0A=
 };=0A=
 =0A=
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c=0A=
index 72514c46b478..72bdac34b0ee 100644=0A=
--- a/drivers/net/usb/usbnet.c=0A=
+++ b/drivers/net/usb/usbnet.c=0A=
@@ -149,20 +149,39 @@ int usbnet_get_ethernet_addr(struct usbnet *dev, int =
iMACAddress)=0A=
 	int 		tmp =3D -1, ret;=0A=
 	unsigned char	buf [13];=0A=
 =0A=
-	ret =3D usb_string(dev->udev, iMACAddress, buf, sizeof buf);=0A=
-	if (ret =3D=3D 12)=0A=
-		tmp =3D hex2bin(dev->net->dev_addr, buf, 6);=0A=
-	if (tmp < 0) {=0A=
-		dev_dbg(&dev->udev->dev,=0A=
-			"bad MAC string %d fetch, %d\n", iMACAddress, tmp);=0A=
-		if (ret >=3D 0)=0A=
-			ret =3D -EINVAL;=0A=
-		return ret;=0A=
+	ret =3D usb_get_address(dev->udev, buf);=0A=
+	if (ret =3D=3D 6)=0A=
+		memcpy(dev->net->dev_addr, buf, 6);=0A=
+	else if (ret < 0) {=0A=
+		ret =3D usb_string(dev->udev, iMACAddress, buf, sizeof buf);=0A=
+		if (ret =3D=3D 12)=0A=
+			tmp =3D hex2bin(dev->net->dev_addr, buf, 6);=0A=
+		if (tmp < 0) {=0A=
+			dev_dbg(&dev->udev->dev,=0A=
+				"bad MAC string %d fetch, %d\n", iMACAddress,=0A=
+				tmp);=0A=
+			if (ret >=3D 0)=0A=
+				ret =3D -EINVAL;=0A=
+			return ret;=0A=
+		}=0A=
 	}=0A=
 	return 0;=0A=
 }=0A=
 EXPORT_SYMBOL_GPL(usbnet_get_ethernet_addr);=0A=
 =0A=
+int usbnet_set_ethernet_addr(struct usbnet *dev)=0A=
+{=0A=
+	int ret;=0A=
+=0A=
+	ret =3D usb_set_address(dev->udev, dev->net->dev_addr);=0A=
+	if (ret < 0) {=0A=
+		dev_dbg(&dev->udev->dev,=0A=
+			"bad MAC address put, %d\n", ret);=0A=
+	}=0A=
+	return ret;=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(usbnet_set_ethernet_addr);=0A=
+=0A=
 static void intr_complete (struct urb *urb)=0A=
 {=0A=
 	struct usbnet	*dev =3D urb->context;=0A=
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h=0A=
index d8860f2d0976..f2b2c5ab5493 100644=0A=
--- a/include/linux/usb/usbnet.h=0A=
+++ b/include/linux/usb/usbnet.h=0A=
@@ -258,6 +258,7 @@ extern int usbnet_change_mtu(struct net_device *net, in=
t new_mtu);=0A=
 =0A=
 extern int usbnet_get_endpoints(struct usbnet *, struct usb_interface *);=
=0A=
 extern int usbnet_get_ethernet_addr(struct usbnet *, int);=0A=
+extern int usbnet_set_ethernet_addr(struct usbnet *);=0A=
 extern void usbnet_defer_kevent(struct usbnet *, int);=0A=
 extern void usbnet_skb_return(struct usbnet *, struct sk_buff *);=0A=
 extern void usbnet_unlink_rx_urbs(struct usbnet *);=0A=
-- =0A=
2.20.1=0A=
