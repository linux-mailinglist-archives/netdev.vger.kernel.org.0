Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1BE2C681
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfE1MbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:31:21 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:55557 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726974AbfE1MbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:31:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D04DE1E2;
        Tue, 28 May 2019 08:22:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 28 May 2019 08:22:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=fCjZ3E6f0rzOz9DRO9S9e6OwIcEgxSGgXEMHtbxO7+E=; b=5cJz+O6k
        vDLpbT5cNbdXLBca7A8thoelqGIr8ZiNw6BVlY12vy5IFg1Crzdc6y5K7Axk1AVh
        rSHA6t08NSEF3xMtKM5HMfoXDetCDrUoRlVAxx1bZ3cjJwx2u7KteEDzSsBHlYrY
        FzuBuGQmwxPUZ7vHt87LDuhCcDVlSS1ezuDCaw5ouxZreQcA/mIEdNFx2qYrShPv
        vDkm60+kp0mP6OOc+/06Um89Rf+hw0GBbT2KXHcJ/29oUtiVNYkDqLK/ENp0C/eY
        TV1bx//1aSzaU59acEm0kaB4Q72PCUlRpQhTfktvdWcK2BkojICQYVZugyLQzc2+
        LulAe+qgx8LX7g==
X-ME-Sender: <xms:ICjtXAdNGKYr_VowhXrSyPzZf0BtOYX5QXYH-n_jRThdRblt0McxrQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:ICjtXJHLX-dJtGEQj1UVbo-JFRkOJYmltbjq-46zArpZfhw_t9h2LA>
    <xmx:ICjtXLOEgKVuPhTkPw3fixYlcp8lyXrngEnWtmlHSC_Z3iAnh4lSyQ>
    <xmx:ICjtXJ57XiOavSrZ_T91E1ar0ZYOzkAIP55ox0JSBz7YH-FGsBus4A>
    <xmx:ICjtXGTM8ZQnNfS6W9RlrvXI49xkfVJRFrn5XFNyJ8DAEiBGf05Y2g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 33E90380089;
        Tue, 28 May 2019 08:22:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 09/12] mlxsw: reg: Add new trap action
Date:   Tue, 28 May 2019 15:21:33 +0300
Message-Id: <20190528122136.30476-10-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190528122136.30476-1-idosch@idosch.org>
References: <20190528122136.30476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Subsequent patches will add discard traps support in mlxsw. The driver
cannot configure such traps with a normal trap action, but need to use
exception trap action, which also increments an error counter.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index e8002bfc1e8f..b4c9c7edd866 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5429,6 +5429,7 @@ enum mlxsw_reg_hpkt_action {
 	MLXSW_REG_HPKT_ACTION_DISCARD,
 	MLXSW_REG_HPKT_ACTION_SOFT_DISCARD,
 	MLXSW_REG_HPKT_ACTION_TRAP_AND_SOFT_DISCARD,
+	MLXSW_REG_HPKT_ACTION_TRAP_EXCEPTION_TO_CPU,
 };
 
 /* reg_hpkt_action
@@ -5439,6 +5440,7 @@ enum mlxsw_reg_hpkt_action {
  * 3 - Discard.
  * 4 - Soft discard (allow other traps to act on the packet).
  * 5 - Trap and soft discard (allow other traps to overwrite this trap).
+ * 6 - Trap to CPU (CPU receives sole copy) and count it as error.
  * Access: RW
  *
  * Note: Must be set to 0 (forward) for event trap IDs, as they are already
-- 
2.20.1

