Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D905A3FD8FB
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 13:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243259AbhIALt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 07:49:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243905AbhIALtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 07:49:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630496902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TpKhRaDL5uh9kwtULNfhD5GpIDEUbSUYlpxLcPeJ2GI=;
        b=S/nF3HLShRvvJ/zysYn0iUZRnUn7Ot3RUBH1AawGsecXLEN7tZDFujIz5oacAoiSUb00J2
        SQzRoMrDoRmBPKXP7crtx+TB0Ep3DtR/T8i8d/0ywYNUHRSXlwiry4SGiTHdKq20cFrYp5
        rv9Z/1atQe1G6x7XAlJiiXicvtYy/48=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-RP-2hYwdPm28iZRyf2NirA-1; Wed, 01 Sep 2021 07:48:21 -0400
X-MC-Unique: RP-2hYwdPm28iZRyf2NirA-1
Received: by mail-ej1-f72.google.com with SMTP id o7-20020a170906288700b005bb05cb6e25so1258639ejd.23
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 04:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TpKhRaDL5uh9kwtULNfhD5GpIDEUbSUYlpxLcPeJ2GI=;
        b=uLk5x3kze2fc4k1vlSkYimjR1m70YscbJ4CliHtI3KJkHjhnQj8ytKbTbJ1UGUqCSn
         0fsHzgxEc1++LXGz1ZOhLLua9teQcACMSP90vSmK88mki+ENLIfp94ijM/sG4iZgVsLc
         m5Eu9tYh0aKvLNnK9Vq8nQZ6aO41Uh+SlKaT8e6M2vCFVxFaLVwIuJrkNTuLdA144pnZ
         IcToflFsEvazP8pCIlKI+rnj9qDNfNzmBLymmEUiq+M4uo7hn0E9nTLNpZkVoBaWyy+7
         k9bkrADXCxOGVzGdJOHwjr7pjnotQRz9+dmEDc/1mFnuZdEMUIrtrHBccAHcfPGiFc8R
         JpQA==
X-Gm-Message-State: AOAM531qjAEiIepOBuXFfSkPu/cQg1iCXajHjmIXbKAq+HPbR0Syf+m6
        y0EKJ3uVP3qVCycEsb9ixImLb/NUzXGO4+2WmfN0FRwKvxme6YMbPAjx+RaXyei3YClDOi389nW
        DfHU661spUwskfJky
X-Received: by 2002:a17:906:e82:: with SMTP id p2mr36393368ejf.50.1630496899666;
        Wed, 01 Sep 2021 04:48:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0cnkbRVkbiVq+hTOc9zTMTCSJABSikudZcY4vayfYyx6/T8yZ+cgbzsYY0TjPgbJzplvpbA==
X-Received: by 2002:a17:906:e82:: with SMTP id p2mr36393343ejf.50.1630496899383;
        Wed, 01 Sep 2021 04:48:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d22sm10009367ejj.47.2021.09.01.04.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 04:48:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3A8031800EB; Wed,  1 Sep 2021 13:48:16 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf v2] libbpf: don't crash on object files with no symbol tables
Date:   Wed,  1 Sep 2021 13:48:12 +0200
Message-Id: <20210901114812.204720-1-toke@redhat.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If libbpf encounters an ELF file that has been stripped of its symbol
table, it will crash in bpf_object__add_programs() when trying to
dereference the obj->efile.symbols pointer.

Fix this by erroring out of bpf_object__elf_collect() if it is not able
able to find the symbol table.

v2:
  - Move check into bpf_object__elf_collect() and add nice error message

Fixes: 6245947c1b3c ("libbpf: Allow gaps in BPF program sections to support overriden weak functions")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6f5e2757bb3c..997060182cef 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2990,6 +2990,12 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
 		}
 	}
 
+	if (!obj->efile.symbols) {
+		pr_warn("elf: couldn't find symbol table in %s - stripped object file?\n",
+			obj->path);
+		return -ENOENT;
+	}
+
 	scn = NULL;
 	while ((scn = elf_nextscn(elf, scn)) != NULL) {
 		idx++;
-- 
2.33.0

