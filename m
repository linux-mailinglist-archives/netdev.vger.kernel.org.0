Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546DC6B5DA4
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 17:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjCKQHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 11:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjCKQHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 11:07:04 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A198B1166E;
        Sat, 11 Mar 2023 08:07:02 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 1BFAB425FF;
        Sat, 11 Mar 2023 16:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1678550820; bh=6O+1q5pkxO0hFhdxV2lPUXqo/slkZFfMLidN5m0Bq/g=;
        h=Date:Subject:To:References:From:In-Reply-To;
        b=oOTEu1WhKRnigtIrEsPcluvbRjy/hPgtEteiZF7lZOJJD5XgGAttXBSGsUVVJSPs5
         Klh/DO9Y4XK1PehVI8KOU7tX56wWWHB1E+OQVaUK/qbd3JMcN+Fv3gGyjYiWIeJ7MG
         iPEPB/98o7hPzezmKUs3FAT1piIm1+BQbQfLeMJLqJv9Girc6khGpmhtOEAeORNkSV
         7NUk4N13ldA6pt7391qkyGQ4TRVYmkxRhbeBr3ROVl2M0jXPFZsvrR0uSiiJQLa1nv
         v51m/d2oFwYVavmd66/BcES3JK75eO3+yBFdEFwXs/EnSjhMo02gPFvJF95uzo0sTs
         G6tQw8RhIxvkQ==
Message-ID: <e5d36d19-624e-ad0e-cd90-8b188771e41d@marcan.st>
Date:   Sun, 12 Mar 2023 01:06:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [REGRESSION] Unable to connect to Internet since kernel 6.2.3 on
 T2 Macs
Content-Language: en-US
To:     Aditya Garg <gargaditya08@live.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Orlando Chamberlain <orlandoch.dev@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <MA0P287MB02178C2B6AFC2E96F261FB2CB8BB9@MA0P287MB0217.INDP287.PROD.OUTLOOK.COM>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <MA0P287MB02178C2B6AFC2E96F261FB2CB8BB9@MA0P287MB0217.INDP287.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/03/2023 00.56, Aditya Garg wrote:
> A weird regression has been affecting the T2 Macs since kernel 6.2.3. The users are unable to connect to both wireless as well as wired Internet. As far as wireless is concerned, the patches for T2 Macs that have been upstreamed in kernel 6.3 have been working well till 6.2.2, but after that the network has stopped working.
> 
> Interesting, the driver shows no errors in journalctl. The wifi firmware loads well and the networks even appear on scan list. But, the connection to a network fails. Ethernet/USB tethering has also stopped working.
> 
> If I you need some logs from me, please do ask.
> 
> Also, Hector, I’d like to know whether this affects the M1/2 Macs as well or not.

This is already reported, identified, and a patch submitted.

https://lore.kernel.org/linux-wireless/20230124141856.356646-1-alexander@wetzel-home.de/

- Hector
