Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21833ABE19
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 23:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhFQVab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 17:30:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233121AbhFQVaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 17:30:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623965285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dAdah8VGuQn72TJlVoq7ahYZ+lMNJR+3mmSVKWZMutE=;
        b=jT3oPPxpdUesieYuMOXbqqnft7SsufHlevpPhfFazFqeDEMQcv66Reg+ULQ0rC1jcxAtxv
        lx1HTwlp+h9l0XmVrRyPlsEPEG7EvPnDQMWK1HSKbTjvOmDt5wbdVIUSb2aJ3Xl22DbxRj
        u3qnsfdA3g5WOcv5+p784A/yGHljj2Q=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-LpDbrwB5NVWVS4YfrZwlbA-1; Thu, 17 Jun 2021 17:28:03 -0400
X-MC-Unique: LpDbrwB5NVWVS4YfrZwlbA-1
Received: by mail-ej1-f71.google.com with SMTP id p20-20020a1709064994b02903cd421d7803so3009151eju.22
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 14:28:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dAdah8VGuQn72TJlVoq7ahYZ+lMNJR+3mmSVKWZMutE=;
        b=nRl8GfqEzk529Reg2ThihDPexCzr3VVinxb+vI0F9UgmiEwtsGSTRxS1q+AMg2hfAD
         Lzff/tBpEYvH7Vu9E+9oELna14vPme9KfzaoKlG/99xXKehJhkRyxlTqTZJrzyohh++p
         a+X92v6d9FemlaOMjJDS3bGeK54RN5HgPXtGXHKVFqUElGplZuYD9/7070jlxUd3t8rm
         fWd+4zVvoPSq4/wwC2qHDKYFYdmXX75Uyd3h2X48Eqja+ogTbxUiEhu8XlgaMl1e201c
         a/dOt8Na9M+HlHPNoPB1WOZnRpuH1HHItNF1aFY9dW1d5EvFrp/V4f4sVArQMFeYg85r
         DTlw==
X-Gm-Message-State: AOAM531ye0hwZi/CcrsXoywsqrRobQ2FxRIN+4+Yx9/v4Qv7+8bzUO/H
        0E6b1X5g2td7QwbYzG/5vtVanZbawIJj50sUP+Y87ApmrhGL9G3eTysVNJE6/3aobVv9V3xbqPZ
        +XQ9vFpVQ14fXKVKy
X-Received: by 2002:a50:ff0a:: with SMTP id a10mr436465edu.273.1623965282740;
        Thu, 17 Jun 2021 14:28:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAR7MBrW4DjSCrWUTnO3yJRhsZzoQfEPwCrPjITjLEgp/KVyK6TzDvfdi+b7OXK36PkMlVfA==
X-Received: by 2002:a50:ff0a:: with SMTP id a10mr436435edu.273.1623965282380;
        Thu, 17 Jun 2021 14:28:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id mm25sm100204ejb.125.2021.06.17.14.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 14:27:59 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BD795180734; Thu, 17 Jun 2021 23:27:54 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Simon Horman <simon.horman@netronome.com>,
        oss-drivers@netronome.com
Subject: [PATCH bpf-next v3 11/16] nfp: remove rcu_read_lock() around XDP program invocation
Date:   Thu, 17 Jun 2021 23:27:43 +0200
Message-Id: <20210617212748.32456-12-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617212748.32456-1-toke@redhat.com>
References: <20210617212748.32456-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nfp driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
program invocations. However, the actual lifetime of the objects referred
by the XDP program invocation is longer, all the way through to the call to
xdp_do_flush(), making the scope of the rcu_read_lock() too small.

While this is not actually an issue for the nfp driver because it doesn't
support XDP_REDIRECT (and thus doesn't call xdp_do_flush()), the
rcu_read_lock() is still unneeded. And With the addition of RCU annotations
to the XDP_REDIRECT map types that take bh execution into account, lockdep
even understands this to be safe, so there's really no reason to keep it
around.

Cc: Simon Horman <simon.horman@netronome.com>
Cc: oss-drivers@netronome.com
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index eeb30680b4dc..a3d59abed6ae 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1819,7 +1819,6 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 	struct xdp_buff xdp;
 	int idx;
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(dp->xdp_prog);
 	true_bufsz = xdp_prog ? PAGE_SIZE : dp->fl_bufsz;
 	xdp_init_buff(&xdp, PAGE_SIZE - NFP_NET_RX_BUF_HEADROOM,
@@ -1919,6 +1918,10 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 					 pkt_off - NFP_NET_RX_BUF_HEADROOM,
 					 pkt_len, true);
 
+			/* This code is invoked within a single NAPI poll cycle
+			 * and thus under local_bh_disable(), which provides the
+			 * needed RCU protection.
+			 */
 			act = bpf_prog_run_xdp(xdp_prog, &xdp);
 
 			pkt_len = xdp.data_end - xdp.data;
@@ -2036,7 +2039,6 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 			if (!nfp_net_xdp_complete(tx_ring))
 				pkts_polled = budget;
 	}
-	rcu_read_unlock();
 
 	return pkts_polled;
 }
-- 
2.32.0

