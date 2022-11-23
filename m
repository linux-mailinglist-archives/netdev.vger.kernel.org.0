Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7F4636C7F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 22:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238686AbiKWVkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 16:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235322AbiKWVkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 16:40:23 -0500
Received: from conssluserg-02.nifty.com (conssluserg-02.nifty.com [210.131.2.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7EE3AF086;
        Wed, 23 Nov 2022 13:40:20 -0800 (PST)
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id 2ANLdwOe024156;
        Thu, 24 Nov 2022 06:39:59 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com 2ANLdwOe024156
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1669239599;
        bh=XDaXinCZ/pwtJaEK2Uz8cutMw5i0ZxD//q2BY+FGPBY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KSD4Ak5ha0bJ2tx+cZWR9hwNMHDFnC7O5bj/jmxVgi0oKEdu2PpRoBrccpERozaNv
         xRvO77M0cciZOptvnsOc9WKxScJsUYyA32kTAqlAQP75I4urNCXhR6mW7MCrseV2kt
         ZIBv5IdtzoBahg2FTlIYNjIDDOoWwjdFtiaa/+JJKDWxR70337/c4hoE3umPCY2Pyx
         a5ViGboXGbfDrBJyRtzRXrNdZ8jCfm+qQzTNN9Ab5xHg7AqAO0dTAsgowdhgNyRnLT
         JME+AeoFaiIxYo1j8tNm6dwvhiKtfDQEZ8Unw2mWazYYQVs6hstgSItusFEZfeyLcQ
         Bf0OCUMcJcn+Q==
X-Nifty-SrcIP: [209.85.160.53]
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-1433ef3b61fso2304484fac.10;
        Wed, 23 Nov 2022 13:39:58 -0800 (PST)
X-Gm-Message-State: ANoB5plJdr6Ed5+ey2qFUORjaR5m9nMaFk+x0ZecmXwiZdfG0oIKrkjX
        6W8WL8t4yvLtYTDNvhiEh0mTEQNJSxY8TThBuVI=
X-Google-Smtp-Source: AA0mqf5kse+8HoHAuaJZlsc74aO2g4dOFf0yP1vFcAjTYlOnUf7ie/3LSrM2a7WM/vsYdzWmoPC2sdnkzETQ3nlk34o=
X-Received: by 2002:a05:6870:3b06:b0:13b:5d72:d2c6 with SMTP id
 gh6-20020a0568703b0600b0013b5d72d2c6mr5885002oab.287.1669239597800; Wed, 23
 Nov 2022 13:39:57 -0800 (PST)
MIME-Version: 1.0
References: <20221119225650.1044591-1-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-1-alobakin@pm.me>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 24 Nov 2022 06:39:21 +0900
X-Gmail-Original-Message-ID: <CAK7LNASxdDFg+CivkBapM82biPDWDYhJ7kn2y0QG2YuhiXcRLw@mail.gmail.com>
Message-ID: <CAK7LNASxdDFg+CivkBapM82biPDWDYhJ7kn2y0QG2YuhiXcRLw@mail.gmail.com>
Subject: Re: [PATCH 00/18] treewide: fix object files shared between several modules
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

On Sun, Nov 20, 2022 at 8:04 AM Alexander Lobakin <alobakin@pm.me> wrote:
>
> This is a follow-up to the series[0] that adds Kbuild warning if an
> object is linked into several modules (including vmlinux) in order
> to prevent hidden side effects from appearing.
> The original series, as well as this one, was inspired by the recent
> issue[1] with the ZSTD modules on a platform which has such sets of
> vmlinux cflags and module cflags so that objects built with those
> two even refuse to link with each other.
> The final goal is to forbid linking one object several times
> entirely.
>
> Patches 1-7 and 10-11 was runtime-tested by me. Pathes 8-9 and 12-18
> are compile-time tested only (compile, link, modpost), so I
> encourage the maintainers to review them carefully. At least the
> last one, for cpsw, most likely has issues :D
> Masahiro's patches are taken from his WIP tree[2], with the two last
> finished by me.
>
> This mostly is a monotonic work, all scores go to Masahiro and
> Alexey :P
>
> [0] https://lore.kernel.org/linux-kbuild/20221118191551.66448-1-masahiroy@kernel.org
> [1] https://github.com/torvalds/linux/commit/637a642f5ca5e850186bb64ac75ebb0f124b458d
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git/log/?h=tmp4
>
> Alexander Lobakin (9):
>   EDAC: i10nm, skx: fix mixed module-builtin object
>   platform/x86: int3472: fix object shared between several modules
>   mtd: tests: fix object shared between several modules
>   crypto: octeontx2: fix objects shared between several modules
>   dsa: ocelot: fix mixed module-builtin object
>   net: dpaa2: fix mixed module-builtin object
>   net: hns3: fix mixed module-builtin object
>   net: octeontx2: fix mixed module-builtin object
>   net: cpsw: fix mixed module-builtin object
>
> Masahiro Yamada (9):
>   block/rnbd: fix mixed module-builtin object
>   drm/bridge: imx: fix mixed module-builtin object
>   drm/bridge: imx: turn imx8{qm,qxp}-ldb into single-object modules
>   sound: fix mixed module-builtin object
>   mfd: rsmu: fix mixed module-builtin object
>   mfd: rsmu: turn rsmu-{core,i2c,spi} into single-object modules
>   net: liquidio: fix mixed module-builtin object
>   net: enetc: fix mixed module-builtin object
>   net: emac, cpsw: fix mixed module-builtin object (davinci_cpdma)




Please split this series and send them to each subsystem.
You can grab authorship for 08, 09
since most of the efforts came from you.


Thanks for helping with this work!





-- 
Best Regards
Masahiro Yamada
