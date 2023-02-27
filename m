Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CAF6A4A7A
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjB0TAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjB0TAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:00:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095F6136C7;
        Mon, 27 Feb 2023 11:00:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCA00B80BAA;
        Mon, 27 Feb 2023 19:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BBEC4339B;
        Mon, 27 Feb 2023 19:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677524449;
        bh=HwzmljqOzuBkijMnmzBYp637A8GdPOQuvWFinajEoGs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Do9qi4Aqw9yT2N03lqdKzOLbWdAURzY1FoAp85RpjLWWiUNFmwcZFsNkjamEhjjiy
         L1hsDSeDKLojst44RoHt9eTsAgo90AHn1TB4lyQHVYbdkGE13GtLQ0DYB6OZP6jrt4
         wOzJoBmRV+Zcgo3Wm7SkQUClpolLGIPWNc9aPlRLiDOeubhRhmv0VLsaO1ksVVH49V
         ZjqqvszxmjLBEDywaQZ4OphWlyxyxfIWqw64e4Nfs0pf6+gAN0Uellj4fVREIPXO+R
         lhd6lfglphM4od6+WExArZ7L0c28NNNzysn+lqYS6+RZI4FwZILQ/uw1YxxGu2RwGn
         /4UaamGjQid3Q==
Date:   Mon, 27 Feb 2023 11:00:47 -0800
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
Message-ID: <20230227110047.224909ee@kernel.org>
In-Reply-To: <e7628b89847adda7d8302db91d48b3ff62245f43.camel@mediatek.com>
References: <20230211083732.193650-1-yanchao.yang@mediatek.com>
        <20230211083732.193650-2-yanchao.yang@mediatek.com>
        <20230214202229.50d07b89@kernel.org>
        <2e518c17bf54298a2108de75fcd35aaf2b3397d3.camel@mediatek.com>
        <d6f13d66a5ab0224f2ae424a0645d4cf29c2752b.camel@mediatek.com>
        <20230224115052.5bdcc54d@kernel.org>
        <e7628b89847adda7d8302db91d48b3ff62245f43.camel@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Feb 2023 12:11:51 +0000 Yanchao Yang (=E6=9D=A8=E5=BD=A6=E8=B6=
=85) wrote:
> On Fri, 2023-02-24 at 11:50 -0800, Jakub Kicinski wrote:
> > Relative paths work, right?
> >  =20
> Okay. Change as follows, is that right?
> mtk_pci.h includes "mtk_dev.h",
> which is located in the parent folder.
> #include "../mtk_dev.h"
>=20
> mtk_fsm.c
> includes "mtk_reg.h", which is located in the child folder "pcie"
> #include "pcie/mtk_reg.h"

Yes, that's right.

> > > Any ideas or comments for this? Please help share it at your
> > > convenience. =20
> >=20
> > It's mandatory for new code. =20
> Okay. Change as follows, is that right?
> 	......
> 	ret =3D mtk_ctrl_init(mdev);
> 	if (ret)
> 		goto free_fsm;
> 	ret =3D mtk_data_init(mdev)
> 	if (ret)
> 		goto free_ctrl_plane;
>=20
> 	return 0;
> free_ctrl_plane:
>=20
> 	mtk_ctrl_exit(mdev);
> free_fsm:
> 	mtk_fsm_exit(mdev);
> exit:
> 	return ret;
> }

That's right, thanks!
