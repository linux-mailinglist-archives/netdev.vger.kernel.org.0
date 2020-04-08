Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2ED1A2040
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 13:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbgDHLvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 07:51:39 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29559 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727797AbgDHLvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 07:51:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586346697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S0LfGJC0m/z5ycd9bGypauRvqS14S05A+ZIX9gPGZiI=;
        b=Wv6eqZmbfb0aBSjJVZn3TQfQtN9lsKSQonT+gXk1taOIu7B1Kjw7s7akynJSxBwZJP+vne
        Ujf2jmVkJ2MMnd3e3torCu6elJQtMepgIMF3slNWvz/9xl1WwnnSjpZXgESH+rxGojag9L
        4wL7WcQ1EkR+04bXenr6T3eN5YuRj90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-kZesqyS8OrCjDKVmbfauuw-1; Wed, 08 Apr 2020 07:51:34 -0400
X-MC-Unique: kZesqyS8OrCjDKVmbfauuw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80F79801E7A;
        Wed,  8 Apr 2020 11:51:31 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26135396;
        Wed,  8 Apr 2020 11:51:31 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 3F96C300020FB;
        Wed,  8 Apr 2020 13:51:30 +0200 (CEST)
Subject: [PATCH RFC v2 11/33] dpaa2-eth: add XDP frame size
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Date:   Wed, 08 Apr 2020 13:51:30 +0200
Message-ID: <158634669018.707275.10848065889032545992.stgit@firesoul>
In-Reply-To: <158634658714.707275.7903484085370879864.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the full page size:
 #define DPAA2_ETH_RX_BUF_RAW_SIZE	PAGE_SIZE

Cc: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index b6c46639aa4c..d05c60e2da9c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -301,6 +301,7 @@ static u32 run_xdp(struct dpaa2_eth_priv *priv,
 	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
 	xdp_set_data_meta_invalid(&xdp);
 	xdp.rxq = &ch->xdp_rxq;
+	xdp.frame_sz = DPAA2_ETH_RX_BUF_RAW_SIZE;
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
 


