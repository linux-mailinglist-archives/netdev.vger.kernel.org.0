Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1149B1A42BE
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 08:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgDJG4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 02:56:32 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54700 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgDJG4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 02:56:32 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200410065630euoutp02ccc8ca5f04ffe529e3f13df69d699faf~EYvkRnaDq1658116581euoutp02g
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 06:56:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200410065630euoutp02ccc8ca5f04ffe529e3f13df69d699faf~EYvkRnaDq1658116581euoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586501790;
        bh=h6kHdF36KlMhhIttdgbrFEFBfvLBXZhJBNFT7k81pr0=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=YAKcxORkT7rAOZMq18y9dVUKWjiCt4CluS7spfX9sVEMNKENsHvlHJ8wOWrLFI5Se
         /wkYE7tfnmC4Q0ga3xEYTxymu1Uv+sZYL1yko7kb4c29jWNy/B/SwgatcztN1/o0rl
         DSarDwzskmks8PymIYk5WOoC+JfHdxE/NcIOtCns=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200410065630eucas1p212c67b5c2b21e8d7f753648fb9454d76~EYvjuC-VB2651126511eucas1p2N;
        Fri, 10 Apr 2020 06:56:30 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id C4.8C.60679.D98109E5; Fri, 10
        Apr 2020 07:56:29 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200410065629eucas1p19d2da846cc0341f2787dbe55c3fb2e7c~EYvjfZjhm0617506175eucas1p13;
        Fri, 10 Apr 2020 06:56:29 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200410065629eusmtrp132b2d3653fb3f8377f2aae9b529e6d07~EYvjenj3G1365613656eusmtrp1f;
        Fri, 10 Apr 2020 06:56:29 +0000 (GMT)
X-AuditID: cbfec7f4-0cbff7000001ed07-f0-5e90189dcece
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 85.62.07950.D98109E5; Fri, 10
        Apr 2020 07:56:29 +0100 (BST)
