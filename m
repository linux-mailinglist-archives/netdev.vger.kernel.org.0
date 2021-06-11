Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5FA3A4A31
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhFKUkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhFKUkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:40:51 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC557C061574;
        Fri, 11 Jun 2021 13:38:42 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id h16so6333780pjv.2;
        Fri, 11 Jun 2021 13:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9KuDiR0/afvizS4hj5Loo8cboTWM7MdUw0YpF4dlIWg=;
        b=e4OQoZbapGBsd95gfs4ae/RGRxzuezrU1OD20VjNZ+lKu4GxF+x99x2e53E8snHBK6
         ig/LOzry5seJ8nfXzMZIMt7/EQjtmm3CWfQgDbkg72fk5BZrzApvbOnZpgPGTB1NpIfv
         uXVHas6DXCpm9VXaajj7YO/CP70/8LkJRmN9HOSmQWN8m4j0RAa19Zz8Sndpke/Rh6n9
         uf7z8L7fC2NgMlioRgSfs/78sHpJBjUqgBajwR1JDFXP1bfDbSl5qGEMbtT4cLBq2Lkt
         90Tqa6Oadb2agJvehPwbyGu1EmgwOZ4s5gnAAUQrczA0CsZq5A7ku/Rt7FHSP3M1Dfmy
         Zsqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9KuDiR0/afvizS4hj5Loo8cboTWM7MdUw0YpF4dlIWg=;
        b=jtHrJa8UB/T3n9VpZ43erZ8hXujYQJeFdTaTs6g28L8IRsY4iH+FbgfYFc4XfpdwFP
         skbaEnlTt232drwA5F7IUr1wLMLsiM1V2mLOHBp8oYhIPmfBfnPTc+2qXt4ym13yTGSR
         BXMsd8+8GPzsKumgsWLh0BVLXYdnEvzk3Qt0+E6l9gvWh57ocIqfYRl8A5Iv0X4ch9mO
         2HfNaOLEv08UcJ8MzqbTKhnmu7ALAVJX7doxcVpAkmjxBTQftwjA+05CXrGIWTqlc/Au
         2RiG7ASfmgHQbBYkT6C1b5RU9AqOcTUABZK9aNxwgB3ripB0vq1w4J2rH/E8U++f1J1c
         X8qw==
X-Gm-Message-State: AOAM531lT1dMeUxvWo/4y8e8sRqNm75HLxcwDESxP8/4KNI4dpoSt5U1
        1GeH+MUUyD1PmZmFNUCIUCs=
X-Google-Smtp-Source: ABdhPJxLceusjx4BsvK+pZ5JF8d1cmFw4KqrcEPZXtIyorMmdM28WNXXW5VjmcskR1gznU91dg5x+w==
X-Received: by 2002:a17:90a:8804:: with SMTP id s4mr6227626pjn.200.1623443922151;
        Fri, 11 Jun 2021 13:38:42 -0700 (PDT)
Received: from localhost (g151.115-65-219.ppp.wakwak.ne.jp. [115.65.219.151])
        by smtp.gmail.com with ESMTPSA id i128sm5690754pfc.142.2021.06.11.13.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:38:41 -0700 (PDT)
Date:   Sat, 12 Jun 2021 05:38:39 +0900
From:   Stafford Horne <shorne@gmail.com>
To:     trix@redhat.com
Cc:     robh+dt@kernel.org, tsbogend@alpha.franken.de, jic23@kernel.org,
        lars@metafoo.de, tomas.winkler@intel.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, nbd@nbd.name,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com, apw@canonical.com, joe@perches.com,
        dwaipayanray1@gmail.com, lukas.bulwahn@gmail.com,
        chenhuacai@kernel.org, jiaxun.yang@flygoat.com,
        zhangqing@loongson.cn, jbhayana@google.com, sean.wang@mediatek.com,
        shayne.chen@mediatek.com, Soul.Huang@mediatek.com,
        gsomlo@gmail.com, pczarnecki@internships.antmicro.com,
        mholenko@antmicro.com, davidgow@google.com,
        devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH 3/7] drivers/soc/litex: fix spelling of SPDX tag
Message-ID: <YMPJPO9S9wiM5B23@antec>
References: <20210610214438.3161140-1-trix@redhat.com>
 <20210610214438.3161140-5-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610214438.3161140-5-trix@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 02:44:34PM -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> checkpatch looks for SPDX-License-Identifier.
> So change the '_' to '-'
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Acked-by: Stafford Horne <shorne@gmail.com>

> ---
>  drivers/soc/litex/Kconfig  | 2 +-
>  drivers/soc/litex/Makefile | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/soc/litex/Kconfig b/drivers/soc/litex/Kconfig
> index e7011d665b151..c03b1f816cc08 100644
> --- a/drivers/soc/litex/Kconfig
> +++ b/drivers/soc/litex/Kconfig
> @@ -1,4 +1,4 @@
> -# SPDX-License_Identifier: GPL-2.0
> +# SPDX-License-Identifier: GPL-2.0
>  
>  menu "Enable LiteX SoC Builder specific drivers"
>  
> diff --git a/drivers/soc/litex/Makefile b/drivers/soc/litex/Makefile
> index 98ff7325b1c07..aeae1f4165a70 100644
> --- a/drivers/soc/litex/Makefile
> +++ b/drivers/soc/litex/Makefile
> @@ -1,3 +1,3 @@
> -# SPDX-License_Identifier: GPL-2.0
> +# SPDX-License-Identifier: GPL-2.0
>  
>  obj-$(CONFIG_LITEX_SOC_CONTROLLER)	+= litex_soc_ctrl.o
> -- 
> 2.26.3
> 
