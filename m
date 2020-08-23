Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B41424EC1E
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgHWIHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:07:53 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44231 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727940AbgHWIHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 04:07:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B96A15C00CA;
        Sun, 23 Aug 2020 04:07:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 23 Aug 2020 04:07:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=feTHXC/jMTaLFJL/SEA0AeqtmTxHLnANZTnGVSBUMi4=; b=DTHcVJrT
        6mXS/Al61sX9b/TaJgcT7YmeTG2JNpptsS058ONSRqfla7SY0O/M7cp5GDJeqRoQ
        n7oDr0LrJVIePwt9pk5JavRiOOjOBEN3LLwGUHbe2wO26W/RLyNelaLCmmrAHol7
        AkRSnqV/aXoEflhHI3VMs1c+xspEzl9bRP+7j6DqEK/JykzX4hwXh5S8QFS5lMWG
        AJxw7cHPWFViiJJGXYMSiu6J1yW2ZfXlkWYg56bToavQDmDW/qX1/lt45b885+Yp
        iscWBmqpP6UlxcwVgcHVp0g6oPJe2/Vl+KGlRNYDkTLtLR0ZB+TEXOB0R0goGhL/
        p6jTKSz+hjIYFA==
X-ME-Sender: <xms:0yNCX2PSr7pAuEMfYeiTLLDurRjlIozP9kdDWOE7eqCIJ9J1iIXRaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhefgtd
    fftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeekrddufedurdefheenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:0yNCX0-iG4kDtGu58YJWXnznJMk8N4448XkuS3VcCJAaOntCrxY0vw>
    <xmx:0yNCX9Rty05bbTKRq9viZNQooXPMo9SkBK--QVScF0PuSVdM2O2jyQ>
    <xmx:0yNCX2unna2eWhEo2-71mmY-EsJlNQvA16CRIa5-v5ZU1Ev4vQWB6g>
    <xmx:0yNCXyEVHA-SJzXdIB1WtG72zRHXshglswqlNovu0Df6aVf2sDpRRQ>
Received: from shredder.mtl.com (bzq-79-178-131-35.red.bezeqint.net [79.178.131.35])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B4F83280059;
        Sun, 23 Aug 2020 04:07:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/7] selftests: mlxsw: Decrease required rate accuracy
Date:   Sun, 23 Aug 2020 11:06:23 +0300
Message-Id: <20200823080628.407637-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200823080628.407637-1-idosch@idosch.org>
References: <20200823080628.407637-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

On Spectrum-{2,3} the required accuracy is +/-10%.

Align the test to this requirement so that it can reliably pass on these
platforms.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/devlink_trap_policer.sh       | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh
index 47edf099a17e..bd4ffed1cca3 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh
@@ -220,8 +220,8 @@ __rate_test()
 
 	rate=$(trap_rate_get)
 	pct=$((100 * (rate - 1000) / 1000))
-	((-5 <= pct && pct <= 5))
-	check_err $? "Expected rate 1000 pps, got $rate pps, which is $pct% off. Required accuracy is +-5%"
+	((-10 <= pct && pct <= 10))
+	check_err $? "Expected rate 1000 pps, got $rate pps, which is $pct% off. Required accuracy is +-10%"
 	log_info "Expected rate 1000 pps, measured rate $rate pps"
 
 	drop_rate=$(policer_drop_rate_get $id)
-- 
2.26.2

