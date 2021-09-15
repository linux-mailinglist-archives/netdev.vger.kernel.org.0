Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430A440CEBC
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 23:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbhIOVWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 17:22:18 -0400
Received: from mout.gmx.net ([212.227.15.19]:55231 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231840AbhIOVWR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 17:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631740841;
        bh=85P8KOWSraZ/o7YpaEMBWIyHbIKI0hZfH9X8NVWLP4U=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=grhNpy7jIhxxhMdMqg5Zg1o4h7AatPM1ETiYAlHaEua4cv8Hrr0ebPnaJR1ZrXDSP
         pX9VSKVTqWXLJg9ufHVhFWArbOBq1mwY9y/g4xGKFAqzhGqNiT368jaSRtLmYcJEgz
         1uYOapKzYg9J6YAO7yW3pvosA/udd4MUL9wae4TM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([46.223.119.124]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MFbW0-1mgYlT2Cbe-00H9fq; Wed, 15
 Sep 2021 23:20:41 +0200
Subject: Re: [PATCH] net/alacritech: Make use of the helper function
 dev_err_probe()
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210915145734.7145-1-caihuoqing@baidu.com>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <707ca3c3-f42a-d7f7-b52c-829d8e243c87@gmx.de>
Date:   Wed, 15 Sep 2021 23:20:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210915145734.7145-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:paAyYoaFbyKpHAcCZxjVr2PF77xbwlikriF3BL/QNmWXTgoPqBQ
 1xGkF7SRhnLKQJtrDFRE7/S0GuicjnjaaPIzCrfT+wRY5z9vhAe6K6iDi98kZNAErfcI+yj
 qIQm3V8XHYeypH6QevOjKTSieEp+YyGMzzOPPycEnDjIxcnxyRLWffY+/Imcj3a9+N+mQ2a
 LzktmtYX5vU2n0ObrnGZA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:aXoFxURQWjs=:Y2edibHHn8J/dYWXu8TWBk
 K3u4Qj2K5F19P01RVFUtSJcsqMJZ19ZFOY2pCL2aZY3pRuFAgCQygqZrgYp+1a9zFVUlPRDTR
 Y4cxlyi3Q6knlZSwmvmdbNXeLe71KcrpTg3cUIfnzywmh81XRJcD7MODOhFSgNwJifjFyUJEB
 dfD29thCUdLIYGm6kroN/zz9NutVYY50AXVdy3IMu+2qtXJfyTtAm2CG0x0ZGz9iSieT8A7EM
 uTStZa35a6+L0JcCIxnyvPIY2FF2kTnTJMNMUGHfIT47cM7cXBSHjsB6I+QNm3StWfZZjnSie
 ZOhhAKZPfQVjAqf38sHE0aHQmXh3eWyhfA6mkFqBFoR1mOyMqX/qlTnHryIIQ0l1zmo1Vk+FK
 N+r7+JJITlRXIfpIrhuz5ACduImXT0Wgj2ctqB6JtuBwPTQyF/dmzOWyDGFgTrOfx2KlePeE/
 qswezUVvbfE0hCjAKoXr4gDxACr9AlObIWcoKD+570U5pbUc+qApvYfAf1TANozN3+pxD8yFf
 iSOA3WhDLzWGkR4QxJxCpxuVNRfYeQNoPi1q3rWQ3Y/mOdx7DsiPZEf/NK/Agdl0YdPiR+4gJ
 z61sM87IBJcEdsTlqlViLd+fESzZKBqSXSDagW/8hSvz1jsLP7g/CKSxxnDXQiqjeUvx8FLwi
 2+qJAFNHKA8GzXojFnccqa7+2Qu5BdnZY6QGpXgIj3PI6J6GS2lWHbVIQjJjBnrfQN3SpYViZ
 EdkyrsuF12gmoOSk6IW6zfOOzQked3aFfRrfUgAmid3MOMtSOjcPr0yrNL9IBkOVfXOlAV9yT
 yt2GjnUejBCNvVaJW4lNOFwUdUUsjA/WpwUmnb90wl7NNa8tsLmdrGr8MZKqlBQOaX9T5nhc9
 +z1XbNshtcNKqzWVyoR4drbK/3nzjhReoE0cIODVpSqNUaV6QexmHkyVJZfNHaB2r8oWHspsT
 V7D2PFSMfMtjB5LCcyd9sUblKmoWMUenYDF+vaAYJLvAbHGc44zyyQhr5sOKAZiXsD3WgView
 OuqPdWrV12nP84ROjy7fzufdwMVOK2kIqpB0bZZv2mDtOWExFGq7NRVnMD9Awe/fO8uY321Ma
 +a4o1JKeqmeMjY=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

On 15.09.21 at 16:57, Cai Huoqing wrote:
> When possible use dev_err_probe help to properly deal with the
> PROBE_DEFER error, the benefit is that DEFER issue will be logged
> in the devices_deferred debugfs file.
> And using dev_err_probe() can reduce code size, and simplify the code.
>
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/net/ethernet/alacritech/slicoss.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/eth=
ernet/alacritech/slicoss.c
> index 696517eae77f..170ff8c77983 100644
> --- a/drivers/net/ethernet/alacritech/slicoss.c
> +++ b/drivers/net/ethernet/alacritech/slicoss.c
> @@ -1743,10 +1743,8 @@ static int slic_probe(struct pci_dev *pdev, const=
 struct pci_device_id *ent)
>  	int err;
>
>  	err =3D pci_enable_device(pdev);
> -	if (err) {
> -		dev_err(&pdev->dev, "failed to enable PCI device\n");
> -		return err;
> -	}
> +	if (err)
> +		return dev_err_probe(&pdev->dev, err, "failed to enable PCI device\n"=
);
>
>  	pci_set_master(pdev);
>  	pci_try_set_mwi(pdev);
>

in which case does pci_enable_device() ever return -EPROBE_DEFER?

Regards,
Lino
