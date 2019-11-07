Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B625F397F
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 21:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfKGUZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 15:25:12 -0500
Received: from mout.web.de ([212.227.17.12]:37187 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfKGUZM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 15:25:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1573158299;
        bh=h+hnYciR3R0RDvRpTXpOQh13Y7dm7cDXRVPS7TqNK8o=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=X1fgYTs5ddR4GTHiyWHUtGJa7aXqj6uvDFo9Cb/3zTuceJpxfOO1PhnD5I74fp1hO
         utVnG8zIQPKeSG3PbaatZAIknfon3s6fRVz5EhyJmAV0vUL0U54xuVxds0bTFqdm0c
         rQzDkQydLzzDL9LMLLlOgTHAu8yAhv8fT8dLoR/s=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.68.124]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MaJvw-1iDKol025A-00Jnv5; Thu, 07
 Nov 2019 21:24:59 +0100
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Igor Russkikh <igor.russkikh@aquantia.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] net: aquantia: Use common error handling code in
 aq_pci_probe()
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <f155464c-5cbd-5cf7-c889-dabbe0f1135e@web.de>
Date:   Thu, 7 Nov 2019 21:24:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:y08fUaNZEZA5x1U0mAUElCdxyEBFsUh9JJ712jIfjLdekwMw78c
 yWGNFyyNhjvZhy0XsCP6ZJy1Klgxn/20Xsp1mFeLRAFyj1rfoEUxbwX8dfiBYezJZaFE+5c
 qxt8vjTD0IA1Xq7/nW78K5LaVdOMYA4wIaBmBSSoT16qBIYLEccDUz1V1gTjZ0w/zpXabFy
 rqGZqTqGqaaeUeykEKstg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8leFqPLzEOs=:ol2WMseU3WCK6uJ1vmd8wC
 Sa9QjGn/V26Ib/N4RQskKlj+kdiXAxqWAKl59QN8YUGdXf5X+ZuEdiGr1aVH4sqwlRE/0MDOw
 tQHuyoE75D+hn91gYruQyDH6SuzhAGgI/tIKYqta03shHkQH6bDtUFiQB2h6S98wOsKzP/Rkh
 G9YTvN5Liz4JdPj4iva1GWcliK+GWLoYZy3Pzouavmpb+6E/HhDAxbwSLcfUOz6qv7i9q+S3C
 Hc15Oxrg/bnQnChF1L7wa3s2Unzagxdm15AeemCQZovN0p2Dj63i25CjjvnxY/00kk0QNviHi
 Iuvnv3A4+YSzb7y6E+GBaMav9NbDb2XIXc4f0QcRlHcFJGr9WpbuZX6a1XmIsDXuFxz8yMuJJ
 Ui2sU7+0qpX8uf2AhqJFjGdRasdBEaw2TgXzUXGAT6XY/doXxTstXqX07KFvvqQV6efu7hpkW
 skVY28ePB9zyB6iScilrtLYXrF5OvdpBZGNEF/9Xb8HUuhbK5g2tPmMJWGZMSwHBEg+1DR2kT
 qc/6m3ytXSLWM56nzPWdkNZtk0S5Up1DGA6B5uP1KoS5n/tA/o49Rd7QqO/i57DQ0Z9N+J4XY
 +BKyDpyEoETFrdEn8pKgeDeHBSxyYR2t9HBznanegiYN1IKe7C3X0apLxLLSD4sDpIGyhauwK
 jiinH/34Cd1BMJJ1QdWGM7vrWGzB2p+Dtot5bRv6YxmbIghhk+pqVKG3wNFtoyjh6l6iBxbPo
 9mAm/2tRZ3Ad+CPwDp7NqRTNuD8XzHLKBrnJRVgoK8SxJ4YoSWmGv+cZGgTvao9HyeIpf9T5h
 8h7s9uZUdONWbcLe2t2i+dWWomUJtbEn+ZTdCf/cckP+kpZxw5pdvyD0M5BfsUu7jxLQ7Fj28
 dn3UreETdp79IsKyrsBgwfKXzbsrQcy4930kvgROOBqMA5r7dBIQw2eWUQr+ugQMKvUFon9a2
 RLWozxZN10pq/M8Xd6vVmUaf2nVVDVZww92uoXuVCBRrGTZVmuZ1aEjBgD9U5fFmncgmK2LRd
 wcs8j4j1VEJXqaECv3s5nznos+hciFvEtn9lUpgPbSKn+e4x86h9dnanUedVR3tc1BxnxmF7H
 pc9qct79lTPylPm8/lQPDv6jnDvORQfuL+Zc8X8C53SzXRI9YDKNu6s1WImRBR8QkXsMiGjzh
 wUz3k++SoV2IXGia+oc1uTJx5q+DzWK3VCSUS/xmIy4uelMLktZwWkkwq4jGxxXxnonQ5BZTO
 1IUcFRH1P/cHpOdWwDUYiF5zqgomV/YJIqyawaAsGJei7SC5hH3/utiYDq74=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 7 Nov 2019 21:17:40 +0100

Move the same error code assignments so that such exception handling
can be better reused at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 .../ethernet/aquantia/atlantic/aq_pci_func.c  | 29 +++++++++----------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/driver=
s/net/ethernet/aquantia/atlantic/aq_pci_func.c
index e82c96b50373..be0c018d0074 100644
=2D-- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -241,30 +241,23 @@ static int aq_pci_probe(struct pci_dev *pdev,
 			resource_size_t reg_sz;

 			mmio_pa =3D pci_resource_start(pdev, bar);
-			if (mmio_pa =3D=3D 0U) {
-				err =3D -EIO;
-				goto err_free_aq_hw;
-			}
+			if (mmio_pa =3D=3D 0U)
+				goto e_io;

 			reg_sz =3D pci_resource_len(pdev, bar);
-			if ((reg_sz <=3D 24 /*ATL_REGS_SIZE*/)) {
-				err =3D -EIO;
-				goto err_free_aq_hw;
-			}
+			if (reg_sz <=3D 24 /* ATL_REGS_SIZE */)
+				goto e_io;

 			self->aq_hw->mmio =3D ioremap_nocache(mmio_pa, reg_sz);
-			if (!self->aq_hw->mmio) {
-				err =3D -EIO;
-				goto err_free_aq_hw;
-			}
+			if (!self->aq_hw->mmio)
+				goto e_io;
+
 			break;
 		}
 	}

-	if (bar =3D=3D 4) {
-		err =3D -EIO;
-		goto err_free_aq_hw;
-	}
+	if (bar =3D=3D 4)
+		goto e_io;

 	numvecs =3D min((u8)AQ_CFG_VECS_DEF,
 		      aq_nic_get_cfg(self)->aq_hw_caps->msix_irqs);
@@ -312,6 +305,10 @@ static int aq_pci_probe(struct pci_dev *pdev,
 err_pci_func:
 	pci_disable_device(pdev);
 	return err;
+
+e_io:
+	err =3D -EIO;
+	goto err_free_aq_hw;
 }

 static void aq_pci_remove(struct pci_dev *pdev)
=2D-
2.24.0

