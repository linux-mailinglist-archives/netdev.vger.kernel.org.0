Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368DF6056FE
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 07:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiJTFvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 01:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJTFvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 01:51:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2E918DAB8
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 22:51:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 680D6619EE
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 05:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350EFC433D7;
        Thu, 20 Oct 2022 05:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666245109;
        bh=zd9xadPbp72GBAWQHBKggABktssgxDFBtsckmeaDIBQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HaaBSJIzEAQmp8Dti0WQ7zDmt1H4ER5602KUWU5T159ccqgtOIjlfPiRrFH/0mhCB
         60JmyzqvCNihePuuB5OFMuP6DZX2XffFkvni8N1325wyht0QK4WJqHpuHtyIFwEMim
         ytDZaQh2zuDvG8TxcThJeFE6dffSfo08HcNCC7IRz66nCbXrQ9TZ7H9RllNz5tGMTD
         NmlkmLlIi15JWgKcHe6TX6fdhOXpbLXaEGf7YtbUm7IIu9InLdEW17RgPK6M0pMo7u
         mNzCVwIrBVVldb/Pmv2WYv3DurOWSW0alGBqv5v0sGeWBqsgY1p+7ZT89Vbf1V0gBD
         3g0Zf7kjxH1ZA==
Date:   Thu, 20 Oct 2022 08:51:46 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com
Subject: Re: [PATCH net] MAINTAINERS: add keyword match on PTP
Message-ID: <Y1Dh8kFNicjxzNHn@unreal>
References: <20221020021913.1203867-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221020021913.1203867-1-kuba@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 07:19:13PM -0700, Jakub Kicinski wrote:
> Most of PTP drivers live under ethernet and we have to keep
> telling people to CC the PTP maintainers. Let's try a keyword
> match, we can refine as we go if it causes false positives.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5c6ce094e55e..ba8ed738494f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16673,6 +16673,7 @@ F:	Documentation/driver-api/ptp.rst
>  F:	drivers/net/phy/dp83640*
>  F:	drivers/ptp/*
>  F:	include/linux/ptp_cl*
> +K:	(?:\b|_)ptp(?:\b|_)

I tried it with grep (maybe it is wrong) and it finds only files with
underscores.

➜  kernel git:(m/xfrm-latest) tree | grep -E "(?:\b|_)ptp(?:\b|_)"
│   │   │   │   │   ├── ice_ptp_consts.h
│   │   │   │   │   ├── ice_ptp_hw.c
│   │   │   │   │   ├── ice_ptp_hw.h

And this is as it is written in MAINTAINERS without "_".

➜  kernel git:(m/xfrm-latest) tree | grep -E "\bptp\b"
│   │       ├── sysfs-ptp
│   │   │   │   ├── intel,ixp46x-ptp-timer.yaml
│   │   │   ├── ptp
│   │   │   │   ├── brcm,ptp-dte.txt
│   │   │   │   ├── ptp-idt82p33.yaml
│   │   │   │   ├── ptp-idtcm.yaml
│   │   │   │   ├── ptp-ines.txt
│   │   │   │   ├── ptp-qoriq.txt
│   │   ├── ptp.rst
│   │   │   │   ├── ptp.c
│   │   │   │   ├── ptp.h
│   │   │   │       └── xgbe-ptp.c
│   │   │   │   │   ├── dpaa2-ptp.c
│   │   │   │   │   ├── dpaa2-ptp.h
│   │   │   │   │   ├── ptp.c
│   │   │   │   │   │   ├── ptp.c
│   │   │   │   │   │   ├── ptp.h
│   │   │   │   │       │   ├── ptp.c
│   │   │   │   │       │   ├── ptp.h
│   │   │   │   ├── ptp.c
│   │   │   │   ├── ptp.h
│   │   │   │   │   ├── ptp.c
│   │   │   │   │   ├── ptp.h
│   │   │   ├── bcm-phy-ptp.c

Should I try it differently?

Thanks

>  
>  PTP VIRTUAL CLOCK SUPPORT
>  M:	Yangbo Lu <yangbo.lu@nxp.com>
> -- 
> 2.37.3
> 
