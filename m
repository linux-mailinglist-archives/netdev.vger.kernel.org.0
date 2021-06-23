Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FF63B18A7
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhFWLQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:16:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230300AbhFWLQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:16:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624446826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3OGKlT+K3Cpr2CAOizG3FJ/dNahuGZz8NpheYYFR6ws=;
        b=O2zr/BJnwqEjDCfiWkYbzi2E+ox7eU/rIyC1eKXJqIcJGNrZuzvgwJD6VbtLWMESYx0Kti
        gQMCGnCe0BOsIjMo2SUC57fzro1Yx6D58TcoM52zx48PbDp3If0hvi4cFHQ+hZfBPAGGDm
        zM6YdKQc2IAvduKSyRrP3cQajp5BOrA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-CYGfScniODWxXF_D6exVkA-1; Wed, 23 Jun 2021 07:13:45 -0400
X-MC-Unique: CYGfScniODWxXF_D6exVkA-1
Received: by mail-ed1-f69.google.com with SMTP id r6-20020a05640216c6b0290394ed90b605so1002961edx.20
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:13:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3OGKlT+K3Cpr2CAOizG3FJ/dNahuGZz8NpheYYFR6ws=;
        b=QZwthlfNWUmyb0q5rhFuG0pNa4Z5fejynW1Yb6IDz2d5R0dLjgsUYJs3YXVXAmgkgL
         Jo057rSYW5KDbqQ4HvZKzmCxUakFqkwK8+wXRYZURcR3kPtyr9+4TeID0Msy1yL9fZIE
         17JGs96Fp74BkIj9/wLErTLt7NHrESWOmxJYq9cWL5OXJW4uXcQS7wFAnn50f0l0F3Xj
         NLGxlLWqTLBIQnHHX96CdqCdOkjRgRPPOOvpf+9+QR2FDWjFn5ekCs5YL/0O+TryNNoj
         4Z8sXHBS0hh4J1tKzTLHdH+tUSx6YhcJt8v+nSVChccpZMVPMSawAP70gchYpPpz2RQ3
         Z7IA==
X-Gm-Message-State: AOAM5319ddBxKAHT65bUZ3Fw5RM6a+3S8PEtLTCZ4ZGx203oRKMWO0BN
        Rvpuy/dCutIvnz+I8M7u7EGR5PjDFQeh3/dh5UaRPXu/N/BcM/Ove0PK8jI6Wdcs2Ji+JRqYngw
        fLSMjV5VEmuT5tBch
X-Received: by 2002:a17:906:244d:: with SMTP id a13mr9481827ejb.551.1624446824262;
        Wed, 23 Jun 2021 04:13:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw71VQKEC/9KOOq6gTZpsMVmotp3bYZ3eOEuR03USdj7N4YBneTwSsmElAQRP2hdOY2F02acA==
X-Received: by 2002:a17:906:244d:: with SMTP id a13mr9481811ejb.551.1624446824081;
        Wed, 23 Jun 2021 04:13:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id n2sm13477595edi.32.2021.06.23.04.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:13:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 61ACB18073E; Wed, 23 Jun 2021 13:07:28 +0200 (CEST)
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
Subject: [PATCH bpf-next v4 14/19] nfp: remove rcu_read_lock() around XDP program invocation
Date:   Wed, 23 Jun 2021 13:07:22 +0200
Message-Id: <20210623110727.221922-15-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623110727.221922-1-toke@redhat.com>
References: <20210623110727.221922-1-toke@redhat.com>
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
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index eeb30680b4dc..5dfa4799c34f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1819,7 +1819,6 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 	struct xdp_buff xdp;
 	int idx;
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(dp->xdp_prog);
 	true_bufsz = xdp_prog ? PAGE_SIZE : dp->fl_bufsz;
 	xdp_init_buff(&xdp, PAGE_SIZE - NFP_NET_RX_BUF_HEADROOM,
@@ -2036,7 +2035,6 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 			if (!nfp_net_xdp_complete(tx_ring))
 				pkts_polled = budget;
 	}
-	rcu_read_unlock();
 
 	return pkts_polled;
 }
-- 
2.32.0

