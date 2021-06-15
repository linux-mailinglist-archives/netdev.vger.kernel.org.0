Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8EB3A835B
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhFOO5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:57:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29995 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231398AbhFOO5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:57:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623768909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+MBUlWntOqYKNc/Hn434J6hypV0mSyDY5Wc91lYkTgY=;
        b=QTbOiUHxd0bb49uuiZcDv8My7qohrSCpqUxU31aKa7cN3X2HjObYiEL8A8MINks09D0P4D
        TZyh/nKrvuW8N8MyWCXc9HMJy0ZJCN9yAoBSjHxFyn9QXtYXSpslmsT2QmD3ZmLn0SYSzP
        WQ3GiKgIPWc59pn0ZnusTt2r3RS4tAg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-T0tU1r-BMPS7_Ucb4aFNwQ-1; Tue, 15 Jun 2021 10:55:07 -0400
X-MC-Unique: T0tU1r-BMPS7_Ucb4aFNwQ-1
Received: by mail-ed1-f72.google.com with SMTP id a16-20020aa7cf100000b0290391819a774aso20495592edy.8
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 07:55:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+MBUlWntOqYKNc/Hn434J6hypV0mSyDY5Wc91lYkTgY=;
        b=BZiFN0UtTKGquX5+iA28sn1qypId3ywL6tnHqMkccQcUHWFrwg8xMdha9BUZi7g3NT
         rn0MPQf+7WqWKjfOlcQ5mNequEYGsxkWTmmPLC5/YUk42qYdI4exeGofvXJarR9X9/+P
         vSfbHzUF9tHu1HaAwVUYlG0sN07Pa15nwwaublSA+0T7FoJTOvvw+CgwlWI2hylPRi2J
         0xf1eRHONaToP+d9jwmpD60WmOl65Ps7qsh0m8wTRZo2qgCKUV9O1ri1JMkuz3A+kfTf
         BmAG7mmL7qIakPt/TOcdzc7BBFNQa0Epi6zuwX/2ghSGvPn3t9Juv1Jx0LJdP99v6WXi
         EnNA==
X-Gm-Message-State: AOAM533fTPS7jtKMWPELNLUWmdT9gfvFoSHYZ/RgIK7Hst8cLj+KiNxf
        O1tHxT0dZOffmtLbtm4UlHa1HPZeQoyV0g/9+xggSedLarUOC53id6c+LPPP0RB1mDJBj0NS6QW
        6FnBUHt72+YAcy/YG
X-Received: by 2002:a17:906:340d:: with SMTP id c13mr21721994ejb.457.1623768906643;
        Tue, 15 Jun 2021 07:55:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJya4LdcReocWctTCZ9mI36cRWbw1AvtX2B2eEU4jnR/LeLy+2+DqvNbDMZXizkn9MKh2FwH1A==
X-Received: by 2002:a17:906:340d:: with SMTP id c13mr21721961ejb.457.1623768906261;
        Tue, 15 Jun 2021 07:55:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id bd3sm12013372edb.34.2021.06.15.07.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:55:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CFF33180728; Tue, 15 Jun 2021 16:54:58 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH bpf-next v2 05/16] bnxt: remove rcu_read_lock() around XDP program invocation
Date:   Tue, 15 Jun 2021 16:54:44 +0200
Message-Id: <20210615145455.564037-6-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615145455.564037-1-toke@redhat.com>
References: <20210615145455.564037-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bnxt driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
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

Cc: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index ec9564e584e0..f38e6ce9b40e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -138,9 +138,10 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 	xdp_prepare_buff(&xdp, *data_ptr - offset, offset, *len, false);
 	orig_data = xdp.data;
 
-	rcu_read_lock();
+	/* This code is invoked within a single NAPI poll cycle and thus under
+	 * local_bh_disable(), which provides the needed RCU protection.
+	 */
 	act = bpf_prog_run_xdp(xdp_prog, &xdp);
-	rcu_read_unlock();
 
 	tx_avail = bnxt_tx_avail(bp, txr);
 	/* If the tx ring is not full, we must not update the rx producer yet
-- 
2.31.1

