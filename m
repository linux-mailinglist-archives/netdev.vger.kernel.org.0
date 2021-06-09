Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919093A1157
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238995AbhFIKks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:40:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238980AbhFIKkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:40:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623235128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aw/xy7JPGgdtm8YR/KgKtd2Nuh+5odcpRTL2K7ZE9co=;
        b=J7SHTm+z6j88yiCuuXGdf1rYIh6qPyFTegJmGG0CGLiCZKNqUc+WSVF+9eIzQ+vuCY3RvJ
        AvrDEogN4PPrXp+LxOxhy5f/NHv0Nj20GMLmiaKgGbzaRQdSVFq9dZo9CIGwxLJixdkcIQ
        dDJUgLM4LQ8bLKR6TPxuTs5H9+ugcAo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-2z2hJ8rHMIGcRbMEhc-5AQ-1; Wed, 09 Jun 2021 06:38:47 -0400
X-MC-Unique: 2z2hJ8rHMIGcRbMEhc-5AQ-1
Received: by mail-ej1-f70.google.com with SMTP id k1-20020a17090666c1b029041c273a883dso3260150ejp.3
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 03:38:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aw/xy7JPGgdtm8YR/KgKtd2Nuh+5odcpRTL2K7ZE9co=;
        b=V48jZsR39AQPFGEy535bn9kFfslXft3QOgPiF5Q/9I2PcHrik9loLw3QF1lgdooXLx
         UkPO7GVkV8LFoYMB48e+bFQtVPtAJ6k4Fc1bH/nW14e/NBCnBBUKrCuNDc9HCEANutee
         jllqIG9OJX5zidGhbnYnT0thKgvaHqO9hECuYtTTCwc0VFyYf93ub5AJYKLSsnBsRxQ4
         +ESlPjF357H9a0omWRIVK3tsdErrFd05jolg3NitX8POZ50/4GX5K/iE54/aBu34PtI/
         vvBvGz3dRdAu+DtzIcYtMnKL6G/YlRf/CJYdvPoQ1jvliTZHb1zYT8CBlFxcUjPK1Uwr
         NpBQ==
X-Gm-Message-State: AOAM531bfay7dWpsSstKKLzQmLojGW4i483LjmqbTPAYmas1yWN+HGHO
        mxLkbIb4sUoY2zwbFAVt7zhiZJouY+lUwQNRHtHXXYqvHRZiuYSd3AnnnNdVJMEo3lh3q5pw+PO
        6nEhtZihKhcvruvpG
X-Received: by 2002:a05:6402:42d2:: with SMTP id i18mr29889168edc.168.1623235125899;
        Wed, 09 Jun 2021 03:38:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2ZxCPYfzIuixLEMF+JxyB09kt/temZ4xhorHzSmowYUw3Lui4JpY3hhytn+YssOjiCEeufA==
X-Received: by 2002:a05:6402:42d2:: with SMTP id i18mr29889153edc.168.1623235125566;
        Wed, 09 Jun 2021 03:38:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id n13sm989526edx.30.2021.06.09.03.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:38:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C980A180730; Wed,  9 Jun 2021 12:33:30 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Simon Horman <simon.horman@netronome.com>,
        oss-drivers@netronome.com
Subject: [PATCH bpf-next 12/17] nfp: remove rcu_read_lock() around XDP program invocation
Date:   Wed,  9 Jun 2021 12:33:21 +0200
Message-Id: <20210609103326.278782-13-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609103326.278782-1-toke@redhat.com>
References: <20210609103326.278782-1-toke@redhat.com>
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
2.31.1

