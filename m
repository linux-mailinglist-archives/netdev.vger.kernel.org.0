Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5013D8D51
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 13:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbhG1L55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 07:57:57 -0400
Received: from m12-11.163.com ([220.181.12.11]:35664 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236145AbhG1L5r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 07:57:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=u3qOm
        i3yxLZFOkDotBepUEsryH0TnOvUsnY/qvFuVKg=; b=ZDRxCktgL8uMj84k1BJW9
        CuIOOWGYhz9f+R8+vzPCULDnHtig/AbRLeB2lKdlgtPWm6YfckaijexFOm4BMplw
        Mkc75V6GQXxG7vs5YSEQ5cc5brpinB4n5pOd8JKjzkSR87MI4eKUXtBepvEhgFdr
        auAHe/LBeda4BBT1r4Ypys=
Received: from localhost (unknown [218.17.89.92])
        by smtp7 (Coremail) with SMTP id C8CowABHRZ0mRgFhIOECpA--.48350S2;
        Wed, 28 Jul 2021 19:57:26 +0800 (CST)
Date:   Wed, 28 Jul 2021 19:57:34 +0800
From:   wengjianfeng <samirweng1979@163.com>
To:     broonie@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        tangbin@cmss.chinamobile.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210728195734.00002cfe@163.com>
Organization: yulong
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: C8CowABHRZ0mRgFhIOECpA--.48350S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF1xCFWUJrWDAryUZrWDurg_yoW8Xr1kpr
        W5J3W0kF18JFn5ArykAw4DuF15tw1xCr1Uu392q3y8AF93ZF97GanF9FWkWrWDurWF93W3
        tr42qw1293WFqaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jATmDUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiHQfdsVSIrqS+NAAAsq
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi all,
> >
> >Today's linux-next merge of the net-next tree got a conflict in:
> >
> >  drivers/nfc/s3fwrn5/firmware.c
> >
> >between commit:
> >
> >  801e541c79bb ("nfc: s3fwrn5: fix undefined parameter values in
> >  dev_err()")
> >
> > from the net tree and commit:

> >  a0302ff5906a ("nfc: s3fwrn5: remove unnecessary label")

> > from the net-next tree.

> > I fixed it up (see below) and can carry the fix as necessary. This
> > is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your
> > tree is submitted for merging.  You may also want to consider
> > cooperating with the maintainer of the conflicting tree to minimise
> > any particularly complex conflicts.

> > diff --cc drivers/nfc/s3fwrn5/firmware.c
> > index 1340fab9565e,1421ffd46d9a..000000000000
> > --- a/drivers/nfc/s3fwrn5/firmware.c
> > +++ b/drivers/nfc/s3fwrn5/firmware.c
> > @@@ -421,10 -421,9 +421,9 @@@ int s3fwrn5_fw_download(struct
> > s3fwrn5_
> > 
> >  tfm = crypto_alloc_shash("sha1", 0, 0);
> >  if (IS_ERR(tfm)) {
> >- ret = PTR_ERR(tfm);
 > > dev_err(&fw_info->ndev->nfc_dev->dev,
> >-	"Cannot allocate shash (code=%d)\n", ret);
> >+	"Cannot allocate shash (code=%ld)\n", PTR_ERR(tfm));
> >- goto out;
> >+ return PTR_ERR(tfm);
> >  }
> > 
> >  ret = crypto_shash_tfm_digest(tfm, fw->image, image_size,
> > hash_data);

Hi Mark,  
  Thanks for you fix the issue, I'll pay attention to this later.

