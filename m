Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20E0C8E1A6
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 02:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbfHOAEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 20:04:01 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:39625 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbfHOAEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 20:04:00 -0400
Received: by mail-oi1-f193.google.com with SMTP id 16so628389oiq.6;
        Wed, 14 Aug 2019 17:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YPTBaJLD3D/u6walQ8y9NQD1N5lcuts2Kk/49zILziw=;
        b=a9kKTsPERfA4T4/IuV7BQpfXwEmT0OefjpLqFp1KOxPeJV7X0ITbcYyTNHrxcDkP0U
         cLZ3tX7s4hLtexS5/mGOUhUcZaXLlfOtcOOGNO6AAaEBRLlRZea+EcP42OSlRoIsAeo7
         FeiEpZYerJsJk84Y8N3YdYC5/hF9FSYI9oY+CNRIQie4hBt6W8nAZkz3ZXhtLuzSjwn8
         tQoKcKz0qAioZ17+nR1UFeopJQDZ2wOF7qmOd8cx5npJy8diDudk9IOX9Gio0M/ITD8H
         TGwoc8oLl/PMcuUPa5okGq+7kUaXueotRBHcyGQpJke/zqfT8u8SKhXIcZi7jC6VNGMj
         HPbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YPTBaJLD3D/u6walQ8y9NQD1N5lcuts2Kk/49zILziw=;
        b=iF8X9G4tF/REIlbDkNJZA6Rz0q0XfBEHv6BQKAuB+pIqODb8Lb0Zs9LOjdQqkFrMEL
         8DP2ZAHUWS9fb08KjApBqlr/B9ehRSV+hdhjD6AN4N1rHZ0GAvIUekGYT04JLQCLdIHo
         ee7VMEePI4uWlKUsXPfMMR5mKL1RJq+NXUMIAIx6GxYxeq4NDiqTq2zQ60w87Pp/OD18
         kvEey6vm88M2Wbp4vJaQyaq0DSHqFe+9RzBh8iQaxNBKlLwRSHHMoqZe5kLYHL+/hIjF
         UGlLKmGjkynXI5ccXPNt+0HD6ihqRmvXqTYsas2y+aq58rmrM4CnAgpVipu00pDhzBLo
         Ly9Q==
X-Gm-Message-State: APjAAAU/nHkqzGd3+gXXPWslNBq5DogCK8B/+BgOarJLzwmal4gWQ0kw
        KHDNxwLFWqnOtU53ngTftNU=
X-Google-Smtp-Source: APXvYqzIS5Ql9OSvCapX12ZA26wlw4RWfNnpgchMEH4A84CibU0GviPLsji5VuKlpeaYLnc/PtnIrQ==
X-Received: by 2002:a05:6808:2c3:: with SMTP id a3mr333060oid.121.1565827439381;
        Wed, 14 Aug 2019 17:03:59 -0700 (PDT)
Received: from localhost.members.linode.com ([2600:3c00::f03c:91ff:fe99:7fe5])
        by smtp.gmail.com with ESMTPSA id k24sm455013oic.29.2019.08.14.17.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 17:03:58 -0700 (PDT)
From:   Anton Protopopov <a.s.protopopov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Anton Protopopov <a.s.protopopov@gmail.com>
Subject: [PATCH bpf-next] tools: libbpf: update extended attributes version of bpf_object__open()
Date:   Thu, 15 Aug 2019 00:03:30 +0000
Message-Id: <20190815000330.12044-1-a.s.protopopov@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the bpf_object_open_attr structure and corresponding code so that the
bpf_object__open_xattr function could be used to open objects from buffers as
well as from files.  The reason for this change is that the existing
bpf_object__open_buffer function doesn't provide a way to specify neither the
needs_kver nor flags parameters to the internal call to __bpf_object__open
which makes it inconvenient for loading BPF objects which doesn't require a
kernel version.

Two new fields, obj_buf and obj_buf_sz, were added to the structure, and the
file field was union'ed with obj_name so that one can open an object like this:

    struct bpf_object_open_attr attr = {
        .obj_name   = name,
        .obj_buf    = obj_buf,
        .obj_buf_sz = obj_buf_sz,
        .prog_type  = BPF_PROG_TYPE_UNSPEC,
    };
    return bpf_object__open_xattr(&attr);

