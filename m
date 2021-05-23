Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4892538DB3D
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 15:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhEWN0n convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 23 May 2021 09:26:43 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:22861 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231757AbhEWN0m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 09:26:42 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4Fp1L224XdzB6pT;
        Sun, 23 May 2021 15:25:14 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dsG_czGrW-V2; Sun, 23 May 2021 15:25:14 +0200 (CEST)
Received: from vm-hermes.si.c-s.fr (vm-hermes.si.c-s.fr [192.168.25.253])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4Fp1L212RgzB6hw;
        Sun, 23 May 2021 15:25:14 +0200 (CEST)
Received: by vm-hermes.si.c-s.fr (Postfix, from userid 33)
        id C951716D; Sun, 23 May 2021 15:29:37 +0200 (CEST)
Received: from 37-164-13-85.coucou-networks.fr
 (37-164-13-85.coucou-networks.fr [37.164.13.85]) by messagerie.c-s.fr (Horde
 Framework) with HTTP; Sun, 23 May 2021 15:29:37 +0200
Date:   Sun, 23 May 2021 15:29:37 +0200
Message-ID: <20210523152937.Horde.5kC0kzvaP3No5BC63LlZ_A7@messagerie.c-s.fr>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, rasmus.villemoes@prevas.dk,
        kuba@kernel.org, davem@davemloft.net, leoyang.li@nxp.com
Subject: Re: [PATCH net-next] ethernet: ucc_geth: Use kmemdup() rather than
 kmalloc+memcpy
In-Reply-To: <20210523075616.14792-1-yuehaibing@huawei.com>
User-Agent: Internet Messaging Program (IMP) H5 (6.2.3)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> a écrit :

> Issue identified with Coccinelle.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/freescale/ucc_geth.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/freescale/ucc_geth.c  
> b/drivers/net/ethernet/freescale/ucc_geth.c
> index e0936510fa34..51206272cc25 100644
> --- a/drivers/net/ethernet/freescale/ucc_geth.c
> +++ b/drivers/net/ethernet/freescale/ucc_geth.c
> @@ -3590,10 +3590,10 @@ static int ucc_geth_probe(struct  
> platform_device* ofdev)
>  	if ((ucc_num < 0) || (ucc_num > 7))
>  		return -ENODEV;
>
> -	ug_info = kmalloc(sizeof(*ug_info), GFP_KERNEL);
> +	ug_info = kmemdup(&ugeth_primary_info, sizeof(*ug_info),
> +			  GFP_KERNEL);

Can you keep that as a single line ? The tolerance is 100 chars per line now.

>  	if (ug_info == NULL)
>  		return -ENOMEM;
> -	memcpy(ug_info, &ugeth_primary_info, sizeof(*ug_info));
>
>  	ug_info->uf_info.ucc_num = ucc_num;
>
> --
> 2.17.1


