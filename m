Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A673F5E26
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 10:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfKIJAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 04:00:52 -0500
Received: from mout.web.de ([212.227.15.14]:58839 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbfKIJAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 04:00:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1573290031;
        bh=G5WT9018vUhaMGJJGfBWCHGF4o3V3lUzPY8ENWHnJlY=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=EqdzMrcc7UrofWYjNYJ4Bzm1gN9iafDRxHnhhYn/5EiXp6FjeY1pz+bq3936wtBGf
         JouVkCsPX7c418nzVzuz50VtN2OMnaN6JPIwY+7FidxTzLQ6f34qUzfLyk+FQfEiJU
         KAldSQpUdGxs4ysgKVBj5orAcb0RbKxcLQG7y3iY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.82.67]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LZeou-1i3yXD1qrE-00lYd6; Sat, 09
 Nov 2019 10:00:31 +0100
Subject: [PATCH 1/3] fsl/fman: Add missing put_device() calls in mac_probe()
From:   Markus Elfring <Markus.Elfring@web.de>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>
References: <132e8369-c4da-249f-76b8-834e394dc6d5@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <63d9c06f-7cb8-1c44-1666-12d31f937a31@web.de>
Date:   Sat, 9 Nov 2019 10:00:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <132e8369-c4da-249f-76b8-834e394dc6d5@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:xzhhk4lZZNRZTh8k0ifOtUV1H/0l3CWU6fPrk6f+PmH5pm6rt9r
 J8EdPhE+wmNN/8q6edLQyRLTQ4Wpqs1Q5lr4wczoEu5cVKqnsOp7i+XuILO/83WOUo790if
 zwvayXCOvGpjcWEiT6FZfta2xVs89z2SzU7RT8hR8xDlvqgu4ZIwibK+8YfEtdv3egjMABn
 bk5BMnhGqARaatDlXs28A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:98jtglzuN88=:7ap2bALMRyoUcvhsplkDNY
 OC4hfxHTa2L5M85Uy0nbJlDT6N6/BP2z+J9c8hW9ZknpEJJLOZdd8Fe6fPhtLmbMxTiPZo6rk
 nyBlhNKdzCmgWsROS3YHz2LADMIniB0aXdQm0hjFi5yVEaZWtirPoDEsgqHPWb89BNsu7r2t3
 6jXVKip4LNgldr99nPq7g0+xQUiHetRcEguxdlp6lDzX3XNJmhH5ZJ4lqCCLyO9LtyhbxJhLU
 YEWTkLWZAJvnaXdXA2rs5ZEP2rfm3srQjo8N57WBqFO+1ICHWeHUOeSuMvK2WwkSTAvxJ7N02
 zTCrr6FXMALxy+HLGKPmNBjlmtKdl7CJ359BqcQFc3AhDhferMOGEeL3SQQhs7JmwD5X0vPoa
 vjRha8pR0jVxz0OvfrDkGJcgTQWjWJgWFFfTTaXw3uJqvHDlJrHI105PFeQnhKxq/D+QZ7G7t
 +TfvQT5C6UQPq/dd5VXYUeH8yciZ022lRjneEewwzCx0/1PIikUicH+/od+MZNws6mMj8e8I8
 Y/bHP57Iov3071FCTU3C5pTwKXNS+wJPHc6N/wRZvXohvXlqjSQkz8lJkkwOxSrQKpQGb2IBW
 EanR6IVM/Pxz8XdSe2g/ibrprKRioIpn2075JXehLMI06AKpvvR/ASCeqBUjylE0BwiBuuisb
 0NBkB6hWciFLLte2bHNUklSwol3YhdXePQ09RCT/TnCV8KxCZw37y+Esj62zK+oo9RR16rsgm
 0gYIiNGqsfzKQZRioGMPbA+ttbUeTJleqE4frlbSvCer6kGJQPe08JumeMQ0dcdeJU8d30SLW
 EFd5cP2VmblLwxnmfGoktmgZuR2+ujVp84DWPvMJz+P+Qx1HVTjvA+c31TEj2lTlPaWHxXnKv
 6eOq9QOn7WKtzBdjoqeDH38uq6nIRukfmpJnl15kc9RGvYDTnCh07MCPOGyKYtEniWSGL424b
 75jamyN0W8L8StqLXVaWCQU1rEoD0/2dQzzwY+rS9v4wb3Q6L2wTKCJMyQVtc7mIH62yczGbd
 Bnmsq6RNjbWKehpwjNhO1QD/4JR+vn8cNIDBtrVAl9RxbVLrC4eKQeZWntrH+YmxbiFnxSrHl
 vqp2m4TEJZ3EeJg8PbdEQxa/S8xMZPuG8uZ0koAwCfryjKfAFfHY5ZdPlc0oix2UwET1iwq2B
 vqFIXpXzQYna+FJ2DF1OK/a7vwig13cLUTOgH7qKYdzeN2RTZMFUauGxyg5170N+kCgTsYZX2
 ulUw7Z9B3MG7j2Tu4ttJC5kjDgD1IwnBs7GPhAO6qwhz4Hp20Q9lZcckRqhM=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 9 Nov 2019 08:14:35 +0100

