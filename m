Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432E63B33A5
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhFXQQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:16:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32021 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229831AbhFXQQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:16:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624551235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3OGKlT+K3Cpr2CAOizG3FJ/dNahuGZz8NpheYYFR6ws=;
        b=ghK686l91nRdCgA+FtXNHqR7DJszQ90QF+RkJwQYolvvymAh6xJK4TA2lRTh7Rv0jPDdyR
        zgHmbAm4DOm6KK/oAlzIYulujj9TuU16ug3HG96cX3E2Ou5qDlPK6nhPoQ3eA7vfIiq+YX
        clceDr/ldponDejIHMsbFwsCHaSlTIk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-SVU7piA7MSmwYR1LHFoMdg-1; Thu, 24 Jun 2021 12:13:54 -0400
X-MC-Unique: SVU7piA7MSmwYR1LHFoMdg-1
Received: by mail-ed1-f69.google.com with SMTP id z5-20020a05640235c5b0290393974bcf7eso3618711edc.2
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 09:13:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3OGKlT+K3Cpr2CAOizG3FJ/dNahuGZz8NpheYYFR6ws=;
        b=VXbzdXUc44mKV+f805dOVzvDwzCbCmh1Xzi3ZylSmabH2I+sgwps39HsnNTq/StObb
         pcG/6cfRU+sPEHKmiwcRXklvIRw94i4CIptM87HUgOa1b801r0ljMVgh81g6eU8ilbmi
         mLLK6xZBbw6ApLD60qDW1Q3yIiTeEwSAIPorE/pHszRPAd70UgAiPGpUoatAmKIP21e8
         k2E/ItTnCX8T6ke2YxsCgHiHofYANtYy5TEv41NTrXA5/gaiMELptKZvB8YoH5n/KwsP
         dUk3+4WEvrk5WRB6Xk5wuOeGyX5kXV753CUPAsma0R90hCIHgHtUfx01ZFes+iteJYSK
         cOxQ==
X-Gm-Message-State: AOAM532huOZRMgH/uuTKy1enFOm0iyEgMxHeQpRgM/VBoJSlA11t6eiP
        ZxZhG3ejdYPtWdGg7FINwtNK/g5PT9YByS82gbs18BN1o4DGDTdihuqHwe8t5N31obpBoeDi2KP
        Q+QrXmaHeUe2uf/Ey
X-Received: by 2002:a17:906:1701:: with SMTP id c1mr6021315eje.425.1624551233599;
        Thu, 24 Jun 2021 09:13:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkMmuHvtFL+2+qbxdEqWtnQFiQm8TsBCugpF27GOyLxyYhdPSN4NVwA3+KZgpg2/w7k0IVOQ==
X-Received: by 2002:a17:906:1701:: with SMTP id c1mr6021291eje.425.1624551233393;
        Thu, 24 Jun 2021 09:13:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id gx4sm1472384ejc.34.2021.06.24.09.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 09:13:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 97A1018073F; Thu, 24 Jun 2021 18:06:10 +0200 (CEST)
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
Subject: [PATCH bpf-next v5 14/19] nfp: remove rcu_read_lock() around XDP program invocation
Date:   Thu, 24 Jun 2021 18:06:04 +0200
Message-Id: <20210624160609.292325-15-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210624160609.292325-1-toke@redhat.com>
References: <20210624160609.292325-1-toke@redhat.com>
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

