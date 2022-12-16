Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5735564E746
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 07:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiLPGW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 01:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiLPGW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 01:22:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7B8654FD;
        Thu, 15 Dec 2022 22:22:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 299B5B81D38;
        Fri, 16 Dec 2022 06:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B616C433F0;
        Fri, 16 Dec 2022 06:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671171743;
        bh=6AJD0sWhzcRVUgHGLoWzQ/D9RJTp+ed+Zwakh4Xu2Wc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=G++PnC4NHAL5pOgQgytc/Xn9cxA0zIeeBlwAzcca9rZ5Gw+sMjU23PmHI9svj8HzM
         +feTNrGfK2eP9NDFuhYRs8tTPiiKbc9puyGKO+VXz2SecKcEGGRd1aREz0CuSDlQBt
         vM5c/08mkEpLq/W2cNQSDygYwo62nkqKhdMWRxqk/mmKyvVGugkTW/x/8q8Y8kyCf4
         nlD/DMfVJUiMg9y78khnQzYxNdt8vkp7+AMCFpXGZaEvxas2CO37eHyqT3X/lBoURq
         3/y0m6SEHawNm0U8oCYZJSAeThYh2q0VZ/xaIJ2LulTOoSQdckVRqm+/oP6ufbWpuZ
         gtnopTFomImvA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mt76: mt7996: select CONFIG_RELAY
References: <20221215163133.4152299-1-arnd@kernel.org>
Date:   Fri, 16 Dec 2022 08:22:18 +0200
In-Reply-To: <20221215163133.4152299-1-arnd@kernel.org> (Arnd Bergmann's
        message of "Thu, 15 Dec 2022 17:31:10 +0100")
Message-ID: <87iliblvfp.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> writes:

> From: Arnd Bergmann <arnd@arndb.de>
>
> Without CONFIG_RELAY, the driver fails to link:
>
> ERROR: modpost: "relay_flush" [drivers/net/wireless/mediatek/mt76/mt7996/mt7996e.ko] undefined!
> ERROR: modpost: "relay_switch_subbuf" [drivers/net/wireless/mediatek/mt76/mt7996/mt7996e.ko] undefined!
> ERROR: modpost: "relay_open" [drivers/net/wireless/mediatek/mt76/mt7996/mt7996e.ko] undefined!
> ERROR: modpost: "relay_reset" [drivers/net/wireless/mediatek/mt76/mt7996/mt7996e.ko] undefined!
> ERROR: modpost: "relay_file_operations" [drivers/net/wireless/mediatek/mt76/mt7996/mt7996e.ko] undefined!
>
> The same change was done in mt7915 for the corresponding copy of the code.
>
> Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
> See-also: 988845c9361a ("mt76: mt7915: add support for passing chip/firmware debug data to user space")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Felix, should I take this to wireless tree?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