A coccicheck run provided information like the following.

drivers/net/ethernet/freescale/fman/mac.c:874:1-7: ERROR: missing put_devi=
ce;
call of_find_device_by_node on line 659, but without a corresponding
object release within this function.
drivers/net/ethernet/freescale/fman/mac.c:874:1-7: ERROR: missing put_devi=
ce;
call of_find_device_by_node on line 760, but without a corresponding
object release within this function.

Generated by: scripts/coccinelle/free/put_device.cocci

Thus adjust jump targets to fix the exception handling for this
function implementation.

Fixes: 3933961682a30ae7d405cda344c040a129fea422 ("fsl/fman: Add FMan MAC d=
river")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/net/ethernet/freescale/fman/mac.c | 28 ++++++++++++++---------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ether=
net/freescale/fman/mac.c
index f0806ace1ae2..e0680257532c 100644
=2D-- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -668,7 +668,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err) {
 		dev_err(dev, "failed to read cell-index for %pOF\n", dev_node);
 		err =3D -EINVAL;
-		goto _return_of_node_put;
+		goto _put_device;
 	}
 	/* cell-index 0 =3D> FMan id 1 */
 	fman_id =3D (u8)(val + 1);
@@ -677,7 +677,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (!priv->fman) {
 		dev_err(dev, "fman_bind(%pOF) failed\n", dev_node);
 		err =3D -ENODEV;
-		goto _return_of_node_put;
+		goto _put_device;
 	}

 	of_node_put(dev_node);
@@ -687,7 +687,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err < 0) {
 		dev_err(dev, "of_address_to_resource(%pOF) =3D %d\n",
 			mac_node, err);
-		goto _return_of_get_parent;
+		goto _put_parent_device;
 	}

 	mac_dev->res =3D __devm_request_region(dev,
@@ -697,7 +697,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (!mac_dev->res) {
 		dev_err(dev, "__devm_request_mem_region(mac) failed\n");
 		err =3D -EBUSY;
-		goto _return_of_get_parent;
+		goto _put_parent_device;
 	}

 	priv->vaddr =3D devm_ioremap(dev, mac_dev->res->start,
@@ -705,12 +705,12 @@ static int mac_probe(struct platform_device *_of_dev=
)
 	if (!priv->vaddr) {
 		dev_err(dev, "devm_ioremap() failed\n");
 		err =3D -EIO;
-		goto _return_of_get_parent;
+		goto _put_parent_device;
 	}

 	if (!of_device_is_available(mac_node)) {
 		err =3D -ENODEV;
-		goto _return_of_get_parent;
+		goto _put_parent_device;
 	}

 	/* Get the cell-index */
@@ -718,7 +718,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err) {
 		dev_err(dev, "failed to read cell-index for %pOF\n", mac_node);
 		err =3D -EINVAL;
-		goto _return_of_get_parent;
+		goto _put_parent_device;
 	}
 	priv->cell_index =3D (u8)val;

@@ -727,7 +727,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (IS_ERR(mac_addr)) {
 		dev_err(dev, "of_get_mac_address(%pOF) failed\n", mac_node);
 		err =3D -EINVAL;
-		goto _return_of_get_parent;
+		goto _put_parent_device;
 	}
 	ether_addr_copy(mac_dev->addr, mac_addr);

@@ -737,14 +737,14 @@ static int mac_probe(struct platform_device *_of_dev=
)
 		dev_err(dev, "of_count_phandle_with_args(%pOF, fsl,fman-ports) failed\n=
",
 			mac_node);
 		err =3D nph;
-		goto _return_of_get_parent;
+		goto _put_parent_device;
 	}

 	if (nph !=3D ARRAY_SIZE(mac_dev->port)) {
 		dev_err(dev, "Not supported number of fman-ports handles of mac node %p=
OF from device tree\n",
 			mac_node);
 		err =3D -EINVAL;
-		goto _return_of_get_parent;
+		goto _put_parent_device;
 	}

 	for (i =3D 0; i < ARRAY_SIZE(mac_dev->port); i++) {
@@ -770,7 +770,7 @@ static int mac_probe(struct platform_device *_of_dev)
 			dev_err(dev, "dev_get_drvdata(%pOF) failed\n",
 				dev_node);
 			err =3D -EINVAL;
-			goto _return_of_node_put;
+			goto _put_device;
 		}
 		of_node_put(dev_node);
 	}
@@ -866,6 +866,12 @@ static int mac_probe(struct platform_device *_of_dev)

 	goto _return;

+_put_parent_device:
+	put_device(&of_dev->dev);
+	goto _return_of_get_parent;
+
+_put_device:
+	put_device(&of_dev->dev);
 _return_of_node_put:
 	of_node_put(dev_node);
 _return_of_get_parent:
=2D-
2.24.0

