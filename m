Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003B86E41A3
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 09:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjDQHy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 03:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjDQHyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 03:54:45 -0400
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34233594;
        Mon, 17 Apr 2023 00:54:42 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 18D6C4212E;
        Mon, 17 Apr 2023 07:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1681718080; bh=9BgjppDTP78o93QzzyDV1mwP9TOqlheAYnzrgGrUZvs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=eLdiolIPfg0qDBvve6LIvtScZrynBCa3ibW75H4luminZX8h3ma+SdY/5AV9T+2u6
         4MU53gW6ne8k2AFtYieKV6xUmBcFYhfHt/5/5BDDID3ltJq8dZKjudCMETmfiBiqbU
         hV0Yrnq0uTfWuJPV1ugZsCU/fM/2dLHo9NgPqfiv7wHZvmH98Iie9iWlcJT75reqEw
         VL/7zPMKCgqpDI6R9qLy1HTRaNuLz3g8kpqbDv9fg9MDLZkT6ZH6ULdsT/yXU7VObc
         T42OVJU/Au5qj/Vs/wpQ5kmhH0nveANqT/8ZcSkSI9TukCzW0SYfBE+Kn+kCDjeQIp
         kO/G4VJjlxXfQ==
Message-ID: <8b2e7bb9-3681-0265-01bc-e7abdd0d08b8@marcan.st>
Date:   Mon, 17 Apr 2023 16:54:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/2] wifi: brcmfmac: Demote vendor-specific attach/detach
 messages to info
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
        stable@vger.kernel.org
References: <20230416-brcmfmac-noise-v1-0-f0624e408761@marcan.st>
 <20230416-brcmfmac-noise-v1-1-f0624e408761@marcan.st>
 <2023041631-crying-contour-5e11@gregkh>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <2023041631-crying-contour-5e11@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/04/2023 21.46, Greg KH wrote:
> On Sun, Apr 16, 2023 at 09:42:17PM +0900, Hector Martin wrote:
>> People are getting spooked by brcmfmac errors on their boot console.
>> There's no reason for these messages to be errors.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: d6a5c562214f ("wifi: brcmfmac: add support for vendor-specific firmware api")
>> Signed-off-by: Hector Martin <marcan@marcan.st>
>> ---
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c | 4 ++--
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 4 ++--
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c | 4 ++--
>>  3 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
>> index ac3a36fa3640..c83bc435b257 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
>> @@ -12,13 +12,13 @@
>>  
>>  static int brcmf_bca_attach(struct brcmf_pub *drvr)
>>  {
>> -	pr_err("%s: executing\n", __func__);
>> +	pr_info("%s: executing\n", __func__);
> 
> Why are these here at all?  Please just remove these entirely, you can
> get this information normally with ftrace.
> 
> Or, just delete these functions, why have empty ones at all?

This is a new WIP code path that Arend introduced which currently
deliberately does nothing (but is intended to hold firmware vendor
specific init in the future). So we can just drop the messages, but I
don't think we want to remove the code entirely.

- Hector

