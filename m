Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C78B61465
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfGGIEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:04:01 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:37817 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGIEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:04:00 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8BA6C2ADF;
        Sun,  7 Jul 2019 04:03:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:03:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=WEkjxHYOTx75p2eOWkyXcn3Pa+rOtoXbtkGPgw1Ymlo=; b=OKsifsm1
        pjhYSXS/wHqABBwwvDJJxAcSXzQLx+/FaAZfeXKWIDi0nWxUc3sa80fnvT5LiL4D
        PL5/c+6ivELKZWn2S8yt/OBbQfiyxoPj1xWIks9les4Xpm58l6jEcQwAyOURY6oq
        wz5/kP/I1IAo1/P+SKRtIQ3z91CSBPUgWMXhds92SMsrCwKZzvcVTZPxsaik/hso
        V2Jnk77QIXjGLZ/rhVWQKYnt5Ga9SKEGHYxJlpvql14bUHdt9N0HEHH5UJkIAr9D
        Oq7jBos5fOmLubKqIm0Oeoce4Bq4of7j9kFlUwQiUSD+EjHQjWJwPaFigQcQGFft
        QFhXGKtadz4wYg==
X-ME-Sender: <xms:b6chXTm9F5F9l7Tu7wyH9H25SRvGmMWqgHNY8Qr4l2Drsq8jN5wpoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:b6chXdmWsKlRSBRvFn-p6RrxSgUjPgjb6N1oLDm_i-O2GpSB6mIyiQ>
    <xmx:b6chXRKKlPhxGYgv_SpJ2gSqjnZIUnl-VDOjwBETWU3IbaX6Mc-j8w>
    <xmx:b6chXZyZxZq1w1qxI5OzVATGNs0lRsdwr0mOZTgnSqEkLTAVDqMUtQ>
    <xmx:b6chXbMP4k4RZG3eovr06oswgXC9LI7Jdj58MZY8iB6s8qxMxJ6oFQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DB7688005A;
        Sun,  7 Jul 2019 04:03:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 0/5] selftests: Add devlink-trap selftests
Date:   Sun,  7 Jul 2019 11:03:31 +0300
Message-Id: <20190707080336.3794-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707075828.3315-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Patch #1 adds test cases for the generic devlink-trap infrastructure
over netdevsim.

Patch #2 mentions the previous patch in the devlink-trap documentation.
This is meant to serve as a reminder for people to add test cases when
the infrastructure is extended.

Patches #3-#5 add test cases over mlxsw.

Ido Schimmel (5):
  selftests: devlink_trap: Add test cases for devlink-trap
  Documentation: Add a section for devlink-trap testing
  selftests: forwarding: devlink_lib: Add devlink-trap helpers
  selftests: mlxsw: Add test cases for devlink-trap L2 drops
  selftests: mlxsw: Add a test case for devlink-trap

 Documentation/networking/devlink-trap.rst     |   9 +
 .../drivers/net/mlxsw/devlink_trap.sh         | 130 +++
 .../net/mlxsw/devlink_trap_l2_drops.sh        | 487 +++++++++++
 tools/testing/selftests/net/Makefile          |   2 +-
 tools/testing/selftests/net/config            |   1 +
 tools/testing/selftests/net/devlink_trap.sh   | 792 ++++++++++++++++++
 .../selftests/net/forwarding/devlink_lib.sh   | 125 +++
 7 files changed, 1545 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
 create mode 100755 tools/testing/selftests/net/devlink_trap.sh

-- 
2.20.1

