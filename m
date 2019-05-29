Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAD932D727
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfE2IAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:00:02 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60179 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725956AbfE2IAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:00:02 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4435222033;
        Wed, 29 May 2019 04:00:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 29 May 2019 04:00:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZFcHGmdv8CeJgMFrf
        Qg11Pm8UjFXra8LQF94jqZk48g=; b=SVA6iCJjWZSFqNiqb4bPOZ1G30M8R1TZb
        2V4EdfM84qtnj7686ArnK5Iuhx9FSBqgEE17RyvKfVDpTglccHM4NaJlZNyyCEKO
        kXpXh/J3bYrqB3VxQZi5i3sBliXPTIdgvhfdmsQsiyl16hLWXzjOVtseYtAu5HJf
        BVlwd9a5y+W6EeeMpeuIq67WU5grSA7LqOzpuqFGpXu8XCVqVbthj0lTVBZDn2Bl
        b4fjNfTo0sC86Qa6/EWtqxEzLaqeK32Pfb5MLybD+1pn7t6b7noaKNmBxxlmjSFS
        9NflXHELrLbg0ITSWsklV4Lbpq3BQ16u23quauRkwuu93s4atlXxg==
X-ME-Sender: <xms:ADzuXEz3kcF0VCX3TErevJr4HjxR4kB6x0XcO_wu_qq5-llfg-K92A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddviedguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:ADzuXOQy-EnXJXnvrK63WwUGHYP8rZeJgRvxD0AvI-OkDDp17NrLww>
    <xmx:ADzuXD9531Lm3vgt3Hun3RgTI4PMOLy5_HE547ysxj9_55TD26GqCg>
    <xmx:ADzuXNqCA6ALxDUkJm96IxG8gfaZ6DLjQrWbBiVA0x_QtKXxTNeZXg>
    <xmx:ATzuXK3ffOpq8lCwxrNy7UMZClGEyPymjtjdKazT7Wo-7COekOImVw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7A6FD380088;
        Wed, 29 May 2019 03:59:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 0/2] mlxsw: Two small fixes
Date:   Wed, 29 May 2019 10:59:43 +0300
Message-Id: <20190529075945.20050-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Patch #1 from Jiri fixes an issue specific to Spectrum-2 where the
insertion of two identical flower filters with different priorities
would trigger a warning.

Patch #2 from Amit prevents the driver from trying to configure a port
with a speed of 56Gb/s and autoneg off as this is not supported and
results in error messages from firmware.

Please consider patch #1 for stable.

Amit Cohen (1):
  mlxsw: spectrum: Prevent force of 56G

Jiri Pirko (1):
  mlxsw: spectrum_acl: Avoid warning after identical rules insertion

 drivers/net/ethernet/mellanox/mlxsw/spectrum.c        |  4 ++++
 .../net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c    | 11 +++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

-- 
2.20.1

