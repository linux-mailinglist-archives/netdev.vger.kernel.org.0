Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B779D919
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 00:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfHZW1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 18:27:16 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:35525 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfHZW1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 18:27:16 -0400
Received: by mail-ua1-f73.google.com with SMTP id s1so1591175uao.2
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 15:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kHR55eOf2d03mqaPFCc0rnz+Hpv6KeB+AOucyBkzha4=;
        b=fnUTkHGnRSymR3vzZa7b5WoOXGW9mVI5oxj5Zz89LSP2Tn8pHQeFdmzS4lFMeUYJ+B
         MagpHvLCuPnAuw7+mRU8UVKbDkk60DAt1tH4vusMl7O6DpJw55Oe0eXkp7bZfU79vdgd
         CynwLtcN6zd/vu4g9jwj0jENABlVWG4IJAA/rmXM9NisNu8HkFYzLQtijtWFlBMqGtnN
         okWhgPLJN6k6xPgaB1dzjSYZVBfd39Xmebw5gOa+iIEu3SA8Mkj66t08u3S1bALMvdkE
         5XxAiGDIdxhP2EsfGfOsuK4bbCTWuBvIZB0j3f7/7VUofYLvYA4q52GaOdcZzDZ+1hwt
         XN+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kHR55eOf2d03mqaPFCc0rnz+Hpv6KeB+AOucyBkzha4=;
        b=jEwtBK8sWvL6jsbuf8rtktexM+xVj4SxkknPszlQJfeBDezDpTm11B6CTa5Nri77EP
         8p9I8Lu8Nkfva1dkQFovZkkWwVygDnJJGOUoEnMsiGskYVsMkhlOAAXrcE2t69bk/9FC
         v/ji+Ff+A+x3UBOer+plcQDXNBDPF0R9jsl4iApiwyzU9wNA0G8OxE68/F3KTcILVkK7
         RbTh3Om9wi1v0ydNJ6Y0ZdCEe0FV8sts6vzQLe82vbQdjmRsWB/p9T1DzadMOS0j1Aia
         /lOVl8n7bhiFOvWBMT40JjEB7BzLSQzIX27aQqcoVvG+bqTA6f1tkQ4xyANOLBchA685
         sypQ==
X-Gm-Message-State: APjAAAXjjRdvoFbpGPgdDMLWgdILmImP/ARtq2vfMSt/4b2UhUyon4Vz
        k4mSkQruocPugyOeYVUK+dv99C6h43PcogwIJ/wX8dRpLO8qnNS4YqloxLaXabM9dyPZR3s6DQI
        /SQ+ULkvXizVdvwyXf9whuD1OobUJ1N8Rq6vWFQ5i6V+h74PTNIxEUQ==
X-Google-Smtp-Source: APXvYqzlk5hQ/C4oVbFOLotxGHC2FlX9UkN9t9Nf1WvGovaoktoAZKeqeF/DzADFpjbM2cMOi8EqX38=
X-Received: by 2002:ab0:630e:: with SMTP id a14mr2036205uap.37.1566858434673;
 Mon, 26 Aug 2019 15:27:14 -0700 (PDT)
Date:   Mon, 26 Aug 2019 15:27:12 -0700
Message-Id: <20190826222712.171177-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH bpf-next] selftests/bpf: remove wrong nhoff in flow dissector test
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

.nhoff = 0 is (correctly) reset to ETH_HLEN on the next line so let's
drop it.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index 6892b88ae065..d2f4a8262200 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -344,7 +344,6 @@ struct test tests[] = {
 			.tcp.dest = 8080,
 		},
 		.keys = {
-			.nhoff = 0,
 			.nhoff = ETH_HLEN,
 			.thoff = ETH_HLEN + sizeof(struct iphdr) +
 				sizeof(struct iphdr),
-- 
2.23.0.187.g17f5b7556c-goog

