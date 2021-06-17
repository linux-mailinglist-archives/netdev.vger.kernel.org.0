Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E453ABE0D
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 23:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhFQVaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 17:30:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233045AbhFQVaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 17:30:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623965283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h2Vi9XceSPVZfLpkffqV3pCVibBmY0ByVpnQRv2lfdE=;
        b=YS+1cSJxvroIY0LLcif7PJxPOT5xDNu+a1+KYWHTjA4lbIf9RJlCEXH6Ik5rzBa8aB4xL6
        xtDtwo1a8kuT5kguHB3gAC6nzRs8xLREqI02OkwjHGLQ3sGnczXLHCVcIIgk6m/IvS7MLU
        6ByvBVcrlQUiau+Ng7snyZ+hbTKsTP8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-Wndln36GNJ25wPqYgM2_cA-1; Thu, 17 Jun 2021 17:28:02 -0400
X-MC-Unique: Wndln36GNJ25wPqYgM2_cA-1
Received: by mail-ej1-f72.google.com with SMTP id u4-20020a1709061244b02904648b302151so3021096eja.17
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 14:28:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h2Vi9XceSPVZfLpkffqV3pCVibBmY0ByVpnQRv2lfdE=;
        b=sp6uiEzwGjlZsHxNtPobbQRtrl+3njOnBhOxPuVDhuRBNUvuOGt7j1UR6ymuITXcjN
         7+z+u4U67fK8t3je0QW42VkTrjm6WqOXvchcgee9RJI+3VeNs9fuPl5jKSFTAz4niopf
         zCXTccSKtwZCkkMrvKJPu3bjLykoSljDMjTsXQkT/OjNex0Gut2I5wI9PO/1FbRCtXJa
         URbNtmUB2eZrAjvE0ILQ+PjTATd5a0nvqRsB+1HMBthEfcnnXh0TSY8DRFr7qCldQKBt
         IJLpywTN7UGcq/9EU2nkPKGOHyAvVdkRdEs8W2Zw6oiWzb/ZGFhdt+OiAnWgTC6YLi78
         iuSA==
X-Gm-Message-State: AOAM533eZnv7ENNXY4Q/mCjocYzdc3DaH0f2bRLGHSVpu0BeeTDCCLib
        u4zqY3jGQKlKJkFnhEGyHlOa249XK1WkNWLZbutw6eT6m6vi9VNJ0LPHD098jp6nHrNq7AGHXI2
        CCdkpw9KKbW7QtmCG
X-Received: by 2002:a05:6402:42cc:: with SMTP id i12mr418827edc.345.1623965280725;
        Thu, 17 Jun 2021 14:28:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7GdrC2OmFDGjTuzCjTi7XENVhneXkF+uyTA4qSW3+SnXwzyHh4ZUMgJUipj8lkd9TnOv6ZA==
X-Received: by 2002:a05:6402:42cc:: with SMTP id i12mr418777edc.345.1623965280307;
        Thu, 17 Jun 2021 14:28:00 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id hg25sm108948ejc.51.2021.06.17.14.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 14:27:59 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DC3F4180738; Thu, 17 Jun 2021 23:27:54 +0200 (CEST)
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
Subject: [PATCH bpf-next v3 15/16] stmmac: remove rcu_read_lock() around XDP program invocation
Date:   Thu, 17 Jun 2021 23:27:47 +0200
Message-Id: <20210617212748.32456-16-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617212748.32456-1-toke@redhat.com>
References: <20210617212748.32456-1-toke@redhat.com>
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index bf9fe25fed69..5dcc8a42abf9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4654,7 +4654,6 @@ static int stmmac_xdp_xmit_back(struct stmmac_priv *priv,
 	return res;
 }
 
-/* This function assumes rcu_read_lock() is held by the caller. */
 static int __stmmac_xdp_run_prog(struct stmmac_priv *priv,
 				 struct bpf_prog *prog,
 				 struct xdp_buff *xdp)
@@ -4662,6 +4661,9 @@ static int __stmmac_xdp_run_prog(struct stmmac_priv *priv,
 	u32 act;
 	int res;
 
+	/* This code is invoked within a single NAPI poll cycle and thus under
+	 * local_bh_disable(), which provides the needed RCU protection.
+	 */
 	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
 	case XDP_PASS:
@@ -4696,17 +4698,14 @@ static struct sk_buff *stmmac_xdp_run_prog(struct stmmac_priv *priv,
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
 
@@ -4976,10 +4975,8 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
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

