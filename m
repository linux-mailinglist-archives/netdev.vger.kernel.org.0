Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5263B1886
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhFWLKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:10:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230403AbhFWLKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:10:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624446482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6wgUfE3YuyYqn3UXIkFwKI8I46axO+CjBlTP2HaYNQM=;
        b=hOYf9YprlHcGInqr9Qmx61xAnO/vnF1NzK7DW05B0SsJGM75s6hM2+dtjeLzKITMJacHGp
        MqUWTI7po0q0ZuWCOTjDHHrjBCaHJrTIuIEg4DeiiZxP2Bf3UgaR1IeKgmNDS25O1EJhS0
        1BKu5zXyREkWtIHiVe0oYfvKNjXh2/A=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-81JP1ZIYNeaZOI_v-6DOKQ-1; Wed, 23 Jun 2021 07:07:57 -0400
X-MC-Unique: 81JP1ZIYNeaZOI_v-6DOKQ-1
Received: by mail-ej1-f69.google.com with SMTP id c13-20020a17090603cdb029049617c6be8eso828619eja.19
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:07:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6wgUfE3YuyYqn3UXIkFwKI8I46axO+CjBlTP2HaYNQM=;
        b=ceR/XBrWZ2OEQ8oGOeQRV4BY4/hMuEfrrfAvuLuTmSGlIpkq2vEPUBkqya9bY453Bv
         r2FX7sausS76ARp3n/dAAVulYVDHEgpwPHML+Rddzo/TH3Z/bU3Rpck/DlVGfT11sUUF
         J3iwBDUPOW7B0YlQMQSQa2ybXLQQC40EeenlhxiEcW3h1+nKQAWdN4hChgaj76OFsB3U
         B1dB5S/XmRyacmO8EXeZVayemKN/LjR2ZlUCv4P2Dpa0FRUbDTq8PDPI6tgl1Ld4hJpV
         TnPM/sj4CT9u5bn03nA1k9lp2htYo3gWpYZ7y1YNEzcLRd3uNb9qj8ImbO6KmkM7znKo
         HekA==
X-Gm-Message-State: AOAM531+WKMJwZq1W9ZvvFlfTAEWJMP0B3/Kg71Hdd7QZMJeHBgycfzo
        5syR6K7XyRampt7pHU37DStfN8HnAT2SDy/s56d2lohq5d7YtuRPJqkw12IXaxFj/h9+F2Nc1In
        eyKbpC4u6OVgfxZyg
X-Received: by 2002:a17:906:244d:: with SMTP id a13mr9452851ejb.551.1624446455888;
        Wed, 23 Jun 2021 04:07:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJuPR44sF0OT9/VupxhagYWjU/hFE+FqxoBPV+oB/0joRp0VUukfBXi80r+7q0PrJGZP+Gvw==
X-Received: by 2002:a17:906:244d:: with SMTP id a13mr9452834ejb.551.1624446455697;
        Wed, 23 Jun 2021 04:07:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id n2sm13468522edi.32.2021.06.23.04.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:07:30 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2D0B9180738; Wed, 23 Jun 2021 13:07:28 +0200 (CEST)
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
Subject: [PATCH bpf-next v4 08/19] bnxt: remove rcu_read_lock() around XDP program invocation
Date:   Wed, 23 Jun 2021 13:07:16 +0200
Message-Id: <20210623110727.221922-9-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623110727.221922-1-toke@redhat.com>
References: <20210623110727.221922-1-toke@redhat.com>
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
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index ec9564e584e0..bee6e091a997 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -138,9 +138,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 	xdp_prepare_buff(&xdp, *data_ptr - offset, offset, *len, false);
 	orig_data = xdp.data;
 
-	rcu_read_lock();
 	act = bpf_prog_run_xdp(xdp_prog, &xdp);
-	rcu_read_unlock();
 
 	tx_avail = bnxt_tx_avail(bp, txr);
 	/* If the tx ring is not full, we must not update the rx producer yet
-- 
2.32.0

