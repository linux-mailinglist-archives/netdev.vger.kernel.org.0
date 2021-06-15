Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A45D3A8353
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhFOO5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:57:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31261 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231373AbhFOO5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:57:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623768907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pWOmo2Dp6By21aiJoC+yh22NhewuBztqhmsfyiwQHMk=;
        b=NEMRMdHzd5MSDhuRDJJgbmjb496iVQ7TcwcnPE6RlxUxLRighUaXY7dGrcZEG1bDPoutwQ
        j95+SROQrr0woT6uvoVq/kNGTbIBhm4fwjfdbI4o+xUer6yLhlfcvaCz/PxYAJ1noLCRTt
        3h8UEp8XQEEL2nyCEOyCqtENdQDmlfI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-mib89zg6MyWaMoSARM9Abg-1; Tue, 15 Jun 2021 10:55:06 -0400
X-MC-Unique: mib89zg6MyWaMoSARM9Abg-1
Received: by mail-ej1-f70.google.com with SMTP id w13-20020a170906384db02903d9ad6b26d8so4689860ejc.0
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 07:55:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pWOmo2Dp6By21aiJoC+yh22NhewuBztqhmsfyiwQHMk=;
        b=OWboMky2Ot0U02DCQu6f7X6s8NhKgjzeqFCIVKsFcvU2IXa29rRr0H/S9H6lpJ3nYB
         AuKDoWqThBoBJQImwxAEZb8FARz1IYkF6NbCPJ9aM+D57CYHEIKHgmHrzK5D7SgWY0qg
         uxK8Oy9LDRRuwIxAX59IqK4nYrEwaBhPLNZW9ZqWuW8ou92fRrynVt6jnqqaHT2mTUXH
         LiIcPVVCmrqg0HHNIqjjJnazbrrgSGeoz30eQnE4AwI9e3MItj2TRMG673SjxSf8AD9f
         6eLWzDLsrYPf8quTR7lxPrgF3Ja06C6Ru4elFx1ECOUGudnl54tVx9ubzlyDwkXn9vIP
         f1Fw==
X-Gm-Message-State: AOAM531rtahNyYH3JEmlhJkOPqvHHWAh6Gc1ik6aIkw4g1GbGTiopOdW
        HPN9XMLhLn4P8EJEIhPIVwSBsow+2FO9cq0PLEOgWw7ddR5JmFj6UPYq+SvziLLSFEo0+WDllzk
        +QPXTezy41oGxgd8z
X-Received: by 2002:a17:906:5ac7:: with SMTP id x7mr5156299ejs.330.1623768905247;
        Tue, 15 Jun 2021 07:55:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzReB1fFu1rxm9m0nqkBN7wrp4chHKHdJVz9CZHmQ8NOXRhVatb2uiKb9hWHsPUxKuHc0Lkog==
X-Received: by 2002:a17:906:5ac7:: with SMTP id x7mr5156279ejs.330.1623768905088;
        Tue, 15 Jun 2021 07:55:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id qh23sm10187974ejb.77.2021.06.15.07.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:55:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 08B1B180735; Tue, 15 Jun 2021 16:54:59 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com
Subject: [PATCH bpf-next v2 12/16] qede: remove rcu_read_lock() around XDP program invocation
Date:   Tue, 15 Jun 2021 16:54:51 +0200
Message-Id: <20210615145455.564037-13-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615145455.564037-1-toke@redhat.com>
References: <20210615145455.564037-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The qede driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
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

Cc: Ariel Elior <aelior@marvell.com>
Cc: GR-everest-linux-l2@marvell.com
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 8e150dd4f899..d806ab925cee 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1089,13 +1089,10 @@ static bool qede_rx_xdp(struct qede_dev *edev,
 	xdp_prepare_buff(&xdp, page_address(bd->data), *data_offset,
 			 *len, false);
 
-	/* Queues always have a full reset currently, so for the time
-	 * being until there's atomic program replace just mark read
-	 * side for map helpers.
+	/* This code is invoked within a single NAPI poll cycle and thus under
+	 * local_bh_disable(), which provides the needed RCU protection.
 	 */
-	rcu_read_lock();
 	act = bpf_prog_run_xdp(prog, &xdp);
-	rcu_read_unlock();
 
 	/* Recalculate, as XDP might have changed the headers */
 	*data_offset = xdp.data - xdp.data_hard_start;
-- 
2.31.1

