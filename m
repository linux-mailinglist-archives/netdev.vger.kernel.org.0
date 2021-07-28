Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4493B3D8C46
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 12:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236001AbhG1Kyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 06:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231994AbhG1Kyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 06:54:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B77CD60F9B;
        Wed, 28 Jul 2021 10:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627469677;
        bh=sq4z9TbkFj1mPktqjg2N583d+O6EFUCt3T0Pf9NUTq8=;
        h=From:To:Cc:Subject:Date:From;
        b=vRJu7BzrHbzAV6CQduG7Njpqur3wD1j7T9P1/8b7pW1swxCnnP+SH7nUpEk/+mFA+
         onhe0R4FUztFOkXWTkIu596UNv73QRu+fDY08kkJw58aZ0DCu6G3VMKsnBVWhwMobj
         cMA+wuY1IH8WHMIlO+JwzoVlOhi4+Et/mYnsqRFHoap1OY12Hi3Hy9QCw1zZ4FiwN7
         i1K+X0I2JsE1j1kSkT1RRUMNqhsardHFHaV2uT0+houghhwrwHtGxtpfEWEr2qIA0G
         7ShqM84BMG6xsOtBxrM0k5VA1ADoFcKnpjQm4f7axN5cq//Net0QQW4WAJbxpAKqZQ
         pQLVwpd2JfI+w==
From:   Mark Brown <broonie@kernel.org>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Date:   Wed, 28 Jul 2021 11:54:23 +0100
Message-Id: <20210728105423.1064-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/nfc/s3fwrn5/firmware.c

between commit:

  801e541c79bb ("nfc: s3fwrn5: fix undefined parameter values in dev_err()")

from the net tree and commit:

  a0302ff5906a ("nfc: s3fwrn5: remove unnecessary label")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc drivers/nfc/s3fwrn5/firmware.c
index 1340fab9565e,1421ffd46d9a..000000000000
--- a/drivers/nfc/s3fwrn5/firmware.c
+++ b/drivers/nfc/s3fwrn5/firmware.c
@@@ -421,10 -421,9 +421,9 @@@ int s3fwrn5_fw_download(struct s3fwrn5_
  
  	tfm = crypto_alloc_shash("sha1", 0, 0);
  	if (IS_ERR(tfm)) {
- 		ret = PTR_ERR(tfm);
  		dev_err(&fw_info->ndev->nfc_dev->dev,
 -			"Cannot allocate shash (code=%d)\n", ret);
 +			"Cannot allocate shash (code=%ld)\n", PTR_ERR(tfm));
- 		goto out;
+ 		return PTR_ERR(tfm);
  	}
  
  	ret = crypto_shash_tfm_digest(tfm, fw->image, image_size, hash_data);
