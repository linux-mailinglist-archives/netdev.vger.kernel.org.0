Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645186A2283
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 20:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjBXTu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 14:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjBXTu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 14:50:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F343A4DE13;
        Fri, 24 Feb 2023 11:50:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2034B81D0C;
        Fri, 24 Feb 2023 19:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C358C433D2;
        Fri, 24 Feb 2023 19:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677268254;
        bh=DxSc5qyoJ3WetPubE5FBomItk0PCI3+VL+zlQed0ojE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tSH3us1vBbUCfEsZ6FMHC5txQio/GgPk3pwL4mgWsm2eWbEdeEVZuqyzPHEJf1Lv/
         41K7CyS5MK3Cquy3xwxCb73DyOY1UOnUh1OmK/TIPpTjgF9RlDgn7g22IWuhPcP7xl
         b8zSoq79YNCAG7T6jskr4k+7aqV1FWwCZgTehv/mAlnjw/6HGGqQ17gCcr56KkrONT
         3dQtOThgDyh8BmGRN64ucXCQZij41ySd9x0PyLyI/HGQhsZKMkdsTYRNOgA7yXd98e
         LSUGk8w2LmrLzZ8t8nUSGgNYtt+nkTPoCTrwKoJjOc5c3q4X/8djvfySzBldSZNJiw
         m89YMERgCba7w==
Date:   Fri, 24 Feb 2023 11:50:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Yanchao Yang (=?UTF-8?B?5p2o5b2m6LaF?=)" <Yanchao.Yang@mediatek.com>
Cc:     "Chris Feng (=?UTF-8?B?5Yav5L+d5p6X?=)" <Chris.Feng@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "Mingliang Xu (=?UTF-8?B?5b6Q5piO5Lqu?=)" <mingliang.xu@mediatek.com>,
        "Min Dong (=?UTF-8?B?6JGj5pWP?=)" <min.dong@mediatek.com>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        "Liang Lu (=?UTF-8?B?5ZCV5Lqu?=)" <liang.lu@mediatek.com>,
        "Haijun Liu (=?UTF-8?B?5YiY5rW35Yab?=)" <haijun.liu@mediatek.com>,
        "Haozhe Chang (=?UTF-8?B?5bi45rWp5ZOy?=)" <Haozhe.Chang@mediatek.com>,
        "Hua Yang (=?UTF-8?B?5p2o5Y2O?=)" <Hua.Yang@mediatek.com>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "Xiayu Zhang (=?UTF-8?B?5byg5aSP5a6H?=)" <Xiayu.Zhang@mediatek.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "Ting Wang (=?UTF-8?B?546L5oy6?=)" <ting.wang@mediatek.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Aiden Wang ( =?UTF-8?B?546L5ZKP6bqS?=)" <Aiden.Wang@mediatek.com>,
        "Felix Chen ( =?UTF-8?B?6ZmI6Z2e?=)" <Felix.Chen@mediatek.com>,
        "Lambert Wang ( =?UTF-8?B?546L5Lyf?=)" <Lambert.Wang@mediatek.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Mingchuang Qiao (=?UTF-8?B?5LmU5piO6Zev?=)" 
        <Mingchuang.Qiao@mediatek.com>,
        "Guohao Zhang (=?UTF-8?B?5byg5Zu96LGq?=)" <Guohao.Zhang@mediatek.com>
Subject: Re: [PATCH net-next v3 01/10] net: wwan: tmi: Add PCIe core
Message-ID: <20230224115052.5bdcc54d@kernel.org>
In-Reply-To: <d6f13d66a5ab0224f2ae424a0645d4cf29c2752b.camel@mediatek.com>
References: <20230211083732.193650-1-yanchao.yang@mediatek.com>
        <20230211083732.193650-2-yanchao.yang@mediatek.com>
        <20230214202229.50d07b89@kernel.org>
        <2e518c17bf54298a2108de75fcd35aaf2b3397d3.camel@mediatek.com>
        <d6f13d66a5ab0224f2ae424a0645d4cf29c2752b.camel@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023 07:39:33 +0000 Yanchao Yang (=E6=9D=A8=E5=BD=A6=E8=B6=
=85) wrote:
> > > Do you really need these flags? =20
> >=20
> > We will check and update if it's really redundant soon. =20
> Update test result.
> Both flags are deleted, then run the make command with=20
> "build in" and "build module" on a separate kernel tree. Both suffer
> the same build error.
> =E2=80=9Cdrivers/net/wan/mediatek/pcie/mtk_pci.c:16:10: fatal error: mtk_=
fsm.h:
> No such file or directory
>  #include "mtk_fsm.h""
> The reason is that all files are not placed in the same folder. The
> driver named TMI needs a child folder, then needs these flags.
>=20
> Any ideas or comments for this? Please help share it at your
> convenience.

Relative paths work, right?

> > > Labels should be named after action they perform, not where they
> > > jump
> > > from. Please fix this everywhere. =20
> >=20
> > We can found similar samples in kernel codes, naming the label per
> > where jump from=E2=80=A6
> > ex. pci-sysfs.c
> > shall we apply this rule to our driver?
> > I
> > t's mandatory or nice to have. =20
>=20
> Any ideas or comments for this? Please help share it at your
> convenience.

It's mandatory for new code.
