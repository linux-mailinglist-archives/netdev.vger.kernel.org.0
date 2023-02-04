Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF0068A999
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 12:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjBDLLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 06:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjBDLLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 06:11:35 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7886C46712;
        Sat,  4 Feb 2023 03:11:32 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 314B8FHF850235
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Sat, 4 Feb 2023 11:08:16 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 314B87aW2058955
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Sat, 4 Feb 2023 12:08:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1675508890; bh=Zqkm7aqyRCSQ+b3/N48+MN/w1oUlkwo8qxuzVoWUtTc=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=aRwiujNJky7pS3rdcMSKtorVQnmE+A6HTkwloMysn9lY6nBqmh5kbPXvYrKkFu85I
         IVIKFgi5Pw2syLj82IVoml1cH4B9SCwxKUUZdYCuUcpoJ6tY5m4ynGb/0H9bsA+0E9
         Ctu8Suw96sjUS/neba+GLYHZFXQZQQY0RSzocDMw=
Received: (nullmailer pid 392333 invoked by uid 1000);
        Sat, 04 Feb 2023 11:08:07 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
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
        Jianhui Zhao <zhaojh329@gmail.com>
Subject: Re: [PATCH 0/9] net: ethernet: mtk_eth_soc: various enhancements
Organization: m
References: <cover.1675407169.git.daniel@makrotopia.org>
Date:   Sat, 04 Feb 2023 12:08:07 +0100
In-Reply-To: <cover.1675407169.git.daniel@makrotopia.org> (Daniel Golle's
        message of "Fri, 3 Feb 2023 06:58:48 +0000")
Message-ID: <87h6w1r8mg.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Golle <daniel@makrotopia.org> writes:

> This series brings a variety of fixes and enhancements for mtk_eth_soc,
> adds support for the MT7981 SoC and facilitates sharing the SGMII PCS
> code between mtk_eth_soc and mt7530.

Thanks! I've now successfully tested this on an MT7986 board with 2.5G
phys (GPY211C) connected to one of the mtk_eth_soc macs and on port 5 of
the the MT7531.  The series fixes a number of issues for me, including a
mysterious packet drop at 1G only which I believe is related to the
undocumented MAC_MCR_BIT_12 in patch 5.

With Vladimir's (WiP?) "PCS and PHY in-band sync" patch set and your
related implementations in mxl-gpy, mt7530 and mtk_eth_soc to top of
this series, both 2.5G ports are now usable at any speed.

Note that the mt7530.c part of the series depends on=20
https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git/commit/?=
id=3D697c3892d825fb78f42ec8e53bed065dd728db3e
which is not yet in net-next. It appears to be destined for v6.2 so this
is not a problem.  Just mentioning it in case someone else is struggling
with the testing of this series.

Feel free to add

Tested-by: Bj=C3=B8rn Mork <bjorn@mork.no>

to the complete series.


Bj=C3=B8rn
