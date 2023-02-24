Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6860F6A1CCE
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 14:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjBXNL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 08:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjBXNLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 08:11:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D199812BD0;
        Fri, 24 Feb 2023 05:11:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C01F61889;
        Fri, 24 Feb 2023 13:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240C9C433EF;
        Fri, 24 Feb 2023 13:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677244313;
        bh=Tmnx99J6rFLY7zffB2aNcRIyYYL1t2F2ABDf+c5GMVg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=H8k6CqZL6BaGKu4kt8cRObUOvEVkpJEKhdApYVg6IeYEXC2gtxLdBYW1ppWP8kKav
         SoXp4+ZtT5XhaS/Fz0mPb7nJkfpiDebE5iiA0pFGO0rNtTb9yd1cfGASCCjVrrcG1L
         UERQTMcRRhyfMBU8f8WBfzituuADOczb49H/UEqIN7fw6Jz+5uR95FnDPSiDURt02b
         d5UhI1PC544wWJnGezsaDQwqmwKfNasdDgL51ItBY0YU4W/rpbaKddndvkppNA1ikU
         Vpl2iEZly25qXuL/rZRcMayED99+CibHweAxKicaXdpee/b/oPHbzhSbI1Dc7+oEs2
         VQJcUctif+4kw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Aditya Garg <gargaditya08@live.com>
Cc:     Hector Martin <marcan@marcan.st>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        "asahi\@lists.linux.dev" <asahi@lists.linux.dev>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl\@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list\@infineon.com" 
        <SHA-cyfmac-dev-list@infineon.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Apple T2 platform support
References: <20230214080034.3828-1-marcan@marcan.st>
        <379F9C6D-F98D-4940-A336-F5356F9C1898@live.com>
        <BM1PR01MB09315D50C9380E9CB6471E9EB8A89@BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM>
Date:   Fri, 24 Feb 2023 15:11:46 +0200
In-Reply-To: <BM1PR01MB09315D50C9380E9CB6471E9EB8A89@BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM>
        (Aditya Garg's message of "Fri, 24 Feb 2023 13:05:55 +0000")
Message-ID: <87leknrywd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aditya Garg <gargaditya08@live.com> writes:

>  On 23-Feb-2023, at 8:31 PM, Aditya Garg <gargaditya08@live.com> wrote:
>
>  =EF=BB=BFHi Hector
>
>  I=E2=80=99ve applied the following patchset (arranged in chronological o=
rder) to linux 6.2,
>  and wifi seems to have broken on MacBookPro16,1 (brcmfmac4364b3)
>
>  https://lore.kernel.org/asahi/20230212063813.27622-1-marcan@marcan.st/T/=
#t
>  (BCM4355/4364/4377 support & identification fixes)
>
>  https://lore.kernel.org/asahi/20230214080034.3828-1-marcan@marcan.st/T/#=
t (Apple T2
>  platform support)
>
>  https://lore.kernel.org/asahi/20230214091651.10178-1-marcan@marcan.st/T/=
#t (BCM4387
>  / Apple M1 platform support)
>
>  https://lore.kernel.org/asahi/b4489e24-e226-4f99-1322-cab6c1269f09@broad=
com.com/T/#t
>  (brcmfmac: cfg80211: Use WSEC to set SAE password)
>
>  The logs show:
>
>  Feb 23 20:08:57 MacBook kernel: usbcore: registered new interface driver=
 brcmfmac
>  Feb 23 20:08:57 MacBook kernel: brcmfmac 0000:05:00.0: enabling device (=
0000 -> 0002)
>  Feb 23 20:08:57 MacBook kernel: brcmfmac: brcmf_fw_alloc_request: using
>  brcm/brcmfmac4364b3-pcie for chip BCM4364/4
>  Feb 23 20:08:57 MacBook kernel: brcmfmac 0000:05:00.0: Direct firmware l=
oad for
>  brcm/brcmfmac4364b3-pcie.Apple Inc.-MacBookPro16,1.bin failed with error=
 -2
>  Feb 23 20:08:57 MacBook kernel: brcmfmac 0000:05:00.0: Direct firmware l=
oad for
>  brcm/brcmfmac4364b3-pcie.bin failed with error -2
>  Feb 23 20:08:57 MacBook kernel: brcmfmac 0000:05:00.0: brcmf_pcie_setup:=
 Dongle setup
>  failed
>
>  I also tested the patchiest in the following link, and wifi mostly worke=
d there (occasionally it
>  complained about some pic error, I=E2=80=99ll save the logs next time I =
encounter that) :
>
>  https://github.com/t2linux/linux-t2-patches/blob/main/8001-asahilinux-wi=
fi-patchset.patch
>
>  Thanks
>  Aditya
>
> I just noticed that the patch to ACPI was missing. Adding that fixed the =
issue.
>
> https://github.com/t2linux/linux-t2-patches/blob/main/8005-ACPI-property-=
Support-strings-in-Apple-_DSM-props.patch

Please don't use HTML, our lists drop those. I'll reply in text/plain so
that is info is archived.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
