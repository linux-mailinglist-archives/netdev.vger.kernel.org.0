Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 146B596C19
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730957AbfHTWWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:22:22 -0400
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:22710 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727358AbfHTWWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:22:22 -0400
Received: from pps.filterd (m0170390.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KMLKUh031014;
        Tue, 20 Aug 2019 18:22:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dellteam.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=smtpout1; bh=qmAnrRGHMMYWyrXBxMC7oZF7obTugelH4zmgxwm12Tw=;
 b=fBFU8ACzu3N/+3GeYJIqiJqM1S2yt2qe5gv9P2SAioChL879kGvrUGkhagX4f1PjrXOF
 vVq3Hz+FAiQ4bMZs6hj2EOF5N3ZFHeK94yxfg1Kinn7m1hGXLAI9nH8FjXLdVsSUtKDm
 RDxfcuyPwjkrd+gPGJTewp7g50RmPPUOtrc6TXPyO+L+Jh1XpOcQWnAqwo08NNbuzSjJ
 gjTXAAiQdUgAdRx3LxajrFvoY88grmC8rHrlrgcgcqy9zhZXaV8RkfEVTLE/zCkuV8zA
 LAze0ZvU96E5i2homy1pCHnvp4/RmPO126OIQUIr5DSd3VYwLeq0MoynbNZRFlNkVn1h KQ== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0a-00154904.pphosted.com with ESMTP id 2ugfdm2vv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 18:22:21 -0400
Received: from pps.filterd (m0142693.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KMI47i097576;
        Tue, 20 Aug 2019 18:22:21 -0400
Received: from ausc60pc101.us.dell.com (ausc60pc101.us.dell.com [143.166.85.206])
        by mx0a-00154901.pphosted.com with ESMTP id 2ugp98tt15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 18:22:21 -0400
X-LoopCount0: from 10.166.132.128
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.60,349,1549951200"; 
   d="scan'208";a="1455945352"
From:   <Charles.Hyde@dellteam.com>
To:     <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <Mario.Limonciello@dell.com>,
        <oliver@neukum.org>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>
Subject: [RFC 3/4] Move ACPI functionality out of r8152 driver
Thread-Topic: [RFC 3/4] Move ACPI functionality out of r8152 driver
Thread-Index: AQHVV6Wmg1QvoyTvokGSVMHHZMBMTw==
Date:   Tue, 20 Aug 2019 22:22:18 +0000
Message-ID: <1566339738195.2913@Dellteam.com>
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
 definitions=main-1908200205
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change moves ACPI functionality out of the Realtek r8152 driver to=0A=
its own source and header file, making it available to other drivers as=0A=
needed now and into the future.  At the time this ACPI snippet was=0A=
introduced in 2016, only the Realtek driver made use of it in support of=0A=
Dell's enterprise IT policy efforts.  There comes now a need for this=0A=
same support in a different driver, also in support of Dell's enterprise=0A=
IT policy efforts.=0A=
=0A=
Signed-off-by: Charles Hyde <charles.hyde@dellteam.com>=0A=
Cc: Mario Limonciello <mario.limonciello@dell.com>=0A=
Cc: Realtek linux nic maintainers <nic_swsd@realtek.com>=0A=
Cc: linux-usb@vger.kernel.org=0A=
Cc: linux-acpi@vger.kernel.org=0A=
---=0A=
 drivers/net/usb/r8152.c | 44 ++++-------------------------------------=0A=
 lib/Makefile            |  3 ++-=0A=
 2 files changed, 6 insertions(+), 41 deletions(-)=0A=
=0A=
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c=0A=
index 0cc03a9ff545..b1dba3400b74 100644=0A=
--- a/drivers/net/usb/r8152.c=0A=
+++ b/drivers/net/usb/r8152.c=0A=
@@ -23,6 +23,7 @@=0A=
 #include <linux/usb/cdc.h>=0A=
 #include <linux/suspend.h>=0A=
 #include <linux/acpi.h>=0A=
+#include <acpi/acpi_mac_passthru.h>=0A=
 =0A=
 /* Information for net-next */=0A=
 #define NETNEXT_VERSION		"09"=0A=
@@ -1175,12 +1176,7 @@ static int rtl8152_set_mac_address(struct net_device=
 *netdev, void *p)=0A=
  */=0A=
 static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr=
 *sa)=0A=
 {=0A=
-	acpi_status status;=0A=
-	struct acpi_buffer buffer =3D { ACPI_ALLOCATE_BUFFER, NULL };=0A=
-	union acpi_object *obj;=0A=
-	int ret =3D -EINVAL;=0A=
 	u32 ocp_data;=0A=
-	unsigned char buf[6];=0A=
 =0A=
 	/* test for -AD variant of RTL8153 */=0A=
 	ocp_data =3D ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);=0A=
@@ -1201,39 +1197,7 @@ static int vendor_mac_passthru_addr_read(struct r815=
2 *tp, struct sockaddr *sa)=0A=
 			return -ENODEV;=0A=
 		}=0A=
 	}=0A=
