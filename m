Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B225F21F3C4
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgGNOVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:21:41 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50497 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726914AbgGNOVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:21:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 4416A5C0182;
        Tue, 14 Jul 2020 10:21:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 14 Jul 2020 10:21:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=R+glxvPwAFgTYMT6X5KW3SpzXPBJ+hNa3A9lkry5Ctg=; b=UV0pjYzy
        HtcGFYI2fDhjTCXdzUmVqdcYcBB2gYcSdta2WXrUUYEimJ4fLMSYDY6InlCi70wS
        OZtWqbwUyc3Gqf9/EW+vLNxBykR5O0x23c7brOhVnPeVO9AWIR7u+Z1+8qcZtoSh
        6S/dS0sxXt0kHXTIUPqNIFodgSBJkXSe17kpAbQJFQ/qZ+q3dx529FE3oJ+ZPwD9
        GiTbRq/tkL9rZ/Vwuo4Mw/Oea9uYryp5vMuPV+QfgvKy9nif68d8urQ4L89H4JDG
        tKVD1tZhIeXEs/QB5xILnQJUi5Sk+wDP2L0rHWjb2oiOmedUBpXxZXgkJNtxjPIi
        SjewAjnKUUv2lw==
X-ME-Sender: <xms:cb8NX3gkwEhys6arl75lUDYFWhVgvDHUUiceFbg3DPBkNmskEZ7H6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:cb8NX0BzKZGbiZZKGdrNDe065u4a3uQe2JuoEHZ899oNu2VttZPWtQ>
    <xmx:cb8NX3HqkcKs310Eh1bJs3Py3HmLxcTg4-wasI93Q6HROsvLl9uYEg>
    <xmx:cb8NX0TE0VM-6GaUponTaGHuTf7F2qjR6JW9AI1NyeLsJN68jVhp7Q>
    <xmx:cb8NXw-b96ISb5EJuGt0HCpuReLK2DETkevIHEYn2sPDBlmuyiPT4A>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 07DD330600B1;
        Tue, 14 Jul 2020 10:21:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/13] mlxsw: reg: add mirroring_pid_base to MOGCR register
Date:   Tue, 14 Jul 2020 17:20:55 +0300
Message-Id: <20200714142106.386354-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714142106.386354-1-idosch@idosch.org>
References: <20200714142106.386354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Allow setting mirroring_pid_base using MOGCR register.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index e460d9d05d81..6af44aee501d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9521,6 +9521,14 @@ MLXSW_ITEM32(reg, mogcr, ptp_iftc, 0x00, 1, 1);
  */
 MLXSW_ITEM32(reg, mogcr, ptp_eftc, 0x00, 0, 1);
 
+/* reg_mogcr_mirroring_pid_base
+ * Base policer id for mirroring policers.
+ * Must have an even value (e.g. 1000, not 1001).
+ * Reserved when SwitchX/-2, Switch-IB/2, Spectrum-1 and Quantum.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mogcr, mirroring_pid_base, 0x0C, 0, 14);
+
 /* MPAGR - Monitoring Port Analyzer Global Register
  * ------------------------------------------------
  * This register is used for global port analyzer configurations.
-- 
2.26.2

