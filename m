Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997D4574A32
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 12:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238154AbiGNKMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 06:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237674AbiGNKMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 06:12:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5958E51A29
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657793558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vX+1vincHLczEvi40DdMkK3fKVGRof2YnPkJlU910Qw=;
        b=YbSfrdI8gN9q219TBT366EasR3aXJh5uEeD/F/M1KT2qMtBX3ol3akVMVOxGsoQjCnVjaY
        1CY10opKt06Irm2W/dmnXMioiZFC1I7wbmWp78f9FF/o5/TRmNrCV5+eHoXUChJom260JC
        rEqjGy59Ki/YyrLlmrXeC/r2BYvV3q0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-OjhTgkCcN2qU-wzvAmMJ7A-1; Thu, 14 Jul 2022 06:12:37 -0400
X-MC-Unique: OjhTgkCcN2qU-wzvAmMJ7A-1
Received: by mail-wm1-f70.google.com with SMTP id z11-20020a05600c0a0b00b003a043991610so545356wmp.8
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:12:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vX+1vincHLczEvi40DdMkK3fKVGRof2YnPkJlU910Qw=;
        b=AnREC46ayA14XxfDMh2HDunxjRWh9WboxlgZ0pDFSkiIDgmH5gnTX7RxYZznjNcD5P
         5kkrGBqzCeicLQu5zd83TjobS/HYRUu0eQk2XhxlzG4AnkUElkfIZY8nFz/VYIGfJc/S
         GSTp34f9MIAP5WolkjV6iGvckP9rhhHtmwRloL5VZLZFRcrQ/qyDbioEJmh0wZ6bObv2
         O6Gdo/BEVHD97M0mkd7bTeZZfwyVlLRLMiEpHc8oICavMu0PD3F21lK/3L/kwDobnhJ9
         YkIsbcCG6EDKZvCFJ82K4wl96JfQB4dCwv7eP1w5qe4OVo27mpj5TdB/y5M5T2CLDdJk
         bfyg==
X-Gm-Message-State: AJIora/codIyfnXGcdOK85otoVtYe2AxWbdzk4dzMH1anAMtXcsiMmBg
        O5y56b3bJHeR7fFxliD6eHkfXd+41wudRRF2EcS+eyieGwIoAMDlsFfIOPVMl10TZP66VVrU+2Z
        nwpoE4GtdMkIonnE1
X-Received: by 2002:adf:df89:0:b0:21d:7f20:7535 with SMTP id z9-20020adfdf89000000b0021d7f207535mr7694506wrl.714.1657793556226;
        Thu, 14 Jul 2022 03:12:36 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s5Ay9m3TGyddNecaSFCH1dv2eH/EJJeiQKALcplGL0A3r8vOuCAHhIFVGKFHWFiAnC1a3UzQ==
X-Received: by 2002:adf:df89:0:b0:21d:7f20:7535 with SMTP id z9-20020adfdf89000000b0021d7f207535mr7694488wrl.714.1657793555976;
        Thu, 14 Jul 2022 03:12:35 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id i3-20020a1c5403000000b003a2e1883a27sm5917529wmb.18.2022.07.14.03.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 03:12:35 -0700 (PDT)
Message-ID: <267f466722ed63a2ba9abd74c31a9fab57965e4a.camel@redhat.com>
Subject: Re: [PATCH 2/2] net: stmmac: remove duplicate dma queue channel
 macros
From:   Paolo Abeni <pabeni@redhat.com>
To:     Junxiao Chang <junxiao.chang@intel.com>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        netdev@vger.kernel.org
Date:   Thu, 14 Jul 2022 12:12:34 +0200
In-Reply-To: <20220713084728.1311465-2-junxiao.chang@intel.com>
References: <20220713084728.1311465-1-junxiao.chang@intel.com>
         <20220713084728.1311465-2-junxiao.chang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-07-13 at 16:47 +0800, Junxiao Chang wrote:
> It doesn't need extra macros for queue 0 & 4. Same macro could
> be used for all 8 queues.
> 
> Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>

This looks like a net-next cleanup for the previous patch, which
instead looks like a proper -net candidate. Would you mind re-posting
the two patch separatelly, waiting for the fix to land into net-next
before posting the cleanup?

> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac4.h      |  4 +---
>  drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 11 ++++-------
>  2 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
> index 462ca7ed095a2..a7b725a7519bb 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
> @@ -330,9 +330,7 @@ enum power_event {
>  
>  #define MTL_RXQ_DMA_MAP0		0x00000c30 /* queue 0 to 3 */
>  #define MTL_RXQ_DMA_MAP1		0x00000c34 /* queue 4 to 7 */
> -#define MTL_RXQ_DMA_Q04MDMACH_MASK	GENMASK(3, 0)
> -#define MTL_RXQ_DMA_Q04MDMACH(x)	((x) << 0)
> -#define MTL_RXQ_DMA_QXMDMACH_MASK(x)	GENMASK(11 + (8 * ((x) - 1)), 8 * (x))
> +#define MTL_RXQ_DMA_QXMDMACH_MASK(x)	GENMASK(3 + (8 * (x)), 8 * (x))
>  #define MTL_RXQ_DMA_QXMDMACH(chan, q)	((chan) << (8 * (q)))

if you here use ((x) & 0x3) instead of (x) and ((q) & 0x3) instead of
(q), you can avoid the if statement below. 
>  
cheers,

Paolo

