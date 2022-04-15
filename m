Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D705024D5
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 07:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346313AbiDOFvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 01:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiDOFvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 01:51:23 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180D04160A;
        Thu, 14 Apr 2022 22:48:57 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 2so6907593pjw.2;
        Thu, 14 Apr 2022 22:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EkZ6B5iLKVXv5Srcu76r3A62V/ZZt/J9R/FB5UABxPU=;
        b=Map6MfGcaRDiOY9nxu5tNcDFugf5a+zp33X0uSP/NLKBd5B8mizst2Hx0ZW+4ZPq4V
         oo55U7QNalBlhk7mZNXTURgkaAlY/AGFajJj9m03US6+UpAAI21/MdvNQghCawIOpYm4
         gMALgH16hFf9OBKy0EKnWcnqc/EzsO56OWtmOeiYJ1YiDJHlis46fH5FDMRZvIJSyCId
         ZGauzdwIzkZuOy8tsaxtgheiDRGWB+rm7D8jo4G7C9tqCLSqlyZE35sF9yWlrNyTxTl/
         tA2Qu3AYGGbAsSV5Ix9No36EgAyyHMcJ4TP05/4ZRuF1IJ34oIBxa2jIf7VK7ChuKjeh
         JpnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EkZ6B5iLKVXv5Srcu76r3A62V/ZZt/J9R/FB5UABxPU=;
        b=nShU1YH2EBAFHLXG07MYgmEAxOMSInxR9OySQXd7B38PpjerH82tgQnnB5GUC9VdbI
         mlUIgHVEg6ytKEajD1EuvMP4kMOTcjiP4xOlf0yKUSiYEbw1F8NuU3OUntNXNTQAxG3U
         ZRWRdk4qf2itxOJMNIv7GMtIQuXwPtbyA3HuJqqTfDo1NtNArtA/BbPQw9cIG9pbkSTE
         K1zIF/Vi+J5WR9CQ0er4lSf7T0erh10MlxI9peuhRM5iUWMM4byNfPFMtdA9VlidycLs
         /5PhjdkD/yR93uVFf7Hw+FQTrzvuMmcR7GFkJoKC+09HmLRpseGfmI3jliprFThiqA0S
         eZFA==
X-Gm-Message-State: AOAM531kvRtHJy4dDvBPISgAr6iqzbuZ50HrEk5AjyGc4zkaIN52eYZu
        FzLgNAB9iXLGaKD3MbnVJJo=
X-Google-Smtp-Source: ABdhPJzq5U/5RA7OgRGopMUXYjszuTAGLW4wdDrxEq9PCpFTXojnP+lSjb6+gqd3ElvWgE/IfSx3jQ==
X-Received: by 2002:a17:90a:c003:b0:1cb:65a2:81ab with SMTP id p3-20020a17090ac00300b001cb65a281abmr2428373pjt.161.1650001736529;
        Thu, 14 Apr 2022 22:48:56 -0700 (PDT)
Received: from d3 ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id n24-20020aa79058000000b0050612d0fe01sm1560528pfo.2.2022.04.14.22.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 22:48:55 -0700 (PDT)
Date:   Fri, 15 Apr 2022 14:48:50 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Yihao Han <hanyihao@vivo.com>
Cc:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
Subject: Re: [PATCH] net: qlogic: qlcnic: simplify if-if to if-else
Message-ID: <YlkHQkZ33rkzAwhS@d3>
References: <20220414031111.76862-1-hanyihao@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414031111.76862-1-hanyihao@vivo.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-13 20:11 -0700, Yihao Han wrote:
> Replace `if (!pause->autoneg)` with `else` for simplification
> and add curly brackets according to the kernel coding style:
> 
> "Do not unnecessarily use braces where a single statement will do."
> 
> ...
> 
> "This does not apply if only one branch of a conditional statement is
> a single statement; in the latter case use braces in both branches"
> 
> Please refer to:
> https://www.kernel.org/doc/html/v5.17-rc8/process/coding-style.html

Seems the part of the log about curly brackets doesn't correspond with
the actual changes.

> 
> Signed-off-by: Yihao Han <hanyihao@vivo.com>
> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
> index bd0607680329..e3842eaf1532 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
> @@ -3752,7 +3752,7 @@ int qlcnic_83xx_set_pauseparam(struct qlcnic_adapter *adapter,
>  	if (ahw->port_type == QLCNIC_GBE) {
>  		if (pause->autoneg)
>  			ahw->port_config |= QLC_83XX_ENABLE_AUTONEG;
> -		if (!pause->autoneg)
> +		else
>  			ahw->port_config &= ~QLC_83XX_ENABLE_AUTONEG;
>  	} else if ((ahw->port_type == QLCNIC_XGBE) && (pause->autoneg)) {
>  		return -EOPNOTSUPP;
> -- 
> 2.17.1
> 
