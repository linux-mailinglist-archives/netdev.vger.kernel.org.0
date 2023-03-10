Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515C86B3D53
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjCJLKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCJLKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:10:49 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16385103397;
        Fri, 10 Mar 2023 03:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678446616; i=frank-w@public-files.de;
        bh=EZaXAg8Hi+22u5PckssBr2DNSY4dcFwH+pwzQq5otbE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ScKdQX1qZJh4KopiTLhp46hhra4byA7Kj71PrsAJEvYVvHvZ7U/cdmNxxco/fCWi/
         fntGeI4538kjoLCyPCWfJKIIxjsXznEA/OXhQSk5B4ksG4ieIklcNELEhNOBogH2uO
         HREznRIGY5gIXAQiNewtpHYfm3BJhruNxi0SSNJWxW8q7XjpJ/AY8o0nN+qvkZ5JVE
         5EktPQajMU6e2I4dsilVMe1cNJwp24R+SdBbaKUvjXElb0Phy718rdJTWtP+pPfHHu
         sqAKfwZwE6Gd3qquwCI/oPLdAItgmNQGd+vXyzH3EVixEIGFUvtNFjLJNlvfcrfTSF
         Tx7fYDb6GIe7w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [157.180.224.176] ([157.180.224.176]) by web-mail.gmx.net
 (3c-app-gmx-bs21.server.lan [172.19.170.73]) (via HTTP); Fri, 10 Mar 2023
 12:10:16 +0100
MIME-Version: 1.0
Message-ID: <trinity-aab1c6ab-373d-4c3d-a646-fdcf6a327048-1678446616345@3c-app-gmx-bs21>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Aw: [PATCH net-next v13 10/16] net: ethernet: mtk_eth_soc: switch
 to external PCS driver
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 10 Mar 2023 12:10:16 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <b61d952d5e0719e0fc6cc3b1d3576ce9aa1444f5.1678357225.git.daniel@makrotopia.org>
References: <cover.1678357225.git.daniel@makrotopia.org>
 <b61d952d5e0719e0fc6cc3b1d3576ce9aa1444f5.1678357225.git.daniel@makrotopia.org>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:XkS1rj6utIKZO75KU6uhVOKHQxtSR3UHSlgHA3thjIaAdf5t8665UcFFxCb9LABtmc+bF
 IiYs+hwNAtwF8YUPK+q5Pz7tNHd1vCuPH1SF1fLuBN69ELIdwVcv3koNBwDDwlfsLCfMZIJlsqNV
 QOqL8vsRQVzLLLXZu/3iMVb71RyA3YnfbXvVizZJWx14ANM9IOCWssMqAL622LIXJKFq4wR+cU4e
 Tn5whN4nvJVyC/aK9jDsJDHNg6HSPme2gBlRdHN3NWnpDtjLs3kkK8YaLIKqLM4/W7V8l/oHW7JT
 g4=
UI-OutboundReport: notjunk:1;M01:P0:TWIsa/mN70E=;qPLa42hpJKl/UclSEwqE6Oqo++9
 rZrltKGWYSoaX+UonVZaAE85d5mloFch/+GM/y2ZtCU+cCuQfwHWnxbDlS4JmmCTPWaiunetn
 I1MaFCAP96mib4ol87YgnYEz3e5R+h0w5X/eSiABXWuiXvbwJZFNNovn8bW773ciKIz+J9hjN
 x7DBgBrygK3u38iSYnPYRfQEVEO9690FcadXzdM29TGuCLceky+HLQVak8Qx1JNeEYLQ6miBg
 K9FYA2+baFbE8Ti3o5kq85WqFnjR6Q8qb2O5Anxw2v8GX6/BEuHzuW9cUWh1VaL9AGF4M4uwO
 oy/XTbNUNBd5PXc+0FJWag1hSsCSMmkif2997EP8ea2Q3wV721pzPp5apV2JucNgV6zQ78kNJ
 LIcgE393ejaAdj5Ij4l6hLZi6SWsolnc5TxXIUHIkmVDgftaG5UdnwqoPuMrHJ1zHpxErfxIN
 faDMhhZZ+RXEiISmjGQLatYHlRQ06KXtI+AiY9oW72w2Sfl7bm/J7gOexzqIa42cwgjYA/RDk
 m3QvuYhhjx0QOJ4vLX9uqqWtSJFDkYRVGIBsfiPAL3tE+kGTr0PkXZLraOyfIBpyRZ8RmfnEY
 gGCrylnO8X0lzmhCTLpVie5jRkYAGyh4kNAPkHJbb/z2FIAI2vfv9aoW7mk9r6DsacnSOAebb
 K3CcI4y9yeojF0c+gmHMX1AN+CG7XZ+CnUPCJvKfkVUY39JpZuFltALrjJAny8zlgFh+WPXly
 MTuP9YZA79Iw5T+QWkTijebkD5y5pRf+4YjG0T76zONKkXw0hMZlsV9Ruh2m4kI3uA88wXcro
 EFjPh+YRDXqSJ+rZoF8rUv7g==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

have tested Parts 1-11 this on bananapi-r3 (mt7986) with 1G Fiber SFP (no 2g5 available yet) on gmac1 and lan4 (mt7531 p5)

Tested-by: Frank Wunderlich <frank-w@public-files.de>

Thx Daniel for working on SFP support :)

regards Frank
