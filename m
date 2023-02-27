Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6398B6A3F9B
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 11:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjB0Km1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 05:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjB0Km0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 05:42:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACB61116D;
        Mon, 27 Feb 2023 02:42:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C70360DD5;
        Mon, 27 Feb 2023 10:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20B2C433D2;
        Mon, 27 Feb 2023 10:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677494543;
        bh=sZKEkf63XeMBlfDhSrMn9S9BUdiM2Payf7wGr+xHNZ8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LKn5vAYcpNDnKEOJ4t9gd8RrAj1eFErwm0H5s8SKs0K+H57HkLDHFMVaDquHt2Dxl
         yYyG8+R1r2emJdA6HuVaxkHmcRkbMqPwLcYx9aHColIkYNbWjMEtpeu2xas09xy/t0
         +s5YqrCJvZDD6YwV2aTQqvXCtTC3OPwBdGxVwoGQJAcjhmgqE5mpFXdnc/t9g5ikuB
         dZmS6yVFo4uk7xXvUgu2a5CMLusKie/wJQgCxVvsM+l/TzRLVJ5IGMUOjzzKySuvdB
         IQPOqW5RooZUTGw5lQkMFia5+hXxk5l1GOsEMbCKq/xC/FnnJ20f4HJA+OGQiJsjji
         78VFSpJ1X3Lkg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v2] wifi: brcmfmac: support CQM RSSI notification with older
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
Message-ID: <167749453809.25422.2426932954308893470.kvalo@kernel.org>
Date:   Mon, 27 Feb 2023 10:42:19 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

Patch applied to wireless-next.git, thanks.

ec52d77d0775 wifi: brcmfmac: support CQM RSSI notification with older firmware

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230124104248.2917465-1-john@metanate.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

