Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5918552EA14
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 12:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348237AbiETKk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 06:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239447AbiETKk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 06:40:56 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A386DE94;
        Fri, 20 May 2022 03:40:53 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L4NYD43MVz4xXj;
        Fri, 20 May 2022 20:40:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1653043251;
        bh=kLvXGUJ3/ReQbtc7FZG4S2UHVHzM/605lq9b6IyiY5M=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=pMWZBKi2JiSg+r6at1yci6wwlaKqROcHmumy1qm2oKAprlF7OjcdtRnL4YzJI0ww7
         sD2U1Ve/WujuCckOohm/ghb7M2rTLRAwbRVbneALWNRVCOFweOj4Zqw+AiW9Qd6YZ5
         W8BcHWFaEuMsjmgGl/FVfHm//aeurxvN5nPWIZtI1sM70KGr6t0eNoNv7Jklm+Psb0
         uWvsjppTeHZvH5lbRxbKW7wZyqx2ocpwCpyz87TjsFA6JEPD90EbiYrFICy2ODn2bl
         Dty+eeRKILrhrPZyMVQ2MjxpU8FQLn9KXVqel0TNRihZ+MlyNDRF0C2Afqo96JN5nC
         hHtsMOodRK9Mg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, corbet@lwn.net,
        tsbogend@alpha.franken.de, benh@kernel.crashing.org,
        paulus@samba.org, sburla@marvell.com, vburru@marvell.com,
        aayarekar@marvell.com, arnd@arndb.de, zhangyue1@kylinos.cn,
        linux-doc@vger.kernel.org, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org
Subject: Re: [PATCH net-next] eth: de4x5: remove support for Generic DECchip
 & DIGITAL EtherWORKS PCI/EISA
In-Reply-To: <20220519031345.2134401-1-kuba@kernel.org>
References: <20220519031345.2134401-1-kuba@kernel.org>
Date:   Fri, 20 May 2022 20:40:48 +1000
Message-ID: <87o7zsmqq7.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:
> Looks like almost all changes to this driver had been tree-wide
> refactoring since git era begun. There is one commit from Al
> 15 years ago which could potentially be fixing a real bug.
>
> The driver is using virt_to_bus() and is a real magnet for pointless
> cleanups. It seems unlikely to have real users. Let's try to shed
> this maintenance burden.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: corbet@lwn.net
> CC: tsbogend@alpha.franken.de
> CC: mpe@ellerman.id.au
> CC: benh@kernel.crashing.org
> CC: paulus@samba.org
> CC: sburla@marvell.com
> CC: vburru@marvell.com
> CC: aayarekar@marvell.com
> CC: arnd@arndb.de
> CC: zhangyue1@kylinos.cn
> CC: linux-doc@vger.kernel.org
> CC: linux-mips@vger.kernel.org
> CC: linuxppc-dev@lists.ozlabs.org
> CC: linux-parisc@vger.kernel.org
> ---
>  .../device_drivers/ethernet/dec/de4x5.rst     |  189 -
>  .../device_drivers/ethernet/index.rst         |    1 -
>  arch/mips/configs/mtx1_defconfig              |    1 -
>  arch/powerpc/configs/chrp32_defconfig         |    1 -
>  arch/powerpc/configs/ppc6xx_defconfig         |    1 -

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers
