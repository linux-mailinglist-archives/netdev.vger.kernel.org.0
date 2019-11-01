Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0BB7EC6C0
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 17:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbfKAQ3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 12:29:46 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:59606 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbfKAQ3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 12:29:46 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 474SMW5qjrz9v2yn;
        Fri,  1 Nov 2019 17:29:43 +0100 (CET)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=aVhErQnj; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id kQdkFGodO6U4; Fri,  1 Nov 2019 17:29:43 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 474SMW4n7qz9v2ym;
        Fri,  1 Nov 2019 17:29:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1572625783; bh=sO50Jxi/6qCHwc0AfimOF6Zwlkx4COhWtKxf+QPTqKM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=aVhErQnjTF3qahziN3iZTdW4hERQNqbN6AMsA5ZDNSKR0RiIbk3UuTKoxbv+Og84m
         wPCPsR6Pb28lWx/OvbesOYQwySgR8i2qfmkZZwaTcSIjTehYfdS0o1sdzwTfIqAZgl
         AiJtQaCT8tDNVDx6tv+0jEN/ruZrQGchWBd6Rl5s=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 3D1398B8F6;
        Fri,  1 Nov 2019 17:29:45 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id mVNcyjLDRV0F; Fri,  1 Nov 2019 17:29:45 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id CCD838B7C2;
        Fri,  1 Nov 2019 17:29:44 +0100 (CET)
Subject: Re: [PATCH v3 35/36] net/wan: make FSL_UCC_HDLC explicitly depend on
 PPC32
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>
Cc:     linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Scott Wood <oss@buserror.net>, netdev@vger.kernel.org
References: <20191018125234.21825-1-linux@rasmusvillemoes.dk>
 <20191101124210.14510-1-linux@rasmusvillemoes.dk>
 <20191101124210.14510-36-linux@rasmusvillemoes.dk>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <4e2ac670-2bf4-fb47-2130-c0120bcf0111@c-s.fr>
Date:   Fri, 1 Nov 2019 17:29:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191101124210.14510-36-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 01/11/2019 à 13:42, Rasmus Villemoes a écrit :
> Currently, FSL_UCC_HDLC depends on QUICC_ENGINE, which in turn depends
> on PPC32. As preparation for removing the latter and thus allowing the
> core QE code to be built for other architectures, make FSL_UCC_HDLC
> explicitly depend on PPC32.

Is that really powerpc specific ? Can't the ARM QE perform HDLC on UCC ?

Christophe

> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>   drivers/net/wan/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
> index dd1a147f2971..78785d790bcc 100644
> --- a/drivers/net/wan/Kconfig
> +++ b/drivers/net/wan/Kconfig
> @@ -270,7 +270,7 @@ config FARSYNC
>   config FSL_UCC_HDLC
>   	tristate "Freescale QUICC Engine HDLC support"
>   	depends on HDLC
> -	depends on QUICC_ENGINE
> +	depends on QUICC_ENGINE && PPC32
>   	help
>   	  Driver for Freescale QUICC Engine HDLC controller. The driver
>   	  supports HDLC in NMSI and TDM mode.
> 
