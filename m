Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEB23B189C
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhFWLQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:16:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46478 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230232AbhFWLQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:16:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624446824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cOyh19f+n3Klc9n0Uf50USUZ/OAvnTAcZiRzl4mD+JA=;
        b=W9SyoSi8B1sOzdyy3LCQRfLDEX/RUOxpDwaPziCFQFg5J9jh0XnbA84m8kGMdedx7E3yMI
        CvTX8PRZGceRt6Pe7LxiaVmPPBz1FXSByJboZJuGm9H7xihcUSGnwloHlucWzaPcMEKkv9
        DK+mpScFTtx9PlA6Tqx2SLoKBD8jnCE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-jtZu29QnN8WS3wthJd8bJw-1; Wed, 23 Jun 2021 07:13:43 -0400
X-MC-Unique: jtZu29QnN8WS3wthJd8bJw-1
Received: by mail-ej1-f72.google.com with SMTP id p20-20020a1709064994b02903cd421d7803so832946eju.22
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:13:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cOyh19f+n3Klc9n0Uf50USUZ/OAvnTAcZiRzl4mD+JA=;
        b=d+JKYArkg9RlPNEeiQz6PUOPLGRYagD3mwLRKa1NWSRJKJBx1yUNA43oNdiW/1AXBf
         avB7h3dRfVz42YCW2ttQIMcida0s3diAn7kY409oPzhCAFXf9G0Du42R7IuYt388O2FC
         jYqFW4qhBy46EgGv8qlKzRzUiOuL9JWzQl/inoA3Ze51NVl6CzmyMAFbw+DhTsYcazhO
         5VYN2HV0SfwJYHTM1WMbCAX+/hhm3E/m595PlqGWFJZp5faQ0p/Mrd5To5Csi3p/wQge
         S+jmqFXXEkZJ7Q+RR/7K1k3v3h4Q7pk+6LHpToi9qb/u36VLydMpbv7/ZWZHduIIzXEd
         q7wA==
X-Gm-Message-State: AOAM530j/0mK1UyMBagA/p4RSYczuPPd0hlkdPLxZ4plm50rOXEkAbEW
        NRzjJZobCFaGPfcWQbxGWYwclkzQJI3OunvcG8Wu4jYo1DIpvl+qu0rN1F/T/T3mBXKkWzcM/sP
        011Rzhce5sn2dwwG1
X-Received: by 2002:a17:906:c108:: with SMTP id do8mr9602774ejc.74.1624446821906;
        Wed, 23 Jun 2021 04:13:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFC4J4yF4C76IBXxeFdHx2yW30lP8pvvXj7t+qqzCoChKhiwz3GKGGMBaMUXSqFPorcLDoxw==
X-Received: by 2002:a17:906:c108:: with SMTP id do8mr9602748ejc.74.1624446821693;
        Wed, 23 Jun 2021 04:13:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id bq1sm7200517ejb.66.2021.06.23.04.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:13:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 74594180740; Wed, 23 Jun 2021 13:07:28 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: [PATCH bpf-next v4 16/19] sfc: remove rcu_read_lock() around XDP program invocation
Date:   Wed, 23 Jun 2021 13:07:24 +0200
Message-Id: <20210623110727.221922-17-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623110727.221922-1-toke@redhat.com>
References: <20210623110727.221922-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sfc driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
program invocations. However, the actual lifetime of the objects referred
by the XDP program invocation is longer, all the way through to the call to
xdp_do_flush(), making the scope of the rcu_read_lock() too small. This
turns out to be harmless because it all happens in a single NAPI poll
cycle (and thus under local_bh_disable()), but it makes the rcu_read_lock()
misleading.

Rather than extend the scope of the rcu_read_lock(), just get rid of it
entirely. With the addition of RCU annotations to the XDP_REDIRECT map
types that take bh execution into account, lockdep even understands this to
be safe, so there's really no reason to keep it around.

Cc: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/sfc/rx.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 17b8119c48e5..606750938b89 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -260,18 +260,14 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 	s16 offset;
 	int err;
 
-	rcu_read_lock();
-	xdp_prog = rcu_dereference(efx->xdp_prog);
-	if (!xdp_prog) {
-		rcu_read_unlock();
+	xdp_prog = rcu_dereference_bh(efx->xdp_prog);
+	if (!xdp_prog)
 		return true;
-	}
 
 	rx_queue = efx_channel_get_rx_queue(channel);
 
 	if (unlikely(channel->rx_pkt_n_frags > 1)) {
 		/* We can't do XDP on fragmented packets - drop. */
-		rcu_read_unlock();
 		efx_free_rx_buffers(rx_queue, rx_buf,
 				    channel->rx_pkt_n_frags);
 		if (net_ratelimit())
@@ -296,7 +292,6 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 			 rx_buf->len, false);
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
-	rcu_read_unlock();
 
 	offset = (u8 *)xdp.data - *ehp;
 
-- 
2.32.0

