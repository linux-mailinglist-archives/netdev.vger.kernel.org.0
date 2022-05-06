Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C823251D116
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 08:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389369AbiEFGPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 02:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353259AbiEFGPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 02:15:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90CD5B3C2;
        Thu,  5 May 2022 23:11:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B35E61F0C;
        Fri,  6 May 2022 06:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DBDC385A8;
        Fri,  6 May 2022 06:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651817515;
        bh=hHJ2dKaQKUKX5YA0P8F4R0QuX/KqDRWP+QfV5J6aF/I=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AXmhgoivoTIbOkrlU7cOSNNeQVxmMkJrZlYludZjC1B+6e92V8SQFv1SL/KyByxWW
         Q+wzOCCju2+v0Tveu/H+KRWiEY6aKp+XZOIg/YK8jG9UpwF9wFerSkraLHQyddCxad
         KQBXpvh7uaJYcQ8Lu7FUSkLROpLCzyi9EC4gQVUTXb4N7yCp2YEP4IZaLT40YDjuR0
         TsAm7w9DonnasfT0JknwSPUTyA0ay0p+f2ShPc9k20713PJtVtnun7BFKJuzW75lHh
         MlNi3B6Evj+gy5ZudY+TIpH80mB3pi+BYRtegAmW7Xh40V9HHu++ka97YX1zCCzFRZ
         o6CDVodLztT6g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wl1251: dynamically allocate memory used for DMA
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <1676021ae8b6d7aada0b1806fed99b1b8359bdc4.1651495112.git.hns@goldelico.com>
References: <1676021ae8b6d7aada0b1806fed99b1b8359bdc4.1651495112.git.hns@goldelico.com>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     arnd@arndb.de, tony@atomide.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, linux-omap@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165181750762.835.18351799442836112147.kvalo@kernel.org>
Date:   Fri,  6 May 2022 06:11:52 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"H. Nikolaus Schaller" <hns@goldelico.com> wrote:

> With introduction of vmap'ed stacks, stack parameters can no
> longer be used for DMA and now leads to kernel panic.
> 
> It happens at several places for the wl1251 (e.g. when
> accessed through SDIO) making it unuseable on e.g. the
> OpenPandora.
> 
> We solve this by allocating temporary buffers or use wl1251_read32().
> 
> Tested on v5.18-rc5 with OpenPandora.
> 
> Fixes: a1c510d0adc6 ("ARM: implement support for vmap'ed stacks")
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>

Patch applied to wireless-next.git, thanks.

454744754cbf wl1251: dynamically allocate memory used for DMA

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1676021ae8b6d7aada0b1806fed99b1b8359bdc4.1651495112.git.hns@goldelico.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

