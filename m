Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C052823BEC8
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 19:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbgHDRVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 13:21:02 -0400
Received: from mout.gmx.net ([212.227.17.22]:33269 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729391AbgHDRVA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 13:21:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1596561629;
        bh=Xm96KhWFipnp8fHSl6yjWFA/cv3nb5aR+D9sTB7Q9DQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=XMFNeBE/s6ISNUdNbeuMDY9W86xY0QoxQ/+90CVOHJSbw2GwzY7Lb8bKhHtLy+vkk
         Il3LgUtHUPLuOZ6J2PW/Z3GLN4OBms/YUrzYuLn75Vn/Tw5D4DjLj+HopIFt8/9zv/
         zfocukZeUcSPLMQiBXmf0ed+5xmE+bp28Ey+HVKU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.144.119] ([217.61.144.119]) by web-mail.gmx.net
 (3c-app-gmx-bap28.server.lan [172.19.172.98]) (via HTTP); Tue, 4 Aug 2020
 19:20:29 +0200
MIME-Version: 1.0
Message-ID: <trinity-c649c75e-dd0a-4a92-9e88-e8668da0218c-1596561629490@3c-app-gmx-bap28>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-mediatek@lists.infradead.org,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Landen Chao <landen.chao@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Aw: [PATCH v4] net: ethernet: mtk_eth_soc: fix MTU warnings
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 4 Aug 2020 19:20:29 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20200804165555.75159-3-linux@fw-web.de>
References: <20200804165555.75159-1-linux@fw-web.de>
 <20200804165555.75159-3-linux@fw-web.de>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:e5KOynI+/rmWbuU9ZXSdr2OtpLUfZJDwrtcFmCyHYcfQVIktZj8UP54lT6kmijAyztwFJ
 yl/DkXGXQ9Km7aZjja8OXleAwTwC6f5x+7GrVb8EA4paejLAXDLRv8/fYbZ68ydyCLdtMM3yBdjH
 /q8jD73GgUR48Illv+r2TScJj6C3PviJBHLRqjUg33gd8KhkYp/xVBSvLtdpdbMx44jxft6Hpf85
 HF/O01uWs6rqiEp/w8+rwXYUEwoQOPVwPC426wQnR5ol7MjBq1vZJYL+5VCQiaajwa45QGffs1d+
 VM=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:fY8FUHPb9Ek=:Ua9iZ3Yg4RDjnNGD/ZPz/O
 hyYwHgepwofq66laYElGNV1ODrmQDlRHdDec0bu4wjLVSmg9x4bXgTU8kYNwAb3yL4YlcBG7q
 Tf4NFSYvsuux9HJtwMcLQS0fSa5iC2V3lN6C7jexawqn6QJUacH+vXJc503dwVncIlh6TcmRe
 7Ea0Sdven4PLpsNH+cAAwM9N+FfqG0hagPXgYSB+0MIxvGGSNcKc8mXJEzhAUEHZRx7Dxwosa
 M1YShXtqraCNNmNyeQoK17yiThA3lC/1HiGX31LCnSqr2er5/nOSqHplojHViohzu0gG4lWK2
 J9AUbBQZxwApFMX5ZD1xWaUPiMIR/Bpz6sNu2BJJzsf/JmYsjTi/qz8LB/ytj0kSmPvPsxUzz
 HZDQ8163owvPngnqgZvam6MmHCU+YPOlnQzYa5MNgsAQZXWFl/BO1IWCuXPHWPJk/cqPqva5A
 nEttbHAyAUDmVpgAyznV2mz8noGFTZ+om2Vy4gsgCj9doKTVElFOD43X32sIBqlaFo0rcocZa
 eAptwzH4b3tCmk8NX/qXJyjRGNAy9/z3FxhzQDXo3h5CaIuxvGIniDxFSou3xveZZfMo9e8po
 LCN9RojlegcSK9tF0jnhmC56V57vnUXfBknp+S3klp0y+yPPqh/fyfDTK8CbLdPjDusRJhpVl
 chOm+NtXkKLmTLE3TRRyC65EBNoTeOhGSduzTVxIGzFUTTs6ZOdDm3OSa/i6tF9TRgM8=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sorry, send this accidentally while posting my hdmi series v4 (have not deleted patch-file)
just ignore this...it's already merged

regards Frank
