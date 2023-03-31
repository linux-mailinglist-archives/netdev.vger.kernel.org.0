Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52246D29C9
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 23:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjCaVIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 17:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbjCaVIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 17:08:01 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8351D850
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:07:50 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q206so14204983pgq.9
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680296870; x=1682888870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b3HBmEpRE2H5FpBYUp+3+9Ba8fJkZe2jGi9zQ9TL+bQ=;
        b=W789RceUy8yw1kmhSKR4L5nPOIoAT3j88Yf2vZLzGDSOKDFs8+WB3FKKBLvSNDsvpg
         5yBxh6cHNeNV4d9Co77o6M93ilUKffiHQQA5DGe5KaDB4ab/QkQON6uY1MwWcwJT49Lb
         SttW+5/pBvEal8cv5/iMRqbzAn6Os/yaxNIcdGhouK78bicF3ACG8XcMZd9ekA9V6ugt
         a+RfhCadtDECM9RUZigUSV0QLHClHF7DTypl5S/WCPa5DLOimseRYoBaTml98jUztxsR
         q/du97bxRyu9X4dLA3P2gUMVh/tdsGRxG4cW+Ajr8EJa8NoGbaI4XOoMNSLmOMyAlh82
         1/cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680296870; x=1682888870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b3HBmEpRE2H5FpBYUp+3+9Ba8fJkZe2jGi9zQ9TL+bQ=;
        b=o+tHStR1JlWT+igySbWSDSkMsbCWh3RkThk0tdtSdOnMRPg92cxd787qS1lccIAZxY
         KVVHRPpiXEe5ZfVGEFmEaI0T0f/cJ5xUYIjC+OnEqMLqWOhzpTBqE8FHe3otkfvCPIPB
         HRwAzQc7FZzco5MDgykHsnjcbCYQJKrzMftWY5zEAAsrg0bSyGMVOpYogipOueet4KX8
         QiToKT3NiMNaQ9amRkQJptlASw94/jhLyQjXvNs15Ei3IzDo8swwv3a8y1bjl/kMy0bv
         K6//TwwsxhKz2lvJsKP/57U8kKooYpBhpC6TdK3f9YlTX5lRHgg8t+0EhsBR3RP9RBhv
         JcUA==
X-Gm-Message-State: AAQBX9cb9PdSQXqrVjXMA/U+6+2DGDyvexEo/fpdalQvX2CeEnhRytwk
        P2Au8WbfHj1uhspRnkjYW9q6dbypHHpFhWGDdIE=
X-Google-Smtp-Source: AKy350anRsfCLJkK+6go7iAS3sjtY50Uy4g6rt48MvbV6wCnxfGDtJ+/VnYLuDaAHD/e9L+vh5drPrTUww+Yab2/Nno=
X-Received: by 2002:a63:582:0:b0:513:a9b2:9612 with SMTP id
 124-20020a630582000000b00513a9b29612mr1935357pgf.6.1680296870327; Fri, 31 Mar
 2023 14:07:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230331205759.92309-1-shenwei.wang@nxp.com> <20230331205759.92309-2-shenwei.wang@nxp.com>
In-Reply-To: <20230331205759.92309-2-shenwei.wang@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 31 Mar 2023 18:07:38 -0300
Message-ID: <CAOMZO5BwVWCMyiFG+HbjxeSvo+8x+1JtSmLmLmXWrWrsg6Cc7A@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] net: stmmac: dwmac-imx: use platform specific
 reset for imx93 SoCs
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shenwei,

On Fri, Mar 31, 2023 at 5:58=E2=80=AFPM Shenwei Wang <shenwei.wang@nxp.com>=
 wrote:
>
> The patch addresses an issue with the reset logic on the i.MX93 SoC, whic=
h
> requires configuration of the correct interface speed under RMII mode to
> complete the reset. The patch implements a fix_soc_reset function and use=
s
> it specifically for the i.MX93 SoCs.
>
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> ---
>  .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 29 ++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/ne=
t/ethernet/stmicro/stmmac/dwmac-imx.c
> index ac8580f501e2..3dfd13840535 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
> @@ -19,9 +19,9 @@
>  #include <linux/pm_wakeirq.h>
>  #include <linux/regmap.h>
>  #include <linux/slab.h>
> -#include <linux/stmmac.h>
>
>  #include "stmmac_platform.h"
> +#include "common.h"

These changes in the header seem to be unrelated.

Apart from that:

Reviewed-by: Fabio Estevam <festevam@gmail.com>
