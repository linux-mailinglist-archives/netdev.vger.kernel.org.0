Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3A296C0E
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730938AbfHTWSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:18:55 -0400
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:16864 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727358AbfHTWSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:18:55 -0400
Received: from pps.filterd (m0170394.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KMFHj8004945;
        Tue, 20 Aug 2019 18:18:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dellteam.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=smtpout1; bh=t1ntUWnyKU7vtk8aQ3sHa2w2l3X2idBxHhft0DoTAhE=;
 b=VutQFxB9oue4jcCDC4Y3nkkfwgyD2kzLQSGECgot99xO4xmj/vKf1tHu+Fxwyjc8Lzt0
 xiW+DvaV+w3lXLvyeCvuq4HFv2MWt7DuX18EcXXlweu63CXJlOZVAaYxJwY6kN2BjQ6Z
 KDpfIrBQIq5zTxbGfLK7OEvP2NtOcYZKBhfDhIbSccKtu2Dzv4xrIQEdJbxfJndtQAv4
 7Q9L3eHaFVdrKNhV2taPO2+ZGZLw3w2uC0SdE0qrAlT5ouJ21tmzgOkVyRPquJ3+UiVf
 eavWsdfINFmNs8iTDHO7/VpTEK2fIviKt+5/7U9HL8Fofen1F8KhcEMZMsXPBFKO4kSM Mw== 
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0b-00154904.pphosted.com with ESMTP id 2ugh3g2h3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 18:18:53 -0400
Received: from pps.filterd (m0144102.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KMHQ2g022625;
        Tue, 20 Aug 2019 18:18:52 -0400
Received: from ausxippc110.us.dell.com (AUSXIPPC110.us.dell.com [143.166.85.200])
        by mx0b-00154901.pphosted.com with ESMTP id 2ugsex8221-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 18:18:52 -0400
X-LoopCount0: from 10.166.132.133
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.60,349,1549951200"; 
   d="scan'208";a="846157333"
From:   <Charles.Hyde@dellteam.com>
To:     <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <Mario.Limonciello@dell.com>,
        <oliver@neukum.org>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>
Subject: [RFC 1/4] Add usb_get_address and usb_set_address support
Thread-Topic: [RFC 1/4] Add usb_get_address and usb_set_address support
Thread-Index: AQHVV6TlN6JhPmp8+EufEIlfFi8+LA==
Date:   Tue, 20 Aug 2019 22:18:42 +0000
Message-ID: <1566339522507.45056@Dellteam.com>
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

The core USB driver message.c is missing get/set address functionality=0A=
that stops ifconfig from being able to push MAC addresses out to USB=0A=
based ethernet devices.  Without this functionality, some USB devices=0A=
stop responding to ethernet packets when using ifconfig to change MAC=0A=
addresses.  This has been tested with a Dell Universal Dock D6000.=0A=
=0A=
Signed-off-by: Charles Hyde <charles.hyde@dellteam.com>=0A=
Cc: Mario Limonciello <mario.limonciello@dell.com>=0A=
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=0A=
Cc: linux-usb@vger.kernel.org=0A=
---=0A=
 drivers/usb/core/message.c | 59 ++++++++++++++++++++++++++++++++++++++=0A=
 include/linux/usb.h        |  3 ++=0A=
 2 files changed, 62 insertions(+)=0A=
=0A=
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c=0A=
index 5adf489428aa..eea775234b09 100644=0A=
--- a/drivers/usb/core/message.c=0A=
+++ b/drivers/usb/core/message.c=0A=
@@ -1085,6 +1085,65 @@ int usb_clear_halt(struct usb_device *dev, int pipe)=
=0A=
 }=0A=
 EXPORT_SYMBOL_GPL(usb_clear_halt);=0A=
 =0A=
+/**=0A=
+ * usb_get_address - =0A=
+ * @dev: device whose endpoint is halted=0A=
+ * @mac: buffer for containing =0A=
+ * Context: !in_interrupt ()=0A=
+ *=0A=
+ * This will attempt to get the six byte MAC address from a USB device's=
=0A=
+ * ethernet controller using GET_NET_ADDRESS command.=0A=
+ *=0A=
+ * This call is synchronous, and may not be used in an interrupt context.=
=0A=
+ *=0A=
+ * Return: Zero on success, or else the status code returned by the=0A=
+ * underlying usb_control_msg() call.=0A=
+ */=0A=
+int usb_get_address(struct usb_device *dev, unsigned char * mac)=0A=
+{=0A=
+	int ret =3D -ENOMEM;=0A=
+	unsigned char *tbuf =3D kmalloc(256, GFP_NOIO);=0A=
+=0A=
+	if (!tbuf)=0A=
+		return -ENOMEM;=0A=
+=0A=
+	ret =3D usb_control_msg(dev, usb_sndctrlpipe(dev, 0),=0A=
+			USB_CDC_GET_NET_ADDRESS,=0A=
+			USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,=0A=
+			0, USB_REQ_SET_ADDRESS, tbuf, 256,=0A=
+			USB_CTRL_GET_TIMEOUT);=0A=
+	if (ret =3D=3D 6)=0A=
+		memcpy(mac, tbuf, 6);=0A=
+=0A=
+	kfree(tbuf);=0A=
+	return ret;=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(usb_get_address);=0A=
+=0A=
+/**=0A=
+ * usb_set_address - =0A=
+ * @dev: device whose endpoint is halted=0A=
+ * @mac: desired MAC address in network address order=0A=
+ * Context: !in_interrupt ()=0A=
+ *=0A=
+ * This will attempt to set a six byte MAC address to the USB device's eth=
ernet=0A=
+ * controller using SET_NET_ADDRESS command.=0A=
+ *=0A=
+ * This call is synchronous, and may not be used in an interrupt context.=
=0A=
+ *=0A=
+ * Return: Zero on success, or else the status code returned by the=0A=
+ * underlying usb_control_msg() call.=0A=
+ */=0A=
+int usb_set_address(struct usb_device *dev, unsigned char *mac)=0A=
+{=0A=
+	return usb_control_msg(dev, usb_sndctrlpipe(dev, 0),=0A=
+			USB_CDC_SET_NET_ADDRESS,=0A=
+			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,=0A=
+			0, USB_REQ_SET_ADDRESS, mac, 6,=0A=
+			USB_CTRL_SET_TIMEOUT);=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(usb_set_address);=0A=
+=0A=
 static int create_intf_ep_devs(struct usb_interface *intf)=0A=
 {=0A=
 	struct usb_device *udev =3D interface_to_usbdev(intf);=0A=
diff --git a/include/linux/usb.h b/include/linux/usb.h=0A=
index e87826e23d59..862c979d9821 100644=0A=
--- a/include/linux/usb.h=0A=
+++ b/include/linux/usb.h=0A=
@@ -1806,6 +1806,9 @@ static inline int usb_get_ptm_status(struct usb_devic=
e *dev, void *data)=0A=
 extern int usb_string(struct usb_device *dev, int index,=0A=
 	char *buf, size_t size);=0A=
 =0A=
+extern int usb_get_address(struct usb_device *dev, unsigned char * mac);=
=0A=
+extern int usb_set_address(struct usb_device *dev, unsigned char * mac);=
=0A=
+=0A=
 /* wrappers that also update important state inside usbcore */=0A=
 extern int usb_clear_halt(struct usb_device *dev, int pipe);=0A=
 extern int usb_reset_configuration(struct usb_device *dev);=0A=
-- =0A=
2.20.1=0A=
