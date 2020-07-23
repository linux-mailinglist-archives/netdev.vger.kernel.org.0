Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0D622ADF9
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgGWLnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:43:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728567AbgGWLnR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:43:17 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA68520B1F;
        Thu, 23 Jul 2020 11:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504597;
        bh=Fw24wTjhX6/veV0b6MJa4ylEAknEnmUlJ5/TqSGR07c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRMLtFzeJJK9jx4pu5W8ym16Q2atoYT4gcywh+FfskDt/ioaa3LhAyNrtxzjT3TzX
         rvTo0MxcXNLv65ELEx60lcKR/mtKvvweASEi9Z3Jx3eOADd9Y+XsS/rB0gpzwq8hg0
         /nZbEYAe7FKhIez4xIVQ7pzW5G7xr5EPHUv9mrOw=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 05/22] net: veth: initialize mb bit of xdp_buff to 0
Date:   Thu, 23 Jul 2020 13:42:17 +0200
Message-Id: <40621d3a47889b83eb79a4d519872f84c89dd558.1595503780.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1595503780.git.lorenzo@kernel.org>
References: <cover.1595503780.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize multi-buffer bit (mb) to 0 in xdp_buff data structure.
This is a preliminary patch to enable xdp multi-buffer support.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index b594f03eeddb..463865c513b2 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -711,6 +711,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	/* SKB "head" area always have tailroom for skb_shared_info */
 	xdp.frame_sz = (void *)skb_end_pointer(skb) - xdp.data_hard_start;
 	xdp.frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	xdp.mb = 0;
 
 	orig_data = xdp.data;
 	orig_data_end = xdp.data_end;
-- 
2.26.2

