Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D6465211F
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 14:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbiLTNBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 08:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbiLTNBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 08:01:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105C7D139;
        Tue, 20 Dec 2022 05:01:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6DCCB8120C;
        Tue, 20 Dec 2022 13:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CF8C433D2;
        Tue, 20 Dec 2022 13:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671541306;
        bh=slrz46HiCnR36Ttz5lZwi2BzDl4AV9enAoKXs0qjmNM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=UXKqSGIOyQZvfv+enBZrb4w4rxIfUxpC8+O6/Z9APCEJ7LTp1RxkoilHrcPTfgiom
         A/E2K6hgvdTdkF+03z6Wj5wceZ7w0g4Z8H15BanUZR0qfQArf1zXWW/sviGezn9WKb
         4aj/Q2APzcDuWMp8Fa+Bmz2Sc4iIjs2Ll0G76mH33aZiaC4l0TDEua3SGeEvgMdzXx
         Sx171OfV+uC4PIa+oqWFqrAmX7bQIRKhvgFo8N7a21xgMNkuqll2G8uhXkeuspPCpv
         fsU58EpwbZeqgaimp2KZsMWL6M8/Okvia8qgDROZWupSsfi9rV7MHI4Mf7OfKMb/Aa
         JlU8uG8IuNL7A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: mt76: mt7996: select CONFIG_RELAY
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221215163133.4152299-1-arnd@kernel.org>
References: <20221215163133.4152299-1-arnd@kernel.org>
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
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167154130077.23629.13270502460080911055.kvalo@kernel.org>
Date:   Tue, 20 Dec 2022 13:01:42 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

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

Patch applied to wireless.git, thanks.

37fc9ad1617a wifi: mt76: mt7996: select CONFIG_RELAY

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221215163133.4152299-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

