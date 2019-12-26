Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 875A612AD89
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 17:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfLZQl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 11:41:57 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56225 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbfLZQl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 11:41:56 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B4EB521F41;
        Thu, 26 Dec 2019 11:41:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 26 Dec 2019 11:41:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=HsHW2yrzE1Ek2p2a+
        TrBt9pNtqcE5u6dFlyH8WmeKk0=; b=XmCFCKeg8/zlWMAzqL/W3col/+wy1Ttxl
        t7t7RFBhRtGCtZglXFnJFhvOFXHdpdjjJRlZFBw40MbCC3iM/u5l0gWGBBsNj0fZ
        hmBELsLS4doR1aefMDqpKCq+BHXMxdZBlgY2QSXVd5RiLn6xIwfD2HV9sWTJ+eQy
        Cmsb4VknvYDxaNDVLmkIoS0/Thi8rVDSxXpNrTWzsA69UL1b4VLMcLAcVwU1r/ND
        lBYzFCKsMqBzHbkscy0womvvnMbgp+sUeq0rzmf/KS10oFzRuM+wPdaMoOAlQFwm
        wQLNS7OSIEUlf4kZyF7eFJBGf1LYwwAwFJO4s2fg3e5tXV6EP3U4A==
X-ME-Sender: <xms:0-IEXpjZgpZbhsQjsAXz7cxBP29M8wICFDi1sU2rlOEHJab4ypyAzw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddviedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:0-IEXrvuwIgyBBUxmi78siGdjUALnDRK2-zyJFg0On4SU34oW268JA>
    <xmx:0-IEXjg-YY85JBCYdPAlV06rE40u-Z2gCSsybaC7vOCHciaZBPn_Ww>
    <xmx:0-IEXmfvt1994U7AUJb7Ndi-UKwFkJPzctt6KvH3Jiz77fQ17u7hgg>
    <xmx:0-IEXhiOPGW3liYsXx0uhUhGFjzgFkA0oUdbFjVqmX90koG3Fsr90w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 85DC8306080E;
        Thu, 26 Dec 2019 11:41:54 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/5] mlxsw: spectrum_router: Cleanups
Date:   Thu, 26 Dec 2019 18:41:12 +0200
Message-Id: <20191226164117.53794-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set removes from mlxsw code that is no longer necessary after
the simplification of the IPv4 and IPv6 route offload API.

The patches eliminate unnecessary code by taking advantage of the fact
that mlxsw no longer needs to maintain a list of identical routes,
following recent changes in route offload API.

Ido Schimmel (5):
  mlxsw: spectrum_router: Remove unnecessary checks
  mlxsw: spectrum_router: Eliminate dead code
  mlxsw: spectrum_router: Make route creation and destruction symmetric
  mlxsw: spectrum_router: Consolidate identical functions
  mlxsw: spectrum_router: Remove FIB entry list from FIB node

 .../ethernet/mellanox/mlxsw/spectrum_router.c | 318 ++++++------------
 1 file changed, 101 insertions(+), 217 deletions(-)

-- 
2.24.1

