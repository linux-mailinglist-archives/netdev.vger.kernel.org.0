Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAD32ED30C
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 15:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbhAGOuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 09:50:13 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:51833 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727327AbhAGOuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 09:50:12 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 3923B1847;
        Thu,  7 Jan 2021 09:49:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 07 Jan 2021 09:49:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=FdIOkSGy3Q32J64k4
        wf1rEB8FQzvb72uodaVN4t5/FA=; b=XmxbSqq0OVwNymfH4VfSU+F1bit0co3a7
        I2XVLzjERh25Iv9JYHobrkBsvcbeheTDGr+qTwBCcGJ1JYndM4gsAxuWfnSP632K
        upo0nm5BttlNVWvkWl1paKv2tOQfum8kIffuz0jTfCH0v4nf2XL0I3ydvfi3OSY9
        GKsF6ZRqYoUP+6Mh8kQqxmuPHj64QHJCY6qvHH6D7kcj6lAHDnR4xMf6ttHvwdL4
        RM8yrB4cw/RLMIWmFteQRZV6Ash2i0VJDPrrGA956pf6qq9QVTUxK5iyBXVDPMaV
        kdOUiDYEereHMhFZI4025nuyvAkle6jImfRHVezKzrxWIW2JIeFnQ==
X-ME-Sender: <xms:YR_3X1phBS_XscgeuerS2m316TRGIbVQNK84lxr51658rnz7gl42fA>
    <xme:YR_3X786UUNBVkNQGkJL4_pPS2_vUMZRltjLtJw5lwrjYs3qFo-QG7L5wtsUuKKp2
    jmdHzL9xGcOJ-Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegvddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrgeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:YR_3XxVQBkriswiVu1_RA2cAbl1hdUJm2BeInnp_kGahVrmAw_FGZA>
    <xmx:YR_3X5Du0OsLDOmHiVr-caYSv78wkbSuqc1m_VVhGkw_v0YyDuKzCg>
    <xmx:YR_3X6z7iB9F2wdpoadCyqAJ66_j1FnDeDfyXhb1lRqGovkK05YS-Q>
    <xmx:YR_3X858_CWQs5TeS_lZP3M-tm2ucx8hm2JKa_qJRt_2iefh5n90fQ>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6EB821080063;
        Thu,  7 Jan 2021 09:49:03 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        dsahern@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/4] nexthop: Various fixes
Date:   Thu,  7 Jan 2021 16:48:20 +0200
Message-Id: <20210107144824.1135691-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This series contains various fixes for the nexthop code. The bugs were
uncovered during the development of resilient nexthop groups.

Patches #1-#2 fix the error path of nexthop_create_group(). I was not
able to trigger these bugs with current code, but it is possible with
the upcoming resilient nexthop groups code which adds a user
controllable memory allocation further in the function.

Patch #3 fixes wrong validation of netlink attributes.

Patch #4 fixes wrong invocation of mausezahn in a selftest.

Ido Schimmel (3):
  nexthop: Fix off-by-one error in error path
  nexthop: Unlink nexthop group entry in error path
  selftests: fib_nexthops: Fix wrong mausezahn invocation

Petr Machata (1):
  nexthop: Bounce NHA_GATEWAY in FDB nexthop groups

 net/ipv4/nexthop.c                          | 6 ++++--
 tools/testing/selftests/net/fib_nexthops.sh | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

-- 
2.29.2

