Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 846028329B
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732032AbfHFNUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:20:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39401 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726036AbfHFNUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:20:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 34A9E22012;
        Tue,  6 Aug 2019 09:20:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 06 Aug 2019 09:20:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=81kYzvmMIQOtXBjR2
        DvWSgn3f3c4lQAtKfAQDT0a//Y=; b=k8S+FzT0fs7P5mZ5LE//tCnItxWbA8zin
        /l4xZoZxfUY71ydZTZ9yd8J7puF7VDdi7c+EKrpzggMu/vKNNpvqwkJrZhSuQyzP
        9nYgqc0K88LlQoKjhVHKO3/SYduel/OwSVUKunHCiNco9rhQlBLLTJs2Tyl2tuug
        27ZyeVnPhgOvhsTOnTZSXFqgcETpXtZKUQBn06WCU4v1jkuxNzp1lqjltFa40uoq
        Ij8gCBJ0SiDqlvCnynq6hWABmc9JtOsLtM/Cn6p3rWrZwbHLD/gsKE1RyG5ETGEY
        DLqJSfb6LbLzbnWz3pyE+bwYEAfe/0WecKLI2zPcM0TIA+teqqTNA==
X-ME-Sender: <xms:qn5JXbLCcU0-Z4IjiG-rBKghnPdG6tBQw2Dkpgzeys359NglNa45aQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddutddgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuffhomhgrihhnpehoiihlrggsshdrohhrghenucfkphepudelfedrge
    ejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihgu
    ohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:qn5JXd_dOlgdCSFgNyTf23-uJuSmbjONEgLPv7cyB-OwnssD3HKlpw>
    <xmx:qn5JXeZM7szT7pGiVh_YOr3ieWZs85a88xUWqUaxwmYTZ5md5KpwMQ>
    <xmx:qn5JXbfU77GvCrocxPbV1OJZg7DTOvQBSh3lBelvawFQTLJJM9M46A>
    <xmx:rH5JXQxYb2Txuok75zvyfjJp7bZ3aKaKfxvMDRdHOQTaTcl9JTuzSw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E3ED280068;
        Tue,  6 Aug 2019 09:20:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, toke@redhat.com,
        jiri@mellanox.com, dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/6] drop_monitor: Various improvements and cleanups
Date:   Tue,  6 Aug 2019 16:19:50 +0300
Message-Id: <20190806131956.26168-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patchset performs various improvements and cleanups in drop monitor
with no functional changes intended. There are no changes in these
patches relative to the RFC I sent two weeks ago [1].

A followup patchset will extend drop monitor with a packet alert mode in
which the dropped packet is notified to user space instead of just a
summary of recent drops. Subsequent patchsets will add the ability to
monitor hardware originated drops via drop monitor.

[1] https://patchwork.ozlabs.org/cover/1135226/

Ido Schimmel (6):
  drop_monitor: Use correct error code
  drop_monitor: Rename and document scope of mutex
  drop_monitor: Document scope of spinlock
  drop_monitor: Avoid multiple blank lines
  drop_monitor: Add extack support
  drop_monitor: Use pre_doit / post_doit hooks

 net/core/drop_monitor.c | 58 +++++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 20 deletions(-)

-- 
2.21.0

