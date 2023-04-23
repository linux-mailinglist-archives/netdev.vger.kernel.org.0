Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D3E6EC128
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 18:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjDWQsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 12:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjDWQsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 12:48:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB79310F0;
        Sun, 23 Apr 2023 09:48:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F5C160C57;
        Sun, 23 Apr 2023 16:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D43C433EF;
        Sun, 23 Apr 2023 16:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682268513;
        bh=UxlIVX22bNdrwnRYKpdbpf7jgyKAxR9M2aHiN+n4ULw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YVKOGEt6PLn3V9UWAyPRMvMcT+55T8SaUsEzRe5D7+n4uCxQknH/8zaqjmVR+9egi
         9wLxuOWS7lG+ZPWabxDU64JsLlP1xpBr3c25bwRtqlD2iho1BxMORxCB5TbUOWLeog
         +Dt7KRhFEHjyVCP27aoIBRil4LcHvDEHsDwtxvshWbiHAvN0G9kfbV3xi18h+A8icI
         Of9Imza4O5VIzJLyvP3ovqBo2y+z0BIxOsm38ABi7wJT7hG7JnzDFE+GHlqovETPgn
         CAzhAwpDRbE9WoFpmm+xvxz7V2CBepHO/fR0QeW6jQo/MqngCrz8D4E0X6QvEmDeyO
         tIn/hDEmwBypA==
Date:   Sun, 23 Apr 2023 19:48:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com, sgoutham@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Subject: Re: [net PATCH 3/9] octeontx2-af: mcs: Config parser to skip 8B
 header
Message-ID: <20230423164829.GE4782@unreal>
References: <20230423095454.21049-1-gakula@marvell.com>
 <20230423095454.21049-4-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423095454.21049-4-gakula@marvell.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 03:24:48PM +0530, Geetha sowjanya wrote:
> When ptp timestamp is enabled in RPM, RPM will append 8B
> timestamp header for all RX traffic. MCS need to skip these
> 8 bytes header while parsing the packet header, so that
> correct tcam key is created for lookup. 
> This patch fixes the mcs parser configuration to skip this 
> 8B header for ptp packets.
> 
> Fixes: ca7f49ff8846 ("octeontx2-af: cn10k: Introduce driver for macsec block.")
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/af/mcs_reg.h   |  1 +
>  .../marvell/octeontx2/af/mcs_rvu_if.c         | 37 +++++++++++++++++++
>  .../net/ethernet/marvell/octeontx2/af/rvu.h   |  1 +
>  .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |  2 +
>  4 files changed, 41 insertions(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
