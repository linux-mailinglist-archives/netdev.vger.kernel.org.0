Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA3B407613
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 12:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbhIKKaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 06:30:08 -0400
Received: from mout.gmx.net ([212.227.17.20]:39781 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235443AbhIKKaH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 06:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631356120;
        bh=kW2/XFCgLeQJ8pAdiZHbaLLR//IPNQFMApFkxDIZUaU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=WBtsBZQz4G7/paKCTF08Zb5U1QgauCNKCCBvanb6wH1x9zXRmsbI68y2CmpVblb5/
         DCnuY6avzo55meTZwHv0/vgqPtrkqRNlAJueAHSe7z0z6mkbUrN8Tc0pa0mzBN+uOi
         +zB3F/2TIfN6gn2kHWDi6e/S20kgBRV0pNu75rko=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.150.72.99]) by mail.gmx.net
 (mrgmx105 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1M1Hdq-1mNMcU11P0-002rAx; Sat, 11 Sep 2021 12:28:40 +0200
From:   Len Baker <len.baker@gmx.com>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Kees Cook <keescook@chromium.org>
Cc:     Len Baker <len.baker@gmx.com>,
        Colin Ian King <colin.king@canonical.com>,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH] net: mana: Prefer struct_size over open coded arithmetic
Date:   Sat, 11 Sep 2021 12:28:18 +0200
Message-Id: <20210911102818.3804-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dfVEWPwUfXk7WIDTAbTGVLjgPLhUDRc24p6xewK3GBqzbU6DrcU
 ykjnc9cNedQlmlg2HsTJDh+pa11ahYb6Y+2sPn51SUs8CNYG+ggGvmOsFmGmQQ77r9/a55S
 635XjyqZv/kz30sj90ZoUxbIdPhLVdwaip4p8XoRizgjtM4u7JfPsXt8t4JOwK4SDCTUtrm
 5Pzh+wyuAZy8g7EzyPK9w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:aaZQKqUHAsA=:5UH7+Vp9zv9Ebwsos2eXEL
 B9iNcka0v4OG7PMubbF6LdznXb4ErFlO61hZEhq9oGgckm3FJ5cKWQ6bC5ipCTI2+MA4SK92W
 caQsjELrtMbv2QGtFTKiDEXjhOrnNwJuRtMXY7SnPFkDvfQzrhvrnXPE4k8Dl6wZDlpOssnnB
 7Md6XCXwhXb8UkN+julAy9NVlC1bD2ntsojt+gzru8JEvgQKl+FEgmFC4rMiabvgWEFdpk6YT
 vSLGf110Znb6tr18K7NJuNP0gYe3Xf0QSIUt3X3dmhQ5Z28f1APyaDisfGrvg5McuOpxiriox
 oNr5gWttuw+wWB0KBjT6gy09FhBv8Wa2Snh1pHG2PKdqU6mYe0C5Lxk4TzHaDqVxye1tL6Pg7
 dO28z09KUC+EIgw6S8XgCQBVx7dm6oRNWqciRZxWO/7JgTCbaueHrnYtvOhaAhWIFpqM829r0
 9v8XeeePZO7B4DYIylStJa4mfNvq6jmLF5djc5DCcvi/gaTaiYD3vNk9/dXpq+TkKy/g+aEfA
 Z6A473KvK+Vk/6cFyb+9UUEWfvN82lv0L3ds3h/Al3c+OODzmxfT9D9a1G0PleRnBt6JqNAtW
 SlGpWhwEbBo57JGu09iPWi96i2Unng+YUswRioMXwko49w3MoRSAYVeTpADhUhm9OMqiD+gt1
 P+zM/eLcG2vo5UJ9FHqsJrek28qAXjmH4bp/2yHajA97YalRzcXzUvcXMYhWTAIjPP5LyDbO8
 Bm2/KgO8boMYnKYDBfPQczPSGkgDm6UD+aj6shCY9KfHj6iBLr98XGbnZYH715DHm8uN507bJ
 dnIZUXqBE9qkNQqSXlyiWymtlJinnByOgJeOwuaYYmUlnh9CRyb/k/plz86cTGBiEHUd+XDUr
 IZXEg0c18VaopPD1wCJHhpN1xg+lIsALJ+Mbg2hf5JutDHfznaK7mqEzMJkQYY+KejZyp6QZ9
 w0e5Nmfb7xkg3Al2NYG9jcEpuQFRTQP6OWFcEP5lAySuU5Y2cRE5He88sy4DYYaRprCEbEmCo
 4/aUvhJqiRUfnu8/v+kmZp/aNk2DG+fTaQnpzNkRq+yWLhCvmmS/gbJGYPrimhWlGMUk7KF3y
 4tVhgpYCBw4awQ=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As noted in the "Deprecated Interfaces, Language Features, Attributes,
and Conventions" documentation [1], size calculations (especially
multiplication) should not be performed in memory allocator (or similar)
function arguments due to the risk of them overflowing. This could lead
to values wrapping around and a smaller allocation being made than the
caller was expecting. Using those allocations could lead to linear
overflows of heap memory and other misbehaviors.

So, use the struct_size() helper to do the arithmetic instead of the
argument "size + count * size" in the kzalloc() function.

[1] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#open-cod=
ed-arithmetic-in-allocator-arguments

Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
 drivers/net/ethernet/microsoft/mana/hw_channel.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/ne=
t/ethernet/microsoft/mana/hw_channel.c
index 1a923fd99990..0efdc6c3c32a 100644
=2D-- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -398,9 +398,7 @@ static int mana_hwc_alloc_dma_buf(struct hw_channel_co=
ntext *hwc, u16 q_depth,
 	int err;
 	u16 i;

-	dma_buf =3D kzalloc(sizeof(*dma_buf) +
-			  q_depth * sizeof(struct hwc_work_request),
-			  GFP_KERNEL);
+	dma_buf =3D kzalloc(struct_size(dma_buf, reqs, q_depth), GFP_KERNEL);
 	if (!dma_buf)
 		return -ENOMEM;

=2D-
2.25.1

