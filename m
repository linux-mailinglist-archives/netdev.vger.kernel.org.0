Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697D969B0F7
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 17:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjBQQbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 11:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjBQQbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 11:31:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFDE25B96;
        Fri, 17 Feb 2023 08:31:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C29EAB82C8E;
        Fri, 17 Feb 2023 16:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6145C433D2;
        Fri, 17 Feb 2023 16:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676651482;
        bh=Nc43sf3KjLBKJ1grV2w2Lxnfo2n1XRCDKjHl1J+knb4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=GXbgTYSXoJhodYMdyp0eVzaWlhyioeNHNy4WyrIB5IqtLDygDfY8l/d92Nw5PZjkj
         Rg/6mM33G3EO3lD9sGd/8TdA8xEpKKCDRkoVzmpU2PqTaSXKjO/vrxP1MFuMS8Cs67
         nH38Or8WLkrau1EXrWdeNkYB7UNLzZx/U6KHOudgUe78q7wldyi0v7yaZviy5syZWT
         KmYSGakoLwMf1AnE2NKXQaqNpSEv0FxnOwACBltb2cP+ZNX/OmXSDUfW4hsNOy0FWl
         TottfZvZuB8VmWjCp/SQRFuja91oB7JXbuT/eIYK3C8dwJsUphPJ+Whpl38NikYjaA
         vcYeRjLd7LXOA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtl8xxxu: add LEDS_CLASS dependency
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230217095910.2480356-1-arnd@kernel.org>
References: <20230217095910.2480356-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167665147529.29864.16564467091788545261.kvalo@kernel.org>
Date:   Fri, 17 Feb 2023 16:31:19 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> rtl8xxxu now unconditionally uses LEDS_CLASS, so a Kconfig dependency
> is required to avoid link errors:
> 
> aarch64-linux-ld: drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.o: in function `rtl8xxxu_disconnect':
> rtl8xxxu_core.c:(.text+0x730): undefined reference to `led_classdev_unregister'
> 
> ERROR: modpost: "led_classdev_unregister" [drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.ko] undefined!
> ERROR: modpost: "led_classdev_register_ext" [drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.ko] undefined!
> 
> Fixes: 3be01622995b ("wifi: rtl8xxxu: Register the LED and make it blink")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-next.git, thanks.

38ae31922969 wifi: rtl8xxxu: add LEDS_CLASS dependency

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230217095910.2480356-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

