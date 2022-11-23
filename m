Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C8F636B56
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235454AbiKWUjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240249AbiKWUiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:38:15 -0500
Received: from conssluserg-05.nifty.com (conssluserg-05.nifty.com [210.131.2.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562D326FB;
        Wed, 23 Nov 2022 12:38:14 -0800 (PST)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id 2ANKbqXm003059;
        Thu, 24 Nov 2022 05:37:52 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com 2ANKbqXm003059
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1669235872;
        bh=mVFr1xC2ioTgngdZFkHFtRlUINTf8FXweXN3/wsapu4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BkpqQaWqqluKEXuWSDULXhY96Qu/GVqi3/DNuaMSpIN0Ly5wolN7OUDQjIPErIzRL
         vAjbt4gheMINVwoP4W2ha8zD63CHrcJs9rgijnXBYyNsDHWMAv7nY/J5jeMYIGMpXV
         4CT0rizpbhz6uRknujkF1czCt8i8UDht2oB8Jk3/Zs1AeXXyf02rcYmPW9SsyHpwEW
         3ZNEApwuT5nzntHe3A9NZs42QjQEXD07pbeXCpMLpE8heYWcynSH1RUoKbL/NnpAQ5
         5VGtHMx05iuUB8ysPSFsI6rIdcVbDJnUpjqNcAEZ3scosaD9Zp7KkZGhrZZiR9jkFQ
         Vo6cAC7DU703g==
X-Nifty-SrcIP: [209.85.210.42]
Received: by mail-ot1-f42.google.com with SMTP id p10-20020a9d76ca000000b0066d6c6bce58so11936404otl.7;
        Wed, 23 Nov 2022 12:37:52 -0800 (PST)
X-Gm-Message-State: ANoB5plEzXPM/DuMbXpr2KcewdX0tecMXFVjFXJY7Cw/SNpYJsd98V9O
        f6GCJJw1qad80OuzF4LoRp+tlWVIDA0ECsAzuY0=
X-Google-Smtp-Source: AA0mqf6OYQzKu5L7stV7+3ooCq7DZutRQ4X9b53o9/X9yVdIG5HuEwCbKHgFCx5Umjc8Cixx4D/rObQbjBLc6jBTXtM=
X-Received: by 2002:a05:6830:1b67:b0:661:8d9e:1959 with SMTP id
 d7-20020a0568301b6700b006618d9e1959mr15509730ote.225.1669235871346; Wed, 23
 Nov 2022 12:37:51 -0800 (PST)
MIME-Version: 1.0
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-19-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-19-alobakin@pm.me>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 24 Nov 2022 05:37:15 +0900
X-Gmail-Original-Message-ID: <CAK7LNAR30BJMghaJz9V6dY_gckZo=EOxh_ima7KjMgWSdhZgBA@mail.gmail.com>
Message-ID: <CAK7LNAR30BJMghaJz9V6dY_gckZo=EOxh_ima7KjMgWSdhZgBA@mail.gmail.com>
Subject: Re: [PATCH 18/18] net: cpsw: fix mixed module-builtin object
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     linux-kbuild@vger.kernel.org, Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 20, 2022 at 8:11 AM Alexander Lobakin <alobakin@pm.me> wrote:
>
> Apart from cpdma, there are 4 object files shared in one way or
> another by 5 modules:
>
> > scripts/Makefile.build:252: ./drivers/net/ethernet/ti/Makefile:
> > cpsw_ale.o is added to multiple modules: keystone_netcp
> > keystone_netcp_ethss ti_cpsw ti_cpsw_new
> > scripts/Makefile.build:252: ./drivers/net/ethernet/ti/Makefile:
> > cpsw_ethtool.o is added to multiple modules: ti_cpsw ti_cpsw_new
> > scripts/Makefile.build:252: ./drivers/net/ethernet/ti/Makefile:
> > cpsw_priv.o is added to multiple modules: ti_cpsw ti_cpsw_new
> > scripts/Makefile.build:252: ./drivers/net/ethernet/ti/Makefile:
> > cpsw_sl.o is added to multiple modules: ti_cpsw ti_cpsw_new
>
> All of those five are tristate, that means with some of the
> corresponding Kconfig options set to `m` and some to `y`, the same
> objects are linked to a module and also to vmlinux even though the
> expected CFLAGS are different between builtins and modules.
> This is the same situation as fixed by
> commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
> There's also no need to duplicate the same code 4 x 5 = roughly 20
> times.
>
> Introduce the new module, ti_cpsw_core, to provide the common
> functions used by all those modules.
>
> Fixes: 16f54164828b ("net: ethernet: ti: cpsw: drop CONFIG_TI_CPSW_ALE config option")
> Fixes: a8577e131266 ("net: ethernet: ti: netcp_ethss: fix build")
> Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
> Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  drivers/net/ethernet/ti/Kconfig          | 11 ++++++--
>  drivers/net/ethernet/ti/Makefile         | 12 ++++----
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c |  2 ++
>  drivers/net/ethernet/ti/cpsw.c           |  1 +
>  drivers/net/ethernet/ti/cpsw_ale.c       | 20 +++++++++++++
>  drivers/net/ethernet/ti/cpsw_ethtool.c   | 24 ++++++++++++++++
>  drivers/net/ethernet/ti/cpsw_new.c       |  1 +
>  drivers/net/ethernet/ti/cpsw_priv.c      | 36 ++++++++++++++++++++++++
>  drivers/net/ethernet/ti/cpsw_sl.c        |  8 ++++++
>  drivers/net/ethernet/ti/netcp_core.c     |  2 ++
>  drivers/net/ethernet/ti/netcp_ethss.c    |  2 ++
>  11 files changed, 112 insertions(+), 7 deletions(-)

As I commented on 09/18,
maybe 09/18 and 18/18 can be merged.





-- 
Best Regards
Masahiro Yamada
