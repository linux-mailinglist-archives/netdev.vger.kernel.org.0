Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1864E3B1882
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhFWLKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:10:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230205AbhFWLJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:09:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624446459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LUCuBp+kMAaiYhpJP43bLBOzgEXgjURSXqNOTfyeabU=;
        b=VWQt80RtVNXwPvukaon6UZmYZxuttdvGqFJ6Zu83iTc/IBWMTory0foFeSTa9pFl55KvOz
        CQ15IY4CqwTkuv3R/OaQ8ZzXL9wYdlno/B42hLWe1IbH730ZK+EEX60batRMIb3Ppx6DJB
        hOgzQrfPzdJfJWhNtFtLakpguSHKfuQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-SwjodxeBN9-608vPAdCvvw-1; Wed, 23 Jun 2021 07:07:37 -0400
X-MC-Unique: SwjodxeBN9-608vPAdCvvw-1
Received: by mail-ej1-f71.google.com with SMTP id j26-20020a170906411ab02904774cb499f8so849677ejk.6
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:07:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LUCuBp+kMAaiYhpJP43bLBOzgEXgjURSXqNOTfyeabU=;
        b=pD/d1YsYfZ+T9Y4uiWp8uufRcSYAJSJudkBmqEb4Z1fWgU3aW3FiiYJQPHq9q4ScID
         rryfKQdXwO+0rvvGWZRgYjpeilCFQHWaI00xE7JXxWi4O4kMrXAx14NCMAAxoaU6ri8g
         h/33c7K6He0E1Jym9E0I965w8zzC4na6tzSnqfCUT76QC3auB9vW5fTKESVrAzaJjWr7
         ikzLW/AsZVy1gVZR/vc69lVyD92C7DWt5Wok/fRLRFlRX1Ci/KYkJxVFFIiP+3LMpDwU
         ndPFBsc2g75TqXHh+IThWVgVWA01fh2SQnJ25M7+aX4JAeHiB1D93LGLvaRLFLcV18HZ
         1u4A==
X-Gm-Message-State: AOAM531EQzoQ8adlMqOlj6lcYRG4jRlmeghtxHExCHkyMPv0D5HLc3AE
        GJnwOVTvgO5faMSnUXbp4RPZAakkMGOxagVf5sDxGT39BBC2Cmw237rYcC6o6vxOzDAL7ZNGxIV
        EkGSB7tpvAHzLjVmy
X-Received: by 2002:a05:6402:34d1:: with SMTP id w17mr9016403edc.167.1624446456599;
        Wed, 23 Jun 2021 04:07:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzryCgWTnTknnV/8acg2toeAqckr6zU4GlElUrLt6wlnzWfynQHUxYeQyBdepxK81ABJex3bg==
X-Received: by 2002:a05:6402:34d1:: with SMTP id w17mr9016360edc.167.1624446456219;
        Wed, 23 Jun 2021 04:07:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id w2sm7152669ejn.118.2021.06.23.04.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:07:30 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0CE81180733; Wed, 23 Jun 2021 13:07:28 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v4 03/19] doc: Give XDP as example of non-obvious RCU reader/updater pairing
Date:   Wed, 23 Jun 2021 13:07:11 +0200
Message-Id: <20210623110727.221922-4-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623110727.221922-1-toke@redhat.com>
References: <20210623110727.221922-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit gives an example of non-obvious RCU reader/updater pairing
in the guise of the XDP feature in networking, which calls BPF programs
from network-driver NAPI (softirq) context.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 Documentation/RCU/checklist.rst | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/RCU/checklist.rst b/Documentation/RCU/checklist.rst
index 07f6cb8f674d..01cc21f17f7b 100644
--- a/Documentation/RCU/checklist.rst
+++ b/Documentation/RCU/checklist.rst
@@ -236,8 +236,15 @@ over a rather long period of time, but improvements are always welcome!
 
 	Mixing things up will result in confusion and broken kernels, and
 	has even resulted in an exploitable security issue.  Therefore,
-	when using non-obvious pairs of primitives, commenting is of
-	course a must.
+	when using non-obvious pairs of primitives, commenting is
+	of course a must.  One example of non-obvious pairing is
+	the XDP feature in networking, which calls BPF programs from
+	network-driver NAPI (softirq) context.	BPF relies heavily on RCU
+	protection for its data structures, but because the BPF program
+	invocation happens entirely within a single local_bh_disable()
+	section in a NAPI poll cycle, this usage is safe.  The reason
+	that this usage is safe is that readers can use anything that
+	disables BH when updaters use call_rcu() or synchronize_rcu().
 
 8.	Although synchronize_rcu() is slower than is call_rcu(), it
 	usually results in simpler code.  So, unless update performance is
-- 
2.32.0

