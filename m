Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9E43B6B21
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 01:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbhF1XDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 19:03:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235313AbhF1XDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 19:03:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624921269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wET16Z+BojG4tjaqWO4XLxsxQNkC9SqpExUXVqFNB/Y=;
        b=Um4/V7d07wIP9/cvoE1GB5eooJw35vgVyjhApnCquN05LAvx4Mqtbx+FmFvAc/kNee9Wur
        owp/sYILmHd2lAg6DxeQoWEH7cJK9B+IwwYnffN0V1qDNvHRm4urLQ8CFD7eCn6TyjINc+
        yxnds9gjhQt/kcuK6P4KSleryU7Hj/8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-1SugnKfmPe-njhiO0l8Wnw-1; Mon, 28 Jun 2021 19:01:08 -0400
X-MC-Unique: 1SugnKfmPe-njhiO0l8Wnw-1
Received: by mail-ed1-f72.google.com with SMTP id p13-20020a05640210cdb029039560ff6f46so2825476edu.17
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 16:01:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wET16Z+BojG4tjaqWO4XLxsxQNkC9SqpExUXVqFNB/Y=;
        b=m3uvsCuyXwLmgQDMU5NHdRYNnz+R0YtU23yiAzJ/hCtpbUFAIySkIoAofz8tahMC9H
         /muj3Q1Y6iAf9EeUkG6Cbl7EhcMvaoKq+L2NPj+s9WIaxprYt91HTiXPEryPFxJ8HQDQ
         UlCdZZTcEJT8tDk6UYSDRGtwXscOnfzCtOWicKmWWDAHE8wnwBL2cXafstCjFLJ07sG6
         nITvQmRiQwYAld6iJey5f0Ltz0VF73ckISNY50fb9+/PeW9kw48pWo8OSL/M5y917un/
         qdB90hQA/LHXkUdfTPGUMiweIYEHsKRJ7cxJkI/jD4LWq42TnJGKskAhFtdfelOgXnfN
         Vu+w==
X-Gm-Message-State: AOAM530QhNQkRwJtZ+jQA9Hf5KoyZQh0Xwp3OuORC5/WNtAyuWvu2YtC
        GdJ1X1hT3QRqRpCucwdsmH9cIo+A/tBF+hXcmLK2u+BK8NUSd5gV00rrWJJFXTiZUqg2slAKedF
        Fcc+by3wqiJ78weKR
X-Received: by 2002:a05:6402:4243:: with SMTP id g3mr18788276edb.118.1624921266971;
        Mon, 28 Jun 2021 16:01:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOkhovZmeE6X4ovlHzS0eNaA0YXEDY/lSgliR+5z8ViDbIlcWecWw/i/RKdJoqWe8GOiDYuw==
X-Received: by 2002:a05:6402:4243:: with SMTP id g3mr18788244edb.118.1624921266707;
        Mon, 28 Jun 2021 16:01:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z28sm7165024ejl.69.2021.06.28.16.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 16:01:05 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 280AE18071E; Tue, 29 Jun 2021 01:01:03 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH bpf-next] bpf/devmap: convert remaining READ_ONCE() to rcu_dereference()
Date:   Tue, 29 Jun 2021 01:00:51 +0200
Message-Id: <20210628230051.556099-1-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There were a couple of READ_ONCE()-invocations left-over by the devmap RCU
conversion. Convert these to rcu_dereference() as well to avoid complaints
from sparse.

Fixes: 782347b6bcad ("xdp: Add proper __rcu annotations to redirect map entries")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/devmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 2f6bd75cd682..7a0c008f751b 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -558,7 +558,7 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
 
 	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
 		for (i = 0; i < map->max_entries; i++) {
-			dst = READ_ONCE(dtab->netdev_map[i]);
+			dst = rcu_dereference(dtab->netdev_map[i]);
 			if (!is_valid_dst(dst, xdp, exclude_ifindex))
 				continue;
 
@@ -654,7 +654,7 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
 
 	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
 		for (i = 0; i < map->max_entries; i++) {
-			dst = READ_ONCE(dtab->netdev_map[i]);
+			dst = rcu_dereference(dtab->netdev_map[i]);
 			if (!dst || dst->dev->ifindex == exclude_ifindex)
 				continue;
 
-- 
2.32.0

