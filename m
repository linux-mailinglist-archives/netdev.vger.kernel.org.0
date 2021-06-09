Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38A83A1133
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238930AbhFIKfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:35:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238857AbhFIKfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:35:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623234821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SDs6RJCDclPtRl7f7lh2LEBzpa1knLCOi0eHBp6e438=;
        b=W4Xg9p0LnWx4kkzQrG3pn9r7eTH9s7nkvEMIT80WK6sZwbdXAuU8oQ0uctcInGH1+KoA3x
        qaF/sx9xclS4HSEP7Vs/vAitqH2GMq0Y+ZMYsM46EvmBG8lmioNAzJxWfGyFNxxqhFL4cp
        w2/On0wdoPSvSyyO80FWNGtOBn348Rw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-VKcCmHN3NXWU6dCjav7SrA-1; Wed, 09 Jun 2021 06:33:40 -0400
X-MC-Unique: VKcCmHN3NXWU6dCjav7SrA-1
Received: by mail-ej1-f71.google.com with SMTP id br12-20020a170906d14cb02904311c0f32adso597427ejb.9
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 03:33:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SDs6RJCDclPtRl7f7lh2LEBzpa1knLCOi0eHBp6e438=;
        b=G9DYjEJhEKNMrfYyAnww5co8nV3eSVGbJtrGAw1RMhAD9w9jhURu4yH8HMWa9liqZm
         M7QqIwo6VuW1e4ejdzFgnHAK74sSyRdld8bt2Y8yLpJu/INZYqQjGUBUAswS+/OnDvFJ
         0MMO0lxsiUF+nGXvmJvJRePl6cWylnVrxeUBmHlm27Woy5v2S5QIHMrEvvt2RswBJFZh
         kOEM3mxKxcOzY+WJYYhnNt4koMj4Wx+h4h9DGpnEU+q6RRWExE6AG1ag6t5vgjZkxIIZ
         HDQszZVT+/sVqKobC3DweJ/7uKF8LnDpVGtRsyXCP9Cd+ztdw2blh2a/FTKmROR1E/ky
         byJg==
X-Gm-Message-State: AOAM532Z3rAWgSUEC4vym+EdS7lhFTFJhX8A5Sywu+FulL4yzwwIYHqT
        8MRfKpARhoNCundG2Uw8EwkWPT8rKES36hQtxfOOHICmJJ1BgRKGZT5Sv8udxubrwyBW23F32d/
        r3PhIl/IIEsPhc8n8
X-Received: by 2002:a17:906:5a9a:: with SMTP id l26mr27998547ejq.490.1623234818852;
        Wed, 09 Jun 2021 03:33:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6cqSoYK0RE/EGw6NF1yHXe5cN5J2vUejl6abV3SnyWgXCCqNzpuKen3JNOpReBROIG0SuEw==
X-Received: by 2002:a17:906:5a9a:: with SMTP id l26mr27998519ejq.490.1623234818517;
        Wed, 09 Jun 2021 03:33:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o4sm946229edc.94.2021.06.09.03.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:33:37 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E95E7180733; Wed,  9 Jun 2021 12:33:30 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH bpf-next 15/17] netsec: remove rcu_read_lock() around XDP program invocation
Date:   Wed,  9 Jun 2021 12:33:24 +0200
Message-Id: <20210609103326.278782-16-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609103326.278782-1-toke@redhat.com>
References: <20210609103326.278782-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netsec driver has a rcu_read_lock()/rcu_read_unlock() pair around the
full RX loop, covering everything up to and including xdp_do_flush(). This
is actually the correct behaviour, but because it all happens in a single
NAPI poll cycle (and thus under local_bh_disable()), it is also technically
redundant.

With the addition of RCU annotations to the XDP_REDIRECT map types that
take bh execution into account, lockdep even understands this to be safe,
so there's really no reason to keep the rcu_read_lock() around anymore, so
let's just remove it.

Cc: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/socionext/netsec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index dfc85cc68173..20d148c019d8 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -958,7 +958,6 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 
 	xdp_init_buff(&xdp, PAGE_SIZE, &dring->xdp_rxq);
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(priv->xdp_prog);
 	dma_dir = page_pool_get_dma_dir(dring->page_pool);
 
@@ -1069,8 +1068,6 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 	}
 	netsec_finalize_xdp_rx(priv, xdp_act, xdp_xmit);
 
-	rcu_read_unlock();
-
 	return done;
 }
 
-- 
2.31.1

