Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D593B3371
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhFXQIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:08:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60195 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229721AbhFXQIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:08:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624550775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LUCuBp+kMAaiYhpJP43bLBOzgEXgjURSXqNOTfyeabU=;
        b=iQv7doFWKpFTcQVlCBd9dfo/9VPAsiBT8OS8HsJhy9343o+AuYLdnUzJFb5Ue7lfuQHWoA
        4K5e4X1tNxRuizEaKRFJCKayt/8wsGCbhhaK0VEdZ+xzYPXCteLl9pHflFaqZGw39zF4ZU
        BDZFNfOCy4w/BhdN6x4BtZUf+Kopww0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-gF__uSGUNpS0gP05HspmPg-1; Thu, 24 Jun 2021 12:06:13 -0400
X-MC-Unique: gF__uSGUNpS0gP05HspmPg-1
Received: by mail-ed1-f70.google.com with SMTP id x10-20020aa7cd8a0000b0290394bdda92a8so3633770edv.8
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 09:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LUCuBp+kMAaiYhpJP43bLBOzgEXgjURSXqNOTfyeabU=;
        b=XNuqXiBYJFyeGfyUi9sKtvBNT+wKo+sL+nMTxGKiYw+6kweKvFznGmzPLsz58n0Kcm
         DpliMdcfYVQxgqEdS8xfFeFwsSNq4TzDeJIWhVqGNLYYC1nTObKrKut7EMHWyPk54qTf
         aM5nRrZvggGNloMtcn5RFDftA0k/FV9iY2nLP1RE0l7vO/r7/vNCL5kbymxlU4J/hqdo
         9TQtu71YWS6iRpZxZAOi7w6uhK2uQngvdwtDHgyAlsixRwBliehlu8fcST1xHzddrcnU
         CR6JAHNn+nd3iYzartx1UcW37EScd7pxl78FIayjZV7jM48qG52/FwB+v0HvKvskoGWt
         jUnQ==
X-Gm-Message-State: AOAM532m0J6BoYjf7bf3mhOi+he92kLO/Rf32acDnw7QNYYPHWDjwlzk
        Dje+VHW8bZFqGBNMuQ4CJSmoo/3naz5u4SuZXU1zZKA8zaa/VvjlIhq3VQcyzDNBeiZTBaV//2I
        yhKzfgq45dD7b5TZq
X-Received: by 2002:a17:907:628a:: with SMTP id nd10mr6096696ejc.326.1624550771943;
        Thu, 24 Jun 2021 09:06:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz55VnSDUxxZZ06Nn0vmqQ6jiFhvp9YY16kWSNeRKwWhkFZsY6OEmU/ZAjLIAB99qnGX5fy9w==
X-Received: by 2002:a17:907:628a:: with SMTP id nd10mr6096659ejc.326.1624550771402;
        Thu, 24 Jun 2021 09:06:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id ci3sm1445516ejc.0.2021.06.24.09.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 09:06:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3FAA8180734; Thu, 24 Jun 2021 18:06:10 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v5 03/19] doc: Give XDP as example of non-obvious RCU reader/updater pairing
Date:   Thu, 24 Jun 2021 18:05:53 +0200
Message-Id: <20210624160609.292325-4-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210624160609.292325-1-toke@redhat.com>
References: <20210624160609.292325-1-toke@redhat.com>
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