while still being able to use the file semantics:

    struct bpf_object_open_attr attr = {
        .file       = path,
        .prog_type  = BPF_PROG_TYPE_UNSPEC,
    };
    return bpf_object__open_xattr(&attr);

Another thing to note is that since the commit c034a177d3c8 ("bpf: bpftool, add
flag to allow non-compat map definitions") which introduced a MAPS_RELAX_COMPAT
flag to load objects with non-compat map definitions, bpf_object__open_buffer
was called with this flag enabled (it was passed as the boolean true value in
flags argument to __bpf_object__open).  The default behaviour for all open
functions is to clear this flag and this patch changes bpf_object__open_buffer
to clears this flag.  It can be enabled, if needed, by opening an object from
buffer using __bpf_object__open_xattr.

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
---
 tools/lib/bpf/libbpf.c | 45 ++++++++++++++++++++++++++----------------
 tools/lib/bpf/libbpf.h |  7 ++++++-
 2 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2233f919dd88..7c8054afd901 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3630,13 +3630,31 @@ __bpf_object__open(const char *path, void *obj_buf, size_t obj_buf_sz,
 struct bpf_object *__bpf_object__open_xattr(struct bpf_object_open_attr *attr,
 					    int flags)
 {
+	char tmp_name[64];
+
 	/* param validation */
-	if (!attr->file)
+	if (!attr)
 		return NULL;
 
-	pr_debug("loading %s\n", attr->file);
+	if (attr->obj_buf) {
+		if (attr->obj_buf_sz <= 0)
+			return NULL;
+		if (!attr->file) {
+			snprintf(tmp_name, sizeof(tmp_name), "%lx-%lx",
+				 (unsigned long)attr->obj_buf,
+				 (unsigned long)attr->obj_buf_sz);
+			attr->obj_name = tmp_name;
+		}
+		pr_debug("loading object '%s' from buffer\n", attr->obj_name);
+	} else if (!attr->file) {
+		return NULL;
+	} else {
+		attr->obj_buf_sz = 0;
 
-	return __bpf_object__open(attr->file, NULL, 0,
+		pr_debug("loading object file '%s'\n", attr->file);
+	}
+
+	return __bpf_object__open(attr->file, attr->obj_buf, attr->obj_buf_sz,
 				  bpf_prog_type__needs_kver(attr->prog_type),
 				  flags);
 }
@@ -3660,21 +3678,14 @@ struct bpf_object *bpf_object__open_buffer(void *obj_buf,
 					   size_t obj_buf_sz,
 					   const char *name)
 {
-	char tmp_name[64];
-
-	/* param validation */
-	if (!obj_buf || obj_buf_sz <= 0)
-		return NULL;
-
-	if (!name) {
-		snprintf(tmp_name, sizeof(tmp_name), "%lx-%lx",
-			 (unsigned long)obj_buf,
-			 (unsigned long)obj_buf_sz);
-		name = tmp_name;
-	}
-	pr_debug("loading object '%s' from buffer\n", name);
+	struct bpf_object_open_attr attr = {
+		.obj_name	= name,
+		.obj_buf	= obj_buf,
+		.obj_buf_sz	= obj_buf_sz,
+		.prog_type	= BPF_PROG_TYPE_UNSPEC,
+	};
 
-	return __bpf_object__open(name, obj_buf, obj_buf_sz, true, true);
+	return bpf_object__open_xattr(&attr);
 }
 
 int bpf_object__unload(struct bpf_object *obj)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index e8f70977d137..634f278578dd 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -63,8 +63,13 @@ LIBBPF_API libbpf_print_fn_t libbpf_set_print(libbpf_print_fn_t fn);
 struct bpf_object;
 
 struct bpf_object_open_attr {
-	const char *file;
+	union {
+		const char *file;
+		const char *obj_name;
+	};
 	enum bpf_prog_type prog_type;
+	void *obj_buf;
+	size_t obj_buf_sz;
 };
 
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
-- 
2.19.1

