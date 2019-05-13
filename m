Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 742831BD93
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 21:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbfEMTEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 15:04:40 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:54307 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727849AbfEMTEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 15:04:40 -0400
Received: by mail-ua1-f73.google.com with SMTP id 45so1515888ual.21
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 12:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=oR8zQU2Zd3bm0eoT1c69aX6y+IQJBeinTbkDZoPCRQo=;
        b=Yrcw+b/UvsPlCbLHRvvnToX6ehGI17r3/iVF3KBzx3OBXmQ5Od/l7/BXOgoUNauZb0
         y6qX/mGY6Owrf84S6ERE0ghXSLREDm7gLd3BrXZXFOowzkqOeu66irrHOtK6UJR60hDN
         FM/2Z8KoUs6T7wbK0BIFKQMEdNWlFMoFzHEPMCi1gYJAKxOSIndHRXZyGz4HzCo3SIRz
         vfI4vg1sPDH8dV7jFCvfAuXq3D5C0i5OB1DzhwZY4pB3rsPYsJKucSwVEC3v2F2bVQUY
         Gi741zmBOwDIaXBe4qE3jfZKaFZ86RKNFlMjoK2jpZBLc1l1mte7cFh+3VWA7lQa2t29
         ODIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=oR8zQU2Zd3bm0eoT1c69aX6y+IQJBeinTbkDZoPCRQo=;
        b=M5TC4sS1X41yDaGSVHvXbxmdaXPsp6GQoKIb/1hgFQ31QouXLEV//fMIluHa0BR/Xa
         JVACRqa6NbuT/8Cv8bVN01N9Cveh+QZe1aJEgb/DlGsylguMghoB0uo6bvxEswqpC+h7
         HgLabPu4qAP9/IgzcDGaNyTIEfxEYzwfJ4KhuFRoYIUD1aftRx0sGfjqB3RDxdiOaw06
         QVgBD+U02/wBhtALm2welZ1Jv5tVgippmqV0vXAoQI4JxXwAcEN0mtlqxKA6CNgOePMv
         wkO9mI/Po2Ttd9/zhLDhmTcm1VCXG2qRdyH1nS3yXi172mJ1/9YBdi5274I80rPKANpb
         6Hig==
X-Gm-Message-State: APjAAAW5TSU0wKogGz7AdA0JvlqDqY5pWI5FgJH4pZB2NJgUiqGrUz6i
        LN8g1nOc6UyzeUlcwaNsf0VVa59ogwyxswdnQAw1G9cMjKb1TOTxKW3r3Uc7a9fws85SXkO2kjw
        aFcEDFB8zDjmmXYQtf52hCDBD7LDr86ECTp+RD7Na/1QuNwV1TYAgJQ==
X-Google-Smtp-Source: APXvYqzImIva+4pxY72XI3JSo2VA+GQHezF49xYTfBBSO8PxBC+B3KDIhBUMCHs+Z3KnztBXZG+Hrlc=
X-Received: by 2002:a67:ff8b:: with SMTP id v11mr4306982vsq.88.1557774279361;
 Mon, 13 May 2019 12:04:39 -0700 (PDT)
Date:   Mon, 13 May 2019 12:04:36 -0700
Message-Id: <20190513190436.229860-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH bpf] bpf: mark bpf_event_notify and bpf_event_init as static
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both of them are not declared in the headers and not used outside
of bpf_trace.c file.

Fixes: a38d1107f937c ("bpf: support raw tracepoints in modules")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/trace/bpf_trace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b496ffdf5f36..f92d6ad5e080 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1297,7 +1297,8 @@ int bpf_get_perf_event_info(const struct perf_event *event, u32 *prog_id,
 }
 
 #ifdef CONFIG_MODULES
-int bpf_event_notify(struct notifier_block *nb, unsigned long op, void *module)
+static int bpf_event_notify(struct notifier_block *nb, unsigned long op,
+			    void *module)
 {
 	struct bpf_trace_module *btm, *tmp;
 	struct module *mod = module;
@@ -1336,7 +1337,7 @@ static struct notifier_block bpf_module_nb = {
 	.notifier_call = bpf_event_notify,
 };
 
-int __init bpf_event_init(void)
+static int __init bpf_event_init(void)
 {
 	register_module_notifier(&bpf_module_nb);
 	return 0;
-- 
2.21.0.1020.gf2820cf01a-goog

