Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E9B3FCBEF
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 18:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240367AbhHaQ7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 12:59:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58063 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240350AbhHaQ7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 12:59:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630429105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5O4cN5GN4rES6GaYCNOSVbONIJtZrh2SfxoFUXUD9nc=;
        b=b6Nf4dAVvyFbEcKslv9ap/fj4NLYmwJxb0vKZbFn4SClha29OhPRFFqRGZOkeXZ29AH9jq
        ebBKkl3tY2yXI9clsTuz8qBWZDt49Wh2EovXfg/eE7QjaoYsbwN5AtTlI7RHa65z5o9fU4
        YKAN7zg1suE9CD3dTjrKZC8XZDKQhR8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-XRPNGdQpMNaGtXVXga9oHA-1; Tue, 31 Aug 2021 12:58:24 -0400
X-MC-Unique: XRPNGdQpMNaGtXVXga9oHA-1
Received: by mail-ej1-f72.google.com with SMTP id q19-20020a1709064cd3b02904c5f93c0124so16843ejt.14
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 09:58:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5O4cN5GN4rES6GaYCNOSVbONIJtZrh2SfxoFUXUD9nc=;
        b=JDJ+HVoVePRP+R+u5wz+WG4Ysz2P/0ybVY0tc8ytSaRZL6j6u0QIEVNG4qTUttXgpp
         mMlFVKFlJNuzkDKHM5Qazy2BlKAdcAK2HOP/mLxyP/CZ12VvAAvwKET0q0ONnA2dT06W
         nIvkz4u8R6syuBcGtaJ52ONUGA4PJEhGj/Qxb12ttuNY1Fqks1FepDruTX+9RbCIvknN
         9DovLMCCUDL11DV+khXlSjYvfBdbsp71J6xpe5MFVOazafrIqHpUWXIUK7hIdHZWG6we
         j140KNuiObaq61vzz6YglaFMn08cmK8x1RWINLcJ2MMj3aN3f4I3hmtwqVmq0YcmtThs
         1huA==
X-Gm-Message-State: AOAM532a+fi/Xyl1wkSuyquAMfuUS1u59j3WrWHd08gAa0M02xJCCp+H
        InSQ0p0w/JZX7l8SHAffOJjTh0r3qjV0UZgVMsuWbH91xp+VuDZrs+I9EDn78tL/z0TZg2VOnBh
        ae++p+CS+Tkj2MGp9
X-Received: by 2002:a17:906:7d83:: with SMTP id v3mr31920118ejo.216.1630429101995;
        Tue, 31 Aug 2021 09:58:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpUVqdypaPmTVrhaipJVHrC1X5LmDfF9NeucZle44BTObeNdYlW+Id4S+7bhi0U+/iiaipSA==
X-Received: by 2002:a17:906:7d83:: with SMTP id v3mr31920065ejo.216.1630429101275;
        Tue, 31 Aug 2021 09:58:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id jx21sm6554677ejb.41.2021.08.31.09.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 09:58:20 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B6AD91800EB; Tue, 31 Aug 2021 18:58:18 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf] libbpf: don't crash on object files with no symbol tables
Date:   Tue, 31 Aug 2021 18:58:02 +0200
Message-Id: <20210831165802.168776-1-toke@redhat.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If libbpf encounters an ELF file that has been stripped of its symbol
table, it will crash in bpf_object__add_programs() when trying to
dereference the obj->efile.symbols pointer. Add a check and return to avoid
this.

Fixes: 6245947c1b3c ("libbpf: Allow gaps in BPF program sections to support overriden weak functions")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6f5e2757bb3c..4cd102affeef 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -668,6 +668,9 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
 	const char *name;
 	GElf_Sym sym;
 
+	if (!symbols)
+		return -ENOENT;
+
 	progs = obj->programs;
 	nr_progs = obj->nr_programs;
 	nr_syms = symbols->d_size / sizeof(GElf_Sym);
-- 
2.33.0

