Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F59A591048
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 13:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237964AbiHLLpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 07:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238206AbiHLLpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 07:45:25 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE05AFAF2;
        Fri, 12 Aug 2022 04:44:49 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 261F361EA1929;
        Fri, 12 Aug 2022 13:44:45 +0200 (CEST)
Message-ID: <f0a6f8cc-e8a5-ff72-b8f0-ed25fcf03b47@molgen.mpg.de>
Date:   Fri, 12 Aug 2022 13:44:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: mainline build failure due to 332f1795ca20 ("Bluetooth: L2CAP:
 Fix l2cap_global_chan_by_psm regression")
Content-Language: en-US
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     torvalds@linux-foundation.org, Jakub Kicinski <kuba@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>
References: <YvY4xdZEWAPosFdJ@debian>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <YvY4xdZEWAPosFdJ@debian>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Sudip,


Am 12.08.22 um 13:25 schrieb Sudip Mukherjee (Codethink):

> The latest mainline kernel branch fails to build csky and mips allmodconfig
> with gcc-12.
> 
> mips error is:
> 
> In function 'memcmp',
>      inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:347:9,
>      inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2003:15:
> ./include/linux/fortify-string.h:44:33: error: '__builtin_memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
>     44 | #define __underlying_memcmp     __builtin_memcmp
>        |                                 ^
> ./include/linux/fortify-string.h:420:16: note: in expansion of macro '__underlying_memcmp'
>    420 |         return __underlying_memcmp(p, q, size);
>        |                ^~~~~~~~~~~~~~~~~~~
> In function 'memcmp',
>      inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:347:9,
>      inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2004:15:
> ./include/linux/fortify-string.h:44:33: error: '__builtin_memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
>     44 | #define __underlying_memcmp     __builtin_memcmp
>        |                                 ^
> ./include/linux/fortify-string.h:420:16: note: in expansion of macro '__underlying_memcmp'
>    420 |         return __underlying_memcmp(p, q, size);
>        |                ^~~~~~~~~~~~~~~~~~~
> 
> 
> csky error is:
> 
> In file included from net/bluetooth/l2cap_core.c:37:
> In function 'bacmp',
>      inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2003:15:
> ./include/net/bluetooth/bluetooth.h:347:16: error: 'memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
>    347 |         return memcmp(ba1, ba2, sizeof(bdaddr_t));
>        |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In function 'bacmp',
>      inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2004:15:
> ./include/net/bluetooth/bluetooth.h:347:16: error: 'memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
>    347 |         return memcmp(ba1, ba2, sizeof(bdaddr_t));
>        |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> 
> git bisect pointed to 332f1795ca20 ("Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression").
> And, reverting that commit has fixed the build failure.
> 
> Already reported at https://lore.kernel.org/lkml/YvVQEDs75pxSgxjM@debian/
> and Jacub is looking at a fix, but this is just my usual build failure
> mail of mainline branch for Linus's information.

Does *[PATCH] Bluetooth: L2CAP: Elide a string overflow warning* [1] fix it?


Kind regards,

Paul


PS:

> --
> Regards
> Sudip

Only if you care, your signature delimiter is missing a trailing space [2].


[1]: 
https://lore.kernel.org/linux-bluetooth/20220812055249.8037-1-palmer@rivosinc.com/T/#t
[2]: https://en.wikipedia.org/wiki/Signature_block#Standard_delimiter
