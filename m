Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3783A1129
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238919AbhFIKfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:35:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47699 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238909AbhFIKfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:35:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623234818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VOVdIjFGkWIiDQLhZ4O8JX1OgtVYddfMXm2FFCs+0ZU=;
        b=LAnJttbNrUiWR2jOVwxyBmNgve0PIw+ucCws4rRMGvf31AVFRO1TM6uDXlfrXH1Ob96LHh
        zHKw8fp8lhVhaBBCsVQClWmHcl/vbJf+YzytHjji1pl0xZr0C7wYih/4h8FP0rswXbnu4D
        3xzy7Nj5RcPssF6QUZA/r1AMCsWxrEo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-tH73yVyZPt6Yg4-HQ3vi5A-1; Wed, 09 Jun 2021 06:33:37 -0400
X-MC-Unique: tH73yVyZPt6Yg4-HQ3vi5A-1
Received: by mail-ed1-f69.google.com with SMTP id u26-20020a05640207dab02903935beb5c71so6397572edy.3
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 03:33:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VOVdIjFGkWIiDQLhZ4O8JX1OgtVYddfMXm2FFCs+0ZU=;
        b=txNryxsLP6DxoqkyPY0ifLwMPxEHzDuWo+YNYcVWnp5FhRnoGCbDkyCuSQPpqjnxcv
         0/N7VLGolos+oUnleWqQPE/5Eo5l0YR01bZq/xA/U5UAl5FaQr7CYwkhEt74FHJpPvgv
         X2uNND8Qasq2cCJ7B8qs+OC4sj279kEaAq5jpuZ/YDU05NwrdzVvwLibXEBmzhH5qdW8
         pE/Xyv4zNm3O8QQOPSbJpnoxUbS4hY3riybkZ433/0QmPeyPfLROswmD16WsnNF9YGe2
         pfVJR0pvSrDnAGoyxtgy1Ol0+RUX4/mNj8xnCM11oh8esogMuhnU9eIEeVyMg09HC4lJ
         S0qQ==
X-Gm-Message-State: AOAM533yz9w+VO24PNSAL18txJyYc+0ab5QRq46DJkfYu6aFf41/SQ+4
        53s8xTyAFtykXf4hFIp9+1zx/h4EBuoIJugeo6OFv8Ttfrfov624bREwRtb8gAKr1zXQMntugUR
        yfDlchY4pU9f32HOe
X-Received: by 2002:aa7:c547:: with SMTP id s7mr29599534edr.239.1623234816147;
        Wed, 09 Jun 2021 03:33:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJsMQfvKo7/nhkmRlLMchZWxJh31qEpOl87eLrNsvu1Nhy2NQKMbTQafLxov+eQh4WGHJZIQ==
X-Received: by 2002:aa7:c547:: with SMTP id s7mr29599525edr.239.1623234816007;
        Wed, 09 Jun 2021 03:33:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id c6sm916307eje.9.2021.06.09.03.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:33:32 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 95EA618072B; Wed,  9 Jun 2021 12:33:30 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH bpf-next 07/17] thunderx: remove rcu_read_lock() around XDP program invocation
Date:   Wed,  9 Jun 2021 12:33:16 +0200
Message-Id: <20210609103326.278782-8-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609103326.278782-1-toke@redhat.com>
References: <20210609103326.278782-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The thunderx driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
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

Cc: Sunil Goutham <sgoutham@marvell.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index c33b4e837515..e2b290135fd9 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -555,9 +555,7 @@ static inline bool nicvf_xdp_rx(struct nicvf *nic, struct bpf_prog *prog,
 	xdp_prepare_buff(&xdp, hard_start, data - hard_start, len, false);
 	orig_data = xdp.data;
 
-	rcu_read_lock();
 	action = bpf_prog_run_xdp(prog, &xdp);
-	rcu_read_unlock();
 
 	len = xdp.data_end - xdp.data;
 	/* Check if XDP program has changed headers */
-- 
2.31.1

