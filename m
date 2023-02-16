Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1367699BEB
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 19:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjBPSKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 13:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjBPSKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 13:10:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C186505F8;
        Thu, 16 Feb 2023 10:10:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACD4162061;
        Thu, 16 Feb 2023 18:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7E4C433D2;
        Thu, 16 Feb 2023 18:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676571036;
        bh=uzqucx/LrtONslFI6zFbkjiUdWhRDsYoF6uZqjKaGG4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H/uqcPeB8dbJbIn7D3f3VvPmx47rdnEYXZcG/1/Lpz42f35J943dmqEqXlx0ix2+u
         r6tju1d882rjR9BYYS8VLBVynl+DskaRVSNsrxtS2vvXSScZgMMMEsiielqf6DM6Pw
         f1a/47K1E8Q3qx6AfFicoDeltN/tqcTjboJkTd3cVzQQP4C1mmSH1/WmUC5cl8Hvdg
         FKCmPpBys0M8KwplZRU5KyVvj97Lel/qufBoO7hF4AiSewxB924Hzs5xX4aQsxRM/b
         ULW5Gy2bTk6eHH+2nJ5SwKnCQDYRFcmhQ3+Q9gB/RVSH1dcGfjspq1Y1GpBgGRZxpL
         C/2ZKBfTNN/LA==
Date:   Thu, 16 Feb 2023 10:10:34 -0800
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
Message-ID: <20230216101034.3f742834@kernel.org>
In-Reply-To: <2e518c17bf54298a2108de75fcd35aaf2b3397d3.camel@mediatek.com>
References: <20230211083732.193650-1-yanchao.yang@mediatek.com>
        <20230211083732.193650-2-yanchao.yang@mediatek.com>
        <20230214202229.50d07b89@kernel.org>
        <2e518c17bf54298a2108de75fcd35aaf2b3397d3.camel@mediatek.com>
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

On Thu, 16 Feb 2023 12:50:44 +0000 Yanchao Yang (=E6=9D=A8=E5=BD=A6=E8=B6=
=85) wrote:
> > > +	pci_clear_master(pdev);
> > > +	mtk_mhccif_exit(mdev);
> > > +	mtk_pci_free_irq(mdev);
> > > +	mtk_pci_bar_exit(mdev);
> > > +	pci_disable_device(pdev);
> > > +	pci_load_and_free_saved_state(pdev, &priv->saved_state);
> > > +	devm_kfree(dev, priv);
> > > +	devm_kfree(dev, mdev); =20
> >=20
> > Why are you using devm_ if you call kfree explicitly anyway?
> > You can save some memory by using kfree() directly. =20
> devm_kzalloc(), devm_ioremap_resource(), devm_request_irq(),
> devm_gpio_request(), devm_clk_get()=E2=80=A6..
> They will be freed automatically
> when corresponding device is freed, so you don=E2=80=99t have to free them
> explicitly. This also make probe error easier to handle. Is it ok?

Yes.
