Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BA36CB03D
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 23:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbjC0VBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 17:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjC0VBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 17:01:31 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7641A211B
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 14:01:30 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso13158986pjb.0
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 14:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679950890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I47QgG80c18NHe2QXGtpe6IXSCOJbQsxdw+n6WwyTPc=;
        b=qEMxtwtl57eh3jwNaDlneulqEJP59uEeZdGMNUBJvreTP9e94ESJcY8Jo7vY9WHvSQ
         ahMzjIJhOtkCwnV0g5A4O/aNEWAnicKi2dfHbEnZ5lShR7llIZ49aK2KwBA45Fh44Dbj
         5fK7WxfNzUdfG5Ci0+Y9QADuCr9zGKlPIwJVis+6X4ICttn9DcgH5dNw1Wj4LRRgaI4a
         pPeeDS2OmegcbFJPxOHZVp7sE5P+x0vEhMGlAin26j6QA3/4vTHTHdck9n4FHyJ0WGrD
         FTG4+dOiu8nnONYgQEOPIjtX5dFKN1NadCgxyamiPKEx5Y4eRsQpVnp5O+mKC3uPdnT4
         I+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679950890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I47QgG80c18NHe2QXGtpe6IXSCOJbQsxdw+n6WwyTPc=;
        b=V6/aReUBeN0ORK47NUaRCqdvjLkC1dq0nUNcgmUmNrLBNot5VijyGV43owKpceQBcy
         HlBctnm922L3Ou1YRkUVuE5xlN0wnK+hrZBDsaDAk63pnHxFmcF5n6hoZLG0a1//wb6k
         bV7xwv/6j4xCIhwqYqw9Qz1NB5hyOcvpVv3Xy1odKdoSaV/i7hI4z3W13rlXgPEAR7Xj
         JHzUnnkh9xl3fBs9H+F06xSmMgjdNMKdgh781lJBQp2WteftMfHiuNo/02dewXiMZAU8
         xnh+bu4O4TFhw9DFRvim44fqGhAqTBmJE1NviYoaqCTvEB6wNa18AfFou5h1PMLunA5S
         asyQ==
X-Gm-Message-State: AAQBX9cdvsjn4QKG5eLIsVviLeORGXnbMUFQ+tXj9foyyMfUDuQiSX8Z
        yJumqVcbKY6YMQ5pxHFDzteSGg==
X-Google-Smtp-Source: AKy350aHdL7wM6XPVYpmTCr5+ubBfWHZ0yH2Ao164vY7yTBP8KHuhKBry5rT2/49WOb0LzeOxmuENA==
X-Received: by 2002:a17:903:32ca:b0:1a0:53f3:3761 with SMTP id i10-20020a17090332ca00b001a053f33761mr13617248plr.15.1679950889923;
        Mon, 27 Mar 2023 14:01:29 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:ad52:968f:ad4a:52d2])
        by smtp.gmail.com with ESMTPSA id y15-20020a1709027c8f00b001a21fceff33sm6267741pll.48.2023.03.27.14.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 14:01:29 -0700 (PDT)
Date:   Mon, 27 Mar 2023 15:01:26 -0600
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 3/5] soc: ti: pruss: Add pruss_cfg_read()/update() API
Message-ID: <20230327210126.GC3158115@p14s>
References: <20230323062451.2925996-1-danishanwar@ti.com>
 <20230323062451.2925996-4-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323062451.2925996-4-danishanwar@ti.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 11:54:49AM +0530, MD Danish Anwar wrote:
> From: Suman Anna <s-anna@ti.com>
> 
> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
> the PRUSS platform driver to read and program respectively a register
> within the PRUSS CFG sub-module represented by a syscon driver.
> 
> These APIs are internal to PRUSS driver. Various useful registers
> and macros for certain register bit-fields and their values have also
> been added.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> ---
>  drivers/soc/ti/pruss.c |   1 +
>  drivers/soc/ti/pruss.h | 112 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 113 insertions(+)
>  create mode 100644 drivers/soc/ti/pruss.h
>

This patch doesn't compile without warnings.

> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> index 126b672b9b30..2fa7df667592 100644
> --- a/drivers/soc/ti/pruss.c
> +++ b/drivers/soc/ti/pruss.c
> @@ -21,6 +21,7 @@
>  #include <linux/regmap.h>
>  #include <linux/remoteproc.h>
>  #include <linux/slab.h>
> +#include "pruss.h"
>  
>  /**
>   * struct pruss_private_data - PRUSS driver private data
> diff --git a/drivers/soc/ti/pruss.h b/drivers/soc/ti/pruss.h
> new file mode 100644
> index 000000000000..4626d5f6b874
> --- /dev/null
> +++ b/drivers/soc/ti/pruss.h
> @@ -0,0 +1,112 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * PRU-ICSS Subsystem user interfaces
> + *
> + * Copyright (C) 2015-2023 Texas Instruments Incorporated - http://www.ti.com
> + *	MD Danish Anwar <danishanwar@ti.com>
> + */
> +
> +#ifndef _SOC_TI_PRUSS_H_
> +#define _SOC_TI_PRUSS_H_
> +
> +#include <linux/bits.h>
> +#include <linux/regmap.h>
> +
> +/*
> + * PRU_ICSS_CFG registers
> + * SYSCFG, ISRP, ISP, IESP, IECP, SCRP applicable on AMxxxx devices only
> + */
> +#define PRUSS_CFG_REVID         0x00
> +#define PRUSS_CFG_SYSCFG        0x04
> +#define PRUSS_CFG_GPCFG(x)      (0x08 + (x) * 4)
> +#define PRUSS_CFG_CGR           0x10
> +#define PRUSS_CFG_ISRP          0x14
> +#define PRUSS_CFG_ISP           0x18
> +#define PRUSS_CFG_IESP          0x1C
> +#define PRUSS_CFG_IECP          0x20
> +#define PRUSS_CFG_SCRP          0x24
> +#define PRUSS_CFG_PMAO          0x28
> +#define PRUSS_CFG_MII_RT        0x2C
> +#define PRUSS_CFG_IEPCLK        0x30
> +#define PRUSS_CFG_SPP           0x34
> +#define PRUSS_CFG_PIN_MX        0x40
> +
> +/* PRUSS_GPCFG register bits */
> +#define PRUSS_GPCFG_PRU_GPO_SH_SEL              BIT(25)
> +
> +#define PRUSS_GPCFG_PRU_DIV1_SHIFT              20
> +#define PRUSS_GPCFG_PRU_DIV1_MASK               GENMASK(24, 20)
> +
> +#define PRUSS_GPCFG_PRU_DIV0_SHIFT              15
> +#define PRUSS_GPCFG_PRU_DIV0_MASK               GENMASK(15, 19)
> +
> +#define PRUSS_GPCFG_PRU_GPO_MODE                BIT(14)
> +#define PRUSS_GPCFG_PRU_GPO_MODE_DIRECT         0
> +#define PRUSS_GPCFG_PRU_GPO_MODE_SERIAL         BIT(14)
> +
> +#define PRUSS_GPCFG_PRU_GPI_SB                  BIT(13)
> +
> +#define PRUSS_GPCFG_PRU_GPI_DIV1_SHIFT          8
> +#define PRUSS_GPCFG_PRU_GPI_DIV1_MASK           GENMASK(12, 8)
> +
> +#define PRUSS_GPCFG_PRU_GPI_DIV0_SHIFT          3
> +#define PRUSS_GPCFG_PRU_GPI_DIV0_MASK           GENMASK(7, 3)
> +
> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE_POSITIVE   0
> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE_NEGATIVE   BIT(2)
> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE            BIT(2)
> +
> +#define PRUSS_GPCFG_PRU_GPI_MODE_MASK           GENMASK(1, 0)
> +#define PRUSS_GPCFG_PRU_GPI_MODE_SHIFT          0
> +
> +#define PRUSS_GPCFG_PRU_MUX_SEL_SHIFT           26
> +#define PRUSS_GPCFG_PRU_MUX_SEL_MASK            GENMASK(29, 26)
> +
> +/* PRUSS_MII_RT register bits */
> +#define PRUSS_MII_RT_EVENT_EN                   BIT(0)
> +
> +/* PRUSS_SPP register bits */
> +#define PRUSS_SPP_XFER_SHIFT_EN                 BIT(1)
> +#define PRUSS_SPP_PRU1_PAD_HP_EN                BIT(0)
> +#define PRUSS_SPP_RTU_XFR_SHIFT_EN              BIT(3)
> +
> +/**
> + * pruss_cfg_read() - read a PRUSS CFG sub-module register
> + * @pruss: the pruss instance handle
> + * @reg: register offset within the CFG sub-module
> + * @val: pointer to return the value in
> + *
> + * Reads a given register within the PRUSS CFG sub-module and
> + * returns it through the passed-in @val pointer
> + *
> + * Return: 0 on success, or an error code otherwise
> + */
> +static int pruss_cfg_read(struct pruss *pruss, unsigned int reg, unsigned int *val)
> +{
> +	if (IS_ERR_OR_NULL(pruss))
> +		return -EINVAL;
> +
> +	return regmap_read(pruss->cfg_regmap, reg, val);
> +}
> +
> +/**
> + * pruss_cfg_update() - configure a PRUSS CFG sub-module register
> + * @pruss: the pruss instance handle
> + * @reg: register offset within the CFG sub-module
> + * @mask: bit mask to use for programming the @val
> + * @val: value to write
> + *
> + * Programs a given register within the PRUSS CFG sub-module
> + *
> + * Return: 0 on success, or an error code otherwise
> + */
> +static int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
> +			    unsigned int mask, unsigned int val)
> +{
> +	if (IS_ERR_OR_NULL(pruss))
> +		return -EINVAL;
> +
> +	return regmap_update_bits(pruss->cfg_regmap, reg, mask, val);
> +}
> +
> +#endif  /* _SOC_TI_PRUSS_H_ */
> -- 
> 2.25.1
> 
