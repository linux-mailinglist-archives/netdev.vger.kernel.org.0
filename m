Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E8F3ABE1A
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 23:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhFQVac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 17:30:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52130 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233129AbhFQVaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 17:30:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623965286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4E0BLtcqynOO11TlkwRy31SmQKgoTi4+6vdURBBEN5E=;
        b=F+hgpmXLTPhxl0vwX11AGC9DUnN1AX6ORLgFeDaOBnVfb6QmSBEcI0iy8EFqlsMUe8nI74
        Qw79JhaFE+ezIP4yt5fb4Wf5nfG1pBbE792oYYd220MTDzFDp06mutxk52HWc9kS5/IwyV
        6nxjWGHSkVM/Y24Z8lkuqRfIXkeq/ZY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-1W7BKo57O5OTQ3-T07DyYw-1; Thu, 17 Jun 2021 17:28:04 -0400
X-MC-Unique: 1W7BKo57O5OTQ3-T07DyYw-1
Received: by mail-ej1-f71.google.com with SMTP id z6-20020a17090665c6b02903700252d1ccso3011551ejn.10
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 14:28:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4E0BLtcqynOO11TlkwRy31SmQKgoTi4+6vdURBBEN5E=;
        b=dDoRSI+/TsyBWBOPlmZjBfRRD2u2zx2JXO/AEG77CovhlQyeq9NeX2fqsTJFXeLvGU
         bt5Yi/8AYmVaztUSNA0QgTh9hAwcvm5cqPPl6xN4yzB4dctR38jswo1EsvkOdnwTsX4v
         UOZ+AVdwmGZAnIUUtMmdZhq8R9v6tmvLTM57QhrFRDY06mComKNISdXdzwRSoVpfzR9S
         sJAUuWtgiylGelnVTHc6o9nDpF1UYDopz0M1GUv1P8LhTugKzqjQ+rvE1jYPZ8MXr46I
         pG1858d1YX11liIja9OybyZc7rDUYx2TiBQiKYTe9BecVU7RRgFHAxI16kjcUFMfwNRr
         k6FA==
X-Gm-Message-State: AOAM530fZpq1mwEvFpO7g6wMmjKzDEhUumweLme7kHt7+bjVl+9AmEY+
        y833nI15frX+rxeH39mweLN8HjDAd8n2LIpGBRWyL8bdAjJAIOycNdYicz4BJ7qA+UcM7pUkN3P
        8fHDzILScgw8LqOms
X-Received: by 2002:aa7:dc0a:: with SMTP id b10mr480327edu.134.1623965283765;
        Thu, 17 Jun 2021 14:28:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwm3xB3xkhsrXomg6vyS9qjizIuVw9HAdz+x5dP1AwlFGrfqO5qySP880NPEtyTVT7G1MUUUw==
X-Received: by 2002:aa7:dc0a:: with SMTP id b10mr480311edu.134.1623965283649;
        Thu, 17 Jun 2021 14:28:03 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e6sm111671ejm.35.2021.06.17.14.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 14:28:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CCF49180736; Thu, 17 Jun 2021 23:27:54 +0200 (CEST)
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
Subject: [PATCH bpf-next v3 13/16] sfc: remove rcu_read_lock() around XDP program invocation
Date:   Thu, 17 Jun 2021 23:27:45 +0200
Message-Id: <20210617212748.32456-14-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617212748.32456-1-toke@redhat.com>
References: <20210617212748.32456-1-toke@redhat.com>
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
 drivers/net/ethernet/sfc/rx.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 17b8119c48e5..3e5b88ab42db 100644
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
@@ -295,8 +291,10 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 	xdp_prepare_buff(&xdp, *ehp - EFX_XDP_HEADROOM, EFX_XDP_HEADROOM,
 			 rx_buf->len, false);
 
+	/* This code is invoked within a single NAPI poll cycle and thus under
+	 * local_bh_disable(), which provides the needed RCU protection.
+	 */
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
-	rcu_read_unlock();
 
 	offset = (u8 *)xdp.data - *ehp;
 
-- 
2.32.0

