Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D143A1131
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238922AbhFIKfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:35:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34548 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238905AbhFIKfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:35:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623234821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b6/ywr8A84xw5GpjlyvV4hRNlzB/uVzXQRS5Ys9UtLc=;
        b=HcCTHeXLhqmy+wd44OwaJr/zKEDWVBkxVJeOfaOwrw357G6Fz0JUAr0mJli5jNfckuaEIc
        YWi1YEyHCWeZ5LsMOBRw9Mn4MamuzcqOCjIW8q6C0EA0W68EutGVhnr2OQPFL+20wBods7
        EPywwviRXhBjeZNyvG0cIQ3yVTMEZRs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-Ej1J2rJ6PfWoW8eIfoWHeQ-1; Wed, 09 Jun 2021 06:33:39 -0400
X-MC-Unique: Ej1J2rJ6PfWoW8eIfoWHeQ-1
Received: by mail-ej1-f71.google.com with SMTP id b8-20020a170906d108b02903fa10388224so7892206ejz.18
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 03:33:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b6/ywr8A84xw5GpjlyvV4hRNlzB/uVzXQRS5Ys9UtLc=;
        b=jl4kQETY5AUfskcOLSbBWZgUOKKlRTB8BEWPb9l8LGcV8j97QtgcZqqc8Hsk2K5yVn
         LN8T8UjhgKbZVHOtZUFPYoN/RlY17/B67yc2VhT5kRdYYWqbX/oDZQwUIG3XlrG+rXfF
         2YV0/PkKXwxnC+RPDcNXL1zQR6RKD1vCvWBKReJ9ETIxldW7JbpWdZvqtgwh1psJHM6u
         tuEG2LOLXGGgJ3569q7Ao9sqsmsy115sE3qTJHobt3AV8zZxgujGMeC9KEZLxzAJQYxg
         xG2nD5raqhgicGtqG1YylVz4cnHQxdCW12BVRDB4L7q4+l6png6Lb6rGmom53IKiMJH/
         9bgw==
X-Gm-Message-State: AOAM533909Q+h64g79X/tkAMY5EU/p+Bl/WloaLJ4vlsVnWb/USsl2Ci
        5b3kO72ijHE+zrZZwA33HMd3elcoT8qG95CWx4m+gc+Nc60mYW4i2W8o00ioqjiaTjJkKLhz2Zy
        Q1ScR6Rml826AYr5r
X-Received: by 2002:a05:6402:511:: with SMTP id m17mr29902723edv.1.1623234818392;
        Wed, 09 Jun 2021 03:33:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxy8dEQdT/+2mrdhhPDQI/OtNZSHMX52Tnhpuds9eoPNSLQsCBSfjSo0BHivEiX/iSeqUt4zA==
X-Received: by 2002:a05:6402:511:: with SMTP id m17mr29902711edv.1.1623234818248;
        Wed, 09 Jun 2021 03:33:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id l8sm933170ejp.40.2021.06.09.03.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:33:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F2934180734; Wed,  9 Jun 2021 12:33:30 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Subject: [PATCH bpf-next 16/17] stmmac: remove rcu_read_lock() around XDP program invocation
Date:   Wed,  9 Jun 2021 12:33:25 +0200
Message-Id: <20210609103326.278782-17-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609103326.278782-1-toke@redhat.com>
References: <20210609103326.278782-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The stmmac driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
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

Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index bf9fe25fed69..08c4b999e1ba 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4654,7 +4654,6 @@ static int stmmac_xdp_xmit_back(struct stmmac_priv *priv,
 	return res;
 }
 
-/* This function assumes rcu_read_lock() is held by the caller. */
 static int __stmmac_xdp_run_prog(struct stmmac_priv *priv,
 				 struct bpf_prog *prog,
 				 struct xdp_buff *xdp)
@@ -4696,17 +4695,14 @@ static struct sk_buff *stmmac_xdp_run_prog(struct stmmac_priv *priv,
 	struct bpf_prog *prog;
 	int res;
 
-	rcu_read_lock();
-
 	prog = READ_ONCE(priv->xdp_prog);
 	if (!prog) {
 		res = STMMAC_XDP_PASS;
-		goto unlock;
+		goto out;
 	}
 
 	res = __stmmac_xdp_run_prog(priv, prog, xdp);
-unlock:
-	rcu_read_unlock();
+out:
 	return ERR_PTR(-res);
 }
 
@@ -4976,10 +4972,8 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 		buf->xdp->data_end = buf->xdp->data + buf1_len;
 		xsk_buff_dma_sync_for_cpu(buf->xdp, rx_q->xsk_pool);
 
-		rcu_read_lock();
 		prog = READ_ONCE(priv->xdp_prog);
 		res = __stmmac_xdp_run_prog(priv, prog, buf->xdp);
-		rcu_read_unlock();
 
 		switch (res) {
 		case STMMAC_XDP_PASS:
-- 
2.31.1

