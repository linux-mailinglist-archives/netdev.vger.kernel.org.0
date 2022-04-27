Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C77512119
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243659AbiD0RAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 13:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243570AbiD0RAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 13:00:38 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9033638B;
        Wed, 27 Apr 2022 09:57:25 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id i27so4612816ejd.9;
        Wed, 27 Apr 2022 09:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J7iWWU5DbOIvLxFewMmC/eOeW4lAauh4Mm/EuelB7bk=;
        b=ck/k3U/nN3UksK/sqlJmCJOICVnTW841IWX6OO4SVKyNLZeMR0BfGBOs9Bir/e1N3j
         lJKf60yq8KMj0bAYh8u03VNb7mSWy+90+l8MyJlz5M6RpcX5ws3tEfo6suyuCXvsYXlS
         KSuTf3+jJaG7vVXmT538qCa6n7i4b4NNmBJ7YX+6EesFMO0iHA+4+ly9ioBylTiphgld
         2yuFVvlqjr/7Ai2I9UPSX7btrJaBsldRRU5bNk9wVe4E/v6Xk0B3ayvGXEebJeQPL3jj
         BV657zUm1VIO+mxoFquonU5ZxFIlsOjlWosM9G10QoFgZGTtg1rZ0e2PJRpqAsO6FlsR
         P7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J7iWWU5DbOIvLxFewMmC/eOeW4lAauh4Mm/EuelB7bk=;
        b=iXX2wFrH9yC18OX+uMUzDeRnWQv51EamJb/fvIfZOECL+E7TluDJB90TLyDix4W2yP
         OQRrQtBcnequXeTDQ3f112iKAJb8cOylM8ynpDtVj40HscNAEIU14Zv/DMKviAino9VF
         vN6f3LhPH9FuJp0aRA4etyZ9YbuJhVwK4A7Ar/K4awdJVeVJgTioBw1ntvX3ar8Mj+Q6
         B5L2O6fWx898GVwDMW6g6x/cCdvq2TuXMwEKs62CtQMaA0eetiZtbD8SQw7JWB9jcIkL
         iorj4f0HrOOnu1c+dUHU2m0wUF3eYLjKTX6eO58JzBy9pLKUuzBYH0hoka13r2v1fAaf
         RWSw==
X-Gm-Message-State: AOAM5325ltJvsBWeruhrVKskjZr9hki/PrOz16HFLI6TxLZm/oQjedwh
        L9x90gLHxXs4R7L6p32H4MY=
X-Google-Smtp-Source: ABdhPJzDLUCAaxJ8C6EauPCu3/glTPM0yGsfrgt5yrS467fot8UOF5bZziTQpX0W9ometbayK6kB6g==
X-Received: by 2002:a17:907:3f1a:b0:6f3:8de5:aee5 with SMTP id hq26-20020a1709073f1a00b006f38de5aee5mr16782005ejc.474.1651078644370;
        Wed, 27 Apr 2022 09:57:24 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id a94-20020a509ee7000000b00425e7035c4bsm5683584edf.61.2022.04.27.09.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:57:23 -0700 (PDT)
Date:   Wed, 27 Apr 2022 19:57:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [RFC patch net-next 3/3] net: dsa: ksz: moved ksz9477 port
 mirror to ksz_common.c
Message-ID: <20220427165722.vwruo5q63stahkby@skbuf>
References: <20220427162343.18092-1-arun.ramadoss@microchip.com>
 <20220427162343.18092-4-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427162343.18092-4-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 09:53:43PM +0530, Arun Ramadoss wrote:
> Moved the port_mirror_add and port_mirror_del function from ksz9477 to

Present tense (move)

> ksz_common, to make it generic function which can be used by KSZ9477
> based switch.

Presumably you mean "which can be used by other switches" (it can
already be used by ksz9477, so that can't be the argument for moving it)

> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Looks good, except for the spelling mistakes in the code that is being
moved (introduced in patch 1), which I expect you will update in the new
code as well.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> diff --git a/drivers/net/dsa/microchip/ksz_reg.h b/drivers/net/dsa/microchip/ksz_reg.h
> new file mode 100644
> index 000000000000..ccd4a6568e34
> --- /dev/null
> +++ b/drivers/net/dsa/microchip/ksz_reg.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Microchip KSZ Switch register definitions
> + *
> + * Copyright (C) 2017-2022 Microchip Technology Inc.
> + */
> +
> +#ifndef __KSZ_REGS_H
> +#define __KSZ_REGS_H
> +
> +#define REG_SW_MRI_CTRL_0		0x0370
> +
> +#define SW_IGMP_SNOOP			BIT(6)
> +#define SW_IPV6_MLD_OPTION		BIT(3)
> +#define SW_IPV6_MLD_SNOOP		BIT(2)
> +#define SW_MIRROR_RX_TX			BIT(0)
> +
> +/* 8 - Classification and Policing */
> +#define REG_PORT_MRI_MIRROR_CTRL	0x0800
> +
> +#define PORT_MIRROR_RX			BIT(6)
> +#define PORT_MIRROR_TX			BIT(5)
> +#define PORT_MIRROR_SNIFFER		BIT(1)
> +
> +#define P_MIRROR_CTRL			REG_PORT_MRI_MIRROR_CTRL
> +
> +#define S_MIRROR_CTRL			REG_SW_MRI_CTRL_0

Small comment: if P_MIRROR_CTRL and S_MIRROR_CTRL are expected to be at
the same register offset for all switch families, why is there a macro
behind a macro for their addresses?

> +
> +#endif
> -- 
> 2.33.0
> 