Received: from [106.210.85.205] (unknown [106.210.85.205]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200410065628eusmtip189221fbe002bd346ad052cfa220c942b~EYvidkuLs0224102241eusmtip1I;
        Fri, 10 Apr 2020 06:56:28 +0000 (GMT)
Subject: Re: [RFC 4/6] drm/bridge/sii8620: fix extcon dependency
To:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>
Cc:     Jernej Skrabec <jernej.skrabec@siol.net>,
        Leon Romanovsky <leon@kernel.org>,
        Jonas Karlman <jonas@kwiboo.se>,
        David Airlie <airlied@linux.ie>, netdev@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>, linux-rdma@vger.kernel.org
From:   Andrzej Hajda <a.hajda@samsung.com>
Message-ID: <ff7809b6-f566-9c93-1838-610be5d22431@samsung.com>
Date:   Fri, 10 Apr 2020 08:56:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200408202711.1198966-5-arnd@arndb.de>
Content-Transfer-Encoding: 7bit
Content-Language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0yNYRz2nu9yvo4OX6fotxg604aNLsRrcpbN5tv8gb9MOBz6FtOF8ylq
        Ni2hOp10XXVKa11UZFqJyjQO66KpFuU0WUeXU1GiC7qhc76a/nve5/c87+953r0MoZijXJjz
        wZd5bbAmUEnLyCd1Uy1b70Ki2mMw1QfrmxsleC65ToqzW6JJ/H5ylMbtv4YI3DjcTuKxDh3C
        sUkFUpw6XUjgdzXZNLYY9SSuHPomwZ/NJgobE47jutzVOGdwkMbp+hHC14GbmU5G3KjpppR7
        XNIp4SwNt2kuKyaT4srvx9JcQ2KbhHv600xx3br6+Wn6Kwn3Qp9CcuPl6w7b+8l8/PnA82G8
        1l11Wnbui/kNebGQuZo39lUaiQzSOGTHALsDEmYmiTgkYxRsMYLf8bWUeJhA8DzuEy0exhEM
        l2aSi5YPlgKbXcEWIZh9sFMUjSLon8ifFzGMI+sL8f0qq8aJ1SFISjpq1RBsJAlFumybmWY3
        w1xFJ23FclYFAzdLbZhk3eCNPouw4lXsSWjuMVGixgEaM/tsIexYbygv/WXjCXY9PB3JJkTs
        BKaeaGRdBuxDBtr/vqLE1Pvhqz4WidgRvtQ/XniAtdCUEr/Q7Dp0F0cTojkGQWVZNSEO9kBX
        8zRtbUbMp35U4y7S+2AqJ4Gw0sCuANOIg5hhBSQ/SV+g5RBzSyGqXaH7beXChc5Q2DpJJyKl
        YUkzw5I2hiVtDP/35iLyPnLmQ4WgAF7wCuavbBM0QUJocMC2syFB5Wj+Uzb9qZ+oQjWzZ4yI
        ZZDSXu6x7I5aQWnChPAgIwKGUDrJD0bp1Qq5vyY8gteGnNKGBvKCEa1hSKWzfHve0EkFG6C5
        zF/g+Yu8dnEqYexcIlFRxvsBf6PrxoFdCvNLd6/e70a1y4ZGh49RXlOqlc/OmlvL7lYMj3rM
        eXbMtFzrYKqS0/Ld3DL2Cg27LbOH/H5E3fP3znPeKlPSxonPfv1t64/o2yTVx9Iaem8M9Nde
        uDQdsa9bzSz3rDpwoiRhZ4SdalNoxFBfV3WWhWpten2nVqckhXMazy2EVtD8AwGzG9CQAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t/xu7pzJSbEGbyfr2vRe+4kk8XfScfY
        Leacb2GxuPL1PZvF1e8vmS1OvrnKYvHpWjejRefEJewWU34tZba4vGsOm8WzQ70sFltfvmOy
        ePjgBqvFob5oi2MLxCzmvXjBZjG99y2zg6DH71+TGD3e32hl99iy8iaTx7MT7Wwesztmsnps
        WtXJ5nFiwiUmj+3fHrB63O8+DpSdfpjJ40DvZBaPz5vkAnii9GyK8ktLUhUy8otLbJWiDS2M
        9AwtLfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DJePTjFUrCUo2LRp9fsDYyz2LsYOTkk
        BEwkrj9bAmRzcQgJLGWUuPvlGVRCXGL3/LfMELawxJ9rXWwQRW8ZJe41nQUq4uAQFnCQ6Hlq
        BxIXEehmlPi5fTELiMMs0MQiMWfKMVaIjs2MEnv6m8BGsQloSvzdfJMNxOYVsJN43roGzGYR
        UJU41TsbrEZUIFaiv3k3I0SNoMTJmU9YQGxOAVOJTWu+s4LYzAJmEvM2P2SGsOUltr+dA2WL
        SNx41MI4gVFoFpL2WUhaZiFpmYWkZQEjyypGkdTS4tz03GIjveLE3OLSvHS95PzcTYzA9LDt
        2M8tOxi73gUfYhTgYFTi4TVg6I8TYk0sK67MPcQowcGsJMLr3dQbJ8SbklhZlVqUH19UmpNa
        fIjRFOi5icxSosn5wNSVVxJvaGpobmFpaG5sbmxmoSTO2yFwMEZIID2xJDU7NbUgtQimj4mD
        U6qB8VBW4C6JqTfdX+9+/XNlxvRjKR3y/d7X7Se3bjbdcqWXvfXS/Bkej9x/8f2dsGF/6wWj
        qS91gh+0XUtcfHRRFVvQhiMhq9ednPqzWnr2AsaS5DMllwX8GVy/5+Y/ydnlPu3R37e2EVfu
        hP2KOXRv/eKPOo/eF/Ru2VAWlP9kgYD6+2lr9uQXbn2vxFKckWioxVxUnAgAJGrOfCUDAAA=
X-CMS-MailID: 20200410065629eucas1p19d2da846cc0341f2787dbe55c3fb2e7c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200408202802eucas1p13a369a5c584245a1affee35d2c8cad32
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200408202802eucas1p13a369a5c584245a1affee35d2c8cad32
References: <20200408202711.1198966-1-arnd@arndb.de>
        <CGME20200408202802eucas1p13a369a5c584245a1affee35d2c8cad32@eucas1p1.samsung.com>
        <20200408202711.1198966-5-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08.04.2020 22:27, Arnd Bergmann wrote:
> Using 'imply' does not work here, it still cause the same build
> failure:
>
> arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/sil-sii8620.o: in function `sii8620_remove':
> sil-sii8620.c:(.text+0x1b8): undefined reference to `extcon_unregister_notifier'
> arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/sil-sii8620.o: in function `sii8620_probe':
> sil-sii8620.c:(.text+0x27e8): undefined reference to `extcon_find_edev_by_node'
> arm-linux-gnueabi-ld: sil-sii8620.c:(.text+0x2870): undefined reference to `extcon_register_notifier'
> arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/sil-sii8620.o: in function `sii8620_extcon_work':
> sil-sii8620.c:(.text+0x2908): undefined reference to `extcon_get_state'
>
> I tried the usual 'depends on EXTCON || !EXTCON' logic, but that caused
> a circular Kconfig dependency. Using IS_REACHABLE() is ugly but works.

'depends on EXTCON || !EXTCON' seems to be proper solution, maybe would be better to try to solve circular dependencies issue.

Regards
Andrzej


