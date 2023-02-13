Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62808694A0F
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjBMPEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbjBMPET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:04:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB7E1C7E4;
        Mon, 13 Feb 2023 07:04:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E12BB81257;
        Mon, 13 Feb 2023 15:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2BDC4339B;
        Mon, 13 Feb 2023 15:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676300631;
        bh=+wEwi3uP6m+OmiYJZXywwSEgwz7I5NuC9HzyYKFbRm4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=QoWMvey/OJC7lIr4yZ9tWaFKtgh6fLbY6hn+ORxeTB0NUkCSFz9y1KVxEG8klG1SV
         hpq8BbH7DxBkfQO4p1/KVcoFoo5nOloFAcFUag611jvwZsMJSGN7280gCWtOjuVSpZ
         USPRd951JzYLDrhNrE7zaZU4cwr4VnSoPfeNpLVutlG0fIrqJu1+qBYJFUWo55zd6M
         e/4uo6KATDUFyO8qZQwVPQutYdtQRvYsXcn9Ww6aSwPHRdnI1DhPjd1opBJrAkkFO5
         fYEHvlqNQFyJ6wNxzzbahbYDa8AMQGN2/EHXii0ZxWcNL8m53/NCLzKXc7KCFhwTRU
         uVPbrH8UFs58w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] brcmfmac: support CQM RSSI notification with older
 firmware
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230124104248.2917465-1-john@metanate.com>
References: <20230124104248.2917465-1-john@metanate.com>
To:     John Keeping <john@metanate.com>
Cc:     netdev@vger.kernel.org, John Keeping <john@metanate.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?utf-8?q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167630062469.12830.3942976448765702685.kvalo@kernel.org>
Date:   Mon, 13 Feb 2023 15:03:47 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Keeping <john@metanate.com> wrote:

> Using the BCM4339 firmware from linux-firmware (version "BCM4339/2 wl0:
> Sep  5 2019 11:05:52 version 6.37.39.113 (r722271 CY)" from
> cypress/cyfmac4339-sdio.bin) the RSSI respose is only 4 bytes, which
> results in an error being logged.
> 
> It seems that older devices send only the RSSI field and neither SNR nor
> noise is included.  Handle this by accepting a 4 byte message and
> reading only the RSSI from it.
> 
> Fixes: 7dd56ea45a66 ("brcmfmac: add support for CQM RSSI notifications")
> Signed-off-by: John Keeping <john@metanate.com>

Arend, could you take a look?

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230124104248.2917465-1-john@metanate.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

