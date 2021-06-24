Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2343B3378
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhFXQIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:08:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230170AbhFXQIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:08:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624550778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2arA4F9H8piXSu2BaYZfrwo91oZXpALZLKMt5odcOCY=;
        b=cxJHIkM5DPs+Z3+An7FZA7UqGNoRZKRVPiM+qFS8xEBTcWT79opsgTHBx7zMboqkWJubDr
        +Gbb7r7xDA03SLUjD7BNnSZ09tpZLjxBjQoAbL1IZzlXDWOxf0yahYoiCRuy/kwF3NLu4o
        N3ISjM4/z80wJHT7WbAPivhWMWl/F0E=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-4rHvdMabMSSf5kfczPfQqg-1; Thu, 24 Jun 2021 12:06:17 -0400
X-MC-Unique: 4rHvdMabMSSf5kfczPfQqg-1
Received: by mail-ej1-f72.google.com with SMTP id de48-20020a1709069bf0b029048ae3ebecabso2165708ejc.16
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 09:06:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2arA4F9H8piXSu2BaYZfrwo91oZXpALZLKMt5odcOCY=;
        b=Tijsa+Poq/s+3TqIXPeaJzAddtrucmgQ8i6jkFHzSRqMVYtes/xozOnt5nTPq60JA8
         58HE+osnr5s7TJ0dOBLug4Ct8vui0eRzRiCvm/4SgzLIYAIVmRjfjFikQaLWe95WqbNZ
         VO2EO1daGTFe5fFj+SLn5343u5YUStzj24v24mCRX3JiC0Mxnxxd01KkDfthCtpuoD/+
         PltScNnXFvo577FXjXETg4QlMT1Iinh3XN6VyIY2j0o2xwHZWBbNFcAG9tQGpEvB1frV
         Cgj3cQc5nU51H/5fpWLP+wl7M+2MDywDlvuDpH//yMgiQ8x0GHSQ8IuFpv2LXxinlQQn
         hLyg==
X-Gm-Message-State: AOAM531lpcv4I3lU6am8FVf6Mzg5UHoC+axwuVd7tey7b2JYtee9hbCs
        d2TqBiEkF8D2kqbTngafB8e90wPl4tjAfZzwcsBNoLDtXkOVq6j6GrXURICqKRkOtPROdcEHAm3
        3lXlGuKqEFeiDVu1O
X-Received: by 2002:aa7:c3d6:: with SMTP id l22mr8228021edr.245.1624550775706;
        Thu, 24 Jun 2021 09:06:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw09H7v0DCCEjs/tE/s2mmEWHfFhayzievmvBhlMCyz27KgLfOMPcrR1ar5NxO3zWi0Usga7Q==
X-Received: by 2002:aa7:c3d6:: with SMTP id l22mr8227949edr.245.1624550775257;
        Thu, 24 Jun 2021 09:06:15 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o4sm2122595edc.94.2021.06.24.09.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 09:06:14 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 66FF318073A; Thu, 24 Jun 2021 18:06:10 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH bpf-next v5 09/19] thunderx: remove rcu_read_lock() around XDP program invocation
Date:   Thu, 24 Jun 2021 18:05:59 +0200
Message-Id: <20210624160609.292325-10-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210624160609.292325-1-toke@redhat.com>
References: <20210624160609.292325-1-toke@redhat.com>
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
2.32.0

