Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2374692DE7
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBKDcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjBKDcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:32:42 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7363A088;
        Fri, 10 Feb 2023 19:32:41 -0800 (PST)
From:   =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1676086359;
        bh=gzBuoXGq9tQc5AaxNhk1VWOvumRFnGBblnycbvJWyFk=;
        h=From:Subject:Date:To:Cc:From;
        b=WYNsqOfKHKuu4lC79pCVMNesQpvp0pK1J+qFFrhoCXy/5YctOa2IJE/MM5Dn36nbj
         WItVOR/PAHwH+rBqNbIv7GJbzfVyo74LLYMgyfp/ifN5JF2DVayKM4kPEdcwSmiQeL
         nJ2AeK2q0WmLSPwp5EROdwaDKoyTmd5XN/2L/kyg=
Subject: [PATCH 0/3] net: make kobj_type structures constant
Date:   Sat, 11 Feb 2023 03:32:28 +0000
Message-Id: <20230211-kobj_type-net-v1-0-e3bdaa5d8a78@weissschuh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAE0M52MC/x2N4QqCQBAGX0X2dwveGYa9SoTc6WduySp3FoX47
 i3+nIFhNspIgkzXYqOEj2SZ1cCdCurGoA+w9MbkS1+V3jl+zfHZrr8FrFi5aYaLq851QO/Jmhg
 yOKag3WiVvqfJ5JIwyPeY3O77/ge63oVYdAAAAA==
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1676086354; l=856;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=gzBuoXGq9tQc5AaxNhk1VWOvumRFnGBblnycbvJWyFk=;
 b=xX0CkdDijrUBiNzg6vc3DnLgreltHIv4mngEpLKCXrKvVPpiEB3hy5yPX9JXK4wAPbYk7/OAk
 BcBpw3erVeFCvso6U5P8RezqihnY7RLGCCUIXL2/gM8Y3gAWHyvI3JH
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
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
Thomas Weißschuh (3):
      net: bridge: make kobj_type structure constant
      net-sysfs: make kobj_type structures constant
      SUNRPC: make kobj_type structures constant

 net/bridge/br_if.c   | 2 +-
 net/core/net-sysfs.c | 4 ++--
 net/sunrpc/sysfs.c   | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)
---
base-commit: 420b2d431d18a2572c8e86579e78105cb5ed45b0
change-id: 20230211-kobj_type-net-99f71346aed2

Best regards,
-- 
Thomas Weißschuh <linux@weissschuh.net>

