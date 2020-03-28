Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 742E819686A
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 19:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgC1S3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 14:29:03 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:51252 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726937AbgC1S3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 14:29:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585420142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O1TasnobZysGj1AsegupcFxLIotb9pYqfJEh44oqQH0=;
        b=CoOfPwsLTF/U8CsaoDAKv5jcIDYFgC/3SzVdXxivs63k7iQh7hBAcTRs4XHzyFaRBOurin
        vqD8NLzRYDe1S8sWfhDltkbTofO670KvmEII/WyHtnyQ25+buXWdFP4LwLz/Mg7z0kvbEz
        wEMV1OdWUMaiH2g7NSJc+sYb7BaJCng=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-0Ufu7oy_NlmEvoIqtU3c0A-1; Sat, 28 Mar 2020 14:29:00 -0400
X-MC-Unique: 0Ufu7oy_NlmEvoIqtU3c0A-1
Received: by mail-lf1-f72.google.com with SMTP id b25so5408041lfi.21
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 11:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O1TasnobZysGj1AsegupcFxLIotb9pYqfJEh44oqQH0=;
        b=cP1hCYcC88LckGaKpYdAjBRghlZfWQX58NwSXaYotVccy0l/djyBoEskxil4pppEvX
         Ls89ec5ontbyYIPHqAVF1cYIEVPdGNQXcdGQ0Pyo9Ud/EYWXQ8KFzclL0DOAP26BTLaN
         dcshS7cHiey736jW3KFSHWzhJLcC9/luoMpLo8n2m7Ks1pdSJfdDDkUQrbcdFvpbP9ib
         0nt8a2MdhDcokLKzliS5kDVMFeeEuwoMqnB0XLX8KLYPTsjTYYo2jHdcXvd/gTAeI16P
         xwal0+WK2LtNNxH88sbIgXv39jcnuzdbyD0MHbNZO4XxYfN8efP7Ar89KMasGt65WqxQ
         ctgQ==
X-Gm-Message-State: AGi0PubFJ40lXQ4ZmvxtAQ2Ce5CnhlWVZAqTW2mBmDCSN/Z2RoIpV8xS
        /LebP+gIU81fUORS2UEu3AWjnEXuhL0gjYGmxzLgL2pQ57Mie/MNUAq6e6xIfLplsY41OA28+MD
        TSm/q8YIRZcWYLLJY
X-Received: by 2002:a05:651c:3cf:: with SMTP id f15mr2718959ljp.184.1585420138633;
        Sat, 28 Mar 2020 11:28:58 -0700 (PDT)
X-Google-Smtp-Source: APiQypLHemQGe8LrMZLmWFOUAnSME0fLHHctBC7ZI9YxnkOch5W8BiLdIxjlCMFW9+foOBuJLm6uBg==
X-Received: by 2002:a05:651c:3cf:: with SMTP id f15mr2718948ljp.184.1585420138357;
        Sat, 28 Mar 2020 11:28:58 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f6sm1306932lfm.40.2020.03.28.11.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 11:28:57 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9409C18158B; Sat, 28 Mar 2020 19:28:54 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH v3 1/2] libbpf: Add setter for initial value for internal maps
Date:   Sat, 28 Mar 2020 19:28:33 +0100
Message-Id: <20200328182834.196578-1-toke@redhat.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200327125818.155522-1-toke@redhat.com>
References: <20200327125818.155522-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For internal maps (most notably the maps backing global variables), libbpf
uses an internal mmaped area to store the data after opening the object.
This data is subsequently copied into the kernel map when the object is
loaded.

This adds a function to set a new value for that data, which can be used to
before it is loaded into the kernel. This is especially relevant for RODATA
maps, since those are frozen on load.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
v3:
  - Add a setter for the initial value instead of a getter for the pointer to it
  - Add selftest
v2:
  - Add per-map getter for data area instead of a global rodata getter for bpf_obj

 tools/lib/bpf/libbpf.c   | 11 +++++++++++
 tools/lib/bpf/libbpf.h   |  2 ++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 14 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 085e41f9b68e..f9953a8ffcfa 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6756,6 +6756,17 @@ void *bpf_map__priv(const struct bpf_map *map)
 	return map ? map->priv : ERR_PTR(-EINVAL);
 }
 
+int bpf_map__set_initial_value(struct bpf_map *map,
+			       void *data, size_t size)
+{
+	if (!map->mmaped || map->libbpf_type == LIBBPF_MAP_KCONFIG ||
+	    size != map->def.value_size)
+		return -EINVAL;
+
+	memcpy(map->mmaped, data, size);
+	return 0;
+}
+
 bool bpf_map__is_offload_neutral(const struct bpf_map *map)
 {
 	return map->def.type == BPF_MAP_TYPE_PERF_EVENT_ARRAY;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index d38d7a629417..ee30ed487221 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -407,6 +407,8 @@ typedef void (*bpf_map_clear_priv_t)(struct bpf_map *, void *);
 LIBBPF_API int bpf_map__set_priv(struct bpf_map *map, void *priv,
 				 bpf_map_clear_priv_t clear_priv);
 LIBBPF_API void *bpf_map__priv(const struct bpf_map *map);
+LIBBPF_API int bpf_map__set_initial_value(struct bpf_map *map,
+					  void *data, size_t size);
 LIBBPF_API int bpf_map__reuse_fd(struct bpf_map *map, int fd);
 LIBBPF_API int bpf_map__resize(struct bpf_map *map, __u32 max_entries);
 LIBBPF_API bool bpf_map__is_offload_neutral(const struct bpf_map *map);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 5129283c0284..f46873b9fe5e 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -243,5 +243,6 @@ LIBBPF_0.0.8 {
 		bpf_link__pin;
 		bpf_link__pin_path;
 		bpf_link__unpin;
+		bpf_map__set_initial_value;
 		bpf_program__set_attach_target;
 } LIBBPF_0.0.7;
-- 
2.26.0

