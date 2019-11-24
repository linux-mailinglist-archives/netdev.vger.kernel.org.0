Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB400108279
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 08:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfKXHtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 02:49:07 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41239 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725913AbfKXHtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 02:49:07 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 577DC2280F;
        Sun, 24 Nov 2019 02:49:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 24 Nov 2019 02:49:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=eyKqlumWIbcRLHhfr
        eVc52KkYBjAjuPXwtfFJD4fLco=; b=G5SqmYFyI4/zvq7ENY3YwTSrBf4gnNBrS
        JXH/OQcaLHzHsoqRnjousJsuq6lJ7RbnSJsntDUGJLqStVZWtp4IupCdYVOtRKbh
        6Vz1RkQKDWyO1CtctA+eopMoMbGSv6vu1dnCpyQIoPkqHlhYqVcDTpRE9vM8qVhY
        9st4JrmbVvFjdepRy90F7D5/bWJV/pwSFX92yIRp0faQO5UVMi4451maTQ3ge+uw
        IJ7g1cds/LcCIz9OmkcY2zQJvmGPC8vrbyvuvX5TRD991u80QsOYXf1KMusmh+7J
        xH388kG7SBom2WfDenN2eKm+HtTst4znnKZ2N+y9tmyHSM6yvz06A==
X-ME-Sender: <xms:8TXaXQB8OiCskwV1r_VTbZgf0IRKu7baVq4Gesny-crIee21shlR7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudehjedguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:8TXaXR36d7WoGbollnS5ROycXZkoMlSlpYYtuHkglXUyL9a4s8bFLA>
    <xmx:8TXaXahG0Ptx_MSr3-Pi3FJ7YSKplpTuwVOJGM-Vj67k0_14_L4Z4w>
    <xmx:8TXaXSHLrUlsL6C9-spSkBr8Gjh3O58n2fECY438lQ7RlCzL32Cymw>
    <xmx:8jXaXYhzwW5uyGftqqfoNHB6DF1r-26asok0AuFiyw0wKdvvWDhqkA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46B37306005B;
        Sun, 24 Nov 2019 02:49:04 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        jiri@mellanox.com, petrm@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/2] mlxsw: Two small updates
Date:   Sun, 24 Nov 2019 09:48:01 +0200
Message-Id: <20191124074803.19166-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Patch #1 from Petr handles a corner case in GRE tunnel offload.

Patch #2 from Amit fixes a recent issue where the driver was programming
the device to use an adjacency index (for a nexthop) that was not
properly initialized.

Amit Cohen (1):
  mlxsw: spectrum_router: Fix use of uninitialized adjacency index

Petr Machata (1):
  mlxsw: spectrum_router: After underlay moves, demote conflicting
    tunnels

 .../ethernet/mellanox/mlxsw/spectrum_router.c | 44 +++++++++++++++++--
 1 file changed, 40 insertions(+), 4 deletions(-)

-- 
2.21.0

