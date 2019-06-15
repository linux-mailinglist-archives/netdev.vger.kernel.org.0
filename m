Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4093F4704D
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfFOOJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:09:20 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39959 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbfFOOJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:20 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8500521EAE;
        Sat, 15 Jun 2019 10:09:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=mJ50WNQT/ltCGC83dPmi/YXk07Zibsi4X4KbK/0zQ0A=; b=yEhiu8Wm
        C5iZ55zI2sWmNbFynnNCIiasBnkUJA+ilIgoDhHd6uhnIO1ehd2/6idczLnWg5jV
        7zq7l0XtlDmoDoz8ecn8X6Z4EZIdU0/d2tNFtS2sM5tF90LOk62ARTKv8a0dFJoF
        cJqzFqO04wh+VafsAsp1KBzBH0fpvgEzmeijK/GN2rPivowgCXwO6/FKd3L2f19S
        JfyrsREaUJ2xmXNQE+HPERu+k16/krIwdUyp4BMPfXSVQJEK8I0uL0WykbHWPVzA
        WI8OvzDD7Hcpp6PCmCzqQrXaA1yfPEtWycvnvKG5NlncxfncTuJ/0/pBB+MgSgyI
        /spaxjG9VGgS/w==
X-ME-Sender: <xms:D_wEXYANlCDLXfY5prQpIKgH1HLRaFtBaYGEYSNaanofj7S8EO8VnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepvd
X-ME-Proxy: <xmx:D_wEXR-3_AbUEERWsPzNP5s1zvflC9rEzRKki0ZurYiXfrwUc0Qehg>
    <xmx:D_wEXY_aMe340fdk8F3MP_E500JSNxk5A1kjidfGwTVocKNIqHWKiQ>
    <xmx:D_wEXYcMNS8XeqZ0h-XeRUu10bfceIc3BZGKRNbZ8bgWtNO3uION-g>
    <xmx:D_wEXZOd5MQD0PgVc394YuczNlYA1-zj5XyLNjBQ6M7CWpxUXjv-zw>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id B1617380085;
        Sat, 15 Jun 2019 10:09:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/17] mlxsw: spectrum_router: Ignore IPv6 multipath notifications
Date:   Sat, 15 Jun 2019 17:07:38 +0300
Message-Id: <20190615140751.17661-5-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190615140751.17661-1-idosch@idosch.org>
References: <20190615140751.17661-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

IPv6 multipath notifications are about to be sent, but mlxsw is not
ready to process them, so ignore them.

The limitation will be lifted by a subsequent patch which will also stop
the kernel from sending a notification for each nexthop.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 23f17ea52061..99a2caccd0fe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6136,6 +6136,8 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 				NL_SET_ERR_MSG_MOD(info->extack, "IPv6 route with nexthop objects is not supported");
 				return notifier_from_errno(-EINVAL);
 			}
+			if (fen6_info->multipath_rt)
+				return NOTIFY_DONE;
 		}
 		break;
 	}
-- 
2.20.1

