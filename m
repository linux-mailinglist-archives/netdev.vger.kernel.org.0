Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C46615B24
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 04:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiKBDty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 23:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiKBDtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 23:49:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA511F2C8;
        Tue,  1 Nov 2022 20:49:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1388B82055;
        Wed,  2 Nov 2022 03:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0095EC433C1;
        Wed,  2 Nov 2022 03:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667360986;
        bh=rNNhFDFwW2G0G/ZlDlWXuItSrEFoY65rTPZ//6woXrw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TPdWrIu7iH0zfXYRcUjT+c9FS6arh7I1skciZ+JgGrGWzZh8R+gd8l2fNzVBCLqOd
         7cqjkrBPHQpzOWrrJPb9cIJkS7UWLj6++2VQl92pLVmXliD5fHyjOB68cZ1ZXo/JoM
         kLl8iiI0bn4cGnN9IwfT7rMRQRVsZsYa4i7uVjrMPEa73NrrJXRWzfqxD3s9gm6+BX
         8WLdeoNnaegu80MswENmq4M8fXEw7OpGerz6OY0rfuz2sDUeRO/RZpJb+sYD5VjGlt
         lUXyHdX9bg8ub3odTSaSajdx77wbhybmPl9LmVUmm1ChBIJioyuVob279TK/azVqsk
         tEhyz+XehMe+g==
Date:   Tue, 1 Nov 2022 20:49:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] net: ethernet: mediatek: ppe: add support for flow
 accounting
Message-ID: <20221101204945.35edb8e6@kernel.org>
In-Reply-To: <Y2HAmYYPd77dz+K5@makrotopia.org>
References: <Y2HAmYYPd77dz+K5@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Nov 2022 00:58:01 +0000 Daniel Golle wrote:
> The PPE units found in MT7622 and newer support packet and byte
> accounting of hw-offloaded flows. Add support for reading those
> counters as found in MediaTek's SDK[1].
> 
> [1]: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/bc6a6a375c800dc2b80e1a325a2c732d1737df92
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
> v4: declare function mtk_mib_entry_read as static
> v3: don't bother to set 'false' values in any zero-initialized struct
>     use mtk_foe_entry_ib2
>     both changes were requested by Felix Fietkau
> 
> v2: fix wrong variable name in return value check spotted by Denis Kirjanov

Please read the FAQ:

https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#tl-dr

https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#running-all-the-builds-and-checks-locally-is-a-pain-can-i-post-my-patches-and-have-the-patchwork-bot-validate-them

