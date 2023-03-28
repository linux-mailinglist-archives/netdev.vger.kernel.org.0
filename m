Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE2F6CB387
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 04:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjC1CDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 22:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjC1CDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 22:03:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBD82685;
        Mon, 27 Mar 2023 19:03:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97DBC6156F;
        Tue, 28 Mar 2023 02:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F85C433EF;
        Tue, 28 Mar 2023 02:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679969017;
        bh=6G2DYg8ELtbcds+HAzH8fVD7RX7HwcvzaOlUuI7kips=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OX6ScXGO6/rjGImEN7aRNFH3B2f7/2aBDNXKhKfqDPgJg+3VrxOY0NG5rJoxK7ZxW
         vVrYX2UbNF+502CXMPlTSLm933frp+X7XJ4XMlhHEMy4rbnzuB6VnzJzwJ8OKepnZb
         gZED4ue40ZcVTlTiGjd1ywtJmGLf4kLtONmtVNYhA2s1Oyu6hqVrnOvUnPbmj0dTP2
         cLumXnQh7MfGEyYmwbrdasOJqtI7NRc72ycgdgqq41PkEgVQZhI3j97prLV9X/5kak
         JXBkGLfpdYCADfJwaN4+XfwuKVKkq0ai8OyHm8Uvh8vta/obJBc7XSLjSgabAT/1oy
         ughYp2bWCDqlA==
Date:   Mon, 27 Mar 2023 19:03:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net 4/7] net: dsa: mt7530: set both CPU port interfaces
 to PHY_INTERFACE_MODE_NA
Message-ID: <20230327190334.6c5bcf87@kernel.org>
In-Reply-To: <8450084e-1474-17fa-32c2-a4653b74ff17@arinc9.com>
References: <20230326140818.246575-1-arinc.unal@arinc9.com>
        <20230326140818.246575-5-arinc.unal@arinc9.com>
        <20230327191242.4qabzrn3vtx3l2a7@skbuf>
        <8450084e-1474-17fa-32c2-a4653b74ff17@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Mar 2023 00:57:57 +0300 Ar=C4=B1n=C3=A7 =C3=9CNAL wrote:
> I don't appreciate your consistent use of the word "abuse" on my=20
> patches. I'm by no means a senior C programmer. I'm doing my best to=20
> correct the driver.
>=20
> Thank you for explaining the process of phylink with DSA, I will adjust=20
> my patches accordingly.
>=20
> I suggest you don't take my patches seriously for a while, until I know=20
> better.

Maybe my bad, I should have sent you a note on your previous series
already. The patches may be fine, but the commit messages need to do
a better job of describing what the goal of the change is, functionally.

For fixes the bar is even higher because, as Vladimir points out,
commit messages for fixes need to explain what user visible problem=20
the patch is resolving. Think of it as a letter to a person using the
switch who hits a problem and wants to look thru the upstream commits
to see if it's already fixed.
