Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE433122A6
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhBGI15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:27:57 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:54961 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230048AbhBGIYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:24:43 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id C2CD85801A2;
        Sun,  7 Feb 2021 03:23:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Feb 2021 03:23:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=P+6Flxxk4YBtOYYJr60bm/Gmwnz7I3sRrLgsOnTSME8=; b=a5twqzF7
        F96GE+1a3eRRURt3mX6ka27SPY27gyN2vYclWM3u7Koh2hgCcoGclJW7KLcn4Aeb
        SIh9mt6u3qtbisoQb5izb/F+C5JX3XrzApLDMM+gKyhH4k6ZiWFNw8B/oBBn4Osm
        D5mPSdyMXcXLxjIYwHVGHzF39b2IoGdLM3YjKJ2r3O5KXjRG1SlO1SEz/wdoqssT
        2ia5SCaV8gopBE2RKWWIw6jlOhXA/EpeL8RuCLB50fFgjBOupMcW3hI8aYeruL/1
        cU5cOx/hfoLY+m4Kw7vDhppAoDHcCmxSMIOjGyemwVfPpxehrG7WVCs/fO3NkC6x
        MkJfsaU9DYuKdw==
X-ME-Sender: <xms:hqMfYAqE46NlJxgmBHBjMzAd_0E-fAzNuCwCXLZPGsw51mU_TZ-cuQ>
    <xme:hqMfYGpQrt04f2WRsrU4DZoFzO2rvLbyvIgMicOwn6I4URTQ_Owdzqd-QQ4BUtvRu
    C0-dT2xxHkl8bk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedtgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:hqMfYFPRjwQIbEQ2ZRy7tUTdHYwVwhFIDKljK9o1bjoIDF_4Xx5zWg>
    <xmx:hqMfYH4etF4kPp-rUOGcdFkVSTFWHxML35uDw92O4xCo-4A_JZbCdw>
    <xmx:hqMfYP7zgcIw4EBj52gawgSSszmposOPCGuEFe1HJV4vI4RYasVzZQ>
    <xmx:hqMfYJu0cXl6jEo6DbDQvdWE_9zsAtzS0u1PEDf5DNfRYVIuenkuZw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id D27EF1080064;
        Sun,  7 Feb 2021 03:23:31 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, yoshfuji@linux-ipv6.org, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/10] rtnetlink: Add RTM_F_OFFLOAD_FAILED flag
Date:   Sun,  7 Feb 2021 10:22:49 +0200
Message-Id: <20210207082258.3872086-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210207082258.3872086-1-idosch@idosch.org>
References: <20210207082258.3872086-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The flag indicates to user space that route offload failed.

Previous patch set added the ability to emit RTM_NEWROUTE notifications
whenever RTM_F_OFFLOAD/RTM_F_TRAP flags are changed, but if the offload
fails there is no indication to user-space.

The flag will be used in subsequent patches by netdevsim and mlxsw to
indicate to user space that route offload failed, so that users will
have better visibility into the offload process.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/uapi/linux/rtnetlink.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index b841caa4657e..91e4ca064d61 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -319,6 +319,11 @@ enum rt_scope_t {
 #define RTM_F_FIB_MATCH	        0x2000	/* return full fib lookup match */
 #define RTM_F_OFFLOAD		0x4000	/* route is offloaded */
 #define RTM_F_TRAP		0x8000	/* route is trapping packets */
+#define RTM_F_OFFLOAD_FAILED	0x20000000 /* route offload failed, this value
+					    * is chosen to avoid conflicts with
+					    * other flags defined in
+					    * include/uapi/linux/ipv6_route.h
+					    */
 
 /* Reserved table identifiers */
 
-- 
2.29.2

