Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313B76957E1
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 05:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjBNEXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 23:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjBNEXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 23:23:20 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B247C17CCC;
        Mon, 13 Feb 2023 20:23:19 -0800 (PST)
From:   =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1676348597;
        bh=COVcQB5cR6h89Wr/2J1rv/M31I/gbeQf6njLyVKwSIM=;
        h=From:Subject:Date:To:Cc:From;
        b=E8NFdE44PufttVZMbbCzPFCjNkIW64yBxlo4sJ076a5J/345Syyya9BaKdHxf9HcS
         p1a42BsThSSLSWd+RKYCTKUjV7wS64PblTpkxX49I2xARHiMuFaFZIs3VD40UJh3Rw
         SZW6o2fvvcKnXlNIO8vWIanZ14fjvoKaZEGmp+WQ=
Subject: [PATCH net-next v2 0/2] net: make kobj_type structures constant
Date:   Tue, 14 Feb 2023 04:23:10 +0000
Message-Id: <20230211-kobj_type-net-v2-0-013b59e59bf3@weissschuh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAK8M62MC/3WNTQ6CMBBGr0JmbQ0tKuDKexhiWjrYKmlJpyCEc
 Hcre5ffz8tbgTBYJLhmKwScLFnvUhCHDFoj3ROZ1SmDyEWRC87Z26vXIy4DMoeR1XVX8uJ0kag
 FJEZJQqaCdK1JlBv7PpVDwM7Ou+QOP8rhHKFJi7EUfVh2+8T3/Y9o4ixnWCgt5VlXsqxuH7RE1
 JrRHNMBmm3bvhJeK/jOAAAA
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1676348594; l=897;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=COVcQB5cR6h89Wr/2J1rv/M31I/gbeQf6njLyVKwSIM=;
 b=mzJZEHszcanAOUqAskTyY8zp/N2ygwkPwET7vB6F566gjMRd1fsDdE1lDINz6C/IzArbj7Pux
 QLn3gil8v5CBhjijG9ctohjQrB1DvCy2GToIrTo8seYprEPPypyg707
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.")
the driver core allows the usage of const struct kobj_type.

Take advantage of this to constify the structure definitions to prevent
modification at runtime.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
Changes in v2:
- drop sunrpc patch from series
- use "net-next" patch prefix
- Link to v1: https://lore.kernel.org/r/20230211-kobj_type-net-v1-0-e3bdaa5d8a78@weissschuh.net

---
Thomas Weißschuh (2):
      net: bridge: make kobj_type structure constant
      net-sysfs: make kobj_type structures constant

 net/bridge/br_if.c   | 2 +-
 net/core/net-sysfs.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)
---
base-commit: f6feea56f66d34259c4222fa02e8171c4f2673d1
change-id: 20230211-kobj_type-net-99f71346aed2

Best regards,
-- 
Thomas Weißschuh <linux@weissschuh.net>

