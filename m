Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3004BE7A8
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356810AbiBULvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 06:51:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356802AbiBULvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 06:51:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4CC1EEE8;
        Mon, 21 Feb 2022 03:51:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C1EA6120C;
        Mon, 21 Feb 2022 11:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A808DC340E9;
        Mon, 21 Feb 2022 11:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645444281;
        bh=aEjnWxrjnA14KfRLROgbL/4x95nqLDJdCIq8yEnO6sU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=KPgkuE4B6hPHagMXMnP0a8ZrFMrlAC6lReEZiqHgP/nTU3UOxhFunYyDDjenWFYci
         GuJXjg3s0wNm4h9juug2LyxQ9VsoUACToenFReqi6uTrDS7m9+M7NjjCt+ZtAuxqpv
         LMoz5cfTZluggZbHdB8IzpEQGS52kUYnOavmJTuEIf/9P2Jf4O0wYVPiQRgcGzuls4
         MU057l5rkYTsersBQzcw2jqf87L0LgTUEc7rX38v6dMOAH4yJcJJVNEnnRSTpjW4N2
         4dVx5sSEzVQlws2tWjc7AAP1D/M9P00vnA9ROkrMmEOl3DArS7rlDdZ0j4MG1fOOc5
         oHEBKXCwx+mCw==
Message-ID: <dca886f1-a187-8fe2-33d3-0626ce62e39b@kernel.org>
Date:   Mon, 21 Feb 2022 13:51:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Build regressions/improvements in v5.17-rc5
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
References: <20220221095530.1355319-1-geert@linux-m68k.org>
 <alpine.DEB.2.22.394.2202211143310.347934@ramsan.of.borg>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <alpine.DEB.2.22.394.2202211143310.347934@ramsan.of.borg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On 21/02/2022 12:47, Geert Uytterhoeven wrote:
> On Mon, 21 Feb 2022, Geert Uytterhoeven wrote:
>> JFYI, when comparing v5.17-rc5[1] to v5.17-rc4[3], the summaries are:
>>  - build errors: +2/-1
> 
>   + /kisskb/src/net/netfilter/xt_socket.c: error: implicit declaration of function 'nf_defrag_ipv6_disable'; did you mean 'nf_defrag_ipv4_disable'? [-Werror=implicit-function-declaration]:  => 224:3
> 
> mips-gcc8/malta_defconfig
> mips-gcc8/ip22_defconfig
> 
>   + error: omap-gpmc.c: undefined reference to `of_platform_device_create':  => .text.unlikely+0x14c4), .text.unlikely+0x1628)

This error should be fixed by this patch

https://lore.kernel.org/all/20220219193600.24892-1-rogerq@kernel.org/t/

> 
> sparc64-gcc11/sparc64-allmodconfig
> sparc64/sparc-allmodconfig
> sparc64/sparc64-allmodconfig
> 
>> [1] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/cfb92440ee71adcc2105b0890bb01ac3cddb8507/ (all 99 configs)
>> [3] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/754e0b0e35608ed5206d6a67a791563c631cec07/ (all 99 configs)
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> -- 
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

--
cheers,
-roger
