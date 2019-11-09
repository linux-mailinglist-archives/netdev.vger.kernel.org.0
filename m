Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2829CF5E29
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 10:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfKIJDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 04:03:24 -0500
Received: from mout.web.de ([212.227.15.14]:55171 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbfKIJDY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 04:03:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1573290197;
        bh=qoIQImRdmD44LsZ6ub5WyhVN02SxMTzaAmh82B3FbiQ=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=KD54TrJuFUMbOY4o01necvCS3Jz4zylZAHVYsSzc2AJY9D0KKZh5bHhIt+BRLICn5
         JQxkmGGlZ31Bk49lGHGP+WCJr94YoqXQZjWR3LJntT/Fy9whju4N+wat0BmCPZjP3M
         wooicXx+UapWia9jjXzgAKgW0tzMR2npnNjQTOQU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.82.67]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M0f1C-1hd3yk3UMQ-00uqJg; Sat, 09
 Nov 2019 10:03:16 +0100
Subject: [PATCH 2/3] fsl/fman: Use common error handling code in mac_probe()
From:   Markus Elfring <Markus.Elfring@web.de>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <132e8369-c4da-249f-76b8-834e394dc6d5@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <38159f52-81a1-8ece-076f-da66180f4d5e@web.de>
Date:   Sat, 9 Nov 2019 10:03:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <132e8369-c4da-249f-76b8-834e394dc6d5@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:5QjZZUF/uEC5ha8UFxSqCFcACX950kwsosWqC4ZkjAORgg/6rnK
 5GCF7hefvFU13OJG6Sw+kzPpSnyQP+b/eYREkmNy0IWZdbh55bY0ZyudP0CNc1hx9odK7+R
 Anu5K+OnPha8xpVry43ehXE2kHZud6Wng3gdh9k7on1LGs0k5uHLD88J9YcIXFsj1zbP/fv
 mQgMFQ+MuIFTa9FDAj+HA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qlQGOrf0uCA=:15IgdzL/4mrHeQXKdvyPyg
 nEjHDrk0oVstuA2uvcjO+VywMh2hGr4Pd+XF1ZkHMah9em4sWAiLQcyBimPFD7kLmKmDoheIS
 OHqhD6whqLEFdYrX5XlFCZavEi6VLeMsxf+QFAhR85nRJEsY+If7NsKeoiXY4yYQF6ZTTBU06
 ov/zdZGEifyI5s7V3PBYAjR2M8O+sw5J3aItBNE1EGanbYwMQ/gh/I0UPvbV72ujOnen232FW
 noDY7VU6un8kB2KJKtghDXOVPU1NpOoNZ0GPmd0BqFk3ZU19A+A40NpLpZ5x4BO3WGsHf4ASQ
 YLkhbEnQVJw0Jjm0xvtBmdOY7DBNO4KOmfFS66aThw5qMUQHyUMyZOKbcdc9J5Ili0gewIllZ
 9MjAu+8exvwdtsfgcL6mhuFvqCUNQQo4HFK4T7g+ODRQbH3Se/VuiNHf8QX1G73w+DFDACLJV
 EZ4+HxRz33WjHjz2V+j4kGDfjp7pMBBOEDoVi6yZQfR0IRhG2cbgcXJeHIxwR0429ceDA5e78
 9am6VVBR/Buh6HkE6JdObCbiVqn8Ey4Si/Oy0Z/PXZ0jV445/z39803micoLAENd8UK0A+hC+
 53rzAaPswuTLqERh3JtAXZKgDfzY0PUR5/20s9UEdQYUby3gRO1m34xRviC7PkyoyDIf3HEib
 2lfmPLYzCaOMGlJsdhp9/ngVx2jwRBatjI6sqmqtLUoyW9oSP9IAicHsvMkuaxAECeM4d0Evh
 fIGlG734+Ajwmr1EgI2nRKrCS9VzLhVl8q1uMvZh8uLZvPSM/l5uFF/ndsecnfV3+AimA8JJt
 5oT9H9oc7sU2C/9+iVnO7sK+hef2uOYIUdKy8H+wnEtECZbqV/per6Ku/KBG2DQBup7unOrkn
 l5hwS4v0H8EcU3Y6IWABGPPylDhnP+/T1vJ4N9Zzv1ke3GKFnZkIUgW2gMVuL9thBJEsI7mzc
 GUbqJHhUOOs1inq9rzzbWU0VbX6MKfaoT3bOXfiLSGQtFV5lyr4pXgt07T8vysF7bBy5Elxow
 MQQjoxEDyQGdERvav8JjezivHp0pg/LIWtrZOuYNdTKlBx7ZNg11WmTfuh2rQRbQXGMJ+zjQi
 ZRekQnh+gyhajzt1pPV5D2I+0NsZBTCX79AKvXjKpInbVtMX2/3WFwBwGkBIXZWs5fDHjrpy9
 c13lryo5qybk1VOMYZh49WeHNOkZL2q22hsZdrmSOM+H1uinGATaOY9/GdkUZNNB1H8n/+3PB
 h93crA5osxziKxR5LE2VibDFyI2FX1wBUPhbULgKDg43vbL7tvKE8jlp4fC4=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 9 Nov 2019 09:13:01 +0100

