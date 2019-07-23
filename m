Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72A507137C
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 09:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733021AbfGWH63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 03:58:29 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44425 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727528AbfGWH63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 03:58:29 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E9AAD2134B;
        Tue, 23 Jul 2019 03:58:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 23 Jul 2019 03:58:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xYMln6/InNcY49miH
        6rzPSuC+XsZBBctf5QS3CSnS8w=; b=ri1quCiy9kwOHmMqPMEd8MT8DG1DLgdb1
        NzTeootdWWIsRIKk6U5b7jCiXTe1eeaL6fVaRtbPmv3TJ362vsBnmGnz2UShBITd
        GOOtYukpiCVO12ka/x+djyxOyUu2fZvgcgDOiNIGCj4lr8lAvkt94A0OnKiKr4Ds
        NHAvqWAaYmex6RuM34z1rhu7AZKQbZGI9RB3pRJ2h5IbkXlsLdZdD5n65dz0ACCC
        xhWfgXEUvqww7uokfJLy59FwpyaMN0u0AQMeG9gmXZpSiGoiihC+oTOnXi0ty282
        pkQIdQAppGkH5ZhKyd6QBXQroH2yEalzwTtxRn40q+q4qxKC8GYeg==
X-ME-Sender: <xms:I742XTUrSAsQgwFT3f5uGisqfA6aho4kbORBo6xpa0ylMYne4xizaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeejgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:I742Xc2EQQtq6QZOeTFh19fe81U-dcvE-d-1OE1yPjEn-GQLSUOsqA>
    <xmx:I742XUt00SiUJrW9rF0AhfiGJjs_sL05jd_tLWp5TOwRvdvswZxEMg>
    <xmx:I742XcR3Bp46JN0vOtm5PZJkDEg9e_RAdhPYMbnKF_gK1Te1I0oZMw>
    <xmx:I742XR0Vm4TN58Ob1ngabe7DQWczheoezwv8AWRcixFaNsbUIF8ycg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F51B380086;
        Tue, 23 Jul 2019 03:58:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/2] mlxsw: Two small updates
Date:   Tue, 23 Jul 2019 10:57:40 +0300
Message-Id: <20190723075742.29029-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Patch #1, from Amit, exposes the size of the key-value database (KVD)
where different entries (e.g., routes, neighbours) are stored in the
device. This allows users to understand how many entries can be
offloaded and is also useful for writing scale tests.

Patch #2 increases the number of IPv6 nexthop groups mlxsw can offload.
The problem and solution are explained in detail in the commit message.

Amit Cohen (1):
  mlxsw: spectrum: Expose KVD size for Spectrum-2

Ido Schimmel (1):
  mlxsw: spectrum_router: Increase scale of IPv6 nexthop groups

 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 22 ++++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  4 ++--
 2 files changed, 23 insertions(+), 3 deletions(-)

-- 
2.21.0

