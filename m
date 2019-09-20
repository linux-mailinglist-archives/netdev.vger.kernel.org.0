Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBDC3B8EB5
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 12:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391936AbfITK5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 06:57:13 -0400
Received: from mout.web.de ([212.227.15.3]:58685 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390701AbfITK5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 06:57:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1568977022;
        bh=I8e3stxS7V1WyGkY8UZNqxelRhUMbfnybkK8wCp4Jlc=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=a5b3TB/87/K8oPhFseUR+7VOUV10ESWzQ1MjnNiIWjy/1G1MvuWdVKRS+aXs2aZiX
         9rxsRtckf05wwSbJX5VN+RoPp/S03eHKCDqHtVDZddWIYGCPLNy3gZmWC2Qb+OUnX9
         KEi4gBlqsjPpuMNDO9RfIXNjx59j8ganImfe/YFs=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.117.22]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M6mQO-1hwt0D3MdY-00wUtX; Fri, 20
 Sep 2019 12:57:01 +0200
Subject: [PATCH v2] ethernet: lantiq_xrx200: Use
 devm_platform_ioremap_resource() in xrx200_probe()
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Radhey Shyam Pandey <radheys@xilinx.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <af65355e-c2f8-9142-4d0b-6903f23a98b2@web.de>
 <CH2PR02MB700047AFFFE08FE5FD563541C78E0@CH2PR02MB7000.namprd02.prod.outlook.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <43bed158-2af9-c518-2f97-a473c2b84eb7@web.de>
Date:   Fri, 20 Sep 2019 12:57:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CH2PR02MB700047AFFFE08FE5FD563541C78E0@CH2PR02MB7000.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rcWsVRp4VpVCA9U7CyHwrhvfv9I/+YKNCHDfKQo/Q45+39/oHrq
 s142pnR3wIji4COb6UXeCELnE+MjPfG1WRVlFzptDONAhcrbKLo7J1/ChtrOpfFf0rospWV
 QMwcVM8zMpi2apfs0lBnMWQ1FianCZf4fzzydQWFyIY9nVWzDXwALI2guKMkXLNFB5HKAgI
 SpL6Um8ClhpdBoNZWOH1Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6UQCvgHc+ZE=:JgBLGAFSTHLyTNKn3qZXt4
 TsdWPmy28j2wIWm19H8eOxAUjLvRMFEPbNjRB92OWWqX0ZMhdhcuwr62/64ZABXsXWb/uNQAY
 35q9vna+0t7ReZCfCtzgETPcJniqXnOhZeyQwPORQLl1XlzzslL5ruHeZpjwQWbgcj+xhNyzs
 xZKqaLti/+7Rct8puA3IVSUCGJM7GwBby0a6hCIauSdV79EtaRZ/pIXdrIbLuRMfGhXx13rua
 Q+IWbasIIcpIDhjYVqXIXty1N/HskospAujJ1yYBUZRCJEx1iT1OvF2YVskCcnn9kQT/D3c61
 a0a+uYmep41ICkDfmRSjEcaz+/CWNWbc1v9ss0vW8Njwd9u8Lara18ne7htD2FLRzxVQHZKnA
 EDtSZ2EXtGpNwkPxnHQWhVVre+fZcDrHg5CxRLvO7+K+5XBjHhRCl0SZWseXv3Kbi1T0azQU1
 Um3C1dJUhiQVF1hftbB+WF+pLXOrarlHcIs3s5y8WNK9dGaPnzct0fkpPP6XoIOh2X4PYDJCf
 3rR0oTAaUUqujBM/XAmaJclmnMW/+8OfXUkH1xreCSy1FZjfTUOcDeCjf0cJ3HQVzLcBD76Lw
 +yI76exhHOSrlRauNPfihHxISzoGJ0JnV/vHERTJL5TQWho1tllJpYuJviiH/6z71m6Pg0oJ/
 bzHow/lcZU/VTx2glXqJ5M0Dg5n3eWB1wvLXJP2r9fhabDyYUct2ArHCEdkPxierweFYZDbwn
 DrGaa6YVPu041F/h90z6wOED2pjW3omdb54+kVRQNuuPUpt7QNXy3uyMgQ7gK45XRWVXV4LVK
 lhfIYYZyJnpLDk5om8+bGGHvYckCv1UDyN9qBgipnWb6vhYN5jySL1+LEovTQ/bm+xvp6wWnu
 9qw6CCGwB48MsIYwH7nVEok17962uuQPt0KA89lYJMVPyNoFtpsleBxzaMEvXM0A2lY/6F6ib
 Cs0Gyd8dMLYxakHSXaVMEL7fa8rHkosz20UXFxwe8Ag+TYNC0DZkKrc+bn24G/fEFVMa3VHH6
 ib71GsBcGXtTgZI4L78P+1N7Jm+mj69JBJOPYHxLnKv9TV99w3bjG+WyCBd4M4Ci+9vgA6UQ3
 S86D9XVQMfDRPcSEMbfdBq5VTEB2BSMoq9/X6y5q2ytorLffhfe7RICk8tiZ4v+5qEB93YnUU
 pAVdpPaV2FnFbvUVZqyUIWxIX1JV/v5U9OtLZnOROqePCQvJjM56WJxMRLtb8+vC74vHMdNR5
 DOAzzDvY6/FE6+a82I3B4pc/dWMJNpzOU9+7xjfLz8eXCimH5pGzuCg5N8rE=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 20 Sep 2019 11:48:33 +0200

Simplify this function implementation by using the wrapper function
=E2=80=9Cdevm_platform_ioremap_resource=E2=80=9D instead of calling the fu=
nctions
=E2=80=9Cplatform_get_resource=E2=80=9D and =E2=80=9Cdevm_ioremap_resource=
=E2=80=9D directly.

* Thus reduce also a bit of exception handling code here.
* Delete the local variable =E2=80=9Cres=E2=80=9D.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--

v2:
Further changes were requested by Radhey Shyam Pandey.

https://lore.kernel.org/r/CH2PR02MB700047AFFFE08FE5FD563541C78E0@CH2PR02MB=
7000.namprd02.prod.outlook.com/



* Updates for three modules were split into a separate patch for each driv=
er.

* The commit description was adjusted.





 drivers/net/ethernet/lantiq_xrx200.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/l=
antiq_xrx200.c
index 900affbdcc0e..0a7ea45b9e59 100644
=2D-- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -424,7 +424,6 @@ static int xrx200_probe(struct platform_device *pdev)
 {
 	struct device *dev =3D &pdev->dev;
 	struct device_node *np =3D dev->of_node;
-	struct resource *res;
 	struct xrx200_priv *priv;
 	struct net_device *net_dev;
 	const u8 *mac;
@@ -443,15 +442,7 @@ static int xrx200_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(net_dev, dev);
 	net_dev->min_mtu =3D ETH_ZLEN;
 	net_dev->max_mtu =3D XRX200_DMA_DATA_LEN;
-
-	/* load the memory ranges */
-	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "failed to get resources\n");
-		return -ENOENT;
-	}
-
-	priv->pmac_reg =3D devm_ioremap_resource(dev, res);
+	priv->pmac_reg =3D devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->pmac_reg)) {
 		dev_err(dev, "failed to request and remap io ranges\n");
 		return PTR_ERR(priv->pmac_reg);
=2D-
2.23.0