Adjust jump targets so that exception handling code can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/net/ethernet/freescale/fman/mac.c | 42 ++++++++++++-----------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ether=
net/freescale/fman/mac.c
index e0680257532c..7fbd7cc24ede 100644
=2D-- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -659,16 +659,14 @@ static int mac_probe(struct platform_device *_of_dev=
)
 	of_dev =3D of_find_device_by_node(dev_node);
 	if (!of_dev) {
 		dev_err(dev, "of_find_device_by_node(%pOF) failed\n", dev_node);
-		err =3D -EINVAL;
-		goto _return_of_node_put;
+		goto _e_inval_put_node;
 	}

 	/* Get the FMan cell-index */
 	err =3D of_property_read_u32(dev_node, "cell-index", &val);
 	if (err) {
 		dev_err(dev, "failed to read cell-index for %pOF\n", dev_node);
-		err =3D -EINVAL;
-		goto _put_device;
+		goto _e_inval_put_device;
 	}
 	/* cell-index 0 =3D> FMan id 1 */
 	fman_id =3D (u8)(val + 1);
@@ -717,8 +715,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	err =3D of_property_read_u32(mac_node, "cell-index", &val);
 	if (err) {
 		dev_err(dev, "failed to read cell-index for %pOF\n", mac_node);
-		err =3D -EINVAL;
-		goto _put_parent_device;
+		goto _e_inval_put_parent_device;
 	}
 	priv->cell_index =3D (u8)val;

@@ -726,8 +723,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	mac_addr =3D of_get_mac_address(mac_node);
 	if (IS_ERR(mac_addr)) {
 		dev_err(dev, "of_get_mac_address(%pOF) failed\n", mac_node);
-		err =3D -EINVAL;
-		goto _put_parent_device;
+		goto _e_inval_put_parent_device;
 	}
 	ether_addr_copy(mac_dev->addr, mac_addr);

@@ -743,8 +739,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (nph !=3D ARRAY_SIZE(mac_dev->port)) {
 		dev_err(dev, "Not supported number of fman-ports handles of mac node %p=
OF from device tree\n",
 			mac_node);
-		err =3D -EINVAL;
-		goto _put_parent_device;
+		goto _e_inval_put_parent_device;
 	}

 	for (i =3D 0; i < ARRAY_SIZE(mac_dev->port); i++) {
@@ -753,24 +748,21 @@ static int mac_probe(struct platform_device *_of_dev=
)
 		if (!dev_node) {
 			dev_err(dev, "of_parse_phandle(%pOF, fsl,fman-ports) failed\n",
 				mac_node);
-			err =3D -EINVAL;
-			goto _return_of_node_put;
+			goto _e_inval_put_node;
 		}

 		of_dev =3D of_find_device_by_node(dev_node);
 		if (!of_dev) {
 			dev_err(dev, "of_find_device_by_node(%pOF) failed\n",
 				dev_node);
-			err =3D -EINVAL;
-			goto _return_of_node_put;
+			goto _e_inval_put_node;
 		}

 		mac_dev->port[i] =3D fman_port_bind(&of_dev->dev);
 		if (!mac_dev->port[i]) {
 			dev_err(dev, "dev_get_drvdata(%pOF) failed\n",
 				dev_node);
-			err =3D -EINVAL;
-			goto _put_device;
+			goto _e_inval_put_device;
 		}
 		of_node_put(dev_node);
 	}
@@ -821,8 +813,7 @@ static int mac_probe(struct platform_device *_of_dev)
 		phy =3D of_phy_find_device(mac_dev->phy_node);
 		if (!phy) {
 			err =3D -EINVAL;
-			of_node_put(mac_dev->phy_node);
-			goto _return_of_get_parent;
+			goto _put_phy_node;
 		}

 		priv->fixed_link->link =3D phy->link;
@@ -837,8 +828,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	err =3D mac_dev->init(mac_dev);
 	if (err < 0) {
 		dev_err(dev, "mac_dev->init() =3D %d\n", err);
-		of_node_put(mac_dev->phy_node);
-		goto _return_of_get_parent;
+		goto _put_phy_node;
 	}

 	/* pause frame autonegotiation enabled */
@@ -866,10 +856,22 @@ static int mac_probe(struct platform_device *_of_dev=
)

 	goto _return;

+_put_phy_node:
+	of_node_put(mac_dev->phy_node);
+	goto _return_of_get_parent;
+
+_e_inval_put_node:
+	err =3D -EINVAL;
+	goto _return_of_node_put;
+
+_e_inval_put_parent_device:
+	err =3D -EINVAL;
 _put_parent_device:
 	put_device(&of_dev->dev);
 	goto _return_of_get_parent;

+_e_inval_put_device:
+	err =3D -EINVAL;
 _put_device:
 	put_device(&of_dev->dev);
 _return_of_node_put:
=2D-
2.24.0

