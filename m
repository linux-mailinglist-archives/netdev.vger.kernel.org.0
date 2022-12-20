Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C4065212A
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 14:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiLTNDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 08:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233868AbiLTNDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 08:03:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D622316596;
        Tue, 20 Dec 2022 05:03:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 723F66140B;
        Tue, 20 Dec 2022 13:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597F2C433EF;
        Tue, 20 Dec 2022 13:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671541380;
        bh=KNR9UnmTyhihgi7laGFrXDHTFdgw9AYrYBt6eXlxzEc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=e5lgBX5fVfhnsY4PqerckGNNZlav8e4jbXNfSHCsY1OMUaOYPxY3oYIhhEK9hQhh4
         h7jOYPaAF9DXimmzmDjMsLOX9ckpBsDbljXEezDF0pl0TsLh2t3rXzup90tF+oUnZ6
         U6Az8A7+HsTU81pOZ5xW4RZCwMb+j3p0HrTx4N7ARKWTVNKRdVn4rg6P+KcE2ZJKtG
         S1zL9ApVk6KHcY2AHaFTbjfNy8pJFYJu9IzlNa25vlkvnxK5m2Cac1XyAAVrW2+qMl
         hqJLitpOJc+wDM2XBa9h9IXNI4XPEOmC85Vc/S9+EjyoAExSPVHBHxDGsNdBtaE6vr
         iTCzprh1j8PpQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: wifi: ath9k: use proper statements in conditionals
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221215165553.1950307-1-arnd@kernel.org>
References: <20221215165553.1950307-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167154137625.23629.16918732467799210521.kvalo@kernel.org>
Date:   Tue, 20 Dec 2022 13:02:58 +0000 (UTC)
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
> A previous cleanup patch accidentally broke some conditional
> expressions by replacing the safe "do {} while (0)" constructs
> with empty macros. gcc points this out when extra warnings
> are enabled:
> 
> drivers/net/wireless/ath/ath9k/hif_usb.c: In function 'ath9k_skb_queue_complete':
> drivers/net/wireless/ath/ath9k/hif_usb.c:251:57: error: suggest braces around empty body in an 'else' statement [-Werror=empty-body]
>   251 |                         TX_STAT_INC(hif_dev, skb_failed);
> 
> Make both sets of macros proper expressions again.
> 
> Fixes: d7fc76039b74 ("ath9k: htc: clean up statistics macros")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>

Patch applied to wireless.git, thanks.

b7dc753fe33a wifi: ath9k: use proper statements in conditionals

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221215165553.1950307-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

