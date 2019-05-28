Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45FD62C6A7
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfE1Mg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:36:28 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:48883 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727175AbfE1MgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:36:22 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9AA952339;
        Tue, 28 May 2019 08:26:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 28 May 2019 08:26:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Goc8G4/51pCBEAc7almDQ+EX1FmegAOC0emsCFLKNYw=; b=yAbA4Fjd
        fn2umahJFCGhZIeiufC6yQQYhu5j68GNvt6V0kyVUS1+gCoKNKo8DOOW0WxLmsPh
        trULDUI1hTIvF6/jet5st9UOzB7t3nyt3WLNNfSmlwTpBumNCi89WQaSm/9/AYk4
        j/j59wPy3IVV6DPNtx0zphCHM9AeY/zvLDIIGCRwsNh+WcJKXhxR32AJFrTVds+M
        aPfxkJLRUSbg2h9D6k1xF92eF8wyL5Di5DuGbK+GvAfTVz2AbjJ6/36nhhtqyLzL
        n0AwZlsFeDT7QS3y+jzyhAB/2ElcrOUSSMdf9MzFea4X/VwcX24cCBMR6nAqqcXv
        8q0agACgIVur/g==
X-ME-Sender: <xms:CSntXNcU9X476ooc8x6Te-zXsfD4yXhmQ7hbtn7jukNp7Srh1W9EJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:CSntXOKf1MT3kuxFBld8Vkz7vWn37BkleTIhn3ipw1K7aA2eWlvQHQ>
    <xmx:CSntXKvqhk4x2esPQLZoOCyFxZmmT_InmsEFeHKzGP9aTOjAeRjUig>
    <xmx:CSntXEIQnGUbEiXLa04EyVjNTloUPqrmObRIPmdthLhtjjWxbK4EfQ>
    <xmx:DSntXE88HejfXx_P_Dn4gi7W7omKF8BZ5S_2V2WHegC_WQo73kDzww>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4124B8005B;
        Tue, 28 May 2019 08:26:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH iproute2-next 0/5] Add devlink-trap support
Date:   Tue, 28 May 2019 15:26:13 +0300
Message-Id: <20190528122618.30769-1-idosch@idosch.org>
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

This patchset adds devlink-trap support in iproute2.

Patch #1 is just for convenience, so that people do not need to pull the
kernel headers themselves. Will be dropped for non-RFC version.

Patch #2 increases the number of options devlink can handle.

Patches #3-#5 gradually add support for all devlink-trap commands.

See individual commit messages for example usage and output.

Ido Schimmel (5):
  Update kernel headers
  devlink: Increase number of supported options
  devlink: Add devlink trap set and show commands
  devlink: Add devlink trap group set and show commands
  devlink: Add devlink trap monitor support

 devlink/devlink.c            | 543 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/devlink.h |  68 +++++
 2 files changed, 594 insertions(+), 17 deletions(-)

-- 
2.20.1

