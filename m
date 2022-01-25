Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2229049AF3B
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455793AbiAYJHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454223AbiAYI6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:58:21 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C2AC05A195;
        Tue, 25 Jan 2022 00:18:04 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id o11so2008328pjf.0;
        Tue, 25 Jan 2022 00:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=biQLAT7AtUR8K2U6MxcC/J7RDvatov8TTpSoutm1HIo=;
        b=dzd6BZs+ci4LC9kkrG/1RZbP2dhyDWKlFXZFeplTEQioAdsl1mGbeX2QytCuKzW3g+
         Dpug/z34NMJZaFSGO0uLzG+rLNQ6ZW2eibFePeZiXY8vrCdli0E4f6DjgNs/dwcUlMZx
         ZWuaTLZuxDZ7ch3wEFQeMZePrfjzGnR46hgEFg/8DiqBeT+SYBNpvIkLqj5OoID0aVSt
         zFi25RIQy0obzq32SCmDVpCbjFGORpVUAw0wMcnWm7suuRbOekrKEHRbJAw1v7VRQYrQ
         VaB0ZPwJD8JOGRQzRdl7PrqxEjruytPFaqrjV9sO7pSgLyZTKq9wqRyzbKpACB1a+X9C
         z77A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=biQLAT7AtUR8K2U6MxcC/J7RDvatov8TTpSoutm1HIo=;
        b=m5BJKcO/CySC5J4gVHNpdm7d3rWZu00w9szxPMjAUcGYfy4LWaDltJGHeNk6y3UY3/
         24+KU0vo6LYqTVXlsl6omoKiUG5rna8IIEWQfjRypRyLCt519iVUCttlLQVCW0PUfcTC
         +AEFs7wHfGMieym0sy1O6+ploByqy7NZxo1IBgbBH6eqfI1jIxXaHAAD1WaeSEpQfbAb
         F9ZD82V3sK0SpCutU3sZIsZb/ID9qsI62i4ADoYRnmmjw1d3v/0a3w12Us/ZLVr9k+XG
         yPHgmg7pSvo5mjXkTrFmVEfnfdmXKUCW1OwsdVugZQHZy3OdiUdbPldBnfBNWHvJqpTl
         luvw==
X-Gm-Message-State: AOAM531TFMmmjCOyq8+2suQy2LQ7/s+KT1GnKJBr7tfsSjz6KwEnPepy
        f8DqZIqzCeWvuXDDSXNq9+ZIdk/gTjU=
X-Google-Smtp-Source: ABdhPJzfbOn9nSYXx7t3Kw5GFSW3Zmz37We69pbZ3EtPqvEgtSpxBHxp1mCyci+1mSksq4RPgRIU6w==
X-Received: by 2002:a17:902:be18:b0:14a:aef3:af2a with SMTP id r24-20020a170902be1800b0014aaef3af2amr17289128pls.25.1643098683637;
        Tue, 25 Jan 2022 00:18:03 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l21sm18928949pfu.120.2022.01.25.00.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:18:03 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        William Tu <u9012063@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf 5/7] selftests/bpf/test_tcp_check_syncookie: use temp netns for testing
Date:   Tue, 25 Jan 2022 16:17:15 +0800
Message-Id: <20220125081717.1260849-6-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220125081717.1260849-1-liuhangbin@gmail.com>
References: <20220125081717.1260849-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use temp netns instead of hard code name for testing in case the
netns already exists.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/test_tcp_check_syncookie.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_tcp_check_syncookie.sh b/tools/testing/selftests/bpf/test_tcp_check_syncookie.sh
index 6413c1472554..102e6588e2fe 100755
--- a/tools/testing/selftests/bpf/test_tcp_check_syncookie.sh
+++ b/tools/testing/selftests/bpf/test_tcp_check_syncookie.sh
@@ -4,6 +4,7 @@
 # Copyright (c) 2019 Cloudflare
 
 set -eu
+readonly NS1="ns1-$(mktemp -u XXXXXX)"
 
 wait_for_ip()
 {
@@ -28,12 +29,12 @@ get_prog_id()
 
 ns1_exec()
 {
-	ip netns exec ns1 "$@"
+	ip netns exec ${NS1} "$@"
 }
 
 setup()
 {
-	ip netns add ns1
+	ip netns add ${NS1}
 	ns1_exec ip link set lo up
 
 	ns1_exec sysctl -w net.ipv4.tcp_syncookies=2
-- 
2.31.1