-=0A=
-	/* returns _AUXMAC_#AABBCCDDEEFF# */=0A=
-	status =3D acpi_evaluate_object(NULL, "\\_SB.AMAC", NULL, &buffer);=0A=
-	obj =3D (union acpi_object *)buffer.pointer;=0A=
-	if (!ACPI_SUCCESS(status))=0A=
-		return -ENODEV;=0A=
-	if (obj->type !=3D ACPI_TYPE_BUFFER || obj->string.length !=3D 0x17) {=0A=
-		netif_warn(tp, probe, tp->netdev,=0A=
-			   "Invalid buffer for pass-thru MAC addr: (%d, %d)\n",=0A=
-			   obj->type, obj->string.length);=0A=
-		goto amacout;=0A=
-	}=0A=
-	if (strncmp(obj->string.pointer, "_AUXMAC_#", 9) !=3D 0 ||=0A=
-	    strncmp(obj->string.pointer + 0x15, "#", 1) !=3D 0) {=0A=
-		netif_warn(tp, probe, tp->netdev,=0A=
-			   "Invalid header when reading pass-thru MAC addr\n");=0A=
-		goto amacout;=0A=
-	}=0A=
-	ret =3D hex2bin(buf, obj->string.pointer + 9, 6);=0A=
-	if (!(ret =3D=3D 0 && is_valid_ether_addr(buf))) {=0A=
-		netif_warn(tp, probe, tp->netdev,=0A=
-			   "Invalid MAC for pass-thru MAC addr: %d, %pM\n",=0A=
-			   ret, buf);=0A=
-		ret =3D -EINVAL;=0A=
-		goto amacout;=0A=
-	}=0A=
-	memcpy(sa->sa_data, buf, 6);=0A=
-	netif_info(tp, probe, tp->netdev,=0A=
-		   "Using pass-thru MAC addr %pM\n", sa->sa_data);=0A=
-=0A=
-amacout:=0A=
-	kfree(obj);=0A=
-	return ret;=0A=
+	return get_acpi_mac_passthru(&tp->intf->dev, sa);=0A=
 }=0A=
 =0A=
 static int determine_ethernet_addr(struct r8152 *tp, struct sockaddr *sa)=
=0A=
@@ -4309,10 +4273,10 @@ static int rtl8152_post_reset(struct usb_interface =
*intf)=0A=
 	if (!tp)=0A=
 		return 0;=0A=
 =0A=
-	/* reset the MAC adddress in case of policy change */=0A=
+	/* reset the MAC address in case of policy change */=0A=
 	if (determine_ethernet_addr(tp, &sa) >=3D 0) {=0A=
 		rtnl_lock();=0A=
-		dev_set_mac_address (tp->netdev, &sa, NULL);=0A=
+		dev_set_mac_address(tp->netdev, &sa, NULL);=0A=
 		rtnl_unlock();=0A=
 	}=0A=
 =0A=
diff --git a/lib/Makefile b/lib/Makefile=0A=
index 29c02a924973..a902bec0ac65 100644=0A=
--- a/lib/Makefile=0A=
+++ b/lib/Makefile=0A=
@@ -35,7 +35,8 @@ lib-y :=3D ctype.o string.o vsprintf.o cmdline.o \=0A=
 	 flex_proportions.o ratelimit.o show_mem.o \=0A=
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \=0A=
 	 earlycpio.o seq_buf.o siphash.o dec_and_lock.o \=0A=
-	 nmi_backtrace.o nodemask.o win_minmax.o memcat_p.o=0A=
+	 nmi_backtrace.o nodemask.o win_minmax.o memcat_p.o \=0A=
+	 acpi_mac_passthru.o=0A=
 =0A=
 lib-$(CONFIG_PRINTK) +=3D dump_stack.o=0A=
 lib-$(CONFIG_MMU) +=3D ioremap.o=0A=
-- =0A=
2.20.1=0A=
