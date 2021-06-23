Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D74C3B18A0
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhFWLQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:16:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45045 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230098AbhFWLQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:16:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624446825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=llJCIySvFOtrYZhTAdojGqVA7hNSjDHEmwwvlUzwRuo=;
        b=BN5m6m9d/5aK6ze/ACjEHaAt9YX4ZAcQUjh0nHmtWO2lmxxc5PmaBbKfup/gic0HPhgcwu
        sl/qflNG0JBmaImJwwVzGyAnEccb9xeRwoMsvjjCgqiezM63jNHcTrOrh/XaWXvNckKn78
        8laCrxKHy5SRKCmp0eVAi7c8P/uMMt4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-jkdPTtRBOeG52CBWEbaYtg-1; Wed, 23 Jun 2021 07:13:44 -0400
X-MC-Unique: jkdPTtRBOeG52CBWEbaYtg-1
Received: by mail-ed1-f69.google.com with SMTP id z5-20020a05640235c5b0290393974bcf7eso1125225edc.2
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:13:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=llJCIySvFOtrYZhTAdojGqVA7hNSjDHEmwwvlUzwRuo=;
        b=ULkRLlkiggZpVrlu6B5XkHekGLhvRb9us9yLDD5YRGbkKAWNUW8aX8gmKarsNY4E08
         uKfchIafGzh830WyyEk70pOeFVXFsL8fWJ9ZlHTkZCrvDz/EBxGtbSxjPic8d0JMHWOP
         htJlw5r4esANR+dnJdumhCOmqoKWWj9faTYMzBe3WmbAUoCm3GzoRLCE1REfNscLFKJK
         PLmRNOUOXhKoB9Un/yahxU0sKUtVdPZL8wlH3Lbxu0q2onrDd4S36OW1YlVUohNLkTv2
         EPhg3N64hq8T5JdMia8yoymaPu0cWs3KV67EzyqqAy2M680ZDgTIiLypUdrs2e+6ABOZ
         C5yw==
X-Gm-Message-State: AOAM533N4igsmA24M6eqRbk+Oagx6qZNLVy8sjO00PGXTezPERySkV2z
        JXSkefTyWzKzR88mYfoNFr7cAdfcYfz4IiRk8UglezaiSbL/DpxE+50ocLJN8k3FJFG004LezoU
        FetTXBDHy0YXKDtpg
X-Received: by 2002:a05:6402:42d2:: with SMTP id i18mr11522753edc.168.1624446823373;
        Wed, 23 Jun 2021 04:13:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8yFgTmKihKxpCubnh8O8F/QHFr0n5nAr6MMyZq4hXtQykYRJ1mSniQXOqaN4HV1YIOxxxAQ==
X-Received: by 2002:a05:6402:42d2:: with SMTP id i18mr11522725edc.168.1624446823254;
        Wed, 23 Jun 2021 04:13:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id gx4sm3605409ejc.34.2021.06.23.04.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:13:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 872E3180742; Wed, 23 Jun 2021 13:07:28 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Subject: [PATCH bpf-next v4 18/19] stmmac: remove rcu_read_lock() around XDP program invocation
Date:   Wed, 23 Jun 2021 13:07:26 +0200
Message-Id: <20210623110727.221922-19-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623110727.221922-1-toke@redhat.com>
References: <20210623110727.221922-1-toke@redhat.com>
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
2.32.0

