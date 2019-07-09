Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41EFE638FD
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 18:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfGIQAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 12:00:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38912 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfGIQAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 12:00:10 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so21613646wrt.6
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 09:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ROsNFih7aIvvYO4hZ5LpXiKTnrDc8efW5guC8WGQZAw=;
        b=EKpUQxwAsHl18XAedG474jFr2avJwJHYl0zPpR1MrdKvzJwS4qSHxm/CnIF56X82EC
         DcdBEd3AGgHQ7ykBzRE5P7c4zfnXKhEc/CPSy8iWZ6eefY5wN1GLUZJGtWKUJNqqt/yO
         qJ16FWkRjwM73XA11bVY+aJ0rlZGqAN3ky8jo7T69lGcele6FZ6duL6J+eX15XIrjWbM
         SdQaHKc4QyHRobEf3U0+pZyJb0Ajc70aJA69tjlhQ9v5yu0ZavLicnczj2t1qxIhxl9P
         frwuHRSF8bg0i/BPJRwaIotD8Rb2hSTP4jXTSLQ9isHLJwx502s3d5CMDEA/t/l1J7B3
         N4lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ROsNFih7aIvvYO4hZ5LpXiKTnrDc8efW5guC8WGQZAw=;
        b=QspnGMN13LijakKoAa6S9Ka+xUw5Nqkknc1envMCGQ3ehFFzvejnxPdTu7AXVAiFc2
         QHLQqCd/Fb3AW94lArfQ3KuoxRj1pWa4RIyhihZ2efT0iPwqFWbDHuOHXK2fYrNhYY6g
         Mp67+MboII1KO4i7A24wlHGsx17xGmjBlV3BLOqgKaAOBJzAgtHBYkSxh+610qBxUmVj
         KP4xDfBLUpVL9tMaosmoKtok2dXkxJUZNDCnGQ+WmbY/KwulTyvGEm188jRUIdZOBeII
         hsRUoODAc+7MsH3+QfYXbQwpmW46YSm/rAJOsJr0ourUK5agMo+Z3VM+H3C1GbhegRR0
         1f+Q==
X-Gm-Message-State: APjAAAWmv3wErhARWScTLziqcxMYL9YMz8R9ptFCmaGnvR785egauazz
        2S5MVmCczwYjGjywTofMl0NdROkeDEE=
X-Google-Smtp-Source: APXvYqzU3E+rDRkXb7xk+VcV/2UxNCLEz29vOoqUShFYDYTlcCY+ZtFPj7wB5ZG7ZEb3OKqd8xFQkQ==
X-Received: by 2002:a5d:5348:: with SMTP id t8mr25230133wrv.159.1562688008616;
        Tue, 09 Jul 2019 09:00:08 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id t6sm3725900wmb.29.2019.07.09.09.00.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 09 Jul 2019 09:00:08 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH iproute2-next 1/3] lib: add mpls_uc and mpls_mc as link layer protocol names
Date:   Tue,  9 Jul 2019 16:59:30 +0100
Message-Id: <1562687972-23549-2-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562687972-23549-1-git-send-email-john.hurley@netronome.com>
References: <1562687972-23549-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the llproto_names array to allow users to reference the mpls
protocol ids with the names 'mpls_uc' for unicast MPLS and 'mpls_mc' for
multicast.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 lib/ll_proto.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/ll_proto.c b/lib/ll_proto.c
index 78c3961..2a0c1cb 100644
--- a/lib/ll_proto.c
+++ b/lib/ll_proto.c
@@ -78,6 +78,8 @@ __PF(TIPC,tipc)
 __PF(AOE,aoe)
 __PF(8021Q,802.1Q)
 __PF(8021AD,802.1ad)
+__PF(MPLS_UC,mpls_uc)
+__PF(MPLS_MC,mpls_mc)
 
 { 0x8100, "802.1Q" },
 { 0x88cc, "LLDP" },
-- 
2.7.4

